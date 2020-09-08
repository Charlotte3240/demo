import UIKit

let urlStr = "https://www.baidu.com:2333/path/data?key=123&value=321#fragid"

let url = URL.init(string: urlStr)!

let urlReq = URLRequest.init(url: url)

// absoluteURL 绝对网址
print(urlReq.url?.absoluteURL.absoluteString ?? "") //https://www.baidu.com

// host 主机
print(urlReq.url?.host ?? "") //www.baidu.com

// port 端口
print(url.port ?? "端口") //2333

// scheme 协议
print(urlReq.url?.scheme ?? "") //https

// query 查询语句 键值对&
print(urlReq.url?.query ?? "") // key=123&value=321

// relative 相对路径
print(urlReq.url?.relativeString ?? "") //https://www.baidu.com:2333/path/data?key=123&value=321#fragid
print(urlReq.url?.relativePath ?? "") //path/data

// fragment 解码后的片段
print(urlReq.url?.fragment ?? "") // fragid
