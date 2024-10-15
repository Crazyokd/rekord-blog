---
title: 一次手机抓包体验
date: 2022/2/6
updated: 2022/2/6
index_img: https://cdn.sxrekord.com/blog/fiddler.png
categories: 
- 折腾
tags:
- Fiddler
---

## 缘起
其实我们学校的易班打卡我一直是不胜其烦的，但苦于没有足够的技术实力，只能含恨忍受。

但现在我作为GitHub社区的一员，又有过web抓包经验，再说这种话就不应该了。

下面开始动手！
## 实践
web抓包于我而言当然首选【python+requests】。

找了几个关于易班的项目，其中大部分是移动端的，但由于缺乏移动端抓包工具，所以最初我将重点放在一个网页端的易班身上。

很快，我实现了自动登录，但在我进一步测试其易班校本化时，发现相关的超链接居然是`javascript:void(0)`。好家伙，这意味着只能在移动端进行校本化作业。

看来手机抓包是绕不过去的坎了，简单的进行了一番google，将目标锁定在fiddler身上，相关介绍和基础配置见[juejin.cn/post/6978086089600794631](https://juejin.cn/post/6978086089600794631)

然而问题又来了，对手机WIFI设置了代理后，易班软件认为我们的网络是不安全的，所以甚至连登录也无法做到。

而如果要实现打卡自动化，肯定需要生成一份表单并提交给服务端，这份表单几乎所有的易班项目肯定是互不相同的，所以必须通过抓包工具获取。

通过在B站搜索，又将目标锁定在一款名为HttpCanary的软件身上，俗称小黄鸟。

在找到软件并克服一些基础问题后，出现了我至今仍没有解决的一个问题————加密乱码问题。

## 转机
千回百转，终于还是回到起点。

然后我突然想到微信也有校本化的功能，而且微信是可以在配置代理的基础上正常运行的。

那么只要能抓到微信中校本化的包，就能开始继续后续步骤了。

最后经测试得出结论————可行！

将抓到的包进行AES解密，获取了表单成品。

在经过一番折腾后，最后功能总算是做出来了，而在今天我也基本解决了时区问题。
## 最后
最后欢迎大家使用成品[yiban-auto](https://github.com/Crazyokd/yiban-auto)