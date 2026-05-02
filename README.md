# 梦幻西游H5游戏 - Docker一键部署

基于经典Q版西游H5游戏，支持Docker一键部署。

## 功能特点

- 🐳 Docker一键部署，无需手动配置环境
- 🎮 完整的游戏服务端和Web前端
- 🛠️ 内置GM后台管理工具
- 📦 镜像托管于GitHub Container Registry
- 🔄 支持数据持久化存储

## 快速部署

### 方式一：使用预构建镜像（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/liangminmx/xyh5.git
cd xyh5

# 2. 配置服务器IP
chmod +x configure-ip.sh
./configure-ip.sh <你的服务器IP>
# 例如: ./configure-ip.sh 192.168.1.100

# 3. 启动服务
docker compose up -d
```

### 方式二：自行构建镜像

```bash
# 1. 克隆仓库
git clone https://github.com/liangminmx/xyh5.git
cd xyh5

# 2. 构建游戏服务端镜像
docker build -t mhxy-server .

# 3. 修改docker-compose.yml中的镜像为本地镜像
# game-server:
#   image: mhxy-server:latest

# 4. 配置IP并启动
./configure-ip.sh <你的服务器IP>
docker compose up -d
```

## 访问游戏

| 地址 | 说明 |
|------|------|
| `http://<IP>:8766/cdn/` | 游戏入口 |
| `http://<IP>:8766/gm/gm.php` | GM后台 |

**GM后台默认账号**:
- 账号: `admin`
- 密码: `123456`

## Docker镜像

| 镜像 | 大小 | 说明 |
|------|------|------|
| `ghcr.io/liangminmx/xyh5/mhxy-server:latest` | ~2.4GB | 游戏服务端 |
| `ghcr.io/liangminmx/xyh5/mysql:5.6` | ~300MB | MySQL数据库 |
| `ghcr.io/liangminmx/xyh5/nginx-php-fpm:php5` | ~230MB | Nginx+PHP |

## 端口说明

| 端口 | 服务 | 说明 |
|------|------|------|
| 8766 | Web | 前端访问入口 |
| 3306 | MySQL | 数据库服务 |
| 10001 | Game | 游戏服务 |
| 11001 | Game | 内部通信 |
| 12001 | Analysis | 数据分析 |
| 8001 | Charge | 充值服务 |
| 8004 | World | 世界服务 |

## 常用命令

```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 查看特定服务日志
docker logs mhxy-server
docker logs mhxy-mysql
docker logs mhxy-web

# 重启服务
docker compose restart

# 停止服务
docker compose down

# 停止并删除数据
docker compose down -v

# 进入容器
docker exec -it mhxy-server bash
docker exec -it mhxy-mysql bash
```

## 目录结构

```
xyh5/
├── Dockerfile              # 游戏服务端镜像构建文件
├── docker-compose.yml      # 容器编排配置
├── entrypoint.sh           # 启动脚本
├── configure-ip.sh         # IP配置脚本
├── nginx-site.conf         # Nginx配置
├── sql/                    # 数据库SQL文件
│   ├── 00-init-databases.sql
│   ├── account.sql
│   ├── chargeserver.sql
│   ├── gameserver.sql
│   ├── gmserver.sql
│   ├── oaglobal.sql
│   ├── operationanalysisserver.sql
│   └── worldserver.sql
└── xyh5/                   # 游戏源码
    ├── home/server/        # 服务端程序
    │   ├── chargeserver/   # 充值服务
    │   ├── gameserver/     # 游戏服务
    │   ├── gmserver/       # GM服务
    │   ├── worldserver/    # 世界服务
    │   └── operationanalysisserver/  # 数据分析
    └── www/wwwroot/xy/     # Web前端
        ├── cdn/            # 游戏资源
        └── gm/             # GM后台
```

## 服务器要求

- **操作系统**: Linux (推荐Ubuntu/CentOS)
- **内存**: 建议4GB以上
- **磁盘**: 建议10GB以上可用空间
- **Docker**: 20.10+
- **Docker Compose**: v2.0+

## 故障排除

### 游戏无法加载
1. 检查端口是否开放: `10001`, `8766`
2. 检查IP配置是否正确
3. 查看游戏服务日志: `docker logs mhxy-server`

### 数据库连接失败
1. 等待MySQL初始化完成（首次启动约30秒）
2. 检查MySQL容器状态: `docker compose ps`
3. 查看MySQL日志: `docker logs mhxy-mysql`

### GM后台无法访问
1. 检查Web容器状态
2. 查看Nginx日志: `docker logs mhxy-web`

### 权限问题
```bash
# 修复SQL文件权限
chmod -R 755 sql/
```

## 数据备份

```bash
# 导出数据库
docker exec mhxy-mysql mysqldump -uroot -pecheverra --all-databases > backup.sql

# 备份游戏数据
docker run --rm -v mhxy-h5-docker_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz /data
```

## 安全建议

1. 修改数据库默认密码
2. 修改GM后台默认账号密码
3. 配置防火墙限制端口访问
4. 定期备份数据

## 相关链接

- [原教程](https://echeverra.cn/xyh5)
- [Docker Hub](https://hub.docker.com)
- [GitHub Container Registry](https://ghcr.io)

## License

本项目仅供学习交流使用，请勿用于商业用途。

## 贡献

欢迎提交Issue和Pull Request！
