<?php
include_once "config.php";
mysql_select_db($dbaccount,$conn) or die ("table not exits");
mysql_query("set names UTF8"); 
$name=$_POST['username'];
$pass=$_POST['passwd'];
if(!$name && !$pass){
	header("Location:/");	
}
if(empty($name) && empty($pass)){
	echo "<script>alert('用户名和密码不能空！');history.go(-1)</script>";
	exit;	
}
if(preg_match('/[\x{4e00}-\x{9fa5}]/u', $name)>0){
	echo "<script>alert('用户名不能包含中文！');history.go(-1)</script>";
	exit;
}
$sql="select * from account where user='".$name."'";
$result=mysql_query($sql);
$row=mysql_fetch_array($result);
if($row['id']){
	if($row['pass']!=md5($pass)){
		echo "<script>alert('登录失败,用户名或密码错误！');history.go(-1)</script>";
		exit;
	}
if($row['status']=='2'){
	echo "<script>alert('账号被封，请联系管理员！');history.go(-1)</script>";
	exit;	
}
	$_SESSION['user']=$name;		
}else{
	$sql="insert into account (user,pass,create_time,ip,status) values ('".$name."','".md5($pass)."','".($time)."','".($user_IP)."','1')";
	$result=mysql_query($sql);
	if($result){
		$_SESSION['user']=$name;
	}else{
		echo "<script>alert('网络繁忙,请稍后重试！');history.go(-1)</script>";
		exit;	
	}
}
$user =$_SESSION['user'];
if(!$user){
	header("Location:/");	
}

	$sql="update account set login_time='".($time)."',ip='".($user_IP)."' where user='".($user)."'";
	$result=mysql_query($sql);
$t = strtotime(date('Y-m-d'));
$sign =md5('account='.$name.'&time='.$t.'&key='.$key);
$url = "index.min.html?account={$name}&t={$t}&sign={$sign}";
header("Location:{$url}");
?>