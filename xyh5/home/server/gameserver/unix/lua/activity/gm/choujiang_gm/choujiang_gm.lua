
-- ////////////////////////// 抽奖的
 local eGMChouJiang_RetCode = {
	eGMCJ_Success = 0,		-- 成功
	eGMCJ_Null = 1,			-- 未知错误
    eGMCJ_NoOpen = 2,       -- 该功能未开启
    eGMCJ_BagNoEnough = 3,  -- 背包空间不够
	eGMCJ_LessEmoney = 4,	-- 消耗的钱不够
    eGMCJ_IdError = 5,      -- 玩家选择的玩法id 和服务器记录的不一样！
}
-- ////////////////////////// 兑换的
local eGMChouJiangExChange_RetCode = {
    eGMCJEx_Success = 0,    -- 成功
    eGMCJEx_Null = 1,		-- 未知错误
	eGMCJEx_LessScore = 2,	-- 兑换分数不够
	eGMCJEx_LessTimes = 3,  -- 兑换次数不够
    eGMCJEx_IdError = 4,    -- 玩家选择的玩法id 和服务器记录的不一样！
    eGMCJEx_BagNoEnough = 5,-- 背包满了
}

-- ////////////////////////// 收到客户端的包的类型
local eGMChouJiang_Req = {
    eGMCJRT_AcitveSyn = 1,  -- 同步活动信息
	eGMCJRT_Choose = 2,     -- 选择伙伴
	eGMCJRT_Draw = 3,       -- 抽奖
	eGMCJRT_ShopSyn = 4,    -- 商店信息同步
	eGMCJRT_Buy = 5,        -- 购买
}

local nResId = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Gm
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

local nResId = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Gm
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local Gm_choujiang_Info = _kaifuchoujiang_gm_Info['root'][1]['group']
local Gm_ChouJiang_nOpenLevel  = _kaifuchoujiang_gm_Info['root'][1]['open'][1]['lv']
local Gm_nMailId_ChouJiang  = _kaifuchoujiang_gm_Info['root'][1]['open'][1]['mailid']
local GM_tNotice = _kaifuchoujiang_gm_Info['root'][1]['lvnpnotice']

--  Note:
--      由 gm 命令开启的抽奖活动，逻辑和开服活动都一样！！！
--      都是函数名前 + GM_ 
--      data1 玩家是否开启了这个活动 0/1 活动中/结束
--      data2 玩家选择的玩法（第一次玩家选择，服务器记录之后就不变了）
--      data3 玩家今日可用的免费次数 
--      data4 玩家在参与活动中，总共的参与抽奖次数（包含免费的）
--      data5 玩家今天充值了多少钱(不够增加一次免费次数的)
--      data6 获得的抽奖积分（活动结束后才清空）
--      data7 本日一共的免费次数 (与data3配合使用)
--      data8 今天的日期 160705 的格式
--      dataStr 积分商店物品兑换记录('id,num|id,num')
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_OnLogin(_idCharacter,_nOsTimes)
	if false == System_IsCrossSever() then--只有在游服才初始化活动数据
		local nStatusBeforeReflseh = GM_ChouJiang_instance_GetStatus()
		-- 调用全服的 instance,要在玩家逻辑前调用！
		GM_ChouJiang_instance_OnLogin(_idCharacter,_nOsTimes) 
		local nStatusAfterReflesh = GM_ChouJiang_instance_GetStatus()
		local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
		if  nStatus ~= nStatusAfterReflesh and 0 == nStatusAfterReflesh then        
			GM_ChouJiang_SendMail(_idCharacter)
		end
	end

    -- 调用配置记录数据字段
    GM_ChouJiang_Sign_OnLogin(_idCharacter)    

    -- 判断玩家活动状态
    GM_ChouJiang_Refresh(_idCharacter,_nOsTimes)
	GM_ChouJiang_Syn_Status(_idCharacter)

    -- 同步第三排活动图标显示信息
    GM_ChouJiang_IconShow(_idCharacter,_nOsTimes)
end
table.insert(tOnLoginActivity,GM_ChouJiang_OnLogin)
table.insert(tOnLoginActivity_Cross,GM_ChouJiang_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_ZeroRefresh(_idCharacter,_nOsTimes)
    GM_ChouJiang_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,GM_ChouJiang_ZeroRefresh)
