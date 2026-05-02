
-- ////////////////////////// 抽奖的
 local eKaFuChouJiang_RetCode = {
	eKFCJ_Success = 0,		-- 成功
	eKFCJ_Null = 1,			-- 未知错误
    eKFCJ_NoOpen = 2,       -- 该功能未开启
    eKFCJ_BagNoEnough = 3,  -- 背包空间不够
	eKFCJ_LessEmoney = 4,	-- 消耗的钱不够
    eKFCJ_IdError = 5,      -- 玩家选择的玩法id 和服务器记录的不一样！
}
-- ////////////////////////// 兑换的
local eKaFuChouJiangExChange_RetCode = {
    eKFCJEx_Success = 0,    -- 成功
    eKFCJEx_Null = 1,		-- 未知错误
	eKFCJEx_LessScore = 2,	-- 兑换分数不够
	eKFCJEx_LessTimes = 3,  -- 兑换次数不够
    eKFCJEx_IdError = 4,    -- 玩家选择的玩法id 和服务器记录的不一样！
    eKFCJEx_BagNoEnough = 5,-- 背包满了
}

-- ////////////////////////// 收到客户端的包的类型
local eKaFuChouJiang_Req = {
    eKFCJRT_AcitveSyn = 1,  -- 同步活动信息
	eKFCJRT_Choose = 2,     -- 选择伙伴
	eKFCJRT_Draw = 3,       -- 抽奖
	eKFCJRT_ShopSyn = 4,    -- 商店信息同步
	eKFCJRT_Buy = 5,        -- 购买
}

local nResId = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Play
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]

local nResId = CRESOURCEFLOWACTION.eFt_KaiFuChouJiang_Play
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId] 

local Kaifuchoujiang_Info   = _kaifuchoujiang_Info['root'][1]['group'] 
local Kaifuchoujiang_nOpenLevel  = _kaifuchoujiang_Info['root'][1]['open'][1]['lv']
local nMailId_ChouJiang     = _kaifuchoujiang_Info['root'][1]['open'][1]['mailid']
local tNotice = _kaifuchoujiang_Info['root'][1]['lvnpnotice']

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
function ChouJiang_OnLogin(_idCharacter,_nOsTimes)
	if false == System_IsCrossSever() then--只有在游服才初始化活动数据
		local nStatusBeforeReflesh = ChouJiang_instance_GetStatus()
		-- 调用全服的 instance,要在玩家逻辑前调用！
		ChouJiang_instance_OnLogin(_nOsTimes)
		local nStatusAfterReflesh = ChouJiang_instance_GetStatus()
		if  nStatusBeforeReflesh ~= nStatusAfterReflesh and 0 == nStatusAfterReflesh then
			ChouJiang_SendMail(_idCharacter)
		end
	end

    -- 调用配合记录字段的接口
    ChouJiang_Sign_OnLogin(_idCharacter,_nOsTimes)

    if  false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
        System_AddTempData(_idCharacter,nLuaIdActivity,false)
		--取下背包空间 也可创建背包
		System_GetKaiFuChouJiangBagSpaceNum(_idCharacter)
    end
    -- 判断玩家活动状态
    ChouJiang_Refresh(_idCharacter,_nOsTimes)
	ChouJiang_Syn_Status(_idCharacter)

    -- 同步第三排活动图标显示信息
    ChouJiang_IconShow(_idCharacter,_nOsTimes)
	
end
table.insert(tOnLoginActivity,ChouJiang_OnLogin)
table.insert(tOnLoginActivity_Cross,ChouJiang_OnLogin)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  零点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_ZeroRefresh(_idCharacter,_nOsTimes)
    ChouJiang_OnLogin(_idCharacter,_nOsTimes)
