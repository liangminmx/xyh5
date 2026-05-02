local eRankActivityCode = {
	eRAC_Unkown   = 0,         	-- 未知错误
	eRAC_Success  = 1,         	-- 成功
	eRAC_NoReward = 2,         -- 没有奖励
	eRAC_BagFull  = 3 ,        	-- 背包空间不足,请先清理背包
	eRAC_ReceiveAlreay = 4,    -- 已经领取了该奖励
	eRAC_OutOfHoldingTime = 5, -- 错过了领奖时间
}

-- 排行活动状态
local eRankAcitivityStatus = {
	eRAS_None = 0,	-- 未开启
	eRAS_Start = 1,	-- 开启
	eRAS_Holding = 2,-- 领奖阶段
	eRAS_End = 3,		-- 结束
}

local eGetRewardType = {
	eGRT_All = 1,
	eGRT_Rank = 2,
}

local nResId = CRESOURCEFLOWACTION.eFI_LevelActivityLevelReward
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tLevelReward_Data = _lvreward_Info["root"][1]["open"]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	找lua要该活动开始的状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetActiveOpen_LevelReward(_nData1,_nCActionType,_nData3,_nData4,_nData5)

	if	nil == _nCActionType then
		L2C_DebugLog("::GetActiveOpen_LevelReward Error ("..(_nCActionType or "nil")..")")
		return eRankAcitivityStatus.eRAS_None
	end
	
	if	_nCActionType ~= nResId then
		return eRankAcitivityStatus.eRAS_None
	end	
	
	local nServerKey = GetServerKey_LevelReward()
	if	"table" ~= type(tLevelReward_Data[nServerKey]) then
		L2C_DebugLog("::GetActiveOpen_LevelReward Error Data !!!")
		return eRankAcitivityStatus.eRAS_None
	end
	local tData = tLevelReward_Data[nServerKey]
	
	local nOpenServerDay = System_GetOpenServerDay()
	local nEndDay = tData["openday"] + tData["continueday"] + tData["holdday"]
	local nHoldDay = tData["openday"] + tData["continueday"]
	
	if	nOpenServerDay >= nEndDay then
		return eRankAcitivityStatus.eRAS_End			-- 活动结束
	elseif	nOpenServerDay >= nHoldDay then
		return eRankAcitivityStatus.eRAS_Holding		-- 领奖时间
	elseif	nOpenServerDay >= tData["openday"] then
		return eRankAcitivityStatus.eRAS_Start			-- 活动开始
	end
	return eRankAcitivityStatus.eRAS_End			-- 活动结束
end
tGetActivityData[nResId] = GetActiveOpen_LevelReward
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	收到领取奖励的请求
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetRewardReq_LevelReward(_idCharacter,_nCActionType,_nGetType,_nData4,_nData5)

	if	nil == _idCharacter or nil == _nCActionType or nil == _nGetType then
		L2C_DebugLog("::GetRewardReq_LevelReward Error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nGetType or "nil")..")")
		return eRankActivityCode.eRAC_Unkown
	end
	
	if	_nCActionType ~= nResId then
		return eRankActivityCode.eRAC_Unkown
	end
	
	if	_nGetType == eGetRewardType.eGRT_All then
		return ReceiveLevelActivityJoinReward(_idCharacter,_nCActionType,_nGetType)
	elseif	_nGetType == eGetRewardType.eGRT_Rank then
		return ReceiveLevelActivityRankRewardReq(_idCharacter,_nCActionType,_nGetType,_nData4)
	end
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = GetRewardReq_LevelReward

-- =================================================================
--	申请领取冲级的有排名的等级奖励 eGRT_Rank
-- =================================================================
function ReceiveLevelActivityRankRewardReq(_idCharacter,_nCActionType,_nGetType,_nRank)
	if	_nGetType ~= eGetRewardType.eGRT_Rank then
		L2C_DebugLog("::ReceiveLevelActivityRankRewardReq Error Get Type !!!")
		return
	end
	
	if	nil == _nRank then
		L2C_DebugLog("::ReceiveLevelActivityRankRewardReq Error Rank Num Is Nil")
		return eRankActivityCode.eRAS_None
	end
	
	local nServerKey = GetServerKey_LevelReward()
	if	"table" ~= type(tLevelReward_Data[nServerKey]) then
		L2C_DebugLog("::ReceiveLevelActivityRankRewardReq Error Data !!!")
		return eRankActivityCode.eRAC_Unkown
	end
	local tData = tLevelReward_Data[nServerKey]
	
	
	if	"table" ~= type(tData["rank"][_nRank]) then
		L2C_DebugLog("::ReceiveLevelActivityRankRewardReq Not Rank :".._nRank.." Reward")
		return eRankActivityCode.eRAC_NoReward
	end
	
	-- L2C_DebugLog("::ReceiveLevelActivityRankRewardReq send reward (".._idCharacter.."|".._nRank..")")
	SendReward_LevelReward_Rank(_idCharacter,nServerKey,_nRank)
	return eRankActivityCode.eRAC_Success
