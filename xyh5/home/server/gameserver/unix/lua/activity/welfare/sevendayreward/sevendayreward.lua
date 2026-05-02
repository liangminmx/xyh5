
-- ////////////////////////// 领取 7天登入奖励的回码
local eRetCode = {
	eRC_Success = 0,				-- 成功
	eRC_WrongDay = 1,			-- 错误的时间
	eRC_WrongTarget = 2,		-- 找不到角色
	eRC_CannotReceive = 3,	-- 无法领取
	eRC_PutBagFaild = 4,		-- 放入背包失败
	eRC_Received = 5,			-- 已领取
	eRC_Null = 6,					-- 未知错误
}

local eOpenSevenLoginModule_ReqType =
{
	eOSLMRT_GetReward = 1,       --// 获取奖励
	eOSLMRT_OpenModule = 2,       --// 发送状态请求
}

local nResId = CRESOURCEFLOWACTION.eFT_SevenLogin		-- 资源流向id
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]	-- 活动掩码id
local nFunctionId = _7dayreward_Info["root"][1]["functionid"][1]["functionid"]
local t7Dayreward_Info = _7dayreward_Info["root"][1]["Reward"]
local nOpenLevel = _7dayreward_Info["root"][1]["openlevel"][1]["openlevel"]

--	Note:
--		活动掩码中:
--			data1 是已经等级第几天了
--			data2 是 refreshContinueDayTime 登入的跟新时间
--			data3 是 按位操作 ，存储的，是否领取了奖励

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入游戏的时候，判断是不是有该活动掩码
--	如果没有，就为该活动创建一个掩码
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_SevenDayReward(_idCharacter,_nOsTimes)
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,1,1,false)					--	登入次数
		System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,true)	--	登入时间
	end
	SevenDay_SendActiveStatus(_idCharacter)
end
table.insert(tOnLoginActivity,OnLogin_SevenDayReward)
-- /////////////////////////////////////////////////////////////////////////////////
--	更新 7 日 登入的零点刷新
-- /////////////////////////////////////////////////////////////////////////////////
function OnSevenDayZeroRefresh(_idCharacter,_nOsTimes)
	
	if	nil == _idCharacter or nil == _nOsTimes then
		L2C_DebugLog("::OnSevenDayZeroRefresh Error ("..(_idCharacter or "nil").."|"..(_nOsTimes or "nil")..")")
		return
	end
		
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,1,1,false)					--	登入次数
		System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,true)	--	登入时间
		return
	end
	
	local nContinueTime = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if	nContinueTime >= 7 then
		--这里发是为了关闭活动
		SevenDay_SendActiveStatus(_idCharacter)
		return
	end

	nContinueTime = nContinueTime + 1
	System_SetTempData(_idCharacter,nLuaIdActivity,1,nContinueTime)
	System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes)
	
	SevenDay_SendActiveStatus(_idCharacter)
	
end
table.insert(tOnZeroTrigger,OnSevenDayZeroRefresh)

function ProcessGetSevenDayReq(_idCharacter,_nCActionType,_nIdReward,_nData4,_nReqType)
	if eOpenSevenLoginModule_ReqType.eOSLMRT_GetReward == _nReqType then
		 local nRet = ProcessGetSevenDayRewardReq(_idCharacter,_nCActionType,_nIdReward,_nData4,_nReqType)
		 if nRet == eRetCode.eRC_Success then
			SevenDay_SendActiveStatus(_idCharacter)
		 end
		 return nRet
	end
	if eOpenSevenLoginModule_ReqType.eOSLMRT_OpenModule == _nReqType then
		return ProcessGetSevenDayOpenModuleReq(_idCharacter,_nCActionType,_nData3,_nData4,_nReqType)
	end
	return eRetCode.eRC_Null
end
tOnOnAcitveAward[nResId] = ProcessGetSevenDayReq
-- /////////////////////////////////////////////////////////////////////////////////
--	领取 7 日登入活动的奖励
-- /////////////////////////////////////////////////////////////////////////////////
function ProcessGetSevenDayRewardReq(_idCharacter,_nCActionType,_nIdReward,_nData4,_nReqType)

	if	nil == _idCharacter or nil == _nCActionType or nil == _nIdReward  then
		L2C_DebugLog("::ProcessGetSevenDayRewardReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nIdReward or "nil")..")")
		return eRetCode.eRC_Null
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::ProcessGetSevenDayRewardReq Wrong _nCActionType !")
		return eRetCode.eRC_Null
	end
		
	if	nil == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return eRetCode.eRC_Null	-- 在这里不应该出现数据库里没有数据了！
	end
	
	if	_nIdReward > 7 then
		return eRetCode.eRC_WrongDay
	end
	
	local nContinueTime = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if	_nIdReward > nContinueTime then	-- 要领取的奖励大于已经登入的天数
		return eRetCode.eRC_CannotReceive
	end
	
	local bitGetRewardSign = System_GetTempData(_idCharacter,nLuaIdActivity,3)
	local bHaveGet = WCBit.GetBit(bitGetRewardSign,_nIdReward + 1)
	if	true == bHaveGet then
		return eRetCode.eRC_Received
	end
	
	-- 判断表里配置的改天奖励
	if	"table" ~= type(t7Dayreward_Info[_nIdReward]) then
		L2C_DebugLog("::ProcessGetSevenDayRewardReq Error Data in Data_Info !!!!!!!!!!!!!")
		return eRetCode.eRC_Null
	end
	
	bitGetRewardSign = WCBit.SetTrue(bitGetRewardSign,_nIdReward + 1)
	if	true == System_SetTempData(_idCharacter,nLuaIdActivity,3,bitGetRewardSign) then
		Send_Reward_SevenDayReward(_idCharacter,_nIdReward)
		return eRetCode.eRC_Success
	else
		L2C_DebugLog("ProcessGetSevenDayRewardReq Mask Error")
		return eRetCode.eRC_Null
	end
	
