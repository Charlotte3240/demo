__all__ = ['foo']
# __all__ 变量  指定导出的内容, 未指定的不能使用 ，仅限于 from moudel import * ,
# 这里的*  和 __all__ 是同一个东西
# 未解析的引用 'stupid'


def foo(x: int, y: int) -> int:
    return x + y


def stupid(x: str, y: str) -> str:
    return x + y


if __name__ == '__main__':
    print(foo(1, 2))

