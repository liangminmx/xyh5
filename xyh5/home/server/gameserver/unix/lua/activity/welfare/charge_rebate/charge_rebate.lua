
-- ////////////////////////// 领取 奖励的回码
local eChargeRebate_RetCode = {
    eRC_Null = 0,					-- 未知错误
	eRC_Success = 1,				-- 成功	
	eRC_HadGet = 2,				    -- 以领取
	eRC_Less = 3,				    -- 不能领取
	eRC_LessBag = 4,				-- 背包空间不足
    eRC_FouncTionNoOpen = 5,
}

-- ////////////////////////// 客户端包进来的类型
local eChargeRebate_ReqType = {
    eCRRT_Syn = 1,
    eCRRT_GetReward = 2,
}

local nResId = CRESOURCEFLOWACTION.eFT_charge_rebate
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

local nResId_sign = CRESOURCEFLOWACTION.eFT_charge_rebate_sign
local nLuaIdActivity_sign = LUARESOURCEFLOWACTION[nResId_sign]

local nResId_days = CRESOURCEFLOWACTION.eFT_charge_rebate_days
local nLuaIdActivity_days = LUARESOURCEFLOWACTION[nResId_days]

local nMamChargeRebateDay = 0

local nFunctionId = _charge_rebate_Info["root"][1]["functionid"][1]["functionid"]
local ChargeRebate_Info = {}
local ChargeRebate_DayKey = {}  -- 表：days - key(in ChargeRebate_Info)
local isInit = 0
local OpenServerDay = 0

--  连充返利活动，用3个数据库记录存了
--  charge_rebate      - 这个只存最近7天的充值记录
--  charge_rebate_sign - 一个存储奖励的可领取、已领取状态
--  charge_rebate_days - 一个存取指定 id 的连充 达成天数
--  以下很多 7 代表xml表中配置的最大连充时长为7天
--  Note：
--      活动掩码中
--      data1：今天充值的数额
--      data2：今天的日期
--      data3：连续充值的天数(无关充值数量，有充就算)
--      data4：本日是否充值了
--      dataStr：充值记录（只统计最近7天）
--              x,x,x,x,x,x,x (第一位表示今天，第二昨天。。。)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家登陆
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_OnLogin(_idCharacter,_nOsTimes)	
	ChargeRebate_Instance(_idCharacter)
	
	initOpenDay(_idCharacter)
	
	--活动没开或持续时间结束，删除活动数据	
	if nMamChargeRebateDay <= 0 or OpenServerDay > nMamChargeRebateDay  then
		if System_IsExistTempData(_idCharacter,nLuaIdActivity) then
			System_DelTempData(_idCharacter,nLuaIdActivity)
		end
		if System_IsExistTempData(_idCharacter,nLuaIdActivity_sign) then
			System_DelTempData(_idCharacter,nLuaIdActivity_sign)
		end
		if System_IsExistTempData(_idCharacter,nLuaIdActivity_days) then
			System_DelTempData(_idCharacter,nLuaIdActivity_days)
		end
		return
	end
	
	
    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        System_AddTempData(_idCharacter,nLuaIdActivity)        
        local tmpStr = ""
        for i = 1,nMamChargeRebateDay,1 do
            if  i == nMamChargeRebateDay then
                tmpStr = tmpStr .. "0"
            else
                tmpStr = tmpStr .. "0"..","
            end
        end
        System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,false)  
        System_SetTempDataStr(_idCharacter,nLuaIdActivity,tmpStr,false)
    end

    ChargeRebate_Sign_OnLogin(_idCharacter,_nOsTimes,ChargeRebate_Info) -- 创建奖励状态记录
    ChargeRebate_Days_OnLogin(_idCharacter,_nOsTimes,ChargeRebate_Info) -- 创建 指定 id 连充达成天数记录

    ChargeRebate_ResetData(_idCharacter,_nOsTimes)  -- 刷新数据

	ChargeRebate_checkDB(_idCharacter)
	
    ChargeRebate_SynAll(_idCharacter)
