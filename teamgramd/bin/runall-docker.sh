#!/usr/bin/env bash

echo "run idgen ..."
chmod +x idgen
nohup ./idgen -f=../etc2/idgen.yaml >> ../logs/idgen.log  2>&1 &
sleep 1

echo "run status ..."
chmod +x status
nohup ./status -f=../etc2/status.yaml >> ../logs/status.log  2>&1 &
sleep 1

echo "run authsession ..."
chmod +x authsession
nohup ./authsession -f=../etc2/authsession.yaml >> ../logs/authsession.log  2>&1 &
sleep 1

echo "run dfs ..."
chmod +x dfs
nohup ./dfs -f=../etc2/dfs.yaml >> ../logs/dfs.log  2>&1 &
sleep 1

echo "run media ..."
chmod +x media
nohup ./media -f=../etc2/media.yaml >> ../logs/media.log  2>&1 &
sleep 1

echo "run biz ..."
chmod +x biz
nohup ./biz -f=../etc2/biz.yaml >> ../logs/biz.log  2>&1 &
sleep 1

echo "run msg ..."
chmod +x msg
nohup ./msg -f=../etc2/msg.yaml >> ../logs/msg.log  2>&1 &
sleep 1

echo "run sync ..."
chmod +x sync
nohup ./sync -f=../etc2/sync.yaml >> ../logs/sync.log  2>&1 &
sleep 1

echo "run bff ..."
chmod +x bff
nohup ./bff -f=../etc2/bff.yaml >> ../logs/bff.log  2>&1 &
sleep 5

echo "run session ..."
chmod +x session
nohup ./session -f=../etc2/session.yaml >> ../logs/session.log  2>&1 &
sleep 5

echo "run gnetway ..."
chmod +x gnetway
nohup ./gnetway -f=../etc2/gnetway.yaml >> ../logs/gnetway.log  2>&1 &
sleep 1

#echo "run httpserver ..."
#nohup ./httpserver -f=../etc/httpserver.yaml >> ../logs/httpserver.log  2>&1 &
#sleep 1
