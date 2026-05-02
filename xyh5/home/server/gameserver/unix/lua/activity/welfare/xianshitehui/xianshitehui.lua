-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1-4 	字段，礼包的ID和购买状态   AAB AA为ID B为购买状态 0未买 1已买
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local nflowaction = CRESOURCEFLOWACTION.eFT_XianShiTeHui
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]

local tXianShiTeHuiInfo = _xianshitehui_Info["root"][1]
local tXianShiTeHuiInfo_Lv = tXianShiTeHuiInfo["lv"][1]
local tXianShiTeHuiInfo_Open = tXianShiTeHuiInfo["open"]

local tXianShiTeHuiOpenServer = {} --开启的是哪个servernum下的活动
local nXianShiTeHuiOptionNum = 4	--有几个选项

local eXSTHLT_Syn = 1
local eXSTHLT_Buy = 2

local eXSTHC_Success = 0		--成功
local eXSTHC_Unknow = 1			--未知错误
local eXSTHC_HasBuy = 2			--已购买过
local eXSTHC_EmoneyEnough = 3	--元宝不足
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function XianShiTeHui_Login(_idCharacter,_nOsTimes)
	if false == XianShiTeHui_Login_CheckOpen(_idCharacter) then
		return
	end
	XianShiTeHui_Init(_idCharacter)
	XianShiTeHui_Syn(_idCharacter)
end
table.insert(tOnLoginActivity,XianShiTeHui_Login)
table.insert(tOnLoginActivity_Cross,XianShiTeHui_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function XianShiTeHui_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if eXSTHLT_Syn == _nData3 then
		return XianShiTeHui_SynReq(_idCharacter)
	end
	if eXSTHLT_Buy == _nData3 then
		local nCode = XianShiTeHui_BuyReq(_idCharacter,_nCActionType,_nData4,_nData5)
		System_XianShiTeHuiBuy(_idCharacter,nCode,_nData4,_nData5)
		-- L2C_DebugLog(nCode)
		return nCode
	end
	return eXSTHC_Unknow
end
tOnOnAcitveAward[nflowaction] = XianShiTeHui_Req
tOnOnAcitveAward_Cross[nflowaction] = XianShiTeHui_Req

-- function TT(_opt,_id)
	-- local nCode = XianShiTeHui_BuyReq(1001000001,644,_opt,_id)
	-- L2C_DebugLog(nCode)
	-- return nCode
-- end
--/calllua </F>TT</N>2</N>1
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		0点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function XianShiTeHui_ZeroRefresh(_idCharacter,_nOsTimes)
	if false == XianShiTeHui_Login_CheckOpen(_idCharacter) then
		return
	end
	local tConfig = XianShiTeHui_GetServerNumConfig(_idCharacter)
	--这个只会在游服触发 所以不用区分跨服
	local nOpenDay = System_GetOpenServerDay()
	local tOptionsInfo = {}
	for i = 1,nXianShiTeHuiOptionNum do
		local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,i)	
		local nNowId,nGet = math.modf(nStatus / 10)
		local tGiftId = {} -- 今天可开启的礼包
		for k,v in pairs(tConfig.slot)do
			if v.options == i then
				if nOpenDay >= v.openday and (nOpenDay < v.openday + v.continueday or -1 == v.continueday )then
					tGiftId[v.id] = 1
				end
			end
		end		
		--当前的活动已过期
		if tGiftId[nNowId] == nil then
			--没有领取奖励
			if nGet == 0 then
				--记未领经分
				System_XianShiTeHuiLog(_idCharacter,i,nNowId,0)
			end
		end
		--非 未过期且未领 刷新礼包
		if false ==(tGiftId[nNowId] ~= nil and nGet == 0) then
			local nNewId = nNowId
			for k,v in pairs(tGiftId) do
				if k > nNowId and (k < nNewId or nNowId == nNewId )then	
					nNewId = k
				end
			end
			--存在新的活动开启
			if nNewId ~= nNowId then
				tOptionsInfo[i] = nNewId * 10 
			else
				tOptionsInfo[i] = nNewId * 10 + 1
			end
		end		
	end
	for k,v in pairs(tOptionsInfo) do
		System_SetTempData(_idCharacter,nLuaIdActivity,k,v)
	end
	XianShiTeHui_Syn(_idCharacter)
