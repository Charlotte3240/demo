f = open("./function.py",'r+',encoding='utf-8')
# 读取指定字符数，如果模式是b 是字节数
# print(f.read(160))

# 不传入参数 读取全部内容
# print(f.read())

# 读取一行
print(f.readline())

# 读取几行
for r in f.readlines(3):
    print(r)

f.close()

# 自动关闭文件
with open("./function.py","r+") as f:
    print(f.read())

# close 内置了flush 功能，所以自动关闭文件 也会 自动flush
with open('./test.txt', "w+") as f:
    f.write('hello world')

with open('./test.txt', 'a+') as f:
    f.write("123467890")
    print(f.read())

# w 清空 创建文件 写入

# a 追加 创建文件 写入