table.insert(tOnZeroTrigger_Cross,GM_ChouJiang_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家升级的触发(判断活动开启)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_LevelUp(_idCharacter,_old,_new)
    if  _old < Gm_ChouJiang_nOpenLevel and Gm_ChouJiang_nOpenLevel <= _new then
        System_SetTempData(_idCharacter,nLuaIdActivity,8,0) -- 故意设错的日期，触发一次刷新
        GM_ChouJiang_Refresh(_idCharacter)  -- 数据刷新

        GM_ChouJiang_Syn_Status(_idCharacter)   -- 同步包
        GM_ChouJiang_IconShow(_idCharacter) -- 同步第三排图标信息
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家充值
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_Recharge(_idCharacter,_nEmoney,_nOsTimes)

    local nFreeTime = System_GetTempData(_idCharacter,nLuaIdActivity,3)    
    local nRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,5)
    local nTodayTotal = System_GetTempData(_idCharacter,nLuaIdActivity,7)    

    local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        -- L2C_DebugLog("::GM_ChouJiang_Recharge get nil server id!")
        return
    end
    local nGetFreeTime = Gm_choujiang_Info[nServerKey]['recharge']

    nRechargeNum = _nEmoney + nRechargeNum
    local nAddTimes = math.floor(nRechargeNum / nGetFreeTime)    -- 向下取整
    local nRemainMoney = nRechargeNum % nGetFreeTime

	local nFree = tonumber(Gm_choujiang_Info[nServerKey]['free']) or 0
	local nLimit = tonumber(Gm_choujiang_Info[nServerKey]['limit']) or 0

    nFreeTime = nFreeTime + nAddTimes       -- 还没判断有没有超过上限的次数
    nTodayTotal = nTodayTotal + nAddTimes
    if  nTodayTotal > (nLimit + nFree) then
        local nExtraTimes = nTodayTotal - (nLimit + nFree)  -- 多加的次数
        nTodayTotal = nLimit + nFree
        nFreeTime = nFreeTime - nExtraTimes
        if  nFreeTime < 0 then  nFreeTime = 0 end
    end
	
    System_SetTempData(_idCharacter,nLuaIdActivity,3,nFreeTime,false)
    System_SetTempData(_idCharacter,nLuaIdActivity,5,nRemainMoney,false)
    System_SetTempData(_idCharacter,nLuaIdActivity,7,nTodayTotal,false)
	
	GM_ChouJiang_Syn_Status(_idCharacter)
end
table.insert(tOnUserRechargeEmoney,GM_ChouJiang_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,GM_ChouJiang_Recharge)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  客户端发的包的总接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function GM_ChouJiang_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
    if  (nil == _idCharacter) or (nResId ~= _nCActionType) or (nil == _nData3) or (nil == _nData4) or (nil == _nData5) then
        L2C_DebugLog("::GM_ChouJiang_Req error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nData3 or "nil").."|"..(_nData4 or "nil").."|"..(_nData5 or "nil")..")")
        return eGMChouJiang_RetCode.eGMCJ_Null
    end
        

    -- 同步活动信息
    if  _nData3 == eGMChouJiang_Req.eGMCJRT_AcitveSyn then
        GM_ChouJiang_Syn_Status(_idCharacter)
        return 0 -- 默认肯定成功的返回码
    end

    -- 选择伙伴 -- GM 活动不用选择伙伴的
    if  _nData3 == eGMChouJiang_Req.eGMCJRT_Choose then
        GM_ChouJiang_SetTypeId(_idCharacter,_nData4)
        GM_ChouJiang_Syn_Status(_idCharacter)
        return 0
    end

    -- 抽奖
    if  _nData3 == eGMChouJiang_Req.eGMCJRT_Draw then
        
        local nRollCode,tRewardData = GM_ChouJiang_PlayingRoll(_idCharacter,_nData4,_nData5)        
        local nScore = System_GetTempData(_idCharacter,nLuaIdActivity,6)
        tRewardData = tRewardData or {}
        -- 发包告诉客户端抽奖结果        
        GM_ChouJiang_Syn_RollResult(_idCharacter,nRollCode,_nData4,_nData5,tRewardData)
        
        if  nRollCode == eGMChouJiang_RetCode.eGMCJ_Success then  
			--获得daynum
			local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
			local nAwardsKey = GM_ChouJiang_GetAwardsKey(_idCharacter,nServerKey,_nData5)
			local dayID=GM_ChouJiang_GetRewardId(_idCharacter,nServerKey,nAwardsKey)
		
			GM_ChouJiang_Syn_Status(_idCharacter)
            -- 写经分
            GM_ChouJiang_Log_Roll(_idCharacter,_nData4,tRewardData,dayID)
            -- 抽奖结果广播
            GM_ChouJiang_Syn_ToAll(_idCharacter,_nData5,tRewardData)
        end        
        return nRollCode
    end

    -- 商店信息同步
    if  _nData3 == eGMChouJiang_Req.eGMCJRT_ShopSyn then
        GM_ChouJiang_Syn_ExChangeShop(_idCharacter)  
        return 0
    end 

    -- 购买
    if  _nData3 == eGMChouJiang_Req.eGMCJRT_Buy then

        local bBuyCode = GM_ChouJiang_Exchange(_idCharacter,_nData4,_nData5)
        if  eGMChouJiangExChange_RetCode.eGMCJEx_Success == bBuyCode then
            GM_ChouJiang_Syn_ExChangeShop(_idCharacter)     
        end
        return bBuyCode
    end
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = GM_ChouJiang_Req
tOnOnAcitveAward_Cross[nResId] = GM_ChouJiang_Req

