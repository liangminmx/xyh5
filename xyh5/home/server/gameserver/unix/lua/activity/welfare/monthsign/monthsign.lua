-- ////////////////////////// 领取活动的时候的放回码
local eSignState =
		{
			NotSign = 0,
			Sign = 1, 
		}
local eDoubleStatus =
		{
			NotDouble = 0;
			Double = 1;
		}
local eMsgCode =
{
	Success = 0,				--//0成功
	SignToday = 1,				--//1本日已签到
	LeftResignTimesZero = 2,	--//2本月剩余补签次数不足
	SignTimesNotEnough = 3,		--//3签到次数不足
	NoDayResign = 4,			--//4本月全勤
	CurrentTotalSignGet = 5,	--//5本次累计签到奖励已领取
	UnKnownError = 6,			--//6未知错误
	BagFull = 7,				--//7背包已满
	NotEnoughLevel = 8,			--//8等级不足
	SignedDay = 9,				--//9这天已经签过了
};

local eSignActionCode =
{
	Sign = 0, --//正常签到
	Resign = 1, --//补签
	VipReSign = 2,	--//提升VIP后的当天补签
};
local nLuaIdActivity = LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_MonthSign]
local tMonthSign_Info = {}
for k,v in pairs(_signin_Info.root[1].signin)do
	tMonthSign_Info[v.periods] = v	
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		活动掩码 data1 字段，已经领取过的，.Bit存储
--				 data2 字段，补签天数
--				 data3 字段，总签到天数
--				 data4 字段，第几天
--				 data5 字段，第几轮签到
--				 data6 字段，VIP签到		0未满足 1可以双倍 2直接活动双倍 3补签双倍
--				 data7 字段，离线时间 用于记算下次上线间隔几天
--				 
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入游戏的时候，判断是不是有该活动掩码
--	如果没有，就为该活动创建一个掩码
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_MonthSignReward(_idCharacter,_nOsTimes)
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity)		
		System_SetTempData(_idCharacter,nLuaIdActivity,4,1,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,5,1)
	end
end
table.insert(tOnLoginActivity,OnLogin_MonthSignReward)
table.insert(tOnLoginActivity_Cross,OnLogin_MonthSignReward)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	领取 每日签到奖励
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function processDailySignAsk(_idCharacter,_nCActionType,_nSignAction,_nSignDay,_nData5)
		
	if	nil == _idCharacter or nil == _nCActionType then
		return eMsgCode.UnKnownError
	end

	-- 活动类型要是同一种
	if	CRESOURCEFLOWACTION.eFT_MonthSign ~= _nCActionType then
		return eMsgCode.UnKnownError
	end

	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		--没掩码不处理
		return eMsgCode.UnKnownError
	end	

	-- 判断是不是已经领取过了
	local bRet,tTemp = WCTempData:Get(_idCharacter,nLuaIdActivity)
	if bRet == false then
		return eMsgCode.UnKnownError
	end
	local bitGetSignStatus = tTemp[1]
	local nResignTimes  = tTemp[2]
	local nTotalSignNum = tTemp[3]
	if tTemp[4] == 0 then tTemp[4] = 1 end		
	local nDay = tTemp[4]
	if tTemp[5] == 0 then tTemp[5] = 1 end		
	local nRoundNum = tTemp[5]
	local nVipSingnStatus = tTemp[6]
	--正常签	或 VIP补签(其实不会有补签进来 都是走正常签到)
	if _nSignAction == eSignActionCode.Sign or _nSignAction == eSignActionCode.VipReSign then
		local bHaveGet =  WCBit.GetBit(bitGetSignStatus,nDay)
		if	true == bHaveGet then 
			if nVipSingnStatus >= 2 then
				return eMsgCode.SignToday
			else 
				if nVipSingnStatus == 1 then
					--//VIP签到
					Send_Reward_MonthSign(_idCharacter,nDay,nRoundNum,eSignActionCode.VipReSign)
					tTemp.Update()
					return eMsgCode.Success
				end
			end
			return eMsgCode.SignToday
		end
	end
	--补签
	if _nSignAction == eSignActionCode.Resign then
		local bHaveGet =  WCBit.GetBit(bitGetSignStatus,_nSignDay)
		if	true == bHaveGet then 
			return eMsgCode.eMC_SignedDay
		end
		nDay = _nSignDay
		tTemp[2] = nResignTimes+ 1
	end

	-- 设置数据库数据
	tTemp[1] = WCBit.SetTrue(bitGetSignStatus,nDay)
	tTemp[3] = nTotalSignNum  + 1
	-- 发放奖励
	Send_Reward_MonthSign(_idCharacter,nDay,nRoundNum,_nSignAction)
	
	--发送消息
	tTemp.Update()
	
	return eMsgCode.Success
