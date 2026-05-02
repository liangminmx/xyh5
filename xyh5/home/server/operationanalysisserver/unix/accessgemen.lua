require "globalvalue"
--gemen


function access_gemen(type, datavalue)
	local g_gemen_post_url = "api.mas.g2.cn/updatePlayerInfo.php"
	local g_gemen_game_key = "mhj"
	local g_gemen_pid = 1
	local g_gemen_login_key = "nCzePN3wM4WHLO1c6AGjSBXboU8EDt2s"
	local g_gemen_toptype = "战斗力"

	local newtable = {}
	if g_http_post_type[type] == "eHPT_upgradelog" or g_http_post_type[type] == "eHPT_Register"
		or g_http_post_type[type] == "eHPT_login" then		--360推送

		if datavalue["playerName"] == "" then
			return ;
		end
		newtable["server_id"] = datavalue["sid"]
		newtable["gkey"] = g_gemen_game_key
		newtable["pid"] = g_gemen_pid
		newtable["toptype"] = g_gemen_toptype
		newtable["topvalue"] = datavalue["combat"]
		if g_http_post_type[type] == "eHPT_Register" then
			newtable["type"] = "1"
		else
			newtable["type"] = "0"
		end

		local account = datavalue["accountName"]
		newtable["qid"] = string.sub(account,string.find(account,"_") + 1)
		newtable["name"] = datavalue["playerName"]
		if g_http_post_type[type] == "eHPT_login" then
			newtable["level"] = datavalue["playerLevel"]
		else
			newtable["level"] = datavalue["newlevel"]
		end

		newtable["playid"] = datavalue["playerId"]
		newtable["regdate"] = datavalue["createDate"]

		newtable["sign"] = luaMD5String(newtable["gkey"] .. newtable["level"]
			.. newtable["name"] .. newtable["playid"] .. newtable["qid"]
			.. newtable["regdate"] .. newtable["server_id"] .. newtable["toptype"]
			.. newtable["topvalue"] .. newtable["type"] .. g_gemen_login_key)
		newtable["sign"] = string.lower(newtable["sign"])

		luaCurlRequest(g_gemen_post_url,"","http","get",newtable)
	end

end

