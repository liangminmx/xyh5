eRechargeGiftMsgcode = {
	eRGMC_Unknow = 0,
	eRGMC_Success = 1,
	eRGMC_HadGet = 2,
	eRGMC_RechargeMoneyNotEnough = 3,
	eRGMC_ActivityEnd = 4,
	eRGMC_BagFull = 5,
	eRGMC_PushBagFaild = 6,
}

local nResId = CRESOURCEFLOWACTION.eFT_ChargeAward
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tRechargeGift_Data = _rechargegift_Info["config"][1]["server"]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：在数据库中
--		nData1 放本日的rechargeNum 充值数量
--		nData2 是存储的该数据的有效日期
--		nData3 记录跨服上的充值数
--		nData4 记录跨服上的充值时间
--		DataStr 是存储领取的奖励的状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家充值接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnRecharge_RechargeGift(_idCharacter,_nEmoney,_nOsTimes)
	if	true == GetRechargeGiftIsOpen(_idCharacter) then
		--L2C_DebugLog("::OnRecharge_RechargeGift RechargeGift Activity Recharge(".._idCharacter.."|".._nEmoney..")")
		if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
			System_AddTempData(_idCharacter,nLuaIdActivity,false)	-- 理论上来说，这里是走不到的
			System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,false)
		end
		IsNeedReset_RechargeGift(_idCharacter,_nOsTimes)
		local nHadRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,1)
		nHadRechargeNum = nHadRechargeNum + _nEmoney		
		--L2C_DebugLog("::OnRecharge_RechargeGift After Recharge Num is ".. nHadRechargeNum)
		System_SetTempData(_idCharacter,nLuaIdActivity,1,nHadRechargeNum,false)
	end
end
table.insert(tOnUserRechargeEmoney,OnRecharge_RechargeGift)
table.insert(tOnUserRechargeEmoney_Cross,OnRecharge_RechargeGift)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入时候，检查掩码是否存在，并创建
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_RechargeGift(_idCharacter,_nOsTimes)
	local bOpenActivity = GetRechargeGiftIsOpen(_idCharacter)
	local bIsExistTempData = System_IsExistTempData(_idCharacter,nLuaIdActivity)
	
	-- 活动已经结束，删除掩码
	if	false == bOpenActivity then
		if true == bIsExistTempData then
		--L2C_DebugLog("::OnLogin_RechargeGift Activity End !!! Delete Data")
			-- System_DelTempData(_idCharacter,nLuaIdActivity,false)
		end
		return
	end
	
	-- 创建掩码
	if	true == bOpenActivity and false == bIsExistTempData then
		--L2C_DebugLog("OnLogin_RechargeGift Create Data !!!")
		System_AddTempData(_idCharacter,nLuaIdActivity)
		System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,false)
		return
	end
	--if 0 < System_GetTempData(_idCharacter,nLuaIdActivity,3) then
	--	local nCrossEmoney = System_GetTempData(_idCharacter,nLuaIdActivity,3)
	--	local nCrossTime = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	--	OnRecharge_RechargeGift(_idCharacter,nCrossEmoney,nCrossTime)
	--	System_SetTempData(_idCharacter,nLuaIdActivity,3,0)
	--	System_SetTempData(_idCharacter,nLuaIdActivity,4,0)
	--end
	IsNeedReset_RechargeGift(_idCharacter,_nOsTimes)
end
table.insert(tOnLoginActivity,OnLogin_RechargeGift)
table.insert(tOnLoginActivity_Cross,OnLogin_RechargeGift)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	零点刷新（做的事情跟登入的一样）
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ZeroReflash_RechargeGift(_idCharacter,_nOsTimes)
	local bOpenActivity = GetRechargeGiftIsOpen(_idCharacter)
	local bIsExistTempData = System_IsExistTempData(_idCharacter,nLuaIdActivity)
	
	-- 活动结束，删除掩码
	if	false == bOpenActivity then
		if true == bIsExistTempData then
		--L2C_DebugLog("::OnLogin_RechargeGift Activity End !!! Delete Data")
			-- System_DelTempData(_idCharacter,nLuaIdActivity,false)
		end
		return
	end
	
	-- 创建掩码
	if	true == bOpenActivity and false == bIsExistTempData then
		--L2C_DebugLog("OnLogin_RechargeGift Create Data !!!")
		System_AddTempData(_idCharacter,nLuaIdActivity)
		System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,false)
		return
	end
	
	--L2C_DebugLog(" ============  call ZeroReflash_RechargeGift")
	IsNeedReset_RechargeGift(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,ZeroReflash_RechargeGift)
