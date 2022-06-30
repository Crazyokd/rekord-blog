---
layout: post
title: about .exe and .msi file extensions
date: 2022/06/28
updated: 2022/06/28
comments: true
categories: 
- 技术
tags:
- Windows
---

**[原文链接](https://support.solarwinds.com/SuccessCenter/s/article/About-exe-msp-and-msi-file-extensions?language=en_US)**
**[原文链接](https://blog.csdn.net/weixin_43924896/article/details/120707191)** 

## 概述
本文介绍了在使用第三方软件包时 Patch Manager 中使用的以下文件扩展名：
- .EXE
- .MSI

## 环境
Patch Manager 2.1 - EOL; Patch Manager Eval

在Windows上安装软件的时候，一般有两种方式：
1. Windows安装包（.msi）
2. Windows二进制文件（.exe）

这两种安装方式的区别如下：
- .exe是一个安装引导程序。它是安装工程通过MSBuild创建的，其中包含了一个XML文件，定义了应用程序所需要的系统必备安装包信息。Setup.exe程序会检查这些系统必备安装包是否需要被下载和安装，如果需要，它就会先安装那些系统必备程序。当我们运行它的时候，它会读取setup.ini来确定安装所需要的配置并开始安装流程。
- .msi是一个Windows　Installer包。和.exe不一样，直接运行MSI安装包不会自动安装自定义系统必备。它只会安装主应用程序。当我们“运行”它的时候，其实是Windows Installer在执行MSI包定义的各项操作。因此我们需要安装Windows Installer的正确版本才能运行.msi。


另外，
- .msi是微软的自解压文件，如安装某些软件时就是这种文件格式打包而成的，Windows系统中自带有软件将其解压。正如WINRAR可以将文件压缩成.rar文件，也可以将.rar文件解压一样；
- 而.exe是可执行文件类型，通俗一点来说.exe文件是不依靠其他软件而单独运行的文件（当然不能脱离系统），因为.exe就是软件。


最后，
- msi是Windows installer开发出来的程序安装文件，是Windows installer的数据包，把所有和安装文件相关的内容封装在一个包里了。
- .exe也允许你安装程序,但程序员在开发.exe的时候要比开发.msi困难的多,需要人工编写和安装,修改,卸载相关的很多内容。而msi把这写功能都集成化了，易于开发WINDWOS程序安装包。


## Resolution
### EXE
EXE是包含可在计算机上执行的程序的文件的文件扩展名。
### MSI
MSI是一个文件扩展名，适用于Microsoft Windows Installer（MSI）使用的数据库文件。它们包含有关应用程序和组件的应用程序的信息，每个组件都可能包含文件，注册表数据，快捷方式等。

MSI文件安装计算机代码，而EXE文件可以是在Windows计算机上运行的任何文件。


**[原文链接](https://www.cnblogs.com/wangjiquan/p/7446981.html)**
.msi和.exe 文件的区别:

有些软件的正本里面同时含有 setup.msi 程序和 setup.exe 程序，例如 Symantec AntiVirus 客户端的软件里就含有 setup.MSI 和 setup.exe 两个安装程序。一般情况下随便用其一进行程序的安装，结果是一样的。

但是如果我们的操作系统(安装环境)没有安装某些程序，则.MSI有可能不能运行，这时就要用Setup.exe来进行安装了。Setup.exe可以利用Setup.ini来先安装运行.MSI需要的软件，建造一个较全的安装环境，最后再调用.MSI程序。

所以当你确定你的安装环境不缺少什么应该安装的程序时，可以直接运行.MSI来安装软件的副本。

对于 Symantec AntiVirus 软件来说，Setup.exe 的一个主要功能就是先安装WindowsInstaller.exe最新版，因为所有的.MSI程序都需要系统里装有WindowsInstaller.exe才能正常运行。


总结: 
- .exe文件进行安装的时会检测安装软件需要的环境和一些必要的组件, 适不适合当前软件安装, 如果缺少一些例如.netframework一类的组件, 就会先进行下载然后再进行安装 
- .msi文件不检测当前系统环境是否符合就直接进行安装, 如果环境不符合运行到一半可能会停止安装,并报错或提示,其实是Windows Installer在执行MSI包定义的各项操作。因此我们需要安装Windows Installer的正确版本才能运行setup.msi

          
我们都知道通过VS工具自带的打包后会生成两个文件，一个是exe文件，一个是msi文件。

需要说明的是msi文件时windowinstaller开发出来的程序安装文件，它可以让你安装、修改、卸载你所安装的程序，也就是说VS工具打包生成的msi文件就是window installer的数据包，把所有和安装文件相关的内容封装在一个包里。

VS工具打包生成的exe文件是主要是用于检查安装的环境，当安装的环境检查成功后，会自动再安装msi文件。当然可能会有exe文件也能直接安装的，但是开发exe的时候要比msi困难多，因为需要编写和安装、修改、卸载相关的很多内容，而msi把这些功能都集成化了，易于开发windows程序安装包。