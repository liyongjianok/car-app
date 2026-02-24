
# Car-App (汽车资讯后端服务)

基于 Go-Zero 微服务框架开发的高性能汽车资讯平台后端。提供包括用户鉴权、复杂的车辆多条件检索、海量车型配置 JSON 动态解析及互动评论功能。

## 🛠 技术栈

- **核心框架**: Golang 1.21+ / Go-Zero (REST API 架构)
- **数据库**: MySQL 8.0 (利用 JSON 类型支持灵活的车辆配置树)
- **缓存**: Redis 7.0 (利用 go-zero 内置的 sqlc 实现底层查询自动缓存)
- **对象存储**: MinIO (本地兼容 S3 协议，用于存储媒体资源)
- **鉴权体系**: JWT (JSON Web Token)

## 📁 目录结构说明

```text
car-app/
├── deploy/         # 数据库初始化及部署脚本 (init.sql)
├── etc/            # 服务 YAML 配置文件
├── internal/
│   ├── config/     # 配置结构映射
│   ├── handler/    # HTTP 请求路由与参数接收
│   ├── logic/      # 核心业务逻辑实现 (联表查询、JSON解析等)
│   ├── model/      # goctl 自动生成的带缓存的数据库操作层
│   ├── svc/        # 服务上下文，注入 DB 连接池等
│   └── types/      # 前后端交互的数据结构定义
├── car.api         # goctl API 接口契约定义文件
└── car.go          # 服务启动主入口
```


## 🚀 快速启动指引

### 1. 环境准备 (Docker)

确保已安装 Docker Desktop，运行根目录下的环境编排：

**Bash**

```
docker-compose up -d
```

> *注：如果您本地已有 MySQL 服务占用了 3306 端口，可以直接使用本地 MySQL，只需保证 Docker 中的 Redis 正常启动即可。*

### 2. 数据库初始化

通过 Navicat 或 DBeaver 连接 MySQL (`127.0.0.1:3306`)：

1. 执行 `deploy/init.sql`。
2. 该脚本会自动创建 `car_db` 数据库、7 张核心数据表，并注入 50 款热门车型、JSON 规格参数及用户评论等测试数据。
3. 预设测试账号：手机号 `13800138000`，密码 `123456`。

### 3. 启动服务

在项目根目录运行：

**Bash**

```
go mod tidy
go run car.go
```

服务默认监听 `http://localhost:8888`。

## 📖 核心接口列表

| **模块**   | **接口路径**          | **方法** | **鉴权** | **描述**                                 |
| ---------------- | --------------------------- | -------------- | -------------- | ---------------------------------------------- |
| **Auth**   | `/api/v1/user/login`      | POST           | 否             | 用户登录获取 JWT Token                         |
| **Auth**   | `/api/v1/user/info`       | GET            | **是**   | 获取当前登录用户信息                           |
| **Car**    | `/api/v1/cars/search`     | GET            | 否             | 分页检索车型 (支持 keyword, brandId, 价格区间) |
| **Car**    | `/api/v1/cars/detail/:id` | GET            | 否             | 获取带 JSON 属性树的车型详情及多媒体图集       |
| **Review** | `/api/v1/cars/reviews`    | GET            | 否             | 获取特定车型的评论列表及打分                   |
| **Review** | `/api/v1/cars/review`     | POST           | **是**   | 登录用户发表车评                               |

## ⚠️ 开发注意事项

* **配置文件** : 修改配置请同步编辑 `etc/car-app.yaml` 及 `internal/config/config.go`，确保 `json` tag 一致。
* **缓存重置** : 如果手动修改了 MySQL 里的数据，由于 sqlc 缓存机制，可能不会立即生效。开发阶段可临时通过 Redis 客户端执行 `FLUSHALL` 清空缓存。