end

-- 插入到领取奖励表中
tOnOnAcitveAward[CRESOURCEFLOWACTION.eFT_MonthSign] = processDailySignAsk
tOnOnAcitveAward_Cross[CRESOURCEFLOWACTION.eFT_MonthSign] = processDailySignAsk


-- ===================================================
--	发放活动奖励
-- ===================================================
function Send_Reward_MonthSign(_idCharacter,_nDay,_nRoundNum,_nSignAction)	
	if "table" ~= type(tMonthSign_Info[_nRoundNum]) then
		_nRoundNum = -1
	end
	local tAward = tMonthSign_Info[_nRoundNum].accumulation
	
	local _nVipLevel = System_GetVipLevel(_idCharacter)
	if	"table" == type(tAward[_nDay].reward) then
		for	k,v in pairs(tAward[_nDay].reward) do
			local nIdItem = v["itemid"]
			local _nTimes = 1
			if _nSignAction == eSignActionCode.Sign then
				if (v["isdoube"] == 1 )then
					local bIsRechare = false -- 充值是否满足
					if System_GetTempData(_idCharacter,nLuaIdActivity,6) == 1 then
						System_SetTempData(_idCharacter,nLuaIdActivity,6,2,false)
						_nTimes = 2
					else
						_nTimes = 1
					end					
				end
				if (v["weekedn"] == 1) then
					local temp = os.date("*t") 
					if 1 == temp.wday or 7 == temp.wday then
						_nTimes = _nTimes * 2
					end
				end
			end
			if _nSignAction == eSignActionCode.Resign then
				--补签不给双倍
				-- if (v["isdoube"] == 1 )then
					-- _nTimes = (v["doubeVip"] <= _nVipLevel) and 2 or _nTimes
				-- end
			end
			if _nSignAction == eSignActionCode.VipReSign then
				if (v["weekedn"] == 1) then
					local temp = os.date("*t") 
					if 1 == temp.wday or 7 == temp.wday then
						_nTimes = _nTimes * 2
					end
				end
				System_SetTempData(_idCharacter,nLuaIdActivity,6,3,false)
			end

			
			local nNum = v["number"] * _nTimes
			if	false == System_AwardThingInBag(_idCharacter,CRESOURCEFLOWACTION.eFT_MonthSign,nIdItem,nNum) then
				System_AwardThingQuestContainer(_idCharacter,CRESOURCEFLOWACTION.eFT_MonthSign,nIdItem,nNum)
			end
		end
	end
end

