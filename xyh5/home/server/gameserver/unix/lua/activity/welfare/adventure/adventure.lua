-- local eAdventureMapRetCode =
-- {
local	eAMRC_Unknow = 0			--//未知错误
local	eAMRC_Success = 1			--//成功
local	eAMRC_NotInActiveTime = 2	--//现在不在活动时间
local	eAMRC_LevelLess = 3		--//参与活动需要等级大于%级
local	eAMRC_HasAccepted = 4		--//请先完成身上的寻宝任务
local	eAMRC_CoolDown = 5			--//您操作太快了，请%秒后再试
local	eAMRC_NoMoney = 6		--银两不够
local	eAMRC_NoEMoney = 7		--元宝不够
local	eAMRC_NoItem = 8		--物品不够
local	eAMRC_VipLess = 9		--Vip 等级不足
local	eAMRC_HasReward = 10		-- 已经领取过奖励了
local	eAMRC_BagNotEnough = 11	--背包空间不足
local	eAMRC_HasGetMap = 12	--今天已经接过宝图任务了
local	eAMRC_PosError = 13	--不在挖宝点
local	eAMRC_TimesOut = 14	--剩余次数不足
-- };

--local eAdventureMapLuaType =
-- {
local	eAMLT_SynInfo = 1
local	eAMLT_GetMap = 2
local	eAMLT_GiveUp = 3
local	eAMLT_RandomEvent = 4
local	eAMLT_Dig = 5
local	eAMLT_Dialog = 6
local	eAMLT_Reward = 7
local	eAMLT_Broadcast = 8
local	eAMLT_Process = 9
local	eAMLT_DigBreak = 10 --// 挖宝中断
local	eAMLT_QuestList = 11 --,// 题目
local	eAMLT_Ansawer = 12 --,// 答题
local	eAMLT_Npc = 13 --,	//npc对话 交寻找任务
local	eAMLT_ActiveStatus = 14 --活动状态
local 	eAMLT_DigEnd = 15 --挖宝结束触发
local 	eAMLT_AnsawerRet = 16 --// 答题
local 	eAMLT_Complete = 17 -- //完成了一轮宝图
local	eAMLT_DirectGetSyn 	= 18 --	//直接领奖同步
local	eAMLT_DirectGetReq 	= 19 --	//直接领奖请求
local	eAMLT_TimeSyn 		= 20 --	//完成次数同步
local	eAMLT_HasMap		= 21 -- //是否有宝图
-- };

--挖宝路上 随机事件
local	eMidway_None = 1
local	eMidway_Buff = 2
local	eMidway_ToMap = 3 --传送到随机地图
local	eMidway_ToPos = 4 -- 传送到随机挖宝点
local	eMidway_GiveUp = 5 --放弃任务

--挖宝结束触发的事件
local	eDigEnd_Award = 1 	 --获得奖励
local	eDigEnd_Balance = 2	 --支线
local	eDigEnd_Anserwer = 3 --答题
local	eDigEnd_Transfer = 4 --传送
local	eDigEnd_GiveUp = 5	 --取消任务


--挖宝触发的支线类型
local	eBalance_Item = 1			-- 索要物品 
local	eBalance_Emoney = 2         -- 索要元宝
local	eBalance_Money = 3          -- 索要银两
local	eBalance_KillMonster = 4    -- 触发杀怪任务
local	eBalance_Copy = 5           -- 触发副本
local	eBalance_Npc = 6            -- 寻人
local	eBalance_Award = 7          -- 给奖励

--	Note:
--		活动掩码中:
--			data1 npcobj  领任务的npc
--			data2 领取任务的时间戳
--			data3 下次触发的随机事件的间隔 s  这个服务端自己存
--			data4 挖完宝图触发的事件
--			data5 挖完宝图触发的事件 的相关数据 brancetype 、questionid
--			data6 挖完宝图触发的事件 的相关数据 taskroom
--			data7 挖完宝图触发的事件 的相关数据 日常任务的id 
--			data8 挖完宝图触发的事件 的相关数据 日常任务的杀怪数量
--			datastr 宝图的坐标 scene,posx,posy  6002,1,1

local nResId = CRESOURCEFLOWACTION.eFT_AdventureMap			-- 资源流向id
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]			-- 活动掩码id
local nLuaIdActivity_Time = LUARESOURCEFLOWACTION[CRESOURCEFLOWACTION.eFT_AdventureMap_Time]		-- 活动掩码id 完成次数用

