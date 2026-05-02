-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--		掩码 data1		字段 activeid	--临时数据 跨服存给游服用
--		掩码 data2		字段 id			--临时数据 跨服存给游服用
--		掩码 data3		字段 price		--临时数据 跨服存给游服用
--		掩码 data7		字段 time		--20140503113011
--		掩码 data8		字段 activeid
--		掩码 datastr 	字段,自己的出价记录  aaa,bbb
--	Note：Global
--		掩码 data1		字段 idCurCharacter
--		掩码 data2		字段 idCurCharacter
--		掩码 data8		字段 activeid
--		掩码 datastr		字段 最高出价
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local nflowaction = CRESOURCEFLOWACTION.eFT_PaiMai_Item
local nflowactionEmoney = CRESOURCEFLOWACTION.eFT_PaiMai_Emoney
local nLuaIdActivity = LUARESOURCEFLOWACTION[nflowaction]
local nLuaGlobal = LUARESOURCEFLOWACTION[nflowaction]

local tPaiMaiInfo = _paimai_Info["config"][1]["server"]
local nPaiMaiFunctionId = _paimai_Info["config"][1]["functionid"][1]["functionid"]

local tPaiMaiOpenServer = {} --开启的是哪个servernum下的活动
local nPaiMaiIdCount = 2 	-- 一次最多拍卖几个物品
local bPaiMai_AddActiveEndTrigger_InOpen = false -- 是否增加监听
local isInit = 0
local nPaiMaiMaxDay = -1

local ePMC_Success = 0
local ePMC_Unknow = 1
local ePMC_PriceLess = 2 	--出价不足 
local ePMC_OutTime = 3   	--活动已结束
local ePMC_Self = 4   		--当前最高价是自己
local ePMC_EmoneyLess = 5   	--元宝不足
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		登录
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function PaiMai_Login(_idCharacter,_nOsTimes)
	PaiMai_GetMaxDay()
	
	if 0 == isInit then
		PaiMai_AddActiveStart()
		PaiMai_AddActiveEndTrigger_InOpen(_nOsTimes)
		isInit=1
	end	
	
	if false == PaiMai_Login_CheckOpen(_idCharacter) then
		System_PaiMaiSyn(_idCharacter,0,"","","")
		return
	end
	PaiMai_Init(_idCharacter)
	PaiMai_Syn(_idCharacter)	
	local tConfig = PaiMai_GetServerNumConfig()
	if nil ~= next(tConfig)then
		local  endtime  =  string.gsub(tConfig.day[1].closetime, ":", "")
		local  nowtime  = os.date("%H%M%S",os.time()) 
		if (tonumber(nowtime) >= tonumber(endtime)) then
			PaiMai_SendEndInfo(_idCharacter)
		end		
	end
end
table.insert(tOnLoginActivity,PaiMai_Login)
table.insert(tOnLoginActivity_Cross,PaiMai_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function PaiMai_Req(_idCharacter,_nCActionType,_nData3,_nData4,_nData5)
	if false == PaiMai_Login_CheckOpen(_idCharacter) then
		System_PaiMaiOffer(_idCharacter,ePMC_OutTime,_nData3,_nData4,_nData5)
		return ePMC_OutTime
	end
	if false == System_IsCrossSever() then
		local code = PaiMai_OfferReq(_idCharacter,_nData3,_nData4,_nData5)
		System_PaiMaiOffer(_idCharacter,code,_nData3,_nData4,_nData5)
		return code
	else
		System_SetTempData(_idCharacter,nLuaIdActivity,1,_nData3)
		System_SetTempData(_idCharacter,nLuaIdActivity,2,_nData4)
		System_SetTempData(_idCharacter,nLuaIdActivity,3,_nData5)
		System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.__PaiMai_Offer,nLuaGlobal)
		return ePMC_Success
	end
end
tOnOnAcitveAward[nflowaction] = PaiMai_Req
tOnOnAcitveAward_Cross[nflowaction] = PaiMai_Req

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		0点刷新
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function PaiMai_ZeroRefresh(_idCharacter,_nOsTimes)	
	System_SetTempData(_idCharacter,nLuaIdActivity,1,0)
	System_SetTempDataStr(_idCharacter,nLuaIdActivity,"")
	System_SetTempData(_idCharacter,nLuaIdActivity,8,System_GetGlobalData(nLuaGlobal,8))
