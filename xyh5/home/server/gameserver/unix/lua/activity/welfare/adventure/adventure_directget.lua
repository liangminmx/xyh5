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
local	eAMLT_DirectGetSyn = 18 --	//直接领奖同步
local	eAMLT_DirectGetReq = 19 --	//直接领奖请求
-- };



local nResId = CRESOURCEFLOWACTION.eFT_AdventureMap_DirctGet			-- 资源流向id
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]			-- 活动掩码id

-- local tDirectGetInfo =   _adventure_Info["Root"][1]["adventure"][1]["completion"][1]
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_DirctGet_Login(_idCharacter,_nOsTimes)
	Adventure_DirctGet_Syn(_idCharacter)
end
-- table.insert(tOnLoginActivity,Adventure_DirctGet_Login)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--0点重置
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_DirctGet_ZeroReset(_idCharacter,_nOsTimes)		
	if System_IsExistTempData(_idCharacter,nLuaIdActivity) then	
		System_SetTempData(_idCharacter,nLuaIdActivity,1,0)
	end
	Adventure_DirctGet_Syn(_idCharacter)
end
-- table.insert(tOnZeroTrigger,Adventure_DirctGet_ZeroReset)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	同步领奖信息
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Adventure_DirctGet_Syn(_idCharacter)
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity,false)		
	end
	local status = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	System_Syn_AdventureMapMessage(_idCharacter,eAMLT_DirectGetSyn,status)
end

function Adventure_DirctGet_processReqMain(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	if eAMLT_DirectGetReq == _nData1 then
		return Adventure_DirctGet_processAward(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)
	end
	return eAMRC_Unknow
end
-- tOnOnAcitveAward[nResId] = Adventure_DirctGet_processReqMain

function Adventure_DirctGet_processAward(_idCharacter,_nCActionType,_nData1,_nData2,_nData3)	
	local status = System_GetTempData(_idCharacter,nLuaIdActivity,1)
	if status ~= 0 then
		return eAMRC_HasReward
	end

	local nViplev = System_GetVipLevel(_idCharacter)
	if "number" ~= type(tDirectGetInfo.viplv)  or tDirectGetInfo.viplv > nViplev then
		return eAMRC_VipLess
	end
	
	if true == Adventure_IsDoToday(_idCharacter) then
		return eAMRC_HasGetMap
	end
	
	if "table" ~= type(tDirectGetInfo.reward) then
		return eAMRC_Unknow
	end
	local itemStr = ""
	for k,v in pairs(tDirectGetInfo.reward)do
		local nItemId = v["itemid"]
		local nNum = v["num"]			
		itemStr = itemStr .. tostring(nItemId) .. "," .. tostring(nNum) .. ";"
	end
	if false == System_CanPushThingsToBagEx(_idCharacter,itemStr) then
		return eAMRC_BagNotEnough
	end
	
	if "number" ~= type(tDirectGetInfo.cost) or false == System_SpendEmoney(_idCharacter,tDirectGetInfo.cost,_nCActionType) then
		return eAMRC_NoEMoney
	end
	
	System_SetTempData(_idCharacter,nLuaIdActivity,1,1)
	
	for k,v in pairs(tDirectGetInfo.reward)do
		local nItemId = v["itemid"]
        local nNum = v["num"]
		-- //绑定这个属性没用了啊 策划为什么要用
		-- local bBind = v["bind"] == "" and 0 or v["bind"]
        System_AwardThingInBag(_idCharacter,nResId,nItemId,nNum)
	end
	Adventure_DirctGet_Syn(_idCharacter)
	return eAMRC_Success
end
--今天是否已经接过宝图任务了
function Adventure_DirctGet_Is_GetAward(_idCharacter)
	if 1 == System_GetTempData(_idCharacter,nLuaIdActivity,1) then
		return true
	else	
		return false
	end
end
--修改活动状态
function Adventure_DirctGet_Set_Status(_idCharacter,_nStatus)
	if 0 == System_GetTempData(_idCharacter,nLuaIdActivity,1) then
		System_SetTempData(_idCharacter,nLuaIdActivity,1,_nStatus)
		Adventure_DirctGet_Syn(_idCharacter)
	end
end