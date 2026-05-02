eOfflineExpMsgcode = {
	eOEM_Unknow = 0,
	eOEM_Success = 1,
	eOEM_Errid = 2,
	eOEM_VipLevNotEnough = 3,
	eOEM_EmoneyNotEnough = 4,
	eOEM_NothingCanGet = 5,
}

local nResId = CRESOURCEFLOWACTION.eFT_OfflineExp_Exp
local nLuaIdActivity = LUARESOURCEFLOWACTION[nResId]
local functionId = _offexp_Info["config"][1]["functionid"][1]["functionid"]
local tOffExp = _offexp_Info["config"][1]["offexp"][1]
local tLimit = _offexp_Info["config"][1]["limit"][1]["condition"]


-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	玩家登入离线奖励的时候
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function OnLogin_OffLineExp(_idCharacter,_nOsTimes)
	if	false == System_IsExistTempData(_idCharacter,nLuaIdActivity) then
		System_AddTempData(_idCharacter,nLuaIdActivity)
	end
end
table.insert(tOnLoginActivity,OnLogin_OffLineExp)

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	申请领取离线经验奖励
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ProcessGetOfflineExpReq(_idCharacter,_nCActionType,_nExpId,_nOfflineMinutes,_nVipLv)
	if	nil == _idCharacter or nil == _nCActionType or nil == _nExpId or nil == _nOfflineMinutes or nil == _nVipLv then
		L2C_DebugLog("::ProcessGetOfflineExpReq Error :("..(_idCharacter or "nil").."|"..(_nCActionType or nil).."|"..(_nExpId or "nil").."|"..(_nOfflineMinutes or "nil").."|"..(_nVipLv or "nil")..")")
		return eOfflineExpMsgcode.eOEM_Unknow
	end
	
	if	_nCActionType ~= nResId then
		return eOfflineExpMsgcode.eOEM_Unknow
	end
	
	-- 根据当前vip，取得可以领取几倍奖励
	local nSelectKey = Get_OffLineExp_Multi(_nVipLv)
	if	"table" ~= type(tLimit[nSelectKey]) then
		L2C_DebugLog("::ProcessGetOfflineExpReq Error : Lua Data Wrong in limit Data!!!,nSelectKey: "..nSelectKey)
		return eOfflineExpMsgcode.eOEM_Unknow
	end
	
	-- 判断要领取的倍数对不对(客户端发的 _nExpId 是要领取1,2,3倍奖励)
	if	_nExpId ~= tLimit[nSelectKey]["multiple"] then
		return eOfflineExpMsgcode.eOEM_Errid
	end
	
	-- 最大的离线计算时间
	if	_nOfflineMinutes > tOffExp["offtimemax"] then
		_nOfflineMinutes = tOffExp["offtimemax"]
	end
	
	-- 判断表里有没有配置当前玩家等级的离线奖励
	local nCharacterLevel = System_GetAttrInt(_idCharacter,CHARACTER_INT.LEVEL)
	if	"number" ~= type(tOffExp["offexpinfo"][nCharacterLevel]["getexp"]) then
		L2C_DebugLog("::ProcessGetOfflineExpReq Error : Lua Data Wrong in getexp !!!")
		return eOfflineExpMsgcode.eOEM_Unknow 
	end
	
	local nGetExp = tOffExp["offexpinfo"][nCharacterLevel]["getexp"]
	nGetExp = _nOfflineMinutes * tLimit[nSelectKey]["multiple"] * nGetExp

	-- 判断要消耗的钱够不够
	if	"number" == type(tLimit[nSelectKey]["emoney"] ) and tLimit[nSelectKey]["emoney"]  > 0 then
		if	false == System_SpendEmoney(_idCharacter,tLimit[nSelectKey]["emoney"],nResId) then
			return eOfflineExpMsgcode.eOEM_EmoneyNotEnough
		end
	end
	
	-- 判断条件以满足，发放离线经验了
	-- L2C_DebugLog("::ProcessGetOfflineExpReq send off line exp to (".._idCharacter.."|"..nGetExp..")")
	System_AwardExp(_idCharacter,nGetExp,nResId)
	return eOfflineExpMsgcode.eOEM_Success
end
tOnOnAcitveAward[nResId] = ProcessGetOfflineExpReq

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--	c++ 找lua要数据的函数
--	得到离线奖励的 最大计算时间
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function Process_OffLineExp_MaxTime(_nData1,_nCActionType,_nData3,_nData4,_nData5)
	if	_nCActionType ~= nResId then
		L2C_DebugLog("::Process_OffLineExp_MaxTime Error Type Get Data From Lua !!!")
		return -1
	end
	
	if	"number" == type(tOffExp["offtimemax"]) then
		return tOffExp["offtimemax"]
	else
		L2C_DebugLog("::Process_OffLineExp_MaxTime not this data")
		return -1
	end
end
tGetActivityData[nResId] = Process_OffLineExp_MaxTime
-- =================================================================
--	根据玩家当前vip等级，获得可以得到几倍奖励和消耗
-- =================================================================
function Get_OffLineExp_Multi(_nVipLv)

	local nowSelectLevel = 0
	local selectKey = 0
	for	k,v in pairs(tLimit) do
		if	_nVipLv >= v["vip"] and nowSelectLevel <= v["vip"] then
			selectKey = k
			nowSelectLevel = v["vip"]
		end
	end
	return selectKey
end