table.insert(tOnZeroTrigger_Cross,ZeroReflash_RechargeGift)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	申请领取充值返利奖品
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessGetRechargeGiftReq(_idCharacter,_nCActionType,_nRewardId,_nRechargeNum,_nOsTimes)
	if	nil == _idCharacter or nil == _nCActionType then
		L2C_DebugLog("::ProcessGetRechargeGiftReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nRewardId or "nil").."|"..(_nRechargeNum or "nil").."|"..(_nOsTimes or "nil") ..")")
		return eRechargeGiftMsgcode.eRGMC_Unknow
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::ProcessGetRechargeGiftReq Error _nCActionType !!!")
		return eRechargeGiftMsgcode.eRGMC_Unknow
	end
	
	local bOpenActivity,nServerKey,nDayKey = GetRechargeGiftIsOpen(_idCharacter)
	if	false == bOpenActivity then
		return eRechargeGiftMsgcode.eRGMC_ActivityEnd
	end
	
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return eRechargeGiftMsgcode.eRGMC_Unknow	-- 走到领奖了，不应该没记录的
	else
		--充值记录已掩码记录为准
		_nRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	end
	
	if	"table" ~= type(tRechargeGift_Data[nServerKey]["recharge"][nDayKey]["reward"][_nRewardId]) then
		L2C_DebugLog("::ProcessGetRechargeGiftReq Error,nServerKey:".. nServerKey..",nDayKey:"..nDayKey..",_nRewardId:".._nRewardId)
		return eRechargeGiftMsgcode.eRGMC_Unknow
	end
	local tRewardData = tRechargeGift_Data[nServerKey]["recharge"][nDayKey]["reward"][_nRewardId]
	
	-- 判断是否已经领取了
	local tGetStatus = GetRewardStatus_RechargeGift(_idCharacter)
	if	nil ~= tGetStatus[_nRewardId] then
		if	tGetStatus[_nRewardId] >= tRewardData["changenum"] then
			return eRechargeGiftMsgcode.eRGMC_HadGet
		end
	end

	-- 判断是否充值的钱够领取了
	local getTimes = tGetStatus[_nRewardId] or 0
	getTimes = getTimes + 1
	local nNeedCost = tRewardData["emoney"] * getTimes
	if	_nRechargeNum < nNeedCost then
		return eRechargeGiftMsgcode.eRGMC_RechargeMoneyNotEnough
	end
	
	if	false == Enough_Bag_RechargeGift(_idCharacter,nServerKey,nDayKey,_nRewardId) then
		return eRechargeGiftMsgcode.eRGMC_BagFull
	end
	
	-- 设置已经领取的标记
	tGetStatus[_nRewardId] = getTimes
	if	true == SetRewardStatus_RechargeGift(_idCharacter,tGetStatus) then
		-- 发放奖励
		-- L2C_DebugLog("::ProcessGetRechargeGiftReq Send Reward (".._idCharacter.."|"..nServerKey.."|"..nDayKey.."|".._nRewardId..")")
		Send_Reward_RechargeGift(_idCharacter,nServerKey,nDayKey,_nRewardId,_nOsTimes)
		return eRechargeGiftMsgcode.eRGMC_Success
	else
		L2C_DebugLog("::ProcessGetRechargeGiftReq Mask Error")
		return eRechargeGiftMsgcode.eRGMC_Unknow
	end
end
tOnOnAcitveAward[nResId] = ProcessGetRechargeGiftReq
tOnOnAcitveAward_Cross[nResId] = ProcessGetRechargeGiftReq

-- =================================================================
--	判断当前活动是不是开启了
-- @return true, nServerKey,nDayKey
--				/false,0,0
-- =================================================================
function GetRechargeGiftIsOpen(_idCharacter)
	local nCombine
	local nOpenServerDay
	if System_IsCrossSever() then
		nCombine = System_GetCombinedTimesByCharacter(_idCharacter)
		nOpenServerDay = System_GetOpenServerDayByCharacter(_idCharacter)
	else
		nCombine = System_GetCombinedTimes()
		nOpenServerDay = System_GetOpenServerDay()
	end
		
	local nDefaultCombine = -1
	
	local nDefaultKey = 1
	local nServerKey = -1
	for 	k,v in  pairs(tRechargeGift_Data) do
		if	nCombine == v["servernum"] then
			nServerKey = k
			break
		end
		if	nDefaultCombine == v["servernum"] then
			nDefaultKey = k
		end
	end
	if	-1 == nServerKey then nServerKey = nDefaultKey end
	
	
	if	"table" == type(tRechargeGift_Data[nServerKey]["recharge"][nOpenServerDay]) then
		return true,nServerKey,nOpenServerDay
	end
	
	return false,0,0
