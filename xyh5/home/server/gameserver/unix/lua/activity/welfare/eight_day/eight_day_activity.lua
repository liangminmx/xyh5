local eEightDayMsgcode = {
	eEightDMC_Unknow = 0,
	eEightDMC_Success = 1,
	eEightDMC_HadGet = 2,
	eEightDMC_ActivityEnd = 3,
	eEightDMC_BagFull = 4,
	eEightDMC_PushBagFaild = 5,
	eEightDMC_LimitNotComplete = 6,	-- 条件没达成
	eEightDMC_NoGift = 7,	-- 没有这个礼包
	eEightDMC_ViplevelNotEnough = 8,	-- vip等级不足
	eEightDMC_EMoneyNotEnough = 9,	-- 元宝不足
	eEightDMC_YouHasBuy = 10,	-- 你的购买次数用完
	eEightDMC_SaleComplete = 11,	-- 全服购买次数用完
}

local nResId = CRESOURCEFLOWACTION.eFT_EightDayActivity
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local tEighthday_Data = _eghthday_Info["root"][1]["server"]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取奖励
--  @_nReached 对指定活动的完成程度
--  @_nRewardId 就是要领取的 level 字段
--  @_nReached 玩家在这个主题的等级
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Eight_Day_GetRewardReq(_idCharacter,_nCActionType,_nRewardId,_nReached,_nOsTime)
	
	if	nil == _idCharacter or nil == _nCActionType or nil == _nRewardId or nil == _nReached or nil == _nOsTime then
		L2C_DebugLog("::Eifht_Day_GetRewardReq Error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nRewardId or "nil").."|"..(_nReached or "nil").."|"..(_nOsTime or "nil")..")")
		return eEightDayMsgcode.eEightDMC_Unknow
	end
	
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::Eifht_Day_GetRewardReq Error _nCActionType:".._nCActionType)
		return eEightDayMsgcode.eEightDMC_Unknow
	end
	
	local nServerKey = Eight_Day_GetServerNum()
	local nDayKey
	if	"table" == type(tEighthday_Data[nServerKey]) then
		nDayKey = Eight_Day_GetOpenDayKey(nServerKey)
		if	nil == nDayKey then
			L2C_DebugLog("::Eifht_Day_GetRewardReq error nDayKey")
			return eEightDayMsgcode.eEightDMC_Unknow
		end
	else
		L2C_DebugLog("::Eifht_Day_GetRewardReq error nServerKey:"..nServerKey)
		return eEightDayMsgcode.eEightDMC_Unknow
	end
	
    -- 判断要领取的level是否在配置表中存在
	local nRewardKey = Eight_Day_GetRewardKey(nServerKey,nDayKey,_nRewardId)
	if	nil == nRewardKey then
		L2C_DebugLog("::Eight_Day_GetRewardReq Error Reward:".._nRewardId..",nServerKey:"..nServerKey..",nDayKey:"..nDayKey)
		return eEightDayMsgcode.eEightDMC_Unknow
	end
	
    -- 判断玩家等级是不是够领取该奖励
	if	tEighthday_Data[nServerKey]["wealth"][nDayKey]["itemcharacter"][nRewardKey]["level"] > _nReached then
		return eEightDayMsgcode.eEightDMC_LimitNotComplete
	end
		
	-- 发放奖励
	local sItem = SendReward_EightDay(_idCharacter,nServerKey,nDayKey,nRewardKey,_nOsTime)
	
	local nNoticelev = tEighthday_Data[nServerKey]["wealth"][nDayKey].comonnoticelev
	local nNoticeId  = tEighthday_Data[nServerKey]["wealth"][nDayKey].comonnoticeid

	if "number" == type(nNoticelev) and "number" == type(nNoticeId) then
		if nNoticelev <= nRewardKey then
			EightDay_SendBroadCast(_idCharacter,nNoticeId,sItem)
		end
	end
	
	return eEightDayMsgcode.eEightDMC_Success
end
--这个去掉了
-- tOnOnAcitveAward[nResId] = Eight_Day_GetRewardReq

-- =================================================================
--	根据合服次数获得数据，返回可用的数据的key
-- =================================================================
function Eight_Day_GetServerNum()
	local nServerNum = System_GetCombinedTimes()
	local nDefault = -1;
	local nDefaultKey = -1
	for	k,v in pairs(tEighthday_Data) do
		if	v["servernum"] == nServerNum then
			return k
		end
		if	v["servernum"] == nDefault then
			nDefaultKey = k
		end
	end
	return nDefaultKey
end

-- =================================================================
--	根据天数 day 字段获得第几天的key,没有返回nil
-- =================================================================
function Eight_Day_GetOpenDayKey(_nServerKey)
	local nOpenServerDay = System_GetOpenServerDay()
	for	k,v in pairs(tEighthday_Data[_nServerKey]["wealth"]) do
		if	nOpenServerDay == v["day"] then
			return k
		end
	end
	return nil
