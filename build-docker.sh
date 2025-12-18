#!/usr/bin/env bash

# 构建脚本 - 支持单独构建每个服务的 Docker 镜像
# 用法:
#   ./build-docker.sh [service_name] [--push]  # 构建指定服务，可选推送
#   ./build-docker.sh all [--push]             # 构建所有服务，可选推送
#   ./build-docker.sh                          # 构建所有服务（默认，不推送）

PROJECT_ROOT=$(pwd)
TEAMGRAMAPP=${PROJECT_ROOT}"/app"
INSTALL=${PROJECT_ROOT}"/teamgramd"
export GOOS=linux
export GOARCH=amd64
export CGO_ENABLED=0

# 镜像仓库配置 harbor.imageharbor.xyz
REGISTRY="192.168.30.81/teamgram"
IMAGE_PREFIX="teamgram"

# 服务列表
SERVICES=("idgen" "status" "dfs" "media" "authsession" "biz" "msg" "sync" "bff" "session" "gnetway")

# 是否推送镜像
PUSH_IMAGE=false

# 构建单个服务的二进制文件
build_service_binary() {
    local service=$1
    echo "Building $service binary..."
    
    case $service in
        idgen)
            cd ${TEAMGRAMAPP}/service/idgen/cmd/idgen
            go build -ldflags="-s -w" -o ${INSTALL}/bin/idgen
            ;;
        status)
            cd ${TEAMGRAMAPP}/service/status/cmd/status
            go build -ldflags="-s -w" -o ${INSTALL}/bin/status
            ;;
        dfs)
            cd ${TEAMGRAMAPP}/service/dfs/cmd/dfs
            go build -ldflags="-s -w" -o ${INSTALL}/bin/dfs
            ;;
        media)
            cd ${TEAMGRAMAPP}/service/media/cmd/media
            go build -ldflags="-s -w" -o ${INSTALL}/bin/media
            ;;
        authsession)
            cd ${TEAMGRAMAPP}/service/authsession/cmd/authsession
            go build -ldflags="-s -w" -o ${INSTALL}/bin/authsession
            ;;
        biz)
            cd ${TEAMGRAMAPP}/service/biz/biz/cmd/biz
            go build -ldflags="-s -w" -o ${INSTALL}/bin/biz
            ;;
        msg)
            cd ${TEAMGRAMAPP}/messenger/msg/cmd/msg
            go build -ldflags="-s -w" -o ${INSTALL}/bin/msg
            ;;
        sync)
            cd ${TEAMGRAMAPP}/messenger/sync/cmd/sync
            go build -ldflags="-s -w" -o ${INSTALL}/bin/sync
            ;;
        bff)
            cd ${TEAMGRAMAPP}/bff/bff/cmd/bff
            go build -ldflags="-s -w" -o ${INSTALL}/bin/bff
            ;;
        session)
            cd ${TEAMGRAMAPP}/interface/session/cmd/session
            go build -ldflags="-s -w" -o ${INSTALL}/bin/session
            ;;
        gnetway)
            cd ${TEAMGRAMAPP}/interface/gnetway/cmd/gnetway
            go build -ldflags="-s -w" -o ${INSTALL}/bin/gnetway
            ;;
        *)
            echo "Unknown service: $service"
            return 1
            ;;
    esac
}

# 推送镜像到 Harbor
push_image() {
    local service=$1
    local local_image="${IMAGE_PREFIX}-${service}:latest"
    local remote_image="${REGISTRY}/${IMAGE_PREFIX}-${service}:latest"
    
    echo "Pushing image ${remote_image}..."
    
    # 标记镜像
    docker tag ${local_image} ${remote_image}
    
    # 推送镜像
    docker push ${remote_image}
    
    if [ $? -eq 0 ]; then
        echo "Successfully pushed ${remote_image}"
        # 删除远程标记的镜像（保留本地镜像）
        docker rmi ${remote_image} 2>/dev/null || true
    else
        echo "Failed to push ${remote_image}"
        return 1
    fi
}

