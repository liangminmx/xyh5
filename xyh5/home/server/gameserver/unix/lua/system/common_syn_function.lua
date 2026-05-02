-- 发送首充团购信息 _idSendAll为true 就是同步所有玩家服务器人数
function System_Syn_Teamrecharge(_idCharacter,_serverTotalNum,_selfRechargeCount,_strSelfRewardStatus)
	if	nil ~= _idCharacter then
		_selfRechargeCount = _selfRechargeCount or 0
		_serverTotalNum = _serverTotalNum or 0
		_strSelfRewardStatus = _strSelfRewardStatus or ""
		local bRet = C_TeamRechargeMessgeSyn(_idCharacter,_serverTotalNum,_selfRechargeCount,_strSelfRewardStatus,false)
		return bRet
	else
		return false
	end
end

-- 首冲团购，返回操作结果 
function System_Syn_TeamRechargeGetRewardRet(_idCharacter,n64code,_nRewardId,_nRewardIndex)
	if	nil ~= _idCharacter then
		local bRet = C_TeamRechargeGetRewardRet(_idCharacter,n64code,_nRewardId,_nRewardIndex)
		return bRet
	else
		return false
	end
end

-- 同步首充团购团购人数给全服所有玩家
function System_Syn_Teamrecharge_ToAll(_idCharacter,_serverTotalNum)
    if  nil ~= _idCharacter then
        _serverTotalNum = _serverTotalNum or 0
        local bRet = C_TeamRechargeMessgeSyn(_idCharacter,_serverTotalNum,0,"",true)
		return bRet
    else
        return false
    end
end--发送元宝翻倍同步消息
function System_Syn_DoubleGold(_idCharacter,_rechargenum,_drawtimes)
	_rechargenum = _rechargenum or 0
	_drawtimes = _drawtimes or 0
	local bRet = C_DoubleGoldMessgeSyn(_idCharacter,_rechargenum,_drawtimes)
	return bRet
end

--发送元宝翻倍抽奖结果
function System_Syn_DoubleGold_DrawRet(_idCharacter,_code,_drawtimes,_multiple,_multipleNum)
	_code = _code or 1
	_drawtimes = _drawtimes or 0
	_multiple = _multiple or 0 
	_multipleNum = _multipleNum or 0
	local bRet = C_DoubleGoldMessgeDrawRet(_idCharacter,_code,_drawtimes,_multiple,_multipleNum)
	return bRet	
end
--发送寻宝奇遇同步信息
function System_Syn_AdventureMapMessage(_idCharacter,_type,_data1,_data2,_data3,_data4,_time,_str1,_str2,_float1,_float2)
	--发消息先屏蔽
	-- if 1 == 1 then return false end
	if _type < 0 then
		return	false
	end
	_data1 = _data1 or 0
	_data2 = _data2 or 0
	_data3 = _data3 or 0
	_data4 = _data4 or 0
	_time = _time or 0	
	_str1 = _str1 or ""
	_str2 = _str2 or ""
	_float1 = _float1 or 0.0
	_float2 = _float2 or 0.0
	-- L2C_DebugLog(string.format("System_Syn_AdventureMapMessage:_idCharacter[%s],_type[%s],_data1[%s],_data2[%s],_data3[%s],_data4[%s],_time[%s],_str1[%s],_str2[%s],_float1[%f],_float2[%f]",_idCharacter,_type,_data1,_data2,_data3,_data4,_time,_str1,_str2,_float1,_float2))
	local bRet = C_AdventureMapMessage(_idCharacter,_type,_data1,_data2,_data3,_data4,_time,_str1,_str2,_float1,_float2)
	return bRet
end

-- 元宝免费送同步信息给客户端
function System_Syn_GetEmoneyMessage(_idCharacter,_nTotalMoney,_nRewardStatus,_nRechargeStatus,_nOpenDay,_nOverDay,_strTotalNum)
   local bRet = C_GetEmoneyMessage(_idCharacter,_nTotalMoney,_nRewardStatus,_nRechargeStatus,_nOpenDay,_nOverDay,_strTotalNum) 
   return bRet
end

-- 元宝免费送同步指定信息给客户端
function System_Syn_GetEmoneySynProcess(_idCharacter,_nType,_nValue)
    local bRet = C_GetEmoneySynProcess(_idCharacter,_nType,_nValue)
    return bRet
