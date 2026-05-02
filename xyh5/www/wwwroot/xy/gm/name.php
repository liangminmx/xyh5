<?php 
header("Content-type: text/html; charset=utf-8");
ini_set('date.timezone','Asia/Shanghai');
include 'config.php';
mysql_select_db($YZF_CONFIG['dbgame'],$con);
mysql_query("set names 'utf8'"); //数据库输出编码
$result=mysql_query("select * from `character`");	
?>