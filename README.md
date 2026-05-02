# 梦幻西游H5游戏 Docker部署

## 快速开始

### 1. 克隆仓库
```bash
git clone https://github.com/liangminmx/xyh5.git
cd xyh5
```

### 2. 登录GitHub Container Registry
```bash
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

### 3. 配置服务器IP
```bash
chmod +x configure-ip.sh
./configure-ip.sh <你的服务器IP>
# 例如: ./configure-ip.sh 192.168.1.100
```

### 4. 启动服务
```bash
docker compose up -d
```

### 5. 访问游戏
- 游戏地址: http://<你的服务器IP>:8766/cdn/
- GM后台: http://<你的服务器IP>:8766/gm/gm.php
  - 账号: admin
  - 密码: 123456

## Docker镜像

本项目使用GitHub Container Registry托管Docker镜像：

- `ghcr.io/liangminmx/xyh5/mhxy-server:latest` - 游戏服务端
- `ghcr.io/liangminmx/xyh5/mysql:5.6` - MySQL数据库
- `ghcr.io/liangminmx/xyh5/nginx-php-fpm:php5` - Nginx+PHP

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
xyh5/
├── Dockerfile          # 游戏服务端镜像构建文件
├── docker-compose.yml  # 容器编排配置
├── entrypoint.sh       # 启动脚本
├── configure-ip.sh     # IP配置脚本
├── nginx-site.conf     # Nginx配置
├── sql/                # 数据库SQL文件
└── xyh5/               # 游戏源码
    ├── home/server/    # 服务端程序
    └── www/wwwroot/xy/ # Web前端
```

## 自行构建镜像

如果需要自行构建镜像：

```bash
# 构建游戏服务端镜像
docker build -t mhxy-server .

# 修改docker-compose.yml使用本地镜像
# game-server:
#   image: mhxy-server:latest
```

## 注意事项

1. 确保服务器有足够的内存（建议4GB以上）
2. 首次启动需要等待MySQL初始化数据库
3. 如遇到权限问题，确保sql目录有正确的读取权限
4. 游戏数据保存在Docker volume中，删除容器不会丢失数据
