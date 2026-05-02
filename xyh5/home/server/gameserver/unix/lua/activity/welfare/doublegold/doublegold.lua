
-- ////////////////////////// 领取 奖励的回码
 eDoubleGold_RetCode = {
	eRC_Success = 0,				-- 成功
	eRC_Null = 1,					-- 未知错误
	eRC_NoRechargeEnough = 2,	-- 自己的充值金额不够
	eRC_NoEnoughTime = 3,			-- 抽奖次数不足
	eRC_NoEnoughEmoney = 4,			-- 剩余金币不足
	eRC_NoActiveOpen = 5,			-- 活动未开启
}


local nResId = CRESOURCEFLOWACTION.eFT_DoubleGold			-- 资源流向id
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]			-- 活动掩码id / 全局掩码表中的 id
-- local nFunctionId = _double_gold_Info["root"][1]["open"][1]["functionid"]
-- local tDoubleGold_Info = _double_gold_Info["root"][1]["secondary"]
local tServerInfo = _double_gold_Info["root"][1]["sever"]
local nOpenFuncId = _double_gold_Info["root"][1]["functionid"][1]["functionid"]
-- local nOpenDayInfo = _double_gold_Info["root"][1]["openday"][1]
local tNotice = _double_gold_Info["root"][1]["lvupnotice"][1] 

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function DoubleGold_Login(_idCharacter,_nOsTimes)	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)		
	end
	DoubleGold_SendActiveStatus(_idCharacter,_nOsTimes)
	DoubleGold_Syn_All(_idCharacter)
end
table.insert(tOnLoginActivity,DoubleGold_Login)
table.insert(tOnLoginActivity_Cross,DoubleGold_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function DoubleGold_ZeroRefresh(_idCharacter,_nOsTimes)	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)		
	else
		--System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
		--System_SetTempData(_idCharacter,nLuaIdActivity,2,0,false)
	end
	DoubleGold_SendActiveStatus(_idCharacter,_nOsTimes)
	DoubleGold_Syn_All(_idCharacter)
end
table.insert(tOnZeroTrigger,DoubleGold_ZeroRefresh)

-- /////////////////////////////////////
--	data1 : 充值数
--	data2 : 已抽奖数
-- /////////////////////////////////////

function DoubleGold_Recharge(_idCharacter,_nEmoney,_nOsTimes)
	local nHadRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	nHadRechargeNum = nHadRechargeNum + _nEmoney
	System_SetTempData(_idCharacter,nLuaIdActivity,1,nHadRechargeNum,false)
	DoubleGold_Syn_All(_idCharacter)
end
table.insert(tOnUserRechargeEmoney,DoubleGold_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,DoubleGold_Recharge)

-- ===================================================
--	发送消息给玩家
-- ===================================================
function DoubleGold_Syn_All(_idCharacter)
	local selfRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local drawtimes = System_GetTempData(_idCharacter,nLuaIdActivity,2)

	System_Syn_DoubleGold(_idCharacter,selfRecharge,drawtimes)
end