end
table.insert(tOnZeroTrigger,ChouJiang_ZeroRefresh)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家升级的触发(判断活动开启)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_LevelUp(_idCharacter,_old,_new)
    if  _old < Kaifuchoujiang_nOpenLevel and Kaifuchoujiang_nOpenLevel <= _new then
        System_SetTempData(_idCharacter,nLuaIdActivity,8,0) -- 故意设错的日期，触发一次刷新
		
        ChouJiang_Refresh(_idCharacter)		-- 数据刷新 
        ChouJiang_Syn_Status(_idCharacter)  	-- 同步包
        ChouJiang_IconShow(_idCharacter)    	-- 同步第三排图标信息  
    end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  玩家充值
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_Recharge(_idCharacter,_nEmoney,_nOsTimes)
    local nFreeTime = System_GetTempData(_idCharacter,nLuaIdActivity,3)    
    local nRechargeNum = System_GetTempData(_idCharacter,nLuaIdActivity,5)
    local nTodayTotal = System_GetTempData(_idCharacter,nLuaIdActivity,7)    

    -- 当前活动没开启，不知道取的哪一个id，就不更新充值记录了
    local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        -- L2C_DebugLog("::ChouJiang_Recharge get nil server key !")
        return
    end
    local nGetFreeTime = Kaifuchoujiang_Info[nServerKey]['recharge']
	
    nRechargeNum = _nEmoney + nRechargeNum
    local nAddTimes = math.floor(nRechargeNum / nGetFreeTime)    -- 向下取整    
    local nRemainMoney = nRechargeNum % nGetFreeTime
    
	local nFree = tonumber(Kaifuchoujiang_Info[nServerKey]['free']) or 0
	local nLimit = tonumber(Kaifuchoujiang_Info[nServerKey]['limit']) or 0

	nFreeTime = nFreeTime + nAddTimes       -- 还没判断有没有超过上限的次数
    nTodayTotal = nTodayTotal + nAddTimes
    if  nTodayTotal > (nLimit + nFree) then
        local nExtraTimes = nTodayTotal - (nLimit + nFree)-- 多加的次数
        nTodayTotal = nLimit + nFree
        nFreeTime = nFreeTime - nExtraTimes
        if  nFreeTime < 0 then  nFreeTime = 0 end
    end

    System_SetTempData(_idCharacter,nLuaIdActivity,3,nFreeTime,false)
    System_SetTempData(_idCharacter,nLuaIdActivity,5,nRemainMoney,false)
    System_SetTempData(_idCharacter,nLuaIdActivity,7,nTodayTotal,false)
	
	ChouJiang_Syn_Status(_idCharacter)
end
table.insert(tOnUserRechargeEmoney,ChouJiang_Recharge)
table.insert(tOnUserRechargeEmoney_Cross,ChouJiang_Recharge)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  客户端发的包的总接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChouJiang_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
    if  (nil == _idCharacter) or (nResId ~= _nCActionType) or (nil == _nData3) or (nil == _nData4) or (nil == _nData5) then
        L2C_DebugLog("::ChouJiang_Req error ("..(_idCharacter or "nil").."|"..(_nCActionType or "nil").."|"..(_nData3 or "nil").."|"..(_nData4 or "nil").."|"..(_nData5 or "nil")..")")
        return eKaFuChouJiang_RetCode.eKFCJ_Null
    end
    
    -- 同步活动信息
    if  _nData3 == eKaFuChouJiang_Req.eKFCJRT_AcitveSyn then
        ChouJiang_Syn_Status(_idCharacter)
        return 0 -- 默认肯定成功的返回码
    end

    -- 选择伙伴
    if  _nData3 == eKaFuChouJiang_Req.eKFCJRT_Choose then
        ChouJiang_SetParentId(_idCharacter,_nData4)
        ChouJiang_Syn_Status(_idCharacter)
        return 0
    end

    -- 抽奖
    if  _nData3 == eKaFuChouJiang_Req.eKFCJRT_Draw then
        local nRollCode,tRewardData = ChouJiang_PlayingRoll(_idCharacter,_nData4,_nData5)		
        local nScore = System_GetTempData(_idCharacter,nLuaIdActivity,6)
        tRewardData = tRewardData or {}
        -- 发包告诉客户端抽奖结果       		
        ChouJiang_Syn_RollResult(_idCharacter,nRollCode,_nData4,_nData5,tRewardData)
        if  nRollCode == eKaFuChouJiang_RetCode.eKFCJ_Success then 
			--获得daynum
			local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter) 
			local nAwardsKey = ChouJiang_GetAwardsKey(_idCharacter,nServerKey,_nData5)
			local dayID=ChouJiang_GetRewardId(_idCharacter,nServerKey,nAwardsKey)
			
			ChouJiang_Syn_Status(_idCharacter)
            -- 写经分
            ChouJiang_Log_Roll(_idCharacter,_nData4,tRewardData,dayID)
            -- 抽奖结果广播
            ChouJiang_Syn_ToAll(_idCharacter,_nData5,tRewardData)
        end
        return nRollCode
    end

    -- 商店信息同步
    if  _nData3 == eKaFuChouJiang_Req.eKFCJRT_ShopSyn then
        ChouJiang_Syn_ExChangeShop(_idCharacter)  
        return 0
    end

    -- 购买
    if  _nData3 == eKaFuChouJiang_Req.eKFCJRT_Buy then

        local bBuyCode = ChouJiang_Exchange(_idCharacter,_nData4,_nData5)
        if  eKaFuChouJiangExChange_RetCode.eKFCJEx_Success == bBuyCode then
            ChouJiang_Syn_ExChangeShop(_idCharacter)     
        end
        return bBuyCode
    end
end
-- 插入到领取奖励表中
tOnOnAcitveAward[nResId] = ChouJiang_Req
tOnOnAcitveAward_Cross[nResId] = ChouJiang_Req

