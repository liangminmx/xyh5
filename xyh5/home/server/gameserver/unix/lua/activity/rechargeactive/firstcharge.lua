-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1-7 字段，今日是否已充值 1-7是不同的累充类型
--				 data8 字段，充值数量
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	local ChargeActiveCode = {
		eCAC_Unkown		= 0,	--//未知错误
		eCAC_Succ		= 1,	--//操作成功
		eCAC_NoReward	= 2,	--//没有奖励可领取
		eCAC_NoStart	= 3,	--// 活动没有开启
		eCAC_NoFoundDeploy = 4,	--//没有找到配置信息
		eCAC_ExchangeError = 5,	--//兑换错误
		eCAC_HaveGetReward = 6,	--//奖励已领取
		eCAC_LessSpace	= 7,	--//背包空间不足
		eCAC_LessLevel = 8,		--//条件不满足
		eCAC_LessRecharge = 9,	--//充值数不满足
	};
local nflowaction = CRESOURCEFLOWACTION.eFT_FirstCharge
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]
local tRechargeInfoMain = _recharge_Info["root"][1]["server"]
local nRechargeFunctionid = _recharge_Info["root"][1]["functionid"][1]["functionid"]
local tRechargeNotice =  tRechargeInfoMain[1].rechargenotice

--这两个是首充团购的
--local nResIdTeam = CRESOURCEFLOWACTION.eFT_Teamrecharge			-- 资源流向id
--local nLuaIdActivityTeam = LUARESOURCEFLOWACTION[nResIdTeam]			-- 活动掩码id / 全局掩码表中的 id

