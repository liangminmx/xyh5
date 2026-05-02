-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1-4 	字段，礼包的ID和购买状态   AAB AA为ID B为购买状态 0未买 1已买
--		data5	记录本次跨服领取的等级 等游服回调领取
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local nflowaction = CRESOURCEFLOWACTION.eFT_ChongJiBiPin
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]

local tChongJiBiPinCfgInfo = _lvgrade_Info["root"][1]
local tChongJiBiPinCfgInfo_Open = tChongJiBiPinCfgInfo["open"]

local tChongJiBiPinOpenServer = {} --开启的是哪个servernum下的活动
local tRewardCfgByLev = {}

local eCJBP_Syn_Global = 1		--申请查询剩余数量
local eCJBP_Req_Reward = 2		--申请领取

local eCJBP_Success = 0			--成功
local eCJBP_Unknow = 1			--未知错误
local eCJBP_HasGet = 2			--已购领取
local eCJBP_NotEnoughReward = 3 --领完了

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChongJiBiPin_Login(_idCharacter,_nOsTimes)
	if false == ChongJiBiPin_Login_CheckOpen(_idCharacter) then
		return
	end
	
	local tConfig = ChongJiBiPin_GetServerNumConfig()
	if nil == next(tConfig)then
		return
	end
	if false == System_IsCrossSever() then
		if false == System_IsExistGlobalData(nLuaIdActivity) then
			System_AddGlobalData(nLuaIdActivity,false)
			local dataStr = ""
			for k,v in pairs(tConfig.reward)do
				if dataStr ~= "" then 
					dataStr = dataStr..'|'..v.lev..','..v.grade
				else 
					dataStr = dataStr..v.lev..','..v.grade
				end
			end
			
			System_SetGlobalDataStr(nLuaIdActivity, dataStr, false)
		end
	end
	
	ChongJiBiPin_Init(_idCharacter)
	ChongJiBiPin_SynSelf(_idCharacter)
	ChongJiBiPin_SynGlobal(_idCharacter)
end
table.insert(tOnLoginActivity,ChongJiBiPin_Login)
table.insert(tOnLoginActivity_Cross,ChongJiBiPin_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChongJiBiPin_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if false == ChongJiBiPin_Login_CheckOpen(_idCharacter) then
		return eCJBP_Unknow
	end

	if eCJBP_Syn_Global == _nData3 then	
		return ChongJiBiPin_SynReq(_idCharacter)
	end
	if eCJBP_Req_Reward == _nData3 then
		if false == System_IsCrossSever() then
			local nCode = ChongJiBiPin_GetRewardReq(_idCharacter,_nCActionType,_nData4)
			System_ChongJiBiPin_RewardRet(_idCharacter,nCode,_nData4)
			-- L2C_DebugLog(nCode)
			return nCode
		else
			System_SetTempData(_idCharacter,nLuaIdActivity,5,_nData4)
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.ChouJiBiPin_GetReward,nLuaIdActivity)
			return eCJBP_Success
		end
	end
	return eCJBP_Unknow
end
tOnOnAcitveAward[nflowaction] = ChongJiBiPin_Req
tOnOnAcitveAward_Cross[nflowaction] = ChongJiBiPin_Req

-- function TT(_opt,_id)
	-- local nCode = XianShiTeHui_BuyReq(1001000001,644,_opt,_id)
	-- L2C_DebugLog(nCode)
	-- return nCode
-- end
--/calllua </F>TT</N>2</N>1

-- ================================================================================================================
--		根据合服取配置
-- ================================================================================================================
function ChongJiBiPin_GetServerNumConfig()
	if next(tChongJiBiPinOpenServer) ~= nil then
		return tChongJiBiPinOpenServer
	end	
	local nCombined = System_GetCombinedTimes()
	for k,v in pairs(tChongJiBiPinCfgInfo_Open) do
		if nCombined == v.servernum then
			tChongJiBiPinOpenServer = tChongJiBiPinCfgInfo_Open[k]
			--return tChongJiBiPinOpenServer
		end
		if -1 == v.servernum then
			tChongJiBiPinOpenServer = tChongJiBiPinCfgInfo_Open[k]
		end
	end
	if next(tChongJiBiPinOpenServer) == nil then
		--L2C_DebugLog(string.format("::ChongJiBiPin_GetServerNumConfig Data Error: CombinedTimes[%d]",nCombined))
	else
