
# 汽车资讯 App 后端 API 服务

基于 Go-Zero 微服务框架开发的汽车资讯后台，提供车型检索、配置详情查询、用户管理及评论交互等功能。

## 技术栈

- 核心语言：Golang 1.21+
- Web 框架：Go-Zero (单体 API 架构)
- 数据库：MySQL 8.0 (使用 JSON 字段存储灵活的汽车参数)
- 缓存：Redis 7.0
- 对象存储：MinIO (本地 S3 兼容，存储车辆图片及视频)

## 本地开发环境搭建

1. 确保已安装 Docker 和 Docker Desktop (Windows)。
2. 使用根目录（或您指定的目录）下的 `docker-compose.yml` 启动中间件：
   `docker-compose up -d`
3. 数据库初始化：
   使用 Navicat 或 DBeaver 连接本地 MySQL (`127.0.0.1:3306`, 用户 `root`, 密码 `rootpassword`)，执行 `deploy/init.sql`。
4. MinIO 初始化：
   访问 `http://localhost:9001` (admin / password123)，创建一个名为 `cars-media` 的 Bucket，并将其 Access Policy 设置为 Public（方便前端直接读取图片）。

## 启动服务

```bash
go mod tidy
go run car.go -f etc/car-api.yaml
```