local nFunctionId = _adventure_Info["Root"][1]["functionid"][1]["functionid"]
local tAdventureInfo =   _adventure_Info["Root"][1]["adventure"][1]

--处理一下任务数据
local tLevelTaskRoom = {}
for k,v in pairs(tAdventureInfo.player) do
	for i = v.minLev,v.maxLev do
		if tLevelTaskRoom[i] ~= nil then
			L2C_DebugLog(string.format("Adventure Data Init :: LevelTaskRoom :: Wrong Level[%s]",i))
			return
		end
		tLevelTaskRoom[i] =  v.taskroom
	end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_Login(_idCharacter,_nOsTimes)
	-- Adventure_SendActiveStatus(_idCharacter,_nOsTimes)
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then	
		System_AddTempData(_idCharacter,nLuaIdActivity,false)						
	end
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity_Time) then
		System_AddTempData(_idCharacter,nLuaIdActivity_Time,false)		
	end
	Adventure_Syn_MapInfo(_idCharacter)
	
	--这里要处理下未完成信息的同步
	local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	if (nEvent > 0 )then
		-- System_Syn_AdventureMapMessage(_idCharacter,eAMLT_DigEnd,nEvent)
		local tBalance = tAdventureInfo.balance[1].event
		if "table" ~= type(tBalance[nEvent]) then
			return
		end
		--答题就发题目
		if (eDigEnd_Anserwer == tBalance[nEvent]["type"]) then
			Adventure_processQuestListReq(_idCharacter)
		end
		if (eDigEnd_Balance == tBalance[nEvent]["type"]) then
			-- L2C_DebugLog("Adventure_Login"..tostring(tBalance[nEvent]["type"]))
			local nBrance = System_GetTempData(_idCharacter,nLuaIdActivity,5)
			if "table" == type(tBalance[nEvent].brance[nBrance]) then			
				local tBrance = tBalance[nEvent].brance[nBrance]
				-- L2C_DebugLog("Adventure_Login  tBrance.brancetype"..tostring(tBrance.brancetype))
				--杀怪数据的同步
				if tBrance.brancetype == eBalance_KillMonster then					
					local nRoomId = System_GetTempData(_idCharacter,nLuaIdActivity,6)
					local nTaskId = System_GetTempData(_idCharacter,nLuaIdActivity,7)
					local nNowNum = System_GetTempData(_idCharacter,nLuaIdActivity,8)					
		
					System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Process,nTaskId,nRoomId,nNowNum)
				end
			end
		end
	end
