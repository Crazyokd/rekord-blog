---
title: Ubuntu中的PPA
index_img: https://cdn.sxrekord.com/blog/ppa.png
banner_img: https://cdn.sxrekord.com/blog/ppa.png
date: 2024-12-28 07:20:18
updated: 2024-12-28 07:20:18
categories:
- 技术
tags:
- Linux
---

有时候我们会需要安装使用一些小众软件，默认的系统软件源一般是不包括它们的。但你又不想手动编译源码（这需要一些基础知识而且还要**做好过程并不顺利的准备**），此时就可以期待作者或用户是否提供了该软件的第三方PPA。

# PPA
在此之前，先介绍一下repository，PPA(Personal Package Archive)本质上就是一种repository。
repository分为以下四类：
- Main: 标准支持的免费和开源的软件
- Universe: 社区维护的免费和开源的软件
- Restricted: 对各个设备的专有驱动
- Multiverse: 受限于版权或法律条目的软件

一般在下载package的时候，我们会输入两个指令：
1. sudo apt update
这一步系统会使用APT tool来检查repo中包含的软件，并将软件信息和版本号保存在缓存中。
2. sudo apt install package_name
这时从缓存中查找对应的package，得到具体的URL并进行下载。
如果该repository中没有该package，则会抛出Error. E: Unable to locate package

# 基本场景
一旦有了第三方ppa源，就可以使用下面的”添加-更新-安装“三板斧：
```shell
sudo apt-add-repository xxx-xxx
sudo apt update
sudo apt install xxx
```

> 以上的命令将会把对应的xxx.list文件写入至/etc/apt/sources.list.d目录中，在更新源的时候会自动读取这个目录下的所有文件。

# 一个软件多个源
一般我们会在系统源没有某个软件或支持的版本过低时考虑使用第三方软件源。
如果没有合适的ppa源，用户还想使用最新版本的软件就只能手动编译了。

但有时我们还会遇到一种更加复杂的情况，即多个源都能安装某一软件，且分别支持不同版本。
这种情况下，我们首先可以通过`apt-cache policy xxx`获取某一软件的源支持情况和其他一些元信息。
```
fish:
  Installed: (none)
  Candidate: 3.3.1+ds-3ubuntu0.1~esm1
  Version table:
     3.7.1-1~jammy 500
        500 https://ppa.launchpadcontent.net/fish-shell/release-3/ubuntu jammy/main amd64 Packages
     3.3.1+ds-3ubuntu0.1~esm1 510
        510 https://esm.ubuntu.com/apps/ubuntu jammy-apps-security/main amd64 Packages
        100 /var/lib/dpkg/status
     3.3.1+ds-3 500
        500 https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy/universe amd64 Packages)
```
上面是我使用fish作为一个示例，可以看到该软件的安装状态（none）、预选安装版本（3.7.1-1~jammy）以及版本表。
版本表的每项包括某个源提供的安装版本，该源的优先级等。

> 有意思的是`/var/lib/dpkg/status`对应的优先级为100，这意味着已安装软件版本的优先级为100，这个优先级只能算低，所以一旦添加了带新版本的软件源或已有的源提供了更新的软件版本，那么执行`apt upgrade`几乎一定会更新该软件。

从上面的预选安装版本或版本表不难发现系统默认将会安装esm源下的fish，那么这种情况该怎么办呢？

我们可以在/etc/apt/preferences.d/目录下创建一个fish-pinning（名字任意）文件，然后在其中填入偏好设置：
```
Package: fish
Pin: release o=LP-PPA-fish-shell-release-3
Pin-Priority: 1001
```

> 上面的Origin值（LP-PPA-fish-shell-release-3）可以通过执行`apt-cache policy | grep fish`来获取。

然后执行`apt update`更新配置。

上面的配置其实就是设置当涉及到`fish`这个包时，fish-shell-release-3这个源的优先级将会上升至1001，这也就能够让我们享受高版本的fish体验。
> 该目录下的`/etc/apt/preferences.d/ubuntu-pro-esm-infra`和`/etc/apt/preferences.d/ubuntu-pro-esm-apps`也是同理。

配置生效后，此时再次执行`apt-cache policy fish`，我们就会得到下面的结果：
```
fish:
  Installed: (none)
  Candidate: 3.7.1-1~jammy
  Version table:
     3.7.1-1~jammy 1001
        500 https://ppa.launchpadcontent.net/fish-shell/release-3/ubuntu jammy/main amd64 Packages
     3.3.1+ds-3ubuntu0.1~esm1 510
        510 https://esm.ubuntu.com/apps/ubuntu jammy-apps-security/main amd64 Packages
        100 /var/lib/dpkg/status
     3.3.1+ds-3 500
        500 https://mirrors.tuna.tsinghua.edu.cn/ubuntu jammy/universe amd64 Packages
```
现在我们就可以放心的执行`apt install fish`来安装fish了。

# 避免特定软件更新
通过第二个案例的启发，我们不难想到一种避免某些软件默认更新的方案。
我们可以为这些需要特别注意的软件创建一个偏好设置文件，然后提高其已安装版本的优先级，从而避免在执行`apt upgrade`时误更新。

