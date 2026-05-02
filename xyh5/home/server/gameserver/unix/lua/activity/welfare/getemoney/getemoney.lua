local nResId_Active = CRESOURCEFLOWACTION.eFT_GeteMoeny_Active
local nLuaIdActivity_Active = LUARESOURCEFLOWACTION[nResId_Active]

local nResId_OnLine = CRESOURCEFLOWACTION.eFT_GeteMoeny_OnLine
local nLuaIdActivity_OnLine = LUARESOURCEFLOWACTION[nResId_OnLine]

local nResId_Kill = CRESOURCEFLOWACTION.eFT_GeteMoeny_Boss
local nLuaIdActivity_Kill = LUARESOURCEFLOWACTION[nResId_Kill]

local nResId = CRESOURCEFLOWACTION.eFT_GeteMoeny
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

local nFunctionId = _getemoney_Info["root"][1]["functionid"][1]["functionid"]

-- ////////////////////////// 领取 奖励的回码
 eGetEmoney_RetCode = {
	eRC_Success = 1,				-- 成功
	eRC_Null = 2,					-- 未知错误
    eRC_FonctionNoOpen = 3,         -- 该功能未开启
    eRC_ErrorIndex = 4,             -- 要领取的天数index不存在！     
    eRC_HadGet = 5,                 -- 已经领取过了
    eRC_NotDouble = 6,              -- 本日没有充值，不能领取双倍
}

-- ////////////////////////// action触发的子类型
eGetEmoney_Action = {
    eGA_Active = 1, -- 活跃度
    eGA_OnLine = 2, -- 在线时长
    eGA_Kill = 3,   -- 参与龙山巡守卫
}

-- ////////////////////////// 从领奖接口进来的类型
eGetEmoneyReqType = {
	eGELT_SynReq = 1,           -- 客户端同步所有信息
	eGELT_RewardReq = 2,        -- 领取奖励
	eGELT_SynProcessReq = 3,    -- 同步指定信息
}

-- Note:
--      data1：今天是开服第几天
--      data2：今天积累的元宝(由子活动结算得到)
--      data3：今天是否首充了
--      data4：根据开放活动的天数，按照位存储，存储的某一天的领取状态
--      data6：合服次数
--      data7,data8：所有开的活动的总的开放和结束(左边闭合右边不闭合 "[)")
--      dataStr：活动期限内，每一天的可以得到的元宝的记录("0|0|0")(有记录多余，字符串是有 从 1 ~ overDay 个记录的)(一定会包含所以子活动的开服时间)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_OnLogin(_idCharacter,_nOsTimes)
    
    local nOpenServerDay = System_GetOpenServerDay()

    -- 子活动要在总活动前调用到！
    GetEMoney_Active_OnLogin(_idCharacter,_nOsTimes,nOpenServerDay)
    GetEMoney_OnLine_OnLogin(_idCharacter,_nOsTimes,nOpenServerDay)
    GetEMoney_Kill_OnLogin(_idCharacter,_nOsTimes,nOpenServerDay)

    GetEMoney_Create(_idCharacter,nOpenServerDay)
    GetEMoney_Reset(_idCharacter,nOpenServerDay)

    GetEMoney_Syn(_idCharacter)

    -- 同步第三排数据
    GetEMoney_SendRewardStatus(_idCharacter,_nOsTimes)
