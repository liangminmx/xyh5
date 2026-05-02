
local nResId = CRESOURCEFLOWACTION.eFT_jjGift
local JjGift_Info = _jjgift_Info["root"][1]["open"]

-- ////////////////////////// 奖励的回码
 eJJGift_RetCode = {
	eRC_Success = 0,				-- 成功
	eRC_Null = 1,					-- 未知错误    
    eRC_NotLevel = 2,               -- 发奖等级不够！
}

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  领取指定奖励
--  @_nType 要领取的奖励的type
--  @_nIndex 要领取的这个type下的哪一个奖励
--  @_nAchieve 当前达到的等级
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function jjGift_GetReward(_idCharacter,_nCActionType,_nType,_nIndex,_nAchieve)    
    
    if  (nil == _idCharacter) or (nil == _nCActionType) or (nil == _nType) or (nil == _nIndex) or (nil == _nAchieve) then
        L2C_DebugLog("::jjGift_GetReward error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nType or "nil").."|"..(_nIndex or "nil").."|"..(_nAchieve or "nil")")")
        return eJJGift_RetCode.eRC_Null
    end

    if  _nCActionType ~= nResId then
        L2C_DebugLog("::jjGift_GetReward error id:" .. _nCActionType)
        return eJJGift_RetCode.eRC_Null
    end

    local nDetailResId = jjGift_GetResID(_nType)
    if  nil == nDetailResId then
        L2C_DebugLog("::jjGift_GetReward error type:" .. _nType)
        return eJJGift_RetCode.eRC_Null
    end

    local nServerKey = jjGift_GetServerKey()
    if  nil == nServerKey then
        L2C_DebugLog("::jjGift_GetReward gei nil server key")
        return eJJGift_RetCode.eRC_Null
    end

    local nTypeKey = jjGift_GetTypeKey(nServerKey,_nType)
    if  nil == nTypeKey then
        L2C_DebugLog("::jjGift_GetReward error server key:" .. nServerKey .. " ,type:" .. _nType)
        return eJJGift_RetCode.eRC_Null
    end

    local nIndexKey = jjGift_GetIndexKey(nServerKey,nTypeKey,_nIndex)
    if  nil == nIndexKey then
        L2C_DebugLog("::jjGift_GetReward error server key:" .. nServerKey .. " ,type key:"..nTypeKey.." ,_nIndex:".._nIndex)
        return eJJGift_RetCode.eRC_Null
    end

    if  "table" ~= type(JjGift_Info[nServerKey]["gifttype"][nTypeKey]["needlv"][nIndexKey]) then
        L2C_DebugLog("::jjGift_GetReward error server key:"..nServerKey.." ,type key:"..nTypeKey.." ,index key:"..nIndexKey)
        return eJJGift_RetCode.eRC_Null 
    else
        local tRewardData = JjGift_Info[nServerKey]["gifttype"][nTypeKey]["needlv"][nIndexKey]  -- 要领取的奖励
        if  _nAchieve < tRewardData["lv"] then
            -- 等级不够，不能领取！
            return eJJGift_RetCode.eRC_NotLevel
        end
        -- 发放奖励            
        jjGift_SendReward(_idCharacter,nServerKey,nTypeKey,nIndexKey,nDetailResId)
        return eJJGift_RetCode.eRC_Success
    end
end
tOnOnAcitveAward[nResId] = jjGift_GetReward



-- ===============================================================================================================
--  根据合服次数获得在 数据 在表中的位置(返回nil 就是活动不开)
-- ===============================================================================================================
function jjGift_GetServerKey(_nCombinedTimes)
    _nCombinedTimes = _nCombinedTimes or System_GetCombinedTimes()
    
    local nDefaultTimes = -1
    local nDefaultKey = nil

    for k,v in pairs(JjGift_Info) do
        if  _nCombinedTimes == v["servernum"] then
            return k
        end
        if  nDefaultTimes == v["servernum"] then
            nDefaultKey = k
        end
    end
    return nDefaultKey
end

-- ===============================================================================================================
--  取得要领取的 index 在数据table中的 key(nil)
-- ===============================================================================================================
function jjGift_GetIndexKey(_nServerKey,_nTypeKey,_nIndex)    
    local tDetailData = JjGift_Info[_nServerKey]["gifttype"][_nTypeKey]["needlv"]
    for k,v in pairs(tDetailData) do
        if  v["lv"] == _nIndex then
            return k
        end
    end
end

-- ===============================================================================================================
--  取得要领取的type的key
-- ===============================================================================================================
function jjGift_GetTypeKey(_nServerKey,_nType)

    local tData = JjGift_Info[_nServerKey]["gifttype"]
    for k,v in pairs(tData) do
        if  _nType == v["type"] then
            return k
        end
    end
end