end
table.insert(tOnZeroTrigger,XianShiTeHui_ZeroRefresh)

-- ================================================================================================================
--		根据合服取配置
-- ================================================================================================================
function XianShiTeHui_GetServerNumConfig(_idCharacter)
	if next(tXianShiTeHuiOpenServer) ~= nil then
		return tXianShiTeHuiOpenServer
	end	
	local nCombined = -1
	if false == System_IsCrossSever() then
		nCombined = System_GetCombinedTimes()
	else
		nCombined = System_GetCombinedTimesByCharacter(_idCharacter)
	end
	for k,v in pairs(tXianShiTeHuiInfo_Open) do
		if nCombined == v.servernum then
			tXianShiTeHuiOpenServer = tXianShiTeHuiInfo_Open[k]
			return tXianShiTeHuiOpenServer
		end
		if -1 == v.servernum then
			tXianShiTeHuiOpenServer = tXianShiTeHuiInfo_Open[k]
		end
	end
	if next(tXianShiTeHuiOpenServer) == nil then
		L2C_DebugLog(string.format("::XianShiTeHui_GetServerNumConfig Data Error: CombinedTimes[%d]",nCombined))
	end
	return tXianShiTeHuiOpenServer
end

-- ================================================================================================================
--		活动开启检测
-- ================================================================================================================
function XianShiTeHui_Login_CheckOpen(_idCharacter)
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) 
	if "number" ~= type(tXianShiTeHuiInfo_Lv.lv) or  nLevel < tXianShiTeHuiInfo_Lv.lv then
		return false
	end
	
	local tConfig = XianShiTeHui_GetServerNumConfig(_idCharacter)
	if nil == next(tConfig )then
		return false
	end

	local nOpenDay = XianShiTeHui_GetOpenDay(_idCharacter)
	if "number" ~= type(tConfig.openday) or  nOpenDay < tConfig.openday then
		return false
	end
	
	return true
end
-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function XianShiTeHui_Init(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	System_AddTempData(_idCharacter,nLuaIdActivity)	
	local tConfig = XianShiTeHui_GetServerNumConfig(_idCharacter)
	local nOpenDay = XianShiTeHui_GetOpenDay(_idCharacter)
	local tOptionsInfo = {}
	for k,v in pairs(tConfig.slot) do
		if "number" == type(v.openday) and "number" == type(v.continueday) then
			if nOpenDay >= v.openday and (nOpenDay < v.openday + v.continueday or -1 == v.continueday ) then
				if nil ~= tOptionsInfo[v.options] then
					if v.id < tOptionsInfo[v.options] then
						tOptionsInfo[v.options] = v.id * 10
					end
				else		
					tOptionsInfo[v.options] = v.id * 10
				end
			else
				if nil == tOptionsInfo[v.options] then	
					tOptionsInfo[v.options] = v.id * 10 + 1
				end
			end
		end
	end
	for k,v in pairs(tOptionsInfo) do
		System_SetTempData(_idCharacter,nLuaIdActivity,k,v)
	end
end
-- ================================================================================================================
--		同步活动信息
-- ================================================================================================================
function XianShiTeHui_Syn(_idCharacter)
	local sStatus = ""
	for i = 1,nXianShiTeHuiOptionNum do
		local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,i)
		local modStatus = math.modf(nStatus / 10)
		sStatus = sStatus .. (modStatus).. "," .. (nStatus % 10)
		if i ~= nXianShiTeHuiOptionNum then
			sStatus = sStatus .. ";"
		end
	end	
	System_XianShiTeHuiSyn(_idCharacter,sStatus)