-- ===============================================================================================================
--  每日刷新数据记录（等级到了开启活动也走这里）
--  无论活动开没开，每日的日期和记录的充值记录都要记录
-- ===============================================================================================================
function ChouJiang_Refresh(_idCharacter,_nOsTimes)
	_nOsTimes = _nOsTimes or os.time()
	local nToday = tonumber( os.date('%Y%m%d',_nOsTimes))
	local nSignDay = tonumber(System_GetTempData(_idCharacter,nLuaIdActivity,8))
	
	if  nToday ~= nSignDay then--判断今日的数据是否处理过
	
		if false == System_IsCrossSever() then
			local nActiveStatus = System_GetGlobalData(nLuaGlobal,1)
			local nGroupId = System_GetGlobalData(nLuaGlobal,4)
			-- 判断能否开启活动
			local nPlayerLevel =  System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
			if  1 == nActiveStatus and nPlayerLevel >= Kaifuchoujiang_nOpenLevel then
				System_SetTempData(_idCharacter,nLuaIdActivity,1,1,false)
			else
				System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
				nActiveStatus = 0
			end
			
			if  1 == nActiveStatus then 
				-- 防止配置多个夸天的活动，出现直接带着老活动积分 进入下一个活动的情况
				local nNowTrueId = nGroupId
				local nNowSignId = ChouJiang_Sign_GetGroupId(_idCharacter)
				
				-- id不一致，出现跨活动情况，优先清空数据
				if  nNowTrueId ~= nNowSignId then     
					System_SetTempData(_idCharacter,nLuaIdActivity,1,1,false)
					System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)
					System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)
					System_SetTempData(_idCharacter,nLuaIdActivity,7,0,false)
					System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)
					--System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)
					ChouJiang_Sign_SetGroupId(_idCharacter,nNowTrueId)  -- 设置正确的 id
				end
				
				-- 判断玩法的 伙伴id 是不是默认的
				ChouJiang_SetDefault_ParentId(_idCharacter)

				local nFreeTime = 0       
				local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
				if  nil == nServerKey then
					L2C_DebugLog("::ChouJiang_Refresh get nil server key !")
				else
					nFreeTime = Kaifuchoujiang_Info[nServerKey]['free'] or 0
				end
				
				System_SetTempData(_idCharacter,nLuaIdActivity,3,nFreeTime,false)   -- 本日可用的免费次数
				System_SetTempData(_idCharacter,nLuaIdActivity,4,0,false)           -- 本日已抽奖次数
				System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)           -- 本日充值数量         
				System_SetTempData(_idCharacter,nLuaIdActivity,7,nFreeTime,false)   -- 本日一共的免费次数
				System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)      -- 本日的日期
				--System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)         -- 物品兑换记录
				ChouJiang_Sign_SetRewardTime(_idCharacter,"")			    		--玩家抽奖次数记录
			else
				-- 活动结束，清除除了日期外的所有数据(省得日期不对一直需要刷新数据)
				System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
				System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)
				System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)
				System_SetTempData(_idCharacter,nLuaIdActivity,7,0,false)
				System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)
				--System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)
				ChouJiang_Sign_SetGroupId(_idCharacter,0)   -- 活动结束，设置进行的活动id = 0
			end
		else
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.ChouJiang_Refresh,nLuaIdActivity)
		end
	end
end
--刷新玩家信息的跨服处理
function ChouJiang_Refresh_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local nActiveStatus = _nData1
	local nGroupId = _nData4
	-- 判断能否开启活动
	local nPlayerLevel =  System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if  1 == nActiveStatus and nPlayerLevel >= Kaifuchoujiang_nOpenLevel then
		System_SetTempData(_idCharacter,nLuaIdActivity,1,1,false)
	else
		System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
		nActiveStatus = 0
	end
	
	if 1 == nActiveStatus then 
		-- 防止配置多个夸天的活动，出现直接带着老活动积分 进入下一个活动的情况
		local nNowTrueId = nGroupId
		local nNowSignId = ChouJiang_Sign_GetGroupId(_idCharacter)
		
		-- id不一致，出现跨活动情况，优先清空数据
		if  nNowTrueId ~= nNowSignId then     
			System_SetTempData(_idCharacter,nLuaIdActivity,1,1,false)
			System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)
			System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)
			System_SetTempData(_idCharacter,nLuaIdActivity,7,0,false)
			System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)
			--System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)
			ChouJiang_Sign_SetGroupId(_idCharacter,nNowTrueId)  -- 设置正确的 id
		end
		
		-- 判断玩法的 伙伴id 是不是默认的
		ChouJiang_SetDefault_ParentId(_idCharacter)

		local nFreeTime = 0       
		local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
		if  nil == nServerKey then
			L2C_DebugLog("::ChouJiang_Refresh get nil server key !")
		else
			nFreeTime = Kaifuchoujiang_Info[nServerKey]['free'] or 0
		end
		
		System_SetTempData(_idCharacter,nLuaIdActivity,3,nFreeTime,false)   -- 本日可用的免费次数
		System_SetTempData(_idCharacter,nLuaIdActivity,4,0,false)           -- 本日已抽奖次数
		System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)           -- 本日充值数量         
		System_SetTempData(_idCharacter,nLuaIdActivity,7,nFreeTime,false)   -- 本日一共的免费次数
		System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)      -- 本日的日期
		--System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)         -- 物品兑换记录
		ChouJiang_Sign_SetRewardTime(_idCharacter,"")			    		--玩家抽奖次数记录
	else
		-- 活动结束，清除除了日期外的所有数据(省得日期不对一直需要刷新数据)
		System_SetTempData(_idCharacter,nLuaIdActivity,1,0,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,3,0,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,7,0,false)
		System_SetTempData(_idCharacter,nLuaIdActivity,8,nToday,false)
		--System_SetTempDataStr(_idCharacter,nLuaIdActivity,"",false)
		ChouJiang_Sign_SetGroupId(_idCharacter,0)   -- 活动结束，设置进行的活动id = 0
	end
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.ChouJiang_Refresh] = ChouJiang_Refresh_Cross

