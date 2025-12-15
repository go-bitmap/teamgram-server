#!/bin/sh

SRC_DIR=.
DST_DIR=$GOPATH/src/

#GOGOPROTO_PATH=$GOPATH/src/github.com/gogo/protobuf/protobuf
MTPROTO_PATH=$(go list -m -f '{{.Dir}}' github.com/teamgram/proto)/mtproto

protoc -I=. -I=$MTPROTO_PATH --proto_path=$(go env GOPATH)/src:. --go_out=. --go-grpc_out=require_unimplemented_servers=false:. $SRC_DIR/*.proto

# Move generated files from github.com/teamgram/teamgram-server/... to current directory
if [ -d "github.com" ]; then
    mv github.com/teamgram/teamgram-server/app/service/biz/help/help/*.pb.go . 2>/dev/null
    rm -rf github.com 2>/dev/null
fi

#protoc -I=$SRC_DIR:$MTPROTO_PATH --proto_path=$GOPATH/src:$GOGOPROTO_PATH:./ \
#    --gogo_out=plugins=grpc,Mgoogle/protobuf/wrappers.proto=github.com/gogo/protobuf/types,:$DST_DIR \
#    $SRC_DIR/*.proto
#protoc -I=$SRC_DIR --proto_path=$GOPATH/src:$GOPATH/src/nebula.chat/vendor:$GOGOPROTO_PATH:./ \
#    --gogo_out=plugins=grpc,Mgoogle/protobuf/wrappers.proto=github.com/gogo/protobuf/types,:$DST_DIR \
#    $SRC_DIR/rpc_error_codes.proto

gofmt -w *.go