end
table.insert(tOnZeroTrigger,PaiMai_ZeroRefresh)
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--		升级处理
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function PaiMai_LevelUp(_idCharacter,_nType,_nOld,_nNew,_nData3,_nData4)
	--if true == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
	--	return
	--end
	PaiMai_Login(_idCharacter,_nOsTimes)
end
tQuestTrigeer[TASKTYPE.LevelUp] = tQuestTrigeer[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer[TASKTYPE.LevelUp],PaiMai_LevelUp)
tQuestTrigeer_Cross[TASKTYPE.LevelUp] = tQuestTrigeer_Cross[TASKTYPE.LevelUp] or {}
table.insert(tQuestTrigeer_Cross[TASKTYPE.LevelUp],PaiMai_LevelUp)

-- ================================================================================================================
--		根据合服取配置
-- ================================================================================================================
function PaiMai_GetServerNumConfig()
	if next(tPaiMaiOpenServer) ~= nil then
		return tPaiMaiOpenServer
	end	
	local nCombined = System_GetCombinedTimes()
	for k,v in pairs(tPaiMaiInfo) do
		if nCombined == v.servernum then
			tPaiMaiOpenServer = tPaiMaiInfo[k]
			return tPaiMaiOpenServer
		end
		if -1 == v.servernum then
			tPaiMaiOpenServer = tPaiMaiInfo[k]
		end
	end
	if next(tPaiMaiOpenServer) == nil then
		L2C_DebugLog(string.format("::PaiMai_GetServerNumConfig Data Error: CombinedTimes[%d]",nCombined))
	end
	return tPaiMaiOpenServer
end

-- ================================================================================================================
--		活动开启检测
-- ================================================================================================================
function PaiMai_Login_CheckOpen(_idCharacter)
	local tConfig = PaiMai_GetServerNumConfig()
	if nil == next(PaiMai_GetServerNumConfig() )then
		return false
	end
	if 0 == _idCharacter then
		return true
	end
	
	if "number" ~= type(tConfig.day[1].openday) or  "number" ~= type(tConfig.day[1].continue) then
		return false
	end
	local nOpenDay = 1
	if false == System_IsCrossSever() then
		nOpenDay = System_GetOpenServerDay()
	else
		nOpenDay = System_GetOpenServerDayByCharacter(_idCharacter)
	end
	if nOpenDay < tConfig.day[1].openday or nOpenDay >= tConfig.day[1].openday + tConfig.day[1].continue then
		return false
	end
	if 0 ~= System_OpenGuideFunction(_idCharacter,nPaiMaiFunctionId) then
		return false
	end	
	return true
end

-- ================================================================================================================
--		初始化开启活动信息
-- ================================================================================================================
function PaiMai_Init(_idCharacter)
	if false == System_IsCrossSever() then
		if false == System_IsExistGlobalData(nLuaGlobal) then
		
			System_AddGlobalData(nLuaGlobal)
			
			local tConfig = PaiMai_GetServerNumConfig()
			local nOpenDay = System_GetOpenServerDay()
			for k,v in pairs(tConfig.day[1].auction) do
				if v.activity == nOpenDay then
					local tBasePrice = {}
					for l,w in pairs(v.reward) do
						if w.id <= nPaiMaiIdCount then
							tBasePrice[w.id] = w.baseprice
						end
					end
					for i= 1,nPaiMaiIdCount do
						tBasePrice[i] = tBasePrice[i] or 0
					end
					System_SetGlobalData(nLuaGlobal,8,v.activity)
					System_SetGlobalDataStr(nLuaGlobal,System_StrCatOnTable(tBasePrice,","))
					--local nDayEndTime = string.gsub(v.closetime, ":", "")
					--nDayEndTime = math.modf(nDayEndTime/100)
					--tTime_HM[nDayEndTime] = tTime_HM[nDayEndTime] or {}
					--table.insert(tTime_HM[nDayEndTime],PaiMai_ActiveEnd)
					break
				end
			end
		end
		if false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then		
			System_AddTempData(_idCharacter,nLuaIdActivity)	
		end		
		
	end

end
-- ================================================================================================================
--		同步活动信息
-- ================================================================================================================
function PaiMai_Syn(_idCharacter)
	if false == System_IsCrossSever() then
		local nActivity = System_GetGlobalData(nLuaGlobal,8)
		if nActivity ~= System_GetTempData(_idCharacter,nLuaIdActivity,8) then
			System_SetTempData(_idCharacter,nLuaIdActivity,8,nActivity)
			System_SetTempData(_idCharacter,nLuaIdActivity,7,0)
		end
		PaiMai_Syn_GameServer(_idCharacter)
	else
		System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.__PaiMai_SynInfo,nLuaGlobal)
	end
