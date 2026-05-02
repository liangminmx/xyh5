
-- ////////////////////////// 领取 奖励的回码
 eTeamrecharge_RetCode = {
	eRC_Success = 0,				-- 成功
	eRC_Null = 1,					-- 未知错误
	eRC_ActivityEnd = 2,			-- 活动结束
	eRC_NoRechargeEnough = 3,	    -- 自己的充值金额不够
	eRC_NoEnoughNum = 4,			-- 今日首充的人数不够
	eRC_HadGet = 5,					-- 已领取
	eRC_BagFull = 6,				-- 背包已满
    eRC_FunctionIdNoOpen = 7,		-- 功能未开放
}

-- ////////////////////////// 奖励的领取状态
 eTeamrecharge_RewardStatus = {
	eRC_None = "0",				-- 未领取
	eRC_Had = "1",				-- 已领取
}


local nResId = CRESOURCEFLOWACTION.eFT_Teamrecharge			-- 资源流向id
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]			-- 活动掩码id / 全局掩码表中的 id
local nFunctionId = _teamrecharge_Info["root"][1]["functionid"][1]["functionid"]
local Teamrecharge_Info = _teamrecharge_Info["root"][1]["sever"]

--	Note:
--		活动掩码中:
--			data1 本条记录的有效日期
--			data2 本日充值的钱
--			data3 本日是否领过首充
--          data4 本日该服务器是否开启该活动 (0/1)
--          data5 在跨服充值的时间
--			dataStr 奖励领取状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Teamrecharge_OnLogin(_idCharacter,_nOsTimes)
	Teamrecharge_AnyOne_OnLogin(_idCharacter,_nOsTimes)	-- 触发全局掩码
	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)				
	end
	
	local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))	
	local signDay = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if	nowDay ~= signDay then
		Teamrecharge_ResetData(_idCharacter,_nOsTimes)
	end
	
	-- 给玩家同步信息
	Teamrecharge_Syn_One(_idCharacter)
	if System_GetTempData(_idCharacter,nLuaIdActivity,5) > 0 then
		Teamrecharge_AchieveToday(_idCharacter,System_GetTempData(_idCharacter,nLuaIdActivity,5))
		System_SetTempData(_idCharacter,nLuaIdActivity,5,0)
	end
	
end
table.insert(tOnLoginActivity,Teamrecharge_OnLogin)
table.insert(tOnLoginActivity_Cross,Teamrecharge_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	零点刷新(做的事情和登入一样的)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Teamrecharge_ZeroRefresh(_idCharacter,_nOsTimes)
	--Teamrecharge_AnyOne_ZeroRefresh(_idCharacter,_nOsTimes)		-- 触发全局掩码刷新
	Teamrecharge_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,Teamrecharge_ZeroRefresh)
table.insert(tOnZeroTrigger_Cross,Teamrecharge_ZeroRefresh)

-- ===============================================================================================================
--	玩家充值(只记录活动中的单日充值数量)
-- ===============================================================================================================
function Teamrecharge_Recharge(_idCharacter,_nEmoney,_nOsTimes)
    local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))
    local signDay = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    if  nowDay ~= signDay then
        Teamrecharge_ResetData(_idCharacter,_nOsTimes)
    end
    
	local nHadRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	nHadRechargeNum = nHadRechargeNum + _nEmoney
	System_SetTempData(_idCharacter,nLuaIdActivity,2,nHadRechargeNum,false)
	Teamrecharge_Syn_One(_idCharacter)
end
table.insert(tOnUserRechargeEmoney,Teamrecharge_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,Teamrecharge_Recharge)

