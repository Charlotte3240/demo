cd pb \
&& protoc --go_out=../services --go_opt=paths=source_relative \
           --go-grpc_out=../services --go-grpc_opt=paths=source_relative \
           Hello.proto Prod.proto Models.proto Orders.proto Users.proto\
&& protoc -I . \
       --grpc-gateway_out ../services \
       --grpc-gateway_opt logtostderr=true \
       --grpc-gateway_opt paths=source_relative \
       Hello.proto  Prod.proto Models.proto Orders.proto \
&& protoc --go_out=../services --go_opt=paths=source_relative \
           --go-grpc_out=../services --go-grpc_opt=paths=source_relative \
           --validate_out=paths=source_relative,lang=go:../services \
           Models.proto