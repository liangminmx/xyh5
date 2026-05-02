
-- 土豪福利

-- 土豪福利，取得玩家信息的转换
local RichWelfare_Type = RichWelfare_Instance_GetTypeData()
local tRichWelfare_ToChaInt = RichWelfare_Instance_GetType_ToChaInt()

local nOpenLevel = _richwelfare_Info['root'][1]['mail'][1]['lv']
local nMailId = _richwelfare_Info['root'][1]['mail'][1]['mailid']
local tRichWelfare_Info = _richwelfare_Info['root'][1]['server']

local nResId = CRESOURCEFLOWACTION.eFT_RichWelfare
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

local tRichWelfareMsg_Type = {
    TRF_Open = 1,   -- 开启功能
    TRF_Info = 2,   -- 申请活动信息    
}

-- Note:
--  data1           本日活动的开启状态，0关闭，非0开(其实就是对应活动按照位的开启状态)
--  data2           预留，按照位置存取，玩家参加了活动没（未使用）
--  data3           玩家开启活动功能的时候，是开服第几天，结算的时候就根据这个天数发奖
--  dataStr 'x,x,x' 与主题类型一一对应的，奖励的结算状态(0/1)，已经结算过的就不会在结算了

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
function RichWelfare_OnLogin(_idCharacter,_nOsTimes)
    
    -- 触发全服 instance 登入
    RichWelfare_Instance_OnLogin(_nOsTimes)

    -- 创建玩家数据库记录
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        System_AddTempData(_idCharacter,nLuaIdActivity)
        local strInit = ''
        local nTypeNum = RichWelfare_Instance_GetTypeInfo()
        for i = 1,(nTypeNum),1 do  -- type 在 instance 中定义
            if  '' == strInit then
                strInit = '0'
            else
                strInit = strInit..','..'0'
            end
        end
        System_SetTempDataStr(_idCharacter,nLuaIdActivity,strInit,false)
    end

    -- 判断玩家活动开启状态
    RichWelfare_OpenActive(_idCharacter)
 
    -- 进行一次奖励结算
    RichWelfare_Deal(_idCharacter)

    -- 同步一次活动信息
    RichWelfare_Syn_Status(_idCharacter)

    -- 同步第三排信息
    RichWelfare_IconShow(_idCharacter,_nOsTimes)
