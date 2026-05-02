<?php
    $data = [];
    // 服务器ID0
    $data[] = 1; //未知
    // 角色ID $CharacterID1
    $data[] = '11000700001';
    // 充值时间（UNIX时间戳）2
    $data[] = '1574135208683';
    // 商品ID3
    $data[] = 24;
    // 商品价格
    $data[] = 100;
    // 平台来源5
    $data[] = 7;//未知
    // IP m_ip6
    $data[] = '127.0.0.1';
    // 账号，上限64 m_account7
    $data[] = '10010';
//        $data[] = $UserId;
    // 订单号，上限256 m_billno8
    $data[] = '10011231';
    //m_amt9
    $data[] = 100;
    //m_payamt_coins10
    $data[] = '';
    //m_pub_payamt_coins11
    $data[] = '';

    $byte = '';
    $byte .= pack('V', $data[0]);
    $byte .= pack('P', $data[1]);
    $byte .= pack('P', $data[2]);
    $byte .= pack('V', $data[3]);
    $byte .= pack('V', $data[4]);
    $byte .= pack('V', $data[5]);
    for ($i = 6; $i < count($data); $i++) {
        $l    = strlen($data[$i]);
        $byte .= pack('v', $l);
        $str  = array_map('ord', str_split($data[$i]));
        foreach ($str as $vo) {
            $byte .= pack('c', $vo);
        }
    }
    $length      = strlen($byte) + 8;
    $protocolsid = 5006;
    // 4字节的长度+4字节的协议id+包内容
//        var_dump($byte);
    $byte = pack('V', $length) . pack('V', $protocolsid) . $byte;

    $socket = socket_create(AF_INET, SOCK_STREAM, SOL_TCP);
	$result = socket_connect($socket, "192.168.100.128", "11001");
	$result = socket_write($socket, $byte);
	if (!$result) {
		echo "发送失败";
    }
	if ($out = socket_read($socket, 8192, PHP_BINARY_READ)) {
        $arr = unpack("Vl1/Vl2/vl3/Pl4", $out);
		var_dump($arr);
    }else{
		echo "读取失败";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	