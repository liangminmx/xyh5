local nResId = CRESOURCEFLOWACTION.eFT_FestivalWeb
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local festivalweb_Info = _festivalweb_Info['root'][1]['group']

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 由 gm 开启
--  Note:
--      data1 活动是否开启：0/1 开启/未开启
--      data2 活动开启的时间戳
--      data3 活动结束的时间戳
--      data4 当前选择group 下的 id
--      data8 本日的日期
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 function GM_FestticalWeb_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	if "table" == type(festivalweb_Info) then
		for k,v in pairs(festivalweb_Info) do
			if _nCfgId == v.id then
				System_SetGlobalData(nLuaGlobal,2,_nBeginTime,false)
				System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)
				System_SetGlobalData(nLuaGlobal,4,_nCfgId,false)
				if _nOSTime >= _nBeginTime and _nOSTime < _nEndTime then			
					if 0 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,1,false)
						System_CallLuaOnline(("</F>FestivalWeb_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				else					
					if 1 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,0,false)
						System_CallLuaOnline(("</F>FestivalWeb_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				end
			end
		end
	end
 end
 
 function GM_FestticalWeb_instance_SetEndData(_nEndTime,_nOSTime)
	if false == System_IsExistGlobalData(nLuaGlobal) then
		return
	end
	nCfgId = System_GetGlobalData(nLuaGlobal,4)
	if "table" == type(festivalweb_Info) then
		for k,v in pairs(festivalweb_Info) do
			if nCfgId == v.id then
				if _nOSTime < _nEndTime then
					if 0 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,1,false)
						System_CallLuaOnline(("</F>FestivalWeb_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				else
					if 1 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,0,false)
						System_CallLuaOnline(("</F>FestivalWeb_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				end
				System_SetGlobalData(nLuaGlobal,2,_nBeginTime,false)
				System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)
			end
		end
	end
 end
 
 function GM_FestticalWeb_instance_GetData(_nCfgId,_nOSTime,_nType)
	-- 活动结束时间戳
    if  eFestivalGetActiveInfo.eFGAI_StartTime == _nType then
        return System_GetGlobalData(nLuaGlobal,2)
    end
    -- 活动开始时间戳
    if  eFestivalGetActiveInfo.eFGAI_EndTime == _nType then
        return System_GetGlobalData(nLuaGlobal,3)
    end
    -- 活动状态
    if  eFestivalGetActiveInfo.eFGAI_Status == _nType then
        return System_GetGlobalData(nLuaGlobal,1)
    end

    if  eFestivalGetActiveInfo.eFGAI_Cfgid == _nType then
        return System_GetGlobalData(nLuaGlobal,4)
    end
	return 0
 end
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	有任意玩家登录时处理
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestticalWeb_instance_Login(_nOSTime)
	if false == System_IsExistGlobalData(nLuaGlobal) then
		System_AddGlobalData(nLuaGlobal,false)
	end
 end
 
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	0点刷新 更新数据
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestticalWeb_instance_ZeroFresh(_nOSTime)	
	_nOSTime = _nOSTime or os.time()
	if "table" == type(festivalweb_Info) then
		_nCfgId = System_GetGlobalData(nLuaGlobal,4)
		for k,v in pairs(festivalweb_Info) do
			if _nCfgId == v.id then
				nBeginTime = System_GetGlobalData(nLuaGlobal,2)
				nEndTime   = System_GetGlobalData(nLuaGlobal,3)
				if _nOSTime >= nBeginTime and _nOSTime < nEndTime then				
					System_SetGlobalData(nLuaGlobal,1,1,false)
				else
					System_SetGlobalData(nLuaGlobal,1,0,false)
				end
				System_CallLuaOnline(("</F>FestivalWeb_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
			end
		end
	end
end
local nDayBeginTime = 0*100+0           -- 每天的0点0分
tTime_HM[nDayBeginTime] = tTime_HM[nDayBeginTime] or {}
table.insert(tTime_HM[nDayBeginTime],GM_FestticalWeb_instance_ZeroFresh)