end
table.insert(tOnLoginActivity,RichWelfare_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RichWelfare_ZeroRefresh(_idCharacter,_nOsTimes)    
    RichWelfare_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,RichWelfare_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  等级变更开启功能
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function RichWelfare_LevelUp(_idCharacter,_nOld,_nNew)
    if  _nOld < nOpenLevel and _nNew >= nOpenLevel  then
        RichWelfare_OpenActive(_idCharacter)-- 判断活动开启
        RichWelfare_Syn_Status(_idCharacter)-- 同步一次信息
        RichWelfare_IconShow(_idCharacter)  -- 同步第三排图标显示信息
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家完成某一活动的接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
function RichWelfare_Complete(_idCharacter,_nCActionTriggerType,_nOldLevel,_nNewLevel,_nData5)
        
    if  _nCActionTriggerType == eActionTriggerType.eATT_Horse_Steplev then  -- 坐骑
        RichWelfare_Improve(_idCharacter,RichWelfare_Type.RWT_Mounts,_nNewLevel)
        
    elseif  _nCActionTriggerType == eActionTriggerType.eATT_LegendaryWeapon then -- 神兵
        RichWelfare_Improve(_idCharacter,RichWelfare_Type.RWT_Weapon,_nNewLevel)
        
    elseif  _nCActionTriggerType == eActionTriggerType.eATT_Wing_Realm then -- 羽翼
        RichWelfare_Improve(_idCharacter,RichWelfare_Type.RWT_Wing,_nNewLevel)
        
    elseif  _nCActionTriggerType == eActionTriggerType.eATT_Heaven_Level then -- 法宝
        RichWelfare_Improve(_idCharacter,RichWelfare_Type.RWT_Treasure,_nNewLevel)
        
    elseif  _nCActionTriggerType == eActionTriggerType.eATT_Poncho_Level then -- 披风
        RichWelfare_Improve(_idCharacter,RichWelfare_Type.RWT_Cloak,_nNewLevel)
        
    elseif  _nCActionTriggerType == eActionTriggerType.eATT_Matrix_Level then -- 法证
        RichWelfare_Improve(_idCharacter,RichWelfare_Type.RWT_Circle,_nNewLevel)
        
    end    
end
-- 插入到活动触发表中
table.insert(tOnCompleteThings,RichWelfare_Complete)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  客户端协议入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
function RichWelfare_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
    if  (nil == _idCharacter) or (nResId ~= _nCActionType) or (nil == _nData3) or (nil == _nData4) or (nil == _nData5) then
        L2C_DebugLog("::RichWelfare_Req error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nData3 or "nil").."|"..(_nData4 or "nil").."|"..(_nData5 or "nil")..")")
        return eKaFuChouJiang_RetCode.eKFCJ_Null
    end
    
    if  _nData3 == tRichWelfareMsg_Type.TRF_Open then            
        RichWelfare_OpenActive(_idCharacter)-- 触发一次玩家状态刷新
        RichWelfare_Syn_Open(_idCharacter)  -- 开功能返回包
        RichWelfare_Syn_Status(_idCharacter)-- 同步一次信息
        RichWelfare_IconShow(_idCharacter)  -- 同步第三排图标显示信息
        return 1

    elseif   _nData3 == tRichWelfareMsg_Type.TRF_Info then
        RichWelfare_Syn_Status(_idCharacter)
        return 1

    else
        L2C_DebugLog('::RichWelfare_Req get error req type:'..tostring(_nData3))
    end
    return 0
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = RichWelfare_Req

-- ===============================================================================================================
--  收到玩家升级功能的
--  @_nType     主题日活动的type
--  @_nLevel    升级后的等级
-- ===============================================================================================================
function RichWelfare_Improve(_idCharacter,_nType,_nLevel)
    RichWelfare_Instance_Improve(_idCharacter,_nType,_nLevel)
end

-- ===============================================================================================================
--  玩家是否能开启功能了
-- ===============================================================================================================
function RichWelfare_OpenActive(_idCharacter)
    
    -- 根据等级判断玩家能不能开启功能
    local nMyLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
    if  nMyLevel >= nOpenLevel then         
        local nTodayStatus = RichWelfare_Instance_TodayStatus()
        System_SetTempData(_idCharacter,nLuaIdActivity,1,nTodayStatus,false)

        -- 如果是刚开活动，记录下本日开服天数，用于奖励结算
        if  0 == System_GetTempData(_idCharacter,nLuaIdActivity,3) then
            local nOpenServerDay = System_GetOpenServerDay()
            System_SetTempData(_idCharacter,nLuaIdActivity,3,nOpenServerDay,false)
        end
    else
        if  0 ~= System_GetTempData(_idCharacter,nLuaIdActivity,1) then
            System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)    
        end
    end
end

-- ===============================================================================================================
--  每日结算(结算触发只与开服天数有关，结算奖励获得要看玩家开启该活动的时间)
-- ===============================================================================================================
function RichWelfare_Deal(_idCharacter)
    
    local nServerKey = RichWelfare_Instance_GetServerKey()
    if  nil == nServerKey then -- 本服没有活动!   
        return
    end
    local tWelfareData = tRichWelfare_Info[nServerKey]['wealth']
    
    -- 遍历开启过的活动，看有没有活动结束了要结算
    local tMaxLevel = RichWelfare_Instance_ReadRecord() -- 服务器最高等级信息
    local nPersonOpenActiveDay = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    local nOpenServerDay = System_GetOpenServerDay()
    local tRewardStatus = RichWelfare_ReadRewardStatus(_idCharacter)

    for k,v in pairs(tWelfareData) do
        local nType = v['activity']
        local nOpenDay = v['day']
        local nContinueDay = v['continueday']    
            
        if  nOpenServerDay >= (nOpenDay + nContinueDay) and -- 活动已经结束
            nPersonOpenActiveDay <= nOpenDay then           -- 玩家开启活动的时间可以参与这个活动

            if  0 == tRewardStatus[nType] then  -- 奖励未领取(该玩家为结算过这个活动)                         
                    -- 取得最高等级和玩家等级
                    local nServerMaxLeve = tMaxLevel[nType]
                    local nMyLevel = System_GetAttrInt(_idCharacter,tRichWelfare_ToChaInt[nType])  
                                      
                    -- 取得可以发奖励的最高等级
                    local nMaxLevelSign = 0
                    local nRewardKey = nil
                    for k_son,v_son in pairs(v['itemcharacter']) do                    
                        local nNeedLeve = v_son['mylev']
                        local nNeedMax = v_son['serverlev']
                        
                        if  nServerMaxLeve >= nNeedMax and nMyLevel >= nNeedLeve then
                            if  nNeedMax > nMaxLevelSign then
                                nMaxLevelSign = nNeedMax 
                                nRewardKey = k_son
                            end
                        end                   
                    end
                    -- 有奖励可以发放
                    if  nil ~= nRewardKey then                        
                        -- 发放邮件                        
                        RichWelfare_SendMail(_idCharacter,v['itemcharacter'][nRewardKey])
                        -- 写经分
                        RichWelfare_Log(_idCharacter,nType,v['itemcharacter'][nRewardKey]['id'])
                    end

                    -- 奖励状态设置为已领取
                    tRewardStatus[nType] = 1
            end
        end
    end

    -- 重新保存玩家领取状态
    RichWelfare_WriteRewardStatus(_idCharacter,tRewardStatus)