-- ===============================================================================================================
--  记录玩法 id（选择伙伴）
-- ===============================================================================================================
function ChouJiang_SetParentId(_idCharacter,_nParentId)
    System_SetTempData(_idCharacter,nLuaIdActivity,2,_nParentId,false)
end

-- ===============================================================================================================
--  玩家在商店兑换物品
--  @_nGetId 要兑换的物品的id
--  @_nParentId 玩家选择的 'awards' 下的 伙伴 玩法id 
-- ===============================================================================================================
function ChouJiang_Exchange(_idCharacter,_nGetId,_nParentId)
    -- 判断记录的玩法id对不对
    if  _nParentId ~= System_GetTempData(_idCharacter,nLuaIdActivity,2) then        
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_IdError
    end

    -- 获得配置的数据
    local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        L2C_DebugLog("::ChouJiang_Exchange get nil server key !")
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_Null
    end
    -- 获得抽奖的数据配置的key
    local nAwardsKey = ChouJiang_GetAwardsKey(_idCharacter,nServerKey,_nParentId)
    if  nil == nAwardsKey then
        L2C_DebugLog("::ChouJiang_Exchange get nil nAwardsKey,nServerKey:"..nServerKey..",_nParentId:".._nParentId)
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_Null
    end 
    -- 获得可兑换物品的数据
    local temp = Kaifuchoujiang_Info[nServerKey]['awards'][nAwardsKey]['index']
    local tExchangeData = {}
    for k,v in pairs(temp) do
        local newKey = v['id']
        tExchangeData[newKey] = v
    end

    if  "table" ~= type(tExchangeData[_nGetId]) then
        L2C_DebugLog("::ChouJiang_Exchange get a error id :".._nGetId)  -- 物品不存在！
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_Null
    end

    -- 判断背包能不能放得下要兑换来的物品
    if  false == ChouJiang_Exchange_BagEnough(_idCharacter,tExchangeData[_nGetId]['item'],tExchangeData[_nGetId]['num']) then
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_BagNoEnough
    end

    -- 获得已经兑换过的次数   
    local tGetRecord = ChouJiang_ReadStr( System_GetTempDataStr(_idCharacter,nLuaIdActivity) )
    local nHadExchangeTimes = tGetRecord[_nGetId] or 0

    -- 判断兑换次数够不够
    local nTatalTimes = tExchangeData[_nGetId]['exchange']
    if  nHadExchangeTimes >= nTatalTimes and nTatalTimes ~= -1 then
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_LessTimes
    end
    
    -- 判断可兑换分数够不够
    local nNeedExchangeScore = tExchangeData[_nGetId]['cousume']
    local nHadScore_before = System_GetTempData(_idCharacter,nLuaIdActivity,6)
    if  nNeedExchangeScore > nHadScore_before then
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_LessScore
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
        ChouJiang_Log_Exchange(_idCharacter,nItemId,nHadExchangeTimes,nHadScore_before,nHadScore_after)
        
        return eKaFuChouJiangExChange_RetCode.eKFCJEx_Success
    else
        L2C_DebugLog("::ChouJiang_Exchange set Mask error !!!")
    end        
end

