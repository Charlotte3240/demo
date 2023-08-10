import random
from typing import Optional

a = 10

if a > 10:
    print(">")
elif a < 10:
    print("dsad")
else:
    print("<")

# 3.10 之后才有的
match a:
    case 1:
        print("value is 1")
    case _:
        print("default")

print('产生一个随机数 %d' % random.randint(1, 10))

i = 0
sum = 0
while i < 100:
    i += 1
    sum += i

print(i, sum)

fruits = ["apple", "banana", "cherry"]

for i, fruit in enumerate(fruits):
    print(f"下标{i}, 名称{fruit}")

for i in range(3, 10, 2):
    print(i)

__str = "dasds"
print(f"str lengh {len(__str)}")


def sum_int(p1: int, p2: float) -> Optional[int]:
    """
    #-> int | None:  可以换成可选值

    """
    if p2 > 3:
        return None
    return int(p1 + p2)


def gen_none() -> str | None:
    return None


result = sum_int(1, 3.3)

print(f"result is not none? {result is not None}")

print(f"sum is {type(result)}  {result}")

result2 = gen_none()

print(f"gen none si {type(result2)} {result2}")

print(result == result2)

result3: int = 0

def check_result(x: int, y: int) -> int | None:
    """
    检查result
    :param x: x value
    :param y: y value
    :return: x,y fn values
    """
    # 把局部变量,映射到全局变量，这样才可以在函数内修改外部变量
    global result3
    result3 = x + y
    return result3


check_result(1, 2)

print(result3)