local eJSXFLuaCode = {	-- 活动开启状态返回码
	eJSXFL_Null = 0,
	eJSXFL_CanStar = 1,
	eJSXFL_CanEnd = 2,
}

local eJSXFPlayerStatus = {	-- 领了领取状态
	eJSXFPS_Null = 0,	-- 不能领奖
	eJSXFPS_CanGetKing = 1,	-- 可领取公会长奖励
	eJSXFPS_CanGetMem = 2,	-- 可领取成员奖励
	eJSXFPS_HadGetKing = 3,
	eJSXFPS_HadGetMem = 4,
}

local eJSXFMsgcode = {
	eJSXFMC_Null = 0,
	eJSXFMC_Success = 1,
	eJSXFMC_NoJurisdiction = 1,	-- 没权限
	eJSXFMC_HadGet = 2,	-- 已经领取
	eJSXFMC_BagFull = 3,	-- 背包满
}

local eJSXFRewardType = { -- 想要领取的的奖励
	eJSXFRT_Null   = 0,
	eJSXFRT_King   = 1,
	eJSXFRT_Member = 2,
}

local nResId = CRESOURCEFLOWACTION.eFT_JSXFGetKing
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tFirstcastellan_Info = _firstcastellan_Info["root"][1]["open"]


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 判断本日活动是否开启了
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function JSXF_CheckCanStarOrEnd(_idCharacter,_nCActionType,_nServerNum,_nOpenServerDay,_Data5)
	
	if	nil == _idCharacter or nil == _nCActionType or nil == _nServerNum or nil == _nOpenServerDay then
		L2C_DebugLog("::JSXF_CheckCanEnd Error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nServerNum or "nil").."|"..(_nOpenServerDay or "nil")..")")
		return eJSXFLuaCode.eJSXFL_Null
	end
	
	local nServerKey = JSXF_getServerNum(_nServerNum)
	if	"table" == type(tFirstcastellan_Info[nServerKey]) then
		local nActivityOpenDay = tFirstcastellan_Info[nServerKey]["openday"]
		local nActivityEndDay = tFirstcastellan_Info[nServerKey]["openday"] + tFirstcastellan_Info[nServerKey]["continueday"] - 1
		
		if	_nOpenServerDay >= nActivityOpenDay and _nOpenServerDay <= nActivityEndDay then
			return eJSXFLuaCode.eJSXFL_CanStar	-- 活动正在运行
		end
		
		if	_nOpenServerDay > nActivityEndDay then
			return eJSXFLuaCode.eJSXFL_CanEnd	-- 活动结束
		end
		
	else
		L2C_DebugLog("::JSXF_CheckCanEnd nKey: "..nServerKey.." Data Error !!!")
	end
	return eJSXFLuaCode.eJSXFL_Null
end
tGetActivityData[nResId] = JSXF_CheckCanStarOrEnd

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取奖励
--	@_nRewardType 想要领取的状态
--	@_nGetType 对应奖励的领取状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GetRewardReq_JSXFActivity(_idCharacter,_nCActionType,_nRewardType,_nGetType,_nServerNum)
	
	if	nil == _idCharacter or nil == _nCActionType or nil == _nRewardType or nil == _nGetType or nil == _nServerNum then		
		L2C_DebugLog("::GetRewardReq_JSXFActivity Error ("..(_nRewardType or "nil").."|"..(_nCActionType or "nil").."|"..(_nCharacterType or "nil").."|"..(_nGetType or "nil").."|"..(_nServerNum or "nil")..")")
		return eJSXFMsgcode.eJSXFMC_Null
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::GetRewardReq_JSXFActivity Error _nCActionType (".._nCActionType..") !!!")
		return eJSXFMsgcode.eJSXFMC_Null
	end
	
	if	_nRewardType ~= eJSXFRewardType.eJSXFRT_King and _nRewardType ~= eJSXFRewardType.eJSXFRT_Member then
		L2C_DebugLog("::GetRewardReq_JSXFActivity Error get reward type: ".._nRewardType)
		return eJSXFMsgcode.eJSXFMC_Null
	end
	
	if	_nRewardType == eJSXFRewardType.eJSXFRT_King and _nGetType ~= eJSXFPlayerStatus.eJSXFPS_CanGetKing then
		return eJSXFMsgcode.eJSXFMC_NoJurisdiction	-- 不能领取会长奖励
	end
	
	if	_nRewardType == eJSXFRewardType.eJSXFRT_Member and _nGetType ~= eJSXFPlayerStatus.eJSXFPS_CanGetMem then
		return eJSXFMsgcode.eJSXFMC_NoJurisdiction	-- 不能领取成员奖励
	end
	
	local nKey = JSXF_getServerNum(_nServerNum)
	if	"table" ~= type(tFirstcastellan_Info[nKey]) then
		L2C_DebugLog("::GetRewardReq_JSXFActivity Error Get Woring Lua Data !!! "..nKey)
		return eJSXFMsgcode.eJSXFMC_Null
	end
	
	SendReward_JSXFActivity(_idCharacter,nKey,_nRewardType)
	return eJSXFMsgcode.eJSXFMC_Success
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = GetRewardReq_JSXFActivity
-- =================================================================
--	获得可用的servernum 的数据
-- =================================================================
function JSXF_getServerNum(_nServerNum)
	
	local nDefaultCombine = -1
	
	local nDefaultServerKey = 1
	
	for	k,v in pairs(tFirstcastellan_Info) do
		if	_nServerNum == v["servernum"] then
			return k
		end
		if	nDefaultCombine == v["servernum"] then 
			nDefaultServerKey = k
		end
	end
	return nDefaultServerKey