end

-- 元宝免费送的主动记录经分
function System_Log_GetEmoney(_idCharacter,_nTotalOnLine,_nOnLineEmoney,_nTotalActive,_nActiveEmoney,_nTotalBoss,_nBossEmoney)
    local bRet = C_GetEmoneyLogOper(_idCharacter,_nTotalOnLine,_nOnLineEmoney,_nTotalActive,_nActiveEmoney,_nTotalBoss,_nBossEmoney)
    return bRet
end

-- 连充返利，推送所有消息
function System_Syn_Charge_Rebate_All(_idCharacter,_nTodayRechargeNum,_nRechargeDays,_strRewardStatus,_strRewardDays)
    local bRet = C_ChargeRebateMessage(_idCharacter,_nTodayRechargeNum,_nRechargeDays,_strRewardStatus,_strRewardDays)
    return bRet
end

-- 连充返利,经分
-- @_nRecharge 该字段没用了
function System_Log_Charge_Rebate(_idCharacter,_nDays,_nId ,_nRecharge)
   local  bRet = C_ChargeRebateLogOper(_idCharacter,_nDays,_nId ,_nRecharge)
   return bRet
end

-- ==========================================================================================
--      =========================  开服抽奖  ============================================
--  开服抽奖活动状态
--  @_nParentId 选择的玩法 
--  @_nGroupId 当前开启的活动的 id
function System_KaiFuChouJiang_Syn_ActiveStatus(_idCharacter,_nStatus,_nParentId,_nHadFree,_nAllFree,_nGroupId,nDayId)   
    local bRet = C_KaiFuChouJiangSendActiveSyn(_idCharacter,_nStatus,_nParentId,_nHadFree,_nAllFree,_nGroupId,nDayId)
    return bRet
end

-- 开服抽奖抽奖结果
--  @_nCode 结果
--  @_nRollTimes 抽奖的次数
--  @_nParentId 伙伴id(玩法)
--	@_nScore 积分
--  @_strGet 获得的物品
function System_KaiFuChouJiang_Syn_RollRet(_idCharacter,_nCode,_nRollTimes,_nParentId,_nScore,_strGet)
    local bRet = C_KaiFuChouJiangSendDrawRet(_idCharacter,_nCode,_nRollTimes,_nParentId,_nScore,_strGet)
    return bRet
end

-- 开服抽奖，兑换商店信息
function System_KaiFuChouJiang_Syn_ShopStatus(_idCharacter,_nScore,_strGet)
    local bRet = C_KaiFuChouJiangSendShopSynRet(_idCharacter,_nScore,_strGet)
    return bRet
end

-- 开服抽奖，抽奖获得物品的经分
--  @_nRollTimes 抽奖的次数
--	@_nTotalTimes 总抽奖次数
function System_KaiFuChouJiang_Log_Roll(_idCharacter,_nRollTimes,_nTotalTimes,_strGet,nDayId)
   local bRet = C_KaiFuChouJiangLogDraw(_idCharacter,_nRollTimes,_nTotalTimes,_strGet,nDayId)
   return bRet 
end

-- 开服抽奖，商店兑换物品的经分
function System_KaiFuChouJiang_Log_Shop(_idCharacter,_nItemId,_nExchangeTimes,_nScoreBefore,_nScoreAfter)
    local bRet = C_KaiFuChouJiangLogExchange(_idCharacter,_nItemId,_nExchangeTimes,_nScoreBefore,_nScoreAfter)
    return bRet
end

-- 开服抽奖，广播的
--  @_nParentId 伙伴id(玩法)
--  @_nPosWantWorld 要广播的物品的pos

function System_KaiFuChouJiang_Syn_ToAll(_idCharacter,_nParentId,_nPosWantWorld,_nWorthMsg)
    local bRet = C_KaiFuChouJiangAddLogAndBroadcast(_idCharacter,_nParentId,_nPosWantWorld,_nWorthMsg)
    return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  GM 开启开服抽奖  ============================================
--  GM 开服抽奖 活动状态
--  @_nParentId 选择的玩法 gm 活动这个值是 0
function System_GM_ChouJiang_Syn_ActiveStatus(_idCharacter,_nStatus,_nParentId,_nHadFree,_nAllFree,_nGroupId,nDayId)    
    local bRet = C_GMKaiFuChouJiangSendActiveSyn(_idCharacter,_nStatus,_nParentId,_nHadFree,_nAllFree,_nGroupId,nDayId)
    return bRet
