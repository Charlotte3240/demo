ps -ef | grep go-http-server | grep -v grep | awk '{print $2}' | xargs kill
