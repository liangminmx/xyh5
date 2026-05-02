<?php
include 'config.php';
if(isset($_POST['sub'])) {	
$gmuser=trim($_POST['gmuser']);
$gmpwd=trim($_POST['gmpwd']);
if(empty($gmpwd)||empty($gmuser)){
echo "<script>alert('用户名和密码不能为空');history.go(-1)</script>";
exit;
}
if($gmuser!=$admin){
echo "<script>alert('用户名错误');history.go(-1)</script>";
exit;
}
foreach ($gmcode as $k => $pwd) {
	if($pwd == $gmpwd){
		$v = md5($key);
		switch ($gmpwd){			
			case $gmcode[0]:
				    $gm=$gmadmin[0];
				    break;
			case $gmcode[1]:
				    $gm=$gmadmin[1];
				    break;
			case $gmcode[2]:
				    $gm=$gmadmin[2];
				    break;
			case $gmcode[3]:
				    $gm=$gmadmin[3];
				    break;
			case $gmcode[4]:
				    $gm=$gmadmin[4];
				    break;		
			case $gmcode[5]:
				    $gm=$gmadmin[5];
				    break;
			case $gmcode[6]:
				    $gm=$gmadmin[6];
				    break;
			case $gmcode[7]:
				    $gm=$gmadmin[7];
				    break;
			case $gmcode[8]:
				    $gm=$gmadmin[8];
				    break;
			case $gmcode[9]:
				    $gm=$gmadmin[9];
				    break;			
		}				
	}
}
$log='log/log_gmcode_'.date('Y-m-d').'.log';
$date=date('Y-m-d H:i:s');
if($v!=$YZF_CONFIG['gmkey']){
	echo "<script>alert('管理员密码错误');history.go(-1)</script>";	
	file_put_contents($log,$date."\t"."管理员密码错误\t"."GM为:".$v."\t".$gm."\t".$user_IP.PHP_EOL,FILE_APPEND);
	exit;
	}
session_start();
$_SESSION["gm"] = $gm;
$_SESSION['expiretime'] = time();
file_put_contents($log,$date."\t"."GM为:".$gm."\t"."管理员登陆成功\t".$user_IP.PHP_EOL,FILE_APPEND);
header("Location:gmht.php?qu=1");	
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
					 <h4><?php echo $_SESSION['gmbt'];?>管理后台</h4>	
				</li>				
			</ul>
<form id="form" name="form" method="post" action="">
      <div class="modal-body">
	     <div class="form-horizontal" >
		 				<div class="form-group">
                </div>
				<div class="form-group">
                    <div class="col-sm-10">
                        <input type="text" id="gmuser" name="gmuser" class="form-control" value="" placeholder="请输入登陆账号" >
                    </div>
                </div>	
                <div class="form-group">
                    <div class="col-sm-10">
                        <input type="password" id="gmpwd" name="gmpwd" class="form-control"  value="" placeholder="请输入登陆密码" >
                    </div>
                </div>
				<div class="form-group">
                    <div class=" col-sm-10">						
						<button type="submit" class="btn btn-danger btn-block" name="sub" >管理登陆</button>							
                    </div>					
                </div>	
                <div class="form-group">
                    <div class="col-sm-10">						
						  <p class="admin_copyright">&copy; </p> 
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