end
table.insert(tOnLoginActivity,Adventure_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	同步玩家身上的宝图信息
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_Syn_MapInfo(_idCharacter)
    local strPos = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	local npcobj = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	if nTime < 0 then nTime = 0 end
	 local tPos = System_Split( strPos,"," )	 
	 local scene,posx,posy = tonumber(tPos[1]),tonumber(tPos[2]),tonumber(tPos[3])
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_SynInfo,scene,0,0,npcobj,nTime,"","",posx,posy)
	
	local nComTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Time,1)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_TimeSyn,nComTimes)
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--发送活动状态给客户端
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_SendActiveStatus(_idCharacter,_nOsTimes)
	if true ==  Adventure_CheckActiveOpen(_idCharacter,_nOsTimes) then
		--local nOpenday = System_GetOpenServerDay()	
		--local status = 1
		--local nEnd = 0
        --
		--local tData = os.date("*t",_nOsTimes)
		--tData["hour"] = 0
		--tData["min"] = 0
		--tData["sec"] = 0
		----先写当天结束
		--nEnd = os.time(tData) + 24 * 3600		
		--System_SendActiveStatus(_idCharacter,nResId,status,0,nEnd);
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_ActiveStatus,1) 
	else
		-- System_SendActiveStatus(_idCharacter,nResId,0,0,0);
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_ActiveStatus,0) 
	end
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 检测活动是否开启
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_CheckActiveOpen(_idCharacter,_nOsTimes)
	-- L2C_DebugLog(string.format("System_OpenGuideFunction(_idCharacter[%s],nFunctionId[%s])  ret[%s]",_idCharacter,nFunctionId,System_OpenGuideFunction(_idCharacter,nFunctionId)))
	if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then
		return false
	end
	
	-- _nOsTimes = _nOsTimes or os.time()
	-- local nClock = tonumber(os.date("%H%M%S",_nOsTimes))
	-- local nBegin = tonumber(tostring(string.gsub(tAdventureInfo.beginTime, ":", "")))
	-- local nEnd   = tonumber(tostring(string.gsub(tAdventureInfo.endTime, ":", "")))
	-- if nClock >= nBegin and nClock <  nEnd then
		-- return true
	-- else
		-- return false
	-- end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 服务端各消息入口
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processAwardReqMain(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	if eAMLT_GetMap == _nData1 then
		return Adventure_processGetMapReq(_idCharacter,_nData1,_nData2)
	end
	if eAMLT_GiveUp == _nData1 then
		return Adventure_processGiveUpReq(_idCharacter)
	end
	if eAMLT_Dig == _nData1 then
		return Adventure_processDigReq(_idCharacter,_nData1,_nData2)
	end
	
	if eAMLT_DigEnd == _nData1 then
		return Adventure_processDigEndReq(_idCharacter,_nData1,_nData2)
	end
	
	if eAMLT_Ansawer == _nData1 then
		return Adventure_processAnswerReq(_idCharacter,_nData1,_nData2)
	end
	
	if eAMLT_DigBreak == _nData1 then
		return Adventure_processDigBreakReq(_idCharacter,_nData1,_nData2)
	end
	
	if eAMLT_Dialog == _nData1 then
		return Adventure_processDialogReq(_idCharacter,_nData1,_nData2)
	end
	
	if eAMLT_Npc == _nData1 then
		return Adventure_processNpcReq(_idCharacter,_nData1,_nData2)
	end
	
	return eAMRC_Unknow
end
tOnOnAcitveAward[nResId] = Adventure_processAwardReqMain
-- ////////////////领取宝图////////////////
function Adventure_processGetMapReq(_idCharacter,_nData1,_nData2)
	if false == Adventure_CheckActiveOpen(_idCharacter) then
		return eAMRC_NotInActiveTime
	end
	if true == Adventure_DirctGet_Is_GetAward(_idCharacter) then
		return eAMRC_HasReward
	end
	
	local strPos = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	if strPos ~= nil and strPos ~= "" then
		return eAMRC_HasAccepted
	end
	local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	if tAdventureInfo.cdTime + nTime > os.time() then
		return eAMRC_CoolDown
	end
	
	local nComTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Time,1)
	if nComTimes >= tAdventureInfo.change then
		return eAMRC_TimesOut
	end
	
	local strPos = Adventure_RandomMapPoint(_idCharacter)
	System_SetTempDataStr(_idCharacter,nLuaIdActivity,strPos,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,1,_nData2,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,2,os.time(),false)	
	Adventure_Syn_MapInfo(_idCharacter)
	
	Adventure_DirctGet_Set_Status(_idCharacter,2)
	return eAMRC_Success
