---
layout: post
title: 博客那点事
date: 2022/05/20
updated: 2022/05/20
comments: true
categories: 
- 折腾
tags:
- website
---

最近这几天陆陆续续完善了博客的几个功能，包括 [RSS 订阅](https://sxrekord.com/atom.xml)、[博客归档页](https://sxrekord.com/archives.html)和[HTTPS](https://en.wikipedia.org/wiki/HTTPS).
同时，这也标志着本网站终于符合了诸如【个人博客】、【个人网站】等标签。

在尘埃落定之前，仅以这篇文章对**《我和博客的故事》**做个小结。
## 最初那股劲
遥想大二下学期那会，需要学一门web课。(~课程全名不记得了~)

前几节课都摸过去了，后面老师布置了第一次作业，才只好买本教材半强制性的学习书本知识并完成作业。

然后发现这东西贼有意思，高效率的所见即所得，就好比学C语言那会初见`printf`。

进一步的深入之后就想着怎么样能部署到服务器，从而脱离*仅支持本地访问*的局限性，然后就了解了服务器、了解了域名。

但是当时的基础是真的差啊，居然选择了一款 Windows 服务器，没钱所以选购的配置又是极低。

上述几个因素综合起来，导致使用阿里云自带的连接工具连接一次服务器真的是极其糟糕的体验。

而且因为Windows服务器没法很好的使用命令行，所以当时也没机会打开 Linux 的大门。

最后搜到一个叫“宝塔”的东西，能自动生成一个web根目录，将本地的文件目录简单的拖过去就成功部署了。

自此，终于完成了资源的非本地部署。

--- 

当我准备继续使用`html+css`大干一场时，（~别笑，真的是这种想法~）又有很多问题来到了我的面前，支开了我的精力。

其中主要包括**域名**和**网站备案**。

其实域名并不是硬性需求，但是我当时看着那些大佬们的个人博客的 URL 可不是一个 IP 地址，而是一个符合个性签名的域名。

现在想想作为一名程序员，使用IP地址访问自己的网站也无伤大雅。属实是舍本逐末了...

至少可以在博客开发出一个较为不错的 release 后，再考虑使用域名替代IP地址。 

---

域名需要实名认证，填写很多个人信息、上传视频保证书等等。

域名弄好了之后，接下来就是映射域名与服务器的IP地址，然后又要进行公网备案，填写的信息大概就是：
1. 网站什么类型、什么性质？
2. 网站的功能大概是怎样的？
3. 是否有登录、注册、评论？

> 这里吐槽一句，完成过程中涉及到的网站体验相当糟糕。

线上通过之后，还需要打印一堆资料，最后去线下公安局签名备案留底。

**【建议没有硬性需求还是别碰域名和网站备案】**

所幸，这些事情最终都成功完成了，但当时由于诸多事务，初心（指搭建个人博客）在很长一段时间内就被遗弃在角落里了。
## 沉寂的日子
网站以一种简单的 html+css 样式被默默的部署在 `sxrekord.com`长达数月。【当然在学了 js 之后，我还曾为它添加过两个动态效果】

直到后来因为一些原因在大三上学期接触了 GitHub ，进而了解了 github.io，基于 Jekyll 又搭建了一个博客，这个博客说实话还算差强人意，期间主要是发布了几篇笔记。

其中最大的问题是没怎么折腾，基本就是基于[github.com/qiubaiying/qiubaiying.github.io](https://github.com/qiubaiying/qiubaiying.github.io)主题对应的修改为自己的信息，现在想想其实可探索性应该还是蛮多的，这里可以参考[jaxvanyang.github.io](https://jaxvanyang.github.io/)。

直到在大三下学期开学前的寒假开始基于 Hexo 主题搭建博客，博客在我的生活里才开始真正重新焕发生机。
## 朝花夕拾亦不晚
借助Hexo文档和主题文档，我很快完成了整个博客的基本搭建，选用的主题为[nexmoe](https://github.com/theme-nexmoe/hexo-theme-nexmoe)。

> 关于该主题，一个相关的 [hexo-theme-nexmoe-example](https://github.com/theme-nexmoe/hexo-theme-nexmoe-example) 或许是更好的入门材料。

将我过去所有的博客内容全部同步过来之后，一些直接影响效果的问题却让我对它又开始兴趣缺缺起来。

其中最大的问题还是访问速度太慢，幸亏我还能借助 wsl 在本地运行测试效果，不然可能早就流产了。

这段时间里，关于博客的折腾算是一阵一阵的，心血来潮了就实现一两个功能。
所幸，整个项目还算是一直在进步，不管是功能还是博客文章还是在不断的增量向前。
## 冲刺结束最后那段路
### RSS 订阅
机缘巧合之下了解到[RSS](https://en.wikipedia.org/wiki/RSS)，关于RSS的一些更通俗易懂的介绍可参考[diygod.me/ohmyrss/](https://diygod.me/ohmyrss/)。

作为一名程序员，相信你了解了RSS的意义后，就能够明白*博客不提供RSS就如同不愿让真正关心你的人关心你*。

考虑到自己手动实现博客RSS格式转换不太现实，但选用的主题本身又不提供RSS订阅功能。所以只好去寻找能将hexo博客解析为RSS格式的项目。

所幸轮子早就有人造好了，使用hexo博客并有相似需求的童鞋可参考[hexo-generator-feed](https://github.com/hexojs/hexo-generator-feed)
### wordcount
字数统计功能在博客中算是屡见不鲜了。提供的内容主要包括**字数统计**和**阅读预计需要多长时间**。

正当我纳闷着要不要尝试学习相关知识并为当前主题提交一条 PR 时。
居然在项目的pr记录中找到了类似pr。 如下：
![pr-rekord](/assets/pr-rekord-22.5.20.jpg)

接下来我把博客的主题升级到最新版后，就有相应的功能了。

不过，可能个人审美风格不相一致。最终我还是提交了一条[pr](https://github.com/theme-nexmoe/hexo-theme-nexmoe/pull/209)，大概就是调整了一下wordcount的出现位置和出场风格。

为开源社区贡献自己的一份力量还是很激动的，哪怕所作所为微不足道。
### HTTPS
关于https的介绍这里就不再赘述了，今天主要是来聊聊我的实现。
1. 申请证书（我是在阿里云申请的免费证书）
2. 下载证书（使用Hexo主题记得下载Nginx类型的证书）
3. 上传证书到服务器（位置自定义）
4. 配置Nginx（相关教程很多，也不细说了）

下面说说我在实现HTTPS的过程中踩过的几个坑。
1. 尝试根据[https://blog.csdn.net/smileyan9/article/details/104130522](https://blog.csdn.net/smileyan9/article/details/104130522)修改`server.js`，然后一直报错端口占用，使用`lsof -i:80`发现80端口被aliyundun占用，但是即使我 kill 该进程后，仍然报错，不知道是因为`aliyundun`快速自启占用端口还是`Hexo`配置的问题。
2. 直接配置nginx，将 root 目录设置为Hexo博客的 public 目录，但浏览器一直报错“403 forbidden”，查看 /usr/local/nginx/logs/error.log 后发现是权限错误，将博客目录移至一个可访问的目录即可解决问题（所以千万不要将博客目录放到 root/ 或者 某个用户的家目录下）。
3. 启动 nginx 报错`/usr/local/nginx/logs/nginx.pid" failed (2: No such file or directory)`，解决方案可参考[https://blog.csdn.net/weixin_45143481/article/details/104949471](https://blog.csdn.net/weixin_45143481/article/details/104949471)

## 写在最后
关于博客的折腾是时候告一段落了，接下来的重点就是不断学习不断沉淀，多产出博客文章。