-- ===============================================================================================================
--  每日刷新数据记录
--  无论活动开没开，每日的日期和记录的充值记录都要记录
-- ===============================================================================================================
function GM_ChouJiang_Refresh(_idCharacter,_nOsTimes)
    _nOsTimes = _nOsTimes or os.time()
	local nToday = tonumber( os.date('%y%m%d',_nOsTimes))
    local nSignDay = tonumber(System_GetTempData(_idCharacter,nLuaIdActivity,8))
	
	if  nToday ~= nSignDay then--判断今日的数据是否处理过
		if false == System_IsCrossSever() then
			local nActiveStatus = System_GetGlobalData(nLuaGlobal,1)
			local nGroupId = System_GetGlobalData(nLuaGlobal,4)
			-- 判断能否开启活动
			local nPlayerLevel =  System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
			if  1 == nActiveStatus and nPlayerLevel >= Gm_ChouJiang_nOpenLevel then
				System_SetTempData(_idCharacter,nLuaIdActivity,1,nGroupId,false)
			else
				System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
				nActiveStatus = 0
			end
				
			if  1 == nActiveStatus then            
				-- -----------------------------------------------------------
				-- 对比开启的 group id，防止出现带着上一个活动的数据进入下一个活动时间段
				local nTrueGroupId = nGroupId
				local nSignGroupId = GM_ChouJiang_Sign_GetGroupId(_idCharacter)
				
				-- id不一致，出现跨活动情况，优先清空数据
				if  nTrueGroupId ~= nSignGroupId then
					System_SetAllTempData(_idCharacter,nLuaIdActivity,1,0,0,0,0,0,0,nToday,"",false)
					GM_ChouJiang_Sign_SetGroupId(_idCharacter,nTrueGroupId)
				end
				
				-- 判断是不是默认选择伙伴id的
				GM_ChouJiang_SetDefault_ParentId(_idCharacter)

				local nFreeTime = 0
				local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
				if  nil == nServerKey then
					L2C_DebugLog("::GM_ChouJiang_Refresh get nil server key")
				else
					nFreeTime = Gm_choujiang_Info[nServerKey]['free'] or 0
				end            
		
				System_SetTempData(_idCharacter,nLuaIdActivity,3,nFreeTime,false)   -- 本日可用的免费次数
				System_SetTempData(_idCharacter,nLuaIdActivity,4,0,false)           -- 本日已抽奖次数
				System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)           -- 本日充值数量         
				System_SetTempData(_idCharacter,nLuaIdActivity,7,nFreeTime,false)   -- 本日一共的免费次数
				System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)      -- 本日的日期
				System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)         -- 物品兑换记录
				GM_ChouJiang_Sign_SetRewardTime(_idCharacter,"")
			else
				-- 活动结束，清除除了日期外的所有数据(省得日期不对一直需要刷新数据)
				System_SetAllTempData(_idCharacter,nLuaIdActivity,0,0,0,0,0,0,0,nToday,"",false)
				GM_ChouJiang_Sign_SetGroupId(_idCharacter,0)
			end
		else
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.GM_ChouJiang_Refresh,nLuaIdActivity)
		end
	 end