-- ===============================================================================================================
--  玩家达到本日充值目标(由首充活动中判断达到条件)
-- ===============================================================================================================
function Teamrecharge_AchieveToday(_idCharacter,_nOsTimes)
    --if true == System_IsCrossSever() then
		--保存跨服充值的时间
	--	System_SetTempData(_idCharacter,nLuaIdActivity,5,_nOsTimes)
	--	return
	--end	
	
    local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))
	local signDay = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if	nowDay ~= signDay then
		Teamrecharge_ResetData(_idCharacter,_nOsTimes)
	end
    
    local nSignAchieve = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    if  nSignAchieve == 0 then
        System_SetTempData(_idCharacter,nLuaIdActivity,3,1,false)
        Teamrecharge_AnyOne_Recharge(_idCharacter,_nOsTimes)
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取奖励
--	@_nRewardId 		奖励的id
--	@_nRewardIndex 	奖励不同id下的第几个奖励
--	@_nOsTimes			当前时间
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Teamrecharge_GetRewardReq(_idCharacter,_nCActionType,_nRewardId,_nRewardIndex,_nOsTimes)
	if	_idCharacter == nil or _nCActionType ~= nResId or _nRewardId == nil or _nRewardIndex == nil or _nOsTimes == nil then
		L2C_DebugLog("::Teamrecharge_GetRewardReq Error (".._idCharacter.."|".._nCActionType.."|".._nRewardId.."|".._nRewardIndex.."|".._nOsTimes..")")
		return eTeamrecharge_RetCode.eRC_Null
	end
    local nOpenStatus = System_OpenGuideFunction(_idCharacter,nFunctionId)
    if  nOpenStatus ~= 0 then
        return eTeamrecharge_RetCode.eRC_FunctionIdNoOpen  -- 功能未开放
    end
	if false == System_IsCrossSever() then
		local globalDay = System_GetGlobalData(nLuaIdActivity,1)
		local nAllNum = System_GetGlobalData(nLuaIdActivity,2)
		local n64code=Teamrecharge_GetRewardReq_Do(_idCharacter,_nCActionType,_nRewardId,_nRewardIndex,_nOsTimes,globalDay,nAllNum)
		System_Syn_TeamRechargeGetRewardRet(_idCharacter,n64code,_nRewardId,_nRewardIndex)
		return n64code --返回码没用了，用上面的方法返回操作结果
	else
		System_SetTempData(_idCharacter,nLuaIdActivity,7,math.floor(_nCActionType)*1000000 + math.floor(_nRewardId)*10000 + math.floor(_nRewardIndex)*100,false) --跨服临时数据,使用完后置0
		System_SetTempData(_idCharacter,nLuaIdActivity,8,_nOsTimes)--跨服临时数据,使用完后置0
		System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_GetReward,nLuaIdActivity)
		return eTeamrecharge_RetCode.eRC_Success --返回码没用了，用上面的方法返回操作结果
	end
end
tOnOnAcitveAward[nResId] = Teamrecharge_GetRewardReq
tOnOnAcitveAward_Cross[nResId] = Teamrecharge_GetRewardReq

function Teamrecharge_GetRewardReq_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local _nOsTimes = System_GetTempData(_idCharacter,nLuaIdActivity,8)
	local nParms = System_GetTempData(_idCharacter,nLuaIdActivity,7)
	local _nCActionType = math.floor(nParms/1000000)
	local _nRewardId = math.floor((nParms-_nCActionType*1000000)/10000)
	local _nRewardIndex = math.floor((nParms-_nCActionType*1000000-_nRewardId*10000)/100)
	local n64code = Teamrecharge_GetRewardReq_Do(_idCharacter,_nCActionType,_nRewardId,_nRewardIndex,_nOsTimes,_nData1,_nData2)
	System_Syn_TeamRechargeGetRewardRet(_idCharacter,n64code,_nRewardId,_nRewardIndex)
	System_SetTempData(_idCharacter,nLuaIdActivity,7,0)
	System_SetTempData(_idCharacter,nLuaIdActivity,8,0)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.Teamrecharge_GetReward] = Teamrecharge_GetRewardReq_Cross


