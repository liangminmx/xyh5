local nResId = CRESOURCEFLOWACTION.eFT_FestivalLogin
local nResId = CRESOURCEFLOWACTION.eFT_FestivalLogin
local nLuaTempid = LUARESOURCEFLOWACTION[nResId]
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local festivallogin_Info = _festival_login_Info['root'][1]['group']

local eFLLT_Syn = 1
local eFLLT_Award = 2

local eFLAC_Success 	= 0	 --领取成功
local eFLAC_Unknow 		= 1  --未知错误
local eFLAC_LevelLess 	= 2  --等级不足
local eFLAC_IsGot 		= 3  --已经领过
local eFLAC_BagFull		= 4	 --背包已满

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--			data1: 活动状态		 0未开启  	1开启
--			data2: 奖励领取状态  0未领 		1已领
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 玩家登录
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FestivalLogin_Person_Login(_idCharacter,_nOsTimes)
	_nOSTime = _nOSTime or os.time()
	GM_FestticalLogin_instance_Login(_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaTempid) then
		System_AddTempData(_idCharacter,nLuaTempid,false)
	end
	FestivalLogin_Person_SendActiveStatus(_idCharacter)
end
table.insert(tOnLoginActivity,FestivalLogin_Person_Login)

-- ===============================================================================================================
-- 发放活动状态给客户端
-- =============================================================================================================== 
function FestivalLogin_Person_SendActiveStatus(_idCharacter)	
	local status = System_GetGlobalData(nLuaGlobal,1)
	local status_p = System_GetTempData(_idCharacter,nLuaTempid,1)
	local status_award = System_GetTempData(_idCharacter,nLuaTempid,2)
	local nBeg = 0
	local nEnd = 0
	if status == 1 then
		nBeg = System_GetGlobalData(nLuaGlobal,2)
		nEnd = System_GetGlobalData(nLuaGlobal,3)		
		System_Festival_Login_Syn(_idCharacter,System_GetGlobalData(nLuaGlobal,4),status,nBeg,nEnd,status_award)
		System_SetTempData(_idCharacter,nLuaTempid,1,1)		
		-- System_SendActiveStatus(_idCharacter,nResId,status,nBeg,nEnd)
	end
	
	if status == 0 and status_p == 1 then
		System_SetTempData(_idCharacter,nLuaTempid,1,0)	
		System_SetTempData(_idCharacter,nLuaTempid,2,0)	
		System_Festival_Login_Syn(_idCharacter,System_GetGlobalData(nLuaGlobal,4),status,nBeg,nEnd,status_award)
		-- System_SendActiveStatus(_idCharacter,nResId,status,nBeg,nEnd)
	end	
end

-- ===============================================================================================================
-- 服务端消息入口
-- =============================================================================================================== 
function FestivalLogin_Person_ReqMain(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	if eFLLT_Syn == _nData1 then
		return FestivalLogin_Person_Syn(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	end
	if eFLLT_Award == _nData1 then
		local nCode = FestivalLogin_Person_Award(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
		System_Festival_Login_Award(_idCharacter,System_GetGlobalData(nLuaGlobal,4),nCode)
		return nCode
	end
	return eFLAC_Unknow
end
tOnOnAcitveAward[nResId] = FestivalLogin_Person_ReqMain

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 同步消息
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function FestivalLogin_Person_Syn(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	local status = System_GetGlobalData(nLuaGlobal,1)
	local status_award = System_GetTempData(_idCharacter,nLuaTempid,2)
	local nBeg = System_GetGlobalData(nLuaGlobal,2)
	local nEnd = System_GetGlobalData(nLuaGlobal,3)	
	System_Festival_Login_Syn(_idCharacter,System_GetGlobalData(nLuaGlobal,4),status,nBeg,nEnd,status_award)
end
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 领取奖励
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function FestivalLogin_Person_Award(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)	
	--处理所在组信息
	local nGroup = System_GetGlobalData(nLuaGlobal,4)	
	local tGroupInfokey = 0
	for k,v in pairs(festivallogin_Info) do
		if v.id == nGroup then
			tGroupInfokey = k
		end
	end
	if "table" ~= type(festivallogin_Info[tGroupInfokey]) then
		return eFLAC_Unknow
	end
	
	local tGroupInfo = festivallogin_Info[tGroupInfokey]
	--判断等级
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if tGroupInfo.lv > nLevel then
		return eFLAC_LevelLess
	end
	--判断领取状态
	local status_award = System_GetTempData(_idCharacter,nLuaTempid,2)
	if status_award ~= 0 then
		return eFLAC_IsGot
	end
	local tReward = tGroupInfo.reward[1]
	--判断背包空间
	local sItem = ""	 
	for k,v in pairs(tReward.item) do
		local nIdItem = "number" == type(v["itemid"]) and v["itemid"] or 0
		local nNum = "number" == type(v["itemnum"]) and v["itemnum"] or 0
		sItem = sItem .. nIdItem .. "," .. nNum .. ";"
	end
	if false == System_CanPushThingsToBagEx(_idCharacter,sItem) then
		return eFLAC_BagFull
	end
	--设置掩码
	System_SetTempData(_idCharacter,nLuaTempid,2,1)
	--发放奖励
	local nExp = "number" == type(tReward.exp) and tReward.exp or 0
	if nExp > 0 then
		System_AwardExp(_idCharacter,nExp, _nCActionType)
	end
	local nMoney = "number" == type(tReward.money) and tReward.money or 0
	if nMoney > 0 then
		System_AwardMoney(_idCharacter,nMoney, _nCActionType)
	end
	for k,v in pairs(tReward.item) do
		local nIdItem = "number" == type(v["itemid"]) and v["itemid"] or 0
		local nNum = "number" == type(v["itemnum"]) and v["itemnum"] or 0
		local nBind = "number" == type(v["bind"]) and v["bind"] or 0 --下面接口给的东西都是绑定的
		System_AwardThingInBag(_idCharacter,_nCActionType,nIdItem,nNum)
	end	
	return eFLAC_Success
end