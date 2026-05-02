
local nResId = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Gm
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local Gm_Choujiang_Info_Ins = _kaifuchoujiang_gm_Info['root'][1]['group']
local nMailId_ChouJiang     = _kaifuchoujiang_gm_Info['root'][1]['open'][1]['mailid']


-- 该文件为服务器全局的开服抽奖活动的开启数据
-- 由 gm 开启
--  Note:
--      data1 活动是否开启：0/1 开启/未开启
--      data2 活动开启的时间戳
--      data3 活动结束的时间戳
--      data4 当前选择group 下的 id
--      data8 本日的日期
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	由任一玩家登入，触发的全局数据刷新（登入）
--  注意！要在玩家登入的逻辑之前调用！
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_OnLogin(_idCharacter,_nOsTimes)    
    if  false == System_IsExistGlobalData(nLuaGlobal) then
        System_AddGlobalData(nLuaGlobal,false)
    end
    GM_ChouJiang_instance_RefleshOpenStatus(_idCharacter,_nOsTimes)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  根据当前记录的开启 id ，获得 group 下的key
--  Note：现在所有 serverNum 都是 -1 了
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_GetServerKey()
    local nNowId = System_GetGlobalData(nLuaGlobal,4)
    for k,v in pairs(Gm_Choujiang_Info_Ins) do
        if  nNowId == v['id'] then
            return k
        end
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得gm配置的数据
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_GetData(_nType)
    
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
        return 1
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  有GM 进来，设置活动结束时间
--  注意！
--      本日设置 开始/结束 时间，明天才会刷新！！
--  @_nEndTime 结束时间戳
--  @_nOSTime 当前时间戳
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_SetEndData(_nEndTime,_nOSTime)
    System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)
    -- System_SetGlobalData(nLuaGlobal,8,0,false) -- 故意把日期设错误，进行一次活动状态刷新
    -- GM_ChouJiang_instance_RefleshOpenStatus(_nOsTimes)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  由 GM 命令调用进来的设置活动数据
--  注意！
--      本日设置 开始/结束 时间，明天才会刷新！！
--  @_nOpenId 要开启的group 下的 id	4
--  @_nBeginTime 开始时间戳			2
--  @_nEndTime 结束时间戳			3
--  @_nOsTimes 当前时间戳			
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_SetData(_nOpenId,_nBeginTime,_nEndTime,_nOsTimes)
    _nOpenId = (0 == _nOpenId) and 1 or _nOpenId
    System_SetGlobalData(nLuaGlobal,4,_nOpenId,false)
    System_SetGlobalData(nLuaGlobal,2,_nBeginTime,false)
    System_SetGlobalData(nLuaGlobal,3,_nEndTime,false)
	
    -- System_SetGlobalData(nLuaGlobal,8,0,false) -- 故意把日期设错误，进行一次活动状态刷新
    -- GM_ChouJiang_instance_RefleshOpenStatus(_nOsTimes)
end

-- ===============================================================================================================
--  更新 全服的 活动是否开启了
-- ===============================================================================================================
function GM_ChouJiang_instance_RefleshOpenStatus(_idCharacter,_nOsTimes)

    -- 找不到配置的GM数据，不开启活动
    if  "table" ~= type(Gm_Choujiang_Info_Ins) then
         System_SetGlobalData(nLuaGlobal,1,0,false) 
         System_SetGlobalData(nLuaGlobal,4,0,false)
		 
		 --需要在玩家上记录活动开启时间，用于跨服
		 GM_ChouJiang_Sign_SetOpenTime(_idCharacter,0)
         return
    end

    -- 没有配置开启的 id 
    if  0 == System_GetGlobalData(nLuaGlobal,4) then
        System_SetGlobalData(nLuaGlobal,1,0,false) 
        System_SetGlobalData(nLuaGlobal,4,0,false)
		
		--需要在玩家上记录活动开启时间，用于跨服
		GM_ChouJiang_Sign_SetOpenTime(_idCharacter,0)
        return
    end

    local nToday = tonumber( os.date("%y%m%d",_nOsTimes))
    local nSignDay = System_GetGlobalData(nLuaGlobal,8)
    if  nToday ~= nSignDay then
        -- 更新日期
        System_SetGlobalData(nLuaGlobal,8,nToday)

        -- 判断本日活动是否开启
        local nStartTime = System_GetGlobalData(nLuaGlobal,2)
        local nEndTime  = System_GetGlobalData(nLuaGlobal,3)
        if  nStartTime <= _nOsTimes and _nOsTimes < nEndTime then
            System_SetGlobalData(nLuaGlobal,1,1,false)
			GM_ChouJiang_Sign_SetOpenTime(_idCharacter,nStartTime)
        else
            System_SetGlobalData(nLuaGlobal,1,0,false)
            System_SetGlobalData(nLuaGlobal,4,0,false)
			GM_ChouJiang_Sign_SetOpenTime(_idCharacter,0)
        end
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得当前开放的 group id
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_GetGroupId()
    if  1 == System_GetGlobalData(nLuaGlobal,1) then
        return System_GetGlobalData(nLuaGlobal,4)
    else
        return 0
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得当前活动状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_instance_GetStatus()
    local nStatus = System_GetGlobalData(nLuaGlobal,1)
    if  nStatus < 0 then
        nStatus = 0
    end
    return nStatus
end

--获得对应天数配置的最大天数
function GM_ChouJiang_GetDayNum(_nServerKey_DayReward)
	local maxday=0
	for k,v in pairs(_nServerKey_DayReward) do
		maxday=maxday+1
	end
	return maxday
end

--获得获得天数对应的rewardId
function GM_ChouJiang_GetRewardId(_idCharacter,_nServerKey,_nAwardsKey)
	local maxDayNum=GM_ChouJiang_GetDayNum(Gm_Choujiang_Info_Ins[_nServerKey]['awards'][_nAwardsKey]["daynum"])
	local nSignOpen = math.floor((os.time()-GM_ChouJiang_Sign_GetOpenTime(_idCharacter))/(60*60*24))	
	local dayid= nSignOpen % maxDayNum 
	dayid= (dayid==0) and maxDayNum or dayid

	return dayid
end