end
--刷新玩家信息的跨服处理
function GM_ChouJiang_Refresh_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local nActiveStatus = _nData1
	local nGroupId = _nData4
	-- 判断能否开启活动
	local nPlayerLevel =  System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if  1 == nActiveStatus and nPlayerLevel >= Gm_ChouJiang_nOpenLevel then
		System_SetTempData(_idCharacter,nLuaIdActivity,1,nGroupId,false)
	else
		System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
		nActiveStatus = 0
	end
		
	if 1 == nActiveStatus then            
		-- -----------------------------------------------------------
		-- 对比开启的 group id，防止出现带着上一个活动的数据进入下一个活动时间段
		local nTrueGroupId = nGroupId
		local nSignGroupId = GM_ChouJiang_Sign_GetGroupId(_idCharacter)
		
		-- id不一致，出现跨活动情况，优先清空数据
		if  nTrueGroupId ~= nSignGroupId then
			System_SetAllTempData(_idCharacter,nLuaIdActivity,1,0,0,0,0,0,0,nToday,"",false)
			GM_ChouJiang_Sign_SetGroupId(_idCharacter,nTrueGroupId)
		end
		
		-- 判断是不是默认选择伙伴id的
		GM_ChouJiang_SetDefault_ParentId(_idCharacter)

		local nFreeTime = 0
		local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
		if  nil == nServerKey then
			L2C_DebugLog("::GM_ChouJiang_Refresh get nil server key")
		else
			nFreeTime = Gm_choujiang_Info[nServerKey]['free'] or 0
		end            

		System_SetTempData(_idCharacter,nLuaIdActivity,3,nFreeTime,false)   -- 本日可用的免费次数
		System_SetTempData(_idCharacter,nLuaIdActivity,4,0,false)           -- 本日已抽奖次数
		System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)           -- 本日充值数量         
		System_SetTempData(_idCharacter,nLuaIdActivity,7,nFreeTime,false)   -- 本日一共的免费次数
		System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)      -- 本日的日期
		System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)         -- 物品兑换记录
		GM_ChouJiang_Sign_SetRewardTime(_idCharacter,"")
	else
		-- 活动结束，清除除了日期外的所有数据(省得日期不对一直需要刷新数据)
		System_SetAllTempData(_idCharacter,nLuaIdActivity,0,0,0,0,0,0,0,nToday,"",false)
		GM_ChouJiang_Sign_SetGroupId(_idCharacter,0)
	end
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.GM_ChouJiang_Refresh] = GM_ChouJiang_Refresh_Cross

-- ===============================================================================================================
--  记录玩法 id 
-- ===============================================================================================================
function GM_ChouJiang_SetTypeId(_idCharacter,_nTypeId)
    System_SetTempData(_idCharacter,nLuaIdActivity,2,_nTypeId,false)
end

-- ===============================================================================================================
--  玩家在商店兑换物品
--  @_nGetId 要兑换的物品的id
--  @_nParentId GM 活动没选择伙伴玩法的
-- ===============================================================================================================
function GM_ChouJiang_Exchange(_idCharacter,_nGetId,_nParentId)

    if  nil == Gm_choujiang_Info then
        return eGMChouJiangExChange_RetCode.eGMCJEx_Null
    end

    -- 判断记录的玩法id对不对
    if  _nParentId ~= System_GetTempData(_idCharacter,nLuaIdActivity,2) then
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_IdError
    end

    -- 获得可兑换物品的数据
    local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        L2C_DebugLog("::GM_ChouJiang_Exchange get nil serverkey")
        return eGMChouJiangExChange_RetCode.eGMCJEx_Null
    end

    local nAwardsKey = GM_ChouJiang_GetAwardsKey(_idCharacter,nServerKey,_nParentId)
    if  nil == nAwardsKey then
        L2C_DebugLog("::GM_ChouJiang_Exchange get nil nAwardsKey,nServerKey:"..nServerKey..",_nParentId:".._nParentId)
        return eGMChouJiangExChange_RetCode.eGMCJEx_Null
    end

    local temp = Gm_choujiang_Info[nServerKey]['awards'][nAwardsKey]['index']
    local tExchangeData = {}
    for k,v in pairs(temp) do
        local newKey = v['id']
        tExchangeData[newKey] = v
    end

    if  "table" ~= type(tExchangeData[_nGetId]) then
        L2C_DebugLog("::GM_ChouJiang_Exchange get a error id :".._nGetId)  -- 物品不存在！
        return eGMChouJiangExChange_RetCode.eGMCJEx_Null
    end

    -- 判断背包能不能放得下要兑换来的物品
    if  false == GM_ChouJiang_Exchange_BagEnough(_idCharacter,tExchangeData[_nGetId]['item'],tExchangeData[_nGetId]['num']) then
        return eGMChouJiangExChange_RetCode.eGMCJEx_BagNoEnough
    end

    -- 获得已经兑换过的次数（读写字符串用的是 通用开服抽奖中的函数）
    local tGetRecord = ChouJiang_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity) )
    local nHadExchangeTimes = tGetRecord[_nGetId] or 0

    -- 判断兑换次数够不够
    local nTatalTimes = tExchangeData[_nGetId]['exchange']
    if  nHadExchangeTimes >= nTatalTimes and nTatalTimes ~= -1 then
        return eGMChouJiangExChange_RetCode.eGMCJEx_LessTimes
    end
    
    -- 判断可兑换分数够不够
    local nNeedExchangeScore = tExchangeData[_nGetId]['cousume']
    local nHadScore_before = System_GetTempData(_idCharacter,nLuaIdActivity,6)
    if  nNeedExchangeScore > nHadScore_before then
        return eGMChouJiangExChange_RetCode.eGMCJEx_LessScore
    end

    -- 加兑换次数，扣分数，发放奖励
    nHadExchangeTimes = nHadExchangeTimes + 1
    local nHadScore_after = nHadScore_before -nNeedExchangeScore
    
    tGetRecord[_nGetId]  = nHadExchangeTimes
    local strNew = ChouJiang_WriteStr(tGetRecord)
    if  true == System_SetTempDataStr(_idCharacter,nLuaIdActivity,strNew) and
        true == System_SetTempData(_idCharacter,nLuaIdActivity,6,nHadScore_after,false) then
        
        -- 发放奖励
        local nItemId = tExchangeData[_nGetId]['item']
        local nNum = tExchangeData[_nGetId]['num']
        System_AwardThingInBag(_idCharacter, CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_GetReward,nItemId,nNum)


        -- 记录经分
        GM_ChouJiang_Log_Exchange(_idCharacter,nItemId,nHadExchangeTimes,nHadScore_before,nHadScore_after)

        return eGMChouJiangExChange_RetCode.eGMCJEx_Success
    else
        L2C_DebugLog("::GM_ChouJiang_Exchange set Mask error !!!")
    end        
