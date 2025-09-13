---
title: Python魔法方法
index_img: https://cdn.sxrekord.com/v2/Python.png
banner_img: https://cdn.sxrekord.com/v2/Python.png
date: 2025-09-13 11:44:13
updated: 2025-09-13 11:44:13
categories:
- 技术
tags:
- Python
- 学习笔记
---

Python 中的魔法方法是指以双下划线开头和结尾的特殊方法，比如 `__init__` 、 `__abs__` 等。

Python 中的内置类定义了非常多的魔法方法。

> 使用dir(o)函数能够快速获知对象所有的方法

魔法方法可以直接被调用，但更多的时候，它会在特定情况下被自动调用。

# 类

## 构造和析构

`__new__(cls, *args, **kwargs)`

`__init__(self, *args, **kwargs)`

```Python
class Foo:
    def __new__(cls, *args, **kwargs):
        print('new...', args, kwargs)
        obj = super().__new__(cls)
        print(obj)
        return obj

    def __init__(self, *args, **kwargs):
        print('init...', args, kwargs)
        print(self)


Foo('a', x=10)
# 输出:
# new... ('a',) {'x': 10}
# <__main__.Foo object at 0x7fc49dc78490>
# init... ('a',) {'x': 10}
# <__main__.Foo object at 0x7fc49dc78490>
```

> 更高阶的内容后面会单开篇章介绍

`__del__(self)`

## 属性访问

* `__getattr__(self, attr_name)`：在实例中找不到属性时调用。
* `__getattribute__(self, attr_name)`：无论是否找到属性均调用。
* `__setattr__(self, attr_name, attr_value)`：对属性赋值时调用。
* `__delattr__(self, attr_name)`：删除属性时调用。

默认情况下对属性的操作都直接作用于self.__dict__上，即使重载了上述方法，最终还是要操作__dict__的，实现这些函数相当于在此之前做一些**前置**逻辑。

## 描述符

见[Python中的描述符](http://sxrekord.com/python-descriptor/)。

# 容器

`__getitem__(self, index)`

`__setitem__(self, key, value)`

`__delitem__(self, key)`

`__contains__(self, ele)`

实现了此方法就能应用in操作符

`__len__(self)`

`__hash__(self)`

与之紧密相关的还有__eq__函数，在set、dict或者frozenset的键判断两个对象是否相等，使用的逻辑是: `obj1.__hash__() == obj.__hash__() and (obj1.id() == obj.id() or obj1.__eq__(obj2))`

---

实际开发时如果真的想实现一些自定义的容器类，建议还是直接继承`collections.abc`包下的基础容器，这样能确保你实现必要的函数。

# 上下文管理
`__enter__(self)`
`__exit__(self)`

# 迭代器
`__iter__(self)`
`__next(self)`

# 类型转换

`__bool__(self)`

`__int__(self)`

`__float__(self)`

`__str__(self)`

`__bytes__(self)`

# 一元操作符

`__pos__(self)`

`__neg__(self)`

`__invert__(self)`

分别表示+、-和~

* `__complex__`：实现内建函数 `complex()`，取复数。
* `__round__`：实现内建函数 `round()`，四舍五入。
* `__ceil__`：实现内建函数 `math.ceil()`，大于原始值的最小整数。
* `__floor__`：实现内建函数 `math.floor()`，小于原始值的最大整数
* `__trunc__`：实现内建函数 `math.trunc()`，朝零取整
* `__index__`：作为列表索引的数字。

```Python
class Index:
    def __index__(self):
        return 1

my_list = [0, 1, 2]  
index = Index()

print(my_list[index])
# 输出:
# 1
```

# 二元操作符

## 比较运算符重载

`__eq__(self, other)`

`__ne__(self, other)`

`__lt__(self, other)`

`__le__(self, other)`

`__gt__(self, other)`

`__ge__(self, other)`

分别实现 `==`、`!=`、 `<` 、 `<=`  、 `>` 、 `>=` 运算符。

## 算数运算符

`__add__(self, other)`

`__sub__(self, other)`

`__mul__(self, other)`

`__truediv__(self, other)`

`__floordir__(self, other)`

`__mod__(self, other)`

`__pow__(self, other)`

`__and__(self, other)`

`__or__(self, other)`

`__xor__(self, other)`

`__lshift__(self, other)`

`__rshift__(self, other)`

`__matmul__(self, other)`

分别表示+、-、*、/、//、%、**、&、|、^、<<、>>和@。

> 这玩意太多了，上面只是简单列举了最常见的。

## 反算数运算符

上面探讨的算数运算符要求位于运算符前面的对象实现，比如：

```python
first + second
```

这个式子中，要求 `first` 必须实现 `__add__` 方法。

但是如果你没办法保证 `first` 的具体实现，那么也可以在 `second` 实现**反算数运算符** `__radd__`，达到同样的效果。

反算数运算的名称就是在正常算数运算符前面加字母 `r`，比如 `__radd__` 、 `__rsub__`，就不展开讲了。

## 增量赋值符

与反算数运算符类似的还有**增量赋值符**，比如最常用的 `+=`：

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y
  
    def __iadd__(self, other):
        return Vector(self.x + other, self.y + other)


v1 = Vector(-1, 2)
v1 += 1
print(v1.x, v1.y)
# 输出:
# 0 3
```

其他的增量赋值符的还有 `__isub__` 、 `__imul__` 等，也不展开列举了。

# 表示相关

`__str__(self)`

`__repr__(self)`

* `__repr__` goal is to be unambiguous
* `__str__` goal is to be readable
* Container’s `__str__` uses contained objects’ `__repr__`

Implement `__repr__` for any class you implement. This should be second nature. Implement `__str__` if you think it would be useful to have a string version which errs on the side of readability.

`__format__(self, spec_str)`

这个方法可以扩展自己在使用format格式化的时候支持的功能集

`__dir__(self)` 定义了调用 `dir()` 时的行为，返回对象的属性、方法的列表

`__dict__` 属性：对于实例，它存储实例属性；对于类，它存储类的属性和方法。

# 可调用

`__call__(self, *args, **kwargs)`

# 参考
- https://www.cnblogs.com/CircleWang/p/17241378.html
- https://github.com/stacklens/python-magic-method-cookbook