end
-- //////////////随机宝图坐标////////////////
function Adventure_RandomMapPoint(_idCharacter)	
	local nLevel =  System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	local strScene = ""
	for k,v in pairs (tAdventureInfo.map) do
		if nLevel >= v.minlev and nLevel <= v.uplev then
			strScene = tostring(v.scene)
			break
		end		
	end

	local tScene = System_Split(strScene,",")
	local nRanScene = tScene[math.random(#tScene)]
	if nRanScene == nil then
		L2C_DebugLog(string.format("Adventure_RandomMapPoint :: Wrong Position[%s]",strScene))
		return ""
	end
	local sPos = nRanScene ..","
	for k,v in pairs (tAdventureInfo.position) do
		if tostring(nRanScene) == tostring(v.scene) then
			sPos = sPos .. v["random"][math.random(#v["random"])].position
			break
		end
	end
	return sPos
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 放弃宝图
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processGiveUpReq(_idCharacter)
	--不在活动时间可以放弃任务
	--if false == Adventure_CheckActiveOpen(_idCharacter) then
	--	return eAMRC_NotInActiveTime
	--end	
	--有宝图任务才放弃
	if "" ~= System_GetTempDataStr(_idCharacter,nLuaIdActivity) then
		local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
		System_SetAllTempData(_idCharacter,nLuaIdActivity,0,nTime,0,0,0,0,0,0,"")	
		local nComTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Time,1)
		System_SetTempData(_idCharacter,nLuaIdActivity_Time,1,nComTimes + 1)
		Adventure_Syn_MapInfo(_idCharacter)
	end
	return eAMRC_Success
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	找lua要数据 要随机事件的触发时间
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_RandomEvent_GetData(_idCharacter,_nCActionType,_GetDateType,_nData4,_nData5)
	if	_nCActionType ~= nResId then
		return -1
	end
	if _GetDateType == eAMLT_RandomEvent  then
		--取随机时间
		if _nData4 == 1 then
			--取剩余时间
			local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,3)
			--这次寻宝的已经触发过了
			if nTime == 999999 then
				return 0
			end
			--没触发过
			if nTime == 0 then
				local nMin = tAdventureInfo.midway[1].mintime
				local nMax = tAdventureInfo.midway[1].maxtime
				System_SetTempData(_idCharacter,nLuaIdActivity,3,999999)
				return math.random(nMin,nMax)				
			end
			--上次的时间没用完
			if nTime > 0 then
				System_SetTempData(_idCharacter,nLuaIdActivity,3,999999)
				return nTime
			end
			
		end
		--取随机的事件索引
		if _nData4 == 2 then
			local tMidEvent = tAdventureInfo.midway[1].midevent
			local nRan = 1
			local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
			local str = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
			if (nEvent >= 0 )and (str ~= "")then

				-- nRan = math.random(#tMidEvent)		
				local tMidwayInfo =  tAdventureInfo.midway[1].midevent
				local nAllWeight = 0
				for k,v in pairs(tMidwayInfo) do
					if v.weight == "" then
						v.weight = 0
					end
					nAllWeight = v.weight + nAllWeight
				end
	
				local nRandom = math.random(nAllWeight)
				-- L2C_DebugLog("nRandom"..nRandom)
				for k,v in pairs(tMidwayInfo) do
					if nRandom > v.weight then
						nRandom = nRandom - v.weight
					else		
						nRan = k
						break
					end
				end
			end
			--1 是无事件  就不返回了
			Adventure_RandomEvent_Work(_idCharacter,nRan)			
			return nRan
		end	
	end
	--取采集时间
	if _GetDateType == eAMLT_Dig then
		if "number" == type(tAdventureInfo.balance[1].keeptime)  then
			return tAdventureInfo.balance[1].keeptime
		end
	end
	--	取身上是否有宝图任务
	if _GetDateType == eAMLT_HasMap then
	    local strPos = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
		local tPos = System_Split( strPos,"," )	 
		local scene,posx,posy = tonumber(tPos[1]),tonumber(tPos[2]),tonumber(tPos[3])
		if "number" == type(scene) and 0 < scene then
			return 1
		else
			return 0
		end
	end
	return -1
end
tGetActivityData[nResId] = Adventure_RandomEvent_GetData

-- //////////////同步玩家触发的随机事件////////////////
function Adventure_Syn_RandomEvent(_idCharacter,_nIndex)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_RandomEvent,_nIndex)
end

function Adventure_RandomEvent_Work(_idCharacter,_nRandom)
	local tMidEvent = tAdventureInfo.midway[1].midevent
	if eMidway_Buff == tMidEvent[_nRandom]["type"] then
		System_AddBuff(_idCharacter,tMidEvent[_nRandom]["buff"])
	end
	if eMidway_ToMap == tMidEvent[_nRandom]["type"] then
	    local strPos = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
		local tPos = System_Split( strPos,"," )	 
		local scene = tonumber(tPos[1])
		local strInitPos = "0,0"
		for k,v in pairs (tAdventureInfo.position)  do
			if v.scene == scene then
				strInitPos = v.pos
			end
		end
		local tInitPos = System_Split(strInitPos,",") 
		local nInitX,nInitY = tonumber(tInitPos[1]),tonumber(tInitPos[2])
		System_TransferCharacter(_idCharacter,scene,nInitX,nInitY )
	end
	if eMidway_ToPos == tMidEvent[_nRandom]["type"] then
		local scene = tMidEvent[_nRandom]["scene"]
		local strInitPos = tMidEvent[_nRandom]["Position"]
		local tPos = System_Split(strInitPos,",") 
		local nX,nY = tonumber(tPos[1]),tonumber(tPos[2])
		System_TransferCharacter(_idCharacter,scene,nX,nY )
	end
	if eMidway_GiveUp == tMidEvent[_nRandom]["type"] then
		Adventure_processGiveUpReq(_idCharacter)
	end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 挖宝图申请
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processDigReq(_idCharacter,_nData1)
	--这里检验坐标
	-- L2C_DebugLog("Adventure_processDigReq");
	local nRadii = tonumber(tAdventureInfo.radii)
	local nScene,fX,fY = System_GetCharacterPostion(_idCharacter)
	local strPos = System_GetTempDataStr(_idCharacter,nLuaIdActivity)
	local tPos = System_Split( strPos,"," )	 
	local scene,posx,posy = tonumber(tPos[1]),tonumber(tPos[2]),tonumber(tPos[3])
	
	if nScene ~= scene then
		return eAMRC_Unknow
	end
	if (fX - posx)*(fX - posx) + (fY - posy)* (fY - posy) > nRadii*nRadii then
		return eAMRC_PosError
	end	
	return eAMRC_Success
end


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 挖宝图结束
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processDigEndReq(_idCharacter,_nData1)
	-- if false == Adventure_CheckActiveOpen(_idCharacter) then
		-- return eAMRC_NotInActiveTime
	-- end
	--这里不判断活动时间 只判断功能是否解锁
	if  0 ~= System_OpenGuideFunction(_idCharacter,nFunctionId) then
		return eAMRC_LevelLess
	end
	if "" == System_GetTempDataStr(_idCharacter,nLuaIdActivity) then
		return eAMRC_Unknow
	end
	local tBalance = tAdventureInfo.balance[1].event
	local nRan = math.random(1,#tBalance)
	--这个要早权重
	local nAllWeight = 0
	for k,v in pairs(tBalance) do
		if v.weight == "" then
			v.weight = 0
		end
		nAllWeight = v.weight + nAllWeight
	end
	
	local nRandom = math.random(nAllWeight)
	-- L2C_DebugLog("nRandom"..nRandom)
	for k,v in pairs(tBalance) do
		if nRandom > v.weight then
			nRandom = nRandom - v.weight
		else		
			nRan = k
			break
		end
	end
	
	-- L2C_DebugLog("System_GetTempData(_idCharacter,nLuaIdActivity,4)"..System_GetTempData(_idCharacter,nLuaIdActivity,4))
	--如果已经传送过 直接给奖励	
	local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	if nEvent > 0 then
		if(tBalance[nRan]["type"] == eDigEnd_Transfer) and (eDigEnd_Transfer == tBalance[nEvent]["type"]) then
			Adventure_GetReaward(_idCharacter)
			return eAMRC_Success
		end
	end
	
	System_SetTempData(_idCharacter,nLuaIdActivity,4,nRan,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,5,0,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,6,0,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,7,0,false)
	--记得保存这个状态
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_DigEnd,nRan)
	
	--触发支线
	-- if(tBalance[nRan]["type"] == eDigEnd_Balance) then
		
	-- end
	
	--触发答题
	if(tBalance[nRan]["type"] == eDigEnd_Anserwer) then
		Adventure_processQuestListReq(_idCharacter)
	end
	if(tBalance[nRan]["type"] == eDigEnd_Award) then
		Adventure_GetReaward(_idCharacter)
	end
	if(tBalance[nRan]["type"] == eDigEnd_GiveUp) then
		Adventure_GetReaward(_idCharacter)
	end
	if(tBalance[nRan]["type"] == eDigEnd_Transfer) then
		local strPos = Adventure_RandomMapPoint(_idCharacter)
		local tPos = System_Split(strPos,",") 
		local scene,nX,nY = tonumber(tPos[1]),tonumber(tPos[2]),tonumber(tPos[3])
		System_TransferCharacter(_idCharacter,scene,nX,nY )
	end
	
	--记录已触发的活动
	return eAMRC_Success
end

-- //////////////同步玩家挖宝触发的事件////////////////
function Adventure_Syn_DigRandomEvent(_nIndex)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_DigEnd,eAMRC_Success,_nIndex)
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  对话支线
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processDialogReq(_idCharacter,_nData1,_nData2)
	local tBalance = tAdventureInfo.balance[1].event
	local nBranceIndex = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	
	--保存支线信息
	System_SetTempData(_idCharacter,nLuaIdActivity,5,_nData2,false)
	
	local tBranceList = tBalance[nBranceIndex].brance[_nData2]
	-- L2C_DebugLog(tostring(tBalance[nBranceIndex].brance[_nData2].brancetype ))
	--元宝处理
	if eBalance_Emoney == tBranceList.brancetype then
		local nSpendEmoney = ("number" == type(tBranceList.needemoney) and tBranceList.needemoney or 0)
		local nCode = eAMRC_Success
		if System_SpendEmoney(_idCharacter,nSpendEmoney,nResId) then
			Adventure_GetReaward(_idCharacter)
		else
			nCode = eAMRC_NoEMoney
		end
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Dialog,nCode,nBranceIndex,_nData2)
		return nCode
	end
	--银两处理
	if eBalance_Money == tBranceList.brancetype then
		local nSpendMoney = ("number" == type(tBranceList.needmoney) and tBranceList.needmoney or 0)
		local nCode = eAMRC_Success
		if System_SpendMoney(_idCharacter,nSpendMoney,nResId) then
			Adventure_GetReaward(_idCharacter)
		else
			nCode = eAMRC_NoMoney
		end
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Dialog,nCode,nBranceIndex,_nData2)
		return nCode
	end	
	if eBalance_Item == tBranceList.brancetype then
		local nNeedItem = ("number" ==  type(tBranceList.needitem) and tBranceList.needitem or 0)
		local nNeedNum = ("number" ==  type(tBranceList.neednum) and tBranceList.neednum or 0)
		
		local nCode = eAMRC_Success
		if System_ConsumeThingOnCharacterBag(_idCharacter,nResId,nNeedItem,nNeedNum) then
			Adventure_GetReaward(_idCharacter)
		else
			nCode = eAMRC_NoItem
		end
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Dialog,nCode,nBranceIndex,_nData2)
		return nCode
	end
	if eBalance_KillMonster == tBranceList.brancetype then
		Adventure_KillMonster(_idCharacter,_nData1,_nData2)
	end
	
	if eBalance_Award == tBranceList.brancetype then
		Adventure_GetReaward(_idCharacter)
	end
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Dialog,eAMRC_Success,nBranceIndex,_nData2)
	return eAMRC_Success
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  领取奖励  _isRealRewar是不是真给奖励  例如答题错就不给奖励了
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_GetReaward(_idCharacter,_isRealRewar)	
	_isRealRewar = _isRealRewar ~= false
	
	local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	local nBrance = System_GetTempData(_idCharacter,nLuaIdActivity,5)
	local tBalance = tAdventureInfo.balance[1].event
	if tBalance[nEvent]["type"] == eDigEnd_Award
		or tBalance[nEvent]["type"] == eDigEnd_Anserwer
		or tBalance[nEvent]["type"] == eDigEnd_Transfer
	then
		
		if _isRealRewar == false then
			Adventure_GetReaward_Work(_idCharacter,tBalance[nEvent].reward,0)
		else
			Adventure_GetReaward_Work(_idCharacter,tBalance[nEvent].reward,tBalance[nEvent].rewardnum)
		end
	end
	if tBalance[nEvent]["type"] == eDigEnd_Balance then

		Adventure_GetReaward_Work(_idCharacter,tBalance[nEvent].brance[nBrance].reward,tBalance[nEvent].brance[nBrance].rewardnum)
	end
	if tBalance[nEvent]["type"] == eDigEnd_GiveUp then
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Reward,eAMRC_Success,0,nEvent,nBrance,0,"")
	end
	
	-- 告诉客户段 任务完成了
	--给奖励发了 这里就不发了
	-- System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Complete,nEvent,nBrance)
	
	local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	System_SetAllTempData(_idCharacter,nLuaIdActivity,0,nTime,0,0,0,0,0,0,"")
	local nComTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Time,1)
	System_SetTempData(_idCharacter,nLuaIdActivity_Time,1,nComTimes + 1)
	Adventure_Syn_MapInfo(_idCharacter)	
	
