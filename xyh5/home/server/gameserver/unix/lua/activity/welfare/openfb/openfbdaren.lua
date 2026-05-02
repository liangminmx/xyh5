-- ////////////////////////// 领取活动的时候的放回码
local eResultCode = {
	eRC_Unknow = 0,
	eRC_Succeed = 1,
	eRC_AlreadyGet = 2,			-- 已经获取
	eRC_NotInActivity = 3,			-- 活动没开启
	eRC_NotEnoughScore = 4,	-- 积分不够
	eRC_NotEnoughSpace =5 ,	-- 空间不够
}

-- ////////////////////////// 活动的当前状态
local eOpenFBDarenStatus = {
	eOpenFB_Null = 0,
	eOpenFB_Start = 1,	-- 开始了
	eOpenFB_Hold = 2,	-- 展示/领奖期间
	eOpenFB_End = 3,	-- 结束了
}

-- ////////////////////////// 这里的值是在 openFBdaren_Data.lua 中，不同活动的id
local TranslateActionTriggerType = {}
TranslateActionTriggerType[eActionTriggerType.eFBT_LifeOrDeath] = 1	-- 超凡生死战
TranslateActionTriggerType[eActionTriggerType.eFBT_ClimbRoad] = 2		-- 登山路
TranslateActionTriggerType[eActionTriggerType.eFBT_Single] = 3			-- 单人副本
TranslateActionTriggerType[eActionTriggerType.eFBT_Equipment] = 4		-- 装备副本
TranslateActionTriggerType[eActionTriggerType.eFBT_SecretHouse] = 5	-- 百战密室
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		活动掩码 data1 字段，放玩家当前 score 分数
--		活动掩码 data2 字段，放已经领取过的，等级奖励.Bit为存储
--					data6 字段，放配置的 holdday
--					data7 字段，放配置的 openDay
--					data8 字段，放配置的 continueday
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local nResId = CRESOURCEFLOWACTION.eFT_openFBMaster
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tOpenFBdaren_Data = _openfbdaren_Info["root"][1]["open"]


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	开服活动中，副本达人的完成分数统计
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function AddScore_OpenFB(_idCharacter,_nCActionTriggerType,_nData3,_nData4,_nData5)
		
	if	nil	~= TranslateActionTriggerType[_nCActionTriggerType] then
	
		-- 只有在活动进行之中，才能够增加分数
		if	eOpenFBDarenStatus.eOpenFB_Start == bInOpenTime_OpenFB() then
			
			local nDataInfo_Key = TranslateActionTriggerType[_nCActionTriggerType]	-- 转化为配置表中活动的key			
			local nServerKey = FindServerKey_OpenFB()
			if nServerKey == nil then
				return -1
			end	
			
			if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
				System_AddTempData(_idCharacter,nLuaIdActivity)			
			end
			
			--	防止活动开放和持续时间改变
			local nOpenDay = tOpenFBdaren_Data[nServerKey]["openday"]
			local nContinueday =tOpenFBdaren_Data[nServerKey]["continueday"]
			local nHoldday =tOpenFBdaren_Data[nServerKey]["holdday"]
			
			if	nHoldday ~= System_GetTempData(_idCharacter,nLuaIdActivity,6) then
				System_SetTempData(_idCharacter,nLuaIdActivity,6,nHoldday)
			end
			if	nOpenDay ~= System_GetTempData(_idCharacter,nLuaIdActivity,7) then
				System_SetTempData(_idCharacter,nLuaIdActivity,7,nOpenDay)
			end
			if	nContinueday ~= System_GetTempData(_idCharacter,nLuaIdActivity,8) then
				System_SetTempData(_idCharacter,nLuaIdActivity,8,nContinueday)
			end	
			
			local nNowScore = System_GetTempData(_idCharacter,nLuaIdActivity,1)	
			local nEvery_Add_Score = tOpenFBdaren_Data[nServerKey]["info"][nDataInfo_Key]["score"]
			nNowScore = nNowScore + nEvery_Add_Score
			
			-- L2C_DebugLog("::AddScore_OpenFB : now score is ".. nNowScore)
			System_SetTempData(_idCharacter,nLuaIdActivity,1,nNowScore)
			-- L2C_DebugLog("::AddScore_OpenFB : add score to (".._idCharacter.."|type:"..nDataInfo_Key..") sucess !")
			return 0
		end
	end
	return -1
