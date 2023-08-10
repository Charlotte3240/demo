import typing


def foo(url: str, method: str, op: callable([[str, str], str])):
    return op(url, method)


def req_devices(url: str, method: str):
    return url + method


res = foo("https://www.baidu.com","get", req_devices)
print(res)


print(foo("123","456",lambda url,method: url + method))