end
-- ================================================================================================================
--		同步活动信息请求
-- ================================================================================================================
function XianShiTeHui_SynReq(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		XianShiTeHui_Init(_idCharacter)
	end
	XianShiTeHui_Syn(_idCharacter)
	return eXSTHC_Success
end

-- ================================================================================================================
--		购买礼包请求
-- ================================================================================================================
function XianShiTeHui_BuyReq(_idCharacter,_nCActionType,_nOptiton,_nId)
	if _nOptiton > nXianShiTeHuiOptionNum or _nOptiton < 0 then
		return eXSTHC_Unknow
	end
	local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,_nOptiton)
	
	if nStatus % 10 ~= 0 then
		return eXSTHC_HasBuy
	end
	--非正确的礼包
	if math.modf(nStatus / 10) ~= _nId then
		return eXSTHC_Unknow
	end

	local tConfig =XianShiTeHui_GetServerNumConfig(_idCharacter)
	local tSlot = {}
	for k,v in pairs(tConfig.slot) do
		if v.id == _nId and v.options == _nOptiton then
			tSlot = tConfig.slot[k]
			break
		end
	end
	--校验礼包时间是否合法
	local nOpenDay = XianShiTeHui_GetOpenDay(_idCharacter)
	if "number" == type(tSlot.openday) and "number" == type(tSlot.continueday) then
		if nOpenDay >= tSlot.openday and (nOpenDay < tSlot.openday + tSlot.continueday or -1 == tSlot.continueday ) then
		else
			return eXSTHC_Unknow
		end
	else
		return eXSTHC_Unknow
	end
	
	if "number" ~= type(tSlot.emoney) or false == System_SpendEmoney(_idCharacter,tSlot.emoney,_nCActionType) then
		return eXSTHC_EmoneyEnough
	end
	
	System_SetTempData(_idCharacter,nLuaIdActivity,_nOptiton,(nStatus + 1))
	
	local tItem = {}	
	
	for k,v in pairs(tSlot.reward) do
		if type(v.timemode)  == "number" then
			local time_n = "number" == type(v["expiredtme"]) and v["expiredtme"] or 0
			time_n =System_timeModeTransfer(v.timemode,time_n)	
			table.insert(tItem,{v.item,v.num,0,v.bind,v.timemode,time_n}) 
		else
			table.insert(tItem,{v.item,v.num,0,v.bind}) 
		end
	end
	--可以放入背包
	if true == System_CanPushThingsToBagEx(_idCharacter,tItem) then
		if	"table" == type(tSlot.reward) then
			for	k,v in pairs(tSlot.reward) do
				local nIdItem = "number" == type(v["item"]) and v["item"] or 0
				local nNum = "number" == type(v["num"]) and v["num"] or 0
				local timeMode = "number" == type(v["timemode"]) and v["timemode"] or 0
				local time_n = "number" == type(v["expiredtme"]) and v["expiredtme"] or 0
	
				time_n =System_timeModeTransfer(timeMode,time_n)			
				if nIdItem ~= 0 then
					if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n) then
						System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum,0,0,0,0,timeMode,time_n)
					end
				end
			end
		end
	else
		if "number" == type(tXianShiTeHuiInfo_Lv.mail) then
			System_SendMail(_idCharacter,tXianShiTeHuiInfo_Lv.mail,tItem)
		else
			L2C_DebugLog("::XianShiTeHui_BuyReq Data Error: mail ")
		end
	end	
	
	System_XianShiTeHuiLog(_idCharacter,_nOptiton,_nId,1)
	
	return eXSTHC_Success
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级触发 等级到了开启活动
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function XianShiTeHui_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	XianShiTeHui_Login(_idCharacter)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],XianShiTeHui_LevelUp)
tQuestTrigeer_Cross[TASKTYPE.LevelUp] = tQuestTrigeer_Cross[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],XianShiTeHui_LevelUp)

function XianShiTeHui_GetOpenDay(_idCharacter)
	if false == System_IsCrossSever() then
		return System_GetOpenServerDay()
	else
		return System_GetOpenServerDayByCharacter(_idCharacter)
	end
	return 0
end