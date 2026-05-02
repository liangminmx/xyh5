-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		购买掩码 data1 字段，基金的档次
--				 data2 字段，已领档次的等级
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local eCode_UnKnow = -1 --未知错误
local eCode_Succ = 0
local eCode_NotOpen = 1 --活动未开启
local eCode_NotAFund = 2 --没有该档基金
local eCode_HaveFund = 3 --已买过
local eCode_NoEnoughEmoney = 4 --元宝不够
local eCode_BagFull = 5 --背包空间不足

local eKFJJLT_Buy = 1
local eKFJJLT_Award = 2

local nflowaction = CRESOURCEFLOWACTION.eFT_Kaifujijin
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]

local tKaifujijinInfo = _kaifujijin_Info["root"][1]
local tKaifujijinInfo_Open = _kaifujijin_Info["root"][1]["open"][1]
local nKaifujijinInfo_FuncId = tKaifujijinInfo["functionid"][1]["functionid"]

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Kaifujijin_Login(_idCharacter,_nOsTimes)
	if false == Kaifujijin_CheckOpen(_idCharacter) then
		return
	end
	Kaifujijin_Init(_idCharacter)
	--这里额外判断一次给奖励  玩家可能在跨服上升级
	-- Kaifujijin_Award(_idCharacter)

	KaifujijinInfo_Syn(_idCharacter)
	-- KaifujijinInfo_IconStatus(_idCharacter)
end
table.insert(tOnLoginActivity,Kaifujijin_Login)
table.insert(tOnLoginActivity_Cross,Kaifujijin_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		购买接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Kaifujijin_Req(_idCharacter,_nCActionType,_nType,_nData4,_nData5)
	if eKFJJLT_Buy == _nType then
		local code = Kaifujijin_BuyReq(_idCharacter,_nData4)
		return code
	end
	if eKFJJLT_Award == _nType then
		local code = Kaifujijin_AwardReq(_idCharacter,_nData4,_nData5)
		return code
	end
end
tOnOnAcitveAward[nflowaction] = Kaifujijin_Req
tOnOnAcitveAward_Cross[nflowaction] = Kaifujijin_Req

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		购买接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Kaifujijin_BuyReq(_idCharacter,_nFundid)
	if false == Kaifujijin_CheckOpen(_idCharacter) then
		return eCode_NotOpen
	end
	
	local tFund = nil
	for k,v in pairs(tKaifujijinInfo_Open.fund) do
		if v.fundid == _nFundid then
			tFund = v
		end
	end
	
	if "table" ~= type(tFund) then 
		return	eCode_NotAFund
	end
		
	if 0 ~= System_GetTempData(_idCharacter,nLuaIdActivity,1) then		
		return eCode_HaveFund
	end
	
	if false == System_SpendEmoney(_idCharacter,tFund.money,nflowaction) then
		return eCode_NoEnoughEmoney
	end
	
	local tBuyInfo = tKaifujijinInfo_Open.buy[1]
	local tItem = {}
	
	if "table" == type(tBuyInfo) then		
		for k,v in pairs(tBuyInfo.reward) do
			table.insert(tItem,{v.item,v.num})
		end		
	end
	if false == System_CanPushThingsToBagEx(_idCharacter,tItem) then
		return eCode_BagFull
	end
	
	System_SetTempData(_idCharacter,nLuaIdActivity,1,_nFundid)
	
	--发放购买奖励
	if "table" == type(tBuyInfo) then		
		local nEmoney =  tFund.money * tBuyInfo.bindemoneyscale / 100				
		for k,v in pairs(tItem)do
			System_AwardThingInBag(_idCharacter,nflowaction,v[1],v[2])
		end
		System_AwardVouchers(_idCharacter,nEmoney,nflowaction)
		-- System_SendMail(_idCharacter,tBuyInfo.mailid,tItem,0,0,nEmoney)
		Kaifujijin_SendBroadCast(_idCharacter,tFund.notice)
	end
	
	-- Kaifujijin_Award(_idCharacter)
	KaifujijinInfo_Syn(_idCharacter)
	
	return eCode_Succ
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		领取接口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Kaifujijin_AwardReq(_idCharacter,_nFundid,_nLevel)
	local code = Kaifujijin_Award(_idCharacter)
	return code
end
-- ================================================================================================================
--		判断活动是否已开
-- ================================================================================================================
function Kaifujijin_CheckOpen(_idCharacter)
	--开服天数是否满足
	local nOpenday = System_GetCharacterCreateDay(_idCharacter)
	if tKaifujijinInfo_Open.openday > nOpenday then
		return false
	end
	--等级是否满足
	if tKaifujijinInfo_Open.openlev > System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL) then
		return false
	end

	--功能是否解锁
	if  0 ~= System_OpenGuideFunction(_idCharacter,nKaifujijinInfo_FuncId) then
	    return false
	end
	return true
