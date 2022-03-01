---
layout: post
title: 在VSCode上配置JavaWeb环境
date: 2021/11/25
updated: 2021/11/25
comments: true
categories: 
- GitHub
tags:
- vscode
- Java
- GitHub
---

## 前置要求
### Java环境
- jdk11及以上
> vscode中配置Java环境要求jdk11及以上，_笔者使用的版本为jdk11_

### Tomcat
- 实测`jdk11 + apache-tomcat-8.0.50`能正常配合使用。
> 其他组合欢迎读者评测后评论留言 :)

### vscode插件
- [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
- [Language Support for Java(TM) by Red Hat](https://marketplace.visualstudio.com/items?itemName=redhat.java)
- [Debugger for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-debug)
- [Java Server Pages (JSP)](https://marketplace.visualstudio.com/items?itemName=pthorsson.vscode-jsp)
> 可以先安装`Extension Pack for Java`，再卸载其内部未列于列表的其他插件(~~当然，安装应该也不无不可~~)
> 
> `Java Server Pages (JSP)`可选

## 目录结构
```
project
    |__package_name
    |       |
    |       |__*.java
    |
    |__WEB-INF
    |       |
    |       |__classes
    |       |       |
    |       |       |__*.class
    |       |
    |       |__lib
    |       |
    |       |__web.xml
    |
    |__META-INF
    |       |
    |       |__MANIFEST.MF
    |
    |__index.jsp/index.html
    |
    |__static_rs/(可选)
```

## 具体配置
### 添加jar包
- `ctrl + shift + P`搜索`Java:Configure Classpath`
    * 在**`Referenced Libraries`**下添加外部Jar包(_主要包括Tomcat的lib目录下的一些jar包_)
- 使用`.vscode/settings.json`文件进行配置(~~对相关参数在此不再说明~~)
> 使用上述两种方式需要安装`Extension Pack for Java`插件。

### 项目部署
- 在`Tomcat/conf/Catalina/localhost/` 目录下添加项目相关的xml文件。
- 一个简单的实例：
    ```xml
    <Context path="/项目名" docBase="项目真实路径（即当前工作区目录）" />
    ```
> **该xml文件名为浏览器上url访问的项目名，与文件中的path属性无关**

### 解释.java文件
使用下列命令手动编译：
```shell
javac .\package_name\**.java -d .\WEB-INF\classes\  
```

> 每次编译后需要重启服务器才能看到更新。(~~实测~~)

## 额外说明
- xml文件的部署和java文件的编译推荐使用脚本执行。
- 静态资源的更改刷新浏览器即可看到更新。
- web.xml文件的配置很重要，不过在此不再赘述。


**一个简单的example已经上传到[Crazyokd/JW_VSC-Template](https://github.com/Crazyokd/JW_VSC-Template)**