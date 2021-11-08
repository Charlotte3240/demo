cd pb \
&& protoc --go_out=../services --go_opt=paths=source_relative \
           --go-grpc_out=../services --go-grpc_opt=paths=source_relative \
           Prod.proto Models.proto Orders.proto \
&& protoc -I . \
       --grpc-gateway_out ../services/Gateway/ \
       --grpc-gateway_opt logtostderr=true \
       --grpc-gateway_opt paths=source_relative \
           Prod.proto Models.proto Orders.proto