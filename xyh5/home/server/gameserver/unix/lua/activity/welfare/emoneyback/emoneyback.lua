-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1 字段，周卡剩余天数
--				 data2 字段，月卡剩余天数
--				 data3 字段，季卡剩余天数
--				 data4 字段，年卡剩余天数
--				 data7 字段，上次离线时间
--				 data8 字段，今日充值
--				 dataStr 字段，x,x,x 指定月卡类型的购买次数，零点刷新不会重置该数据
--
--		领取掩码
--				 data1 字段，周卡今日领取状态 0未开启 1未领取 2已领取 3已过期
--				 data2 字段，月卡今日领取状态
--				 data3 字段，季卡今日领取状态
--				 data4 字段，年卡今日领取状态
--				 data8 字段，总类型的数量
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local eEMoneyBackCode =
{
	Unknow = 0,
	Succeed = 1,
	HasBought = 2,		--//已经购买了
	RechargeNotEnough = 3,		--//充值不足
	NotEnoughEMoney = 4,		--//元宝不足
	NotBuy = 5,			--//还未购买
	AlreadyGet = 6,		--//已经领取
	NotGetCount = 7,		--//没有领取次数
	NotEnoughLevel = 8,
}

local nLuaIdBuy = LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackBuy]		--购买掩码
local nLuaIdGet = LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackGet]		--领取掩码
local nLuaIdTime= LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_EMoneyBackBuyTimes] --购买次数掩码
local _nEmoneyBackFunction = _emoneyback_Info.root[1].functionid[1].functionid
local tEmoneyBack_Data = _emoneyback_Info.root[1].open[1]
local nCardTypes = #tEmoneyBack_Data.rebate
local nBuyAllType = 9
local nAllNotice = tEmoneyBack_Data.noticeid
-- ===================================================
--是否开启该活动
-- ===================================================
function EmoneyBack_IsOpen(_idCharacter)
	if System_GetOpenServerDay() >= tEmoneyBack_Data.openday and System_OpenGuideFunction(_idCharacter,_nEmoneyBackFunction) then
		if	false == System_IsExistTempData(_idCharacter,nLuaIdBuy) then
			System_AddTempData(_idCharacter,nLuaIdBuy)	
		end
		if	false == System_IsExistTempData(_idCharacter,nLuaIdGet) then
			System_AddTempData(_idCharacter,nLuaIdGet)	
			System_SetTempData(_idCharacter,nLuaIdGet,8,#tEmoneyBack_Data.rebate)
		end
		if false == System_IsExistTempData(_idCharacter,nLuaIdTime) then
			System_AddTempData(_idCharacter,nLuaIdTime)
			--处理旧号，还有未领取的标识为第一次买
			for i = 1,nCardTypes do
				if 0 ~= System_GetTempData(_idCharacter,nLuaIdGet,i) then
					System_SetTempData(_idCharacter,nLuaIdTime,i,1,false)
				end
			end
		end
		return true
	end
	return false	
end
-- ===================================================
--登录处理
-- ===================================================
function EmoneyBack_OnLogin(_idCharacter,_nOsTimes)
	if false == EmoneyBack_IsOpen(_idCharacter) then
		System_DelTempData(_idCharacter,nLuaIdBuy)	
		System_DelTempData(_idCharacter,nLuaIdGet)	
	end
end
table.insert(tOnLoginActivity,EmoneyBack_OnLogin)
table.insert(tOnLoginActivity_Cross,EmoneyBack_OnLogin)
-- ===================================================
--0点重置
-- ===================================================
function EmoneyBack_ZeroReset(_idCharacter,_nOsTimes)	
	--L2C_DebugLog("EmoneyBack_ZeroReset")
	local bRetBuy,tTempBuy = WCTempData:Get(_idCharacter,nLuaIdBuy)
	local bRetGet,tTempGet = WCTempData:Get(_idCharacter,nLuaIdGet)
	if not(bRetBuy and bRetGet)  then
		return
	end
	
	local nLogoutTIme = tTempBuy[7]
	local days = 1	--间隔了几天
	if nLogoutTIme > 0 and _nOsTimes > nLogoutTIme then
		days = math.ceil((System_GetZeroTime(_nOsTimes) - nLogoutTIme) / (24*60*60))
	end
	--必须一天天来  要记录经分
	for x = 1,days do
		for i = 1,nCardTypes do			
			tTempBuy[i] = (tTempGet[i] == 1)and (tTempBuy[i] + 1)  or tTempBuy[i]
			tTempGet[i] = (tTempGet[i] == 1) and 3 or tTempGet[i]
			--L2C_DebugLog("EmoneyBack_ZeroReset"..tTempBuy[i].."|"..tTempGet[i]) 
		end
		tTempBuy[8] = 0
		tTempBuy.Update(1)
		tTempGet.Update(1)
		--记完经分后
		for i = 1,nCardTypes do		
			if (tEmoneyBack_Data.rebate[i] and tEmoneyBack_Data.rebate[i]["lasttime"]) then
				if tTempBuy[i] >= tEmoneyBack_Data.rebate[i]["lasttime"] then
					tTempGet[i] = 0				
				else
					if tTempGet[i] ~= 0 then
						tTempGet[i] = 1
					end
				end
			end
		end
		tTempGet.Update(1)
	end
	tTempBuy[7] = _nOsTimes
end
table.insert(tOnZeroTrigger,EmoneyBack_ZeroReset)
table.insert(tOnZeroTrigger_Cross,EmoneyBack_ZeroReset)
-- ===================================================
--购买
-- ===================================================
function EmoneyBack_processEMoneyBackBuyReq(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	local bRetBuy,tTempBuy = WCTempData:Get(_idCharacter,nLuaIdBuy)
	local bRetGet,tTempGet = WCTempData:Get(_idCharacter,nLuaIdGet)	
	local bRetTimes,tTempTimes = WCTempData:Get(_idCharacter,nLuaIdTime)	
	if not (bRetBuy and bRetGet and bRetTimes) then
		return eEMoneyBackCode.NotEnoughLevel
	end
	--记录当前卡类型数量
	tTempGet[8] = #tEmoneyBack_Data.rebate	
	if _nType <= #tEmoneyBack_Data.rebate then
		--非正确的返利卡类型
		if not ("number" == type(_nType) and "table"== type(tEmoneyBack_Data.rebate[_nType])) then
			return eEMoneyBackCode.Unknow
		end
		if tTempGet[_nType] ~= 0 then
			return eEMoneyBackCode.HasBought
		end
		if tTempBuy[8] < (tEmoneyBack_Data.rebate[_nType]["needcost"] or 999999999) then
			return eEMoneyBackCode.RechargeNotEnough
		end		
		--扣除金币
		-- L2C_DebugLog(tEmoneyBack_Data.rebate[_nType]["costemoney"])
		if "number" ~= type(tEmoneyBack_Data.rebate[_nType]["costemoney"]) 
			or false == System_SpendEmoney(_idCharacter,tEmoneyBack_Data.rebate[_nType]["costemoney"],CRESOURCEFLOWACTION.eFT_EMoneyBackBuy)	
		then
			return eEMoneyBackCode.NotEnoughEMoney
		end
		
		local buyTimes = GetDataStr_EmoneyBack(tTempBuy["str"])
		-- 记录购买次数
		tTempBuy["str"] = SetDataStr_EmoneyBack(tTempBuy["str"],_nType)
		
		tTempBuy[_nType] = 0
		tTempGet[_nType] = 1
		tTempTimes[_nType] = tTempTimes[_nType] + 1
		--改为给绑定元宝
		System_AwardVouchers(_idCharacter,tEmoneyBack_Data.rebate[_nType]["buyemoney"] or 0,CRESOURCEFLOWACTION.eFT_EMoneyBackBuy)
		local bBuff = tEmoneyBack_Data.rebate[_nType]["buff"]
		if ("number" == type(bBuff) and 0 < bBuff) then
			System_AddBuff(_idCharacter,bBuff)
		end
		for k,v in ipairs ( tEmoneyBack_Data.rebate[_nType].itemrebate) do
			local nIdItem = v["itemid"]
			local nNum = v["num"]
			if nIdItem > 0 and nNum > 0 then
				if	false == System_AwardThingInBag(_idCharacter,CRESOURCEFLOWACTION.eFT_EMoneyBackBuy,nIdItem,nNum) then
					System_AwardThingQuestContainer(_idCharacter,CRESOURCEFLOWACTION.eFT_EMoneyBackBuy,nIdItem,nNum)
				end
			end
		end
		if "0" == buyTimes[_nType] then
			System_AddDomainExp(_idCharacter, tEmoneyBack_Data.rebate[_nType]["domainexp"])
		end
		if "number" ==  type(tEmoneyBack_Data.rebate[_nType].noticeid) then
			EmoneyBack_SendBroadCast(_idCharacter,tEmoneyBack_Data.rebate[_nType].noticeid)
		end
	end
	--全部购买
	if _nType == nBuyAllType then
		if tTempBuy[8] < (tEmoneyBack_Data.allrecharge) then
			return eEMoneyBackCode.RechargeNotEnough
		end		
		for i = 1,nCardTypes do
			if tTempGet[i] ~= 0 then
				return eEMoneyBackCode.HasBought
			end
		end		
		--扣除金币
		if "number" ~= type(tEmoneyBack_Data.allbuycost) 
			or false == System_SpendEmoney(_idCharacter,tEmoneyBack_Data.allbuycost,CRESOURCEFLOWACTION.eFT_EMoneyBackBuyAll)	
		then
			return eEMoneyBackCode.NotEnoughEMoney
		end
		
		local buyTimes = GetDataStr_EmoneyBack(tTempBuy["str"])
		tTempBuy["str"] = SetDataStr_EmoneyBack(tTempBuy["str"],_nType)
		
		for i = 1,nCardTypes do
			tTempBuy[i] = 0
			tTempGet[i] = 1
			tTempTimes[i] = tTempTimes[i] + 1
			System_AwardVouchers(_idCharacter,tEmoneyBack_Data.rebate[i]["buyemoney"] or 0,CRESOURCEFLOWACTION.eFT_EMoneyBackBuy)
			local bBuff = tEmoneyBack_Data.rebate[i]["buff"]
			if ("number" == type(bBuff) and 0 < bBuff) then
				System_AddBuff(_idCharacter,bBuff)
			end
			for k,v in ipairs ( tEmoneyBack_Data.rebate[i].itemrebate) do
				local nIdItem = v["itemid"]
				local nNum = v["num"]
				if nIdItem > 0 and nNum > 0 then
					if	false == System_AwardThingInBag(_idCharacter,CRESOURCEFLOWACTION.eFT_EMoneyBackBuy,nIdItem,nNum) then
						System_AwardThingQuestContainer(_idCharacter,CRESOURCEFLOWACTION.eFT_EMoneyBackBuy,nIdItem,nNum)
					end
				end
			end
			if "0" == buyTimes[i] then
				System_AddDomainExp(_idCharacter, tEmoneyBack_Data.rebate[i]["domainexp"])
			end
		end
		if "number" ==  type(nAllNotice) then
			EmoneyBack_SendBroadCast(_idCharacter,nAllNotice)
		end
	end
	--tTempBuy.Update()
	return eEMoneyBackCode.Succeed
	
end
tOnOnAcitveAward[CRESOURCEFLOWACTION.eFT_EMoneyBackBuy] = EmoneyBack_processEMoneyBackBuyReq
tOnOnAcitveAward_Cross[CRESOURCEFLOWACTION.eFT_EMoneyBackBuy] = EmoneyBack_processEMoneyBackBuyReq
-- ===================================================
--领取
-- ===================================================
function EmoneyBack_processEMoneyBackGetReq(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	local bRetBuy,tTempBuy = WCTempData:Get(_idCharacter,nLuaIdBuy)
	local bRetGet,tTempGet = WCTempData:Get(_idCharacter,nLuaIdGet)	
	if not (bRetBuy and bRetGet) then
		return eEMoneyBackCode.NotEnoughLevel
	end 
	--非正确的返利卡类型
	if not ("number" == type(_nType) and "table"== type(tEmoneyBack_Data.rebate[_nType])) then
		return eEMoneyBackCode.Unknow
	end
	if tTempGet[_nType] == 0 then
		return eEMoneyBackCode.NotBuy
	end	
	if tTempGet[_nType] ~= 1 then
		return eEMoneyBackCode.AlreadyGet
	end
	tTempGet[_nType] = 2
	tTempBuy[_nType] = tTempBuy[_nType] + 1
	
	local buyTimes = GetDataStr_EmoneyBack(tTempBuy["str"])
	-- 记录购买次数
	tTempBuy["str"] = SetDataStr_EmoneyBack(tTempBuy["str"],_nType)

	System_AwardVouchers(_idCharacter,tEmoneyBack_Data.rebate[_nType]["backemoney"] or 0,CRESOURCEFLOWACTION.eFT_EMoneyBackGet)
	
	if "0" == buyTimes[_nType] then
			System_AddDomainExp(_idCharacter, tEmoneyBack_Data.rebate[_nType]["domainexp"])
		end
	--tTempGet.Update()
	return eEMoneyBackCode.Succeed
end
tOnOnAcitveAward[CRESOURCEFLOWACTION.eFT_EMoneyBackGet] = EmoneyBack_processEMoneyBackGetReq
tOnOnAcitveAward_Cross[CRESOURCEFLOWACTION.eFT_EMoneyBackGet] = EmoneyBack_processEMoneyBackGetReq
-- ===================================================
--充值
-- ===================================================
function EmoneyBack_Recharge(_idCharacter,_nEmoney)
	local bRetBuy,tTempBuy = WCTempData:Get(_idCharacter,nLuaIdBuy)
	if not bRetBuy then
		return
	end
	tTempBuy[8] = tTempBuy[8] + _nEmoney
	tTempBuy.Update()
end
table.insert(tOnUserRechargeEmoney,EmoneyBack_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,EmoneyBack_Recharge)



-- /////////////////////////////////////////////////////////////////////////////////
--	记录离线时间
-- /////////////////////////////////////////////////////////////////////////////////
function OnEmoneyOffLine(_idCharacter,_nOsTimes)
	local nTime = System_GetTempData(_idCharacter,nLuaIdBuy,7)
	--非同一天才记录
	if os.date("%x",_nOsTimes) ~= os.date("%x",nTime) then
		System_SetTempData(_idCharacter,nLuaIdBuy,7,_nOsTimes)
	end
end
table.insert(tOnLogoutActivity,OnEmoneyOffLine)
table.insert(tOnLogoutActivity_Cross,OnEmoneyOffLine)

-- /////////////////////////////////////////////////////////////////////////////////
--	设置买月卡记录的 datastr
-- /////////////////////////////////////////////////////////////////////////////////
function SetDataStr_EmoneyBack(_str,_nType)
	
	local strRes = ""
	local tBuyTimes = System_Split(_str,",")
	
	if	"table" == type(tBuyTimes) and next(tBuyTimes) ~= nil then
		for	k,v in pairs(tBuyTimes) do
			if	nil ~= tonumber(tBuyTimes[k]) then
				tBuyTimes[k] = tonumber(tBuyTimes[k])
			else
				L2C_DebugLog("::SetDataStr_EmoneyBack read a data error !!!")
			end
		end
	end
	
	
	if 	_nType <= #tEmoneyBack_Data.rebate then	
		local nTimes = tBuyTimes[_nType] or 0
		tBuyTimes[_nType] = nTimes + 1
	end
	
	if _nType == nBuyAllType then		
		for	i = 1,(#tEmoneyBack_Data.rebate),1 do
			local nTimes = tBuyTimes[i] or 0
			tBuyTimes[i] = nTimes + 1
		end
	end
	
	for	i = 1,(#tEmoneyBack_Data.rebate),1 do
		local nTimes = tBuyTimes[i] or 0		
		if	i < (#tEmoneyBack_Data.rebate) then
			strRes = strRes .. string.format("%d",nTimes) .. ","
		else
			strRes = strRes .. string.format("%d",nTimes)
		end
	end
	
	return strRes
end

-- /////////////////////////////////////////////////////////////////////////////////
--	获取买月卡记录的 datastr
-- /////////////////////////////////////////////////////////////////////////////////
function GetDataStr_EmoneyBack(_str)
	local tBuyTimes = {}
	if	_str ~= "" then
		tBuyTimes = System_Split(_str,",")
	else
		for	i = 1,(#tEmoneyBack_Data.rebate),1 do
			tBuyTimes[i] = "0"
		end
	end
	return tBuyTimes
end
-- /////////////////////////////////////////////////////////////////////////////////
--	购买后发放广播
-- /////////////////////////////////////////////////////////////////////////////////
function EmoneyBack_SendBroadCast(_idCharacter,_nBroadId)
		local sParam = string.format("%d,%u;%d,%s"
									,ePreparedStatementValueType.TYPE_UI64,_idCharacter
									,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)									
									)
		System_SendCommonBroadCastMsg(_nBroadId,sParam)
end
