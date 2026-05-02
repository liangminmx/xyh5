local eCloudTimeType = {	-- 购买云购的限制类型
	eCTT_ReadTime = 0,		-- 根据配置时间
	eCTT_NoLimitTime = 1,	-- 不限制
	eCTT_LimitTime = 2,		-- 全天限制
}
local eBuyResultCode = {		-- 购买云购返回码
	eBuyResultCode_Success = 1,
	eBuyResultCode_UseLess = 2,		-- 购买次数已经用完
	eBuyResultCode_GridLess = 3,		-- 背包空间不足
	eBuyResultCode_ServerError = 4,	-- 服务器异常
	eBuyResultCode_GoldLess = 5,		-- 货币不足
	eBuyResultCode_OutOfLuckyTime = 6,      -- 超过开奖时间 则无法购买
	eBuyResultCode_ActivityCloseStatus = 7, -- 活动在关闭状态
}

local eSendLuckReward = {	-- 发放luck奖励
	eSLuck_Sucess = 1,
	eSLuck_Fail = 2,
}

local nResId = CRESOURCEFLOWACTION.eFT_CloudBuyOpenServer
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tKaiFunYunGou_Data = _kaifuyungou_Info["root"][1]["openday"]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家购买云购奖励
--	@_nOsTime 购买的时间
--	@_nDay 购买的时候是第几天
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Buy_KaiFuYunGou(_idCharacter,_nCActionType,_nOsTime,_nDay,_nBuyTimes)
	if	nil == _idCharacter or nil == _nCActionType or nil == _nOsTime or nil == _nDay or nil == _nBuyTimes then
		L2C_DebugLog("::Buy_KaiFuYunGou Error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nOsTime or "nil")..")".."|"..(_nDay or "nil").."|"..(_nBuyTimes or "nil")..")")
		return eBuyResultCode.eBuyResultCode_ServerError
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::Buy_KaiFuYunGou Error _nCActionType:".._nCActionType)
		return eBuyResultCode.eBuyResultCode_ServerError
	end	
	
	local nKey = KaiFuYunGou_GetServerNum()
	if	"table" ~= type(tKaiFunYunGou_Data[nKey]) or
		"table" ~= type(tKaiFunYunGou_Data[nKey]["group"][1]) or
		"table" ~= type(tKaiFunYunGou_Data[nKey]["group"][1]["daylast"][_nDay]) then
		-- 开服云购的group 为1 
		--L2C_DebugLog("::Buy_KaiFuYunGou Error Lua Data nKey: "..nKey..",_nDay: ".._nDay)
		return eBuyResultCode.eBuyResultCode_ServerError
	end
	local tData = tKaiFunYunGou_Data[nKey]["group"][1]["daylast"][_nDay]	-- 得到这一天的数据
	
	
	-- 判断是不是过了今天的 lucktime 抽奖时间
	if	true == IsPass_LuckTime(_nOsTime,nKey,_nDay) then
		-- L2C_DebugLog("::Buy_KaiFuYunGou had passed LuckTime can not buy "..eBuyResultCode.eBuyResultCode_OutOfLuckyTime)
		return eBuyResultCode.eBuyResultCode_OutOfLuckyTime
	end
	
	-- 判断能不能购买云购（次数够不够）
	if	false == CanBuyCloudTime(_idCharacter,_nBuyTimes,_nOsTime,nKey,_nDay) then
		return eBuyResultCode.eBuyResultCode_UseLess
	end
	
	local bMoneyEnough = false
	if	CURRENCYTYPE.MONEY == tData["moneytype"] then
		bMoneyEnough = System_SpendMoney(_idCharacter,tData["money"],nResId)
	elseif	CURRENCYTYPE.EMONEY == tData["moneytype"] then
		bMoneyEnough = System_SpendEmoney(_idCharacter,tData["money"],nResId)
	elseif	CURRENCYTYPE.VOUCHERS == tData["moneytype"] then
		bMoneyEnough = System_SpendVouchers(_idCharacter,tData["money"],nResId)
	else
		L2C_DebugLog("::Buy_KaiFuYunGou Error moneytype:"..tData["moneytype"])
		return eBuyResultCode.eBuyResultCode_ServerError
	end
	if	false == bMoneyEnough then
		return eBuyResultCode.eBuyResultCode_GoldLess
	end
		
	-- 判断背包空间够不够放物品
	if 	false == BagEnough_KaiFuYunGou(_idCharacter,nKey,_nDay) then
		return eBuyResultCode.eBuyResultCode_GridLess
	end
	
	-- 发放买了云购的奖励
	Send_KaiFuYunGou(_idCharacter,nKey,_nDay)
	return eBuyResultCode.eBuyResultCode_Success
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = Buy_KaiFuYunGou
tOnOnAcitveAward_Cross[nResId] = Buy_KaiFuYunGou


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	发放luck奖励
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function SendLuckReward(_idCharacter,_nCActionType,_nTotalBuyTimes,_nDay,_nData5)
	if	nil == _idCharacter or nil == _nCActionType or nil == _nTotalBuyTimes or nil == _nDay or nil == _nData5 then
		L2C_DebugLog("::SendLuckReward Error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nTotalBuyTimes or "nil").."|"..(_nDay or "nil").."|"..(_nData5 or "nil")..")")
		return eSendLuckReward.eSLuck_Fail
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::Buy_KaiFuYunGou Error _nCActionType:".._nCActionType)
		return eSendLuckReward.eSLuck_Fail
	end	
	
	local nKey = KaiFuYunGou_GetServerNum()
	if	"table" ~= type(tKaiFunYunGou_Data[nKey]) or
		"table" ~= type(tKaiFunYunGou_Data[nKey]["group"][1]) or
		"table" ~= type(tKaiFunYunGou_Data[nKey]["group"][1]["daylast"][_nDay]) then
		return eSendLuckReward.eSLuck_Fail		
	end
	local tData = tKaiFunYunGou_Data[nKey]["group"][1]["daylast"][_nDay]
	
	if	_nTotalBuyTimes < tData["neednum"] then
		return eSendLuckReward.eSLuck_Fail
	end
	
	-- 发放奖励
	local sItem = ""
	if	"table" == type(tData["lucky"]) then
		for	k,v in pairs(tData["lucky"]) do
			local	nItem = v["item"]
			local nNum = v["num"]
			local nStage = 0 -- 没有配该字段，但是发邮件皆有要==、
			sItem = sItem .. tostring(nItem) ..",".. tostring(nNum) ..","..tostring(nStage)..";"
		end
	end
		-- L2C_DebugLog("::SendLuckReward get error lucky table")
	System_SendMail(_idCharacter,tKaiFunYunGou_Data[nKey]["group"][1]["mail"],sItem,0,_nData5,0)
	
	return eSendLuckReward.eSLuck_Sucess
