#!/usr/bin/env bash

# 构建脚本 - 构建所有服务的二进制文件（不构建 Docker 镜像）
# 如需构建 Docker 镜像，请使用 build-docker.sh

PWD=$(pwd)
TEAMGRAMAPP=${PWD}"/app"
INSTALL=${PWD}"/teamgramd"
export GOOS=linux
export GOARCH=amd64

echo "build idgen ..."
cd ${TEAMGRAMAPP}/service/idgen/cmd/idgen
go build -o ${INSTALL}/bin/idgen

echo "build status ..."
cd ${TEAMGRAMAPP}/service/status/cmd/status
go build -o ${INSTALL}/bin/status

echo "build dfs ..."
cd ${TEAMGRAMAPP}/service/dfs/cmd/dfs
go build -o ${INSTALL}/bin/dfs

echo "build media ..."
cd ${TEAMGRAMAPP}/service/media/cmd/media
go build -o ${INSTALL}/bin/media

echo "build authsession ..."
cd ${TEAMGRAMAPP}/service/authsession/cmd/authsession
go build -o ${INSTALL}/bin/authsession

echo "build biz ..."
cd ${TEAMGRAMAPP}/service/biz/biz/cmd/biz
go build -o ${INSTALL}/bin/biz

echo "build msg ..."
cd ${TEAMGRAMAPP}/messenger/msg/cmd/msg
go build -o ${INSTALL}/bin/msg

echo "build sync ..."
cd ${TEAMGRAMAPP}/messenger/sync/cmd/sync
go build -o ${INSTALL}/bin/sync

echo "build bff ..."
cd ${TEAMGRAMAPP}/bff/bff/cmd/bff
go build -o ${INSTALL}/bin/bff

echo "build session ..."
cd ${TEAMGRAMAPP}/interface/session/cmd/session
go build -o ${INSTALL}/bin/session

echo "build gnetway ..."
cd ${TEAMGRAMAPP}/interface/gnetway/cmd/gnetway
go build -o ${INSTALL}/bin/gnetway

#echo "build httpserver ..."
#cd ${TEAMGRAMAPP}/interface/httpserver/cmd/httpserver
#go build -o ${INSTALL}/bin/httpserver