-- ===============================================================================================================
--  玩家抽奖
--  @_nSingleOrTen 单次抽奖/10  1/10
--  @_nParentId 玩家选择的 'awards' 下的id 
-- ===============================================================================================================
function ChouJiang_PlayingRoll(_idCharacter,_nSingleOrTen,_nParentId)
    -- 判断玩家是否开启了活动
    if  1 ~= System_GetTempData(_idCharacter,nLuaIdActivity,1) then
        return eKaFuChouJiang_RetCode.eKFCJ_NoOpen
    end
    -- 判断记录的玩法id对不对
    if  _nParentId ~= System_GetTempData(_idCharacter,nLuaIdActivity,2) then        
        return eKaFuChouJiang_RetCode.eKFCJ_IdError
    end
    -- 获得配置的数据
    local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
	local nServerKey_dayReward={}
    if  nil == nServerKey then
        L2C_DebugLog("::ChouJiang_PlayingRoll get nil server key !")
        return eKaFuChouJiang_RetCode.eKFCJ_Null
	end
    local tData = Kaifuchoujiang_Info[nServerKey]
    
    -- 获得抽奖的数据配置的key
    local nAwardsKey = ChouJiang_GetAwardsKey(_idCharacter,nServerKey,_nParentId)
    if  nil == nAwardsKey then
        L2C_DebugLog("::ChouJiang_PlayingRoll get nil nAwardsKey,nServerKey:"..nServerKey..",_nParentId:".._nParentId)
        return eKaFuChouJiang_RetCode.eKFCJ_Null
    end
    -- 获得本次抽奖的消耗多少钱
    local needCost = 0
    local nIntegral = 0
    local nHaveFree = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    if  1 == _nSingleOrTen then   
        if  nHaveFree == 0 then
            needCost = tData['lottery'][1]['single']
        end                
        nIntegral = tData['lottery'][1]['integral']    
    elseif  10 == _nSingleOrTen then        
        needCost    = tData['lottery'][2]['ten']
        nIntegral   = tData['lottery'][2]['integral']
    else   
        L2C_DebugLog("::ChouJiang_PlayingRoll get error _nSingleOrTen:"..tostring(_nSingleOrTen))
        return eKaFuChouJiang_RetCode.eKFCJ_Null
    end
    -- 判断背包空间够不够
    if  false == ChouJiang_Roll_BagEnough(_idCharacter,_nSingleOrTen) then 
        return eKaFuChouJiang_RetCode.eKFCJ_BagNoEnough
    end
    -- 预抽奖，获得本次抽奖最终得到的物品
    local bRoll,tGetReward = ChouJiang_RealRoll(_idCharacter,nServerKey,nAwardsKey,_nSingleOrTen)
    if  false == bRoll then
        L2C_DebugLog("::ChouJiang_PlayingRoll roll fail!")
        return eKaFuChouJiang_RetCode.eKFCJ_Null
    end
    -- 如果是单次抽奖，扣一次免费次数
    if  1 == _nSingleOrTen and nHaveFree > 0 then
        nHaveFree = nHaveFree - 1
        System_SetTempData(_idCharacter,nLuaIdActivity,3,nHaveFree,false)
    else
        -- 判断消耗的钱够不够        
        local nCostId = ChouJiang_GetCostId(_nSingleOrTen)
        if  false == System_SpendEmoney(_idCharacter,needCost,nCostId) then        
            return eKaFuChouJiang_RetCode.eKFCJ_LessEmoney
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
    ChouJiang_Roll_SendReward(_idCharacter,tGetReward)
    return eKaFuChouJiang_RetCode.eKFCJ_Success,tGetReward
end

-- ===============================================================================================================
--  获得'awards' 下的id 的key
-- ===============================================================================================================
function ChouJiang_GetAwardsKey(_idCharacter,_nServerKey,_nParentId)
	if "number" ~= type(_nServerKey) or 0 == _nServerKey then
		_nServerKey = 1
	end
	
	--没有伙伴选择默认伙伴
	local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
	if 0 == _nParentId then
		_nParentId = Kaifuchoujiang_Info[nServerKey]['awards'][1]['id']
	end
    -- 获得 _nParentId 在配置数据中的key
    local nTypeKey = nil
    for k,v in pairs(Kaifuchoujiang_Info[_nServerKey]['awards']) do
        if  v['id'] == _nParentId then
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
function ChouJiang_RealRoll(_idCharacter,_nServerKey,_nAwardsKey,_nSingleOrTen) 
	 local dayID=ChouJiang_GetRewardId(_idCharacter,_nServerKey,_nAwardsKey)
     local nTotalRollTimes = System_GetTempData(_idCharacter,nLuaIdActivity,4)
     local tAllRewardData = Kaifuchoujiang_Info[_nServerKey]['awards'][_nAwardsKey]["daynum"][dayID]['reward']
	 
	 --获得对应物品的抽奖次数
	 local tItemTimes=ChouJiang_Sign_GetRewardTime(_idCharacter)
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
	 ChouJiang_Sign_SetRewardTime(_idCharacter,sItemTimes)
     return true,tGetReward
end