function Teamrecharge_GetRewardReq_Do(_idCharacter,_nCActionType,_nRewardId,_nRewardIndex,_nOsTimes,globalDay,nAllNum)
	-- 检验全局掩码/个人掩码的日期
	local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))
	local personDay = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if	nowDay ~= personDay or nowDay ~= globalDay then
		L2C_DebugLog("::Teamrecharge_GetRewardReq Date Error :　day1:"..personDay..",day2:"..globalDay .. "nowDay:"..nowDay)
		return eTeamrecharge_RetCode.eRC_Null
	end
    -- 判断该服务器,本日 开不开活动
    local nServerKey = Teamrecharge_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        return eTeamrecharge_RetCode.eRC_ActivityEnd
    end   
	local nOpenServerDay
	if false == System_IsCrossSever() then 
		nOpenServerDay = System_GetOpenServerDay()
	else
		nOpenServerDay = System_GetOpenServerDayByCharacter(_idCharacter)
	end
	
	local nDayKey, nilStr =  Teamrecharge_GetKeyAndTable(nServerKey,nOpenServerDay)
	if	nil == nDayKey then
		return eTeamrecharge_RetCode.eRC_ActivityEnd	
	end
	
	-- 判断参数是否正确(该奖励是否存在)
	local tToDayData = Teamrecharge_Info[nServerKey]['recharge'][nDayKey]
	if	"table" ~= type(tToDayData) or 
		"table" ~= type(tToDayData["need"][_nRewardId]) or
		"table" ~= type(tToDayData["need"][_nRewardId]["needemoney"][_nRewardIndex]) then
		
		L2C_DebugLog("::Teamrecharge_GetRewardReq Error DayKey:"..nDayKey..",_nRewardId:".._nRewardId..",_nRewardIndex:".._nRewardIndex)
		return eTeamrecharge_RetCode.eRC_Null 
	end
	-- 判断全服的充值人数够不够
	if	nAllNum < tToDayData["need"][_nRewardId]["neednum"] then
		return eTeamrecharge_RetCode.eRC_NoEnoughNum 
	end
	-- 判断自己充值的金额够不够
	local nMyRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local nNeedMoney = tToDayData["need"][_nRewardId]["needemoney"][_nRewardIndex]["needemoney"]
	if	nMyRechargeNum < nNeedMoney then		
		return eTeamrecharge_RetCode.eRC_NoRechargeEnough 
	end
	-- 判断今日这个奖励是否已经领取
	local toDayRewardStatusStr = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	if	"string" ~= type(toDayRewardStatusStr) or toDayRewardStatusStr == "" then
		toDayRewardStatusStr = nilStr
	end
	local tRewardStatus = Teamrecharge_ReadStr(toDayRewardStatusStr)
	if	"nil" ~= type(tRewardStatus[_nRewardId][_nRewardIndex]) and tRewardStatus[_nRewardId][_nRewardIndex] ~= eTeamrecharge_RewardStatus.eRC_None then
		return eTeamrecharge_RetCode.eRC_HadGet 
	end
	-- 判断背包够不够放
	if	false == Teamrecharge_BagEnough(_idCharacter,nServerKey,nDayKey,_nRewardId,_nRewardIndex) then		
		return eTeamrecharge_RetCode.eRC_BagFull
	end
	-- 设置该奖励已经被领取
	tRewardStatus[_nRewardId][_nRewardIndex] = eTeamrecharge_RewardStatus.eRC_Had
	local resultStr = Teamrecharge_WriteStr(tRewardStatus)
	if	false == System_SetTempDataStr(_idCharacter,nLuaIdActivity,resultStr) then
		L2C_DebugLog("::Teamrecharge_GetRewardReq Error Set Mask Str Failed")
		return eTeamrecharge_RetCode.eRC_Null
	else
		-- 发放奖励
		Teamrecharge_SendReward(_idCharacter,nServerKey,nDayKey,_nRewardId,_nRewardIndex)
		return eTeamrecharge_RetCode.eRC_Success
	end
end
-- ========================================================================================================
-- 重置数据
-- ========================================================================================================
function Teamrecharge_ResetData(_idCharacter,_nOsTimes)
	local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))
    -- 判断该服务器,本日 开不开活动
    local nOpen = 0
    local nServerKey = Teamrecharge_GetServerKey(_idCharacter)
    if  nil ~= nServerKey then
	    local nOpenServerDay
		if false == System_IsCrossSever() then 
			nOpenServerDay = System_GetOpenServerDay()
		else
			nOpenServerDay = System_GetOpenServerDayByCharacter(_idCharacter)
		end
	
	    local nDayKey, nilStr =  Teamrecharge_GetKeyAndTable(nServerKey,nOpenServerDay)
        if  nil ~= nDayKey then
            nOpen = 1
        end
    end   

	System_SetTempData(_idCharacter,nLuaIdActivity,1,nowDay,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,2,0,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)
    System_SetTempData(_idCharacter,nLuaIdActivity,4,nOpen,false)
	System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)	