end
tGetActivityData[nResId] = SendLuckReward

-- =================================================================
--	当前时间能不能买云购（限制时间、不限制时间的判断）
-- =================================================================
function CanBuyCloudTime(_idCharacter,_nBuyTimes,_nOsTime,_nKey,_nDay)
	
	local tData = tKaiFunYunGou_Data[_nKey]["group"][1]	-- 得到开服云购的数据，开服云购的group id是1
	
	if	eCloudTimeType.eCTT_NoLimitTime == tData["daylast"][_nDay]["timetype"] then
		return true	-- 不限制时间次数，任意购买
	end
	
	local nVipLevel = System_GetVipLevel(_idCharacter)
	local nVipCanBuyTimes = tData["viptime"][1]["vip"][nVipLevel+1]["vipnum"]
	
	if	eCloudTimeType.eCTT_LimitTime == tData["daylast"][_nDay]["timetype"] then
		if	_nBuyTimes < nVipCanBuyTimes then
			return true	-- 全天限制，只能根据vip等级的购买次数购买
		else
			return false
		end
	end
	
	-- 根据配置时间限制购买次数，规定时间内不限制购买
	-- 获得现在的时间 转化成数字
	local nNowTime = tonumber(os.date("%H%M%S",_nOsTime))
	
	-- 时间字符串的 格式是 [时:分]
	local time_t = System_Split(tData["daylast"][_nDay]["time"],[[:]])
	local time_num = time_t[1]*100*100 + time_t[2]*100
	
	if	nNowTime >= time_num then
		return true	-- 在随意购买时间内，可以随便买
	end
	
	if	_nBuyTimes < nVipCanBuyTimes then
		return true	-- 还有购买次数
	end
	
	return false
end