end

-- ===============================================================================================================
--  玩家抽奖
--  @_nSingleOrTen 单次抽奖/10  1/10
--  @_nParentId 
--  @return code,tReward
-- ===============================================================================================================
function GM_ChouJiang_PlayingRoll(_idCharacter,_nSingleOrTen,_nParentId)
    -- 判断玩家是否开启了活动
    if  1 ~= System_GetTempData(_idCharacter,nLuaIdActivity,1) then
        return eGMChouJiang_RetCode.eGMCJ_NoOpen
    end

    -- 判断记录的伙伴玩法id对不对
    if  _nParentId ~= System_GetTempData(_idCharacter,nLuaIdActivity,2) then
        L2C_DebugLog("::GM_ChouJiang_PlayingRoll get error _nParentId:".._nParentId)
        return eGMChouJiang_RetCode.eGMCJ_IdError
    end

    -- 获得配置的数据
    local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        L2C_DebugLog("::GM_ChouJiang_PlayingRoll get a nil server key")
        return eGMChouJiang_RetCode.eGMCJ_Null
    end

    -- 获得玩法 id 的配置
    local nAwardsKey = GM_ChouJiang_GetAwardsKey(_idCharacter,nServerKey,_nParentId)
    if  nil == nAwardsKey then
        L2C_DebugLog("::GM_ChouJiang_PlayingRoll get nil nAwardsKey,nServerKey:"..nServerKey..",_nParentId:".._nParentId)
        return eGMChouJiang_RetCode.eGMCJ_Null
    end

    -- 获得本次抽奖的消耗多少钱
    local needCost = 0
    local nIntegral = 0
    local nHaveFree = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    if  1 == _nSingleOrTen then   
        if  nHaveFree == 0 then
            needCost = Gm_choujiang_Info[nServerKey]['lottery'][1]['single']
        end                
        nIntegral = Gm_choujiang_Info[nServerKey]['lottery'][1]['integral']    
    elseif  10 == _nSingleOrTen then        
        needCost    = Gm_choujiang_Info[nServerKey]['lottery'][2]['ten']
        nIntegral   = Gm_choujiang_Info[nServerKey]['lottery'][2]['integral']
    else   
        L2C_DebugLog("::GM_ChouJiang_PlayingRoll get error _nSingleOrTen:"..tostring(_nSingleOrTen))
        return eGMChouJiang_RetCode.eGMCJ_Null
    end

    -- 判断背包空间够不够
    if  false == GM_ChouJiang_Roll_BagEnough(_idCharacter,_nSingleOrTen) then 
        return eGMChouJiang_RetCode.eGMCJ_BagNoEnough
    end

    -- 预抽奖，获得本次抽奖最终得到的物品
    local bRoll,tGetReward = GM_ChouJiang_RealRoll(_idCharacter,nServerKey,nAwardsKey,_nSingleOrTen)
    if  false == bRoll then
        L2C_DebugLog("::GM_ChouJiang_PlayingRoll roll fail!")
        return eGMChouJiang_RetCode.eGMCJ_Null
    end

    -- 如果是单次抽奖，扣一次免费次数
    if  1 == _nSingleOrTen and nHaveFree > 0 then
        nHaveFree = nHaveFree - 1
        System_SetTempData(_idCharacter,nLuaIdActivity,3,nHaveFree,false)
    else
        -- 判断消耗的钱够不够        
        local nCostId = GM_ChouJiang_GetCostId(_nSingleOrTen)
        if  false == System_SpendEmoney(_idCharacter,needCost,nCostId) then        
            return eGMChouJiang_RetCode.eGMCJ_LessEmoney
        end
    end

    -- 记录增加的抽奖次数
    local nRollTime = System_GetTempData(_idCharacter,nLuaIdActivity,4)
    nRollTime = nRollTime + _nSingleOrTen 
    System_SetTempData(_idCharacter,nLuaIdActivity,4,nRollTime,false)

    -- 增加抽奖积分
    local nChouJiang_Score = System_GetTempData(_idCharacter,nLuaIdActivity,6)
    nChouJiang_Score = nChouJiang_Score + nIntegral
    System_SetTempData(_idCharacter,nLuaIdActivity,6,nChouJiang_Score,false)

    -- 发放奖励了
    GM_ChouJiang_Roll_SendReward(_idCharacter,tGetReward)

    return eGMChouJiang_RetCode.eGMCJ_Success,tGetReward
