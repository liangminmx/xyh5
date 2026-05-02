math.randomseed(os.time())  
function C2L_RunPerMinute()

	-- L2C_CustomLog("lua_task", "RunPerMinute")
	--x = os.clock();
	--Quest_IsQuestComplete(1,20010)
	--C2L_OnAcceptQuest(1000000001,20010)
	--C2L_QuestCheck(1000000001,20060,5,1,0)
	--C2L_OnQuestReward(1000000001,20020)
	--/reload 
	--/calllua </F>C2L_QuestCheck</N>11000000001</N>10010</N>11</N>10001</N>1
	--/calllua </F>C2L_QuestCheck</N>3000000001</N>10020</N>12</N>100000</N>1
	--/calllua </F>C2L_QuestCheck</N>3000000001</N>10030</N>11</N>10001</N>1
	--/calllua </F>C2L_QuestCheck</N>3000000001</N>10040</N>12</N>100001</N>1
	--/calllua </F>Quest_CompleteQuest</N>11000000001</N>10010</N>10001
	--/calllua </F>Quest_CompleteQuest</N>10000000001</N>10010</N>10001
	--/calllua </F>C2L_QuestCheck</N>11000000001</N>30020</N>12</N>100001</N>1
	--/calllua </F>C2L_QuestCheck</N>10000000001</N>30030</N>12</N>100002</N>1
	--/calllua </F>C2L_QuestCheck</N>11000000001</N>30020</N>12</N>100002</N>1
	--/calllua </F>C2L_QuestCheck</N>4000000001</N>20010</N>15</N>0</N>100
	--/calllua </F>C2L_QuestCheck</N>4000000001</N>20000</N>15</N>0</N>100
	--/calllua </F>C2L_QuestCheck</N>4000000001</N>20020</N>16</N>0</N>100
end

function System_ItemVec2String(_tItems,_nCount)	
	local sRet = ""
	_nCount = _nCount or 0
	for _,v in ipairs(_tItems) do
		if "table" == type(v) then		
			--物品ID
			if _nCount >= 1 then
				sRet = sRet .. v[1] 
			end
			--数量
			if _nCount >= 2 then
				sRet = sRet .. [[,]] .. (v[2] or 1)
			end
			--层级
			if _nCount >= 3 and v[3] ~= nil then
				sRet = sRet .. [[,]] .. v[3]
			end			
			--是否绑定
			if _nCount >= 4 and v[4] ~= nil then
				sRet = sRet .. [[,]] .. v[4]
			end
			--过期模式
			if _nCount >= 5 and v[5] ~= nil then
				sRet = sRet .. [[,]] .. v[5]
			end
			--过期时间
			if _nCount >= 6 and v[6] ~= nil then
				sRet = sRet .. [[,]] .. v[6]
			end
		end
		sRet = sRet .. [[;]]
	end
	return sRet
end
--字符串链接
function System_StrCatOnTable(_tTable,_sSplit,_sKey)
	local sRet = ""
	for k,v in ipairs(_tTable) do
		local sWord = ""
		if _sKey ~= nil then
			sWord = tostring(v[_sKey])
		else
			sWord = tostring(v)
		end
		if k == 1 then
			sRet = sWord
		else
			sRet = sRet .. _sSplit .. sWord
		end
	end
	return sRet
end

function L2C_CustomLog(sLogName, sLogTxt)
	return C_ProcessAction(101, 0, sLogName, sLogTxt)
end

function L2C_DebugLog(sLogTxt)
	if (nil ~= string.find(sLogTxt,"%%"))then
		--//这是不定参 防止有人写错 %s 之类的
		sLogTxt = string.gsub(sLogTxt,"%%","[Percent]")
	end
	return C_ProcessAction(101, 0, "lua_debug", sLogTxt)
end

function L2C_AwardLuoDan(nAwardNum, eActionType)
	return C_AddCharacterLuoDan(nAwardNum, eActionType)
end


function L2C_AwardThings_Clear()
	return C_ClearThingCreateDataTempVector()
end

function L2C_AwardThings_Add(nItemCfgID, nNum, bBind, nQuality, nRealm, nStage, nStrengthLev, nTimeMode, nExpiryTime)
	return C_PushThingCreateDataToTempVector(nItemCfgID, nNum, bBind or true, nQuality or 0, nRealm or 0, nStage or 0, nStrengthLev or 0, nTimeMode or 0, nExpiryTime or 0)
end

function L2C_AwardThings_Can()
	return C_CanPushThingsToCharacterBag()
end

function L2C_AwardThings_Begin()
	return C_PushThingsToCharacterBag(eActionType)
end

function L2C_AwardThingInBag(eActionType, nItemCfgID, nNum, bBind, nQuality, nRealm, nStage, nStrengthLev, nTimeMode, nExpiryTime)
	return C_PushThingToCharacterBag(eActionType, nItemCfgID, nNum, bBind or true, nQuality or 0, nRealm or 0, nStage or 0, nStrengthLev or 0, nTimeMode or 0, nExpiryTime or 0)
end

function L2C_AwardThingQuestContainer(eActionType, nItemCfgID, nNum, bBind, nQuality, nRealm, nStage, nStrengthLev, nTimeMode, nExpiryTime)
	return C_PushThingToCharacterQuestContainer(eActionType, nItemCfgID, nNum, bBind or true, nQuality or 0, nRealm or 0, nStage or 0, nStrengthLev or 0, nTimeMode or 0, nExpiryTime or 0)
end

