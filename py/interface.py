class AC:

    def cool(self):
        """制冷"""
        pass


class Geli(AC):
    def cool(self):
        print("geli cool")


class Meidi(AC):
    def cool(self):
        print("meidi cool")


# 参数为interface， 传入实现类
def make_cool(ac: AC):
    ac.cool()


make_cool(Geli())
make_cool(Meidi())
