---
alwaysApply: false
description: 编写golang代码时
---
# Teamgram Server 项目规则

## 技术栈与环境
- **语言**: Go 1.21+
- **框架**: [go-zero](https://github.com/zeromicro/go-zero) (微服务)
- **协议**: gRPC (内部通信), MTProto (客户端通信), HTTP (网关)
- **数据库**: MySQL
- **缓存/KV**: Redis
- **服务发现**: Etcd
- **消息队列**: Kafka
- **对象存储**: MinIO

## 项目结构
- **Monorepo (单体仓库)**: 项目采用单体仓库结构。
  - `app/`: 包含业务逻辑服务和 BFF (Backend for Frontend)。
  - `service/`: 包含核心后端领域服务。
  - `interface/`: 包含网关和面向公众的接口。
  - `pkg/`: 共享库和工具。
  - `docker/`: 服务的 Dockerfile。
  - `k8s/`: Kubernetes 清单和 Helm charts。
- **服务布局**:
  - `cmd/<service_name>/main.go`: 服务入口点。
  - `etc/<service_name>.yaml`: 配置文件。
  - `internal/`: 私有实现细节。
    - `config/`: 配置结构定义。
    - `server/`: gRPC/HTTP 服务器设置。
    - `core/` 或 `logic/`: 业务逻辑。
    - `dao/`: 数据访问对象 (数据库交互)。
    - `svc/`: 服务上下文 (依赖项)。
- **Protobuf**: `.proto` 文件定义 API 接口和数据结构。

## 编码规范
- **命名**:
  - Go 结构体、接口和函数使用 `CamelCase` (大驼峰)。
  - 文件名和目录名主要使用 `snake_case` (蛇形命名)。
  - 数据库列名和 JSON 标签使用 `snake_case`。
- **错误处理**:
  - 适当使用 `github.com/pkg/errors` 进行错误包装。
  - 显式处理错误；不要忽略它们。
- **日志**:
  - 使用 `github.com/zeromicro/go-zero/core/logx` 进行日志记录。
- **配置**:
  - 使用 `github.com/zeromicro/go-zero/core/conf` 加载 YAML 配置。
- **依赖注入**:
  - 使用 `ServiceContext` 模式 (go-zero 中常见) 将依赖项 (DB 连接、RPC 客户端) 传递给 logic/core 层。

## 开发工作流
- **构建**: 使用 `Makefile` 或 `build.sh` 构建服务。
- **Protobuf 生成**: 当 `.proto` 文件更改时，确保重新生成 `.pb.go` 文件 (通常通过服务目录中的 `sh build2.sh` 或类似脚本)。
- **测试**:
  - 使用标准 `testing` 包。
  - 使用 `github.com/stretchr/testify` 进行断言。
  - 将测试放在被测试代码旁边 (例如 `*_test.go`)。

## 特定模式
- **Helpers**: BFF 服务通常将逻辑组织到 `*_helper` 包中 (例如 `account_helper`, `chats_helper`) 以模块化复杂的聚合逻辑。
- **MTProto**: 项目实现了 MTProto 协议。注意 `github.com/teamgram/proto/mtproto` 类型和接口。
