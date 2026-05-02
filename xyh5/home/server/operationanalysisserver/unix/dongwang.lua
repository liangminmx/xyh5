-- require "luasql.mysql"

--动网数据处理方法文件

--存库
function saveDB(serverid,sqlstr)

-- env = luasql.mysql()
--_DBIP,_DBLoginName,_DBPassword,_DBName,_DBPort = getDBCfg(serverid)
--print(_DBName,_DBLoginName,_DBPassword,_DBIP,_DBPort)
--conn = env:connect(_DBName,_DBLoginName,_DBPassword,_DBIP,_DBPort)
-- conn = env:connect("oa_dev","root","123","192.168.1.111",3306)
--conn:execute([[set names utf8]])
-- print(conn:execute(sqlstr))

-- close everything
-- conn:close()
-- env:close()

end

--table转sql语句
function dongwanggetsql(datavalue,tablename)
	prestr = "insert into " .. tablename
	resqlstr = ""

	if tablename == 't_user' then
		resqlstr = prestr ..' (sid,playerId,accountName,playerlevel,platform,createTime,via,subactivityid,loginsrc) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerlevel']..'","'..datavalue['platform']..'","'..datavalue['createTime']..'","'..datavalue['activityid']..'","'..datavalue['subactivityid']..'","'..datavalue['loginsrc']..'");'
	elseif tablename == 't_player' then
		resqlstr = prestr ..' (sid,playerId,accountName,playerName,playerlevel,platform,via,subactivityid,createTime,loginsrc) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['playerlevel']..'","'..datavalue['platform']..'","'..datavalue['activityid']..'","'..datavalue['subactivityid']..'","'..datavalue['createTime']..'","'..datavalue['loginsrc']..'");'
	elseif tablename == 't_recharge' then
		resqlstr = prestr .. ' (sid,playerId,accountName,playerName,playerlevel,transactionId,money,gold,exchangeType,gDepay,amt,payamt_coins,pubacct_payamt_coins,createDate,loginsrc,pf,activity,subactivity) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['playerlevel']..'","'..datavalue['transactionId']..'","'..datavalue['money']..'","'..datavalue['gold']..'","'..datavalue['exchangeType']..'","'..datavalue['gDepay']..'","'..datavalue['amt']..'","'..datavalue['payamt_coins']..'","'..datavalue['pubacct_payamt_coins']..'","'..datavalue['createDate']..'","'..datavalue['loginsrc']..'","'..datavalue['pf']..'","'..datavalue['activity']..'","'..datavalue['subactivity']..'");'
	elseif tablename == 't_upgradelog' then
		resqlstr = prestr .. ' (sid,playerId,accountName,playerName,oldlevel,newlevel,sucess,upgradeType,createDate) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['oldlevel']..'","'..datavalue['newlevel']..'","'..datavalue['sucess']..'","'..datavalue['upgradeType']..'","'..datavalue['createDate']..'");'
	elseif tablename == 't_newtask' then
		resqlstr = prestr .. ' (sid,playerId,accountName,playerName,taskId,status,quality,createDate) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['taskId']..'","'..datavalue['status']..'","'..datavalue['quality']..'","'..datavalue['createDate']..'");'
	elseif tablename == 't_login' then
		if  datavalue['playerName'] == nil then
			datavalue['playerName'] = ""
		end
		resqlstr = prestr ..' (sid,playerId,accountName,playerName,playerlevel,platform,Ip,createDate) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['playerLevel']..'","'..datavalue['platform']..'","'..datavalue['Ip']..'","'..datavalue['createDate']..'");'
	elseif tablename == 't_offline' then
		resqlstr = prestr ..' (sid,playerId,accountName,playerName,playerlevel,platform,Ip,onlineTime,historyOnline,createDate) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['playerLevel']..'","'..datavalue['platform']..'","'..datavalue['Ip']..'","'..datavalue['onlineTime']..'","'..datavalue['historyOnline']..'","'..datavalue['createDate']..'");'
	elseif tablename == 't_online' then
		resqlstr = prestr ..' (sid,allcount,cashcount,createDate) values ("'..datavalue['sid']..'","'..datavalue['allcount']..'","'..datavalue['cashcount']..'","'..datavalue['createDate']..'");'
	elseif tablename == 't_moneylog' then
		resqlstr = prestr ..' (sid,playerId,accountName,playerName,rootId,typeId,oldValue,newValue,createDate) values ("'..datavalue['sid']..'","'..datavalue['playerId']..'","'..datavalue['accountName']..'","'..datavalue['playerName']..'","'..datavalue['rootId']..'","'..datavalue['typeId']..'","'..datavalue['oldValue']..'","'..datavalue['newValue']..'","'..datavalue['createDate']..'");'
	end
	return resqlstr
end