-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取奖励  就是抽奖
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function DoubleGold_GetRewardReq(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	if false == DoubleGold_CheckActiveOpen(_idCharacter) then
		System_Syn_DoubleGold_DrawRet(_idCharacter,eDoubleGold_RetCode.eRC_NoActiveOpen,0,0,0)
		return eDoubleGold_RetCode.eRC_NoActiveOpen		
	end

	local code,nDrawTimes,nMultiple,nMultipleNum = DoubleGold_Draw(_idCharacter)
	System_Syn_DoubleGold_DrawRet(_idCharacter,code,nDrawTimes,nMultiple,nMultipleNum)
	
	-- L2C_DebugLog("DoubleGold_GetRewardReq:"..code)
	return code;
end
tOnOnAcitveAward[nResId] = DoubleGold_GetRewardReq
tOnOnAcitveAward_Cross[nResId] = DoubleGold_GetRewardReq

function DoubleGold_Draw(_idCharacter)
	local nServerKey = DoubleGold_GetServerNumKey(_idCharacter)
	if nServerKey == nil then
		return eDoubleGold_RetCode.eRC_Null
	end
	local nRecharge = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nDrawTimes = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	
	local tDoubleGold_Info = tServerInfo[nServerKey]["secondary"]
	
	if nDrawTimes < 0 or nRecharge < 0 then
		return eDoubleGold_RetCode.eRC_Null
	end
	
	if nil == tDoubleGold_Info[nDrawTimes + 1] then
		return eDoubleGold_RetCode.eRC_NoEnoughTime
	end
	
	if nRecharge < tDoubleGold_Info[nDrawTimes + 1].recharge then
		return eDoubleGold_RetCode.eRC_NoRechargeEnough
	end
	
	if false == System_SpendEmoney(_idCharacter,tDoubleGold_Info[nDrawTimes + 1].cost,nResId)	then
		-- L2C_DebugLog("tDoubleGold_Info[nDrawTimes + 1].cost:"..tDoubleGold_Info[nDrawTimes + 1].cost)
		return eDoubleGold_RetCode.eRC_NoEnoughEmoney
	end
	
	local Allweights = 0
	for i,v in ipairs(tDoubleGold_Info[nDrawTimes + 1]["random"]) do
		if v.weights == "" then
			v.weights = 0
		end
		Allweights = Allweights + v.weights
	end
	local nRan = math.random(1,Allweights)
	local nMultipleIndex,nMultiple = 0,0
	for i = 1,#tDoubleGold_Info[nDrawTimes + 1]["random"] do
		if nRan > tDoubleGold_Info[nDrawTimes + 1]["random"][i].weights then
			nRan = nRan - tDoubleGold_Info[nDrawTimes + 1]["random"][i].weights
		else
			nMultipleIndex,nMultiple = i,tDoubleGold_Info[nDrawTimes + 1]["random"][i].multiple
			break
		end
	end
	
	System_SetTempData(_idCharacter,nLuaIdActivity,2,nDrawTimes + 1)
	local addnum = math.ceil(tDoubleGold_Info[nDrawTimes + 1].cost * nMultiple / 10000)
	
	System_AwardEmoney(_idCharacter,addnum,nResId)
	-- System_AwardVouchers(_idCharacter,addnum,nResId)
	--  完全没得抽就关闭活动入口
	if tDoubleGold_Info[nDrawTimes + 2] == nil then
		DoubleGold_SendActiveStatus(_idCharacter)
	end	
	DoubleGold_SendBroadCast(_idCharacter,nMultiple)
	return eDoubleGold_RetCode.eRC_Success,nDrawTimes + 1,nMultipleIndex,nMultiple
end
--检测活动是否开启
function DoubleGold_CheckActiveOpen(_idCharacter)
	local nServerKey = DoubleGold_GetServerNumKey(_idCharacter)

	if nServerKey == nil then
		return false
	end	
	
	if 0 ~= System_OpenGuideFunction(_idCharacter,nOpenFuncId) then
		return false
	end
	
	local nOpenDay
	if System_IsCrossSever() then
		nOpenDay = System_GetOpenServerDayByCharacter(_idCharacter)
	else
		nOpenDay = System_GetOpenServerDay()
	end
	
	 local tOpenDayInfo = tServerInfo[nServerKey]["openday"][1]
	 if not(nOpenDay >= tOpenDayInfo.openday and nOpenDay < tOpenDayInfo.openday + tOpenDayInfo.down ) then
		return false
	 end	 
	 -- L2C_DebugLog("DoubleGold_CheckActiveOpen:: nOpenDay".. nOpenDay)
	 return true
end

--发送活动状态给客户端
function DoubleGold_SendActiveStatus(_idCharacter,_nOsTimes)
	if false == System_OpenGuideFunction(_idCharacter,nOpenFuncId) then
		return
	end
	
	local nServerKey = DoubleGold_GetServerNumKey(_idCharacter)
	if nServerKey == nil then
		return 
	end	

	if false == DoubleGold_CheckActiveOpen(_idCharacter) then
		System_SendActiveStatus(_idCharacter,nResId,0,0,0);
		return
	end
	local nDrawTimes = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local tDoubleGold_Info = tServerInfo[nServerKey]["secondary"]
	--没有下一个抽奖
	if tDoubleGold_Info[nDrawTimes  + 1] == nil then
		System_SendActiveStatus(_idCharacter,nResId,0,0,0);
		return
	end
	
	local nOpenDay
	if System_IsCrossSever() then
		nOpenDay = System_GetOpenServerDayByCharacter(_idCharacter)
	else
		nOpenDay = System_GetOpenServerDay()
	end

	local status = 1
	local nEnd = 0

	local tData = os.date("*t",_nOsTimes)
	tData["hour"] = 0
	tData["min"] = 0
	tData["sec"] = 0
	--都是持续一天的
	local tOpenDayInfo = tServerInfo[nServerKey]["openday"][1]
	nEnd = os.time(tData) + 24 * 3600 * (tOpenDayInfo.openday + tOpenDayInfo.down - nOpenDay )
	System_SendActiveStatus(_idCharacter,nResId,status,0,nEnd);	
end
--升级时触发一次登录 用于开启功能
function DoubleGold_LevelUp(_idCharacter,_old,_new)	
	if 0 ~= System_OpenGuideFunction(_idCharacter,nOpenFuncId) then
		return false
	end
	DoubleGold_Login(_idCharacter,_nOsTimes)	
end
--发放广播
function DoubleGold_SendBroadCast(_idCharacter,_nMultiple)
	local nNeedMultiple = tNotice.multiple
	local nBroadCastId = tNotice.notice
	
	if "number" == type(nNeedMultiple) and _nMultiple >= nNeedMultiple then
		local sParam = string.format("%d,%u;%d,%s;%d,%d"
									,ePreparedStatementValueType.TYPE_UI64,_idCharacter
									,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)									
									,ePreparedStatementValueType.TYPE_UI32,_nMultiple
									)
		System_SendCommonBroadCastMsg(nBroadCastId,sParam)
	end
end

function DoubleGold_GetServerNumKey(_idCharacter)
	local nKey = nil
	
	local nCombined
	if System_IsCrossSever() then
		nCombined = System_GetCombinedTimesByCharacter(_idCharacter)
	else
		nCombined = System_GetCombinedTimes()
	end
	
	for k,v in pairs(tServerInfo) do
		if v.servernum == -1 and nKey == nil then
			nKey = k
		end
		if v.servernum == nCombined then
			nKey = k
		end
	end
	return nKey
end