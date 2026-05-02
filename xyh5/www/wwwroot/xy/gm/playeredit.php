<?php
include 'config.php';
if(empty($_SESSION["vip"])){
	echo "<script>alert('非法访问 ');history.go(-1)</script>";
	exit;
}
if($_SESSION["vip"]!=1){
	echo "<script>alert('VIP权限不足 ');history.go(-1)</script>";
	exit;
}
 if(isset($_SESSION['expiretime'])) {   
    if($_SESSION['expiretime'] < time()) {  
    unset($_SESSION['expiretime']);  
	header('Location: index.php?TIMEOUT'); // 登出  
	exit(0);  
	} else {  
	$_SESSION['expiretime'] = time() + 3600; // 刷新时间戳  
	}   
} 
?>
<!DOCTYPE html>
<html>   
<head>
 <meta charset="utf-8">
 <meta http-equiv="X-UA-Compatible" content="IE=edge">
 <meta name="viewport" content="width=device-width, initial-scale=1">
 <title><?php echo $_SESSION['gmbt'];?>玩家后台</title>
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
	<div class="modal-body">
			 <div class="form-horizontal" >
				<div class="form-group">
					<div class="col-sm-10">
					<button class="btn btn-success btn-block" onclick="window.location.href='player.php'">玩家后台</button>
					<button class="btn btn-warning btn-block" onclick="window.location.href='playeredit.php'">修改密码</button>
					<button class="btn btn-info btn-block" onclick="window.location.href='exit.php'">退出</button>
					</div>
				</div>
			</div>
		</div>
	</div>
    <div class="modal-content">
<form id="form" name="form" method="post" action="playerquery.php">
      <div class="modal-body">
	     <div class="form-horizontal" >
				<div class="form-group">			
                    <div class="col-sm-10">
						<label >游戏区：</label>
  <!--                      <select id="qu" name="qu"  value="" class="form-control selectpicker" data-size="5"  >
								<?php
							  foreach($yzfqu as $k=>$v){
								  echo '<option value="'.$k.'">'.$v.'</option>';
							  }
							  ?>
                        </select>
-->
                        <input type="text" readOnly="true" id="qu" name="qu" class="form-control" value="<?php echo $_SESSION["qu"]; ?>" >
                    </div>
                </div>
				<div class="form-group">				
                    <div class="col-sm-10">
					<label >玩家账号：</label>
                        <input type="text" readOnly="true" id="name" name="name" class="form-control" value="<?php echo $_SESSION["name"]; ?>" >
                    </div>
                </div>				
				<div class="form-group">
                    <div class="col-sm-10">
                        <input type="text" id="pwd" name="pwd" class="form-control" value="" placeholder="请输入后台密码" >
                    </div>
                </div>	
                <div class="form-group">
                    <div class=" col-sm-10">	
						<button type="submit" class="btn btn-danger btn-block" name="sub" value="editpwd">修改玩家密码</button>											
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