-- /////////////////////////////////////////////////////////////////////////////////
--	0点刷新签到天数
-- /////////////////////////////////////////////////////////////////////////////////
function OnMonthSignZeroRefresh(_idCharacter,_nOsTimes)	
	local bitGetSignStatus =  System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nDay =  System_GetTempData(_idCharacter,nLuaIdActivity,4)
	local nLogoutTIme = System_GetTempData(_idCharacter,nLuaIdActivity,7)
	--L2C_DebugLog("OnMonthSignZeroRefresh:"..nDay.."|[Lin]".._nOsTimes.."|[Lout]"..nLogoutTIme)
	if nDay == 0 then nDay = 1 end
	
	local nRoundNum =  System_GetTempData(_idCharacter,nLuaIdActivity,5)
	if nRoundNum == 0 then nRoundNum = 1 end
	--  这个修正已经出错的玩家
	if nRoundNum == -1 then 
		System_SetTempData(_idCharacter,nLuaIdActivity,5,4) 
	end
	if "table" ~= type(tMonthSign_Info[nRoundNum]) then
		nRoundNum = -1
	end
	
	local days = 1	--间隔了几天
	if nLogoutTIme ~= 0 and _nOsTimes > nLogoutTIme then
		days = math.ceil((System_GetZeroTime(_nOsTimes) - nLogoutTIme) / (24*60*60))		
	end
	-- L2C_DebugLog("OnMonthSignZeroRefresh:"..days)
	for x = 1,days do
		if (nDay == #tMonthSign_Info[nRoundNum].accumulation) then
			nDay = 1
			System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
			System_SetTempData(_idCharacter,nLuaIdActivity,2,0,false)
			System_SetTempData(_idCharacter,nLuaIdActivity,3,0,true)
			if nRoundNum == -1 or "table" ~= type(tMonthSign_Info[nRoundNum+1] ) then
				nRoundNum = -1
			else
				nRoundNum = nRoundNum + 1
			end
			--//轮次直接库里
			local nRound = System_GetTempData(_idCharacter,nLuaIdActivity,5)
			System_SetTempData(_idCharacter,nLuaIdActivity,5,nRound + 1,false)
		else
			nDay = nDay + 1
			-- L2C_DebugLog("OnMonthSignZeroRefresh  ".. (2 ^(nDay - 1)).."|"..bitGetSignStatus)
			--如果数据异常
			if 2 ^(nDay - 1) < bitGetSignStatus then
				--清空当天之后的数据
				for i = nDay,#tMonthSign_Info[nRoundNum].accumulation do
					if true == WCBit.GetBit(bitGetSignStatus,i) then
						-- L2C_DebugLog("OnMonthSignZeroRefresh  ".. i)
						bitGetSignStatus = WCBit.SetFalse(bitGetSignStatus,i)
						--扣除已签到天数
						System_SetTempData(_idCharacter,nLuaIdActivity,3,System_GetTempData(_idCharacter,nLuaIdActivity,3) - 1,false)
					end
				end
				System_SetTempData(_idCharacter,nLuaIdActivity,1,bitGetSignStatus,false)
				--清空补签天数
				System_SetTempData(_idCharacter,nLuaIdActivity,2,0,true)
			end
		end
	end

	System_SetTempData(_idCharacter,nLuaIdActivity,4,nDay,false)	
	System_SetTempData(_idCharacter,nLuaIdActivity,6,0,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,7,_nOsTimes)
end
table.insert(tOnZeroTrigger,OnMonthSignZeroRefresh)
table.insert(tOnZeroTrigger_Cross,OnMonthSignZeroRefresh)

-- /////////////////////////////////////////////////////////////////////////////////
--	记录离线时间
-- /////////////////////////////////////////////////////////////////////////////////
function OnMonthSignOffLine(_idCharacter,_nOsTimes)
	local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,7)
	--非同一天才记录
	if os.date("%x",_nOsTimes) ~= os.date("%x",nTime) then
		System_SetTempData(_idCharacter,nLuaIdActivity,7,_nOsTimes)
	end
end
table.insert(tOnLogoutActivity,OnMonthSignOffLine)
table.insert(tOnLogoutActivity_Cross,OnMonthSignOffLine)

-- /////////////////////////////////////////////////////////////////////////////////
--	充值记录
-- /////////////////////////////////////////////////////////////////////////////////
function OnMonthSign_Recharge(_idCharacter,_nEmoney,_nOsTimes)
	if System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		if 0 == System_GetTempData(_idCharacter,nLuaIdActivity,6) then
			System_SetTempData(_idCharacter,nLuaIdActivity,6,1)
		end
	end
end
table.insert(tOnUserRechargeEmoney,OnMonthSign_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,OnMonthSign_Recharge)