end

-- =================================================================
--	申请领取参与达到90级的奖励 eGRT_All
-- =================================================================
function ReceiveLevelActivityJoinReward(_idCharacter,_nCActionType,_nGetType)
	
	if	_nGetType ~= eGetRewardType.eGRT_All then
		L2C_DebugLog("::ReceiveLevelActivityJoinReward Error Get Type !!!")
		return
	end
	
	local nServerKey = GetServerKey_LevelReward()	
	if	"table" ~= type(tLevelReward_Data[nServerKey]) then
		L2C_DebugLog("::ReceiveLevelActivityJoinReward Error Data !!!")
		return eRankActivityCode.eRAC_Unkown
	end
	local tData = tLevelReward_Data[nServerKey]
	
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if	nLevel < tData["all"][1]["lev"] then
		-- L2C_DebugLog("::ReceiveLevelActivityJoinReward not enough level !!!")
		return eRankActivityCode.eRAC_NoReward
	end
	
	-- L2C_DebugLog("::ReceiveLevelActivityJoinReward send reward (".._idCharacter..")")
	SendReward_LevelReward_90(_idCharacter,nServerKey)
	return eRankActivityCode.eRAC_Success
end

-- =================================================================
--	根据合服次数获得奖励信息
-- =================================================================
function GetServerKey_LevelReward()
	local nServerNum = System_GetCombinedTimes()
	local nDefault = -1
	local nDefaultKey
	
	for	k,v in pairs(tLevelReward_Data) do
		if	nServerNum == v["servernum"] then
			return k
		end
		if	nDefault == v["servernum"] then 
			nDefaultKey = k
		end
	end
	return nDefaultKey
end

-- =================================================================
-- 发放参与达到90级奖励
-- =================================================================
function SendReward_LevelReward_90(_idCharacter,_nServerKey)

	if	"table" == type(tLevelReward_Data[_nServerKey]) then
		local tData = tLevelReward_Data[_nServerKey]["all"][1]
		
		if	"table" == type(tData["allrewarditem"]) then
			for	k,v in pairs(tData["allrewarditem"]) do
				local nItem = v["item"]
				local nNum = v["num"]
				if	false == System_AwardThingInBag(_idCharacter,nResId,nItem,nNum) then
					System_AwardThingQuestContainer(_idCharacter,nResId,nItem,nNum)
				end
			end
		end
		
		if	"number" == type(tData["emoney"]) and tData["emoney"] > 0 then
			System_AwardEmoney(_idCharacter,tData["emoney"], nResId)
		end
		
		if	"number" == type(tData["money"]) and tData["money"] > 0 then
			System_AwardMoney(_idCharacter,tData["money"], nResId)
		end
		
		if	"number" == type(tData["exp"]) and tData["exp"] > 0 then
			System_AwardExp(_idCharacter,tData["exp"],nResId)
		end
		
		if	"number" == type(tData["point"]) and tData["point"] > 0 then
			System_AwardRealmPoint(_idCharacter,tData["point"],nResId)
		end
		
	else
		L2C_DebugLog("::SendReward_LevelReward_90 Error NOT FIND nKey:".._nServerKey.." Data !!!")
	end
end

-- =================================================================
--	发放等级奖励有排名的奖励
-- =================================================================
function SendReward_LevelReward_Rank(_idCharacter,_nServerKey,_nRank)

	if	"table" == type(tLevelReward_Data[_nServerKey]["rank"][_nRank]) then
		local tData = tLevelReward_Data[_nServerKey]["rank"][_nRank]
		
		if	"table" == type(tData["reward"]) then
			for	k,v in pairs(tData["reward"]) do
				local nItem = v["item"]
				local nNum = v["num"]
				if	false == System_AwardThingInBag(_idCharacter,nResId,nItem,nNum) then
					System_AwardThingQuestContainer(_idCharacter,nResId,nItem,nNum)
				end
			end
		end
		
		if	"number" == type(tData["emoney"]) and tData["emoney"] > 0 then
			System_AwardEmoney(_idCharacter,tData["emoney"],nResId)
		end
		
		if	"number" == type(tData["money"]) and tData["money"] > 0 then
			System_AwardMoney(_idCharacter,tData["money"],nResId)
		end
		
		if	"number" == type(tData["exp"]) and tData["exp"] > 0 then
			System_AwardExp(_idCharacter,tData["exp"],nResId)
		end
		
		if	"number" == type(tData["point"]) and tData["point"] > 0 then
			System_AwardRealmPoint(_idCharacter,tData["point"],nResId)
		end
		
	else
		L2C_DebugLog("::SendReward_LevelReward_Rank Error NOT FIND nKey:".._nServerKey.." Data !!!")
	end
end
