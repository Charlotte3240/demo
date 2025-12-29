#/bin/bash

echo "start build"
go build
echo "build end"

echo "starting app: go-http-server"
nohup ./go-http-server > nohup.out 2>&1 &
echo "started app: go-http-server"

tail -n 30 ./output/log.log