end

-- ===============================================================================================================
--  获得'awards' 下的id 的key / GM 活动下是不需要选择玩法的
-- ===============================================================================================================
function GM_ChouJiang_GetAwardsKey(_idCharacter,_nServerKey,_nTypeId)
	--没有伙伴选择默认伙伴
	local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
	if 0 == _nTypeId then
		_nTypeId = Gm_choujiang_Info[nServerKey]['awards'][1]['id']
	end   
    -- 获得 _nTypeId 在配置数据中的key
    local nTypeKey = nil
    for k,v in pairs(Gm_choujiang_Info[_nServerKey]['awards']) do
        if  v['id'] == _nTypeId then
            return k            
        end
    end
end

-- ===============================================================================================================
--  抽奖的函数
--  @_nServerKey                             
--  @_nTypeId 选择的 awards 下的类型的id 的key
--  @_nSingleOrTen 抽奖次数
--  @return false,nil
--          true,tGetReward
-- ===============================================================================================================
function GM_ChouJiang_RealRoll(_idCharacter,_nServerKey,_nAwardsKey,_nSingleOrTen)  
	 local dayID=GM_ChouJiang_GetRewardId(_idCharacter,_nServerKey,_nAwardsKey) 
     local nTotalRollTimes = System_GetTempData(_idCharacter,nLuaIdActivity,4)
     local tAllRewardData = Gm_choujiang_Info[_nServerKey]['awards'][_nAwardsKey]["daynum"][dayID]['reward']
	 
	 --获得对应物品的抽奖次数
	 local tItemTimes=GM_ChouJiang_Sign_GetRewardTime(_idCharacter)
	 if "" == tItemTimes then 
		tItemTimes=ChouJiang_ItemTimeInst(tAllRewardData) 
	 else
		tItemTimes=System_Split(tItemTimes, ",")
	 end
	 local tRealRewardData={}
     local tGetReward = {}
     for i = 1,_nSingleOrTen,1 do
		--每次抽奖后时都要计算次数
		tRealRewardData,tItemTimes=ChouJiang_TimeToRoll(tAllRewardData,tItemTimes)
        local nRandomValue = ChouJiang_Weights(tRealRewardData)
		table.insert(tGetReward,nRandomValue)
		
		--抽到奖励后重置最低次数
		if -1 ~= tonumber(tItemTimes[nRandomValue["position"]]) then
			tItemTimes[nRandomValue["position"]] = ""==nRandomValue["min"] and -1 or nRandomValue["min"]
		end
     end
	 local sItemTimes = System_StrCatOnTable(tItemTimes,",")
	 GM_ChouJiang_Sign_SetRewardTime(_idCharacter,sItemTimes)

     return true,tGetReward
end