--  处理奖励配置		
		for k,v in pairs(tChongJiBiPinOpenServer.reward) do
			tRewardCfgByLev[v.lev] = v
		end
	end
	
	return tChongJiBiPinOpenServer
end

-- ================================================================================================================
--		活动开启检测
-- ================================================================================================================
function ChongJiBiPin_Login_CheckOpen(_idCharacter)
	local tConfig = ChongJiBiPin_GetServerNumConfig()
	if nil == next(tConfig)then
		return false
	end
	
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) 
	if "number" ~= type(tConfig.lv) or  nLevel < tConfig.lv then
		return false
	end
	if System_IsCrossSever() then
		local nOpenDay = System_GetOpenServerDayByCharacter(_idCharacter)
		if "number" ~= type(tConfig.openday) or  nOpenDay < tConfig.openday then
			return false
		end
	else
		local nOpenDay = System_GetOpenServerDay()
		if "number" ~= type(tConfig.openday) or  nOpenDay < tConfig.openday then
			return false
		end
	end
	
	return true
end
-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function ChongJiBiPin_Init(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	System_AddTempData(_idCharacter,nLuaIdActivity)
end

-- ================================================================================================================
--		同步活动自己的信息
-- ================================================================================================================
function ChongJiBiPin_SynSelf(_idCharacter)
	local sStatus = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	System_ChongJiBiPinSynSelf(_idCharacter,sStatus)
end

-- ================================================================================================================
--		同步活动公共信息
-- ================================================================================================================
function ChongJiBiPin_SynGlobal(_idCharacter)
	if false == System_IsCrossSever() then
		local sInfo = System_GetGlobalDataStr(nLuaIdActivity)
		System_ChongJiBiPinSynGlobal(_idCharacter,sInfo)
	else
		System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.ChouJiBiPin_Syn,nLuaIdActivity)
	end
end

function ChongJiBiPin_SynGlobal_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	System_ChongJiBiPinSynGlobal(_idCharacter,_strData)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.ChouJiBiPin_Syn] = ChongJiBiPin_SynGlobal_Cross

-- ================================================================================================================
--		客户端申请同步公共信息请求
-- ================================================================================================================
function ChongJiBiPin_SynReq(_idCharacter)
	ChongJiBiPin_SynGlobal(_idCharacter)
	return eCJBP_Success
end

