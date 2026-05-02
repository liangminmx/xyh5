local DISCOUNT_MAX = 10000.0
local GETDISCOUNTTYPE = {
	eFT_Get_Discount = 1,
	eFT_Get_FunctionId = 2,
	eFT_Get_Active = 3,
	eFT_Get_Shop_Discount = 4,
}

local nResId = CRESOURCEFLOWACTION.eFT_ConsumeDiscount
local functionId =  _active_discount_Info["root"][1]["functionid"][1]["functionid"]
local tActiveDiscount_Server_Data = _active_discount_Info["root"][1]["open"]
local tActiveDiscount_Id_Data = _active_discount_Info["root"][1]["active"]
local tActiveDiscount_Random_Data = _active_discount_Info["root"][1]["random"][1]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	找lua要数据
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Active_Discount_GetData(_idCharacter,_nCActionType,_GetDateType,_nData4,_nData5)

	if	_nCActionType ~= nResId then
		return -1
	end
	
	if	_GetDateType == GETDISCOUNTTYPE.eFT_Get_Discount then
		return Active_Discount_GetDisCount(_nData4)	-- 折扣
		
	elseif	_GetDateType == GETDISCOUNTTYPE.eFT_Get_FunctionId then
		return Active_Discount_GetFunctionId()		-- function id
		
	elseif	_GetDateType == GETDISCOUNTTYPE.eFT_Get_Active then
		return Active_Discount_GetActivity(_nData4,_nData5)	-- 本日开启的活动
		
	elseif	_GetDateType == GETDISCOUNTTYPE.eFT_Get_Shop_Discount then
		return Active_Discount_GetShopDisCount(_nData4)
	end
end
tGetActivityData[nResId] = Active_Discount_GetData

-- =================================================================
--	得到商店中指定item的折扣
-- =================================================================
function Active_Discount_GetShopDisCount(_nItemId)
	if	nil == _nItemId then
		L2C_DebugLog("::Active_Discount_GetShopDisCount (nil)")
		return
	end
	
	-- 商城打折活动的activeId 是100,在 key = 10 的位置
	-- 配置的item 在 itemid 字段中，可配置多个，用逗号隔开
	local discount = 10000
	
	local nActiveKey = GetActive_Discount_Key(100)
	if	nil == nActiveKey then
		L2C_DebugLog("::Active_Discount_GetShopDisCount activeID = 100 is nil !!!")
		return discount
	end
	local tData = tActiveDiscount_Id_Data[nActiveKey]
	
	local bFindItemId = false
	local strItemId = tostring(tData["itemid"])	-- 只配置一个的话，会被当成 number的
	
	_nItemId = tostring(_nItemId)	-- 解析出来的itemId在table最后是string格式的，要格式一样才能判断 ==
	local tItemId = System_Split(strItemId,[[,]])
	for	k,v in pairs(tItemId) do
		if	_nItemId == v then	-- 配置该item可以打折
			bFindItemId = true
			break
		end
	end
	
	if	true == bFindItemId then
		discount = tData["discount"]
	end
	return discount
end

-- =================================================================
--	获得 active 中根据 activeID 得到key
-- =================================================================
function GetActive_Discount_Key(_nActiveId)
	for	k,v in pairs(tActiveDiscount_Id_Data) do
		if	_nActiveId == v["activeID"] then
			return k
		end
	end
end

-- =================================================================
--	得到活动的折扣
-- =================================================================
function Active_Discount_GetDisCount(_nActiveId)
	if	nil == _nActiveId then
		L2C_DebugLog("::Active_Discount_GetDisCount Error (nil)")
		return
	end
	
	local discount = 10000
	local nActiveKey = GetActive_Discount_Key(_nActiveId)
	if	nil == nActiveKey then
		L2C_DebugLog("::Active_Discount_GetShopDisCount activeID = ".._nActiveId.." is nil !!!")
		return discount
	end
	local tData = tActiveDiscount_Id_Data[nActiveKey]
	
	discount = tData["discount"]	
	return discount
end

-- =================================================================
-- 得到FunctionId
-- =================================================================
function Active_Discount_GetFunctionId()
	return functionId
end
-- =================================================================
--	获取指定时间的开启的活动
-- =================================================================
function Active_Discount_GetActivity(_nServerNum,_nOpenDay)
	if	nil == _nServerNum or nil == _nOpenDay then
		L2C_DebugLog("::Active_Discount_GetActivity ("..(_nServerNum or "nil").."|"..(_nOpenDay or "nil")..")")
		return
	end
	
	local tRetOpenActivity = {}
	local nServerKey = Active_Discount_GetMapOpenInfo(_nServerNum)
	local tActiveData = tActiveDiscount_Server_Data[nServerKey]
	
	if	_nOpenDay >= tActiveData["openday"] then
		local nDay = _nOpenDay - tActiveData["openday"] + 1
		
		if	"table" == type(tActiveData["activeday"][nDay]) then
			tRetOpenActivity = System_Split( tActiveData["activeday"][nDay]["activeID"], [[,]])
		else
			-- 超出了配置天数，随机开一个活动
			tRetOpenActivity = Active_Discount_Random()
		end
	end
	
	-- 把table中的数字按照位运算，拼接成一个数字
	local nRet = 0
	for	k,v in pairs(tRetOpenActivity) do
		nRet = WCBit.SetTrue(nRet,v)
	end
	return nRet
end

-- =================================================================
--	得到根据开服次数得到活动总信息
-- =================================================================
function Active_Discount_GetMapOpenInfo(_nServerNum)
	local nDefaultServerNum = -1
	local nDefaultKey
	for	k,v in pairs(tActiveDiscount_Server_Data) do
		if	_nServerNum == v["servernum"] then
			return k
		end
		if	nDefaultServerNum == v["servernum"] then
			nDefaultKey = k
		end
	end
	return nDefaultKey
end

-- =================================================================
--	获取随机任务
-- =================================================================
function Active_Discount_Random()
	local selectActivity = {}
	local activityNum = tActiveDiscount_Random_Data["randomNum"]
	local tRandomId = System_Split( tActiveDiscount_Random_Data["activeID"], [[,]])
	
	if	activityNum > (#tRandomId) then
		L2C_DebugLog("::Active_Discount_Random total not enough!!!")
		return selectActivity
	elseif	activityNum == (#tRandomId) then
		return tRandomId
	end
	
	
	for i = 1,5000,1 do
		local nRandomIndex = math.random(1, (#tRandomId))
		local bHadRandom = false
		
		for	k,v in pairs(selectActivity) do
			if	v == tRandomId[nRandomIndex] then
				L2C_DebugLog("::Active_Discount_Random do not write same activeID !!!!") -- tRandomId 中就不该有重复的！
				bHadRandom = true
				break	
			end
		end
		
		if	false == bHadRandom then
			table.insert( selectActivity, tRandomId[nRandomIndex])
			table.remove(tRandomId,nRandomIndex)
		end
		
		if	activityNum <= (#selectActivity) then
			return selectActivity
		end
		
	end
	

	selectActivity = {}
	for i = 1,activityNum,1 do -- 不随机了，直接去取前  activityNum 个
		table.insert(selectActivity,tRandomId[i])
	end
	return selectActivity
end