end

-- =================================================================
--	判断当前的时间和掩码数据的时间是否一致，
--	如不一致就将数据初始化
-- =================================================================
function IsNeedReset_RechargeGift(_idCharacter,_nOsTimes)
	local nDaySign = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local nDaySignTime = tonumber(os.date("%Y%m%d",nDaySign))	-- 记录的登入时间
	local nDayLoginTime = tonumber(os.date("%Y%m%d",_nOsTimes))	-- 本次的登入时间

	if	nDayLoginTime > nDaySignTime then
		System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)	-- 充值数量
		System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)	-- 充值状态		
		System_SetTempData(_idCharacter,nLuaIdActivity,2,_nOsTimes,true)	-- 本条记录的有效时间
	end
end

-- =================================================================
--	得到奖励字符串解析的领奖状态表
-- @return table
-- =================================================================
function GetRewardStatus_RechargeGift(_idCharacter)
	local strStatus = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	local tStatus = {}
	
	if	nil == strStatus or "" == strStatus then
		return tStatus
	end
	
	local tTmp = System_Split(strStatus,"]")
	for	k,v in pairs(tTmp) do
		local tTmp2 = System_Split(string.sub(v,2,-1),",")
		if nil ~= tonumber(tTmp2[1]) and nil ~= tonumber(tTmp2[2]) then
			tStatus[ tonumber(tTmp2[1])] = tonumber(tTmp2[2])
		else
			L2C_DebugLog("::GetRewardStatus_RechargeGift Data Error _idCharacter[".._idCharacter.."]")
		end
	end	
	return tStatus
end

-- =================================================================
--	设置领取的状态
-- =================================================================
function SetRewardStatus_RechargeGift(_idCharacter,_tStatus)
	local strStatusTotal = ""
	if	nil == _tStatus or nil == next(_tStatus) then
		System_SetTempDataStr(_idCharacter,nLuaIdActivity,strStatusTotal)
		return
	end
	
	for	k,v in pairs(_tStatus) do
		local strReward = "["..k..","..v.."]"
		strStatusTotal = strStatusTotal .. strReward
	end
	
	return System_SetTempDataStr(_idCharacter,nLuaIdActivity,strStatusTotal,false)
end

-- =================================================================
--	发放奖励
-- =================================================================
function Send_Reward_RechargeGift(_idCharacter,_nServerKey,_nDayKey,_nRewardId,_nOsTimes)

	if	"table" == type(tRechargeGift_Data[_nServerKey]["recharge"][_nDayKey]["reward"][_nRewardId]) then
	
		local tRewardData = tRechargeGift_Data[_nServerKey]["recharge"][_nDayKey]["reward"][_nRewardId]
		if	"table" == type(tRewardData["rewardinfo"]) then
			for	k,v in pairs(tRewardData["rewardinfo"]) do
				local nItemId = v["item"]
				local nNum = v["itemnum"]
				
				local timeMode = v["timemode"] or 0
				local time_n = v["time"] or 0

				time_n =System_timeModeTransfer(timeMode,time_n,_osTime)
				
				System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum,0,0,0,0,timeMode,time_n)				
			end
		end
		
		if	"number" == type(tRewardData["elixir"]) and tRewardData["elixir"] > 0 then
			System_AwardRealmPoint(_idCharacter,tRewardData["elixir"])
		end
	end
end

-- =================================================================
--	背包够不够放
-- =================================================================
function Enough_Bag_RechargeGift(_idCharacter,_nServerKey,_nDayKey,_nRewardId)
	if	"table" == type(tRechargeGift_Data[_nServerKey]["recharge"][_nDayKey]["reward"][_nRewardId]) then
		local tRewardData = tRechargeGift_Data[_nServerKey]["recharge"][_nDayKey]["reward"][_nRewardId]
		
		local itemStr = ""
		if	"table" == type(tRewardData["rewardinfo"]) then
			for	k,v in pairs(tRewardData["rewardinfo"]) do
				local nItemId = v["item"]
				local nNum = v["itemnum"]
				
				itemStr = itemStr .. tostring(nItemId) .. "," .. tostring(nNum) .. ";"
			end
		end

		return System_CanPushThingsToBagEx(_idCharacter,itemStr)
	else
		L2C_DebugLog("::Enough_Bag_RechargeGift Error Data !!!")
		return false
	end
end