end
table.insert(tOnCompleteThings,AddScore_OpenFB)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取 开服活动中，副本达人奖励
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessGetOpenFBRewardReq(_idCharacter,_nCActionType,_nIdReward,_nData4,_nData5)
		
	if	nil == _idCharacter or nil == _nCActionType or _nIdReward == nil then
		L2C_DebugLog("::ProcessGetOpenFBRewardReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nIdReward or "nil")..")")
		return eResultCode.eRC_Unknow
	end
	
	-- 活动类型要是同一种
	if	nResId ~= _nCActionType then
		return eResultCode.eRC_Unknow
	end
	
	-- eOpenFB_Null,
	-- eOpenFB_Start,	-- 开始了
	-- eOpenFB_Hold,	-- 展示/领奖期间
	-- eOpenFB_End,	-- 结束了
	-- 判断活动 既不是 开启，也不是领奖状态 
	local nActivityStatus = bInOpenTime_OpenFB()
	if	eOpenFBDarenStatus.eOpenFB_Null == nActivityStatus or 
		eOpenFBDarenStatus.eOpenFB_End == nActivityStatus then
		return eResultCode.eRC_NotInActivity
	end	

	
	
	local nServerKey = FindServerKey_OpenFB()
	if nServerKey == nil then
		return eResultCode.eRC_NotInActivity
	end	
		
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity)
	end
	
	--	防止活动开放和持续时间改变
	local nOpenDay = tOpenFBdaren_Data[nServerKey]["openday"]
	local nContinueday =tOpenFBdaren_Data[nServerKey]["continueday"]
	if	nOpenDay ~= System_GetTempData(_idCharacter,nLuaIdActivity,7) then
		System_SetTempData(_idCharacter,nLuaIdActivity,7,nOpenDay)
	end
	if	nContinueday ~= System_GetTempData(_idCharacter,nLuaIdActivity,8) then
		System_SetTempData(_idCharacter,nLuaIdActivity,8,nContinueday)
	end	
	
	-- 判断是不是已经领取过了
	local bitGetRewardSign = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local bHaveGet =  WCBit.GetBit(bitGetRewardSign,_nIdReward)
	if	true == bHaveGet then
		return eResultCode.eRC_AlreadyGet
	end
	
	-- 获得要领取的指定奖励的信息
	if	"table" ~= type(tOpenFBdaren_Data[nServerKey]["reward"][_nIdReward]) then
		L2C_DebugLog("::ProcessGetOpenFBRewardReq error data,nServerKey: "..nServerKey..",_nIdReward: ".._nIdReward)
		return eResultCode.eRC_Unknow
	end
	local tInfo = tOpenFBdaren_Data[nServerKey]["reward"][_nIdReward]
	
	-- 判断分数够不够
	local nNowScore = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if	nNowScore < tInfo["needscore"] then
		-- L2C_DebugLog("::ProcessGetOpenFBRewardReq : not have enough score !")
		return eResultCode.eRC_NotEnoughScore
	end
	
	if	false == EnoughBag_OpenFBDaren(_idCharacter,nServerKey,_nIdReward) then
		return eResultCode.eRC_NotEnoughSpace
	end
	
	-- 设置数据库数据
	bitGetRewardSign = WCBit.SetTrue(bitGetRewardSign,_nIdReward)
	if	true == System_SetTempData(_idCharacter,nLuaIdActivity,2,bitGetRewardSign) then
		-- 发放奖励
		Send_Reward_OpenFBdaren(_idCharacter,nServerKey,_nIdReward)
		return eResultCode.eRC_Succeed
	else
		L2C_DebugLog("::ProcessGetOpenFBRewardReq Mask Error")
		return eResultCode.eRC_Unknow
	end
	
	
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = ProcessGetOpenFBRewardReq

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入的时候，检验活动是不是已经关闭了
--	如果活动已经过了开放时间，就删除掩码
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_OpenFBdaren(_idCharacter,_nOsTimes)
	local nActivityStatus = bInOpenTime_OpenFB() 
	if	eOpenFBDarenStatus.eOpenFB_End == nActivityStatus then	-- 活动状态
		if	true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
			System_DelTempData(_idCharacter,nLuaIdActivity)
		end
	end
