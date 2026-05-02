local nResId = CRESOURCEFLOWACTION.eFT_FestivalConsume
local nLuaTempid = LUARESOURCEFLOWACTION[nResId]
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local FestivalConsume_Info = _festival_newconsume_Info['root'][1]['openday'][1]['group']
local FestivalConsume_Openday = _festival_newconsume_Info['root'][1]['openday'][1]

local eFCLT_Syn = 1
local eFCLT_Reward = 2
local eFCLT_ActivityInfo = 3

local eFestivalCMC_Unknow = 0
local eFestivalCMC_Success = 1
local eFestivalCMC_HadGet = 2
local eFestivalCMC_ConsumeMoneyNotEnough = 3
local eFestivalCMC_ActivityEnd = 4
local eFestivalCMC_BagFull = 5
local eFestivalCMC_PushBagFaild = 6
local eFestivalCMC_LvNotEnough = 7

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--			data1: 已消费金额
--			data8: groupid 	
--			datastr: 奖励领取状态  id1,num1,id2,num2,id3,num3,id4,num4	
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 玩家登录
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FestivalConsume_Person_Login(_idCharacter,_nOsTimes)
	_nOsTimes = _nOsTimes or os.time()
	
	if false == System_IsCrossSever() then
		if false == System_IsExistTempData(_idCharacter,nLuaTempid) then
			System_AddTempData(_idCharacter,nLuaTempid,false)
		end
		
		GM_FestivalConsume_instance_OnLogin(_nOsTimes)
		
		--将玩家身上的groupId 同步为Global，这样在跨服上就不用取
		local nGlobalGroup = System_GetGlobalData(nLuaGlobal,4)
		if nGlobalGroup ~= System_GetTempData(_idCharacter,nLuaTempid,8) then --跨服后加的功能要额外验证后来的玩家数据
			System_SetTempData(_idCharacter,nLuaTempid,8,nGlobalGroup)
			System_SetAllTempData(_idCharacter,nLuaTempid,0,0,0,0,0,0,0,nGlobalGroup,"") 
		end
		
		FestivalConsume_Person_SendActivityInfo(_idCharacter)
	end

	FestivalConsume_Person_SendActiveStatus(_idCharacter)
