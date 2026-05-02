
local nResId = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Play
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId] 

local nResId_Sign = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Play_Sign
local nLuaIdActivity_Sign = LUARESOURCEFLOWACTION[nResId_Sign]

local Kaifuchoujiang_Info_Ins   = _kaifuchoujiang_Info['root'][1]['group']
local nMailId_ChouJiang     = _kaifuchoujiang_Info['root'][1]['open'][1]['mailid']

-- 该文件为服务器全局的开服抽奖活动的开启数据
-- 对应 配置数据 中 id = 1 的类型
-- 
--  Note:
--      data1 活动是否开启：0/1 开启/未开启
--      data2 开启日期
--      data3 结束日期
--      data4 开服抽奖活动，本次开启的活动的id
--      data8 本日的日期
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	由任一玩家登入，触发的全局数据刷新（登入）
--  注意！要在玩家登入的逻辑之前调用！
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_instance_OnLogin(_nOsTimes)
    if  false == System_IsExistGlobalData(nLuaGlobal) then
        System_AddGlobalData(nLuaGlobal,false)
    end
    ChouJiang_instance_RefleshOpenStatus(_nOsTimes)
end

-- ===============================================================================================================
--  更新 全服的 活动是否开启了
-- ===============================================================================================================
function ChouJiang_instance_RefleshOpenStatus(_nOsTimes)
    local nOpenServerDay = System_GetOpenServerDay()
	local nCombinedTimes=System_GetCombinedTimes()
    local nSignOpen = System_GetGlobalData(nLuaGlobal,2)
    local nSignClose = System_GetGlobalData(nLuaGlobal,3)
	local nTodayTime = tonumber( os.date("%Y%m%d",_nOsTimes))
	
    -- 活动正在开启中（）
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
    for k,v in pairs(Kaifuchoujiang_Info_Ins) do
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

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  根据当前记录的开启 id ，获得 group 下的key
--  Note：现在所有 serverNum 都是 -1 了
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_instance_GetServerKey()
    local nNowId = System_GetGlobalData(nLuaGlobal,4)    
    for k,v in pairs(Kaifuchoujiang_Info_Ins) do
        if  v['id'] == nNowId then
            return k
        end
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得当前开放的 group id
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_instance_GetGroupId()
    if  1 == System_GetGlobalData(nLuaGlobal,1) then
        return System_GetGlobalData(nLuaGlobal,4)
    else
        return 0
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  获得当前活动状态
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_instance_GetStatus()
    local nStatus = System_GetGlobalData(nLuaGlobal,1)
    if  nStatus < 0 then
        nStatus = 0
    end
    return nStatus
end

--获得对应天数配置的最大天数
function ChouJiang_GetDayNum(_nServerKey_DayReward)
	local maxday=0
	for k,v in pairs(_nServerKey_DayReward) do
		maxday=maxday+1
	end
	return maxday
end

--获得获得天数对应的rewardId
function ChouJiang_GetRewardId(_idCharacter,_nServerKey,_nAwardsKey)
	if "number" ~= type(_nServerKey) or 0 == _nServerKey then
		_nServerKey = 1
	end
	
	local maxDayNum=ChouJiang_GetDayNum(Kaifuchoujiang_Info_Ins[_nServerKey]['awards'][_nAwardsKey]["daynum"])
	local nOpenServerDay = (false == System_IsCrossSever()) and System_GetOpenServerDay() or System_GetOpenServerDayByCharacter(_idCharacter)
	local nSignOpen = System_GetTempData(_idCharacter,nLuaIdActivity_Sign,2)
	local dayid=(nOpenServerDay + 1-nSignOpen) % maxDayNum 
	dayid=(dayid == 0) and maxDayNum or dayid
	return dayid
end
