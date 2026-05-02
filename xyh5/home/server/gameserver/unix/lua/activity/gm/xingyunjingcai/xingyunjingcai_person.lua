local nResId = CRESOURCEFLOWACTION.eFT_XingYunJingCai_Buy
local nResIdAward = CRESOURCEFLOWACTION.eFT_XingYunJingCai_Award
local nLuaTempid = LUARESOURCEFLOWACTION[nResId]
local nLuaGlobal = LUARESOURCEFLOWACTION[nResId]

local XingYunJingCai_Info = _xingyunjingcai_Info['Root'][1]['group']

local eXYJCLT_Syn = 1
local eXYJCLT_Guess = 2
local eXYJCLT_Buy = 3
local eXYJCLT_GiveUp = 4

local eXYJCC_Success 			= 0	--领取成功
local eXYJCC_Unknow 			= 1	--未知错误
local eXYJCC_EmoneyNotEnough 	= 2	--元宝不足
local eXYJCC_BagFull 			= 3	--背包已满
local eXYJCC_TimeLess 			= 4	--次数不足
local eXYJCC_NotOpen 			= 5	--活动未开启

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	Note：
--			data1: 活动状态		0未开启  	1开启
--			data2: 已竞猜次数  	又改成轮数
--			data3: 可竞猜次数  	又改成轮数
--			data4: 已用免费次数 又改成轮数
--			data5: 
--			data6: 当前区间min
--			data7: 当前区间max
--			data8: 当前竞猜轮数
--			datastr: 竞猜记录  num,num,num
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 玩家登录
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function XingYunJingCai_Person_Login(_idCharacter,_nOsTimes)
	_nOSTime = _nOSTime or os.time()
	GM_XingYunJingCai_instance_Login(_nOsTimes)
	if false == System_IsExistTempData(_idCharacter,nLuaTempid) then
		System_AddTempData(_idCharacter,nLuaTempid,false)
		XingYunJingCai_Person_ResetGuessData(_idCharacter,true)
	end
	XingYunJingCai_Person_SendActiveStatus(_idCharacter)
	XingYunJingCai_Person_Syn(_idCharacter)
end
table.insert(tOnLoginActivity,XingYunJingCai_Person_Login)

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 0点重置
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function XingYunJingCai_Person_ZeroRefresh(_idCharacter,_nOsTimes)	
	XingYunJingCai_Person_SendActiveStatus(_idCharacter)
	XingYunJingCai_Person_ResetGuessData(_idCharacter,true)
	XingYunJingCai_Person_Syn(_idCharacter)
end
table.insert(tOnZeroTrigger,XingYunJingCai_Person_ZeroRefresh)
-- ===============================================================================================================
-- 发放活动状态给客户端
-- =============================================================================================================== 
function XingYunJingCai_Person_SendActiveStatus(_idCharacter)	
	local status = System_GetGlobalData(nLuaGlobal,1)
	local status_p = System_GetTempData(_idCharacter,nLuaTempid,1)

	local nBeg = 0
	local nEnd = 0
	if status == 1 then
		nBeg = System_GetGlobalData(nLuaGlobal,2)
		nEnd = System_GetGlobalData(nLuaGlobal,3)		
		System_SetTempData(_idCharacter,nLuaTempid,1,1)		
		System_XingYunJingCai_SendStatus(_idCharacter,status,System_GetGlobalData(nLuaGlobal,4),nBeg,nEnd)		
	end
	
	if status == 0 and status_p == 1 then
		System_SetTempData(_idCharacter,nLuaTempid,1,0)	
		--这个不应该清掉的
		--System_SetTempData(_idCharacter,nLuaTempid,2,0)		
		System_XingYunJingCai_SendStatus(_idCharacter,status,System_GetGlobalData(nLuaGlobal,4),nBeg,nEnd)
	end	
	if status == 1 and status_p == 0 then
		--//开启活动的话 增加免费次数 又改成轮数
		local nGroup = System_GetGlobalData(nLuaGlobal,4)
		local tGroupInfo = nil
		for k,v in pairs(XingYunJingCai_Info) do
			if v.id == nGroup then
				tGroupInfo = XingYunJingCai_Info[k]
			end
		end
		if tGroupInfo == nil then
			L2C_DebugLog(string.format("::XingYunJingCai_Person_SendActiveStatus DataConfig Error GroupId[%d]",nGroup))
			return
		end
	
		local tXingyun = tGroupInfo.xingyun[1]
		System_SetTempData(_idCharacter,nLuaTempid,4, 0)	
		XingYunJingCai_Person_ResetGuessData(_idCharacter,false)
	end
end