end
table.insert(tOnLoginActivity,ChargeRebate_OnLogin)
table.insert(tOnLoginActivity_Cross,ChargeRebate_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  数据验证
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_checkDB(_idCharacter)
	--local dataStr = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	local signData = ChargeRebate_Sign_AllData(_idCharacter)
	local dayData = ChargeRebate_Days_GetDaysData(_idCharacter)

	--local dataTable = ChargeRebate_ReadStr(dataStr)
	local signTable =  ChargeRebate_Sign_ReadStr(signData)
	local dayTable = ChargeRebate_Days_ReadStr(dayData)
	
	for k,v in pairs(signTable) do
		if dayTable[k][3] >= k then
			v[1] = 7
		elseif dayTable[k][2] >= k then
			v[1] = 3
		elseif dayTable[k][1] >= k then
			v[1] = 1
		end
	end

	local str = ChargeRebate_Sign_WriteStr(signTable)
	System_SetTempDataStr(_idCharacter,nLuaIdActivity_sign,str,false)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  数据初始化
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Instance(_idCharacter)
	if 0==isInit then
		isInit = 1
		local nCombinedTimes,defaultServerConfig
		local defaultDuration = 0
		if false == System_IsCrossSever() then
			nCombinedTimes=System_GetCombinedTimes()
		else
			nCombinedTimes=System_GetCombinedTimesByCharacter(_idCharacter)
		end
		
		for k,v in pairs(_charge_rebate_Info["root"][1]["openactivity"]) do
			--获取 =-1的默认配置
			if -1 == v["servernum"] then
				defaultServerConfig = v["days"]
				defaultDuration = v["duration"]
			end
			
			if nCombinedTimes == v["servernum"] then
				ChargeRebate_Info = v["days"]
				nMamChargeRebateDay = v["duration"]
			end
		end
		
		if 0 == nMamChargeRebateDay and defaultDuration~=0 then
			--表示没有对应的开服配置，但是=-1有配置
			nMamChargeRebateDay = defaultDuration
			ChargeRebate_Info = defaultServerConfig
		end
		
		for k,v in pairs(ChargeRebate_Info) do
			local newKey = v["day"]
			ChargeRebate_DayKey[newKey] = k
		end
	end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  初始化开服时间
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function initOpenDay(_idCharacter) 
	if System_IsCrossSever() then
		OpenServerDay = System_GetOpenServerDayByCharacter(_idCharacter)
	else
		OpenServerDay = System_GetOpenServerDay()
	end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_ZeroRefresh(_idCharacter,_nOsTimes)
    ChargeRebate_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,ChargeRebate_ZeroRefresh)
table.insert(tOnZeroTrigger_Cross,ChargeRebate_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家充值
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Recharge(_idCharacter,_nEmoney,_nOsTimes)
	if 0 == OpenServerDay then
		initOpenDay()
	end
	
	if nMamChargeRebateDay <= 0 or OpenServerDay > nMamChargeRebateDay then
		return
	end
	
	if "number" == type(_nEmoney) and _nEmoney <=0 then
		return
	end
	
	local dataStr = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
    local tRecharge = ChargeRebate_ReadStr(dataStr)
    tRecharge[1] = tRecharge[1] + _nEmoney
    -- 记录本日充值数量
    System_SetTempData(_idCharacter,nLuaIdActivity,1,tRecharge[1],false)

    -- 累计连续充值天数
    if  0 == System_GetTempData(_idCharacter,nLuaIdActivity,4) then
        local nCoutinueDays = System_GetTempData(_idCharacter,nLuaIdActivity,3)
        nCoutinueDays = nCoutinueDays + 1
        System_SetTempData(_idCharacter,nLuaIdActivity,3,nCoutinueDays,false)   -- 连续充值天数
        System_SetTempData(_idCharacter,nLuaIdActivity,4,1,false)   -- 本日已经充值
    end

    -- 开始判断逻辑 累计 的改变
    -- 判断充值后有没有奖励达到可以领取 和 有没有达到某一奖励的 天数累计条件
    ChargeRebate_AchieveCanGet(_idCharacter,tRecharge,_nOsTimes)

    -- 记录新的每日充值记录字符串
    local strNew = ChargeRebate_WriteStr(tRecharge)
    System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false)

	ChargeRebate_checkDB(_idCharacter)
    ChargeRebate_SynAll(_idCharacter)