end
table.insert(tOnLoginActivity,GetEMoney_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_ZeroRefresh(_idCharacter,_nOsTimes)
    GetEMoney_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,GetEMoney_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家升级的触发
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_LevelUp(_idCharacter,_old,_new)
    GetEMoney_SendRewardStatus(_idCharacter)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  触发该活动的事件（玩家分数增加）
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_ActionTrigeer(_idCharacter,_nCActionTriggerType,_nSonType,_nData4,_nData5)

    if  _nCActionTriggerType == eActionTriggerType.eATT_GetEmoney then           
        local nOpenServerDay = System_GetOpenServerDay()
        local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity,7)
        local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity,8)

        if  nOpenDay <= nOpenServerDay and nOpenServerDay <=  nOverDay then                             
            if  eGetEmoney_Action.eGA_Active == _nSonType then
                -- _nData4 是活跃度的增加量
                -- L2C_DebugLog("::GetEMoney_ActionTrigeer (".._idCharacter..")".._nSonType..",".._nData4)
                GetEMoney_Active_AddScore(_idCharacter,nOpenServerDay,_nData4)

            elseif  eGetEmoney_Action.eGA_OnLine == _nSonType then
                -- _nData4 是 当前时间 （1分钟会触发一次）
                -- _nData5 是触发的间隔时间 
                -- L2C_DebugLog("::GetEMoney_ActionTrigeer (".._idCharacter..")".._nData4..",".._nData5)
                GetEMoney_OnLine_AddScore(_idCharacter,nOpenServerDay,_nData4,_nData5)

            elseif  eGetEmoney_Action.eGA_Kill == _nSonType then
                -- 调用一次该接口，增加一个次数
                GetEMoney_Kill_AddScore(_idCharacter,nOpenServerDay)
            end
        end
    end
end
table.insert(tOnCompleteThings,GetEMoney_ActionTrigeer)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  从领奖接口进来的类型分支
--  @_nType 分支类型
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_Door(_idCharacter,_nCActionType,_nType,_nData4,_nData5)    
    if  _nCActionType ~= nResId then
        L2C_DebugLog("::GetEMoney_Door error CType is ".._nCActionType)
        return eGetEmoney_RetCode.eRC_Null
    end

    if  _nType == eGetEmoneyReqType.eGELT_SynReq then   
        
        GetEMoney_Syn(_idCharacter)
        return 0
                            
    elseif  _nType == eGetEmoneyReqType.eGELT_RewardReq then
        -- _nData4 就是要领取的奖励 id
        -- _nData5 是要不要领取双倍的标记
        return GetEMoney_GetRewardReq(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
        
    elseif  _nType == eGetEmoneyReqType.eGELT_SynProcessReq then        
        -- _nData4 就是要的指定的 type 进度
        GetEMoney_Syn_Type(_idCharacter,_nData4)
        return 0
    else
        L2C_DebugLog("::GetEMoney_Door error type:".._nType)
    end
end
tOnOnAcitveAward[nResId] = GetEMoney_Door

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  领取奖励接口
--  Note：有这个父活动区调用子活动的发奖，子活动自己也记录是否已经发奖的
--  @_nIndex        要领取的index 天数
--  @_nWantDouble   0 想领取单倍，1 想领取双倍
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_GetRewardReq(_idCharacter,_nCActionType,_nData3,_nIndex,_nWantDouble)
    if  (nil == _idCharacter) or (nil == _nCActionType) or (nil == _nIndex) or (nil == _nWantDouble) then
        L2C_DebugLog("::GetEMoney_GetRewardReq error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nIndex or "nil").."|"..(_nWantDouble or "nil")..")")
        return eGetEmoney_RetCode.eRC_Null
    end

    if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then
        return eGetEmoney_RetCode.eRC_FonctionNoOpen
    end

    -- 领取的id是否正确
    local nOpenServerDay = System_GetOpenServerDay()
    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity,8)
    if  _nIndex < nOpenDay or 
        _nIndex > nOverDay or
        _nIndex >= nOpenServerDay then  -- 今天的奖励明天才能领取
        return eGetEmoney_RetCode.eRC_ErrorIndex
    end

    -- 本日是否有充值过
    local nHadRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    if  0 == nHadRecharge and 1 == _nWantDouble then    -- 今天没充值却要领双倍
        return eGetEmoney_RetCode.eRC_NotDouble
    end

    -- 是否已领取
    local nGetSign = System_GetTempData(_idCharacter,nLuaIdActivity,4)     
    local bGet = WCBit.GetBit(nGetSign,_nIndex)
    if  true == bGet then
        return eGetEmoney_RetCode.eRC_HadGet
    end

    -- 设置已领奖标志    
    nGetSign = WCBit.SetTrue(nGetSign,_nIndex)    
    if  true == System_SetTempData(_idCharacter,nLuaIdActivity,4,nGetSign,false) then

        local nTotalSend = GetEMoney_SendReward(_idCharacter,_nIndex,_nWantDouble) -- 给奖励
        GetEMoney_Syn(_idCharacter) -- 给客户端同步信息
        GetEMoney_Log_Type(_idCharacter,nTotalSend) -- 经分
        
        GetEMoney_SendRewardStatus(_idCharacter)    -- 领奖之后触发一次推送第三排显示的信息

        return eGetEmoney_RetCode.eRC_Success
    else
        L2C_DebugLog("::GetEMoney_GetRewardReq error in set mask !!!")
        return eGetEmoney_RetCode.eRC_Null
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  本日充值了的接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetEMoney_ToDayRecharge(_idCharacter,_nEmoney,_nOsTimes)
    local nOpenServerDay = System_GetOpenServerDay()

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity,8)

    -- 就算活动结束了。。依然要记录本日充值状态
    --if  nOpenDay <= nOpenServerDay and nOpenServerDay <= nOverDay then
        
        if  0 == System_GetTempData(_idCharacter,nLuaIdActivity,3) then

            System_SetTempData(_idCharacter,nLuaIdActivity,3,1,false)    
            GetEMoney_Active_Recharge(_idCharacter,nOpenServerDay)  -- 活跃度
            GetEMoney_OnLine_Recharge(_idCharacter,nOpenServerDay)  -- 在线时长
            GetEMoney_Kill_Recharge(_idCharacter,nOpenServerDay)    -- 龙山巡守

            GetEMoney_Syn(_idCharacter) -- 充值之后，给客户端同步消息
        end
    --end