-- ===============================================================================================================
--  获得消耗的资源流向id
-- ===============================================================================================================
function GM_ChouJiang_GetCostId(_nSingleOrTen)
    if  1 == _nSingleOrTen then
        return CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_Single
    elseif  10 == _nSingleOrTen then
        return CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_Ten
    else
        L2C_DebugLog("::GM_ChouJiang_GetCostId get error _nSingleOrTen:"..tostring(_nSingleOrTen))
    end
end

-- ===============================================================================================================
--  玩家同步第三排图标开启信息
-- ===============================================================================================================
function GM_ChouJiang_IconShow(_idCharacter,_nOsTimes)
    _nOsTimes = _nOsTimes or os.time()
	GM_ChouJiang_Sign_SetNowTime(_idCharacter,_nOsTimes)--跨服临时数据
	
    local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    if  1 == nStatus then
        -- GM 抽奖的结束时间戳，直接去对应的 instance 里取得
		if false == System_IsCrossSever() then
			local nEndTime = System_GetGlobalData(nLuaIdActivity,3)
			System_SendActiveStatus(_idCharacter,nResId,1,0,nEndTime)
		else
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.GM_ChouJiang_IconShow,nLuaIdActivity)
		end
    else
        System_SendActiveStatus(_idCharacter,nResId,0,0,0)  -- 不显示
    end
end
function GM_ChouJiang_IconShow_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local nEndTime = _nData3
	System_SendActiveStatus(_idCharacter,nResId,1,0,nEndTime)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.GM_ChouJiang_IconShow] = GM_ChouJiang_IconShow_Cross

-- ===============================================================================================================
--  抽奖获得的物品 - 判断背包够不够放要抽获得物品
-- ===============================================================================================================
function GM_ChouJiang_Roll_BagEnough(_idCharacter,_nSingleOrTen)
    
   return System_GetKaiFuChouJiangBagSpaceNum(_idCharacter) >= _nSingleOrTen
end

-- ===============================================================================================================
--  商店兑换 - 判断背包够不够放要抽获得物品
-- ===============================================================================================================
function GM_ChouJiang_Exchange_BagEnough(_idCharacter,_nItemId,_nNum)
    local strItem = tostring(_nItemId)..","..tostring(_nNum)..";"
    return System_CanPushThingsToBagEx(_idCharacter,strItem)
end

-- ===============================================================================================================
--  根据 策划配置的 preselection id，判断是不是要默认给自己设置默认选择 伙伴id
-- ===============================================================================================================
function GM_ChouJiang_SetDefault_ParentId(_idCharacter)
    local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        L2C_DebugLog("::GM_ChouJiang_SetDefault_ParentId get nil serverKey")
        return
    end
    -- 只有一个伙伴玩法，默认给选择
    if  0 == Gm_choujiang_Info[nServerKey]['preselection'] then
        local nParentId = Gm_choujiang_Info[nServerKey]['awards'][1]['id']
        GM_ChouJiang_SetTypeId(_idCharacter,nParentId)
    end
end

-- ===============================================================================================================
--  发放抽奖获得的奖励
--  @_tRewardData 就是抽出了，'reward' 下的具体的奖励数据
-- ===============================================================================================================
function GM_ChouJiang_Roll_SendReward(_idCharacter,_tRewardData)    
    local nGetRollResId = CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_GetReward
    for k,v in pairs(_tRewardData) do
        local nItem = v['item']
        local nNum = v['num']

		System_AwardThingInKaiFuChouJiangBag(_idCharacter,nGetRollResId,nItem,nNum)    
       
        -- 判断要不要推送广播
        local bNotice,nNoticeId = GM_ChouJiang_Notice(nItem) 
        if  true == bNotice and "number" == type(nNoticeId) then
            local sParam = string.format("%d,%u;%d,%s;%d,%d;%d,%d"
							,ePreparedStatementValueType.TYPE_UI64,     _idCharacter
							,ePreparedStatementValueType.TYPE_STRING,   System_GetCharacterName(_idCharacter)									
							,ePreparedStatementValueType.TYPE_UI32,     nItem             
							,ePreparedStatementValueType.TYPE_UI32,     1             --绑定							
							)  
            System_SendCommonBroadCastMsg(nNoticeId,sParam)
        end         
    end
end 

-- ===============================================================================================================
--  判断抽到的物品要不要广播
--  @return true,nNoticeId
-- ===============================================================================================================
function GM_ChouJiang_Notice(_nItemId) 
    if  "table" == type(GM_tNotice) then
        for k,v in pairs(GM_tNotice) do
            if  v['item'] == _nItemId then
                return true,v['notice']
            end
        end
    end
end

