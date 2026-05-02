# 梦幻西游H5游戏 Docker部署

## 快速开始

### 1. 配置服务器IP
```bash
./configure-ip.sh <你的服务器IP>
# 例如: ./configure-ip.sh 192.168.1.113
```

### 2. 构建并启动
```bash
docker compose up -d
```

### 3. 访问游戏
- 游戏地址: http://<你的服务器IP>:8766/cdn/
- GM后台: http://<你的服务器IP>:8766/gm/gm.php
  - 账号: admin
  - 密码: 123456

## 端口说明
- 8766: Web前端
- 3306: MySQL数据库
- 10001: 游戏服务
- 11001: 内部通信
- 12001: 数据分析
- 8001: 充值服务
- 8004: 世界服务

## 常用命令
```bash
# 查看日志
docker logs mhxy-server
docker logs mhxy-mysql
docker logs mhxy-web

# 重启服务
docker compose restart

# 停止服务
docker compose down

# 停止并删除数据
docker compose down -v
```

## 文件说明
```
mhxy-h5-docker/
├── Dockerfile          # 游戏服务端镜像
├── docker-compose.yml  # 容器编排配置
├── entrypoint.sh       # 启动脚本
├── configure-ip.sh     # IP配置脚本
├── nginx-site.conf     # Nginx配置
├── sql/                # 数据库SQL文件
└── xyh5/               # 游戏源码
    ├── home/server/    # 服务端程序
    └── www/wwwroot/xy/ # Web前端
```