end

-- ========================================================================================================
-- 判断背包能不能放得下
-- ========================================================================================================
function Teamrecharge_BagEnough(_idCharacter,_nServerKey,_nDayKey,_nRewardId,_nRewardIndex)
        
    local tToDayData = Teamrecharge_Info[_nServerKey]['recharge'][_nDayKey]	
	if	"table" ~= type(tToDayData) or 
		"table" ~= type(tToDayData["need"][_nRewardId]) or
		"table" ~= type(tToDayData["need"][_nRewardId]["needemoney"][_nRewardIndex]) then
		-- 这里不应该找不到的！
		L2C_DebugLog("::Teamrecharge_BagEnough Error nServerKey:".._nServerKey..",DayKey:".._nDayKey..",_nRewardId:".._nRewardId..",_nRewardIndex:".._nRewardIndex)
		return false
	else
		
		local rewardData = tToDayData["need"][_nRewardId]["needemoney"][_nRewardIndex]
		local itemStr = ""
		if	"table" == type(rewardData["reward"]) then
			for	k,v in pairs(rewardData["reward"]) do
				local nItemId = v["item"]
				local nNum = v["itemnum"]				
				itemStr = itemStr .. tostring(nItemId) .. "," .. tostring(nNum) .. ";"
			end
		end
		return System_CanPushThingsToBagEx(_idCharacter,itemStr)
	end
end

-- ========================================================================================================
-- 发放奖励
-- ========================================================================================================
function Teamrecharge_SendReward(_idCharacter,_nServerKey,_nDayKey,_nRewardId,_nRewardIndex)

    local tToDayData = Teamrecharge_Info[_nServerKey]['recharge'][_nDayKey]   	
	if	"table" ~= type(tToDayData) or 
		"table" ~= type(tToDayData["need"][_nRewardId]) or
		"table" ~= type(tToDayData["need"][_nRewardId]["needemoney"][_nRewardIndex]) then
		-- 这里不应该找不到的！
		L2C_DebugLog("::Teamrecharge_GetRewardReq Error nServerKey:".._nServerKey..",DayKey:".._nDayKey..",_nRewardId:".._nRewardId..",_nRewardIndex:".._nRewardIndex)
	else
		
		local rewardData = tToDayData["need"][_nRewardId]["needemoney"][_nRewardIndex]
		if	"table" == type(rewardData["reward"]) then
			for	k,v in pairs(rewardData["reward"]) do
				local nItemId = v["item"]
				local nNum = v["itemnum"]
				System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum)
			end
		end
	end
end

-- ========================================================================================================
--	发送某一玩家信息给客戶端
-- ========================================================================================================
function Teamrecharge_Syn_One(_idCharacter)
    local nServerKey = Teamrecharge_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        return 
    end
	local nOpenServerDay
	if false == System_IsCrossSever() then 
		nOpenServerDay = System_GetOpenServerDay()
	else
		nOpenServerDay = System_GetOpenServerDayByCharacter(_idCharacter)
	end

	local nDayKey, nilStr = Teamrecharge_GetKeyAndTable(nServerKey,nOpenServerDay)
	if	nil ~= nDayKey then
		-- L2C_DebugLog("::Teamrecharge_Syn_One (".._idCharacter.."|"..selfRecharge.."|"..serverTotalNum.."|"..toDayRewardStatusStr..")")
		if false == System_IsCrossSever() then
			local selfRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,2)
			local toDayRewardStatusStr = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
			if	"string" ~= type(toDayRewardStatusStr) or toDayRewardStatusStr == "" then
				toDayRewardStatusStr = nilStr
			end
			local serverTotalNum = System_GetGlobalData(nLuaIdActivity,2)
			System_Syn_Teamrecharge(_idCharacter,serverTotalNum,selfRecharge,toDayRewardStatusStr)
		else
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_GetServerTotalNumToOne,nLuaIdActivity)
		end
	end
