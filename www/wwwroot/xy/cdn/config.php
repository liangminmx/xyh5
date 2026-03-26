<?php
	include_once dirname(__FILE__) . '/../mysql_compat.php';
	error_reporting(0);
	date_default_timezone_set("PRC");
	header("Content-type: text/html; charset=utf8");
	$db_host='127.0.0.1';
	$db_username='root';//数据库帐号
	$db_password='echeverra';//数据库密码
	$dbport = 3306;
	$dbaccount='account';  //账号注册地址
	$key='V05YLW';
	$conn = @mysql_connect($db_host,$db_username,$db_password,$dbport) or die ("could not connect mysql");
	if (!mysql_select_db($dbaccount, $conn)){
	mysql_query("CREATE DATABASE {$dbaccount}",$conn);	
	mysql_query("set names UTF8"); 
	mysql_select_db($dbaccount, $conn);
	mysql_query("CREATE TABLE if not exists account( ".
        "id INT NOT NULL AUTO_INCREMENT, ".
		"user VARCHAR(100) NOT NULL COMMENT '用户名', ".	
		"pass VARCHAR(100) NOT NULL COMMENT '密码', ".	
		"create_time datetime NOT NULL COMMENT '建号时间', ".
		"login_time datetime  NULL COMMENT '登陆时间', ".
		"ip VARCHAR(100) NOT NULL COMMENT 'ip地址', ".
		"status VARCHAR(100) NOT NULL COMMENT '默认1 禁用2', ".		
        "PRIMARY KEY (id ))ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci; ");	
	}
	$time = date('Y-m-d H:i:s',strtotime('now')); 
	$user_IP = ($_SERVER["HTTP_VIA"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
	$user_IP = ($user_IP) ? $user_IP : $_SERVER["REMOTE_ADDR"];
?>