-- ================================================================================================================
--		领取奖励请求
-- ================================================================================================================
function ChongJiBiPin_GetRewardReq(_idCharacter,_nCActionType,_nLevReq,_sDataStr)
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) 
	if nLevel < _nLevReq then
		--等级不足以领奖励， 防止客户端发加班
		return eCJBP_Unknow
	end

	if nil == tRewardCfgByLev[_nLevReq] then 
		return eCJBP_Unknow -- 没找到配置
	end
	
	local rewardDetail = tRewardCfgByLev[_nLevReq]
	local nStatus = {}
	local tInfoTemp = System_Split( System_GetTempDataStr(_idCharacter,nLuaIdActivity),"|" )   -- 领取奖励情况            
	for k,v in pairs(tInfoTemp) do
		local tInfoTemp1 = System_Split(v, ",")
		nStatus[tonumber(tInfoTemp1[1])] = tonumber(tInfoTemp1[2])
	end
	
	if nil == nStatus[_nLevReq] then
		nStatus[_nLevReq] = 1
	elseif 1 == nStatus[_nLevReq] then
		return eCJBP_HasGet -- 已经领取过
	end
	
	local nGlobalNum = {}
	--非跨服重新取数据
	if false == System_IsCrossSever() then
		_sDataStr = System_GetGlobalDataStr(nLuaIdActivity)
	end
	if "string" ~= type(_sDataStr) then
		return eCJBP_Unknow
	end
	tInfoTemp = System_Split( _sDataStr,"|" )   -- 剩余奖励情况
	for k,v in pairs(tInfoTemp) do
		local tInfoTemp1 = System_Split(v, ",")
		nGlobalNum[tonumber(tInfoTemp1[1])] = tonumber(tInfoTemp1[2])
	end
	
	if nil == nGlobalNum[_nLevReq] then
	-- 配置有新加导致找不到
		nGlobalNum[_nLevReq] = tRewardCfgByLev[_nLevReq].grade
	elseif nGlobalNum[_nLevReq] <= 0 then
		return eCJBP_NotEnoughReward
	end
	
	nGlobalNum[_nLevReq] = nGlobalNum[_nLevReq] - 1

	-- 保存玩家领取情况
	local nStatusStr = ""
	for k,v in pairs(nStatus) do
		if "" == nStatusStr then
			nStatusStr = nStatusStr..k..','..v
		else
			nStatusStr = nStatusStr..'|'..k..','..v
		end
	end 
	System_SetTempDataStr(_idCharacter, nLuaIdActivity, nStatusStr, false)
	
	-- 保存次数
	local sGlobalNumStr = ""
	for k,v in pairs(nGlobalNum) do
		if "" == sGlobalNumStr then
			sGlobalNumStr = sGlobalNumStr..k..','..v
		else
			sGlobalNumStr = sGlobalNumStr..'|'..k..','..v
		end
	end 
	
	if false == System_IsCrossSever() then
		System_SetGlobalDataStr(nLuaIdActivity, sGlobalNumStr, false)
	else
		--这个就不处理返回了
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.ChouJiBiPin_Record,nLuaIdActivity,0,0,sGlobalNumStr)
	end
	
	
	
	-- 广播说某个级数已经没奖励了
	if 0 == nGlobalNum[_nLevReq] then
		System_BroadCastChongJiBiPinRewardZero(_idCharacter, _nLevReq)
	end
	
	-- 发放奖励
	if "number" == type(rewardDetail.money) and rewardDetail.money > 0 then
		System_AwardMoney(_idCharacter, rewardDetail.money, nflowaction)
	end
	
	if "number" == type(rewardDetail.emoney) and rewardDetail.emoney > 0 then
		System_AwardEmoney(_idCharacter, rewardDetail.emoney, nflowaction)
	end
	
	if "number" == type(rewardDetail.exp) and rewardDetail.exp > 0 then
		System_AwardExp(_idCharacter, rewardDetail.exp, nflowaction)
	end
	
	local strItem = ""  -- _sItem格式 "item,num;item2,num2;"
    if  "table" == type(rewardDetail.thing) then
        for k,v in pairs(rewardDetail.thing) do
            local nItemId = v["itemid"]
            local nNum = v["num"]
            strItem = strItem .. tostring(nItemId) .. "," .. tostring(nNum)..";"
        end 
    end   
	
	--可以放入背包
	local _isByMail = 0
	if true == System_CanPushThingsToBagEx(_idCharacter,strItem) then
		if	"table" == type(rewardDetail.thing) then
			for	k,v in pairs(rewardDetail.thing) do
				local nIdItem = "number" == type(v["itemid"]) and v["itemid"] or 0
				local nNum = "number" == type(v["num"]) and v["num"] or 0
				if nIdItem ~= 0 then
					if	false == System_AwardThingInBag(_idCharacter,nflowaction,nIdItem,nNum) then
						System_AwardThingQuestContainer(_idCharacter,nflowaction,nIdItem,nNum)
					end
				end
			end
		end
	else
		_isByMail = 1
		if nil == tChongJiBiPinOpenServer.mail or "number" == type(tChongJiBiPinOpenServer.mail) then
			System_SendMail(_idCharacter,type(tChongJiBiPinOpenServer.mail) and tChongJiBiPinOpenServer.mail or 0,strItem)
		else
			L2C_DebugLog("::ChongJiBiPin_GetRewardReq Data Error: mail ")
		end
	end	
	
	System_ChongJiBiPinLog(_idCharacter, _nLevReq, _isByMail)
	
	return eCJBP_Success
end

-- ================================================================================================================
--		领取奖励请求 跨服
-- ================================================================================================================
function ChongJiBiPin_GetRewardReq_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local _nLevReq = System_GetTempData(_idCharacter,nLuaIdActivity,5)
	local _nCActionType = nflowaction
	local nCode = ChongJiBiPin_GetRewardReq(_idCharacter,_nCActionType,_nLevReq,_strData)
	
	System_ChongJiBiPin_RewardRet(_idCharacter,nCode,_nLevReq)
	
	System_SetTempData(_idCharacter,nLuaIdActivity,5,0)	

end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.ChouJiBiPin_GetReward] = ChongJiBiPin_GetRewardReq_Cross

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级触发 等级到了开启活动
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ChongJiBiPin_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	ChongJiBiPin_Login(_idCharacter)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],ChongJiBiPin_LevelUp)
tQuestTrigeer_Cross[TASKTYPE.LevelUp] = tQuestTrigeer_Cross[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],ChongJiBiPin_LevelUp)

