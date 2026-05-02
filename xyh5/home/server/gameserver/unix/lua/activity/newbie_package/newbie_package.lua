-- /////////////////////////////////////////////////////////////////////////////////
tEnumNewGuildGiftMsgCode = {
	eNewGiftMC_Null = 0,
	eNewGiftMC_Success = 1,	
	eNewGiftMC_HadGet = 2,
	eNewGiftMC_LevelNotEnough = 3,
	eNewGiftMC_BagFreeSpaceNotEnough = 4,
}

local nResId = CRESOURCEFLOWACTION.eFT_NewguildGift
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tNewbie_Info = _newbie_package_Info["config"][1]["package"]

-- /////////////////////////////////////////////////////////////////////////////////
--	Note:
--		活动掩码 data1 字段，放已经领取过的，新手等级奖励的等级
--		如：现在15级，已经领取了10级的等级奖励，数据就是10
-- /////////////////////////////////////////////////////////////////////////////////

-- ===================================================
--	收到申请领取等级奖励的包
-- ===================================================
function ProcessGetLevelRewardReq(_idCharacter,_nCActionType,_nOstime,_nData4,_nData5)
	if	nil == _idCharacter or nil == _nCActionType then
		L2C_DebugLog("::ProcessGetLevelRewardReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nOstime or "nil")..")")
		return tEnumNewGuildGiftMsgCode.eNewGiftMC_Null
	end
	
	-- 活动类型要是同一种
	if	nResId ~= _nCActionType then
		return tEnumNewGuildGiftMsgCode.eNewGiftMC_Null
	end
	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)
	end
	-- 判断有没下一级奖励可以领取
	local nHaveGetRewardSign = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nNextRewardLevel,nKey = GetNextLevelGift(nHaveGetRewardSign)	-- 想要领取的奖励的 等级
	if	nil	== nNextRewardLevel then
		return tEnumNewGuildGiftMsgCode.eNewGiftMC_Null
	end
	
	-- 判断等级够不够领取奖励了
	local nNowLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) or 0
	if	nNowLevel < nNextRewardLevel then
		return tEnumNewGuildGiftMsgCode.eNewGiftMC_LevelNotEnough
	end
	
	-- 发放奖励
	if	true == System_SetTempData(_idCharacter,nLuaIdActivity,1,nNextRewardLevel) then
		Send_Reward_NewBie_Package(_idCharacter,nKey,_nOstime)
		return tEnumNewGuildGiftMsgCode.eNewGiftMC_Success
	else
		L2C_DebugLog("::ProcessGetLevelRewardReq Mask Error !!!")
		return tEnumNewGuildGiftMsgCode.eNewGiftMC_Null
	end
end
-- 插入到触发表中
tOnOnAcitveAward[nResId] = ProcessGetLevelRewardReq

-- ===================================================
--	发放 新手等级大礼包奖励
-- ===================================================
function Send_Reward_NewBie_Package(_idCharacter,_nKey,_nOstime)

	local tReward_Data = tNewbie_Info[_nKey]
	
	if	"number" == type(tReward_Data["money"]) then
		System_AwardMoney(_idCharacter,tReward_Data["money"],nResId)
	end
	
	if	"number" == type(tReward_Data["emoney2"]) then
		System_AwardEmoney(_idCharacter,tReward_Data["emoney2"],nResId)
	end
	
	if	"number" == type(tReward_Data["realmPoint"]) and tReward_Data["realmPoint"] > 0 then
		System_AwardRealmPoint(_idCharacter,tReward_Data["realmPoint"])
	end
	
	-- 发放武器
	if	"table" == type(tReward_Data["equip"]) then
		local nItemCfgID = tReward_Data["equip"][1]["equip"]
		local nNum = tReward_Data["equip"][1]["num"]
		local nStage = tReward_Data["equip"][1]["stage"]
		
		if 	false == System_AwardThingInBag(_idCharacter,nResId,nItemCfgID,nNum,0,0,nStage) then
			System_AwardThingQuestContainer(_idCharacter,nResId,nItemCfgID,nNum,0,0,nStage)
		end
	end
	
	-- 发放item
	if	"table" == type(tReward_Data["item"]) then
		for	k,v in pairs(tReward_Data["item"]) do
			local nItemId = v["item"]
			local nNum = v["num"]
			
			local timeMode = v["timeMode"] or 0
			local time_n = v["expiredtme"] or 0			
			time_n = System_timeModeTransfer(timeMode,time_n,_nOstime)
			
			if	false == System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum,0,0,0,0,timeMode,time_n) then
				System_AwardThingQuestContainer(_idCharacter,nResId,nItemId,nNum,0,0,0,0,timeMode,time_n)
			end
		end
	else
		L2C_DebugLog("::Send_Reward_NewBie_Package [".._nKey.."][item] is not table !")
	end
end

-- ===================================================
--	根据已经领取的奖励的等级，判断还有没有配置更高一级的奖励
--	返回准备要领取的奖励的限制等级和在表中的key，没有返回 nil
-- ===================================================
function GetNextLevelGift(_nHaveGetRewardLevel)
	for	k,v in pairs(tNewbie_Info) do	
		if	v["Level"] > _nHaveGetRewardLevel then
			return v["Level"],k
		end
	end
end