end
table.insert(tOnUserRechargeEmoney,GetEMoney_ToDayRecharge)

-- ===============================================================================================================
--  领取奖励的元宝（不同子活动的资源流向不一样，给资源让子活动自己给,同时，子活动自己也会记录发奖记录的）
--  @return 所以子活动一共给玩家充值了多少钱（根据 _nIndex，有的活动是没奖励的）
-- ===============================================================================================================
function GetEMoney_SendReward(_idCharacter,_nIndex,_nWantDouble)
    local send_active =  GetEMoney_Active_GetReward(_idCharacter,_nIndex,_nWantDouble)    -- 活跃度
    local send_online = GetEMoney_OnLine_GetReward(_idCharacter,_nIndex,_nWantDouble)    -- 在线时长
    local send_killboss = GetEMoney_Kill_GetReward(_idCharacter,_nIndex,_nWantDouble)      -- 龙山巡守
    return (send_active + send_online + send_killboss)
end

-- ===============================================================================================================
--  添加掩码，并设置掩码数据
-- ===============================================================================================================
function GetEMoney_Create(_idCharacter,_nOpenServerDay)
    
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        local nOpen_active = System_GetTempData(_idCharacter,nLuaIdActivity_Active,7)
        local nOpen_onLine = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,7)
        local nOpen_kill = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,7)

        local nOver_active = System_GetTempData(_idCharacter,nLuaIdActivity_Active,8)
        local nOver_onLine = System_GetTempData(_idCharacter,nLuaIdActivity_OnLine,8)
        local nOver_kill = System_GetTempData(_idCharacter,nLuaIdActivity_Kill,8)

        local totalOpen = math.min(nOpen_active,nOpen_onLine,nOpen_kill)    -- 开始时间取子活动最早
        local totalOver = math.max(nOver_active,nOver_onLine,nOver_kill)    -- 结束时间去子活动最晚

        local str = ""
        for i = 1,totalOver,1 do
            if  i == totalOver then
                str = str .. "0"
            else
                str = str .. "0" .. "|"
            end
        end

        local nCombineTimes = System_GetCombinedTimes()

        System_AddTempData(_idCharacter,nLuaIdActivity,false)
        System_SetTempData(_idCharacter,nLuaIdActivity,1,_nOpenServerDay,false)
        System_SetTempData(_idCharacter,nLuaIdActivity,6,nCombineTimes,false)
        System_SetTempData(_idCharacter,nLuaIdActivity,7,totalOpen,false)
        System_SetTempData(_idCharacter,nLuaIdActivity,8,totalOver,false)
        System_SetTempDataStr(_idCharacter,nLuaIdActivity,str)

    end