end
--给奖励的逻辑
function Adventure_GetReaward_Work(_idCharacter,_nReward,_nNum)
		--//给奖励
	local rewardKey = 0 
	for i,v in pairs(tAdventureInfo.reward[1].jackpot)do
		if _nReward == v.reward then
			rewardKey = i
			break
		end
	end
	local tItem = Adventure_RandomAward(rewardKey,_nNum or 0)
	local sItem = ""
	for k,v in pairs(tItem)do	
		sItem = sItem .. v
		if k ~= #tItem then
			sItem = sItem .. ","
		end
	end

	local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	local nBrance = System_GetTempData(_idCharacter,nLuaIdActivity,5)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Reward,eAMRC_Success,_nReward,nEvent,nBrance,0,sItem)
	
	
	local tBroadcastItem = {} --广播的物品表
	local tAwardInfo = tAdventureInfo.reward[1].jackpot[ rewardKey ].info
	for k,v in pairs(tItem) do
		if false == System_AwardThingInBag(_idCharacter,ACTIONTYPE.PLOTQUEST, tAwardInfo[v].itemid, tAwardInfo[v].num ,0) then
			System_AwardThingQuestContainer(_idCharacter,ACTIONTYPE.PLOTQUEST,tAwardInfo[v].itemid, tAwardInfo[v].num ,0)
		end			
		if tAwardInfo[v].record == 1 then
			table.insert(tBroadcastItem,v)			
		end
	end
	local sBroadcastItem = ""
	for k,v in pairs(tBroadcastItem)do	
		sBroadcastItem = sBroadcastItem .. v
		if k ~= #tBroadcastItem then
			sBroadcastItem = sBroadcastItem .. ","
		end
	end
	if sBroadcastItem ~= "" then
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Broadcast,_nReward,0,0,0,0,sBroadcastItem);
	end