function FirstCharge_processReceiveFirstReward(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	-- _nType = 1
	if 0 ~= System_OpenGuideFunction(_idCharacter,nRechargeFunctionid) then
		return ChargeActiveCode.eCAC_LessLevel
	end
	--统一走累计充值接口
	-- if _nType == 1 then
		-- return FirstCharge_ReceiveFirstReward(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	-- end
	-- if _nType == 2 then
	
	local code =FirstCharge_ReceiveAccumulateReward(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	return code
	-- end
	-- return ChargeActiveCode.eCAC_Unkown
end
tOnOnAcitveAward[nflowaction] = FirstCharge_processReceiveFirstReward
--领首充奖励
function FirstCharge_ReceiveFirstReward(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
		--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity)
	if false == bRet then
		return ChargeActiveCode.eCAC_Unkown
	end
	--取奖励次数
	local IsRecharge,nowRewardTimes,topRewardTimes = tTemp[1],tTemp[2],tTemp[3]
	if nowRewardTimes >= topRewardTimes then
		return ChargeActiveCode.eCAC_NoReward
	end
	local key = FirstCharge_GetServerKey(_idCharacter)
	if -9999 == key then
		return ChargeActiveCode.eCAC_NoReward
	end
	
	local tAward = tRechargeInfoMain[key]
	if tAward.isopen ~= 1 then
		return ChargeActiveCode.eCAC_NoStart
	end
	
	local tAwardRecharge = tAward.recharge[1]
	if nowRewardTimes < tAwardRecharge.maxcount then
		nowRewardTimes = nowRewardTimes + 1
	elseif tAwardRecharge.hold == 1 then
		nowRewardTimes = tAwardRecharge.maxcount
	else
		return ChargeActiveCode.eCAC_Unkown
	end
	--处理一下奖励表 
	local tRechargeinfo = {}
	for i,v in pairs(tAwardRecharge.rechargeinfo) do
		if _nType == v.type then
			if nil == tRechargeinfo[v.count] then		
				tRechargeinfo[v.count] = v
			else
				L2C_DebugLog("FirstCharge_ReceiveFirstReward: config error count["..v.count.."]")
			end
		end
	end
	
	--记发奖次数
	tTemp[2] = tTemp[2] + 1
	tTemp[4] = nowRewardTimes
	if	"table" == type(tRechargeinfo[nowRewardTimes].reward) then
		for	k,v in pairs(tRechargeinfo[nowRewardTimes].reward) do
			local nIdItem = v["itemid"]
			local nNum = v["itemnum"]
			local timeMode = v["timemode"] or 0
			local time_n = v["time"] or 0

			time_n =System_timeModeTransfer(timeMode,time_n)			

			if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n) then
				System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n)
			end
		end
	end
	
	return ChargeActiveCode.eCAC_Succ
end
--领累计充值奖励
function FirstCharge_ReceiveAccumulateReward(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
			--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity)
	if false == bRet then
		return ChargeActiveCode.eCAC_Unkown
	end
	--取奖励次数
	local IsRecharge,sAwardStatus,rechargeCount = tTemp[_nType],tTemp["str"],tTemp[8]
	local tAwardStatus = System_Split(sAwardStatus,",")
	local nowRewardTimes,topRewardTimes = tonumber(tAwardStatus[2*_nType - 1]),tonumber(tAwardStatus[2*_nType])
	if nowRewardTimes >= topRewardTimes then
		return ChargeActiveCode.eCAC_NoReward
	end

	local key = FirstCharge_GetServerKey(_idCharacter)
	if -9999 == key then
		return ChargeActiveCode.eCAC_NoReward
	end
	
	local tAward = tRechargeInfoMain[key]
	if tAward.isopen ~= 1 then
		return ChargeActiveCode.eCAC_NoStart
	end
	
	local tAwardRecharge = tAward.recharge[1]
	if nowRewardTimes < tAwardRecharge.maxcount then
		nowRewardTimes = nowRewardTimes + 1
	elseif tAwardRecharge.hold == 1 then
		nowRewardTimes = tAwardRecharge.maxcount
	else
		return ChargeActiveCode.eCAC_Unkown
	end
	--处理一下奖励表 
	local tRechargeinfo = {}
	for i,v in pairs(tAwardRecharge.rechargeinfo) do
		if _nType == v.type then
			if nil == tRechargeinfo[v.count] then		
				tRechargeinfo[v.count] = v
			else
				L2C_DebugLog("FirstCharge_ReceiveFirstReward: config error count["..v.count.."]")
			end
		end
	end
	--今日可以领才判断是不是充值额足够
	if IsRecharge == 1 and rechargeCount < tRechargeinfo[nowRewardTimes].needrecharge then
		return ChargeActiveCode.eCAC_LessRecharge
	end
	
	--记发奖次数
	tAwardStatus[2*_nType - 1] = tostring(tonumber(tAwardStatus[2*_nType - 1]) + 1 )
	sAwardStatus = ""
	for i = 1,#tAwardStatus do		
		sAwardStatus = sAwardStatus .. tAwardStatus[i]
		if i ~= #tAwardStatus then
			sAwardStatus = sAwardStatus ..","
		end
	end
		
	-- L2C_DebugLog("FirstCharge_ReceiveFirstReward: awardStatus["..tTemp["str"].."]")
	tTemp["str"] = sAwardStatus
	if	"table" == type(tRechargeinfo[nowRewardTimes].reward) then
		for	k,v in pairs(tRechargeinfo[nowRewardTimes].reward) do
			local nIdItem = v["itemid"]
			local nNum = v["itemnum"]
			local timeMode = v["timemode"] or 0
			local time_n = v["time"] or 0

			time_n =System_timeModeTransfer(timeMode,time_n)			

			if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n) then
				System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n)
			end
			if k == 1 then
				FirstCharge_SendBroadCast(_idCharacter,_nType,nIdItem,nNum)
			end
		end
	end
	
	--if 0 == System_GetTempData(_idCharacter,nLuaIdActivityTeam,3) then
	--	System_SetTempData(_idCharacter,nLuaIdActivityTeam,3,1)
	--	local nGlobalDay = System_GetGlobalData(nLuaIdActivityTeam,1)
	--	if tostring(nGlobalDay) == os.date("%y%m%d",os.time()) then
	--		System_SetGlobalData(nLuaIdActivityTeam,2,System_GetGlobalData(nLuaIdActivityTeam,2) + 1)
	--		System_Syn_Teamrecharge(_idCharacter,System_GetGlobalData(nLuaIdActivityTeam,2),0,"",true)
	--	end
	--end
    Teamrecharge_AchieveToday(_idCharacter,os.time())

	return ChargeActiveCode.eCAC_Succ
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家充值接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FirstCharge_OnRecharge(_idCharacter,_nEmoney,_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity)
	if false == bRet then return end


	--更新累计充值的状态
	--===============================
	local key = FirstCharge_GetServerKey(_idCharacter)
	if -9999 == key then
		return
	end	
	local tAward = tRechargeInfoMain[key]
	local tAwardRecharge = tAward.recharge[1]

	local sAwardStatus = tTemp["str"]
	local tAwardStatus = System_Split(sAwardStatus,",")
	
	tTemp[8] = tTemp[8] + _nEmoney
	--处理一下奖励表 
	local tRechargeinfo = {}
	for i,v in pairs(tAwardRecharge.rechargeinfo) do
		tRechargeinfo[v.type] = tRechargeinfo[v.type] or {}
		if nil == tRechargeinfo[v.type][v.count] then		
			tRechargeinfo[v.type][v.count] = v
		else
			L2C_DebugLog("FirstCharge_ReceiveFirstReward: config error count["..v.count.."]")
		end
	end	
	
	for i,v in pairs (tRechargeinfo) do
		if tTemp[i] == 0 then
			tAwardStatus[2*i-1] = tAwardStatus[2*i-1] or "0"
			tAwardStatus[2*i] = tAwardStatus[2*i] or "0"
			local nowRewardTimes = tonumber(tAwardStatus[2*i-1])
			if nowRewardTimes < tAwardRecharge.maxcount then
				nowRewardTimes = nowRewardTimes + 1
			elseif tAwardRecharge.hold == 1 then
				nowRewardTimes = tAwardRecharge.maxcount
			else
				return ChargeActiveCode.eCAC_Unkown
			end
			if  tTemp[8]>= v[nowRewardTimes].needrecharge then 
				tTemp[i] = 2
				tAwardStatus[2*i] = tostring(tonumber(tAwardStatus[2*i]) + 1)
				-- L2C_DebugLog((2*i).."|"..tAwardStatus[2*i])
			end
		end
	end
	sAwardStatus = ""
	for i = 1,#tAwardStatus do		
		sAwardStatus = sAwardStatus .. tAwardStatus[i]
		if i ~= #tAwardStatus then
			sAwardStatus = sAwardStatus ..","
		end
	end
	tTemp["str"] = sAwardStatus
	--更新一遍 给记录经分
	tTemp.Update()
	for i,v in pairs (tRechargeinfo) do
		if tTemp[i] == 2 then
			tTemp[i] = 1
		end
	end
	tTemp.Update()

	--===============================