end
table.insert(tOnUserRechargeEmoney,ChargeRebate_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,ChargeRebate_Recharge)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  客户端申请包接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_Req(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	if 0 == OpenServerDay then
		initOpenDay()
	end
	
	if nMamChargeRebateDay <= 0 or OpenServerDay > nMamChargeRebateDay then
		return eChargeRebate_RetCode.eRC_FouncTionNoOpen
	end
	
    if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then        
        return eChargeRebate_RetCode.eRC_FouncTionNoOpen
    end


    if  nil == _idCharacter or nResId ~= _nCActionType or nil == _nType or nil == _nData4 or nil == _nData5 then
        L2C_DebugLog("::ChargeRebate_Req error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nType or "nil").."|"..(_nData4 or "nil").."|"..(_nData5 or "nil")..")")
        return eChargeRebate_RetCode.eRC_Null
    end
      
    if  eChargeRebate_ReqType.eCRRT_Syn == _nType then               
        ChargeRebate_SynAll(_idCharacter)
        return eChargeRebate_RetCode.eRC_Success

    elseif  eChargeRebate_ReqType.eCRRT_GetReward == _nType then
        local nCode = ChargeRebate_GetRewardReq(_idCharacter,_nData4,_nData5)
        if  eChargeRebate_RetCode.eRC_Success == nCode then
            -- 写经分数据
            ChargeRebate_Log(_idCharacter,_nData4,_nData5)
        end
        return nCode
    end
    L2C_DebugLog("::ChargeRebate_Req get a error _nType:".._nType)
    return eChargeRebate_RetCode.eRC_Null
end
tOnOnAcitveAward[nResId] = ChargeRebate_Req
tOnOnAcitveAward_Cross[nResId] = ChargeRebate_Req

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得指定天数，需要的充值金额
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_GetNeedRecharge(_nDay,_nId)
    -- 判断 该 day-id 的数据存不存在
    if  nil == ChargeRebate_DayKey[_nDay] then
        L2C_DebugLog("::ChargeRebate_GetNeedRecharge error get nil day:" .._nDay)
        return 0
    end
    local nDayKey = ChargeRebate_DayKey[_nDay]
    local nIdKey = ChargeRebate_GetIdKey(nDayKey,_nId)
    if  nil == nIdKey then
        L2C_DebugLog("::ChargeRebate_GetNeedRecharge error get nil id, day: ".._nDay.." ,id:".._nId)
        return 0
    end    

    return ChargeRebate_Info[nDayKey]["grade"][nIdKey]["recharge"]
end

-- ========================================================================================================
--  领取奖励
-- ========================================================================================================
function ChargeRebate_GetRewardReq(_idCharacter,_nDay,_nId)
    -- 判断 该 day-id 的数据存不存在
    if  nil == ChargeRebate_DayKey[_nDay] then
        L2C_DebugLog("::ChargeRebate_GetRewardReq error get nil day:" .._nDay)
        return eChargeRebate_RetCode.eRC_Null
    end
    local nDayKey = ChargeRebate_DayKey[_nDay]
    local nIdKey = ChargeRebate_GetIdKey(nDayKey,_nId)
    if  nil == nIdKey then
        L2C_DebugLog("::ChargeRebate_GetRewardReq error get nil id, day: ".._nDay.." ,id:".._nId)
        return eChargeRebate_RetCode.eRC_Null
    end    
    local tData = ChargeRebate_Info[nDayKey]["grade"][nIdKey]   -- 奖励存在 [nDayKey]["grade"][nIdKey]

    -- 判断该奖励能不能领取
    local bCan = ChargeRebate_Sign_Can(_idCharacter,0,_nDay,_nId)
    if  false == bCan then
        return eChargeRebate_RetCode.eRC_Less
    end

    -- 判断该奖励是否已经领取
    local bGet = ChargeRebate_Sign_Get(_idCharacter,0,_nDay,_nId)    
    if  true == bGet then
        return eChargeRebate_RetCode.eRC_HadGet
    end

    -- 判断背包能不能放的下
    if  false == ChargeRebate_BagEnough(_idCharacter,nDayKey,nIdKey) then
        return eChargeRebate_RetCode.eRC_LessBag
    end

    -- 设置奖励已领取并发放奖励
    if  true == ChargeRebate_Sign_Get(_idCharacter,1,_nDay,_nId) then
        -- L2C_DebugLog("ChargeRebate_GetRewardReq success ")
        ChargeRebate_SendReward(_idCharacter,nDayKey,nIdKey)
        return eChargeRebate_RetCode.eRC_Success
    else
        L2C_DebugLog("::ChargeRebate_GetRewardReq set mask error")
        return eChargeRebate_RetCode.eRC_Null
    end
end

-- ========================================================================================================
--  发放奖励
-- ========================================================================================================
function ChargeRebate_SendReward(_idCharacter,_nDayKey,_nIdKey)
    local tRewardData = ChargeRebate_Info[_nDayKey]["grade"][_nIdKey]
    if  "table" == type(tRewardData["obtain"]) then
        for k,v in pairs(tRewardData["obtain"]) do
            local nItemId = v["item"]
            local nNum = v["num"]
            local nTimeMode = v["timemode"] or 0
            local nTime = v["time"] or 0        
                
            local nRealTime = System_timeModeTransfer(nTimeMode,nTime)            

            System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum,0,0,0,0,nTimeMode,nRealTime)
        end 
    end  
