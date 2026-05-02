#!/bin/bash
echo "正在启动服务端"

echo "正在启动基础服务"

echo "正在启动充值服务"
cd chargeserver/unix
./start_chargeserver.sh
sleep 3
echo "正在启动GM服务"
cd ../../gmserver/unix
./start_gmserver.sh
sleep 3
echo "正在启动世界服务"
cd ../../worldserver/unix
./start_worldserver.sh
sleep 3

echo "基础服务启动完成"

echo "正在启动一区"

echo "正在启动游戏服务"
cd ../../gameserver/unix
./start_gameserver.sh
sleep 3
echo "正在启动数据分析服务"
cd ../../operationanalysisserver/unix
./start_operationanalysisserver.sh
sleep 3
echo "服务端启动完成"