end
-- ===================================================
--	开启功能
-- ===================================================
function ProcessGetSevenDayOpenModuleReq(_idCharacter,_nCActionType,_nData3,_nData4,_nReqType)
	SevenDay_SendActiveStatus(_idCharacter)
	return eRetCode.eRC_Success
end

-- ===================================================
--	发放活动奖励
-- ===================================================
function Send_Reward_SevenDayReward(_idCharacter,_nIdReward)
	
	local tReward_Data = t7Dayreward_Info[_nIdReward]
	
	if	"table" == type(tReward_Data["item"]) then
		for	k,v in pairs(tReward_Data["item"]) do
			local nItemId = v["itemid"]
			local nNum = v["num"]
			local nStrength = v["strengthen"] or 0
			local nStage = v["stage"] or 0
			if	false == System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum,0,0,nStage,nStrength) then
				System_AwardThingQuestContainer(_idCharacter,nResId,nItemId,nNum,0,0,nStage,nStrength)
			end
		end
	else
		L2C_DebugLog("::Send_Reward_SevenDayReward error : [item] is not a table")
	end
	
	if	nil ~= tReward_Data["artifact"] and "string" == type(tReward_Data["artifact"]) and [[]] ~= tReward_Data["artifact"] then
		local nType =  System_GetProfession(_idCharacter)
		local tWeapon_Reward = SevenDay_artifact_Splite(tReward_Data["artifact"])
		if	nil ~= tWeapon_Reward[nType] and "number" == type(tWeapon_Reward[nType]) then
			System_UnlockWeapon(_idCharacter,tWeapon_Reward[nType],eWeaponRewardWay.eWRW_SevenLoginReward)
		else
			L2C_DebugLog("::Send_Reward_SevenDayReward error : [artifact] error nType:"..nType..",day:".._nIdReward)
		end
	end
	
	if	"number" == type(tReward_Data["currency"][1]["money"]) then
		System_AwardMoney(_idCharacter,tReward_Data["currency"][1]["money"],nResId)
	end
	
	if	"number" == type(tReward_Data["currency"][1]["skillpoint"]) then
		System_AddSkillPoint(_idCharacter,tReward_Data["currency"][1]["skillpoint"],nResId)
	end

	if	"number" == type(tReward_Data["currency"][1]["emoney2"]) then
		System_AwardEmoney(_idCharacter,tReward_Data["currency"][1]["emoney2"],nResId)
	end

end

-- ===================================================
-- 拆分 artifact  字段(如果有数据)
--	要么是[[0:1020,1:2020]] -- 代表不同职业给不同的武器
--	要么是[[]]
-- ===================================================
function SevenDay_artifact_Splite(_artifact)
	local tResult = {}
	if	_artifact == nil or _artifact == "" then
		return tResult
	end
	
	local temp = System_Split(_artifact,[[,]])
	for	k,v in pairs(temp) do
		local temp2 = System_Split(v,[[:]])
		local key = tonumber(temp2[1])
		local value = tonumber(temp2[2])
		tResult[key] = value
	end

	return tResult
end

-- ===================================================
-- 发放活动状态
-- ===================================================
function SevenDay_SendActiveStatus(_idCharacter)
	-- L2C_DebugLog("SevenDay_SendActiveStatus"..System_OpenGuideFunction(_idCharacter,nFunctionId))
	if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then
		System_SendActiveStatus(_idCharacter,nResId,0,0,0);	
		return
	end
	local continuedDays = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local rewardStatus = System_GetTempData(_idCharacter,nLuaIdActivity,3)
	local status = 0
	local nEnd = 0
	--先检测有没有下一天
	for k,v in pairs(t7Dayreward_Info) do
		if v.day > continuedDays then
			status = 1
			local tData = os.date("*t",_nOsTimes)
			tData["hour"] = 0
			tData["min"] = 0
			tData["sec"] = 0
			--都是持续一天的
			nEnd = os.time(tData) + 24 * 3600
			break
		end
	end
	--没有下一天 看看是不是有奖励未领
	if status == 0 then
		for k,v in pairs(t7Dayreward_Info)do
			local bHaveGet = WCBit.GetBit(rewardStatus,v.day + 1)
			if	false == bHaveGet then
                status = 1
				break
			end
		end
	end	
	System_SendActiveStatus(_idCharacter,nResId,status,0,nEnd);	
end

-- ===================================================
-- 七日登陆获取数据
-- ===================================================
function SevenDay_GetDataInfo(_idCharacter,_nCActionType,nData3,_nIdReward,_nData5)
	if 1 == nData3 then 
		local bitGetRewardSign = System_GetTempData(_idCharacter,nLuaIdActivity,3)
		if -1 == bitGetRewardSign then
			return -1
		end
		
		if	_nIdReward > 7 or _nIdReward < 1 then
			return -1
		end
		
		local bHaveGet = WCBit.GetBit(bitGetRewardSign,_nIdReward + 1)
		if	true == bHaveGet then
			return 1
		end
		
		return 0
	end
	
	return -1
end
tGetActivityData[nResId] = SevenDay_GetDataInfo