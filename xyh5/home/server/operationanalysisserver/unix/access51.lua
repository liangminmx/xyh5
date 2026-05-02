require "globalvalue"
--360



function access_51(type, datavalue)
	local g_51_post_url = "gameapi.51.com/role_level/level_push"
	local g_51_game_id = "366"
	local g_51_secret_key = "5264ea4d31b23c4c00f6f98b18336064"

	local newtable = {}
	if g_http_post_type[type] == "eHPT_upgradelog" or g_http_post_type[type] == "eHPT_Register" then		--360อฦหอ
		newtable["areasign"] = datavalue["sid"]
		newtable["game_id"] = g_51_game_id
		local account = datavalue["accountName"]
		newtable["user"] = string.sub(account,string.find(account,"_") + 1)
		newtable["t"] = datavalue["createDate"]
		newtable["level"] = datavalue["newlevel"]
		newtable["authkey"] = luaMD5String(newtable["game_id"] .. newtable["areasign"] .. newtable["user"] .. newtable["t"] .. newtable["level"] .. g_51_secret_key)

		luaCurlRequest(g_51_post_url,"","http","post",newtable)
	end

end