end
table.insert(tOnLoginActivity,OnLogin_OpenFBdaren)
-- ===================================================
--	计算当前 开服活动，副本达人 活动任务是否在开启时间内
--	@return arg1 bool 		是否在活动时间内
-- ===================================================
function bInOpenTime_OpenFB()
	
	local nServerKey = FindServerKey_OpenFB()
	local nOpenServerDay = System_GetOpenServerDay()	-- 获取开服的天数
	if nServerKey == nil then
		return eOpenFBDarenStatus.eOpenFB_Null
	end	
	
	local nOpenDay = tOpenFBdaren_Data[nServerKey]["openday"]
	local nContinueday = tOpenFBdaren_Data[nServerKey]["continueday"]
	local nHoldday = tOpenFBdaren_Data[nServerKey]["holdday"]
	
	
	if	nOpenDay <= nOpenServerDay and nOpenServerDay < (nOpenDay + nContinueday) then		
		return eOpenFBDarenStatus.eOpenFB_Start	-- 开启
		
	elseif	(nOpenDay + nContinueday) <= nOpenServerDay and nOpenServerDay < (nOpenDay + nContinueday + nHoldday) then	
		return eOpenFBDarenStatus.eOpenFB_Hold	-- 展示/领奖期间
		
	elseif	(nOpenDay + nContinueday + nHoldday) <= nOpenServerDay then	
		return eOpenFBDarenStatus.eOpenFB_End	-- 结束
		
	else
		return eOpenFBDarenStatus.eOpenFB_Null
	end
	
	
end

-- ===================================================
--	根据合服次数，和配置表中配置的不同合服次数的 数据，判断用
--	@return 表中可以用的数据的 key 
-- ===================================================
function FindServerKey_OpenFB()
	local nServerNum =  System_GetCombinedTimes() -- 获取合服次数
	local nDefaultServerNum = -1
	local nDefaultServerKey = nil
	
	for	k,v in pairs(tOpenFBdaren_Data) do
		if	nServerNum == v["servernum"] then
			return k
		end
		if	nDefaultServerNum == v["servernum"] then
			nDefaultServerKey = k
		end
	end
	return nDefaultServerKey
end

-- ===================================================
--	发放活动奖励
-- ===================================================
function Send_Reward_OpenFBdaren(_idCharacter,_nServerKey,_nIdReward)

	if	"table" == type(tOpenFBdaren_Data[_nServerKey]["reward"][_nIdReward]) then
		local tRewardInfo = tOpenFBdaren_Data[_nServerKey]["reward"][_nIdReward]
		
		if	"number" == type(tRewardInfo["emoney"]) and tRewardInfo["emoney"] > 0 then
			System_AwardEmoney(_idCharacter,tRewardInfo["emoney"],nResId)
		end
		
		if	"table" == type(tRewardInfo["rewardinfo"]) then
			for	k,v in pairs(tRewardInfo["rewardinfo"]) do
				local nIdItem = v["itemid"]
				local nNum = v["num"]			
				if	false == System_AwardThingInBag(_idCharacter,nResId,nIdItem,nNum) then
					System_AwardThingQuestContainer(_idCharacter,nResId,nIdItem,nNum)
				end
			end
		end
		
	else
		-- 不应该走到这里的
		L2C_DebugLog("::Send_Reward_OpenFBdaren Error Data,nServerKey: "..nServerKey..",_nIdReward: ".._nIdReward)
	end
end

-- ===================================================
-- 判断背包空间够不够
-- ===================================================
function EnoughBag_OpenFBDaren(_idCharacter,_nServerKey,_nIdReward)

	if	"table" == type(tOpenFBdaren_Data[_nServerKey]["reward"][_nIdReward]) then
	
		local tRewardInfo = tOpenFBdaren_Data[_nServerKey]["reward"][_nIdReward]
		
		local sItem = ""
		if	"table" == type(tRewardInfo["rewardinfo"]) then
			for	k,v in pairs(tRewardInfo["rewardinfo"]) do
				local nIdItem = v["itemid"]
				local nNum = v["num"]			
				sItem = sItem .. tostring(nIdItem) .. ","..tostring(nNum)..";"
			end
		end
		return System_CanPushThingsToBagEx(_idCharacter,sItem)
		
	else
		-- 不应该走到这里的
		L2C_DebugLog("::EnoughBag_OpenFBDaren Error Data,nServerKey: "..nServerKey..",_nIdReward: ".._nIdReward)
	end
end