-- ===============================================================================================================
-- 服务端消息入口
-- =============================================================================================================== 
function XingYunJingCai_Person_ReqMain(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	if eXYJCLT_Syn == _nData1 then
		 XingYunJingCai_Person_Syn(_idCharacter)
		 return eXYJCC_Success
	end
	if eXYJCLT_Guess == _nData1 then
		local nCode = XingYunJingCai_Person_Guess(_idCharacter,_nCActionType,_nData2)
		-- L2C_DebugLog("::XingYunJingCai_Person_Guess Code".. nCode)
		return nCode
	end
	if eXYJCLT_Buy == _nData1 then
		local nCode,free = XingYunJingCai_Person_Buy(_idCharacter,_nCActionType,_nData2)		
		System_XingYunJingCai_Buy(_idCharacter,nCode,System_GetTempData(_idCharacter,nLuaTempid,3) + free)
		-- L2C_DebugLog("::XingYunJingCai_Person_Buy Code".. nCode)
		return nCode		
	end
	if eXYJCLT_GiveUp == _nData1 then
		local nCode = XingYunJingCai_Person_GiveUp(_idCharacter,_nCActionType)		
		-- L2C_DebugLog("::XingYunJingCai_Person_GiveUp Code".. nCode)
		return nCode	
	end
	return eXYJCC_Unknow
end
tOnOnAcitveAward[nResId] = XingYunJingCai_Person_ReqMain

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 同步消息
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_Syn(_idCharacter)
	--活动信息 活动没开启就不发 活动状态有单独消息
	local nStatus = System_GetTempData(_idCharacter,nLuaTempid,1)	
	if nStatus == 0 then
		return
	end

	local nGroup = System_GetGlobalData(nLuaGlobal,4)
	local nTimes = System_GetTempData(_idCharacter,nLuaTempid,2)	
	local times_total = System_GetTempData(_idCharacter,nLuaTempid,3)	
	local times_free = System_GetTempData(_idCharacter,nLuaTempid,4)	
	local min_base, max_base = XingYunJingCai_Person_GetArea(_idCharacter)
	local min_now = System_GetTempData(_idCharacter,nLuaTempid,6)	
	local max_now = System_GetTempData(_idCharacter,nLuaTempid,7)	
	local strData = System_GetTempDataStr(_idCharacter,nLuaTempid)	
	
	local nGroup = System_GetGlobalData(nLuaGlobal,4)
	local tGroupInfo = nil
	for k,v in pairs(XingYunJingCai_Info) do
		if v.id == nGroup then
			tGroupInfo = XingYunJingCai_Info[k]
		end
	end
	if tGroupInfo == nil then
		L2C_DebugLog(string.format("::XingYunJingCai_Person_Syn DataConfig Error GroupId[%d]",nGroup))
		return 
	end
	
	local tXingyun = tGroupInfo.xingyun[1]	
	
	System_XingYunJingCai_Syn(_idCharacter,nGroup,nTimes + times_free, times_total + tXingyun.num, min_base, max_base, min_now, max_now, strData)
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 重置竞猜信息
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_ResetGuessData(_idCharacter,_isNewDay)
	local nGroup = System_GetGlobalData(nLuaGlobal,4)
	local tGroupInfo = nil
	for k,v in pairs(XingYunJingCai_Info) do
		if v.id == nGroup then
			tGroupInfo = XingYunJingCai_Info[k]
		end
	end
	if tGroupInfo == nil then
		-- L2C_DebugLog(string.format("::XingYunJingCai_Person_ResetGuessData DataConfig Error GroupId[%d]",nGroup))
		return
	end
	
	local tXingyun = tGroupInfo.xingyun[1]
	
	--新一天的话重置次数
	if true == _isNewDay then
		System_SetTempData(_idCharacter,nLuaTempid,8,0)
		--System_SetTempData(_idCharacter,nLuaTempid,3,tXingyun.num)
		--没猜完且活动没结束就继续猜
		if "" ~= System_GetTempDataStr(_idCharacter,nLuaTempid) and 1 == System_GetTempData(_idCharacter,nLuaTempid,1) then
			return
		end
	end		
	
	local nBaseMin,nBaseMax =  XingYunJingCai_Person_GetArea(_idCharacter)
	System_SetTempData(_idCharacter,nLuaTempid,6,nBaseMin)
	System_SetTempData(_idCharacter,nLuaTempid,7,nBaseMax)
	System_SetTempDataStr(_idCharacter,nLuaTempid,"")
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 竞猜
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_Guess(_idCharacter,_nCActionType,_nNum)
	local nGroup = System_GetGlobalData(nLuaGlobal,4)
	local tGroupInfo = nil
	for k,v in pairs(XingYunJingCai_Info) do
		if v.id == nGroup then
			tGroupInfo = XingYunJingCai_Info[k]
		end
	end
	if tGroupInfo == nil then
		L2C_DebugLog(string.format("::XingYunJingCai_Person_Guess DataConfig Error GroupId[%d]",nGroup))
		return eXYJCC_Unknow
	end
	
	local tXingyun = tGroupInfo.xingyun[1]
	
	for k,v in pairs(tXingyun.reward) do
		--判断背包空间
		local sItem = ""	 
		for l,w in pairs(v.thing) do
			local nIdItem = "number" == type(w["item"]) and w["item"] or 0
			local nNum = "number" == type(w["num"]) and w["num"] or 0
			sItem = sItem .. nIdItem .. "," .. nNum .. ";"
		end
		if false == System_CanPushThingsToBagEx(_idCharacter,sItem) then
			return eXYJCC_BagFull			
		end		
	end	

	
	local number_log = System_GetTempDataStr(_idCharacter,nLuaTempid)
	local nTimes = System_GetTempData(_idCharacter,nLuaTempid,2)
	local times_total = System_GetTempData(_idCharacter,nLuaTempid,3)

	-- 已有竞猜就让他猜完 不做时间判定
	if number_log == "" then
		if false == XingYunJingCai_Person_CheckOpen(_idCharacter,tGroupInfo) then
			return eXYJCC_NotOpen
		end
		if System_GetTempData(_idCharacter,nLuaTempid,4) < tXingyun.num then
			System_SetTempData(_idCharacter,nLuaTempid,4,  (System_GetTempData(_idCharacter,nLuaTempid,4)  + 1 ))
		else
			if nTimes >= times_total then
				return eXYJCC_TimeLess
			end	
			System_SetTempData(_idCharacter,nLuaTempid,2,  (System_GetTempData(_idCharacter,nLuaTempid,2)  + 1 ))
		end
	end
	
	

	local min_now = System_GetTempData(_idCharacter,nLuaTempid,6)	
	local max_now = System_GetTempData(_idCharacter,nLuaTempid,7)	
	local nRound = System_GetTempData(_idCharacter,nLuaTempid,8)
	
	--判断是否中奖
	local nAwardType = 0 -- 发哪种奖  0为不发
	
	if min_now <= _nNum and max_now >= _nNum then
		--区间内的数字才判断是否中奖
		for k,v in pairs(tXingyun.guess) do
			if v.nummin <= nRound + 1 and nRound + 1 <= v.nummax then
				if "number" == type(v.probability) then
					if v.probability >= math.random(1,10000) then
						nAwardType = 1
					end
				end
			end
		end
	end	
	
	if nAwardType == 0 then
		--判断是否全部猜完
		local number_log = System_GetTempDataStr(_idCharacter,nLuaTempid)
		local tLog = System_Split(number_log,",")
		if #tLog + 1 >= tXingyun.caicishu then
			nAwardType = 2
		end
	end
	--有奖励发
	if nAwardType > 0 then
		System_SetTempData(_idCharacter,nLuaTempid,8,System_GetTempData(_idCharacter,nLuaTempid,8) + 1)		
		XingYunJingCai_Person_ResetGuessData(_idCharacter,false)
		
		for k,v in pairs(tXingyun.reward) do
			if nAwardType == v.type then
				if "number" == type(v.gold) then
					System_AwardEmoney(_idCharacter,v.gold,nResIdAward)
				end
				for l,w in pairs(v.thing) do
					local nIdItem = "number" == type(w["item"]) and w["item"] or 0
					local nNum = "number" == type(w["num"]) and w["num"] or 0
					System_AwardThingInBag(_idCharacter,nResIdAward,nIdItem,nNum)
				end
			end
		end
		--记录发奖经分
		System_XingYunJingCai_LogAward(_idCharacter,nAwardType)
	end
	--通知竞猜结果
	if nAwardType == 1 then		
		System_XingYunJingCai_Guess(_idCharacter,1
										,System_GetTempData(_idCharacter,nLuaTempid,6)
										,System_GetTempData(_idCharacter,nLuaTempid,7)
									)
		local sParam = string.format("%d,%u;%d,%s"
					,ePreparedStatementValueType.TYPE_UI64,_idCharacter
					,ePreparedStatementValueType.TYPE_STRING,System_GetCharacterName(_idCharacter)									
					)
		System_SendCommonBroadCastMsg(tXingyun.notice1,sParam)
	elseif nAwardType == 0 then
		if min_now <= _nNum and max_now >= _nNum then
			--区间内的数字才更新区间		
			local nNerval = tXingyun.nerval_num
			
			if _nNum < min_now + nNerval and _nNum + nNerval < max_now then
				--下区间小于间隔 则上区间
				min_now = _nNum + 1
			elseif _nNum + nNerval > max_now and _nNum > min_now + nNerval then
				--上区间小于间隔 则下区间
				max_now = _nNum - 1
			elseif _nNum + nNerval >= max_now and _nNum <= min_now + nNerval then
				-- 两个区间都小于间隔 取大区间
				if max_now + min_now < 2 * _nNum then
					max_now = _nNum - 1
				end
				if max_now + min_now > 2 * _nNum then
					min_now = _nNum + 1
				end			
				if max_now + min_now == 2 * _nNum then
					local nRan = math.random(1,2)
						if nRan == 1 then
						min_now = _nNum	+ 1		
					end
					if nRan == 2 then
						max_now = _nNum - 1
					end
				end
			else
				--都大于区间的话随机一个
				local nRan = math.random(1,2)
				if nRan == 1 then
					min_now = _nNum	+ 1		
				end
				if nRan == 2 then
					max_now = _nNum - 1
				end
			end
		end
		
		local number_log = System_GetTempDataStr(_idCharacter,nLuaTempid)
		if number_log == "" then
			number_log = _nNum
		else		
			number_log = number_log .. "," .. _nNum
		end
		System_SetTempDataStr(_idCharacter,nLuaTempid,number_log)
		System_SetTempData(_idCharacter,nLuaTempid,6,min_now)	
		System_SetTempData(_idCharacter,nLuaTempid,7,max_now)		
		
		System_XingYunJingCai_Guess(_idCharacter,0,min_now,max_now)
	elseif nAwardType == 2 then
		System_XingYunJingCai_Guess(_idCharacter,0
										,System_GetTempData(_idCharacter,nLuaTempid,6)	
										,System_GetTempData(_idCharacter,nLuaTempid,7)
										)
	end
	return eXYJCC_Success
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 购买次数 又改成轮数
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_Buy(_idCharacter,_nCActionType,_nNum)
	local nGroup = System_GetGlobalData(nLuaGlobal,4)
	local tGroupInfo = nil
	for k,v in pairs(XingYunJingCai_Info) do
		if v.id == nGroup then
			tGroupInfo = XingYunJingCai_Info[k]
		end
	end
	if tGroupInfo == nil then
		L2C_DebugLog(string.format("::XingYunJingCai_Person_Buy DataConfig Error GroupId[%d]",nGroup))
		return eXYJCC_Unknow
	end
	
	local tXingyun = tGroupInfo.xingyun[1]
	if false == XingYunJingCai_Person_CheckOpen(_idCharacter,tGroupInfo) then
		return eXYJCC_NotOpen
	end
	
	if false == System_SpendEmoney(_idCharacter,tXingyun.cost * _nNum,nResId) then
		return eXYJCC_EmoneyNotEnough
	end
	System_SetTempData(_idCharacter,nLuaTempid,3, System_GetTempData(_idCharacter,nLuaTempid,3) + _nNum)	
	return eXYJCC_Success,tXingyun.num
end
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 检测开启条件
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_CheckOpen(_idCharacter,tGroupInfo) 
	local starttime =  string.gsub(tGroupInfo.xingyun[1].start_time, ":", "")
	local  endtime  =  string.gsub(tGroupInfo.xingyun[1].end_time, ":", "")
	local  nowtime  = os.date("%H%M%S",os.time())
	if tonumber(starttime) and tonumber(endtime) and tonumber(nowtime) then
		if tonumber(starttime) > tonumber(nowtime) or tonumber(nowtime) > tonumber(endtime) then
			return false
		end
	else
		return false
	end
	local nLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if "number" ~= type(tGroupInfo.lv ) or tGroupInfo.lv > nLevel then
		return false
	end
end

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 根据轮数取区间
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_GetArea(_idCharacter)
	local nGroup = System_GetGlobalData(nLuaGlobal,4)
	local tGroupInfo = nil
	for k,v in pairs(XingYunJingCai_Info) do
		if v.id == nGroup then
			tGroupInfo = XingYunJingCai_Info[k]
		end
	end
	if tGroupInfo == nil then
		L2C_DebugLog(string.format("::XingYunJingCai_Person_SendActiveStatus DataConfig Error GroupId[%d]",nGroup))
		return 0,0
	end
	
	local tXingyun = tGroupInfo.xingyun[1]
	-- 取基本区间
	local nBaseMin = tXingyun.small_num
	local nBaseMax = tXingyun.big_num
	-- 根据今日轮数变更区间
	local nRound = System_GetTempData(_idCharacter,nLuaTempid,8)
	for k,v in pairs(tXingyun.guess) do
		if v.nummin <= nRound + 1 and nRound + 1 <= v.nummax then
			if "number" == type(v.value ) then
				if v.value < 0 then
					nBaseMax = nBaseMax + v.value
				end
				if v.value > 0 then
					nBaseMin = nBaseMin + v.value
				end
			end
		end
	end
	return nBaseMin,nBaseMax 
end
-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 放弃竞猜
-- /////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
function XingYunJingCai_Person_GiveUp(_idCharacter,_nCActionType)
	XingYunJingCai_Person_ResetGuessData(_idCharacter,false)
	return eXYJCC_Success
end