end

-- ===============================================================================================================
--  发放邮件奖励
--  @_tRewardData 'itemcharacter'字段下的某一奖励信息
-- ===============================================================================================================
function RichWelfare_SendMail(_idCharacter,_tRewardData)
    local strMail = ''
    if  'table' == type(_tRewardData) then
        for k,v in pairs(_tRewardData['reward']) do
            local nItem = v['item']
            local nNum = v['itemnum']
            strMail = strMail .. tostring(nItem) .. ',' .. tostring(nNum) .. ',' ..'0;' 
        end
    end

    -- L2C_DebugLog('::RichWelfare_SendMail send mail '..strMail)
    System_SendMail(_idCharacter,nMailId,strMail)
end

-- ===============================================================================================================
--  同步第三排信息
-- ===============================================================================================================
function RichWelfare_IconShow(_idCharacter,_nOsTimes)
    _nOsTimes = _nOsTimes or os.time()

    -- 玩家未开启活动，不显示
    if  0 == System_GetTempData(_idCharacter,nLuaIdActivity,1) then             
        System_SendActiveStatus(_idCharacter,nResId,0,0,0)
        return
    end

    -- 活动结束，不显示
    local nOpenServerDay = System_GetOpenServerDay()
    local nEndDay = RichWelfare_Instance_GetLastDay()
    if  nOpenServerDay > nEndDay then          
        System_SendActiveStatus(_idCharacter,nResId,0,0,0)        
        return
    end
     
    -- 显示    
    local nEndTime = System_GetZeroTime(_nOsTimes) + (nEndDay - nOpenServerDay)*24*60*60
    System_SendActiveStatus(_idCharacter,nResId,1,0,nEndTime)
end

-- ===============================================================================================================
--  获取玩家奖励领取状态
-- ===============================================================================================================
function RichWelfare_ReadRewardStatus(_idCharacter)
    local str = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
    local tRet = System_Split(str,',')
    for k,v in pairs(tRet) do
       tRet[k] = tonumber(v) 
    end
    return tRet
end

-- ===============================================================================================================
--  写玩家奖励领取状态
-- ===============================================================================================================
function  RichWelfare_WriteRewardStatus(_idCharacter,_t)
    local str = ''
    for k,v in ipairs(_t) do
        if  '' == str then
            str = tostring(v)
        else
            str = str..','..tostring(v)
        end
    end
    System_SetTempDataStr(_idCharacter,nLuaIdActivity,str,false)
end

-- ===============================================================================================================
--  同步开启活动返回值
-- ===============================================================================================================
function RichWelfare_Syn_Open(_idCharacter)     
    -- uCode 默认都是开启功能成功
    -- L2C_DebugLog('::RichWelfare_Syn_Open code:1')
    System_RichWelfare_Open_Syn(_idCharacter,1)
end

-- ===============================================================================================================
--  同步活动状态
-- ===============================================================================================================
function RichWelfare_Syn_Status(_idCharacter) 
    local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    local strMaxLevel = RichWelfare_Instance_ReadRecord_Str()
    
    -- L2C_DebugLog('::RichWelfare_Syn_Status nStatus:'..nStatus..',strMaxLevel:'..strMaxLevel)
    System_RichWelfare_Info_Syn(_idCharacter,nStatus,strMaxLevel)
end

-- ===============================================================================================================
--  写经分数据
-- ===============================================================================================================
function RichWelfare_Log(_idCharacter,_nActiveType,_nLevelId)    
    -- L2C_DebugLog('::RichWelfare_Log ('.._idCharacter..','.._nActiveType..','.._nLevelId..')')
    System_RichWelfare_Log(_idCharacter,_nActiveType,_nLevelId)
end