end

-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function Kaifujijin_Init(_idCharacter)
	if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return
	end
	System_AddTempData(_idCharacter,nLuaIdActivity)		
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if "table" ~= type(tKaifujijinInfo_Open.level[1].reward) then
		return
	end	
	-- Kaifujijin_Award(_idCharacter)
end
-- ================================================================================================================
--		给奖励
-- ================================================================================================================
function Kaifujijin_Award(_idCharacter)
	local code = eCode_UnKnow
	local nfund = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nAwardLevel =  System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	local tFund = nil
	for k,v in pairs(tKaifujijinInfo_Open.fund) do
		if v.fundid == nfund then
			tFund = v
		end
	end
	
	if "table" ~= type(tFund) then 
		return	code
	end
	local nMinAward = nAwardLevel
	-- local tAwardKey = {} -- 需要给奖励的key
	local tAwardKey = nil -- 需要给奖励的key
	
	--只取一个最低的
	for k,v in pairs(tKaifujijinInfo_Open.level[1].reward) do
		if nLevel >= v.lv and nAwardLevel < v.lv then			
			-- table.insert(tAwardKey,k)
			if v.lv < nMinAward or nMinAward == nAwardLevel then
				nMinAward = v.lv 
				tAwardKey = k
			end
		end		
	end
	if nMinAward > nAwardLevel then
		System_SetTempData(_idCharacter,nLuaIdActivity,2,nMinAward)
		--这里还要发同步给客户端
	end
	-- for k,v in pairs(tAwardKey) do
	if nil ~= tKaifujijinInfo_Open.level[1].reward[tAwardKey] then
		local nEmoney = tFund.money * tKaifujijinInfo_Open.level[1].reward[tAwardKey].bindemoneyscale / 100
		-- System_SendMail(_idCharacter,tKaifujijinInfo_Open.level[1].mailid,"",0,0,nEmoney)
		System_AwardVouchers(_idCharacter,nEmoney,nflowaction)
		Kaifujijin_SendBroadCast(_idCharacter,tKaifujijinInfo_Open.level[1].reward[tAwardKey].notice)
		code = eCode_Succ
	end
	return eCode_Succ
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级触发
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Kaifujijin_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	
	if Kaifujijin_CheckOpen(_idCharacter) == false then
		Kaifujijin_Init(_idCharacter)
	else
		--Kaifujijin_Award(_idCharacter)
	end
	KaifujijinInfo_Syn(_idCharacter)
	-- KaifujijinInfo_IconStatus(_idCharacter)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],Kaifujijin_LevelUp)
tQuestTrigeer_Cross[TASKTYPE.LevelUp] = tQuestTrigeer_Cross[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],Kaifujijin_LevelUp)

-- ================================================================================================================
--		同步消息
-- ================================================================================================================
function KaifujijinInfo_Syn(_idCharacter)
	if false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		return 
	end
	local nFundid = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nLevel = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	System_KaifujijinInfoSyn(_idCharacter,nFundid,nLevel)
end
-- ================================================================================================================
--		开启活动图标
-- ================================================================================================================
function KaifujijinInfo_IconStatus(_idCharacter)
	local status = 0
	if Kaifujijin_CheckOpen(_idCharacter) then
		--判断奖励有没有领完
		local nGetLevel = System_GetTempData(_idCharacter,nLuaIdActivity,2)
		for k,v in pairs(tKaifujijinInfo_Open.level[1].reward) do
			if nGetLevel < v.lv then
				status = 1		
				break
			end
		end		
	end	
	System_SendActiveStatus(_idCharacter,nflowaction,status,0,0)
end
-- ================================================================================================================
--		购买广播
-- ================================================================================================================
function Kaifujijin_SendBroadCast(_idCharacter,_nNotice)
	local sParam = string.format("%d,%u;%d,%s;"
								,ePreparedStatementValueType.TYPE_UI64,_idCharacter
								,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)		
								)
	System_SendCommonBroadCastMsg(_nNotice,sParam)
end