end

-- =================================================================
--	根据客户端发的要领的奖励的level ，获得key
-- =================================================================
function Eight_Day_GetRewardKey(_nServerKey,_nDayKey,_nRewardId)
	if	"table" == type(tEighthday_Data[_nServerKey]["wealth"][_nDayKey]["itemcharacter"]) then
		for	k,v in pairs(tEighthday_Data[_nServerKey]["wealth"][_nDayKey]["itemcharacter"]) do
			if	_nRewardId == v["level"] then
				return k
			end
		end
	else
		L2C_DebugLog("::Eight_Day_GetRewardKey error data ".._nServerKey..",".._nDayKey)
	end
	
end

-- =================================================================
--	发放奖励 返回用于广播的物品组
-- =================================================================
function SendReward_EightDay(_idCharacter,_nServerKey,_nDayKey,_nRewardKey,_nOsTime)
	
	-- L2C_DebugLog("::SendReward_EightDay nServerKey:".._nServerKey..",nDayKey:".._nDayKey..",nRewardKey:".._nRewardKey)
	
	local tEightDay_Reward_Data = tEighthday_Data[_nServerKey]["wealth"][_nDayKey]["itemcharacter"][_nRewardKey]
	local sItem = ""
	if	"table" == type(tEightDay_Reward_Data["reward"]) then
		for	k,v in pairs(tEightDay_Reward_Data["reward"]) do
			local nItemId = v["item"]
			local nNum = v["itemnum"]
			local realm = v["realm"] or 0
			--[[
			local nTimeMode = ThingExpiryMode.eTEM_Unlimit
			local nOverTime = v["overtime"] or 0
			if	nOverTime > 0 then	-- 原来的逻辑，nOverTime 字段是有效天数
				nTimeMode = ThingExpiryMode.eTEM_TimeOut
				nOverTime = _nOsTime + (24*60*60)*nOverTime
			end
			]]
			local nTimeMode = ThingExpiryMode.eTEM_Unlimit
			local nOverTime = ("number" == type(v["time"])) and v["time"] or 0
			if nOverTime > 0 then
				nTimeMode = ThingExpiryMode.eTEM_TimeOut
				nOverTime = _nOsTime + nOverTime
			end			
			if 	false == System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum,realm,0,0,0,nTimeMode,nOverTime) then
				System_AwardThingQuestContainer(_idCharacter,nResId,nItemId,nNum,realm,0,0,0,nTimeMode,nOverTime)
			end
			if k == #tEightDay_Reward_Data["reward"] then
				sItem = sItem .. nItemId
			else
				sItem = sItem .. nItemId .. ","
			end
		end
	else
		L2C_DebugLog("::SendReward_EightDay error nServerKey:".._nServerKey..",nDayKey:".._nDayKey..",nRewardKey:".._nRewardKey)
	end
	return sItem
end


-- =================================================================
--	登录处理  发送活动状态给客户端
-- =================================================================
function EightDay_Login(_idCharacter,_nOsTimes)
	local nKey = Eight_Day_GetServerNum()
	if "table" ~= type(tEighthday_Data[nKey]) then
		L2C_DebugLog("::EightDay_Login Error Lua Data nKey: "..nKey)
        System_SendActiveStatus(_idCharacter,nResId,0,0,0);
        return
	end
	local tActiveData = tEighthday_Data[nKey]["wealth"]
	local nOpenday = System_GetOpenServerDay()	
	local status = Eight_Day_GetOpenDayKey(nKey) and 1 or 0
	local nEnd = 0
	if status == 1 then
		local tData = os.date("*t",_nOsTimes)
		tData["hour"] = 0
		tData["min"] = 0
		tData["sec"] = 0
		--都是持续一天的
		nEnd = os.time(tData) + 24 * 3600
	end
	System_SendActiveStatus(_idCharacter,nResId,status,0,nEnd);
end
table.insert(tOnLoginActivity,EightDay_Login)
--0点刷新跟登录处理一样
function EightDay_ZeroReset(_idCharacter,_nOsTime)
	EightDay_Login(_idCharacter,_nOsTimes)
end
-- table.insert(tOnZeroTrigger,EightDay_ZeroReset)

--发放系统广播
function EightDay_SendBroadCast(_idCharacter,_nNoticeId,_sItem)
	local sParam = string.format("%d,%u;%d,%s;%d,%s"
					,ePreparedStatementValueType.TYPE_UI64,_idCharacter
					,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)									
					,ePreparedStatementValueType.TYPE_STRING,_sItem						
					)
	System_SendCommonBroadCastMsg(_nNoticeId,sParam)
end
