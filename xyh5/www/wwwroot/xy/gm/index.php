<?php
include 'config.php';
if(isset($_POST['sub'])) {	
$name=trim($_POST['name']);
$pwd=trim($_POST['pwd']);
if ($pwd == '') {
		exit('玩家后台的授权密码不能为空');
		}	
	mysql_query("set names 'utf8'"); //数据库输出编码
	mysql_select_db($YZF_CONFIG['dbgame'],$con);
	$result = mysql_query("SELECT * FROM `character` WHERE name LIKE '{$name}' or account LIKE '{$name}' limit 1");
	if($result&&mysql_num_rows($result)>0){
	$row = mysql_fetch_array($result);
	}
	$uid =$row['characterid'];
	$account = $row['account'];
	$pwd=md5($uid.$pwd.$key);	
$fp = fopen($vipfile, "a+");
	if (filesize($vipfile) > 0) {
		$str = fread($fp, filesize($vipfile));
		fclose($fp);
		$vipjson = json_decode($str, true);
		if ($vipjson == null) {
			$vipjson = array();
		}
	} else {
		$vipjson = array();
	}
	if (!$vipjson[$uid]) {
		echo "<script>alert('你没有VIP权限 ');history.go(-1)</script>";
		exit;
	} elseif ($vipjson[$uid]['pwd'] != $pwd) {
		echo "<script>alert('用户密码不匹配 ');history.go(-1)</script>";
		exit;
	}
	if ($vipjson[$uid]['qu'] != $qu) {
		echo "<script>alert('授权用户与当前选择大区不匹配 ');history.go(-1)</script>";
		exit;
	}
	$viplevel = intval($vipjson[$uid]['level']);
	if($viplevel==1){
		$_SESSION["vip"] = $viplevel;
		$_SESSION["name"] = $account;
		$_SESSION["pwd"] = $pwd;
		$_SESSION["qu"] = $vipjson[$uid]['qu'];
		$_SESSION['expiretime'] = time();
		 mysql_close($con);;
		header("Location:player.php");	
	}elseif($viplevel==2){
		$_SESSION["vip"] = $viplevel;
		$_SESSION["name"] = $account;
		$_SESSION["pwd"] = $pwd;
		$_SESSION["qu"] = $vipjson[$uid]['qu'];
		$_SESSION['expiretime'] = time();
		 mysql_close($con);;
		header("Location:playermail.php");	
	}
	 echo "<script>alert('该ID并未授权 ');history.go(-1)</script>";
	exit;
}
?>
<!DOCTYPE html>
<html>   
<head>
 <meta charset="utf-8">
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <title>后台</title>
 <link rel="stylesheet" href="lib/css/bootstrap.min.css">
 <link rel="stylesheet" href="lib/layui/css/layui.css" media="all">
 <script src="lib/js/jquery-1.11.0.min.js" type="text/javascript"></script>
 <script type="text/javascript" src="lib/layer/layer.js"></script>
 <script src="lib/js/bootstrap.min.js" type="text/javascript"></script>
 <link rel="stylesheet" href="lib/css/bootstrap-select.min.css">
 <script src="lib/js/bootstrap-select.min.js"></script>
</head>    
<body>
 <div class="container">
   <br>
   <div class="row">
     <div class="container-fluid">
  <div class="modal-dialog">
    <div class="modal-content">
      <ul class="breadcrumb">
				<li>
					 <h4><?php echo $_SESSION['gmbt'];?>玩家后台</h4>
				</li>				
			</ul>
<form id="form" name="form" method="post" action="">
      <div class="modal-body">
	     <div class="form-horizontal" >
		 		<div class="form-group">
                    <div class="col-sm-10">
                        <select id="qu" name="qu"  value="" class="form-control selectpicker" data-size="5"  >
								<?php
							  foreach($yzfqu as $k=>$v){
								  echo '<option value="'.$k.'">'.$v.'</option>';
							  }
							  ?>
                        </select>
                    </div>
                </div>
				<div class="form-group">
                    <div class="col-sm-10">
                        <input type="text" id="name" name="name" class="form-control" value="" placeholder="请输入登陆角色名" >
                    </div>
                </div>	
                <div class="form-group">
                    <div class="col-sm-10">
                        <input type="password" id="pwd" name="pwd" class="form-control"  value="" placeholder="请输入登陆密码" >
                    </div>
                </div>
				<div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-danger btn-block" name="sub" >登陆</button>							
                    </div>					
                </div>	
                <div class="form-group">
                    <div class="col-sm-10">						
						  <p class="admin_copyright"></p> 
                    </div>					
                </div>					
            </div>
      </div>
    </div>
  </div>
</div>
</div>
</div>
</form>
</body>
</html>