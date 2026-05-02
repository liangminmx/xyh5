--全局变量文件

--数据库信息
g_DBIP = {}
g_DBLoginName = {}
g_DBPassword = {}
g_DBName = {}
g_DBPort = {}

--平台信息
g_VersionTable = {
	[1] = "VERSION_LAN",
	[2] = "VERSION_TENCENT",
	[3] = "VERSION_360",
	[4] = "VERSION_RELEASE",
	[5] = "VERSION_LEGANG",--乐港
	[6] = "VERSION_yy",
	[7] = "VERSION_sougou",
	[8] = "VERSION_shunwang",
	[9] = "VERSION_51",
	[10] = "VERSION_xunlei",
	[11] = "VERSION_7k7k",
	[12] = "VERSION_4399",
	[13] = "VERSION_9377",
	[14] = "VERSION_pps",
	[15] = "VERSION_baidu",
	[16] = "VERSION_pptv",
	[17] = "VERSION_3595",
	[18] = "VERSION_gemen",
	[19] = "VERSION_bianfeng",
	[20] = "VERSION_kugou",
	[21] = "VERSION_douyu",
}

--类型对应数据库表明
g_typeToDBExcelName = {
	[1] = "t_user",
	[2] = "t_player",
	[3] = "t_recharge",
	[4] = "t_upgradelog",
	[5] = "t_newtask",
	[6] = "t_login",
	[7] = "t_offline",
	[8] = "t_online",
	[9] = "t_moneylog",
}

--罗盘url
g_compass_url = "tencentlog.com/stat/"
g_compass_script = {
	[51] = "report_login.php",
	[52] = "report_register.php",
	[53] = "report_consume.php",
	[54] = "report_recharge.php",
	[55] = "report_quit.php",
	[56] = "report_online.php",
}
g_tencent_app_id = "1106618632"

--推送类型
g_http_post_type = {
	[1] = "eHPT_User",
	[2] = "eHPT_Player",
	[3] = "eHPT_Recharge",
	[4] = "eHPT_upgradelog",
	[5] = "eHPT_newtask",
	[6] = "eHPT_login",
	[7] = "eHPT_offline",
	[8] = "eHPT_online",
	[9] = "eHPT_moneylog",
	[10] = "eHPT_Register",
	[11] = "eHPT_Combat",

	[101] = "eHPT_UnionRegisterExtra",
}


function initXML(serverid_,dbip_,loginname_,password_,dbname_,dbport_)

	g_DBIP[serverid_] = dbip_
	g_DBLoginName[serverid_] = loginname_
	g_DBPassword[serverid_] = password_
	g_DBName[serverid_] = dbname_
	g_DBPort[serverid_] = dbport_
	print(serverid_,dbip_,loginname_,password_,dbname_,dbport_)
end

function getDBCfg(serverid_)
	return g_DBIP[serverid_],g_DBLoginName[serverid_],g_DBPassword[serverid_],g_DBName[serverid_],g_DBPort[serverid_]
end


function getExcelNameByType(execlType)
	return g_typeToDBExcelName[execlType]
end


function getVersionName(version)
	return g_VersionTable[version]
end