end

--  GM 抽奖抽奖结果
--  @_nCode 结果
--  @_nRollTimes 抽奖的次数
--  @_nParentId 伙伴id(玩法)  gm 活动这个值是 0
--	@_nScore 积分
--  @_strGet 获得的物品
function System_GM_ChouJiang_Syn_RollRet(_idCharacter,_nCode,_nRollTimes,_nParentId,_nScore,_strGet)
    local bRet = C_GMKaiFuChouJiangSendDrawRet(_idCharacter,_nCode,_nRollTimes,_nParentId,_nScore,_strGet)
    return bRet
end

-- GM 抽奖活动的，兑换商店信息
function System_GM_ChouJiang_Syn_ShopStatus(_idCharacter,_nScore,_strGet)
    local bRet = C_GMKaiFuChouJiangSendShopSynRet(_idCharacter,_nScore,_strGet)
    return bRet
end

--  GM 抽奖活动的，抽奖获得物品的经分
--  @_nRollTimes 抽奖的次数
--	@_nTotalTimes 总抽奖次数
function System_GM_ChouJiang_Log_Roll(_idCharacter,_nRollTimes,_nTotalTimes,_strGet,nDayId)
   local bRet = C_GMKaiFuChouJiangLogDraw(_idCharacter,_nRollTimes,_nTotalTimes,_strGet,nDayId)
   return bRet 
end

-- GM 抽奖活动的，商店兑换物品的经分
function System_GM_ChouJiang_Log_Shop(_idCharacter,_nItemId,_nExchangeTimes,_nScoreBefore,_nScoreAfter)
    local bRet = C_GMKaiFuChouJiangLogExchange(_idCharacter,_nItemId,_nExchangeTimes,_nScoreBefore,_nScoreAfter)
    return bRet
end

--  GM 抽奖，广播的
--  @_nParentId 伙伴id(玩法)    GM 活动都发 0 
--  @_nPosWantWorld 要广播的物品的pos
function System_GM_ChouJiang_Syn_ToAll(_idCharacter,_nParentId,_nPosWantWorld,_nWorthMsg)    
    local bRet = C_GMKaiFuChouJiangAddLogAndBroadcast(_idCharacter,_nParentId,_nPosWantWorld,_nWorthMsg)
    return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  图鉴任务  ============================================
--  同步包
function System_Pokedex_Syn_All(_idCharacter,_nFlag,_nToDayDo,_nChapterId,_nMonsterId,_nProgess,_nCompleteAll)
    local bRet = C_processPokedexInfoSyn(_idCharacter,_nFlag,_nToDayDo,_nChapterId,_nMonsterId,_nProgess,_nCompleteAll)
    return bRet;
end

-- 一键完成任务会包
function System_Pokedex_Syn_Complete(_idCharacter,_nCode,_nCount,_nChapterId,_nAfterCount)
    local bRet = C_processPokedexComplete(_idCharacter,_nCode,_nCount,_nChapterId,_nAfterCount)
    return bRet;
end

-- 记录经分
function System_Pokedex_Log(_idCharacter,_nLevel,_nCount,_nCompleteType,_nCompleteCount)
    local bRet = C_writeLogPokedex(_idCharacter,_nLevel,_nCount,_nCompleteType,_nCompleteCount)
    return bRet;
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  土豪福利活动  ============================================

-- 开启活动返回包
function System_RichWelfare_Open_Syn(_idCharacter,_nCode)
    local bRet = C_richWelfareOpenSyn(_idCharacter,_nCode)
    return bRet
end

-- 同步活动信息包
-- @_nStatus 按照位存的子活动的状态，0为活动全关
-- @_strMaxlevel 字符串存的，服务器最高等级 'x,x,x'
function System_RichWelfare_Info_Syn(_idCharacter,_nStatus,_strMaxlevel)
    local bRet = C_richWelfareInfoSyn(_idCharacter,_nStatus,_strMaxlevel)
    return bRet
end

-- 写经分
-- @_nActiveType 当日主题活动id
-- @_nLevelId 领取的奖励id 
function System_RichWelfare_Log(_idCharacter,_nActiveType,_nLevelId)
    local bRet = C_richWelfareLog(_idCharacter,_nActiveType,_nLevelId)
    return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  开服基金活动  ============================================