-- =================================================================
--	根据合服次数得到可用的数据
-- =================================================================
function KaiFuYunGou_GetServerNum()

	local nDefault = -1
	local nServerNum = System_GetCombinedTimes()
	local nDefaultKey
	local isFind = false
	
	for	k,v in pairs(tKaiFunYunGou_Data) do
		if	nServerNum == v["servernum"] then
			return k
		end
		if	nDefault == v["servernum"] then
			nDefaultKey = k
			isFind = true
		end
	end
	
	if isFind then
		return nDefaultKey
	else
		return nDefault
	end
	
end

-- =================================================================
--	判断背包空间够不够放物品
-- =================================================================
function BagEnough_KaiFuYunGou(_idCharacter,_nServerNum,_nDay)
	
	local tData = tKaiFunYunGou_Data[_nServerNum]["group"][1]["daylast"][_nDay]
	
	if	"table" == type(tData["reward"]) then
		local sItem = ""
		for	k,v in pairs(tData["reward"]) do
			local nItemId = v["item"]
			local nNum = v["num"]
			sItem = sItem..nItemId..","..nNum..";"
		end
		return System_CanPushThingsToBagEx(_idCharacter,sItem)
	else
		L2C_DebugLog("::BagEnough_KaiFuYunGou reward is error !!!")
	end
	return true
end

-- =================================================================
--	发放开服云购的物品
-- =================================================================
function Send_KaiFuYunGou(_idCharacter,_nServerNum,_nDay)
	
	local tData = tKaiFunYunGou_Data[_nServerNum]["group"][1]["daylast"][_nDay]
	
	if	"table" == type(tData["reward"]) then
		for	k,v in pairs(tData["reward"]) do
			local nItemId = v["item"]
			local nNum = v["num"]
			local nTimeMode = v["itemtimetype"] or 0
			local nExpiryTime = v["itemtime"] or 0
			
			System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum,0,0,0,0,nTimeMode,nExpiryTime)
		end
	end
	
end

-- =================================================================
--	判断当前时间是不是已经在 lucktime 之后了，lucktime 抽奖之后不能再买云购了
-- =================================================================
function IsPass_LuckTime(_nOsTime,_nServerKey,_nDay)
	
	-- 获得现在的时间 转化成数字，云购 lucktime 之后不能再购买
	-- 格式 ：[00 00 00] 的时:分:秒 
	local nNowTime = tonumber(os.date("%H%M%S",_nOsTime))
	
	local tData = tKaiFunYunGou_Data[_nServerKey]["group"][1]["daylast"][_nDay]	-- 今天云购的信息
	
	local strLuckTime =  tData["luckytime"]
	-- 时间字符串的 格式是 [时:分]
	local time_t = System_Split( strLuckTime, [[:]])
	local time_num = time_t[1]*100*100 + time_t[2]*100
	
	if	nNowTime >= time_num then
		return true
	else
		return false
	end
end
-- =================================================================
--	登录处理  发送活动状态给客户端
-- =================================================================
function KaiFuYunGou_Login(_idCharacter,_nOsTimes)
	local nKey = KaiFuYunGou_GetServerNum()
	if "table" ~= type(tKaiFunYunGou_Data[nKey]) or 
		"table" ~= type(tKaiFunYunGou_Data[nKey]["group"][1]) then
		--L2C_DebugLog("::KaiFuYunGou_Login Error Lua Data nKey: "..nKey)
		return
	end
	
	local tActiveData = tKaiFunYunGou_Data[nKey]["group"][1]
	local nOpenday = System_GetOpenServerDay()
	local status = nOpenday < (tActiveData.day + tActiveData.openday) and 1 or 0
	local nEnd = 0
	if status == 1 then
		local tData = os.date("*t",_nOsTimes)
		tData["hour"] = 0
		tData["min"] = 0
		tData["sec"] = 0
		nEnd = os.time(tData) + (tActiveData.day + tActiveData.openday - nOpenday) * 24 * 3600
	end
	System_SendActiveStatus(_idCharacter,nResId,status,0,nEnd);
end
table.insert(tOnLoginActivity,KaiFuYunGou_Login)
--0点刷新跟登录处理一样
function KaiFuYunGou_ZeroReset(_idCharacter,_nOsTime)
	KaiFuYunGou_Login(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,KaiFuYunGou_ZeroReset)