# 构建单个服务的 Docker 镜像
build_service_docker() {
    local service=$1
    local image_name="${IMAGE_PREFIX}-${service}:latest"
    echo "Building Docker image for $service..."
    
    # 先构建二进制文件（会改变工作目录）
    build_service_binary $service
    
    # 回到项目根目录
    cd ${PROJECT_ROOT}
    
    # 构建 Docker 镜像
    docker build -f ./docker/${service}/Dockerfile -t ${image_name} .
    
    if [ $? -eq 0 ]; then
        echo "Successfully built ${image_name}"
        
        # 如果需要推送镜像
        if [ "$PUSH_IMAGE" = true ]; then
            push_image $service
        fi
    else
        echo "Failed to build ${image_name}"
        return 1
    fi
}

# 构建所有服务
build_all() {
    echo "Building all services..."
    if [ "$PUSH_IMAGE" = true ]; then
        echo "Push mode: enabled"
    else
        echo "Push mode: disabled"
    fi
    
    for service in "${SERVICES[@]}"; do
        build_service_docker $service
        if [ $? -ne 0 ]; then
            echo "Failed to build $service"
            exit 1
        fi
    done
    echo "All services built successfully!"
}

# 主逻辑
ARGS=("$@")

# 检查是否包含 --push 参数
for arg in "${ARGS[@]}"; do
    if [ "$arg" = "--push" ]; then
        PUSH_IMAGE=true
        break
    fi
done

# 移除 --push 参数，保留其他参数
ARGS_WITHOUT_PUSH=()
for arg in "${ARGS[@]}"; do
    if [ "$arg" != "--push" ]; then
        ARGS_WITHOUT_PUSH+=("$arg")
    fi
done

# 根据参数执行相应操作
if [ ${#ARGS_WITHOUT_PUSH[@]} -eq 0 ]; then
    # 没有参数，构建所有服务（不推送）
    build_all
elif [ "${ARGS_WITHOUT_PUSH[0]}" = "all" ]; then
    # 构建所有服务
    build_all
elif [ "${ARGS_WITHOUT_PUSH[0]}" = "binary" ]; then
    # 只构建二进制文件
    if [ -n "${ARGS_WITHOUT_PUSH[1]}" ]; then
        build_service_binary "${ARGS_WITHOUT_PUSH[1]}"
    else
        echo "Error: binary command requires service name"
        echo "Usage: $0 binary <service_name> [--push]"
        exit 1
    fi
elif [ "${ARGS_WITHOUT_PUSH[0]}" = "docker" ]; then
    # 只构建 Docker 镜像（假设二进制已存在）
    if [ -n "${ARGS_WITHOUT_PUSH[1]}" ]; then
        service="${ARGS_WITHOUT_PUSH[1]}"
        image_name="${IMAGE_PREFIX}-${service}:latest"
        # 确保在项目根目录
        cd ${PROJECT_ROOT}
        docker build -f ./docker/$service/Dockerfile -t ${image_name} .
        if [ $? -eq 0 ] && [ "$PUSH_IMAGE" = true ]; then
            push_image $service
        fi
    else
        echo "Error: docker command requires service name"
        echo "Usage: $0 docker <service_name> [--push]"
        exit 1
    fi
else
    # 构建指定服务的二进制和 Docker 镜像
    service="${ARGS_WITHOUT_PUSH[0]}"
    if [[ " ${SERVICES[@]} " =~ " ${service} " ]]; then
        build_service_docker $service
    else
        echo "Usage: $0 [service_name|all|binary service_name|docker service_name] [--push]"
        echo ""
        echo "Options:"
        echo "  service_name          Build and optionally push specified service"
        echo "  all                   Build and optionally push all services"
        echo "  binary service_name   Build binary only (no Docker image)"
        echo "  docker service_name   Build Docker image only (assumes binary exists)"
        echo "  --push                Push image to Harbor after building"
        echo ""
        echo "Available services: ${SERVICES[*]}"
        echo ""
        echo "Examples:"
        echo "  $0 idgen                # Build idgen image only"
        echo "  $0 idgen --push          # Build and push idgen image"
        echo "  $0 all --push            # Build and push all services"
        echo "  $0 docker idgen --push   # Build and push idgen image (binary exists)"
        exit 1
    fi
fi