function System_KaifujijinInfoSyn(_idCharacter,_nFundid,_nLevel)
	local bRet = C_KaifujijinInfoSyn(_idCharacter,_nFundid,_nLevel)
	return bRet
end

-- ==========================================================================================

-- ==========================================================================================
--   =========================  GM刷怪活动  ============================================
function System_Festival_Monster_Gm(_nOpen,_nGroupId,_nBeginTime,_nEndTime)
    local bRet = C_GM_FestivalMonster_instance_ToC_Open(_nOpen,_nGroupId,_nBeginTime,_nEndTime)
    return bRet
end

function System_Festival_Monster_Log(_idCharacter,_nLevel,_nGroupId,_strReward)
    local bRet = C_GM_FestivalMonster_instance_WriteLog(_idCharacter,_nLevel,_nGroupId,_strReward)
    return bRet
end

-- ==========================================================================================


-- ==========================================================================================
--   =========================  运营活动  ============================================
function System_Festival_Web(_idCharacter,nGroup)
	local bRet = C_GM_FestivalWeb_Syn(_idCharacter,nGroup)
	return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  登录活动  ============================================
function System_Festival_Login_Syn(_idCharacter,nGroup,nActiveStatus,nBeg,nEnd,nAwardStatus)
	local bRet = C_GM_FestivalLogin_Syn(_idCharacter,nGroup,nActiveStatus,nBeg,nEnd,nAwardStatus)
	return bRet
end

function System_Festival_Login_Award(_idCharacter,nGroup,nCode)
	local bRet = C_GM_FestivalLogin_Award(_idCharacter,nGroup,nCode)
	return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  幸运竞猜  ============================================
function System_XingYunJingCai_Syn(_idCharacter,nGroup,nTimes, times_total, min_base, max_base, min_now, max_now, strData)
	local bRet = C_GM_XingYunJingCai_Syn(_idCharacter,nGroup,nTimes, times_total, min_base, max_base, min_now, max_now, strData)
	return bRet
end

function System_XingYunJingCai_Guess(_idCharacter, nCode, min_now, max_now)
	local bRet = C_GM_XingYunJingCai_Guess(_idCharacter, nCode, min_now, max_now)
	return bRet 
end

function System_XingYunJingCai_Buy(_idCharacter,nCode,_total_num)
	local bRet = C_GM_XingYunJingCai_Buy(_idCharacter,nCode,_total_num)
	return bRet
end

function System_XingYunJingCai_LogAward(_idCharacter,nType)
	local bRet = C_GM_XingYunJingCai_Log(_idCharacter, nType)
	return bRet 
end

function System_XingYunJingCai_SendStatus(_idCharacter,status,groupid,nBegin,nEnd)
	local bRet = C_GM_XingYunJingCai_SendStatus(_idCharacter,status,groupid,nBegin,nEnd)
	return bRet 
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  限时特惠  ============================================
function System_XianShiTeHuiSyn(_idCharacter,_sStatus)
	local bRet = C_XianShiTeHuiSyn(_idCharacter,_sStatus)
	return bRet
end
function System_XianShiTeHuiBuy(_idCharacter,_code,_options,_id)
	local bRet = C_XianShiTeHuiBuy(_idCharacter,_code,_options,_id)
	return bRet
end
function System_XianShiTeHuiLog(_idCharacter,_options,_id,_status)
	local bRet = C_XianShiTeHuiLog(_idCharacter,_options,_id,_status)
	return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  冲级比拼  ============================================
function System_ChongJiBiPinSynSelf(_idCharacter,_sStatus)
	local bRet = C_ChongJiBiPinSynSelf(_idCharacter,_sStatus)
	return bRet
end

function System_ChongJiBiPinSynGlobal(_idCharacter,_sInfo)
	local bRet = C_ChongJiBiPinSynGlobal(_idCharacter,_sInfo)
	return bRet
end

function System_ChongJiBiPin_RewardRet(_idCharacter,_code,_reqLev)
	local bRet = C_ChongJiBiPinRewardRet(_idCharacter,_code,_reqLev)
	return bRet
end

