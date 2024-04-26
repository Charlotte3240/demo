

#  获取所有平台列表

-------------------
> 入参：无
返回：返回所有平台列表

##### 地址： http://150.158.10.87/rpa/api/platform/list
###### Get请求参数,请求类型：application/json; charset=utf-8
###### Header参数: Authorization: Basic {{Token}}
###### 签名方式：Token: Base64.Encode(keyuser:JHyzA6VQhNNdDNMcDRrXq48wH1YDNw5)
##### 回调结果

| 参数名称    | 是否返回 | 字段类型   | 描述      |
|---------|------| ---------- |---------|
| Code   | 否    | string     | 返回错误描述  |
| Msg | 否    | string     | 返回的消息状态 |
| Data    | 是    | dictionary | 返回结果    |

###### DATA 结果描述
| 数据名称        | 是否返回 | 字段类型 | 描述     |
|-------------|----|------|--------|
| List | 是   | List | 返回执行结果 |

````json
{
  "Code": 0,
  "Msg": "SUCCESS",
  "Data": {
    "List": [
      {
        "id": 1,
        "created_at": "2024-04-18T00:59:45+08:00",
        "updated_at": "2024-04-18T00:59:45+08:00",
        "title": "公积金平台",
        "file": "ccb.js",
        "url": "https://igjj.ccb.com/qgzfgjj/login",
        "enable": true
      },
      {
        "id": 2,
        "created_at": "2024-04-18T00:59:45+08:00",
        "updated_at": "2024-04-18T00:59:45+08:00",
        "title": "个人所得税平台",
        "file": "chinatax.js",
        "url": "https://www.etax.chinatax.gov.cn/webstatic/login",
        "enable": true
      }
    ]
  }
}
````
---

# 读取平台脚本

-------------------

##### 地址： http://150.158.10.87/rpa/api/platform/resource
###### POST请求参数,请求类型：application/json; charset=utf-8
###### Header参数: Authorization: Basic {{Token}}
###### 签名方式：Token: Base64.Encode(keyuser:JHyzA6VQhNNdDNMcDRrXq48wH1YDNw5)
##### 请求参数

| 参数名称 | 是否必填 | 字段类型   | 参数说明 |
|------|------|--------|------|
| id   | 是    | string | 平台ID |

```` json
{
  "id": 106
}
````
##### 回调结果

| 参数名称    | 是否返回 | 字段类型   | 描述      |
|---------|------| ---------- |---------|
| Code   | 否    | string     | 返回错误描述  |
| Msg | 否    | string     | 返回的消息状态 |
| Data    | 是    | dictionary | 返回结果    |

###### DATA 结果描述
| 数据名称        | 是否返回 | 字段类型    | 描述                                            |
|-------------|----|---------|-----------------------------------------------|
| Id | 是   | string  | 平台ID                                          |
| Url | 是   | string  | 平台访问地址i                                       |
| Name | 是   | string  | 平台名称                                          |
| Js | 是   | string  | 基于AES（PKCS#7填充）对称加密的密文脚本, 需要使用AES解密（测试用解压密码：1234567890123456） |

````json
{
  "Code": 0,
  "Msg": "SUCCESS",
  "Data": {
    "Id": 2,
    "Js": "vnOOqjOgb8FO5rdjH9hWmWd+DnubVH9TwIxNGoqebgpHRvrbJVUptY9yuSIpXakE5cE=",
    "Name": "个人所得税平台",
    "Url": "https://www.etax.chinatax.gov.cn/webstatic/login"
  }
}
````
---

# 保存日志

-------------------

##### 地址： http://150.158.10.87/rpa/api/log/save
###### POST请求参数,请求类型：application/json; charset=utf-8
###### Header参数: Authorization: Basic {{Token}}
###### 签名方式：Token: Base64.Encode(keyuser:JHyzA6VQhNNdDNMcDRrXq48wH1YDNw5)
##### 回调结果

| 参数名称 | 是否必填 | 字段类型   | 参数说明 |
|------|------|--------|------|
| id   | 是    | string | 平台ID |
| logs | 是    | string  | 平台ID |


```` json
{
  "id": 106,
  "logs":"[{\"17138069236011\":\"{\\\"level\\\":1}\"},{\"1713806923607\":\"{\\\"level\\\":2}\"}]"
}
````
##### 回调结果

| 参数名称    | 是否返回 | 字段类型   | 描述      |
|---------|------| ---------- |---------|
| Code   | 否    | string     | 返回错误描述  |
| Msg | 否    | string     | 返回的消息状态 |
| Data    | 是    | dictionary | 返回结果    |

###### DATA 结果描述
| 数据名称  | 是否返回 | 字段类型   | 描述                                                            |
|-------|----|--------|---------------------------------------------------------------|
| Id    | 是   | string | 平台ID                                                          |
| Total | 是   | Int    | 成功插入数量                                                        |

````json
{
  "Code": 0,
  "Msg": "SUCCESS",
  "Data": {
    "Id": 2,
    "Total": 2
  }
}
````
---





## 打包部署方式：
$env:GOOS="linux"
go build -o rpa-linux main.go

LINUX:
chmod 777 rpa-linux
./main-linux

后台运行：
setsid ./rpa-linux
杀死：
ps -ef | grep rpa-linux



iOS平台打包脚本

`sh PICWorkSpace/PICApp/Script/create_xcframework.sh`

