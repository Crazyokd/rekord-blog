---
title: Google C++ Style Guide
date: 2023/09/28
updated: 2023/09/28
index_img: https://cdn.sxrekord.com/blog/cplus.png
banner_img: https://cdn.sxrekord.com/blog/cplus.png
categories: 
- 技术
tags:
- C/C++
- 规范
---


# Google C++ Style Guide

> **片面摘选，仅供参考**
- Do not use [non-standard extensions](https://google.github.io/styleguide/cppguide.html#Nonstandard_Extensions).

# 头文件

- 通常一个cc文件对应一个.h文件，但是单元测试和很小的cc文件（仅包含一个main函数）除外
- 头文件应是能独立编译的；而*包含文件*后缀应为.inc（慎用）
- 头文件都应该有[header guards](https://google.github.io/styleguide/cppguide.html#The__define_Guard)，并包含所依赖的其他头文件
- 头文件中的内联和模板应当定义（直接或间接），并且这些定义不要拆分成多个头文件
- header guards 格式为*<PROJECT>*_*<PATH>*_*<FILE>*_H_
- 仅包含需要的头文件，没用到的不要include
- 不要依赖“依赖传递”，比如a.h需要b.h和c.h，而b.h已经包含了c.h，此时a.h应仍然把c.h包含进来。
- 内联函数应少于等于10行
- cc文件包含头文件的顺序为：直接对应头文件、c标准库（带.h)、c++标准库(不带.h)、第三方库、你自己项目中定义的其他头文件。每种类别以空行分隔

# 域

## 命令空间

- 命令空间命名为全小写，以下划线分隔
- 命令空间的`}`后加上命名空间结束的注释
- 不要使用内联命令空间

## 内部链接

cc中定义的函数使用static修饰或使用匿名命名空间包裹

## 局部变量

- 尽可能在使用它的地方声明/定义它
- 仅在if、while、for中使用的变量应当在对应的`()`中定义，但如果是类类型，就需要慎重考虑一下。

## 静态变量和全局变量

- 析构的代价尽可能小

# 类

- 避免隐含的转换，对转换操作符应当使用explicit进行修饰。
- 类的公共API必须对是否可拷贝、是否可移动有一个清晰的认识
- 继承应当使用public修饰
- 类的数据成员应当是private，除非它们是常量
- 对虚函数和虚析构器显式的使用`override`或`final`
- public声明在前，然后是protected 和 private，每一部分的内容遵循以下顺序：
    1. Types and type aliases (`typedef`, `using`, `enum`, nested structs and classes, and `friend` types)
    2. (Optionally, for structs only) non-`static` data members
    3. Static constants
    4. Factory functions
    5. Constructors and assignment operators
    6. Destructor
    7. All other functions (`static` and non-`static` member functions, and `friend` functions)
    8. All other data members (static and non-static)

# 函数

- 优先使用return，而非“outputparameter”，return的值最好是一个值其次是引用，最好不要使用指针，除非返回的这个值可能为NULL。
- `Non-optional input parameter`通常应为值或常量引用，而`non-optional output and input/output parameter`通常应为引用。`optional outputs and optional input/output parameters`使用非常量指针。
- 尝试拆分长函数
- 允许在非虚函数中使用形参默认值
- 尽量不使用尾后返回值

# google魔法

- 清楚指针的所有者，如果无法确定，将所有权交给智能指针
- 使用`cpplint.py`检查风格错误

# 其他C++特性

- 不适用C++异常
- 避免使用运行时类型信息(RTTI)，即`typeid`和`dynamic_cast`
- 尽量使用`++i`
- 尽量使用const
- 只使用int不使用其他的整型，比如short用int16_t替代。
- 避免定义宏，特别是在头文件中
- 使用`nullptr`而不是`NULL`，空字符使用`’\0’`
- 尽量使用`sizeof(varname)`代替`sizeof(type)`
- 尽量不依赖类型推断
- 避免复杂的模板编程
- 如果switch条件不是一个枚举值，switch必须带一个default语句

# 命名

- 越是局部的名字就可以更精悍一些，越是一些公共的名字可以更详细一点，并尽量避免缩写。
- 文件名应当全小写，并考虑使用下划线`_`或中划线`-`分隔
- classes, structs, type aliases, enums, and type template parameters的命名遵循大驼峰
- 变量名（包括形参名、成员变量名）使用`snake_case`(全小写，使用下划线分隔）
- 类（struct不在此列）成员变量可以考虑在snake_case的基础上添加一个尾下划线
- 常量名以`k`开头，后跟大驼峰，如果大驼峰不足以起到分隔的目的，就使用下划线如
    
    `const int kAndroid8_0_0 = 24;  // Android 8.0.0`
    
- 一般的函数命名也是大驼峰，但是getter和setter应当使用不带尾下划线的变量式命名，如`void set_count(int count)`
- 命名空间的名称应当使用不带尾下划线的变量式命名，另外尽量不要使用缩写。最高层的命名空间应当基于项目名。
- enum内部的值应当以常量名的方式命名
- 宏的命名使用全大写加下划线分割，不要使用尾下划线。
- 想和现有的C/C++命名方案兼容，考虑使用下面的命名规则：
    
    `bigopen()`
    
    function name, follows form of `open()`
    
    `uint`
    
    `typedef`
    
    `bigpos`
    
    `struct` or `class`, follows form of `pos`
    
    `sparse_hash_map`
    
    STL-like entity; follows STL naming conventions
    
    `LONGLONG_MAX`
    
    a constant, as in `INT_MAX`
    

# 注释规范

- 每个文件以许可证模板开头，如果需要的话，还应当加上一些抽象说明。不应该包含日期和作者。
- 类注释
- 函数注释既需要出现在函数定义的地方（how）也需要出现在函数声明的地方（what）

# 格式

- 每行不超过80列，但可以有以下几种例外：
    - `using`声明
    - `header-guard`
    - `include`语句
    - 不好拆分的注释
    - 不好拆分的字符串字面量
- 最好不要使用非ASCII字符
- 不要使用tab，一个tab应为2个空格
- 返回类型和函数名在同一行，参数最好也在同一行，如果参数太长，第二行的参数与第一行参数对齐。如果第一行长到连参数也放不下，那就缩进四个空格将形参放在下一行。（**函数声明、定义和调用都遵循此条原则**）
- 如果函数在定义中用到了某个形参，在声明中也记录名字。
- 超过一行的函数调用除调用的最后一行均以逗号结尾。
- 可变形参格式为`, args...`
- 列表初始化第一行以`{`结尾，最后一行以`};`结尾
- 循环或分支等语句处的空格细节和阿里巴巴Java开发手册一致
- 将布尔表达式拆成多行，以&&或||作为前一行的结尾
- 预处理指令前面不应有任何空格缩进
- `public/protected/private` 前缩进一个空格
- 成员属性/成员方法前缩进两个空格
- 构造初始化的`:`放在下一行，前面缩进4个空格，更多行的参数与上一行的参数对齐
- 命名空间中的内容不缩进
- 每行的结尾一定不能有空格
- 赋值语句超过80列以`=`进行拆分，第一行以`=`结尾，第二行缩进四个空格。