end


function PaiMai_Syn_GameServer(_idCharacter)
	local activityid = System_GetGlobalData(nLuaGlobal,8)
	if activityid > nPaiMaiMaxDay then
		System_PaiMaiSyn(_idCharacter,0,"","","") 
		return
	end
	
	local tCurCharacter = {}
	for i = 1,nPaiMaiIdCount do
		tCurCharacter[i] = System_GetGlobalData(nLuaGlobal,i)	
	end
	local cur_price = System_GetGlobalDataStr(nLuaGlobal) or ""
	local self_price = System_GetTempDataStr(_idCharacter,nLuaIdActivity) or ""
	
	System_PaiMaiSyn(_idCharacter,activityid,cur_price,self_price,System_StrCatOnTable(tCurCharacter,","))
end

function PaiMai_Syn_CrossServer(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local activeid = _nData8
	if activeid > nPaiMaiMaxDay then
		System_PaiMaiSyn(_idCharacter,0,"","","") 
		return
	end
	
	if activeid ~= System_GetTempData(_idCharacter,nLuaIdActivity,8) then
		System_SetTempData(_idCharacter,nLuaIdActivity,8,activeid)
		System_SetTempData(_idCharacter,nLuaIdActivity,7,0)
	end
	local parmCurCharacter ={_nData1,_nData2}
	local tCurCharacter = {}
	for i = 1,nPaiMaiIdCount do
		tCurCharacter[i] = parmCurCharacter[i]
	end
	
	local cur_price = _strData
	local self_price = System_GetTempDataStr(_idCharacter,nLuaIdActivity) or ""
	System_PaiMaiSyn(_idCharacter,activeid,cur_price,self_price,System_StrCatOnTable(tCurCharacter,","))
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.__PaiMai_SynInfo] = PaiMai_Syn_CrossServer

-- ================================================================================================================
--		弹窗提示 弹窗CD,1小时
-- ================================================================================================================
function PaiMai_Syn_Windows(_idCharacter)
	--不满足参与条件不弹窗
	if false == PaiMai_Login_CheckOpen(_idCharacter) then
		return
	end
	
	local tab_nCurTime = System_Split(os.date("%H:%M:%S",os.time()), ":")
	local nCurTime = System_getStringTime(tab_nCurTime,0,1)
	local sleepTIme = System_getStringTime(tab_nCurTime,-3600,1)
	local tipTime = tonumber(System_GetTempData(_idCharacter,nLuaIdActivity,7))
	if 0 == tipTime or sleepTIme >= tipTime or tipTime>nCurTime then
		if false == System_IsCrossSever() then
			local _tConfig = PaiMai_GetServerNumConfig()
			local _curPrices = System_GetGlobalDataStr(nLuaGlobal)
			local _rewardIds = {}
			for k,v in pairs(_tConfig.day[1].auction[1].reward) do
				_rewardIds[k] = v.id
			end
			System_PaiMaiSyn_Windows(_idCharacter,System_StrCatOnTable(_rewardIds,","),_curPrices)
		else
			System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.__PaiMai_Windows,nLuaGlobal)
		end
		System_SetTempData(_idCharacter,nLuaIdActivity,7,tonumber(nCurTime))
	end
end

function PaiMai_Syn_Windows_CrossServer(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local _tConfig = PaiMai_GetServerNumConfig()
	local _curPrices = _strData
	local _rewardIds = {}
	for k,v in pairs(_tConfig.day[1].auction[1].reward) do
		_rewardIds[k] = v.id
	end
	System_PaiMaiSyn_Windows(_idCharacter,System_StrCatOnTable(_rewardIds,","),_curPrices)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.__PaiMai_Windows] = PaiMai_Syn_Windows_CrossServer