end
table.insert(tOnUserRechargeEmoney,FirstCharge_OnRecharge)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入时候，检查掩码是否存在，并创建
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FirstCharge_OnLogin(_idCharacter,_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity)
		
		local key = FirstCharge_GetServerKey(_idCharacter)
		if -9999 == key then
			return
		end	
		local tAward = tRechargeInfoMain[key]
		local tAwardRecharge = tAward.recharge[1]
		--处理一下奖励表 
		local tRechargeinfo = {}
		for i,v in pairs(tAwardRecharge.rechargeinfo) do
			tRechargeinfo[v.type] = tRechargeinfo[v.type] or {}
			if nil == tRechargeinfo[v.type][v.count] then		
				tRechargeinfo[v.type][v.count] = v
			else
				L2C_DebugLog("FirstCharge_ReceiveFirstReward: config error count["..v.count.."]")
			end
		end
		local strData = ""
		for i = 1,#tRechargeinfo do
			strData = strData.."0,0"
			if i ~= #tRechargeinfo then
				strData = strData .. ","
			end
		end
		System_SetTempDataStr(_idCharacter,nLuaIdActivity,strData)
	end	
end
table.insert(tOnLoginActivity,FirstCharge_OnLogin)

-- /////////////////////////////////////////////////////////////////////////////////
--	0点刷新充值
-- /////////////////////////////////////////////////////////////////////////////////
function FirstCharge_ZeroRefresh(_idCharacter,_nOsTimes)	
		--取掩码
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity)
	if false == bRet then return end
	for i = 1,8 do
		tTemp[i] = 0
	end
	tTemp.Update()
end
table.insert(tOnZeroTrigger,FirstCharge_ZeroRefresh)
-- /////////////////////////////////////////////////////////////////////////////////
--	取对应的活动KEY
-- /////////////////////////////////////////////////////////////////////////////////
function FirstCharge_GetServerKey(_idCharacter)
	local combineTime
	if false == System_IsCrossSever() then
		combineTime = System_GetCombinedTimes()
	else
		combineTime = System_GetCombinedTimesByCharacter(_idCharacter)
	end

	local key = -9999
	for k,v in pairs(tRechargeInfoMain) do
		if -1 == v.servernum and -9999 == key then
			key = k
		end
		if combineTime == v.servernum then
			key = k
			break
		end		
	end
	return key
end

function FirstCharge_SendBroadCast(_idCharacter,_nType,_nItem,_nNum)
	for i,v in pairs(tRechargeNotice) do
		if "number" == type(v["type"]) and _nType == v["type"] then
			if "number" == type( v["noticeid"]) then
				local sParam = string.format("%d,%u;%d,%s;%d,%d;%d,%d;%d,%d"
								,ePreparedStatementValueType.TYPE_UI64,_idCharacter
								,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)									
								,ePreparedStatementValueType.TYPE_UI32,_nItem						
								,ePreparedStatementValueType.TYPE_UI32,_nNum						
								,ePreparedStatementValueType.TYPE_UI32,1
								)
				System_SendCommonBroadCastMsg(v["noticeid"],sParam)
			end
		end
	end
end