end

--随机奖励
function Adventure_RandomAward(_nRawardKey,_nNum)
	local tResult = {}
	local tRewardInfo =  tAdventureInfo.reward[1].jackpot[ _nRawardKey ].info	
	if "table" ~= type(tRewardInfo) then
		return {}
	end
	local nAllWeight = 0
	for k,v in pairs(tRewardInfo) do
		if v.weight == "" then
			v.weight = 0
		end
		nAllWeight = v.weight + nAllWeight
	end
	
	for i = 1, _nNum do
		local nRan = math.random(nAllWeight)		
		for k,v in pairs(tRewardInfo) do
			if nRan > v.weight then
				nRan = nRan - v.weight
			else		
				table.insert(tResult,k)
				break
			end
		end
	end
	return tResult
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  任务数据下发
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_KillMonster(_idCharacter,_nData1,_nData2)	

	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	-- L2C_DebugLog(string.format("nLevel[%s]",nLevel))
	if tLevelTaskRoom[nLevel] == nil then
		return eAMRC_Unknow
	end
	local nRoomId = tLevelTaskRoom[nLevel]
	local tTaskList = tAdventureInfo.taskroom[nRoomId].task
	local nTaskKey = math.random(#tTaskList)
	
	-- L2C_DebugLog(string.format("nRoomId[%s]nTaskKey[%s]",nRoomId,nTaskKey))
	System_SetTempData(_idCharacter,nLuaIdActivity,5,_nData2,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,6,nRoomId,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,7,tTaskList[nTaskKey].taskId,false)
	System_SetTempData(_idCharacter,nLuaIdActivity,8,0,false)
	
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Process,tTaskList[nTaskKey].taskId,nRoomId,0)
	
	--要帮玩家传送至任务点
	local tPos = System_Split(tTaskList[nTaskKey].point,",")
	System_TransferCharacter(_idCharacter,tonumber(tTaskList[nTaskKey].scene),tonumber(tPos[1]),tonumber(tPos[2]))
	
	
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--  杀怪计数
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_KillMonster_Process(_idCharacter,_nMonsterId,_nNum)
	-- L2C_DebugLog(string.format("_nMonsterId[%s]_nNum[%s]",_nMonsterId,_nNum))
	local nRoomId = System_GetTempData(_idCharacter,nLuaIdActivity,6)
	if "table" ~= type(tAdventureInfo.taskroom[nRoomId]) then
		return
	end
	local tTaskInfo = tAdventureInfo.taskroom[nRoomId].task
	local nTaskId = System_GetTempData(_idCharacter,nLuaIdActivity,7)
	local nNowNum = System_GetTempData(_idCharacter,nLuaIdActivity,8)
	for k,v in pairs(tTaskInfo)do
		if nTaskId == v.taskId and _nMonsterId == v.monsterId then
			if nNowNum + _nNum >= v.num then
				local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
				local nBrance = System_GetTempData(_idCharacter,nLuaIdActivity,5)
				local tEvent = tAdventureInfo.balance[1].event[nEvent]				
				
				--先同步给客户端满数量
				System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Process,nTaskId,nRoomId,v.num)
				
				Adventure_GetReaward(_idCharacter)
				
			else
				System_SetTempData(_idCharacter,nLuaIdActivity,8,nNowNum + _nNum)
				System_Syn_AdventureMapMessage(_idCharacter,eAMLT_Process,nTaskId,nRoomId,nNowNum + _nNum)
			end
			break			
		end
	end