end

-- ===============================================================================================================
--  每天重置并计算老一天的数据
--  取的子活动str上记录的昨天的元宝，加到自己的记录中
-- ===============================================================================================================
function GetEMoney_Reset(_idCharacter,_nOpenServerDay)

    local nCombineTimes = System_GetCombinedTimes() 
    if  nCombineTimes ~= System_GetTempData(_idCharacter,nLuaIdActivity,6) then
        System_DelTempData(_idCharacter,nLuaIdActivity,false)
        GetEMoney_Create(_idCharacter,_nOpenServerDay)
    end
    -- 只在新服开放
    if  0 ~= nCombineTimes then
        return
    end

    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity,8)

    if  _nOpenServerDay ~= System_GetTempData(_idCharacter,nLuaIdActivity,1) then
        
        -- 本日是否充值了,就算活动结束了，这个值仍然更新并记录
        System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)       
        System_SetTempData(_idCharacter,nLuaIdActivity,1,_nOpenServerDay,false) -- 本日开服天数

        -- 需要更新的时间 nOpenDay ~ (nOverDay + 1)
        if  nOpenDay <= _nOpenServerDay and  _nOpenServerDay <= (nOverDay + 1) then  -- <= overDay 是为了要计算最后一天的分数                                         
            local tOldScore = {}

            -- 子活动元宝记录的 table
            local tActive = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_Active),"|" )   -- 活跃度            
            for k,v in pairs(tActive) do
                tActive[k] = System_Split(v, ",")
            end

            local tOnLine = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_OnLine),"|" )   -- 在线时长            
            for k,v in pairs(tOnLine) do
                tOnLine[k] = System_Split(v, ",")
            end

            local tKill = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity_Kill),"|" )   -- 龙山巡守            
            for k,v in pairs(tKill) do
                tKill[k] = System_Split(v, ",")
            end

            -- 把子活动昨天记录的元宝数值，加起来记录到 自己的 元宝数量 str-table 里
            for i = 1,nOverDay,1 do
                local tmp_active,tmp_online,tmp_kill = 0,0,0
                if  nil ~= tActive[i] then 
                    tmp_active = tActive[i][1] or 0
                end
                if  nil ~= tOnLine[i] then
                    tmp_online = tOnLine[i][1] or 0
                end
                if  nil ~= tKill[i] then
                    tmp_kill = tKill[i][1] or 0
                end

                -- ///////////////////////// 添加log 开始
                
                if  not("string" == type(tmp_active) or 0 == tmp_active) then    -- 要么是解析出来的字符串("0"/"num")，要么是 0
                    L2C_DebugLog("::GetEMoney_Reset get error tmp_active id:" .. _idCharacter)
                    L2C_DebugLog("::GetEMoney_Reset get error tmp_active:" .. tostring(tmp_active))
                    L2C_DebugLog("::GetEMoney_Reset strActive:".. System_GetTempDataStr(_idCharacter,nLuaIdActivity_Active))

                    tmp_active = 0
                end

                if  not("string" == type(tmp_online) or 0 == tmp_online) then
                    L2C_DebugLog("::GetEMoney_Reset get error tmp_online id:" .. _idCharacter)
                    L2C_DebugLog("::GetEMoney_Reset get error tmp_online:" .. tostring(tmp_online))
                    L2C_DebugLog("::GetEMoney_Reset strOnLine:"..System_GetTempDataStr(_idCharacter,nLuaIdActivity_OnLine))

                    tmp_online = 0
                end

                if  not("string" == type(tmp_kill) or 0 == tmp_kill) then
                    L2C_DebugLog("::GetEMoney_Reset get error tmp_kill id:" .. _idCharacter)
                    L2C_DebugLog("::GetEMoney_Reset get error tmp_kill:" .. tostring(tmp_kill))
                    L2C_DebugLog("::GetEMoney_Reset strKill:"..System_GetTempDataStr(_idCharacter,nLuaIdActivity_Kill))

                    tmp_kill = 0
                end
                -- ///////////////////////// 添加log 结束

                tOldScore[i] = tonumber(tmp_active) + tonumber(tmp_online) + tonumber(tmp_kill)
            end
            local strNew = GetEMoney_Reset_Write(tOldScore)

            -- System_SetTempData(_idCharacter,nLuaIdActivity,1,_nOpenServerDay,false) -- 本日开服天数
            System_SetTempData(_idCharacter,nLuaIdActivity,2,0,false)       -- 本日积累的分数
            -- System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)       -- 本日是否充值了
            System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false) -- 更新的奖励字符串
        end
    end
