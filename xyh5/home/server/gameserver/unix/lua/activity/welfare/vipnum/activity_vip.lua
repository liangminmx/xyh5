eActivityVipNumMsgcode = {
	eActivityVipNumMC_Unknow = 0,
	eActivityVipNumMC_Success = 1,
	eActivityVipNumMC_HadGet = 2,		-- 已领取
	eActivityVipNumMC_Uncomplete = 3,	-- 未达成
	eActivityVipNumMC_BagFull = 4,		-- 背包满
	eActivityVipNumMC_ErrorId = 5,		-- 错误的ID
	eActivityVipNumMC_LessLevel = 6,
	eActivityVipNumMC_LessVipLevel = 7,-- 自己的vip等级不够
}
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	在掩码中，
--	nDtat1 为 按照 位 存的int，表示对应位置的奖励的领取状态
-- nData2 为 要读取几位(即使配置了多少个奖励)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local nResId = CRESOURCEFLOWACTION.eFT_ActivityVipNum
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local functionId = _active_vipnum_Info["root"][1]["functionid"][1]["functionid"]
local tActive_VipNum = _active_vipnum_Info["root"][1]["vipnum"]


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	主要功能是新号第一次登入的时候，为该号创建一个掩码
--	Note：永久活动，不需要删除该掩码
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_VipNum(_idCharacter,_nOsTimes)
	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity)
	end
	local nRewardNum = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	
	-- 防止活动中活动奖励个数改变
	local nRewardNums = (#tActive_VipNum)
	if	nRewardNum ~= nRewardNums then
		System_SetTempData(_idCharacter,nLuaIdActivity,2,nRewardNums)
	end
end
table.insert(tOnLoginActivity,OnLogin_VipNum)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取vip数量福利反馈的奖励的请求包
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessActivityVipNumRewardReq(_idCharacter,_nCActionType,_nIdReward,_nData4,_nData5)
	if	nil == _idCharacter or nil == _nCActionType or _nIdReward == nil then
		L2C_DebugLog("::ProcessGetOpenFBRewardReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nIdReward or "nil")..")")
		return eActivityVipNumMsgcode.eActivityVipNumMC_Unknow
	end
	
	if	_nCActionType ~= nResId then
		return eActivityVipNumMsgcode.eActivityVipNumMC_Unknow
	end
		
	-- 判断是否领取过奖励了
	local tRewardState = VipNum_GetRewardState(_idCharacter,nLuaIdActivity)
	if	nil == tRewardState[_nIdReward] then
		-- L2C_DebugLog("::ProcessActivityVipNumRewardReq not reward Data !, IdReward: ".._nIdReward)
		return eActivityVipNumMsgcode.eActivityVipNumMC_ErrorId
	end
	
	if	true == tRewardState[_nIdReward] then
		-- L2C_DebugLog("::ProcessActivityVipNumRewardReq have getted reward !")
		return eActivityVipNumMsgcode.eActivityVipNumMC_HadGet
	end

	-- 判断该服务器的 指定vip人数够不够
	local nNeedVipLev = tActive_VipNum[_nIdReward]["viplev"]
	local nNeedVipNum = tActive_VipNum[_nIdReward]["vipnum"]
	local nSuitVipNum = System_GetVipPlayerNum(nNeedVipLev)
	
	if	nSuitVipNum < nNeedVipNum then
		return eActivityVipNumMsgcode.eActivityVipNumMC_Uncomplete
	end
	
	local nMyVipLev = System_GetVipLevel(_idCharacter)
	
	-- 是否达到领取奖励的vip等级了
	local nCanGetVipLevel = tActive_VipNum[_nIdReward]["playerviplev"] or 0
	if	nMyVipLev < nCanGetVipLevel then
		return eActivityVipNumMsgcode.eActivityVipNumMC_LessVipLevel
	end
	
	-- 计算奖励是否翻倍
	local nRewardMulti = 1
	if	nMyVipLev >= tActive_VipNum[_nIdReward]["vipmultiple"] then
		nRewardMulti = nRewardMulti * tActive_VipNum[_nIdReward]["multiple"]
	end
	
	-- 设置领奖成功
	local rewardStateSign = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	rewardStateSign = WCBit.SetTrue(rewardStateSign,_nIdReward)
	
	if 	true == System_SetTempData(_idCharacter,nLuaIdActivity,1,rewardStateSign) then
		-- 发放奖励
		Send_Reward_VipNum(_idCharacter,_nIdReward,nRewardMulti)
		return eActivityVipNumMsgcode.eActivityVipNumMC_Success
	else
		L2C_DebugLog("::ProcessActivityVipNumRewardReq Mask Error")
		return eActivityVipNumMsgcode.eActivityVipNumMC_Unknow
	end
	
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = ProcessActivityVipNumRewardReq

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	c++ 找lua要数据的函数
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessVipNumSendToC(_idCharacter,_nCActionType,_nIdReward,_nGet,_nData5)
	if	_nCActionType ~= nResId then
		return -1
	end
	
	if	"number" == type(tActive_VipNum[_nIdReward]["viplev"]) then
		return tActive_VipNum[_nIdReward]["viplev"]
	end
	
	return -1
end
-- 插入到 获取数据函数表中
tGetActivityData[nResId] = ProcessVipNumSendToC
-- ==================================================
--	获取领取奖励的状态
-- ==================================================
function VipNum_GetRewardState(_idCharacter,_nLuaIdActivity)
	local rewardStateSign = System_GetTempData(_idCharacter,_nLuaIdActivity,1)
	local nRewardNum = System_GetTempData(_idCharacter,_nLuaIdActivity,2)
	local tRewardState = {}
	
	for	i = 1,nRewardNum,1 do
		local bState = WCBit.GetBit(rewardStateSign,i)
		tRewardState[i] = bState
	end
	return tRewardState
end

-- ==================================================
--	发放奖励
-- ==================================================
function Send_Reward_VipNum(_idCharacter,_nRewardId,_nMultiple)

	if	"table" == type(tActive_VipNum[_nRewardId]) then
		local tData = tActive_VipNum[_nRewardId]
		
		if	"number" == type(tData["exp"]) and tData["exp"] > 0 then
			local nExp = tData["exp"] * _nMultiple
			System_AwardExp(_idCharacter,nExp,nResId)
		end
		
		if	"number" == type(tData["money"]) and tData["money"] > 0 then
			local nMoney = tData["money"] * _nMultiple
			System_AwardMoney(_idCharacter,nMoney,nResId)
		end
		
		if	"number" == type(tData["emoney2"]) and tData["emoney2"] > 0 then
			local nEmoney2 = tData["emoney2"] * _nMultiple
			System_AwardEmoney(_idCharacter,nEmoney2,nResId)
		end
		
		if	"table" == type(tData["itemreward"]) then
			for	k,v in pairs(tData["itemreward"]) do
				local nItemId = v["itemid"]
				local nNum = v["num"]
				nNum = nNum * _nMultiple
				if	false == System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum) then
					System_AwardThingQuestContainer(_idCharacter,nResId,nItemId,nNum)
				end
			end
		end
		
	else
		-- 这里不应该走到的！
		L2C_DebugLog("::Send_Reward_VipNum Error, nRewardId: ".._nRewardId..",nMultiple: ".._nMultiple)
	end
end