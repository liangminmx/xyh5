local nResId = CRESOURCEFLOWACTION.eFT_FestivalConsume
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local FestivalConsume_Info = _festival_newconsume_Info['root'][1]['openday'][1]['group']

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 由 gm 开启
--  Note:
--      data1 活动是否开启：0/1 开启/未开启
--      data2 活动开启的时间戳
--      data3 活动结束的时间戳
--      data4 当前选择group 下的 id
--      data8 本日的日期
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalConsume_instance_OnLogin(_nOsTimes)
    if  false == System_IsExistGlobalData(nLuaGlobal) then
        System_AddGlobalData(nLuaGlobal,false)
    end
    GM_FestivalConsume_instance_Reflesh(_nOsTimes)
end

-- ===============================================================================================================
--  更新 全服的 活动是否开启了
-- ===============================================================================================================
 function GM_FestivalConsume_instance_Reflesh(_nOsTimes)
    local nOpenServerDay = System_GetOpenServerDay()
	local nCombinedTimes=System_GetCombinedTimes()
    local nSignOpen = System_GetGlobalData(nLuaGlobal,2)
    local nSignClose = System_GetGlobalData(nLuaGlobal,3)
	local nTodayTime = tonumber( os.date("%Y%m%d",_nOsTimes))

    -- 活动正在开启中
    if  nSignOpen <= nTodayTime and nTodayTime <= nSignClose then
        if  0 ~= System_GetGlobalData(nLuaGlobal,4) then
            System_SetGlobalData(nLuaGlobal,1,1,false)  -- 设置已经开启活动
            return
        else
            System_SetGlobalData(nLuaGlobal,1,0,false)  -- 没有 id 数据错了！关活动
            System_SetGlobalData(nLuaGlobal,4,0,false)  -- 当前没有开启的活动id 设置为0 
        end
    end

    -- 判断有没有活动可以开
	
    for k,v in pairs(FestivalConsume_Info) do
        local nOpenDay = v['opentime']
        local nEndDay = v['overtime']
		
		--根据开服天数，判断不开启活动的时间
		local nNoOpenday = (0 < nCombinedTimes) and v['mergeserver'] or v['openserver']
		if nNoOpenday < nOpenServerDay and nOpenDay <=  nTodayTime and nTodayTime <= nEndDay then
			-- 有一个可以开的活动！
			local nGroupId = v['id']
			System_SetGlobalData(nLuaGlobal,1,1,false)          -- 设置已经开启活动
			System_SetGlobalData(nLuaGlobal,2,nOpenDay,false)   -- 活动开始天数
			System_SetGlobalData(nLuaGlobal,3,nEndDay,false)    
			System_SetGlobalData(nLuaGlobal,4,nGroupId,false)
			return
		end
    end

    -- 开启活动失败了
    System_SetGlobalData(nLuaGlobal,1,0,false)
    System_SetGlobalData(nLuaGlobal,4,0,false)
end

 function GM_FestivalConsume_instance_SetData(_nCfgId,_nBeginTime,_nEndTime,_nOSTime)
	if "table" == type(FestivalConsume_Info) then
		for k,v in pairs(FestivalConsume_Info) do
			if _nCfgId == v.id then
				System_SetGlobalData(nLuaGlobal,2,_nBeginTime,false)
				System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)
				System_SetGlobalData(nLuaGlobal,4,_nCfgId,false)
				if _nOSTime >= _nBeginTime and _nOSTime < _nEndTime then			
					if 0 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,1,false)
						System_CallLuaOnline(("</F>FestivalConsume_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				else					
					if 1 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,0,false)
						System_CallLuaOnline(("</F>FestivalConsume_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				end
			end
		end
	end
 end
 
function GM_FestivalConsume_instance_SetEndData(_nEndTime,_nOSTime)
	if false == System_IsExistGlobalData(nLuaGlobal) then
		return
	end
	nCfgId = System_GetGlobalData(nLuaGlobal,4)
	if "table" == type(FestivalConsume_Info) then
		for k,v in pairs(FestivalConsume_Info) do
			if nCfgId == v.id then
				if _nOSTime < _nEndTime then
					if 0 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,1,false)
						System_CallLuaOnline(("</F>FestivalConsume_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				else
					if 1 == System_GetGlobalData(nLuaGlobal,1) then
						System_SetGlobalData(nLuaGlobal,1,0,false)
						System_CallLuaOnline(("</F>FestivalConsume_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
					end					
				end
				System_SetGlobalData(nLuaGlobal,2,_nBeginTime,false)
				System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)
			end
		end
	end
 end

 function GM_FestivalConsume_instance_GetData(_nCfgId,_nOSTime,_nType)
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
function GM_FestivalConsume_instance_Login(_nOSTime)
	if false == System_IsExistGlobalData(nLuaGlobal) then
		System_AddGlobalData(nLuaGlobal,false)
	end
end
 
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得当前活动状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalConsume_instance_GetStatus()
    local nStatus = System_GetGlobalData(nLuaGlobal,1)
    if  nStatus < 0 then
        nStatus = 0
    end
    return nStatus
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	0点刷新 更新数据
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_FestivalConsume_instance_ZeroFresh(_nOSTime)	
	_nOSTime = _nOSTime or os.time()
	if "table" == type(FestivalConsume_Info) then
		_nCfgId = System_GetGlobalData(nLuaGlobal,4)
		for k,v in pairs(FestivalConsume_Info) do
			if _nCfgId == v.id then
				nBeginTime = System_GetGlobalData(nLuaGlobal,2)
				nEndTime   = System_GetGlobalData(nLuaGlobal,3)
				if _nOSTime >= nBeginTime and _nOSTime < nEndTime then				
					System_SetGlobalData(nLuaGlobal,1,1,false)
				else
					System_SetGlobalData(nLuaGlobal,1,0,false)
				end
				System_CallLuaOnline(("</F>FestivalConsume_Person_Login</N>CHARACTER_ID</N>".._nOSTime))
			end
		end
	end
end
--local nDayBeginTime = 0*100+0           -- 每天的0点0分
--tTime_HM[nDayBeginTime] = tTime_HM[nDayBeginTime] or {}
--table.insert(tTime_HM[nDayBeginTime],GM_FestivalConsume_instance_ZeroFresh)