end

-- ========================================================================================================
--  判断背包能不能放得下
-- ========================================================================================================
function ChargeRebate_BagEnough(_idCharacter,_nDayKey,_nIdKey)
    local tRewardData = ChargeRebate_Info[_nDayKey]["grade"][_nIdKey]      
    local strItem = ""  -- _sItem格式 "item,num;item2,num2;"
    if  "table" == type(tRewardData["obtain"]) then
        for k,v in pairs(tRewardData["obtain"]) do
            local nItemId = v["item"]
            local nNum = v["num"]
            strItem = strItem .. tostring(nItemId) .. "," .. tostring(nNum)..";"
        end 
    end    
    return System_CanPushThingsToBagEx(_idCharacter,strItem)
end

-- ========================================================================================================
--  每日重置数据
-- ========================================================================================================
function ChargeRebate_ResetData(_idCharacter,_nOsTimes)

    local nSignDayTmp = System_GetTempData(_idCharacter,nLuaIdActivity,2)   -- 记录的时间戳

    local nTodayZero = System_GetZeroTime(_nOsTimes)
    local nSignDayZero = System_GetZeroTime(nSignDayTmp)

    if  nTodayZero ~= nSignDayZero then   
                               
        -- 获得本次刷新与上次登入隔了几天                
        local nPastDay = math.ceil( (nTodayZero - nSignDayZero) / (24*60*60) )

        -- 刷新纪录奖励连充天数的数据
        local nTodayRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,1)
        ChargeRebate_Days_ResetData(_idCharacter,nPastDay, nTodayRecharge,ChargeRebate_Info) 

        -- 刷新7天内充值记录
        local tRecharge = ChargeRebate_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity)) -- str: "x,x,x" (7个0)
        tRecharge = ChargeRebate_Reset_Recharge(tRecharge,nPastDay)
        local strNew = ChargeRebate_WriteStr(tRecharge)
        
        -- 连续充值天数，其实是无用数据了 ==、
        local nCoutinueDays = System_GetTempData(_idCharacter,nLuaIdActivity,3)
		-- 不重置天数
        -- if  0 == System_GetTempData(_idCharacter,nLuaIdActivity,4) then
            -- nCoutinueDays = 0
        -- end

        -- 重新记录数据库数据
        System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)       -- 今天的充值金额
        System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,false)  -- 设置新的日期
        System_SetTempData(_idCharacter,nLuaIdActivity,3,nCoutinueDays,false)   -- 连续充值天数
        System_SetTempData(_idCharacter,nLuaIdActivity,4,0,false)   -- 本日是否充值了
		
		--活动结束就不变更记录
		if nMamChargeRebateDay >= System_GetCharacterCreateDay(_idCharacter) then
			System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew,false) -- 新的充值记录        
		end
        
    end
end

-- ========================================================================================================
--  每天充值之后，判断有没有新的奖励达成可领取条件了  和 有没有达到某一奖励的 天数累计条件
-- ========================================================================================================
function ChargeRebate_AchieveCanGet(_idCharacter,_tData,_nOsTimes)
    
    local nTodayRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    
    for k,v_day in pairs(ChargeRebate_Info) do  -- 遍历每一天/id 的奖励

        local needCountinueDay = v_day["day"]
        for k2,v_id in pairs(v_day["grade"]) do
            local id = v_id["id"]
            local nNeedMoney = v_id["recharge"]

            if  nTodayRecharge >= nNeedMoney then   -- 今天的充值金额达到某一 档位 要求金额，连充天数 + 1
                ChargeRebate_Days_AchieveOne(_idCharacter,needCountinueDay,id)
            end
     
            local bCanGet = ChargeRebate_DealCan(_tData,needCountinueDay,nNeedMoney) -- 遍历最近7天的充值记录，判断该档 达到领取条件                               
            if true == bCanGet then                
                ChargeRebate_Sign_Can(_idCharacter,1,needCountinueDay,id)
            end
        end
    end            
