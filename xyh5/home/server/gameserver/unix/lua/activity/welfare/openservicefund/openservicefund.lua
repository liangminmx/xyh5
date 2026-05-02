local eOSFMsgcode = {
	eOSFMC_Null = 0,					-- 内部错误
	eOSFMC_Success	= 1,				-- 成功
	eOSFMC_Param	= 2,				-- 消息参数错误
	eOSFMC_NotBuy	= 3,				-- 没有购买对应基金
	eOSFMC_HadGet	= 4,				-- 已经领取
	eOSFMC_NoReward	= 5,			-- 未达到领取条件
	eOSFMC_BagFull	= 6,				-- 背包已满
	eOSFMC_BagErr	= 7,				-- 添加物品失败
	eOSFMC_HadBuy	= 8,				-- 已经购买了指定基金
	eOSFMC_End		= 9,				-- 活动已结束
	eOSFMC_LevelLow	= 10,			-- 等级不足
	eOSFMC_NoEMoney	= 11,			-- 元宝不足
	eOSFMC_SecurityLocked = 12,	-- 安全锁定
	eOSFMC_RechargeDaily = 13, 	-- 每日充值的金额不足
}
	
local eOSFStatus = { 	-- 开服基金活动状态
	eOSF_End	= 0,		-- 结束,也不能领取奖励
	eOSF_Start	= 1,		-- 开启状态
	eOSF_Hold	= 2,		-- 结束,但是可以领取奖励
}

local eOSFRewardStatus = {		-- 基金奖励领取状态
	eOSFReward_UnGet = 0,		-- 还未领取
	eOSFReward_HadGet = 1,	-- 已经领取
	eOSFReward_NoReward = 2,	-- 还未满足领取条件
}

local OSF_MAX_REWARD_COUNT = 8	--  基金的最大奖励个数

local eOSF_Type = {
	eOSFT_1 = 1,	-- 天才基金
	eOSFT_2 = 2,	-- 超凡基金
	eOSFT_3 = 3,	-- 成神基金
}

local nResId = CRESOURCEFLOWACTION.eFT_OpenServiceFund
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tOpenFund_Data = _openservicefund_Info["root"][1]["openday"]

-- =================================================================
-- 根据服务器次数获得可用的数据
-- =================================================================
function Fund_getServerNum(_nServerNum)
	
	local nDefaultServerNum = -1
	local nDefaultServerKey	
	
	for	k,v in pairs(tOpenFund_Data) do
		if	_nServerNum == v["servernum"] then
			return k
		end
		if	nDefaultServerNum == v["servernum"] then
			nDefaultServerKey = k
		end
	end
	return nDefaultServerKey
end

-- =================================================================
--	根据 FundId 找到在表里的位置
-- =================================================================
function FindKey_Fund(_nServerKey,_nFundid)
	for	k,v in pairs(tOpenFund_Data[_nServerKey]["fund"]) do
		if	_nFundid == v["fundid"] then
			return k
		end
	end	
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取奖励
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Get_Reward_Req_Fund(_idCharacter,_nCActionType,_nFundid,_nRewardIndex,_nData5)
	if	nil == _idCharacter or nil == _nCActionType or nil == _nFundid or nil == _nRewardIndex or nil == _nData5 then		
		L2C_DebugLog("::Get_Reward_Req_Fund Error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nFundid or "nil").."|"..(_nRewardIndex or "nil").."|"..(_nData5 or "nil")..")")
		return eOSFMsgcode.eOSFMC_Null
	end

	if	nResId ~= _nCActionType then
		L2C_DebugLog("::Get_Reward_Req_Fund Error _nCActionType:".._nCActionType)
		return eOSFMsgcode.eOSFMC_Null
	end
	
	if	_nRewardIndex > OSF_MAX_REWARD_COUNT then
		L2C_DebugLog("::Get_Reward_Req_Fund Error _nRewardIndex:".._nRewardIndex)
		return eOSFMsgcode.eOSFMC_Param
	end
	
	-- 找不到奖励配置
	local nServerNum = System_GetCombinedTimes()
	local nServerKey = Fund_getServerNum(nServerNum)
	local nFundKey = FindKey_Fund(nServerKey,_nFundid)
	if	nil == nFundKey then
		L2C_DebugLog("::Get_Reward_Req_Fund not _nFundid: ".._nFundid)
		return eOSFMsgcode.eOSFMC_Null
	end
	if	"table" ~= type(tOpenFund_Data[nServerKey]) or
		"table" ~= type(tOpenFund_Data[nServerKey]["fund"][nFundKey]) or
		"table" ~= type(tOpenFund_Data[nServerKey]["fund"][nFundKey]["reward"][_nRewardIndex]) then
	
		L2C_DebugLog("::Get_Reward_Req_Fund Lua Data Error nServerKey:"..nServerKey..",nFundKey is:"..nFundKey..",_nRewardIndex is:".._nRewardIndex)
		return eOSFMsgcode.eOSFMC_Null
	end
	
	
	SendReward_Fund(_idCharacter,nServerKey,nFundKey,_nRewardIndex)
	return eOSFMsgcode.eOSFMC_Success
	
end
-- tOnOnAcitveAward[nResId] = Get_Reward_Req_Fund

-- =================================================================
-- 发放奖励
-- =================================================================
function SendReward_Fund(_idCharacter,_nServerKey,_nFundKey,_nRewardIndex)

	if	"table" == type(tOpenFund_Data[_nServerKey]["fund"][_nFundKey]["reward"][_nRewardIndex]) then
		
		local tRewardData = tOpenFund_Data[_nServerKey]["fund"][_nFundKey]["reward"][_nRewardIndex]
		
		local nItemId = tRewardData["itemid"]
		local nNum = tRewardData["num"]
		if	false == System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum) then
				System_AwardThingQuestContainer(_idCharacter,nResId,nItemId,nNum)
		end
		
		if	"number" == type(tRewardData["bindemoney"]) and tRewardData["bindemoney"] > 0 then
			System_AwardVouchers(_idCharacter,tRewardData["bindemoney"],nResId)
		end
		
	else
		-- 不应该走到这里
		L2C_DebugLog("::SendReward_Fund Error (".._idCharacter.."|".._nServerKey.."|".._nFundKey.."|".._nRewardIndex..")")
	end
end

-- =================================================================
--	登录处理  发送活动状态给客户端
-- =================================================================
function Fund_Login(_idCharacter,_nOsTimes)
	local nKey = Fund_getServerNum()
	if "table" ~= type(tOpenFund_Data[nKey]["open"]) then
		L2C_DebugLog("::KaiFuYunGou_Login Error Lua Data nKey: "..nKey)
	end
	local tActiveData = tOpenFund_Data[nKey]["open"][1]
	local nOpenday = System_GetOpenServerDay()
	local status = nOpenday <= (tActiveData.days + tActiveData.openday - 1) and 1 or 0
	local nEnd = 0
	if status == 1 then
		local tData = os.date("*t",_nOsTimes)
		tData["hour"] = 0
		tData["min"] = 0
		tData["sec"] = 0
		nEnd = os.time(tData) + (tActiveData.days + tActiveData.openday - nOpenday) * 24 * 3600
	end
	System_SendActiveStatus(_idCharacter,nResId,status,0,nEnd);
end
-- table.insert(tOnLoginActivity,Fund_Login)
--0点刷新跟登录处理一样
function Fund_ZeroReset(_idCharacter,_nOsTime)
	Fund_Login(_idCharacter,_nOsTimes)
end
-- table.insert(tOnZeroTrigger,Fund_ZeroReset)