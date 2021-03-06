---
layout: post
title: 一次对图床问题的探索
date: 2021/10/10
updated: 2022/3/10
comments: true
categories: 
- 折腾
tags:
- 图床
---

## 初体验
> 就是不想去找第三方图床，一心想要薅它们的羊毛！！！

1. 本以为可以将博客园当图床，而且在Typora上使用也成功显示了。但是在其他网站引用时却无法正常显示，估计是被filter了:skull_and_crossbones:。

2. 放github里面的image文件夹也是不行的，因为github里面的image地址对应的实际是一个网页，而非一张图片，估计是github自身防止被当做自由图床的一种防卫手段。

3. 当在README.md文件中引用一张图片（比如来自博客园）时，发现居然可以显示，用开发者工具看了下，似乎是被下载备份到GitHub自己的服务器了，所以才可以显示。然后再一次更改图片地址为这个GitHub图片地址，发现在博客上就可以正常显示了（可能因为GitHub在国外的原因偶尔可能刷新不出来。。。），至少说明图片不是瞬时加载（但是不是保留几天就不得而知了），但是这种引用方式好麻烦啊:cry:!

4. 直接拿自己网站当图床得了！

5. 在GitHub上面的README.md文件直接粘贴图片，图片会完成上传工作，而且在其他网页是可以引用的（博客园应该学学人家的气度:angry:)

## 需求升级
### CDN
- content delivery network
- 关于CDN各方面的基本介绍可参考[www.cloudflare.com](https://www.cloudflare.com/zh-cn/learning/cdn/what-is-a-cdn/)