end
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--   题目申请
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processQuestListReq(_idCharacter)
	local nQuestionIndex =  math.random(#tAdventureInfo.question)	
	local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	
	System_SetTempData(_idCharacter,nLuaIdActivity,5,nQuestionIndex,false)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_QuestList,nEvent,nQuestionIndex,0,0,0,Adventure_RandomQuestList())
end

local tQuestRanList = {
"1,2,3,4","1,2,4,3","1,3,2,4","1,3,4,2","1,4,2,3","1,4,3,2",
"2,1,3,4","2,1,4,3","2,3,1,4","2,3,4,1","2,4,1,3","2,4,3,1",
"3,1,2,4","3,1,4,2","3,2,1,4","3,2,4,1","3,4,1,2","3,4,2,1",
"4,1,2,3","4,1,3,2","4,2,1,3","4,2,3,1","4,3,1,2","4,3,2,1",
}
function Adventure_RandomQuestList()
	local nRan = math.random(#tQuestRanList)
	return tQuestRanList[nRan]
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--   答题申请-- _nData2 答案index
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processAnswerReq(_idCharacter,_nData1,_nData2)
	local nEvent = System_GetTempData(_idCharacter,nLuaIdActivity,4)
	local nQuestionIndex = System_GetTempData(_idCharacter,nLuaIdActivity,5)
	
	if tAdventureInfo.question[nQuestionIndex].key == _nData2 then
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_AnsawerRet,eAMRC_Success,nEvent)
		Adventure_GetReaward(_idCharacter)		
		return eAMRC_Success
	else
		System_Syn_AdventureMapMessage(_idCharacter,eAMLT_AnsawerRet,eAMRC_Unknow,nEvent)
		Adventure_GetReaward(_idCharacter,false)
		return eAMRC_Unknow
	end