-- ================================================================================================================
--		出价
-- ================================================================================================================
function PaiMai_OfferReq(_idCharacter,activeid,id,price,_tCurCharacter,_sCurPrice)
	local tConfig = PaiMai_GetServerNumConfig()
	if nil == next(tConfig )then
		return ePMC_Unknow
	end
	
	if activeid ~= System_GetTempData(_idCharacter,nLuaIdActivity,8) then
		return ePMC_Unknow
	end
	
	local tActivityConfig = {}
	local itemId = 0
	for k,v in pairs(tConfig.day[1].auction) do
		if activeid == v.activity then
			tActivityConfig = v
			itemId = v.reward[id].item
			break
		end
	end
	
	local starttime =  string.gsub(tConfig.day[1].opentime, ":", "")
	local tab_endtime = System_Split(tConfig.day[1].closetime, ":")
	local  endtime  =  System_getStringTime(tab_endtime,-1,1)
	local  nowtime  = os.date("%H%M%S",os.time())
	if tonumber(starttime) and tonumber(endtime) and tonumber(nowtime) then
		if tonumber(starttime) > tonumber(nowtime) or tonumber(nowtime) > tonumber(endtime) then
			return ePMC_OutTime
		end
	else
		return ePMC_OutTime
	end 
	--取这当前最高出价玩家
	local idCurCharacter = 0 
	if false == System_IsCrossSever() then
		idCurCharacter = System_GetGlobalData(nLuaGlobal,id)
		_sCurPrice = System_GetGlobalDataStr(nLuaGlobal)
	else
		if "table" == type(_tCurCharacter) then
			idCurCharacter = _tCurCharacter[id] or idCurCharacter
		end		
	end
	
	if idCurCharacter == _idCharacter then
		return ePMC_Self
	end	
	
	
	local tCurPrice = System_Split(_sCurPrice,",")
	if nil ~= tonumber(tCurPrice[id]) then
		if tonumber(tCurPrice[id]) >= price then
			return ePMC_PriceLess
		end		
	end

	if false == System_SpendEmoney(_idCharacter,price,nflowactionEmoney) then
		return  ePMC_EmoneyLess
	end
	
	--返还前一位的拍卖元宝
	if  tCurPrice[id] ~= nil and tCurPrice[id] - 0 > 0 and idCurCharacter ~= 0 then
		PaiMai_BackEmoney(idCurCharacter,tCurPrice[id],tConfig.day[1].losemail,itemId,_idCharacter)
	end
	System_PaiMaiLogOfferInfo(_idCharacter,tCurPrice[id], price, 0)
	
	tCurPrice[id] = price
	local tSelfPrice = System_Split(System_GetTempDataStr(_idCharacter,nLuaIdActivity),",")
	tSelfPrice[id] = price
	
	if System_IsCrossSever() then
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.__PaiMai_Offer,nLuaIdActivity,id,_idCharacter,"")		
	else
		System_SetGlobalData(nLuaGlobal,id,_idCharacter)
	end
	for i = 1,nPaiMaiIdCount do
		tCurPrice[i] = tCurPrice[i] or 0
	end
	
	if System_IsCrossSever() then
		System_SetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.__PaiMai_Offer,nLuaIdActivity,0,0,System_StrCatOnTable(tCurPrice,","))		
	else
		System_SetGlobalDataStr(nLuaGlobal,System_StrCatOnTable(tCurPrice,","))
	end	
	for i = 1,nPaiMaiIdCount do
		tSelfPrice[i] = tSelfPrice[i] or 0
	end
	System_SetTempDataStr(_idCharacter,nLuaIdActivity,System_StrCatOnTable(tSelfPrice,","))
	--记录出价没
	System_SetTempData(_idCharacter,nLuaIdActivity,id,price)
	
	System_CallLuaOnline("</F>PaiMai_Login</N>CHARACTER_ID",_idCharacter)
	--被别人竞拍需要弹窗提示
	System_CallLuaOnline("</F>PaiMai_Syn_Windows</N>CHARACTER_ID",_idCharacter)
	return ePMC_Success
end

function PaiMai_OfferReq_Cross(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local activeid = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local id = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	local price = System_GetTempData(_idCharacter,nLuaIdActivity,3)
	
	local parmCurCharacter ={_nData1,_nData2}
	local tCurCharacter = {}
	for i = 1,nPaiMaiIdCount do
		tCurCharacter[i] = parmCurCharacter[i]
	end

	local code = PaiMai_OfferReq(_idCharacter,activeid,id,price,tCurCharacter,_strData)
	System_PaiMaiOffer(_idCharacter,code,activeid,id,price)
	
	System_SetTempData(_idCharacter,nLuaIdActivity,1,0)
	System_SetTempData(_idCharacter,nLuaIdActivity,2,0)
	System_SetTempData(_idCharacter,nLuaIdActivity,3,0)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.__PaiMai_Offer] = PaiMai_OfferReq_Cross
