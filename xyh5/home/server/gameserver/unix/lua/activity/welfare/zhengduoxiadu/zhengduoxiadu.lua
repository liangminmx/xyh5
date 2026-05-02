-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1-4 	字段，礼包的ID和购买状态   AAB AA为ID B为购买状态 0未买 1已买
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local nflowaction = CRESOURCEFLOWACTION.eFT_ZhengDuoXiaDu
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]

local tZhengDuoXiaDuCfgInfo = _open_castellan_Info["root"][1]
local tZhengDuoXiaDuCfgInfo_Open = tZhengDuoXiaDuCfgInfo["open"]

local tZhengDuoXiaDuOpenServer = {} --开启的是哪个servernum下的活动

local eZDXD_SetCanRewrad = 1	--服务器发起设置有资格领取奖励
local eZDXD_Req_Reward = 2		--客户端发起申请领取

local eZDXD_Success = 0			--成功
local eZDXD_Unknow = 1			--未知错误
local eZDXD_HasGet = 2			--已购领取
local eZDXD_BagFull = 3			--背包满了
local eZDXD_NoRight = 4			--没有领取奖励资格

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ZhengDuoXiaDu_Login(_idCharacter,_nOsTimes)
	if false == ZhengDuoXiaDu_Login_CheckOpen(_idCharacter) then
		return
	end
	
	local tConfig = ZhengDuoXiaDu_GetServerNumConfig(_idCharacter)
	if nil == next(tConfig)then
		return
	end
	
	ZhengDuoXiaDu_Init(_idCharacter)
	ZhengDuoXiaDu_SynSelf(_idCharacter)
end
table.insert(tOnLoginActivity,ZhengDuoXiaDu_Login)
table.insert(tOnLoginActivity_Cross,ZhengDuoXiaDu_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ZhengDuoXiaDu_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if false == ZhengDuoXiaDu_Login_CheckOpen(_idCharacter) then
		return eCJBP_Unknow
	end
	
	if eZDXD_SetCanRewrad == _nData3 then	
		ZhengDuoXiaDu_Init(_idCharacter)
		local nCanGetReward = System_GetTempData(_idCharacter,nLuaIdActivity,1)
		if 1 ~= nCanGetReward then
			System_SetTempData(_idCharacter, nLuaIdActivity, 1, 1, false)
			ZhengDuoXiaDu_SynSelf(_idCharacter)
		end
		
		return eZDXD_Success
	end
	
	if eZDXD_Req_Reward == _nData3 then
		local nCode = ZhengDuoXiaDu_GetRewardReq(_idCharacter,_nCActionType)
		System_ZhengDuoXiaDu_RewardRet(_idCharacter,nCode)
		-- L2C_DebugLog(nCode)
		return nCode
	end
	
	return eCJBP_Unknow
end
tOnOnAcitveAward[nflowaction] = ZhengDuoXiaDu_Req
tOnOnAcitveAward_Cross[nflowaction] = ZhengDuoXiaDu_Req

-- function TT(_opt,_id)
	-- local nCode = XianShiTeHui_BuyReq(1001000001,644,_opt,_id)
	-- L2C_DebugLog(nCode)
	-- return nCode
-- end
--/calllua </F>TT</N>2</N>1

-- ================================================================================================================
--		根据合服取配置
-- ================================================================================================================
function ZhengDuoXiaDu_GetServerNumConfig(_idCharacter)
	if next(tZhengDuoXiaDuOpenServer) ~= nil then
		return tZhengDuoXiaDuOpenServer
	end	
	
	local nCombined
	if false == System_IsCrossSever() then
		nCombined = System_GetCombinedTimes()
	else
		nCombined = System_GetCombinedTimesByCharacter(_idCharacter)
	end
	
	for k,v in pairs(tZhengDuoXiaDuCfgInfo_Open) do
		if nCombined == v.servernum then
			tZhengDuoXiaDuOpenServer = tZhengDuoXiaDuCfgInfo_Open[k]
			return tZhengDuoXiaDuOpenServer
		end
		if -1 == v.servernum then
			tZhengDuoXiaDuOpenServer = tZhengDuoXiaDuCfgInfo_Open[k]
		end
	end
	if next(tZhengDuoXiaDuOpenServer) == nil then
		L2C_DebugLog(string.format("::ZhengDuoXiaDu_GetServerNumConfig Data Error: CombinedTimes[%d]",nCombined))
	end
	
	return tZhengDuoXiaDuOpenServer
end

-- ================================================================================================================
--		活动开启检测
-- ================================================================================================================
function ZhengDuoXiaDu_Login_CheckOpen(_idCharacter)
	local tConfig = ZhengDuoXiaDu_GetServerNumConfig(_idCharacter)
	if nil == next(tConfig)then
		return false
	end
	
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) 
	if "number" ~= type(tConfig.lv) or  nLevel < tConfig.lv then
		return false
	end
	
	if false == System_IsCrossSever() then
		local nOpenDay = System_GetOpenServerDay()
		if "number" ~= type(tConfig.openday) or  nOpenDay < tConfig.openday then
			return false
		end
	else
		local nOpenDay = System_GetOpenServerDayByCharacter(_idCharacter)
		if "number" ~= type(tConfig.openday) or  nOpenDay < tConfig.openday then
			return false
		end		
	end
	
	return true