-- ===============================================================================================================
--  计算权重，并取得一个随机值回来
--  @return v(_t 中的一个项)
-- ===============================================================================================================
function ChouJiang_Weights(_t)
    local nTotalWeight = 0
    for k,v in pairs(_t) do
        local nEveryWei = v['weights'] or 0
        nTotalWeight = nTotalWeight + nEveryWei
    end

    local nRan = math.random(nTotalWeight)
    for k,v in pairs(_t) do
        local nReduceWie = v['weights'] or 0
        if  nRan > nReduceWie then
            nRan = nRan - nReduceWie
        else
            return v
        end
    end
end

-- ===============================================================================================================
--  获得消耗的资源流向id
-- ===============================================================================================================
function ChouJiang_GetCostId(_nSingleOrTen)
    if  1 == _nSingleOrTen then
        return CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_Single
    elseif  10 == _nSingleOrTen then
        return CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_Ten
    else
        L2C_DebugLog("::ChouJiang_GetCostId get error _nSingleOrTen:"..tostring(_nSingleOrTen))
    end
end

-- ===============================================================================================================
--  抽奖获得的物品- 判断背包够不够放要抽获得物品
-- ===============================================================================================================
function ChouJiang_Roll_BagEnough(_idCharacter,_nSingleOrTen)
    -- local strItem = ''
    -- local nTempItemId = 100001 -- 随便item找的东西
    -- strItem = tostring(nTempItemId)..","..tostring(_nSingleOrTen)..";"	
    -- return System_CanPushThingsToBagEx(_idCharacter,strItem)
	return System_GetKaiFuChouJiangBagSpaceNum(_idCharacter) >= _nSingleOrTen
end

-- ===============================================================================================================
--  商店兑换 - 判断背包够不够放要抽获得物品
-- ===============================================================================================================
function ChouJiang_Exchange_BagEnough(_idCharacter,_nItemId,_nNum)
    local strItem = tostring(_nItemId)..","..tostring(_nNum)..";"
    return System_CanPushThingsToBagEx(_idCharacter,strItem)
end

-- ===============================================================================================================
--  根据 策划配置的 preselection id，判断是不是要默认给自己设置默认选择 伙伴id
-- ===============================================================================================================
function ChouJiang_SetDefault_ParentId(_idCharacter)
    local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
    if  nil == nServerKey then
        L2C_DebugLog("::ChouJiang_SetParentId get nil serverKey")
        return
    end
    -- 只有一个伙伴玩法，默认给选择
    if  0 == Kaifuchoujiang_Info[nServerKey]['preselection'] then
        local nParentId = Kaifuchoujiang_Info[nServerKey]['awards'][1]['id']
        ChouJiang_SetParentId(_idCharacter,nParentId)
    end
end

-- ===============================================================================================================
--  发放抽奖获得的奖励
--  @_tRewardData 就是抽出了，'reward' 下的具体的奖励数据
-- ===============================================================================================================
function ChouJiang_Roll_SendReward(_idCharacter,_tRewardData) 
    local nGetRollResId = CRESOURCEFLOWACTION.eFT_KaiFuChouJiang_GetReward
    for k,v in pairs(_tRewardData) do
        local nItem = v['item']
        local nNum = v['num']
               
		System_AwardThingInKaiFuChouJiangBag(_idCharacter,nGetRollResId,nItem,nNum)      
       
        -- 判断物品是否要发放全服广播
        local bNotice,nNoticeId = ChouJiang_Notice(nItem)
        if  true == bNotice and "number" == type(nNoticeId) then            
            local sParam = string.format("%d,%u;%d,%s;%d,%d;%d,%d"
									,ePreparedStatementValueType.TYPE_UI64,     _idCharacter
									,ePreparedStatementValueType.TYPE_STRING,   System_GetCharacterName(_idCharacter)									
									,ePreparedStatementValueType.TYPE_UI32,     nItem                                    
									,ePreparedStatementValueType.TYPE_UI32,     1	--绑定
									)            
            System_SendCommonBroadCastMsg(nNoticeId,sParam)
        end
    end
end 

-- ===============================================================================================================
--  判断抽到的物品要不要广播
--  @return true,nNoticeId
-- ===============================================================================================================
function ChouJiang_Notice(_nItemId)
    if  "table" == type(tNotice) then
        for k,v in pairs(tNotice) do
            if  v['item'] == _nItemId then
                return true,v['notice']
            end
        end
    end
end

