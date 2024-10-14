---
title: 解决vscode中引用c++外部库报错
date: 2021/10/16
index_img: https://cdn.sxrekord.com/blog/cplus.png
banner_img: https://cdn.sxrekord.com/blog/cplus.png
categories: 
- 技术
tags:
- C/C++
---

`Visual Studio Code`用了也有一段时间了，其中它的**小巧**、**美观**给我留下了很深的印象。

最近做了两次计算机图形学实验，其中一个实验必须引用外部的图形库，但是在使用vsCode完成这样一项“简单”的工作时却报错不断:cry::cry:。甚至一度让我放弃去使用。（当然重量级的vs2017又很快将我劝回来了！:joy:)

今天总算真正决定去弄清并解决这个问题。:fist_right::fist_right:

下面是几点收获（包括原理和解决方案）

- ### **[g++与gcc的区别](https://zhuanlan.zhihu.com/p/100050970)**

    结论：**写c++选g++更好！**

    

- ### **g++编译器相关命令行参数**

    * `-o 文件名.exe`，通过`-o`参数指定编译后得到的exe程序名。

    * `-I 外部include路径`，通过`-I`参数指定外部include的路径，实现导入外部包的效果。

    * `-L 外部lib路径`，通过`-L`参数指定外部lib的路径，为下面的`-l`参数提供搜索地址。

    * `-l[链接文件(去除lib前缀和.a后缀)]`，通过`-l`参数指定链接lib*.a文件，下面是一个例子：

        ![链接依赖](https://user-images.githubusercontent.com/74645100/136906636-98339484-45c5-44d8-adfe-7141a1d46210.png)



- ### **c++程序的编译和运行过程**

    * 通过`g++ 文件名1.cpp 必要的命令行参数`对cpp源文件进行编译。（编译成功后会得到一个`.exe`可执行文件，但不会**自动执行**）
    * 命令行直接输入exe文件名(包括后缀)运行exe可执行程序。



- ### **tasks.json与c_cpp_properties.json**

    * `c_cpp_properties.json`文件中的`includePath`包含的路径将会成为编辑器内部intelliSense的关键，但**与实际编译过程无关**。（**tip**:`ctrl+shift+P`输入`Edit configurations(UI)`即可通过图形化界面选择选项自动配置生成`c_cpp_properties.json`文件的相关参数）

    * `tasks.json`文件中的`args`包含的参数将会在编译时作为命令行参数使用（即ctrl+f5）。

    结论：若要引入外部库，需要同时配置**`c_cpp_properties.json`文件中的`includePath`和`tasks.json`文件中的`args`**，从而实现无论是开发过程还是编译过程均不报错。




- ### **解决方案**

    0. 如果你安装了`C/C++ Compile Run`插件，该插件在Windows上可通过键入`F6`快速编译运行程序。其实它就是帮你实现了上述编译运行过程的两个步骤。但是***命令行参数的灵活性自然也被舍弃了***。。。

         所以果断**舍弃这个插件**吧！￣□￣｜｜

    1. 配置`c_cpp_properties.json`文件中的`includePath`和`tasks.json`文件中的`args`，在includePath变量中添加你的外部include地址，在args变量中添加`-I 外部include地址`和`-L 外部lib地址`参数。
    
    2. 编译默认库时是不需要带`-I`和`-L`参数的，换言之，内部库的位置不需要额外指定，此时**将外部库的文件手动移植到默认库的位置**就可以达到引用外部库的效果了，此时仅在必要情况下配置`-l`参数。



---




下面解决一个实际问题————vscode导入EGE图形库。

- 作为形式上的内部库

    * [下载](https://xege.org/)相关依赖包

    * 将对应的`include`和`lib`文件夹放入内部库的`include`和`lib`文件夹

    * 在`tasks.json`文件中添加如下库依赖参数：

    ![库依赖参数](https://user-images.githubusercontent.com/74645100/136908758-19e46f61-d01e-4857-82c6-4c69a9c1be99.png)

- 完全作为外部依赖

    * [下载](https://xege.org/)相关依赖包
* 配置`c_cpp_properties.json`文件中的`includePath`，使其指向你的外部库的include位置
    * 在`tasks.json`文件中添加lib依赖路径
* 在`tasks.json`文件中添加include依赖路径（文件位置仅供参考）
    
![tasks_args](https://user-images.githubusercontent.com/74645100/137584363-1e714351-6830-49e6-acdf-0343538936f7.png)
    
* 在`tasks.json`文件中添加库依赖参数。
    
    ![库依赖参数](https://user-images.githubusercontent.com/74645100/136908758-19e46f61-d01e-4857-82c6-4c69a9c1be99.png)