-- ================================================================================================================
--		返还元宝
-- ================================================================================================================
function PaiMai_BackEmoney(_idCharacter,_nEmoney,_nMailId,nItemid,buy_idCharacter)
	System_SendMail_PaiMai(_idCharacter,_nMailId,"",0,_nEmoney,0,nItemid,buy_idCharacter)
	System_PaiMaiLogOfferInfo(_idCharacter,0, 0, _nEmoney)
end

-- ================================================================================================================
--		发奖
-- ================================================================================================================
function PaiMai_SendAward(_nOsTimes)
	local tConfig = PaiMai_GetServerNumConfig()
	if nil == next(PaiMai_GetServerNumConfig() )then
		L2C_DebugLog("::PaiMai_SendAward Error ")
		return 
	end
	-- System_SetGlobalDataStr(nLuaGlobal,"")	
	for i = 1,nPaiMaiIdCount do
		local idCurCharacter =  System_GetGlobalData(nLuaGlobal,i)		
		local nActive = System_GetGlobalData(nLuaGlobal,8)
		for k,v in pairs(tConfig.day[1].auction) do
			if nActive == v.activity then
				for l,w in pairs(v.reward) do		
					if i == w.id then
						if idCurCharacter == 0 then
							break
						end
						local nItem = "number" == type(w.item) and w.item or 0
						local nNum  = "number" == type(w.number) and w.number or 0
						local nBing = "number" == type(w.bind) and w.bind or 0
						local nTime2 = "number" == type(w.time2) and w.time2 or 0
						local nTime3 = "number" == type(w.time3) and w.time3 or 0
						
						nTime3 = System_timeModeTransfer(nTime2,nTime3)	
						local sItem = string.format("%d,%d,0,%d,%d,%d",nItem,nNum,nBing,nTime2,nTime3)
						System_PaiMaiLogGetItem(idCurCharacter,v.activity, w.id, nItem)
						-- System_SetGlobalData(nLuaGlobal,i,0)				
						System_SendMail_PaiMai(idCurCharacter,tConfig.day[1].winmail,sItem)
						break
					end
				end
				break
			end
		end		
	end
end

-- ================================================================================================================
--		活动结束触发 通知发奖内容
-- ================================================================================================================
function PaiMai_SendEndInfo(_idCharacter)	
	if false == System_IsCrossSever() then
		PaiMai_SendEndInfo_GameServer(_idCharacter)
	else
		System_GetGlobalDataCross(_idCharacter,eCrossGlobbalActionType.__PaiMai_EndInfo,nLuaGlobal)
	end
end

function PaiMai_SendEndInfo_GameServer(_idCharacter)
	local sPrice = System_GetGlobalDataStr(nLuaGlobal)
	local sName = ""
	for i = 1,nPaiMaiIdCount do
		local nCharacterID = System_GetGlobalData(nLuaGlobal,i)
		if nCharacterID ~= 0 then
			sName = sName.. System_GetCharacterName(nCharacterID)
		else
			sName = sName.. ""
		end
		if i ~= nPaiMaiIdCount then
			sName =sName .. ","
		end
	end
	System_PaiMaiSendEndInfo(_idCharacter,sPrice,sName)
end

function PaiMai_SendEndInfo_CrossServer(_idCharacter,_nAction,_nGlobalId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_strData)
	local sPrice = _strData
	
	local parmCurCharacter ={_nData1,_nData2}
	local tCurCharacter = {}
	for i = 1,nPaiMaiIdCount do
		tCurCharacter[i] = parmCurCharacter[i]
	end

	local sName = ""
	for i = 1,nPaiMaiIdCount do
		local nCharacterID = tCurCharacter[i]
		if nCharacterID ~= 0 then
			sName = sName.. System_GetCharacterName(nCharacterID)
		else
			sName = sName.. ""
		end
		if i ~= nPaiMaiIdCount then
			sName =sName .. ","
		end
	end
	
	local self_price = System_GetTempDataStr(_idCharacter,nLuaIdActivity) or ""
	System_PaiMaiSendEndInfo(_idCharacter,sPrice,sName)
end
tGlobalDataQueryTrigeer[eCrossGlobbalActionType.__PaiMai_EndInfo] = PaiMai_SendEndInfo_CrossServer
-- ================================================================================================================
--		活动结束触发 用于发奖 
-- ================================================================================================================
function PaiMai_ActiveEnd(_nOsTimes)
	System_CallLuaOnline("</F>PaiMai_SendEndInfo</N>CHARACTER_ID")
	PaiMai_SendAward(_nOsTimes)