function System_BroadCastChongJiBiPinRewardZero(_idCharacter,_zeroLev)
	local bRet = C_BroadCastChongJiBiPinRewardZero(_idCharacter, _zeroLev)
	return bRet
end

function System_ChongJiBiPinLog(_idCharacter, _nLevReq, _isByMail)
	local bRet = C_ChongJiBiPinLog(_idCharacter, _nLevReq, _isByMail)
	return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  争夺夏都  ============================================
function System_ZhengDuoXiaDuSynSelf(_idCharacter,_nCanReward,nHasGetReward)
	local bRet = C_ZhengDuoXiaDuSynSelf(_idCharacter,_nCanReward,nHasGetReward)
	return bRet
end

function System_ZhengDuoXiaDu_RewardRet(_idCharacter,_nCode)
	local bRet = C_ZhengDuoXiaDuRewardRet(_idCharacter,_nCode)
	return bRet
end
-- ==========================================================================================


-- ==========================================================================================
--   =========================  每日拍卖会  ============================================
function System_PaiMaiSyn(_idCharacter,activeid, strData, self_price, idCurCharacter)
	local bRet = C_PaiMaiSyn(_idCharacter,activeid, strData, self_price, idCurCharacter)
	return bRet
end

function System_PaiMaiSyn_Windows(_idCharacter,_rewardIds,_curPrices)
	local bRet = C_PaiMaiSyn_Windows(_idCharacter,_rewardIds, _curPrices)
end


function System_PaiMaiOffer(_idCharacter,code, activeid, id, price)
	local bRet = C_PaiMaiOffer(_idCharacter,code, activeid, id, price)
	return bRet
end

function System_PaiMaiLogOfferInfo(_idCharacter,rechange_jetton, after_jetton, rechange_jetton)
	local bRet = C_PaiMaiLogOfferInfo(_idCharacter,rechange_jetton, after_jetton, rechange_jetton)
	return bRet
end

function System_PaiMaiLogGetItem(_idCharacter,activity, id, getitemid)
	local bRet = C_PaiMaiLogGetItem(_idCharacter, activity, id, getitemid)
	return bRet
end

function System_PaiMaiSendEndInfo(_idCharacter, self_price, idCurCharacter)
	local bRet = C_PaiMaiSendEndInfo(_idCharacter, self_price, idCurCharacter)
	return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  开服进阶返利  ============================================
function System_OpenAdvanceDaySyn(_idCharacter, activeid, rewardLevel)
	local bRet = C_OpenAdvanceDaySyn(_idCharacter, activeid, rewardLevel)
	return bRet 
end

function System_OpenAdvanceDayReward(_idCharacter,code, activeid, level)
	local bRet = C_OpenAdvanceDayReward(_idCharacter,code, activeid, level)
	return bRet 
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  开服投资  ============================================
function System_KaiFuTouZiSyn(_idCharacter, fundid, reward)
	local bRet = C_KaiFuTouZiSyn(_idCharacter, fundid, reward)
	return bRet
end

function System_KaiFuTouZiReward(pCharacter, code, fundid, reward)
	local bRet = C_KaiFuTouZiReward(pCharacter, code, fundid, reward)
	return bRet
end
-- ==========================================================================================

-- ==========================================================================================
--   =========================  节日消费  ============================================
function System_FestivalConsumeSendInfoRet(_idCharacter, _nConsumenum, _sRewardStatus)
	local bRet = C_FestivalConsumeSendInfoRet(_idCharacter, _nConsumenum, _sRewardStatus)
	return bRet
end

function System_FestivalConsumeSendGetRewardRet(_idCharacter, _nCode, _nRewardId, _nNum, _nConsumenum, _nGroupId)
	local bRet = C_FestivalConsumeSendGetRewardRet(_idCharacter, _nCode, _nRewardId, _nNum, _nConsumenum, _nGroupId)
	return bRet
end
function System_FestivalConsumeSynPlayerCostNum(_idCharacter, _nConsumenum)
	local bRet = C_FestivalConsumeSynPlayerCostNum(_idCharacter, _nConsumenum)
	return bRet
end
function System_FestivalConsumeActivityInfo(_idCharacter, _nBeginTime, _nEndTime, nGroupId)
	local bRet = C_FestivalConsumeActivityInfo(_idCharacter, _nBeginTime, _nEndTime, nGroupId)
	return bRet
end
-- ==========================================================================================