-- ===============================================================================================================
--  玩家同步第三排图标开启信息
-- ===============================================================================================================
function ChouJiang_IconShow(_idCharacter,_nOsTimes)
    _nOsTimes = _nOsTimes or os.time()
	ChouJiang_Sign_SetNowTime(_idCharacter,_nOsTimes)--跨服临时数据
	
	local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if  1 == nStatus then
		-- 开服抽奖的结束时间天数，直接去对应的 instance 里取得
		if false == System_IsCrossSever() then
			local todayZero = System_GetZeroTime(_nOsTimes)
			local nEndDay_Date = System_GetGlobalData(nLuaIdActivity,3)
			local nNowDay_Date = os.date('%Y%m%d',_nOsTimes)
			local nEndDay_Stamp = System_GetTimeStamp(tonumber(string.sub(nEndDay_Date,1,4)),tonumber(string.sub(nEndDay_Date,5,6)),tonumber(string.sub(nEndDay_Date,7,8)),0,0,0)
			local nNowDay_Stamp = System_GetTimeStamp(tonumber(string.sub(nNowDay_Date,1,4)),tonumber(string.sub(nNowDay_Date,5,6)),tonumber(string.sub(nNowDay_Date,7,8)),0,0,0)
			local nEndTime = nEndDay_Stamp - nNowDay_Stamp + todayZero 
			nEndTime = nEndTime + (24*60*60) -- 取得结束那一天的 24 点
			System_SendActiveStatus(_idCharacter,nResId,1,0,nEndTime)
		else
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.ChouJiang_IconShow,nLuaIdActivity)
		end
	else
		System_SendActiveStatus(_idCharacter,nResId,0,0,0)  -- 不显示
	end
	
end
function ChouJiang_IconShow_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local _nOsTimes = ChouJiang_Sign_GetNowTime(_idCharacter)
	local todayZero = System_GetZeroTime(_nOsTimes)
	local nEndDay_Date = _nData3
	local nNowDay_Date = os.date('%Y%m%d',_nOsTimes)
	local nEndDay_Stamp = System_GetTimeStamp(tonumber(string.sub(nEndDay_Date,1,4)),tonumber(string.sub(nEndDay_Date,5,6)),tonumber(string.sub(nEndDay_Date,7,8)),0,0,0)
	local nNowDay_Stamp = System_GetTimeStamp(tonumber(string.sub(nNowDay_Date,1,4)),tonumber(string.sub(nNowDay_Date,5,6)),tonumber(string.sub(nNowDay_Date,7,8)),0,0,0)
	local nEndTime = nEndDay_Stamp - nNowDay_Stamp + todayZero 
	nEndTime = nEndTime + (24*60*60) -- 取得结束那一天的 24 点
	
	ChouJiang_Sign_SetNowTime(_idCharacter,0)--使用完清理掉数据
	System_SendActiveStatus(_idCharacter,nResId,1,0,nEndTime)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.ChouJiang_IconShow] = ChouJiang_IconShow_Cross