end

-- ========================================================================================================
--  判断某一项连充奖励是否完成
--  @return true/false
-- ========================================================================================================
function ChargeRebate_DealCan(_tData,_nNeedContinueDay,_nNeeMoney)    
    local nTotalTimes = 0
    for i = 1,nMamChargeRebateDay,1 do
        if  _tData[i] >= _nNeeMoney then    
            nTotalTimes = nTotalTimes + 1 
            if  nTotalTimes >= _nNeedContinueDay then    
                return true
            end
        -- else 
            -- nTotalTimes = 0
        end                          
    end
    return false
end

-- ========================================================================================================
--  获取在天数下(day下)，id的key
-- ========================================================================================================
function ChargeRebate_GetIdKey(_nDayKey,_nId)
    for k,v in pairs(ChargeRebate_Info[_nDayKey]["grade"]) do
        if  _nId == v["id"] then
            return k
        end
    end
end

-- ========================================================================================================
--  解析字符串 格式 x,x
-- ========================================================================================================
function ChargeRebate_ReadStr(_str)
    if  nil == _str or "" == _str then
        L2C_DebugLog("::ChargeRebate_ReadStr get error str")
        return {}
    end
    local tmpData = System_Split(_str,",")
    for k,v in pairs(tmpData) do
        tmpData[k] = tonumber(v)
    end
    return tmpData
end

-- ========================================================================================================
--  写字符串
-- ========================================================================================================
function ChargeRebate_WriteStr(_tData)
    local strNew = ""
    for i = 1,nMamChargeRebateDay,1 do    -- 7 代表xml中配置的连续充值最多7天，所以只记录最近7天的记录
		local nDayRecharge = _tData[i] or 0
		if "number" ~= type(_tData[i]) then
			nDayRecharge = 0
		end
        if  i == nMamChargeRebateDay then                    
            strNew = strNew .. tostring(nDayRecharge)
        else
            strNew = strNew .. tostring(nDayRecharge) .. ","
        end
    end
    return strNew
end

-- ========================================================================================================
--  更新表示每日充值数量的
--  @_tData 要求要是 [1],[2],[3] .. [n] 的连续记录(应该是到[7])
--  @_nPastDay 过去多少天(逻辑上0 < _nPastDay <= 7，否则返回 7 天都为0)
-- ========================================================================================================
function ChargeRebate_Reset_Recharge(_tData,_nPastDay)    
    local nChildNum = (#_tData)
    local tRet = {}
    if  _nPastDay < 0 then
        for i = 0,nChildNum,1 do
            tRet[i] = 0
        end
    else
        for i = 0,nChildNum,1 do
            local nDataInOldTableKey = i - _nPastDay
            tRet[i] = _tData[nDataInOldTableKey] or 0
        end

    end
    return tRet
end

-- ========================================================================================================
--  写发奖之后的经分
-- ========================================================================================================
function ChargeRebate_Log(_idCharacter,_nDay,_nId)

    local nTodayRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,1)-- 本日充值数量
    local nCoutinueDays = System_GetTempData(_idCharacter,nLuaIdActivity,3) -- 连充天数

    System_Log_Charge_Rebate(_idCharacter,_nDay,_nId,0)
end

-- ========================================================================================================
--  发同步包
-- ========================================================================================================
function ChargeRebate_SynAll(_idCharacter)
    local nTodayRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,1)-- 本日充值数量
    local nCoutinueDays = System_GetTempData(_idCharacter,nLuaIdActivity,3) -- 连充天数
    local strStatus = ChargeRebate_Sign_AllData(_idCharacter)
    local strDays = ChargeRebate_Days_GetDaysData(_idCharacter)
        
    -- L2C_DebugLog("::ChargeRebate_SynAll " .. strDays)
    System_Syn_Charge_Rebate_All(_idCharacter,nTodayRecharge,nCoutinueDays,strStatus,strDays)
end


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级触发
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChargeRebate_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	ChargeRebate_OnLogin(_idCharacter,os.time())
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],ChargeRebate_LevelUp)
tQuestTrigeer_Cross[TASKTYPE.LevelUp] = tQuestTrigeer_Cross[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],ChargeRebate_LevelUp)