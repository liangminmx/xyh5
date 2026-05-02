local eOnlineRewardMsgCode = {
	eORMC_UnKnownError = 0,			-- 未知错误
	eORMC_Success = 1,					-- 成功
	eORMC_MessageErr = 2,				-- 消息格式不匹配
	eORMC_NotFoundCharacter = 3,	-- 未找到角色
	eORMC_CannotGetReward = 4,		-- 未达领奖时间
	eORMC_PutBagFailder = 5,			-- 放入背包失败
	eORMC_GetAll = 6,						-- 已全部领取
}

local nResId = CRESOURCEFLOWACTION.eFT_OnlineReward
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local nOpenLev = _timelottery_Info["root"][1]["timeLottery"][1]["openlev"]
local tTimeLottery_Data = _timelottery_Info["root"][1]["items"]

-- /////////////////////////////////////////////////////////////////////////////////
--	活动掩码中：
--		nData8	为 online time，是今天前几次登入累计的登入时间
--		nData1 ~ nData5 是 配置的，value = -1，说明还没领取该奖励
-- /////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家新账号第一个等入的时候，为他创建一个该活动的掩码
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_OnLineReward(_idCharacter,_nOsTimes)
	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity)
		OnLineReward_ResetData(_idCharacter,nLuaIdActivity)	-- 创建之后重置一次
	end
end
table.insert(tOnLoginActivity,OnLogin_OnLineReward)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	在线奖励 0 点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLineReward_ZeroRefresh(_idCharacter,_nOsTimes)
	if	nil == _idCharacter or nil == _nOsTimes then
		L2C_DebugLog("::OnLineReward_ZeroRefresh Error ("..(_idCharacter or "nil").."|"..(_nOsTimes or "nil")..")")
		return
	end

	OnLineReward_ResetData(_idCharacter,nLuaIdActivity)
end
table.insert(tOnZeroTrigger,OnLineReward_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	申请领取在线奖励的包
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Process_Get_OnLineReward_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	local nRewardId = _nData3
	
	local nReturnCode = 0
	if	nil == _idCharacter or nil == _nCActionType then
		L2C_DebugLog("::Process_Get_OnLineReward_Req Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil")..")")
		return eOnlineRewardMsgCode.eORMC_UnKnownError
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::Process_Get_OnLineReward_Req Wrong _nCActionType !")
		return eOnlineRewardMsgCode.eORMC_UnKnownError
	end
	
	

	local nRewardDay = BOnLineReward_Have_All_Reward(_idCharacter,nLuaIdActivity,nRewardId)
	
	if	0 == nRewardDay then
		return eOnlineRewardMsgCode.eORMC_GetAll
	end
	
	-- L2C_DebugLog("::Process_Get_OnLineReward_Req can get nRewardDay: "..nRewardDay)
	-- 判断时间够不够
	local nCurTime =  System_GetCurrentOnLineTime(_idCharacter)
	local nNeedTime =  tTimeLottery_Data[nRewardDay]["lotterytime"]
	if	nCurTime < nNeedTime then
		return eOnlineRewardMsgCode.eORMC_CannotGetReward
	end
	
	-- 发放奖励
	if	true == System_SetTempData(_idCharacter,nLuaIdActivity,nRewardDay,nRewardDay) then
		Send_Reward_OnLineReward(_idCharacter,nRewardDay)
		return eOnlineRewardMsgCode.eORMC_Success
	else
		L2C_DebugLog("::Process_Get_OnLineReward_Req Mask Error !!!")
		return eOnlineRewardMsgCode.eORMC_UnKnownError
	end
	
	
end
tOnOnAcitveAward[nResId] = Process_Get_OnLineReward_Req
-- =================================================
--	重置玩家的登入时间信息
-- =================================================
function OnLineReward_ResetData(_idCharacter,_nLuaIdActivity)
	if	true == System_IsExistTempData(_idCharacter,_nLuaIdActivity) then
		System_SetAllTempData(_idCharacter,_nLuaIdActivity,0,0,0,0,0,0,0,0,"",true)
	end
end

-- =================================================
--	判断玩家本日的登入奖励是否全领取了 
-- =================================================
function BOnLineReward_Have_All_Reward(_idCharacter,_nLuaIdActivity,_nRewardId)
	--local myReward = {}	-- nData1 ~ nData5 对应5个在线时长的奖励
	--myReward[1] = System_GetTempData(_idCharacter,_nLuaIdActivity,1)
	--myReward[2] = System_GetTempData(_idCharacter,_nLuaIdActivity,2)
	--myReward[3] = System_GetTempData(_idCharacter,_nLuaIdActivity,3)
	--myReward[4] = System_GetTempData(_idCharacter,_nLuaIdActivity,4)
	--myReward[5] = System_GetTempData(_idCharacter,_nLuaIdActivity,5)
	--
	--local nNotGetRew = 0;
	--for	i = 1,5,1 do
	--	if	0 == myReward[i] then
	--		nNotGetRew = i
	--		return nNotGetRew
	--	end	
	--end
	--return nNotGetRew
	-- 现在按ID领 ，返回这个ID是不是领过了
	 if 0 ~= System_GetTempData(_idCharacter,_nLuaIdActivity,_nRewardId) then
		_nRewardId = 0
	 end
	 return _nRewardId
end

-- =================================================
--	发放奖励
-- =================================================
function Send_Reward_OnLineReward(_idCharacter,_nKey)
	
	local tReward_Data = tTimeLottery_Data[_nKey]
		
	if	"table" == type(tReward_Data["lotteryPrize"]) then
		for	k,v in pairs(tReward_Data["lotteryPrize"]) do
			local nItemId = v["itemid"]
			local nNum = v["num"]
			local recharge = v["emoney2"] --这里给的金币视为充值
			
			if	nil ~= nItemId then
				if	false == System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum) then
					System_AwardThingQuestContainer(_idCharacter,nResId,nItemId,nNum)
				end
			end
			
			if	nil ~= recharge then
				if "number" == type(recharge) then
					System_Recharge(_idCharacter,recharge)
				end
			end			
			
		end
	end
	
end