end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--   挖宝中断回包
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_processDigBreakReq(_idCharacter,_nData1,_nData2)
	return eAMRC_Success
end

function Adventure_processNpcReq(_idCharacter,_nData1,_nData2)
	Adventure_GetReaward(_idCharacter)
	return eAMRC_Success
end

-- local nBeginTime = math.ceil(tonumber(tostring(string.gsub(tAdventureInfo.beginTime, ":", "")))/100)
-- local nEndTime   = math.ceil(tonumber(tostring(string.gsub(tAdventureInfo.endTime, ":", "")))/100)
-- local nDelTime =  math.ceil(tonumber(tostring(string.gsub(tAdventureInfo.delTime, ":", "")))/100)
-- function Adventure_ActiveTimeCheck(nCurHour,nCurMin,nCurYear,nCurMon,nCurDay)
	-- System_CallLuaOnline("</F>Adventure_SendActiveStatus</N>%s")
-- end
-- tTime_HM[nBeginTime] = tTime_HM[nBeginTime] or {}
-- table.insert(tTime_HM[nBeginTime],Adventure_ActiveTimeCheck)
-- tTime_HM[nEndTime] = tTime_HM[nEndTime] or {}
-- table.insert(tTime_HM[nEndTime],Adventure_ActiveTimeCheck)

-- function Adventure_ActiveTimeDel(nCurHour,nCurMin,nCurYear,nCurMon,nCurDay)
	-- System_CallLuaOnline("</F>Adventure_processGiveUpReq</N>%s")
-- end
-- tTime_HM[nDelTime] = tTime_HM[nDelTime] or {}
-- table.insert(tTime_HM[nDelTime],Adventure_ActiveTimeDel)

--等级解锁功能时触发
-- tGuideFunctionTrigeer[nFunctionId] = function(_idCharacter)
	-- Adventure_SendActiveStatus(_idCharacter)
-- end

--今日是否做过宝图
function Adventure_IsDoToday(_idCharacter)
	local nTime = System_GetTempData(_idCharacter,nLuaIdActivity,2)
	if os.date("%y%m%d",nTime) == os.date("%y%m%d",os.time()) then
		return true
	else
		return false
	end	
end
--死亡则放弃任务
function Adventure_OnDead(_idCharacter)
	Adventure_processGiveUpReq(_idCharacter)
end
table.insert(tOnCharacterDead,Adventure_OnDead) 

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--0点重置
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_ZeroReset(_idCharacter,_nOsTimes)		
	if System_IsExistTempData(_idCharacter,nLuaIdActivity_Time) then	
		System_SetTempData(_idCharacter,nLuaIdActivity_Time,1,0)
	end
	local nComTimes = System_GetTempData(_idCharacter,nLuaIdActivity_Time,1)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_TimeSyn,nComTimes)
end
table.insert(tOnZeroTrigger,Adventure_ZeroReset)