-- ===============================================================================================================
--  GM 同步活动信息	1010007	1	1481040000	1481299200	161207
-- ===============================================================================================================
function GM_ChouJiang_Syn_Status(_idCharacter)
    local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    local nParentId = System_GetTempData(_idCharacter,nLuaIdActivity,2)
    local nRemainFree = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    local nTotalFree = System_GetTempData(_idCharacter,nLuaIdActivity,7)
    --local nGroupId = System_GetGlobalData(nLuaIdActivity,4)
	local nGroupId = GM_ChouJiang_Sign_GetGroupId(_idCharacter)
	
	--默认选择第1天，玩家没有选择伙伴的时候读数据有问题
	local nDayId=1
	if 0 < nParentId then
		local nServerKey = GM_ChouJiang_Sign_GetServerKey(_idCharacter)
		local nAwardsKey = GM_ChouJiang_GetAwardsKey(_idCharacter,nServerKey,nParentId)
		nDayId=GM_ChouJiang_GetRewardId(_idCharacter,nServerKey,nAwardsKey)
	end
	return System_GM_ChouJiang_Syn_ActiveStatus(_idCharacter,nStatus,nParentId,nRemainFree,nTotalFree,nGroupId,nDayId)
end

-- ===============================================================================================================
--  GM 抽奖结果包
-- ===============================================================================================================
function GM_ChouJiang_Syn_RollResult(_idCharacter,_nCode,_nRollTimes,_nParentId,_tRewardData)     
   local strRewardPos = ""
   for  k,v in pairs(_tRewardData) do
        local nPos = v['position']
        if  "" == strRewardPos then
            strRewardPos = tostring(nPos)
        else
            strRewardPos = strRewardPos .. "," ..tostring(nPos)
        end   
   end
   local nScore = System_GetTempData(_idCharacter,nLuaIdActivity,6)   
   return System_GM_ChouJiang_Syn_RollRet(_idCharacter,_nCode,_nRollTimes,_nParentId,nScore,strRewardPos)
end

-- ===============================================================================================================
--  GM 兑换商店数据同步包
-- ===============================================================================================================
function GM_ChouJiang_Syn_ExChangeShop(_idCharacter)
    local nScore = System_GetTempData(_idCharacter,nLuaIdActivity,6)
    local strBuyRecord = System_GetTempDataStr(_idCharacter,nLuaIdActivity)    

    return System_GM_ChouJiang_Syn_ShopStatus(_idCharacter,nScore,strBuyRecord)
end

-- ===============================================================================================================
--  GM 写抽奖获得物品的经分
-- ===============================================================================================================
function GM_ChouJiang_Log_Roll(_idCharacter,_nSingleOrTen,_tRewardData,_tdayID)   
   local strPos = ""
   for  k,v in pairs(_tRewardData) do
        local nPos = v['position']
        local strTmp = "["..tostring(nPos).."]"
        strPos = strPos .. strTmp
   end     
   local nTodayTotalRollTimes = System_GetTempData(_idCharacter,nLuaIdActivity,4)

   return System_GM_ChouJiang_Log_Roll(_idCharacter,_nSingleOrTen,nTodayTotalRollTimes,strPos,_tdayID)
end

-- ===============================================================================================================
--  GM 写兑换购买获得物品的经分
--  @_nItemId 兑换的物品id
--  @_nExchangeNums 兑换的次数
--  @_nBefore 兑换前分数
--  @_nAfter 兑换后分数
-- ===============================================================================================================
function GM_ChouJiang_Log_Exchange(_idCharacter,_nItemId,_nExchangeNums,_nBefore,_nAfter)
    return System_GM_ChouJiang_Log_Shop(_idCharacter,_nItemId,_nExchangeNums,_nBefore,_nAfter)
end

-- ===============================================================================================================
--  GM 写兑换购买获得物品的经分
--  广播的接口
--  @_nParentId
-- ===============================================================================================================
function GM_ChouJiang_Syn_ToAll(_idCharacter,_nParentId,_tRewardData)        
    for k,v in pairs(_tRewardData) do
        local nPos = v['position']
        local worldmsg = v['worldmsg']
        if  "number" == type(worldmsg) and worldmsg ~= 0 then                                           
            System_GM_ChouJiang_Syn_ToAll(_idCharacter,_nParentId,nPos,worldmsg)          
        end                
    end
end

-- ===============================================================================================================
--  活动结束 发邮件给玩家
-- ===============================================================================================================
function GM_ChouJiang_SendMail(_idCharacter)
	System_SendMailFromKaiFuChouJiangBag(_idCharacter,Gm_nMailId_ChouJiang)
end