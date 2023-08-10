# 捕获单个种类的异常
try:
    print(name)
except NameError as e:
    print("捕获异常", e)

name = 'charlotte'
# 捕获所有异常
try:
    print(name)
except Exception as e:
    print("捕获到了异常", e)
else:
    print("没有异常发生")
finally:
    print('最终要执行的')