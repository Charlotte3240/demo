- Name:AVDemoKey
- Key ID:K7AYSC553X
- Services:Apple Push Notifications service (APNs)



## 设备注册

```curl
# env 环境标识 0: 测试环境， 1:生产环境
# iden手机标识
# deviceToken
# bundleId

curl --location 'https://api.hc-nsqk.com/register' \
--header 'Content-Type: application/json' \
--data '{
    "env":0,
    "iden":"xx",
    "deviceToken":"asdbsa1d111",
    "bundleId":"dasdasadsa"
}'
```



## 单个设备推送

```culr
curl --location 'https://api.hc-nsqk.com/push' \
--header 'Content-Type: application/json' \
--data '{
    "env": 0,
    "iden": "iPhone",
    "deviceToken": "2e8a9c225ae556456629fe3abac6a5646d4408524046db455a95a9b0cbb53796",
    "bundleId": "com.charlotte.HCWebRtc.ipa",
    "payload": "{\n        \"aps\": {\n            \"alert\": {\n                \"body\": \"新增了推送功能\",\n                \"title\": \"app有新版本可以更新了\"\n            },\n            \"sound\": \"default\",\n            \"badge\": 1\n        },\n        \"custom1\": \"custom information\"\n }"
}'
```



## 多个设备推送

```curl
curl --location 'https://api.hc-nsqk.com/pushMultiple' \
--header 'Content-Type: application/json' \
--data '{
    "env": 1,
    "bundleId": "com.charlotte.HCWebRtc.ipa",
    "payload": "{\n        \"aps\": {\n            \"alert\": {\n                \"body\": \"新增了推送功能\",\n                \"title\": \"app有新版本可以更新了\"\n            },\n            \"sound\": \"default\",\n            \"badge\": 1\n        },\n        \"custom1\": \"custom information\"\n }"
}'
```