-- ===============================================================================================================
--  根据奖励的种类，获得指定资源流向
--  type	开启活动的类型
--  = 1神兵 432
--  = 2羽翼 427
--  = 3坐骑 426
--  = 4法宝 428
--  = 5披风 444
--  = 6法阵 449
-- ===============================================================================================================
function jjGift_GetResID(_nType)
    if  1 == _nType then
        return CRESOURCEFLOWACTION.eFT_jjGift_Weapon
    elseif  2 == _nType then
        return CRESOURCEFLOWACTION.eFT_jjGift_Wing
    elseif  3 == _nType then
        return CRESOURCEFLOWACTION.eFT_jjGift_Mounts
    elseif  4 == _nType then
        return CRESOURCEFLOWACTION.eFT_jjGift_Treasure
    elseif  5 == _nType then
        return CRESOURCEFLOWACTION.eFT_jjGift_Cloak
    elseif  6 == _nType then
        return CRESOURCEFLOWACTION.eFT_jjGift_Circle
    else
        L2C_DebugLog("::jjGift_GetResID get a error type:"..tostring(_nType))
    end
end

-- ===============================================================================================================
--  发放奖励
--  @_nDatailResID 这个奖励的资源流向
-- ===============================================================================================================
function jjGift_SendReward(_idCharacter,_nServerKey,_nTypeKey,_nIndexKey,_nDatailResID)

    if  "table" ~= type(JjGift_Info[_nServerKey]["gifttype"][_nTypeKey]["needlv"][_nIndexKey]) then        
        L2C_DebugLog("::jjGift_SendReward error server key:".._nServerKey.." ,type key:".._nTypeKey.." ,index key:".._nIndexKey)
        return 
    end 
    
    local tRewardData = JjGift_Info[_nServerKey]["gifttype"][_nTypeKey]["needlv"][_nIndexKey]
    -- if  "number" == type(tRewardData["money"]) and tRewardData["money"] > 0 then
        -- System_AwardMoney(_idCharacter, tRewardData["money"] ,_nDatailResID)
    -- end
    -- if  "number" == type(tRewardData["emoney"]) and tRewardData["emoney"] > 0 then
        -- System_AwardEmoney(_idCharacter, tRewardData["emoney"], _nDatailResID)
    -- end
    -- if  "number" == type(tRewardData["exp"]) and tRewardData["exp"] > 0 then
        -- System_AwardExp(_idCharacter, tRewardData["exp"], _nDatailResID)
    -- end


    if  "table" == type(tRewardData["reward"]) then        
        -- 判断背包能不能放得下        
        if  false == jjGift_BagEnough(_idCharacter,tRewardData["reward"]) then
            -- 发邮件            
            local sItem = ""    -- _sItem格式 "item,num,stage;item2,num2,stage2;"
            for k,v in pairs(tRewardData["reward"]) do
                local nItemId = v["item"]
                local nNum = v["num"]
                local nStage = v["stage"] or 0
                sItem = sItem .. tostring(nItemId)..","..tostring(nNum)..","..tostring(nStage)..";"
            end
            local nMailId = JjGift_Info[_nServerKey]["mailid"]
            System_SendMail(_idCharacter,nMailId,sItem)
        else
            -- 直接发奖            
            for k,v in pairs(tRewardData["reward"]) do                
                local nItemId = v["item"]
                local nNum = v["num"]
                System_AwardThingInBag(_idCharacter,_nDatailResID,nItemId,nNum)
            end
        end
    end
end

-- ===============================================================================================================
--  判断背包能不能放得下
-- ===============================================================================================================
function jjGift_BagEnough(_idCharacter,_tData)   
   local strItem = ""   -- item,num;item2,num2;
   for  k,v in pairs(_tData) do
        strItem = strItem .. tostring(v["item"]) .. ","..tostring(v["num"]) .. ";"   
   end
   return System_CanPushThingsToBagEx(_idCharacter,strItem)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  c++要求lua发送活动状态给客户端
--      原因是策划需求同一天可配置多个活动，并随机其中一个
--      约定，_nType = 0 的时候，全部发送活动结束的status
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function jjGift_SendActiveStatus(_idCharacter,_nCActionType,_nOsTimes,_nType,_nData5)
    _nOsTimes = _nOsTimes or os.time()
    _nType = _nType or 0

    if  _nCActionType ~= nResId then
        return 0
    end

    local nServerKey = jjGift_GetServerKey()
    local tmpType = JjGift_Info[nServerKey]["gifttype"]
    
    local nTodayBegin = System_GetZeroTime(_nOsTimes)   -- 活动都只在今天持续
    local nTodayEnd = nTodayBegin + 24 * 3600

    for k,v in pairs(tmpType) do

        local type_res_id = jjGift_GetResID(v["type"])
        if  nil == type_res_id then
            L2C_DebugLog("::jjGift_SendActiveStatus get nil res_id, type is:" .. v["type"])
        end

        if  v["type"] == _nType then
            System_SendActiveStatus(_idCharacter,type_res_id,1,0,nTodayEnd);
        else
            System_SendActiveStatus(_idCharacter,type_res_id,0,0,0);
        end
    end
    return 1
end
tGetActivityData[nResId] = jjGift_SendActiveStatus