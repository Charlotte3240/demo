# from moudel import *
import logging
from dataclasses import dataclass, asdict
from typing import List, Any

from flask import json

import moudel as m

print(m.foo(1, 2))

print('stupid 方法调用', m.stupid('sad', 'momo'))

print('后续代码执行')

arr = [21, 25, 21, 23, 22, 20]
arr.append(31)
arr.extend([29, 33, 30])
print(arr[0])
print(arr[-1])
print(arr.index(31))

if 331 in arr:
    print("contained")
else:
    print("not contained")

for e in arr:
    print(e)

r = range(1, 10)


# list: list[Any] = []
#
# if list:
#     print("true")
# else:
#     print('else')
#
# print("next", list)


@dataclass
class Relation:
    friends: [str]


@dataclass
class Person:
    name: str
    age: int
    relation: Relation


person = Person(name='Alice', age=25, relation=Relation(friends=['a', 'b']))
json_data = json.dumps(asdict(person))
print(json_data)

s = '{"name": "Alice", "age": 25, "relation": {"friends": ["a", "b"]}}'
jsonObj = json.loads(s)
p = Person(**jsonObj)
print(p)

# import hc_charlotte.hc
# import hc_charlotte.charlotte
#
# hc_charlotte.hc.foo()
# hc_charlotte.charlotte.foo()

# from hc_charlotte import hc
# from hc_charlotte import charlotte
#
# hc.foo()
# charlotte.foo()

# from hc_charlotte import *
#
# hc.foo()
# charlotte.foo()


import hc_charlotte as h

logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

logger = logging.getLogger('test')

# h.hc.foo()
h.charlotte.foo()

logger.info("hello")

# l = [1, 2, 3, 4, 5]
#
# result = filter(lambda x: x > 2, l)
# print(list(result))
# result = map(lambda item: item * item, l)
# print(list(result))
# print(l)
#
#
# my_gen = (i for i in range(3))
# print(next(my_gen))
# print(next(my_gen))
# print(next(my_gen))
#
# a = [1, 2, 3]
# b = [4, 5, 6, 7]  # zip 函数 短的list 结束后就返回结果了
# c = zip(a, b)
# print(list(c))
#
# print('end')