--设置任务flag
function Quest_SetQuestFlag(_idCharacter,_nQuestId,_nFlag)
    local bRet = C_SetQuestFlag(_idCharacter,_nQuestId,_nFlag)
    return bRet
end

--增加任务进度
function Quest_AddQuestProgess(_idCharacter,_nQuestId,_nNum)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_AddScriptQuestProgess(_idCharacter,_nQuestId,_nNum)
	return bRet 
end
--设置任务进度
function Quest_SetQuestProgess(_idCharacter,_nQuestId,_nNum)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_SetScriptQuestProgess(_idCharacter,_nQuestId,_nNum)
	return bRet
end
--获取任务进度
function Quest_GetQuestProgess(_idCharacter,_nQuestId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local nRet = C_GetScriptQuestProgess(_idCharacter,_nQuestId)
	return nRet
end
--任务达成 
function Quest_AccomplishQuest(_idCharacter,_nQuestId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_AccomplishQuest(_idCharacter,_nQuestId)
	return bRet	
end

--添加任务
function Quest_AddNewQuest(_idCharacter,_nQuestId,_nFlag)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	_nFlag = _nFlag or 1
	local bRet = C_AddNewQuest(_idCharacter,_nQuestId,_nFlag)
	return bRet	
end

--任务达成 完成并交任务
function Quest_QuestFinishCondition(_idCharacter,_nQuestId,_nCurTaskId,_nEntrustTaskId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	_nCurTaskId = _nCurTaskId or 0
	_nEntrustTaskId = _nEntrustTaskId or 0
	local bRet = C_MeetScriptQuestFinishCondition(_idCharacter,_nQuestId,_nCurTaskId,_nEntrustTaskId)
	return bRet
end
--任务是否完成
function Quest_IsQuestComplete(_idCharacter,_nQuestId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_IsQuestComplete(_idCharacter,_nQuestId)
	return bRet
end

--取任务状态
function Quest_GetQuestFlag(_idCharacter,_nQuestId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return -1
	end
	local nRet = C_GetQuestFlag(_idCharacter,_nQuestId)
	return nRet
end
--完成任务
function Quest_CompleteQuest(_idCharacter,_nQuestId,_nNpc)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_CompleteQuest(_idCharacter,_nQuestId,_nNpc)
	return bRet
end
--删除任务
function Quest_DeleteQuest(_idCharacter,_nQuestId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_DeleteQuest(_idCharacter,_nQuestId,_nNpc)
	return bRet
end
--增加掩码 
--参数： 玩家ID、 任务ID、 掩码索引（1-6为int32 78为int 64 ）、数量
function Quest_AddMask(_idCharacter,_nQuestId,_nMask,_nNum)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_AddScriptQuestMask(_idCharacter,_nQuestId,_nMask,_nNum)
	return bRet
end
--修改掩码
function Quest_SetMask(_idCharacter,_nQuestId,_nMask,_nNum)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_SetScriptQuestMask(_idCharacter,_nQuestId,_nMask,_nNum)
	return bRet
end
--获取掩码
function Quest_GetMask(_idCharacter,_nQuestId,_nMask)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_GetScriptQuestMask(_idCharacter,_nQuestId,_nMask)
	return bRet
end
--接受宗族任务
function Quest_AcceptGuildQuest(_idCharacter)
	local bRet = C_AcceptGuildQuest(_idCharacter)
	return bRet
end
--设置任务完成
function Quest_SetQuestComplete(_idCharacter,_nQuestId)
	if not ("number" == type(_nQuestId) and _nQuestId > 0 )then
		return false
	end
	local bRet = C_SetQuestComplete(_idCharacter,_nQuestId)
	return bRet
end

--获取玩家属性信息
function System_GetAttrInt(_idCharacter,_nCharacterInt,_nData)
	_nData = _nData or -1
	local nRet = C_GetCharacterAttrInt(_idCharacter,_nCharacterInt,_nData)
	return nRet
end

--获取玩家职业
function System_GetProfession(_idCharacter)
	local nRet = C_GetProfession(_idCharacter)
	return nRet
end

--增加游戏币
function System_AwardMoney(_idCharacter,_nAwardNum, _eActionType)
	if "number" ~= type(_nAwardNum) or _nAwardNum <= 0 then return false end
	local bRet = C_AddCharacterCurrencyNum(_idCharacter,_nAwardNum, CURRENCYTYPE.MONEY, _eActionType)
	return bRet
end
--增加代币
function System_AwardEmoney(_idCharacter,_nAwardNum, _eActionType)
	if "number" ~= type(_nAwardNum) or _nAwardNum <= 0 then return false end
	local bRet = C_AddCharacterCurrencyNum(_idCharacter,_nAwardNum, CURRENCYTYPE.EMONEY, _eActionType)
	return bRet
end
--增加礼金
function System_AwardVouchers(_idCharacter,_nAwardNum, _eActionType)
	if "number" ~= type(_nAwardNum) or _nAwardNum <= 0 then return false end
	local bRet = C_AddCharacterCurrencyNum(_idCharacter,_nAwardNum, CURRENCYTYPE.VOUCHERS, _eActionType)
	return bRet
end

--扣除游戏币
function System_SpendMoney(_idCharacter,_nSpendNum, _eActionType)
	if "number" ~= type(_nSpendNum) or _nSpendNum <= 0 then return false end
	local bRet = C_SubCharacterCurrencyNum(_idCharacter,_nSpendNum, CURRENCYTYPE.MONEY, _eActionType)
	return bRet
end
--扣除代币
function System_SpendEmoney(_idCharacter,_nSpendNum, _eActionType)
	if "number" ~= type(_nSpendNum) or _nSpendNum <= 0 then return false end
	local bRet = C_SubCharacterCurrencyNum(_idCharacter,_nSpendNum, CURRENCYTYPE.EMONEY, _eActionType)
	return bRet
end
--扣除礼金
function System_SpendVouchers(_idCharacter,_nSpendNum, _eActionType)
	if "number" ~= type(_nSpendNum) or _nSpendNum <= 0 then return false end
	local bRet = C_SubCharacterCurrencyNum(_idCharacter,_nSpendNum, CURRENCYTYPE.VOUCHERS, _eActionType)
	return bRet
end

--充值
function System_Recharge(_idCharacter,_nAwardNum)
	if "number" ~= type(_nAwardNum) or _nAwardNum <= 0 then return false end
	local bRet = C_Recharge(_idCharacter,_nAwardNum)
	return bRet
end

function System_AwardRealmPoint(_idCharacter,_nAwardNum)
	local bRet = C_AddCharacterRealm(_idCharacter,_nAwardNum)
	return bRet
end
--增加经验
function System_AwardExp(_idCharacter,_nAwardNum, _eActionType)
    if  "number" ~= type(_nAwardNum) or _nAwardNum <= 0 then return false end
	local bRet = C_AddCharacterExp(_idCharacter,_nAwardNum, _eActionType)
	return bRet
end
-- _sItem格式 "item,num;item2,num2;"
-- _tItems格式 {{item,num},{item2,num2}}
function System_CanPushThingsToBagEx(_idCharacter, _sItem)
	if "table" == type(_sItem) then _sItem = System_ItemVec2String(_sItem,2) end	
	local bRet = C_CanPushThingsToBagEx(_idCharacter,_sItem)
	return bRet	
end
--增加物品
function System_AwardThingInBag(_idCharacter,_eActionType, _nItemCfgID, _nNum, _nQuality, _nRealm, _nStage, _nStrengthLev, _nTimeMode, _nExpiryTime)
	if _nNum == 0 then
		return false
	end
	_nQuality = _nQuality or 0
	_nRealm = _nRealm or 0
	if _nRealm == 0 then _nRealm = _nQuality end
	_nStage = _nStage or 0
	_nStrengthLev = _nStrengthLev or 0
	_nTimeMode = _nTimeMode or 0
	_nExpiryTime = _nExpiryTime or 0	
	local bRet = C_PushThingToCharacterBag(_idCharacter,_eActionType, _nItemCfgID, _nNum, true, _nQuality, _nRealm, _nStage, _nStrengthLev, _nTimeMode, _nExpiryTime)
	return bRet
end
--整型转为boolean 
function WC_IntToBool(_nData)
	if("boolean" == type(_nData))then
		return _nData
	end
	if ("number" == type(_nData))then
		return 0 ~= _nData
	end
	if 	("string" == type(_nData))then
		return "0" ~= _nData
	end
end

function System_AwardThingQuestContainer(_idCharacter,_eActionType, _nItemCfgID, _nNum, _nQuality, _nRealm, _nStage, _nStrengthLev, _nTimeMode, _nExpiryTime)
	if _nNum == 0 then
		return false
	end
	_nQuality = _nQuality or 0
	_nRealm = _nRealm or 0
	if _nRealm == 0 then _nRealm = _nQuality end
	_nStage = _nStage or 0
	_nStrengthLev = _nStrengthLev or 0
	_nTimeMode = _nTimeMode or 0
	_nExpiryTime = _nExpiryTime or 0
	local bRet = C_PushThingToCharacterQuestContainer(_idCharacter,_eActionType, _nItemCfgID, _nNum, true, _nQuality, _nRealm, _nStage, _nStrengthLev, _nTimeMode, _nExpiryTime)
	return bRet
end
-- 增加家族贡献（伪）
function System_AwardContribution(_idCharacter,_nAwardNum,_nType)	
	local bRet = C_AddCharacterContribution(_idCharacter,_nAwardNum,_nType)	and System_AwardStroy(_idCharacter,_nAwardNum,_nType)
	return bRet
end
--一些旧配置是Contribution 但是雪鹰实际给的是Stroy 显示也是Stroy  实际两个都要加
--Contribution属于类似于该帮派的总贡献 离帮清空 stroy可以带走
-- 增加家族贡献（真）
function System_AwardStroy(_idCharacter,_nAwardNum,_nType)	
	local bRet = C_AddCharacterStroy(_idCharacter,_nAwardNum,_nType)
	return bRet
end


--增加血脉
function System_AwardBlood(_idCharacter,_nAwardNum, _eActionType)
	local bRet = C_AddBloodValue(_idCharacter,_nAwardNum, _eActionType)
	return bRet
end
--增加真页
function System_AwardTruePage(_idCharacter,_nAwardNum, _eActionType)
	local bRet = C_AddTruePage(_idCharacter,_nAwardNum, _eActionType)
	return bRet
end
--增加悟性
function System_AddSavvy(_idCharacter,_nAwardNum, _eActionType)
	local bRet = C_AddSavvy(_idCharacter,_nAwardNum, _eActionType)
	return bRet
end
--增加技能点
function System_AddSkillPoint(_idCharacter,nAwardNum, eActionType)
	local bRet =  C_AddCharacterUnitPower(_idCharacter,nAwardNum, eActionType)
	return bRet
end
--解释神兵
--	enum eWeaponRewardWay
--	{
--		eWRW_Item = 1,      
--		eWRW_WeaponPractiseLevel    = 2, 
--		eWRW_UseIllusion = 3,
--		eWRW_CompletePlotQuest = 4,
--		eWRW_SevenLoginReward = 5,
--	};
function System_UnlockWeapon(_idCharacter,_nWeaponId,_nAwardWay)
	local bRet = C_UnlockWeapon(_idCharacter,_nWeaponId,_nAwardWay)
	return bRet
end

--获得伙伴
--enum eGetPartnerType
--{
--	eGPT_Vip = 1,
--	eGPT_Item,
--	eGPT_Quest,
--	eGPT_Debris,
--};
function System_UnlockPartner(_idCharacter,_nPartnerId,_nStartLevel,_nLevel,_nType)
	local bRet = C_UnlockPartner(_idCharacter,_nPartnerId,_nStartLevel,_nLevel,_nType)
	return bRet
end
--增加伙伴皮肤
function System_AwardPartnerSkin(_idCharacter,_nPartnerId)
	local bRet = C_AwardPartnerSkin(_idCharacter,_nPartnerId)
	return bRet
end

--增加技能
function System_AddSkill(_idCharacter,_nSkillId,_nLevel)
	local bRet = C_AddSkill(_idCharacter,_nSkillId,_nLevel)
	return bRet
end
--====================================================================================
--玩家个人掩码操作
--====================================================================================
--enum Msg_UserTempData_Act
--{
--	eMUTDA_NONE = 0,
--	eMUTDA_LOAD = 1,		//上线加载
--	eMUTDA_ADD = 2,		//添加
--	eMUTDA_DEL = 3,		//删除
--	eMUTDA_UPDATE = 4,		//修改
--};	

function System_IsExistTempData(_idCharacter,_nTempId)
	local bRet = C_IsExistTempData(_idCharacter,_nTempId)
	return bRet
end
function System_AddTempData(_idCharacter,_nTempId,_IsSend)
	_IsSend = _IsSend ~= false
	local bRet = C_AddTempData(_idCharacter,_nTempId)
	if _IsSend then System_SendTempData2Other(_idCharacter,_nTempId,2) end
	return bRet
end
function System_DelTempData(_idCharacter,_nTempId,_IsSend)
	_IsSend = _IsSend ~= false
	local bRet = C_DelTempData(_idCharacter,_nTempId)
	if _IsSend then System_SendTempData2Other(_idCharacter,_nTempId,3) end
	return bRet
end
--_nIndex : 1-8
function System_GetTempData(_idCharacter,_nTempId,_nIndex)
	local nRet = C_GetTempData(_idCharacter,_nTempId,_nIndex)
	return nRet 
end
function System_GetTempDataStr(_idCharacter,_nTempId)
	local nRet = C_GetTempDataStr(_idCharacter,_nTempId)
	return nRet 
end
function System_SetTempData(_idCharacter,_nTempId,_nIndex,_nData,_IsSend)
	_IsSend = _IsSend ~= false
	local nRet = C_SetTempData(_idCharacter,_nTempId,_nIndex,_nData)
	if _IsSend then System_SendTempData2Other(_idCharacter,_nTempId,4) end
	return nRet 
end
function System_SetTempDataStr(_idCharacter,_nTempId,_sData,_IsSend)
	_IsSend = _IsSend ~= false
	if _sData == nil then
		L2C_DebugLog("Error:System_SetTempDataStr _sData is nil")	
		return
	end
	if string.len(_sData) >= MAXTEMPDATASTRINGLEN then
		L2C_DebugLog("Error:System_SetTempDataStr _sData is too long")	
		return
	end	
	local nRet = C_SetTempDataStr(_idCharacter,_nTempId,_sData)
	if _IsSend then System_SendTempData2Other(_idCharacter,_nTempId,4) end
	return nRet 
end
function System_SendTempData2Other(_idCharacter,_nTempId,_nAction)
	local bRet = C_SendTempData(_idCharacter,_nTempId,_nAction)
	return bRet
end

function System_SetAllTempData(_idCharacter,_nTempId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_sDataStr,_IsSend)
	_nData1 = _nData1 or 0
	_nData2 = _nData2 or 0
	_nData3 = _nData3 or 0
	_nData4 = _nData4 or 0
	_nData5 = _nData5 or 0
	_nData6 = _nData6 or 0
	_nData7 = _nData7 or 0
	_nData8 = _nData8 or 0
	_IsSend = _IsSend ~= false	
	if _sDataStr == nil then
		L2C_DebugLog("Error:System_SetAllTempData _sDataStr is nil")	
		return
	end
	if string.len(_sDataStr) >= MAXTEMPDATASTRINGLEN then
		L2C_DebugLog("Error:System_SetAllTempData _sDataStr is too long")	
		return
	end	
	local bRet = C_SetAllTempData(_idCharacter,_nTempId,_nData1,_nData2,_nData3,_nData4,_nData5,_nData6,_nData7,_nData8,_sDataStr,_IsSend)
	if _IsSend then System_SendTempData2Other(_idCharacter,_nTempId,4) end
	return bRet
end

--====================================================================================
--全局掩码操作
--====================================================================================
function System_IsExistGlobalData(_nGlobalId)
	local bRet = C_IsExistGlobalData(_nGlobalId)
	return bRet
end
function System_AddGlobalData(_nGlobalId,_IsSend)
	_IsSend = _IsSend ~= false
	local bRet = C_AddGlobalData(_nGlobalId)
	if _IsSend then System_SendGlobalData2Other(_nGlobalId,2) end
	return bRet
end
function System_DelGlobalData(_nGlobalId,_IsSend)
	_IsSend = _IsSend ~= false
	local bRet = C_DelGlobalData(_nGlobalId)
	if _IsSend then System_SendGlobalData2Other(_nGlobalId,3) end
	return bRet
end
--_nIndex : 1-8
function System_GetGlobalData(_nGlobalId,_nIndex)
	local nRet = C_GetGlobalData(_nGlobalId,_nIndex)
	return nRet 
end
function System_GetGlobalDataStr(_nGlobalId)
	local nRet = C_GetGlobalDataStr(_nGlobalId)
	return nRet 
end
function System_SetGlobalData(_nGlobalId,_nIndex,_nData,_IsSend)
	_IsSend = _IsSend ~= false
	local nRet = C_SetGlobalData(_nGlobalId,_nIndex,_nData)
	if _IsSend then System_SendGlobalData2Other(_nGlobalId,4) end
	return nRet 
end
function System_SetGlobalDataStr(_nGlobalId,_sData,_IsSend)
	_IsSend = _IsSend ~= false
	if _sData == nil then
		L2C_DebugLog("Error:System_SetGlobalDataStr _sData is nil")	
		return
	end
	if string.len(_sData) >= MAXTEMPDATASTRINGLEN then
		L2C_DebugLog("Error:System_SetGlobalDataStr _sData is too long")	
		return
	end	
	local nRet = C_SetGlobalDataStr(_nGlobalId,_sData)
	if _IsSend then System_SendGlobalData2Other(_nGlobalId,4) end
	return nRet 
end

function System_SendGlobalData2Other(_nGlobalId,_nAction)
	local bRet = C_SendGlobalData(_nGlobalId,_nAction)
	return bRet
end
--跨服上取数据用这个
function System_GetGlobalDataCross(_idCharacter,_nAction,_nGlobalId)
	local bRet =  C_GetGlobalDataCross(_idCharacter,_nAction,_nGlobalId)
	return bRet
end
--跨服上修改数据用这个 _nIndex为0时 为修改_strData
function System_SetGlobalDataCross(_idCharacter,_nAction,_nGlobalId,_nIndex,_nData,_strData)
	local bRet = C_SetGlobalDataCross(_idCharacter,_nAction,_nGlobalId,_nIndex,_nData,_strData)
	return bRet
end

--====================================================================================
--====================================================================================

--开启功能
--enum eNewGuideReturnCode
--{
--	eNewGuideRC_Unknow = -1,
--	eNewGuideRC_Success = 0,
--	eNewGuideRC_LessLevel = 1,
--	eNewGuideRC_QuestNotAccept = 2,
--	eNewGuideRC_QuestNotComplete = 3,
--	eNewGuideRC_LessRealm = 4,
--	eNewGuideRC_LessVipLevel = 5,
--};
-- /calllua </F>System_OpenGuideFunction</N>1000000001</N>501
function System_OpenGuideFunction(_idCharacter,_nFuncId)
	local nRet = C_OpenGuideFunction(_idCharacter,_nFuncId)
	return nRet
end
--获取合服次数
function System_GetCombinedTimes()
	local nRet = C_GetCombinedTimes()
	return nRet
end
--获取合服次数 通过玩家ID获取 主要是用跨服上
function System_GetCombinedTimesByCharacter(_idCharacter)
	if false == System_IsCrossSever() then
		return -1
	end
	local nRet = C_GetCombinedTimesByCharacter(_idCharacter)
	return nRet
end
--获取开服天数
function System_GetOpenServerDay()
	local nRet = C_GetOpenServerDay()
	return nRet
end
--获取开服天数 通过玩家ID获取 主要是用跨服上
function System_GetOpenServerDayByCharacter(_idCharacter)
	if false == System_IsCrossSever() then
		return -1
	end
	local nRet = C_GetOpenServerDayByCharacter(_idCharacter)
	return nRet
end
-- 获取该玩家今天的在线时间
function System_GetCurrentOnLineTime(_idCharacter)
	local nRet = C_GetCurrentOnlineTime(_idCharacter)
	return nRet
end
-- 获取Vip等级
function System_GetVipLevel(_idCharacter)
	local nRet = C_GetVipLevel(_idCharacter)
	return nRet
end

-- 获取某个vip等级的人数 Max_Level = 10
function System_GetVipPlayerNum(_nLevel)
	if _nLevel < 0 then return 0 end
	local nRet = C_GetVipPlayerNum(_nLevel)
	return nRet
end
--给玩家发邮件
-- 参数：玩家 、邮件ID或文字、物品、游戏币、代币、礼金
-- _sItem格式 "item,num,stage;item2,num2,stage2;"
-- quality = stage = realm 装备等级 这三个其实是都一个意思
-- _tItems格式 {{item,num,stage},{item2,num2,stage2}}
-- 邮件ID会去邮件文字列表取文字；否则使用本文字
function System_SendMail(idCharacter,_sContent,_sItem,_nMoney,_nEmoney,_nVouchers)
	_nMailId = type(_sContent) == "number" and _sContent or 0
	_sItem = _sItem or ""
	_nMoney = _nMoney or 0
	_nEmoney = _nEmoney or 0
	_nVouchers = _nVouchers or 0
	if "table" == type(_sItem) then _sItem = System_ItemVec2String(_sItem,6) end
	local bRet = C_SendMail(idCharacter,_nMailId,_sContent,_sItem,_nMoney,_nEmoney,_nVouchers)
	return bRet
end

--给玩家发邮件
-- 参数：玩家 、邮件ID或文字、物品、游戏币、代币、礼金
-- _sItem格式 "item,num,stage;item2,num2,stage2;"
-- quality = stage = realm 装备等级 这三个其实是都一个意思
-- _tItems格式 {{item,num,stage},{item2,num2,stage2}}
-- 邮件ID会去邮件文字列表取文字；否则使用本文字
function System_SendMail_PaiMai(idCharacter,_sContent,_sItem,_nMoney,_nEmoney,_nVouchers,_nItemId,_nBuyIdCharacter)
	_nMailId = type(_sContent) == "number" and _sContent or 0
	_sItem = _sItem or ""
	_nMoney = _nMoney or 0
	_nEmoney = _nEmoney or 0
	_nVouchers = _nVouchers or 0
	_nItemId = _nItemId or 0
	_nBuyIdCharacter = _nBuyIdCharacter or 0
	
	if "table" == type(_sItem) then _sItem = System_ItemVec2String(_sItem,6) end
	
	local bRet = C_SendMailFromPaiMai(idCharacter,_nMailId,_sContent,_sItem,_nMoney,_nEmoney,_nVouchers,_nItemId,_nBuyIdCharacter)
	return bRet
end


function System_Split(_str, _delimiter)
	if _str == nil or _str ==''  or _delimiter == nil or _delimiter == '' then
		return {}
	end
	
    local tResult = {}
    --for match in (_str.._delimiter):gmatch("(.-)".._delimiter) do
    --    table.insert(tResult, match)
    --end
	string.gsub(_str, '[^'.._delimiter..']+', function(w) table.insert(tResult, w) end )
    return tResult
end
--取0点的时间戳
function System_GetZeroTime(_nOStime)
	_nOStime = _nOStime or os.time()
	local tDate = os.date("*t",_nOStime)
	tDate.hour = 0
	tDate.min = 0
	tDate.sec = 0
	return os.time(tDate)
end

--取时间戳
function System_GetTimeStamp(nYear,nMonth,nDay,nHour,nMin,nSec)
	local tDate = {}
	tDate.year = nYear
	tDate.month = nMonth
	tDate.day  = nDay
	tDate.hour = nHour
	tDate.min = nMin
	tDate.sec = nSec
	
	return tonumber(os.time(tDate))
end

--增加BUFF
function System_AddBuff(_idCharacter,_nBuffType)
	local bRet = C_AddCharacterBuff(_idCharacter,_nBuffType)
	return bRet
end
--是否跨服服务器
function System_IsCrossSever()
	local bRet = C_IsCrossSever()
	return bRet
end
--将配置的时间改为需要的时间
function System_timeModeTransfer(timeMode,time_n,_nOsTimes)
	_nOsTimes = _nOsTimes or os.time()

	if	timeMode == ThingExpiryMode.eTEM_Unlimit then
	
	elseif	timeMode == ThingExpiryMode.eTEM_AchieveConsume then					
		time_n = time_n + _nOsTimes				
	elseif	timeMode == ThingExpiryMode.eTEM_AchieveOnLineConsume then
			
	elseif	timeMode == ThingExpiryMode.eTEM_AchieveUse then				
			time_n = time_n + _nOsTimes					
			
	elseif	timeMode == ThingExpiryMode.eTEM_AchieveOnlineUse then
		
	elseif	timeMode == ThingExpiryMode.eTEM_TimeOut then				
			time_n = time_n + _nOsTimes			
	elseif	timeMode == ThingExpiryMode.eTEM_DailyConsume then
	else
		L2C_DebugLog("::System_timeModeTransfer Error Time Type !!")
		return 0
	end
	return time_n
end
--增加领域经验
function System_AddDomainExp(_idCharacter, _nDomainExp)
	local bRet = C_AddDomainExp(_idCharacter, _nDomainExp)
	return bRet
end
--活动消息提醒
function System_SendActiveStatus(_idCharacter,_nType,_nStatus,_nBegin,_nEnd)
	-- L2C_DebugLog(string.format("SendActiveStatus:_nType[%s],_nStatus[%s],_nBegin[%s],_nEnd[%s]",_nType,_nStatus,_nBegin,_nEnd))
	local bRet = C_SendActiveStatusMessage(_idCharacter,_nType,_nStatus,_nBegin,_nEnd)
	return bRet
end
--增加称号
function System_AddActiveDesign(_idCharacter,_nTitile,_nType,_nMode,_nTime)
	_nMode = _nMode or 0
	_nTime = _nTime or 0
	local bRet = C_AddActiveDesign(_idCharacter,_nTitile,_nType,_nMode,_nTime)
	return bRet
end
-- enum ePositonType{
	-- ePT_Scene = 1,
	-- ePT_PosX = 2,
	-- ePT_PosY = 3,
-- };
--获取玩家所在地图
function System_GetCharacterScene(_idCharacter)
	local nRet = C_GetCharacterCoordinate(_idCharacter,1)
	nRet = math.floor(nRet + .5)
	return nRet
end

--获取玩家坐标X
function System_GetCharacterPosX(_idCharacter)
	local fRet = C_GetCharacterCoordinate(_idCharacter,2)
	return fRet
end

--获取玩家坐标Y
function System_GetCharacterPosY(_idCharacter)
	local fRet = C_GetCharacterCoordinate(_idCharacter,3)
	return fRet
end
--获取玩家完整位置信息
function System_GetCharacterPostion(_idCharacter)
	local nScene = System_GetCharacterScene(_idCharacter)
	local fPosX = System_GetCharacterPosX(_idCharacter)
	local fPosY = System_GetCharacterPosY(_idCharacter)
	return nScene,fPosX,fPosY
end

--传送玩家
function System_TransferCharacter(_idCharacter, nScene,fPosX,fPosY)
	if _idCharacter <= 0 or nScene <= 0 or fPosX < 0 or fPosY < 0 then
		L2C_DebugLog(string.format("System_TransferCharacter Error :_idCharacter[%s], nScene[%s],fPosX[%s],fPosY[%s]",_idCharacter, nScene,fPosX,fPosY))
		return false
	end
	local bRet = C_ChangeCharacterCoordinate(_idCharacter, nScene,fPosX,fPosY)
	return bRet
end
--消耗物品
function System_ConsumeThingOnCharacterBag(_idCharacter,_nAction,_nThingCfgId,_nNum)
	_nNum = _nNum or 1
	local bRet = C_ConsumeThingOnCharacterBag(_idCharacter,_nAction,_nThingCfgId,_nNum)	
	return bRet
end
--=========_sLuaFunc=========
--在线玩家执行脚本   "</F>FF</N>CHARACTER_ID</N>xxx</S>sss"
--防止被截断   用%s传值  
--CHARACTER_ID 为固有参数 用于服务端替换为玩家ID
--=========_idCharacter
--跨服上才用 ，用于发给对应的游服
function System_CallLuaOnline(_sLuaFunc,_idCharacter)
	_idCharacter = _idCharacter or 0
	local bRtt = C_CallLuaOnlineCharacter(_sLuaFunc,_idCharacter)
end

-- 取得本日(时间)的零点时间戳
function System_GetZeroTime(_nOsTime)
    _nOsTime = _nOsTime or os.time()
    local tData = os.date("*t",_nOsTime)     
    tData["hour"] = 0
	tData["min"] = 0
	tData["sec"] = 0
    return os.time(tData)
end
-- 解锁龙山帝宝
function System_UnlockTreasure(_idCharacter,_nTreasureId,_nActionType)
	local bRet = C_UnlockJewels(_idCharacter,_nTreasureId,_nActionType)
	return bRet
end

--增加开服抽奖到临时背包
function System_AwardThingInKaiFuChouJiangBag(_idCharacter,_eActionType, _nItemCfgID, _nNum, _nQuality, _nRealm, _nStage, _nStrengthLev, _nTimeMode, _nExpiryTime)
	if _nNum == 0 then
		return false
	end
	_nQuality = _nQuality or 0
	_nRealm = _nRealm or 0
	if _nRealm == 0 then _nRealm = _nQuality end
	_nStage = _nStage or 0
	_nStrengthLev = _nStrengthLev or 0
	_nTimeMode = _nTimeMode or 0
	_nExpiryTime = _nExpiryTime or 0	
	local bRet = C_PushThingstoKaiFuChouJiangBag(_idCharacter,_eActionType, _nItemCfgID, _nNum, true, _nQuality, _nRealm, _nStage, _nStrengthLev, _nTimeMode, _nExpiryTime)
	return bRet
end

--获取开服抽奖背包空间
function System_GetKaiFuChouJiangBagSpaceNum(_idCharacter)
	local nRet = C_GetKaiFuChouJiangBagSpaceNum(_idCharacter)
	return nRet
end
-- 将开服抽奖的物品当邮件发给玩家
function System_SendMailFromKaiFuChouJiangBag(_idCharacter,_nMailId)
	local bRet = C_SendMailFromKaiFuChouJiangBag(_idCharacter,_nMailId)
	return bRet
end
--取玩家姓名
function System_GetCharacterName(_idCharacter)
	local sRet = C_GetCharacterName(_idCharacter)
	return sRet
end
--发放广播
function System_SendCommonBroadCastMsg(_nBroadCastId,_Param)
	--表的话 转为string
	if  "table" == type(_Param ) then
        local bSpell,strParam = System_SpellSendCommonBroadMsgParam(_Param)
        if  false == bSpell then
            return false
        else
            _Param = strParam
        end
	end
	local bRet = C_SendCommonBroadCastMsg(_nBroadCastId,_Param)
	return bRet
end

-- 把广播的表转换成拼接好的字符串
-- @return false,nil / true,str
function System_SpellSendCommonBroadMsgParam(_tParamData)
    local strParam = ''
    for k,v in ipairs(_tParamData) do
        if  'table' ~= type(v) or 2 ~= (#v) then
            return false
        end

        local strTmp = ''
        if  ePreparedStatementValueType.TYPE_BOOL_1 == v[1] then
            local uSign = 0
            if  'boolean' == type(v[2]) then
                if  true == v[2] then uSign = 1 end
            else
                if  0 ~= v[2] then uSign = 1 end
            end
            strTmp = string.format('%d,%u',
                ePreparedStatementValueType.TYPE_BOOL_1,uSign)

        elseif  ePreparedStatementValueType.TYPE_UI8 == v[1] then
            strTmp = string.format('%d,%u',
                ePreparedStatementValueType.TYPE_UI8,v[2])

        elseif  ePreparedStatementValueType.TYPE_UI16 == v[1] then
            strTmp = string.format('%d,%u',
                ePreparedStatementValueType.TYPE_UI16,v[2])

        elseif  ePreparedStatementValueType.TYPE_UI32 == v[1] then
            strTmp = string.format('%d,%u',
                ePreparedStatementValueType.TYPE_UI32,v[2])

        elseif  ePreparedStatementValueType.TYPE_UI64 == v[1] then
            strTmp = string.format('%d,%u',
                ePreparedStatementValueType.TYPE_UI64,v[2])

        elseif  ePreparedStatementValueType.TYPE_I8 == v[1] then
            strTmp = string.format('%d,%d',
                ePreparedStatementValueType.TYPE_I8,v[2])            

        elseif  ePreparedStatementValueType.TYPE_I16 == v[1] then
            strTmp = string.format('%d,%d',
                ePreparedStatementValueType.TYPE_I16,v[2])  

        elseif  ePreparedStatementValueType.TYPE_I32 == v[1] then
            strTmp = string.format('%d,%d',
                ePreparedStatementValueType.TYPE_I32,v[2])  

        elseif  ePreparedStatementValueType.TYPE_I64 == v[1] then
            strTmp = string.format('%d,%d',
                ePreparedStatementValueType.TYPE_I64,v[2])

        elseif  ePreparedStatementValueType.TYPE_FLOAT == v[1] then
            strTmp = string.format('%d,%f',
                ePreparedStatementValueType.TYPE_FLOAT,v[2])

        elseif  ePreparedStatementValueType.TYPE_DOUBLE == v[1] then
            strTmp = string.format('%d,%f',
                ePreparedStatementValueType.TYPE_DOUBLE,v[2])            

        elseif  ePreparedStatementValueType.TYPE_STRING == v[1] then
            strTmp = string.format('%d,%s',
                ePreparedStatementValueType.TYPE_STRING,v[2])   

        else
            L2C_DebugLog('::System_SpellParam get a error type:'..tostring(v[1]))
            return false
        end
        
        if  '' == strParam then
            strParam = strTmp
        else
            strParam = strParam .. ';' .. strTmp
        end
    end
    return true,strParam
end

function System_LogCommonOA(_idCharacter,_sName,_Param)	
	--表的话 转为string
	if  "table" == type(_Param ) then
        local bSpell,strParam = System_SpellSendCommonBroadMsgParam(_Param)
        if  false == bSpell then
            return false
        else
            _Param = strParam
        end
	end
	local bRet = C_LogCommonOperationAnalysis(_idCharacter,_sName,_Param)
	return bRet
end


-- 获取排行榜信息
-- @_nTypeRank 排行榜类型(eRankListType)
-- @_nRank 第几名(c++ 从0开始计数,默认-1)
-- @return characterid(0为错误)
function System_GetRankInfo(_nTypeRank,_nRank)
    _nRank = _nRank - 1
    local bRet = C_GetRankListCharacterId(_nTypeRank,_nRank)
    return bRet
end

-- 触发一次任务检测
-- @_nType 触发的任务事件类型
function System_QuestCheck(_idCharacter,_nType,_nData3,_nData4,_nData5)
    _nData3 = _nData3 or 0
    _nData4 = _nData4 or 0
    _nData5 = _nData5 or 0
    local bRet = C_OnQuestCheck(_idCharacter,_nType,_nData3,_nData4,_nData5)   
    return bRet
end

-- 获得装备部位等级
-- @_nPart 某个装备部位
		-- eET_Begin = 101,
		-- eET_Head = eET_Begin,	//头
		-- eET_Body = 102,	//衣服
		-- eET_Arm = 103,	//护手
		-- eET_Legs = 104,	//护腿
		-- eET_Shoes = 105,	//鞋子
		-- eET_Gloves = 106,	//手套
		-- eET_Necklace = 107,	//项链
		-- eET_Ring = 108,	//戒指
		-- eET_Earrings = 109,	//耳坠
		-- eET_Belt = 110,	//腰带
function System_GetEquipPartStrengthLev(_idCharacter,_nPart)
	local nRet = C_GetEquipPartStrengthLev(_idCharacter,_nPart)
	return nRet
end

-- //// 获取超凡生死战当天最高的通关数
function System_GetCurDayHeroBattleId(_idCharacter)
	local nRet = C_GetCurDayHeroBattleId(_idCharacter)
	return nRet
end
-- ////  填满怒气
function System_FullCharacterAngry(_idCharacter)
	local bRet = C_FullCharacterAngry(_idCharacter)
	return bRet
end
-- // 是否有家族
function System_IsHaveGuild(_idCharacter)
	local bRet = C_IsHaveGuild(_idCharacter)
	return bRet
end
-- // 取角色创建天数
function System_GetCharacterCreateDay(_idCharacter)
	local nRet = C_GetCharacterCreateDay(_idCharacter)
	return nRet
end

-- 时间变化，增加或减少
-- 参数：_tabTime[年，月，日]	_costTime增加或减少的时间，单位秒	StrFromat格式，0=时分秒
-- 返回：字符串"年月日"，格式"000000"
function System_getStringTime(_tabTime,_costTime,_nModf)
	if "nil" == type(_tabTime[3]) then
		return nil
	end
	_costTime = tonumber(_costTime)
	if 0 ~= _costTime then
		local time_real = _tabTime[1]*60*60 + _tabTime[2]*60 + _tabTime[3]	
		time_real = math.max(time_real+_costTime, 0)
		local tab_nowtime = {}
		tab_nowtime[1] = math.modf(time_real/(60*60))
		tab_nowtime[2] = math.modf(math.max((time_real-(tab_nowtime[1]*60*60)),0)/(60))
		tab_nowtime[3] = math.modf(math.max((time_real-(tab_nowtime[1]*60*60)-(tab_nowtime[2]*60)),0))
		for k,v in pairs(tab_nowtime) do
			if 1 == string.len(v) then
				tab_nowtime[k] = "0"..v
			end
		end
		return math.modf(System_StrCatOnTable(tab_nowtime,"")/tonumber(_nModf))
	else
		return math.modf(System_StrCatOnTable(_tabTime,"")/tonumber(_nModf))
	end
end
	