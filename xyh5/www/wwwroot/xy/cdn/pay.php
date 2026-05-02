<?php 

if($_POST){
	$money = $_POST['money'];
	$userdata = $_POST['userdata'];
	$data = explode("_",$_POST['userdata']);
	$json_string = file_get_contents('rechargedata.json'); 
	$rechargedata = json_decode($json_string, true); 
	if($rechargedata['root']['cfg']['root']['recharge'][$data[2]-1]['recharge'] == $money/100){
		$sign = md5("name=充值&price=$money&extractInfo=$userdata&key=V05YLW");
		exit($sign);
	}else{
		exit("error");
	}
}