end

-- ===============================================================================================================
-- 获取的只有今天一天的累计元宝数量
-- ===============================================================================================================
function GetEMoney_GetTodayReward(_idCharacter)
    local nToday = GetEMoney_Active_NowEMoney(_idCharacter)+ GetEMoney_OnLine_NowEmoney(_idCharacter) + GetEMoney_Kill_NowEmoney(_idCharacter) 
    System_SetTempData(_idCharacter,nLuaIdActivity,2,nToday,false)
    return nToday
end

-- ===============================================================================================================
--  把一个table，写成用 "|"分割的字符串,(3个子活动也用的！)
-- ===============================================================================================================
function GetEMoney_Reset_Write(_t)
    local steRet = ""
    for i = 1,(#_t),1 do
        if  i == (#_t) then
            steRet = steRet .. tostring(_t[i])
        else
            steRet = steRet .. tostring(_t[i]) .. "|"
        end
    end
    return steRet
end

-- ===============================================================================================================
--  同步消息给客户端
-- ===============================================================================================================
function GetEMoney_Syn(_idCharacter)
    
    GetEMoney_GetTodayReward(_idCharacter)
     
    local nTotalMoney = System_GetTempData(_idCharacter,nLuaIdActivity,2)   -- 本日累计的元宝数
    local nRechargeSign = System_GetTempData(_idCharacter,nLuaIdActivity,3) -- 本日是否充值
    local nRewardStatus = System_GetTempData(_idCharacter,nLuaIdActivity,4) -- 位存储，天数-领奖状态    
    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity,7)      
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity,8)

    --local strTotalNum = System_GetTempDataStr(_idCharacter,nLuaIdActivity)

    -- Note:
    --      根据与客户端的商谈和与 策划的撕逼
    --      字段含义变化了
    --      主要是 str 的意思变化，原格式："x|x|x"代表第几天的3个子活动在这一天累计可以领取的元宝数
    --      根据客户端撕逼结果：变成 "x|x|x" 第一个代表第一个活动总共的可领取数，第二个是第二个
    --      就是显示的第一天第二天不再是第一天第二天，而是第一个活动，第二个活动
    --      现在这样改的原因是：一个天只一个活动，一个活动只开一天，所示会是正确的。。
    -- 策划已经签字！！ 
    
    local nActive = GetEMoney_Active_NowEMoney(_idCharacter,1)
    local nOnLine = GetEMoney_OnLine_NowEmoney(_idCharacter,1)
    local nKill = GetEMoney_Kill_NowEmoney(_idCharacter,1)
    local strTotalNum = tostring(nActive) .. "|" .. tostring(nOnLine) .. "|" .. tostring(nKill)

    -- L2C_DebugLog("::GetEMoney_Syn (".._idCharacter..","..nTotalMoney..","..nRewardStatus..","..nRechargeSign..","..nOpenDay..","..nOverDay..","..strTotalNum..")")
    System_Syn_GetEmoneyMessage(_idCharacter,nTotalMoney,nRewardStatus,nRechargeSign,nOpenDay,nOverDay,strTotalNum)
end