end
function Teamrecharge_Syn_One_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local selfRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local toDayRewardStatusStr = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	if	"string" ~= type(toDayRewardStatusStr) or toDayRewardStatusStr == "" then
		toDayRewardStatusStr = nilStr
	end
	System_Syn_Teamrecharge(_idCharacter,_nData2,selfRecharge,toDayRewardStatusStr)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.Teamrecharge_GetServerTotalNumToOne] = Teamrecharge_Syn_One_Cross

-- ========================================================================================================
--	根据开服天数，找到配置数据在表中的 key，并返回一个全部奖励为领取的 str
-- ========================================================================================================
function Teamrecharge_GetKeyAndTable(_nServerKey,_nOpenDay)
    
    local tRecharge_Info = Teamrecharge_Info[_nServerKey]['recharge']

	local nDefaultDay = -1
	local nDefaultKey = nil
	
	local nDayKey = nil
	local strTotal = ""
	
	for	k,v in pairs(tRecharge_Info) do
		if	v["day"] == _nOpenDay then
			nDayKey = k
			break;
		end
		if	v["day"] == nDefaultDay then nDefaultKey = k end
	end
	if	nDayKey == nil then nDayKey = nDefaultKey end
	
	if	nDayKey ~= nil then	-- 拼接字符串		
		local tToDayRewardList = tRecharge_Info[nDayKey]["need"]
		for	i = 1, (#tToDayRewardList),1 do
		
			local tRewardType = tToDayRewardList[i]
			local strType = ""
			
			for	j = 1, (#(tRewardType["needemoney"])),1 do
				strType = strType .. "0"  
				if	j == (#(tRewardType["needemoney"])) then
					if i ~= #tToDayRewardList then
						strType = strType .. "|"
					end
				else
					strType = strType ..","
				end
			end	
			strTotal = strTotal .. strType
			
		end
	end
	
	return nDayKey,strTotal
end

-- ========================================================================================================
--	读取解析字符串数据，返回table
--	字符串格式："[x,x,x][x,x,x]"
-- ========================================================================================================
function Teamrecharge_ReadStr(toDayRewardStatusStr)--_idCharacter)
	
	local resTable = {}
	local strTep = toDayRewardStatusStr-- System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	if	"string" ~= type(strTep) or strTep == "" then
		return resTable 
	end
	
	local tTmp = System_Split(strTep,"|")	-- 解析出今日活动不同 id 的串，得每一个字串到格式 "x,x,x]"
	for	k,v in pairs(tTmp) do
		local tTmp2 = System_Split( string.sub(v,1,-1)	,",")
		table.insert(resTable,tTmp2)
	end
	
	return resTable
end

-- ========================================================================================================
--	创建字符串数据，返回str
-- ========================================================================================================
function Teamrecharge_WriteStr(_tStrData)

	local resStr = ""
	for	k,v in ipairs(_tStrData) do
		local tmpStr = ""--"["
		for	i = 1,(#v),1 do
				tmpStr = tmpStr .. tostring(v[i])
				if	i == (#v) then
					if nil ~= next(_tStrData,k) then
						tmpStr = tmpStr .. "|"
					end
				else
					tmpStr = tmpStr .. ","
				end
		end

		resStr = resStr .. tmpStr
	end
	return resStr
end

-- ========================================================================================================
--  根据合服次数，返回可用key
-- ========================================================================================================
function Teamrecharge_GetServerKey(_idCharacter)
    
    local nCombineTime
	if false == System_IsCrossSever() then 
		nCombineTime = System_GetCombinedTimes()
	else
		nCombineTime = System_GetCombinedTimesByCharacter(_idCharacter)
	end
    local nDefaultTime = -1
    local nDefaultKey = nil

    for k,v in pairs(Teamrecharge_Info) do
        
        if  nCombineTime == v['servernum'] then
            return k
        end
        if  nDefaultTime == v['servernum'] then
            nDefaultKey = k
        end
    end

    return nDefaultKey
end



