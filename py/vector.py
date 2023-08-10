# 1. 列表 list
from typing import List

arr = [1, 2, 3, 4, 5]
# print(arr[-6]) 越界
# print(arr[6])  越界
value = None
try:
    value = arr[3]
except:
    print("can't get value from list")

print(value)
# find index by value
print(arr.index(3))
# print(arr.index(6)) 6 is not in list
arr[3] = 200
print(arr[3])
print(arr.__contains__(0))

# insert append
arr.insert(0, 19)
print(arr)
arr.append(100)
print(arr)
arr.extend([1, 2, 3])
print(arr)

# del pop
value = arr.pop(0)  # 边界不安全, 但有返回值
print(arr, value)
del arr[1]  # 边界不安全, 没有返回值
print(arr)

# remove 指定元素内容删除
arr.remove(100)
print(arr)

# count 统计传入元素的个数
print(arr.count(3))

# list len
print(len(arr))

# clear
arr.clear()
print(arr)


# 2. 元组 tuple， 元组不可修改
def gen_tuple(x: int, y: str) -> tuple[int, str]:
    return x, y


print("tuple start -------")
print(gen_tuple(1, "2"))

t = (1,)  # 元组如果只有一个元素时，需要有个单独的，


# 3. 字符串 str
string = ["hello", "world"]
print("--->".join(string))


# 4. 集合 set
s = set()
s.add("a")
s.add("a")
print(s)

s1 = {1, 2, 3}
s2 = {2, 3, 4}
r = s1.difference(s2)  # 提取不同值，原集合不变
print(f"diff {r}")

s1.difference_update(s2)  # 消除前面集合中相同部分，会改变原集合，无返回值

print(f"s1 {s1}")
print(f"s2 {s2}")

# 合并集合
print(s1.union(s2))


# 5. 字典 dict

obj = {"msg": "success", "code": 200,"data":{
    "op":1,
    "switch":"off"
}}
print(obj)

# 获取全部的key
print(obj.keys())
print(obj.values())
# 删除元素
obj.pop('msg')
print(obj)
obj['data'].popitem()  # 随机删除一对 键值对
print(obj)
# 遍历
for key, value in obj.items():
    print(key, value)


print(f"len {len(obj)}")

# 清空元素
# obj.clear()
# print(obj)