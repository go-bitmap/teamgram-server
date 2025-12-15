# Teamgram 服务独立部署指南（Kubernetes）

本文档说明如何将 Teamgram 的各个服务独立部署到 Kubernetes 集群中。

## 目录结构

```
docker/
├── idgen/
│   └── Dockerfile
├── status/
│   └── Dockerfile
├── dfs/
│   └── Dockerfile
├── media/
│   └── Dockerfile
├── authsession/
│   └── Dockerfile
├── biz/
│   └── Dockerfile
├── msg/
│   └── Dockerfile
├── sync/
│   └── Dockerfile
├── bff/
│   └── Dockerfile
├── session/
│   └── Dockerfile
└── gnetway/
    └── Dockerfile
```

## Dockerfile 说明

每个服务的 Dockerfile 都遵循以下规范：

- **APP_NAME**: 环境变量，定义服务二进制文件的路径
- **启动命令**: 统一为 `$APP_NAME -f /app/config.yml`
- **配置文件**: 通过 Kubernetes ConfigMap 挂载到 `/app/config.yml`

### 示例 Dockerfile

```dockerfile
FROM alpine:latest
WORKDIR /app
COPY ./teamgramd/bin/idgen /app/bin/idgen
RUN chmod +x /app/bin/idgen
RUN mkdir -p /app/logs
ENV APP_NAME=/app/bin/idgen
ENTRYPOINT ["/bin/sh", "-c", "$APP_NAME -f /app/config.yml"]
```

## 构建服务

### 镜像仓库配置

默认镜像仓库：`harbor.imageharbor.xyz`

镜像命名格式：`harbor.imageharbor.xyz/teamgram-<service>:latest`

### 构建所有服务的 Docker 镜像

```bash
# 只构建，不推送
./build-docker.sh all
# 或者
./build-docker.sh

# 构建并推送到 Harbor
./build-docker.sh all --push
```

### 构建单个服务的 Docker 镜像

```bash
# 只构建，不推送
./build-docker.sh idgen
./build-docker.sh status
./build-docker.sh dfs
./build-docker.sh media
./build-docker.sh authsession
./build-docker.sh biz
./build-docker.sh msg
./build-docker.sh sync
./build-docker.sh bff
./build-docker.sh session
./build-docker.sh gnetway

# 构建并推送到 Harbor
./build-docker.sh idgen --push
./build-docker.sh status --push
# ... 其他服务类似
```

### 只构建二进制文件（不构建 Docker 镜像）

```bash
./build-docker.sh binary idgen
```

### 只构建 Docker 镜像（假设二进制已存在）

```bash
# 只构建，不推送
./build-docker.sh docker idgen

# 构建并推送
./build-docker.sh docker idgen --push
```

### 推送镜像到 Harbor

在构建时添加 `--push` 参数即可自动推送镜像到 Harbor：

```bash
# 推送单个服务
./build-docker.sh idgen --push

# 推送所有服务
./build-docker.sh all --push
```

**注意**：推送前需要先登录 Harbor：

```bash
docker login harbor.imageharbor.xyz
```

## Kubernetes 部署

### 1. 创建 ConfigMap

为每个服务创建 ConfigMap，包含配置文件：

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: teamgram-idgen-config
data:
  config.yml: |
    Name: service.idgen
    ListenOn: 0.0.0.0:20660
    Etcd:
      Hosts:
        - etcd-service:2379
      Key: service.idgen
    Log:
      Mode: file
      Path: /app/logs/idgen
      Level: debug
    NodeId: 1
    SeqIDGen:
      - Host: redis-service:6379
```

### 2. 创建 Deployment

示例 Deployment 配置：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: teamgram-idgen
spec:
  replicas: 1
  selector:
    matchLabels:
      app: teamgram-idgen
  template:
    metadata:
      labels:
        app: teamgram-idgen
    spec:
      containers:
      - name: idgen
        image: teamgram-idgen:latest
        imagePullPolicy: IfNotPresent
        volumeMounts:
        - name: config
          mountPath: /app/config.yml
          subPath: config.yml
        - name: logs
          mountPath: /app/logs
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "500m"
      volumes:
      - name: config
        configMap:
          name: teamgram-idgen-config
      - name: logs
        emptyDir: {}
```

### 3. 创建 Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: teamgram-idgen-service
spec:
  selector:
    app: teamgram-idgen
  ports:
  - port: 20660
    targetPort: 20660
  type: ClusterIP
```

## 服务列表

| 服务名称 | 二进制路径 | 配置文件 |
|---------|-----------|---------|
| idgen | `/app/bin/idgen` | `config.yml` |
| status | `/app/bin/status` | `config.yml` |
| dfs | `/app/bin/dfs` | `config.yml` |
| media | `/app/bin/media` | `config.yml` |
| authsession | `/app/bin/authsession` | `config.yml` |
| biz | `/app/bin/biz` | `config.yml` |
| msg | `/app/bin/msg` | `config.yml` |
| sync | `/app/bin/sync` | `config.yml` |
| bff | `/app/bin/bff` | `config.yml` |
| session | `/app/bin/session` | `config.yml` |
| gnetway | `/app/bin/gnetway` | `config.yml` |

## 特殊说明

### gnetway 服务

gnetway 服务需要 `server_pkcs1.key` 密钥文件，已包含在镜像的 `/app/bin/server_pkcs1.key` 路径下。配置文件中的 `KeyFile` 应设置为 `./server_pkcs1.key`（相对于工作目录）。

### 配置文件路径

- **容器内路径**: `/app/config.yml`（固定）
- **挂载方式**: 通过 ConfigMap 挂载
- **启动参数**: `$APP_NAME -f /app/config.yml`

## 服务依赖关系

服务启动顺序建议：

1. **基础设施服务**：etcd, redis, mysql, kafka, zookeeper, minio
2. **基础服务**：idgen, status
3. **存储服务**：dfs, media
4. **认证服务**：authsession
5. **业务服务**：biz
6. **消息服务**：msg, sync
7. **API 服务**：bff
8. **会话服务**：session
9. **网关服务**：gnetway

## 注意事项

1. 所有服务的配置文件都通过 ConfigMap 挂载到 `/app/config.yml`
2. 配置文件中的服务地址应使用 Kubernetes Service 名称（如 `etcd-service:2379`）
3. 日志文件存储在 `/app/logs` 目录，建议使用 Volume 持久化
4. 服务之间通过 etcd 进行服务发现
5. 确保所有依赖的基础设施服务已部署并可用

## 故障排查

### 查看 Pod 状态

```bash
kubectl get pods -l app=teamgram-idgen
```

### 查看 Pod 日志

```bash
kubectl logs -f deployment/teamgram-idgen
```

### 进入 Pod 调试

```bash
kubectl exec -it deployment/teamgram-idgen -- /bin/bash
```

### 检查配置文件

```bash
kubectl exec deployment/teamgram-idgen -- cat /app/config.yml
```

### 检查环境变量

```bash
kubectl exec deployment/teamgram-idgen -- env | grep APP_NAME
```