end

-- ================================================================================================================
--		每日增加活动结束监听
-- ================================================================================================================
function PaiMai_AddActiveEndTrigger(_nOsTimes)
	local tConfig = PaiMai_GetServerNumConfig()
	if nil == next(tConfig )then
		return 
	end

	local nOpenDay = System_GetOpenServerDay()
	local isAllEnd = true
	for k,v in pairs(tConfig.day[1].auction) do
		if v.activity == nOpenDay then
			isAllEnd = false
			System_SetGlobalDataStr(nLuaGlobal,"")	
			local tBasePrice = {}
			for l,w in pairs(v.reward) do
				if w.id <= nPaiMaiIdCount then
					tBasePrice[w.id] = w.baseprice
				end
			end
			for i= 1,nPaiMaiIdCount do
				tBasePrice[i] = tBasePrice[i] or 0
				System_SetGlobalData(nLuaGlobal,i,0)	
			end
			System_SetGlobalData(nLuaGlobal,8,v.activity)
			System_SetGlobalDataStr(nLuaGlobal,System_StrCatOnTable(tBasePrice,","))
			break
		end
	end	
	if true == isAllEnd then
		System_SetGlobalData(nLuaGlobal,8,0)
		System_SetGlobalDataStr(nLuaGlobal,"")	
	end
	System_CallLuaOnline("</F>PaiMai_Login</N>CHARACTER_ID")
	PaiMai_AddActiveStart()--零点增加弹窗定时器
end
tTime_HM[0000] = tTime_HM[0000] or {}
table.insert(tTime_HM[0000],PaiMai_AddActiveEndTrigger)

-- ================================================================================================================
--		 开服务器时如果在活动期间 增加监听
-- ================================================================================================================
function PaiMai_AddActiveEndTrigger_InOpen(_nOsTimes)
	-- 跨服就不发奖了
	if System_IsCrossSever() then
		return 
	end

	_nOsTimes = _nOsTimes or os.time()
	local tConfig = PaiMai_GetServerNumConfig()
	if nil == next(tConfig )then
		return 
	end
	
	
	local nDayEndTime = string.gsub(tConfig.day[1].closetime, ":", "")
	local nCurTime = os.date("%H%M%S",_nOsTimes)
	-- 不需要时间判断 这个监听都要加  不然第二天也没有
	-- if tonumber(nDayEndTime) > tonumber(nCurTime) then
		nDayEndTime = math.modf(nDayEndTime/100)
		tTime_HM[nDayEndTime] = tTime_HM[nDayEndTime] or {}
		table.insert(tTime_HM[nDayEndTime],PaiMai_ActiveEnd)
	-- end
end

-- ================================================================================================================
--		在线玩家弹窗提示
-- ================================================================================================================
function PaiMai_PushWindows(_nOsTimes)
	System_CallLuaOnline("</F>PaiMai_Syn_Windows</N>CHARACTER_ID")
end

-- ================================================================================================================
--		每日增加活动开始监听,刚开始的时候手动添加,之后每日零点更新下
-- ================================================================================================================
function PaiMai_AddActiveStart()
	local tConfig = PaiMai_GetServerNumConfig()
	if nil == tConfig then
		return
	end
	
	local pushTime = System_Split(tConfig.day[1].push,",")
	for k,v in ipairs(pushTime) do
		v = string.gsub(v, ":", "")
		v = System_Split(v,"|")
		for key,value in pairs(v) do
			value = math.modf(value/100)
			tTime_HM[value] = tTime_HM[value] or {}
			table.insert(tTime_HM[value],PaiMai_PushWindows)
		end
	end
end

-- ================================================================================================================
--		获得本次活动最大开启天数
-- ================================================================================================================
function PaiMai_GetMaxDay()
	if -1 == nPaiMaiMaxDay then
	
		local tConfig = PaiMai_GetServerNumConfig()
		if nil == tConfig then
			nPaiMaiMaxDay = 0
			return
		end
	
		for k,v in pairs(tConfig.day[1].auction) do
			if v.activity > nPaiMaiMaxDay then
				nPaiMaiMaxDay = v.activity
			end
		end	
		
		if -1 == nPaiMaiMaxDay then
			nPaiMaiMaxDay = 0
		end
	end
	
end