-- ===============================================================================================================
--  同步指定消息给客户端
-- ===============================================================================================================
function GetEMoney_Syn_Type(_idCharacter,_nType)
    
    if  eGetEmoney_Action.eGA_Active == _nType then   -- 累计的总的活跃度

        local nActive = GetEMoney_Active_NowAllScore(_idCharacter)        
        System_Syn_GetEmoneySynProcess(_idCharacter,eGetEmoney_Action.eGA_Active,nActive)

    elseif  eGetEmoney_Action.eGA_OnLine == _nType then    -- 累计的总的在线时长
        
        local nTotalOnLineTime = GetEMoney_OnLine_NowAllTime(_idCharacter)
        System_Syn_GetEmoneySynProcess(_idCharacter,eGetEmoney_Action.eGA_OnLine,nTotalOnLineTime)

    elseif  eGetEmoney_Action.eGA_Kill == _nType then    -- 累计的总的龙山巡守
        
        local nTotalTimes = GetEMoney_Kill_NowAllTimes(_idCharacter)
        System_Syn_GetEmoneySynProcess(_idCharacter,eGetEmoney_Action.eGA_Kill,nTotalTimes)
    end    
end

-- ===============================================================================================================
--  记录经分数据
-- ===============================================================================================================
function GetEMoney_Log_Type(_idCharacter,_nTotalNum)
   
    local nTotalOnLine = GetEMoney_OnLine_NowAllTime(_idCharacter)
    local nOnLineEmoney = GetEMoney_OnLine_NowEmoney(_idCharacter,1)

    local nTotalActive = GetEMoney_Active_NowAllScore(_idCharacter)
    local nActiveEmoney = GetEMoney_Active_NowEMoney(_idCharacter,1)

    local nTotalBoss = GetEMoney_Kill_NowAllTimes(_idCharacter)
    local nBossEmoney = GetEMoney_Kill_NowEmoney(_idCharacter,1)

    System_Log_GetEmoney(_idCharacter,nTotalOnLine,nOnLineEmoney,nTotalActive,nActiveEmoney,nTotalBoss,nBossEmoney)

end

-- ===============================================================================================================
--  主动计算下发活动状态
-- ===============================================================================================================
function GetEMoney_SendRewardStatus(_idCharacter,_nOsTimes)
    
    _nOsTimes = _nOsTimes or os.time()
    
    local nCombineTimes = System_GetCombinedTimes()
    if  0 ~= nCombineTimes then
        System_SendActiveStatus(_idCharacter,nResId,0,0,0)  -- 只在新服开启这个活动
        return
    end

    if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then
        -- L2C_DebugLog("::GetEMoney_SendRewardStatus nFunction not open,nFunctionId : "..nFunctionId)                
        System_SendActiveStatus(_idCharacter,nResId,0,0,0)  -- 活动功能未开启
        return
    end

    local nOpenServerDay = System_GetOpenServerDay()
    -- 同步下标显示的时间    
    local nOpenDay = System_GetTempData(_idCharacter,nLuaIdActivity,7)
    local nOverDay = System_GetTempData(_idCharacter,nLuaIdActivity,8)
    local status = 0
    if  nOpenDay <= nOpenServerDay and nOpenServerDay < nOverDay then
        status = 1
    end
        
    local nEndTime = 0
    if  1 == status then
        local tData = os.date("*t",_nOsTimes)
        tData["hour"] = 0
		tData["min"] = 0
		tData["sec"] = 0
              
        nEndTime = os.time(tData) + ( nOverDay - nOpenServerDay ) * 24 * 3600            
    end

    -- 活动时间上结束了，判断是不有还有为领取的奖励
    if  0 == status then        

        local nGetSign = System_GetTempData(_idCharacter,nLuaIdActivity,4)
        local tReward = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity),"|")

        for i = nOpenDay,(nOverDay-1),1 do
            local bTmp = WCBit.GetBit(nGetSign,i)
            local nRewardNum = tReward[i] or 0
            nRewardNum = tonumber(nRewardNum)
            if  false == bTmp and nRewardNum > 0 then  -- 某一天还有奖励未领取
                status = 1
                break
            end
        end
    end
    -- L2C_DebugLog("::GetEMoney_SendRewardStatus (id:".._idCharacter..",nResId:"..nResId..",status:"..status..",startTime:0,nEndTime:"..nEndTime)
    System_SendActiveStatus(_idCharacter,nResId,status,0,nEndTime)
end