end
table.insert(tOnLoginActivity,FestivalConsume_Person_Login)
table.insert(tOnLoginActivity_Cross,FestivalConsume_Person_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		同步客户端活动信息
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FestivalConsume_Person_SendActivityInfo(_idCharacter)
	local nGroupId = System_GetGlobalData(nLuaGlobal,4)
	local nUserGroupId = System_GetTempData(_idCharacter,nLuaTempid,8)	

	if nGroupId > 0 or (nGroupId == 0 and nUserGroupId > 0)then
		--日期转时间戳给客户端
		local nBegin = System_GetGlobalData(nLuaGlobal,2)
		local nEnd = System_GetGlobalData(nLuaGlobal,3)
		local nBegin_Stamp = System_GetTimeStamp(tonumber(string.sub(nBegin,1,4)),tonumber(string.sub(nBegin,5,6)),tonumber(string.sub(nBegin,7,8)),0,0,0)
		local nEnd_Stamp = System_GetTimeStamp(tonumber(string.sub(nEnd,1,4)),tonumber(string.sub(nEnd,5,6)),tonumber(string.sub(nEnd,7,8)),24,0,0)
		System_FestivalConsumeActivityInfo(_idCharacter,nBegin_Stamp,nEnd_Stamp,nGroupId)
	end	
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		0点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function FestivalConsume_Person_ZeroRefresh(_idCharacter,_nOsTimes)
	--L2C_DebugLog("run:: FestivalConsume_Person_ZeroRefresh")
	
	local nGroup = System_GetTempData(_idCharacter,nLuaTempid,8) 
	local tGroupInfokey = 0
	for k,v in pairs(FestivalConsume_Info) do
		if v.id == nGroup then
			tGroupInfokey = k
		end
	end
	
	if "table" == type(FestivalConsume_Info[tGroupInfokey]) then
		--先发奖
		--L2C_DebugLog("rewardtype="..FestivalConsume_Info[tGroupInfokey]["rewardtype"])
		if 1 == FestivalConsume_Info[tGroupInfokey]["rewardtype"] then
			--local nConsumenum = System_GetTempData(_idCharacter,nLuaTempid,1)
			--FestivalConsume_Person_SendEndReward(_idCharacter,nConsumenum)
			System_SetTempDataStr(_idCharacter,nLuaTempid,"")
		end 
	end

	--活动内容检索
	GM_FestivalConsume_instance_OnLogin(_nOsTimes)
	
	--玩家个人信息检索
	local nGlobalGroup = System_GetGlobalData(nLuaGlobal,4)
	if nGlobalGroup ~= nGroup then
		System_SetTempData(_idCharacter,nLuaTempid,8,nGlobalGroup)
		System_SetAllTempData(_idCharacter,nLuaTempid,0,0,0,0,0,0,0,nGlobalGroup,"")
		nGroup = nGlobalGroup
	end
	
	--处理所在组信息
	tGroupInfokey = 0
	for k,v in pairs(FestivalConsume_Info) do
		if v.id == nGroup then
			tGroupInfokey = k
		end
	end
	if "table" ~= type(FestivalConsume_Info[tGroupInfokey]) then
		return 
	end
	
	local tGroupInfo = FestivalConsume_Info[tGroupInfokey]
	if "number" == type(tGroupInfo.reset) and 1 == tGroupInfo.reset then
		System_SetTempData(_idCharacter,nLuaTempid,1,0)
	end
	
	--同步数据
	FestivalConsume_Person_SendActivityInfo(_idCharacter)
	FestivalConsume_Person_SendActiveStatus(_idCharacter)
end
table.insert(tOnZeroTrigger,FestivalConsume_Person_ZeroRefresh)

-- ===============================================================================================================
-- 发放活动状态给客户端
-- =============================================================================================================== 
function FestivalConsume_Person_SendActiveStatus(_idCharacter)	
	local nConsumenum = System_GetTempData(_idCharacter,nLuaTempid,1)
	local sRewardStatus = System_GetTempDataStr(_idCharacter,nLuaTempid)
	local nGroupId = System_GetTempData(_idCharacter,nLuaTempid,8)
	if nGroupId > 0 then
		System_FestivalConsumeSendInfoRet(_idCharacter,nConsumenum,sRewardStatus)
	end
end

-- ===============================================================================================================
-- 服务端消息入口
-- =============================================================================================================== 
function FestivalConsume_Person_ReqMain(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	if eFCLT_Syn == _nData1 then
		return FestivalConsume_Person_Syn(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	end
	if eFCLT_Reward == _nData1 then
		local nCode = FestivalConsume_Person_Award(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
		local nConsumenum = System_GetTempData(_idCharacter,nLuaTempid,1)
		local nGroupId = System_GetTempData(_idCharacter,nLuaTempid,8)
		System_FestivalConsumeSendGetRewardRet(_idCharacter, nCode, _nData2, _nData3, nConsumenum, nGroupId)
		return nCode
	end
	return eFLAC_Unknow
end
tOnOnAcitveAward[nResId] = FestivalConsume_Person_ReqMain
tOnOnAcitveAward_Cross[nResId] = FestivalConsume_Person_ReqMain


function FestivalConsume_Person_Syn(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	FestivalConsume_Person_SendActiveStatus(_idCharacter)	
	return eFestivalCMC_Success
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 领取奖励
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function FestivalConsume_Person_Award(_idCharacter,_nCActionType,_nData1,_nGetRewardid,_nRewardNum)	
	--处理所在组信息
	local nGroup = System_GetTempData(_idCharacter,nLuaTempid,8) 
	local tGroupInfokey = 0
	for k,v in pairs(FestivalConsume_Info) do
		if v.id == nGroup then
			tGroupInfokey = k
		end
	end
	if "table" ~= type(FestivalConsume_Info[tGroupInfokey]) then
		return eFestivalCMC_Unknow
	end
	
	local tGroupInfo = FestivalConsume_Info[tGroupInfokey]
	--判断等级
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if FestivalConsume_Openday.lv > nLevel then
		return eFestivalCMC_LvNotEnough
	end
	--判断领取状态
	local sStatus_award = System_GetTempDataStr(_idCharacter,nLuaTempid)
	local tStatus_award = System_Split(sStatus_award,",")	
	local tStatus_award_Done = {}
	for i = 1 , #tStatus_award / 2 do
		tStatus_award_Done[tonumber(tStatus_award[2*i - 1])] = tonumber(tStatus_award[2*i])
	end
	
	local tConsumeInfo = {}
	for k,v in pairs(tGroupInfo.consume) do
		if _nGetRewardid == v.id then
			tConsumeInfo = tGroupInfo.consume[k]
		end
	end
	
	if nil == next(tConsumeInfo) then
		return eFestivalCMC_Unknow
	end
	
	if "number" == type(tStatus_award_Done[_nGetRewardid]) then
		if tConsumeInfo.time < _nRewardNum + tStatus_award_Done[_nGetRewardid] then
			return eFestivalCMC_HadGet
		end
	end
	
	--判断领取条件
	local nConsumenum = System_GetTempData(_idCharacter,nLuaTempid,1)
	if nConsumenum < tConsumeInfo.consume * (( tStatus_award_Done[_nGetRewardid] or 0 ) + _nRewardNum) then
		return eFestivalCMC_ConsumeMoneyNotEnough
	end
	
	local tReward = tConsumeInfo.rewarditem
	--判断背包空间
	local sItem = ""	 
	for k,v in pairs(tReward) do
		local nIdItem = "number" == type(v["item"]) and v["item"] or 0
		local nNum = "number" == type(v["num"]) and v["num"] or 0
		sItem = sItem .. nIdItem .. "," .. nNum .. ";"
	end
	if false == System_CanPushThingsToBagEx(_idCharacter,sItem) then
		return eFestivalCMC_BagFull
	end
	--设置掩码
	tStatus_award_Done[_nGetRewardid] = ( tStatus_award_Done[_nGetRewardid] or 0 ) + _nRewardNum
	local tRecord = {}
	for k,v in pairs(tStatus_award_Done) do
		table.insert(tRecord,k..","..v)
	end	
	System_SetTempDataStr(_idCharacter,nLuaTempid,System_StrCatOnTable(tRecord,","))
	
	--发放奖励
	local nExp = "number" == type(tReward.exp) and tReward.exp or 0
	if nExp > 0 then
		System_AwardExp(_idCharacter,nExp, _nCActionType)
	end

	for k,v in pairs(tReward) do
		local nIdItem = "number" == type(v["item"]) and v["item"] or 0
		local nNum = "number" == type(v["num"]) and v["num"] or 0
		local nBind = "number" == type(v["bind"]) and v["bind"] or 0 --下面接口给的东西都是绑定的
		System_AwardThingInBag(_idCharacter,_nCActionType,nIdItem,nNum * _nRewardNum)
	end	
	return eFestivalCMC_Success
end
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 领取奖励
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function FestivalConsume_Person_SpendEmoney(_idCharacter,_nSpendEmoney)
	local nConsumenum = System_GetTempData(_idCharacter,nLuaTempid,1)
	System_SetTempData(_idCharacter,nLuaTempid,1,nConsumenum + _nSpendEmoney)
	System_FestivalConsumeSynPlayerCostNum(_idCharacter, nConsumenum + _nSpendEmoney)
end
table.insert(tOnUserSpendEmoney,FestivalConsume_Person_SpendEmoney)
table.insert(tOnUserSpendEmoney_Cross,FestivalConsume_Person_SpendEmoney)


function FestivalConsume_Person_SendEndReward(_idCharacter,nConsumenum)
	local nGroup = System_GetTempData(_idCharacter,nLuaTempid,8) 
	local tGroupInfokey = 0
	for k,v in pairs(FestivalConsume_Info) do
		if v.id == nGroup then
			tGroupInfokey = k
		end
	end
	if "table" ~= type(FestivalConsume_Info[tGroupInfokey]) then
		return
	end
	local tGroupInfo = FestivalConsume_Info[tGroupInfokey]
	
	--判断等级
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if FestivalConsume_Openday.lv > nLevel then
		return
	end
	
	--判断领取状态
	local sStatus_award = System_GetTempDataStr(_idCharacter,nLuaTempid)
	local tStatus_award = System_Split(sStatus_award,",")	
	local tStatus_award_Done = {}
	for i = 1 , #tStatus_award / 2 do
		tStatus_award_Done[tonumber(tStatus_award[2*i - 1])] = tonumber(tStatus_award[2*i])
	end
	
	local _nRewardNum = 1
	for k,v in pairs(tGroupInfo.consume) do
		FestivalConsume_Person_CheckReward(_idCharacter,tGroupInfo.consume[k],tStatus_award_Done,_nRewardNum,tGroupInfokey,v.id,nConsumenum)
	end
end

function FestivalConsume_Person_CheckReward(idCharacter,tConsumeInfo,tStatus_award_Done,_nRewardNum,tGroupInfokey,_nGetRewardid,nConsumenum)
	
	if nil == next(tConsumeInfo) then
		return
	end
	
	if "number" == type(tStatus_award_Done[_nGetRewardid]) then
		if tConsumeInfo.time < _nRewardNum + tStatus_award_Done[_nGetRewardid] then
			return
		end
	end
	
	--判断领取条件
	if nConsumenum < tConsumeInfo.consume * (( tStatus_award_Done[_nGetRewardid] or 0 ) + _nRewardNum) then
		return eFestivalCMC_ConsumeMoneyNotEnough
	end
	
	local tReward = tConsumeInfo.rewarditem

	--发放奖励
	local nExp = "number" == type(tReward.exp) and tReward.exp or 0
	if nExp > 0 then
		System_AwardExp(_idCharacter,nExp, _nCActionType)
	end
	
	local sItem = ""	 
	for k,v in pairs(tReward) do
		local nIdItem = "number" == type(v["item"]) and v["item"] or 0
		local nNum = "number" == type(v["num"]) and v["num"] or 0
		sItem = sItem .. nIdItem .. "," .. nNum .. ";"
	end
	System_SendMail(_idCharacter,111111111,sItem)
end