-- ===============================================================================================================
--  拼接兑换次数字符串
-- ===============================================================================================================
function ChouJiang_WriteStr(_t)
    local strNew = ''    
    local tStrTmp = {}
    for k,v in pairs(_t) do
        local strTmp = tostring(k)..","..tostring(v)
        table.insert(tStrTmp,strTmp)
    end

    for i = 1,(#tStrTmp),1 do
        if  i == (#tStrTmp) then
            strNew = strNew .. tStrTmp[i]
        else
            strNew = strNew .. tStrTmp[i] .. "|"
        end
    end
    return strNew
end

-- ===============================================================================================================
--  读取兑换次数字符串
--  table[nItemId] = num
-- ===============================================================================================================
function ChouJiang_ReadStr(_str)
    local tRet = {}
    if  '' == _str or nil == _str then
        return tRet
    end

    local tTmp = System_Split(_str,'|')
    for k,v in pairs(tTmp) do   -- 'nItemId,num'
        local tItemData = System_Split(v,',')
        local nItemId = tonumber(tItemData[1])
        local nNum = tonumber(tItemData[2])
        tRet[nItemId] = nNum
    end
    return tRet
end

-- ===============================================================================================================
--  同步活动信息
-- ===============================================================================================================
function ChouJiang_Syn_Status(_idCharacter)
    local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    local nParentId = System_GetTempData(_idCharacter,nLuaIdActivity,2)
    local nRemainFree = System_GetTempData(_idCharacter,nLuaIdActivity,3)
    local nTotalFree = System_GetTempData(_idCharacter,nLuaIdActivity,7)
    local nGroupId = ChouJiang_Sign_GetGroupId(_idCharacter)
	
	--默认选择第1天，玩家没有选择伙伴的时候读数据有问题
	local nDayId=1
	if 0 < nParentId then
		local nServerKey = ChouJiang_Sign_GetServerKey(_idCharacter)
		local nAwardsKey = ChouJiang_GetAwardsKey(_idCharacter,nServerKey,nParentId)
		nDayId=ChouJiang_GetRewardId(_idCharacter,nServerKey,nAwardsKey)
	end
    return System_KaiFuChouJiang_Syn_ActiveStatus(_idCharacter,nStatus,nParentId,nRemainFree,nTotalFree,nGroupId,nDayId)
	--return System_KaiFuChouJiang_Syn_ActiveStatus(_idCharacter,nStatus,nParentId,nRemainFree,nTotalFree,nGroupId)
end

-- ===============================================================================================================
--  抽奖结果包
-- ===============================================================================================================
function ChouJiang_Syn_RollResult(_idCharacter,_nCode,_nRollTimes,_nParentId,_tRewardData)
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
   return System_KaiFuChouJiang_Syn_RollRet(_idCharacter,_nCode,_nRollTimes,_nParentId,nScore,strRewardPos)
end

-- ===============================================================================================================
--  开服兑换商店数据同步包
-- ===============================================================================================================
function ChouJiang_Syn_ExChangeShop(_idCharacter)
    local nScore = System_GetTempData(_idCharacter,nLuaIdActivity,6)
    local strBuyRecord = System_GetTempDataStr(_idCharacter,nLuaIdActivity)    

    return System_KaiFuChouJiang_Syn_ShopStatus(_idCharacter,nScore,strBuyRecord)
end

-- ===============================================================================================================
--  写抽奖获得物品的经分
-- ===============================================================================================================
function ChouJiang_Log_Roll(_idCharacter,_nSingleOrTen,_tRewardData,_tdayID)   
   local strPos = ""
   for  k,v in pairs(_tRewardData) do
        local nPos = v['position']
        local strTmp = "["..tostring(nPos).."]"
        strPos = strPos .. strTmp
   end     
   local nTodayTotalRollTimes = System_GetTempData(_idCharacter,nLuaIdActivity,4)

   return System_KaiFuChouJiang_Log_Roll(_idCharacter,_nSingleOrTen,nTodayTotalRollTimes,strPos,_tdayID)
end

-- ===============================================================================================================
--  写兑换购买获得物品的经分
--  @_nItemId 兑换的物品id
--  @_nExchangeNums 兑换的次数
--  @_nBefore 兑换前分数
--  @_nAfter 兑换后分数
-- ===============================================================================================================
function ChouJiang_Log_Exchange(_idCharacter,_nItemId,_nExchangeNums,_nBefore,_nAfter)
    return System_KaiFuChouJiang_Log_Shop(_idCharacter,_nItemId,_nExchangeNums,_nBefore,_nAfter)
end

-- ===============================================================================================================
--  写兑换购买获得物品的经分
--  广播的接口
-- ===============================================================================================================
function ChouJiang_Syn_ToAll(_idCharacter,_nParentId,_tRewardData)  
    for k,v in pairs(_tRewardData) do
        local nPos = v['position']
        local worldmsg = v['worldmsg']
        if  "number" == type(worldmsg) and worldmsg ~= 0 then            
            System_KaiFuChouJiang_Syn_ToAll(_idCharacter,_nParentId,nPos,worldmsg)         
        end
    end
end
-- ===============================================================================================================
--  活动结束 发邮件给玩家
-- ===============================================================================================================
function ChouJiang_SendMail(_idCharacter)
	--local nStatus = System_GetTempData(_idCharacter,nLuaIdActivity,1)
    --if  0 == nStatus then     
		System_SendMailFromKaiFuChouJiangBag(_idCharacter,nMailId_ChouJiang)
	--end
end

-- ===============================================================================================================
--  根据次数计算抽奖结果
--	tAllRewardData	抽奖配置数据
--	_nSingleOrTen	本次抽奖总计次数
--	tItemTimes		对应物品的抽奖次数
-- ===============================================================================================================
function ChouJiang_TimeToRoll(tAllRewardData,tItemTimes)
	local ntime=1
	-- 处理获得本次抽奖最终可以获得物品,先放入奖池再计算次数(策划说满足次数后的下一次才会生效)
	 local isError=true
	 local errorItem
     local tRealRewardData = {}
     for k,v in pairs(tAllRewardData) do
		if -1 == tonumber(tItemTimes[ntime]) or 0 == tonumber(tItemTimes[ntime]) then
			local tTmp = v
			tTmp['posKey'] = k
			table.insert(tRealRewardData,tTmp)

			--错误验证
			if isError then	
				isError=false
				errorItem = v
				errorItem['posKey'] = k
			end
		else
			tItemTimes[ntime]=tonumber(tItemTimes[ntime])-1
		end
		ntime=ntime+1
     end
	 if isError then 
		table.insert(tRealRewardData,errorItem)
		L2C_DebugLog("ChouJiang::Min num all error,nothing can roll")
	 end
	 return tRealRewardData,tItemTimes  
end

-- ===============================================================================================================
--  物品抽奖记录初始化
-- ===============================================================================================================
function ChouJiang_ItemTimeInst(tAllRewardData)
	local tItemTime={}
	for key,value in pairs(tAllRewardData) do
		local _min = ""==value["min"] and -1 or value["min"]
		table.insert(tItemTime,_min)
	end
	
	return tItemTime
end
