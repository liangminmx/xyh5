-- globaldata 表
-- 用于记录本日充值人数
--	Note：
--		全局掩码中:
--			data1 本条记录的有效日期
--			data2 本日参与充值的人数

-- 这两个 id 与玩家使用的 id 是一样的
local nResId = CRESOURCEFLOWACTION.eFT_Teamrecharge			-- 资源流向id
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]			-- 活动掩码id / 全局掩码表中的 id

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	全服任一玩家登入，就会创建该全局掩码
--	不主动触发，由任一玩家登入的时候触发
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Teamrecharge_AnyOne_OnLogin(_idCharacter,_nOsTimes)
	local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))
	-- System_SetTempData(_idCharacter,nLuaIdActivity,6,nowDay)--临时数据，跨服后删除
	if false == System_IsCrossSever() then
		local checkTime = System_GetGlobalData(nLuaIdActivity,1)
		local signDay = (0 < checkTime) and checkTime or nowDay
		if	nowDay ~= signDay then
			System_SetGlobalData(nLuaIdActivity,1,nowDay,false)
			System_SetGlobalData(nLuaIdActivity,2,0,false)
		end
	else
		--跨服上不进行重置处理
		-- System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_Restart,nLuaIdActivity)
	end
end
function Teamrecharge_AnyOne_OnLogin_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	-- local nowDay = System_GetTempData(_idCharacter,nLuaIdActivity,6)
	local nowDay = tonumber(os.date("%y%m%d",os.time()))
	local checkTime = _nData1
	local signDay = (0 < checkTime) and checkTime or nowDay
	if	nowDay ~= signDay then
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_Restart,nLuaIdActivity,1,nowDay,"")
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_Restart,nLuaIdActivity,2,0,"")
	end
	-- System_SetTempData(_idCharacter,nLuaIdActivity,6,0)
end
-- tGlobalDataQueryTrigeer[eCrossGlobbalActionType.Teamrecharge_Restart] = Teamrecharge_AnyOne_OnLogin_Cross

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	全服任一玩家触发 零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Teamrecharge_AnyOne_ZeroRefresh(_idCharacter,_nOsTimes)
	Teamrecharge_AnyOne_OnLogin(_idCharacter,_nOsTimes)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  全服达到条件人数增加
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Teamrecharge_AnyOne_Recharge(_idCharacter,_nOsTimes)
    local nowDay = tonumber(os.date("%y%m%d",_nOsTimes)) 
	if false == System_IsCrossSever() then
		local signDay = System_GetGlobalData(nLuaIdActivity,1)
		local nTotalNum = 0
		if	nowDay ~= signDay then
			System_SetGlobalData(nLuaIdActivity,1,nowDay,false)
		else
			nTotalNum = System_GetGlobalData(nLuaIdActivity,2)
		end
		nTotalNum = nTotalNum + 1
		System_SetGlobalData(nLuaIdActivity,2,nTotalNum,false)
		System_CallLuaOnline("</F>Teamrecharge_Syn_One</N>CHARACTER_ID",_idCharacter)
	else
		-- System_SetTempData(_idCharacter,nLuaIdActivity,6,nowDay) --跨服临时数据，跨服查询结束后置0
		System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_GetInfo,nLuaIdActivity)
	end
end
function Teamrecharge_AnyOne_Recharge_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	-- local nowDay=System_GetTempData(_idCharacter,nLuaIdActivity,6)
	local nowDay = tonumber(os.date("%y%m%d",_nOsTimes))
	local nTotalNum = 0
	if	nowDay ~= _nData1 then
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_GetInfo,nLuaIdActivity,1,nowDay,"")
	else
		nTotalNum = _nData2
	end
	nTotalNum = nTotalNum + 1
	System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_Restart,nLuaIdActivity,2,nTotalNum,"")
	-- System_SetTempData(_idCharacter,nLuaIdActivity,6,0)
	
end
--跨服需要等游服存好后再做操作,Teamrecharge_Restart
function Teamrecharge_AnyOne_Recharge_Cross_CallBack(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	System_CallLuaOnline("</F>Teamrecharge_Syn_One</N>CHARACTER_ID",_idCharacter)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.Teamrecharge_GetInfo] = Teamrecharge_AnyOne_Recharge_Cross
tGlobalDataUpdateTrigeer[eCrossGlobbalActionType.Teamrecharge_Restart] = Teamrecharge_AnyOne_Recharge_Cross_CallBack

--测试数据，设置全服人数
function Teamrecharge_SetGlobleNum(_num,_idCharacter)
	if false == System_IsCrossSever() then
		System_SetGlobalData(nLuaIdActivity,1,tonumber(os.date("%y%m%d",os.time())) )
		System_SetGlobalData(nLuaIdActivity,2,_num)
	else
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_Restart,nLuaIdActivity,1,tonumber(os.date("%y%m%d",os.time())),"")
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.Teamrecharge_Restart,nLuaIdActivity,2,_num,"")
	end
	System_CallLuaOnline("</F>Teamrecharge_Syn_One</N>CHARACTER_ID",_idCharacter)
end