end
-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function ZhengDuoXiaDu_Init(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	System_AddTempData(_idCharacter,nLuaIdActivity)
end

-- ================================================================================================================
--		同步活动自己的信息
-- ================================================================================================================
function ZhengDuoXiaDu_SynSelf(_idCharacter)
	local nCanReward = System_GetTempData(_idCharacter, nLuaIdActivity, 1)
	local nHasReward = System_GetTempData(_idCharacter, nLuaIdActivity, 2)
	System_ZhengDuoXiaDuSynSelf(_idCharacter,nCanReward,nHasReward)
end

-- ================================================================================================================
--		领取奖励请求
-- ================================================================================================================
function ZhengDuoXiaDu_GetRewardReq(_idCharacter,_nCActionType)
	if nil == tZhengDuoXiaDuOpenServer["allreward"] then 
		return eZDXD_Unknow -- 没找到配置
	end
	
	local tRewardCfg = tZhengDuoXiaDuOpenServer["allreward"][1]
	if nil == tRewardCfg then
		return eZDXD_Unknow -- 没找到配置
	end
	
	local nCanReward = System_GetTempData(_idCharacter,nLuaIdActivity, 1)
	if nCanReward ~= 1 then
		return eZDXD_NoRight -- 没资格领取
	end
	
	local nHasGetReward = System_GetTempData(_idCharacter,nLuaIdActivity, 2)
	if 1 == nHasGetReward then
		return eZDXD_HasGet -- 已经领取过	
	end
	
	-- 检测是否可以放入背包
	local strItem = ""  -- _sItem格式 "item,num;item2,num2;"
    if  "table" == type(tRewardCfg.allrewarditem) then
        for k,v in pairs(tRewardCfg.allrewarditem) do
            local nItemId = v["itemid"]
            local nNum = v["num"]
            strItem = strItem .. tostring(nItemId) .. "," .. tostring(nNum)..";"
        end 
    end   
	
	--可以放入背包
	if false == System_CanPushThingsToBagEx(_idCharacter,strItem) then
		return eZDXD_BagFull -- 背包满了
	end	
	
	System_SetTempData(_idCharacter, nLuaIdActivity, 2, 1, false)
	
	-- 发放奖励
	if "number" == type(tRewardCfg.money) and tRewardCfg.money > 0 then
		System_AwardMoney(_idCharacter, rewardDetail.money, nflowaction)
	end
	
	if "number" == type(tRewardCfg.emoney) and tRewardCfg.emoney > 0 then
		System_AwardEmoney(_idCharacter, rewardDetail.emoney, nflowaction)
	end
	
	if "number" == type(tRewardCfg.exp) and tRewardCfg.exp > 0 then
		System_AwardExp(_idCharacter, rewardDetail.exp, nflowaction)
	end
	
	if	"table" == type(tRewardCfg.allrewarditem) then
		for	k,v in pairs(tRewardCfg.allrewarditem) do
			local nIdItem = "number" == type(v["itemid"]) and v["itemid"] or 0
			local nNum = "number" == type(v["num"]) and v["num"] or 0
			if nIdItem ~= 0 then
				if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum) then
					System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum)
				end
			end
		end
	end
	
	return eZDXD_Success
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级触发 等级到了开启活动
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ZhengDuoXiaDu_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	ZhengDuoXiaDu_Login(_idCharacter)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],ZhengDuoXiaDu_LevelUp)
tQuestTrigeer_Cross[TASKTYPE.LevelUp] = tQuestTrigeer_Cross[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],ZhengDuoXiaDu_LevelUp)