end

-- =================================================================
--	发放奖励
-- =================================================================
function SendReward_JSXFActivity(_idCharacter,_nKey,_nRewardType)
	if	"table" ~= type(tFirstcastellan_Info[_nKey]) then
		L2C_DebugLog("::SendReward_JSXFActivity Error Data _nKey ".._nKey)
		return
	end
	
	local nResoureTo = 0	-- 资源流向
	local tRewardData = {}
	if	_nRewardType == eJSXFPlayerStatus.eJSXFPS_CanGetKing then
		nResoureTo = CRESOURCEFLOWACTION.eFT_JSXFGetKing	-- 会长奖励的资源流向
		tRewardData = tFirstcastellan_Info[_nKey]["reward"][1]
	elseif	_nRewardType == eJSXFPlayerStatus.eJSXFPS_CanGetMem then
		nResoureTo = CRESOURCEFLOWACTION.eFT_JSXFGetMem
		tRewardData = tFirstcastellan_Info[_nKey]["allreward"][1]	-- 成员奖励的资源流向
	end
	if	"nil" == next(tRewardData) then
		L2C_DebugLog("::SendReward_JSXFActivity Error nil Reward Data !!!")
		return
	end
	
	-- 发放会长的奖励item
	if	nResoureTo == CRESOURCEFLOWACTION.eFT_JSXFGetKing then
			if	"table" == type(tRewardData["rewarditem"]) then
				for	k,v in pairs(tRewardData["rewarditem"]) do
						local nItem = v["itemid"]
						local nNum = v["num"]
						if	false == System_AwardThingInBag(_idCharacter,nResoureTo,nItem,nNum) then
							System_AwardThingQuestContainer(_idCharacter,nResoureTo,nItem,nNum)
						end
				end
			else
				L2C_DebugLog("::SendReward_JSXFActivity Error Reward Item")
			end
	end

	
	-- 发放成员的奖励item
	if	nResoureTo == CRESOURCEFLOWACTION.eFT_JSXFGetMem then
			if	"table" == type(tRewardData["allrewarditem"])   then
				for	k,v in pairs(tRewardData["allrewarditem"]) do
						local nItem = v["itemid"]
						local nNum = v["num"]
						if	false == System_AwardThingInBag(_idCharacter,nResoureTo,nItem,nNum) then
							System_AwardThingQuestContainer(_idCharacter,nResoureTo,nItem,nNum)
						end
				end
			else
				L2C_DebugLog("::SendReward_JSXFActivity Error Reward Item")
			end
	end

	
	if	"number" == type(tRewardData["emoney"]) and tRewardData["emoney"] > 0 then
		System_AwardEmoney(_idCharacter,tRewardData["emoney"],nResoureTo)
	end
	
	if	"number" == type(tRewardData["money"]) and tRewardData["money"] > 0 then
		System_AwardMoney(_idCharacter,tRewardData["money"],nResoureTo)
	end

	if	"number" == type(tRewardData["exp"]) and tRewardData["exp"] > 0 then
		System_AwardExp(_idCharacter,tRewardData["exp"],nResoureTo)
	end
	
	if	"number" == type(tRewardData["point"]) and tRewardData["point"] > 0 then
		System_AwardRealmPoint(_idCharacter,tRewardData["point"],nResoureTo)
	end
	
end
