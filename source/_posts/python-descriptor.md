---
title: Python中的描述符
index_img: https://cdn.sxrekord.com/v2/Python.png
banner_img: https://cdn.sxrekord.com/v2/Python.png
date: 2025-09-13 19:55:13
updated: 2025-09-13 19:55:13
categories:
- 技术
tags:
- Python
- 学习笔记
---

Python中的描述符(descriptor)协议是下面三个函数：

`__get__(self, instance, cls)`

`__set__(self, instance, value)`

`__delete__(self, instance)`

定义了这些方法中的任何一个的对象被视为描述符，从而就可以覆盖作为属性查找时的默认行为。

如果一个对象同时定义了`__get__`和和`__set__`，则它会被视为数据描述符。 仅定义了__get__的被称为非数据描述符。

二者的主要区别是访问优先级。如果实例的__dict__中具有与数据描述符同名的key，则数据描述符优先。如果具有与非数据描述符同名的key，则__dict__优先。

python中的描述符看起来很像类属性，或者类比于其它语言中的类静态变量。

但理解一些隐晦的用法后你就会发现这背后的原理和你过去想的大不相同。

# 背景

有些时候我们可能需要控制实例属性的访问和修改操作，这时候在其它语言中我们会定义相应的getter和setter，而在python中一般是@property。

但如果某一种类型的实例属性有多个呢？这时候为每一个实例属性分别定义基本一致的@property无疑违背了DRY原则。

此时描述符(Descriptor)就登场了。

# 使用

语法基本就是在类中直接定义成员，并限定该成员为描述符类型。

```Python
class Integer:
    def __init__(self, name):
        print('Integer __init__', name)
        self.name = name

    def __get__(self, instance, cls):
        print('Integer __get__')
        return
        if instance is None:
            return self
        else:
            return instance.__dict__[self.name]

    def __set__(self, instance, value):
        print('Integer __set__')
        if not isinstance(value, int):
            raise TypeError('Expected an int')
        instance.__dict__[self.name] = value

    def __delete__(self, instance):
        print('Integer __delete__')
        del instance.__dict__[self.name]

class Point:
    x = Integer('x')
    y = Integer('y')

    def __init__(self, x, y):
        print('Point __init__')
        self.x = x
        self.y = y

# 输出：
# Integer __init__ x
# Integer __init__ y
```

之后对self.x/self.y的访问、修改和删除就会自动调用到描述符的__get__、__set__和__delete__函数了。

```python
p = Point(1, 2)

# 输出：
# Point __init__
# Integer __set__
# Integer __set__
```

执行这条语句就会分别调用两个描述符对象(x和y)的__set__函数。

# 描述符对象实例

如果之后这个类又生成了其他实例，且不断访问和修改各实例的self.x/self.y，这时候整个虚拟机中存在几个描述符对象实例呢？

```python
points = []
for i in range(10)
	point = Point(i, i)
	points.append(point) # 防止回收
	self.x = i + i
	print(self.x)
	self.y = i * i
	print(self.y)

```

答案是两个。

描述符实例属于类级别，只有通过类定义或者修改(形如Point.x = xxx)才能真正影响描述符对象实例的数量。

而上面的代码全都是创建Point实例并修改和访问最开始类定义时创建的两个描述符实例对象。

所以实例对描述符的修改操作其实是发生在描述符内部，可能会影响这个描述符实例的内部状态，但一般不影响描述符实例的创建和消亡。

也正因为如此，我们尽量不会修改描述符实例本身的内部状态，而是更新和访问instance参数的内部状态，该参数代表的就是调用的某个具体的Point实例。

往深一点思考不难发现，其实形如p.x = 3这样的语句底层来看完全不能算作赋值语句，因为=左右两边的类型完全不一致，左边是Integer类型，右边是int内置类型。

> `p.x = 3  ==>  Integer.__set__(x, p, 3)`

---

下面的代码，才是真正更改了p.x的类型。

```python
class AnotherDescriptor:
    def __get__(self, instance, cls):
        print('AnotherDescriptor __get__')

Point.x = AnotherDescriptor()
print(p.x)

# 输出：
# AnotherDescriptor __get__
```

如果通过Point.y将y设置为一个非描述符对象，这就涉及到__dict__了。

# 与__dict__的关系

如果__dict__中存在与描述符同名的属性，则要看描述符是数据描述符还是非数据描述符。

如果是数据描述符，__dict__中的条目会被覆盖，所有实例访问该属性时共享数据描述符对象。

如果是非数据描述符，__dict__中的条目优先级更高，这时候类中定义的这个非数据描述符属性更像是充当Point实例最开始访问同名属性默认值的效果。

```python
class Point:
    x : int = 1

    def __init__(self):
        pass

p = Point()
print(p.x)
p.x = 2 # 覆盖
print(p.x)

# 输出：
# 1
# 2
```

第一次访问p.x时由于p的__dict__中还没有x属性，所以会访问到类属性x。当执行p.x = 2时会在__dict__中创建条目——{x: 2}，之后对x的访问就全是基于这个条目了。

# 参考

* https://docs.python.org/3.6/howto/descriptor.html

‍
