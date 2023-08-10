import asyncio
import json
import time
from typing import Union


class Demo:
    name: str = None
    # __变量名 代表私有变量
    __private_var: str = 'private string'

    # def __init__(self, name: str):
    def __init__(self, name: str = None):
        self.name = name

    def __str__(self):
        """用于自定义类对象的输出描述"""
        return f"this is class object description"

    def __lt__(self, other):
        """用于对象的比较 > < 操作符"""
        return self.name < other.name

    def __le__(self, other):
        """用于对象的比较 <= >= 操作符"""
        return self.name <= other.name

    def __eq__(self, other):
        """用于对象的比较 == 操作符"""
        return self.name == other.name

    def foo(self) -> str:
        self.__private_func()
        return f"hello world {self.name}"

    def __private_func(self):
        """__方法名 代表私有方法"""
        print(f"this is a private function {self.name} {self.__private_var}")

    @staticmethod
    def static_foo(name: str, wait: int) -> str:
        return f"hello world {name}"


class NFC:
    capability: str = None


class D(Demo, NFC):
    model: str = None
    # 多继承中同名属性 使用先继承的(左边的)
    name : str = 'None1'

    def new_foo(self) -> str:
        return f"this is {self.model}"

    def foo(self) -> str:
        # return super().foo() # 使用父类方法
        return "D foo function"


d1 = Demo('demo')
d2 = Demo('demo')
print(d1 == d2)

d1.foo()

d3 = D()
d3.model = 'ip12'
d3.capability = '读写'
print(d3.foo())
print(d3.new_foo())
print(d3.capability)
print(d3.name)


# 在注释中也可以进行类型注解

d = json.loads('{"msg":"success","code":0}')  # type: dict[str,Any]

dx: dict[str, Union[str, int]] = json.loads('{"msg":"success","code":0}')
