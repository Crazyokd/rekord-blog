---
layout: post
title: 在 Pentium Dual-Core E6700 上安装 ArchLinux
date: 2023/01/11
updated: 2023/01/11
cover: https://cdn.sxrekord.com/blog/arch_on_pentium.png
coverWidth: 1475
coverHeight: 745
comments: true
categories: 
- 折腾
tags:
- Linux
---

## 既失败又成功的双系统
昨天在我的主机上又安装了一个ArchLinux，好让其作为双系统使用，然而因为一些细节原因最终没能取得圆满成功，GRUB甚至抓取不到双系统菜单，如果我要进行系统切换，每次需要进入bios，在`windows boot manager`或`grub`间进行切换。

动手能力差这点我是有自知之明的，但是折腾一下午还是收获不少，以下分别细说：
### 其一是装机过程
- 烧录镜像我用的是[Rufus](https://rufus.ie/zh/)，但都说[Ventoy](https://github.com/ventoy/Ventoy)更好用，这玩意上过几天trending，当时我还刷到过，但是烧录镜像时没想起来，只能说以后有机会再试试了。不过有一说一，Rufus也完全够用。
    ![rufus](https://cdn.sxrekord.com/blog/rufus.png)
    
- 接下来就是在Windows中选择高级启动，然后在Bios中关闭Windows安全启动以及提高U盘（*我烧录镜像到U盘中*）启动优先级。重启后就可以选择Arch Linux启动了。

- 联网这些不细说了，根据自己的网络环境选择相应的命令即可。

- 磁盘分区我用的是fdisk和[LVM]()，fdisk比较通用（*基本格式都支持*），而且比较好用（*操作简单*），甚至容错性也很高（*不使用w写入分区不生效*）。
由于是UEFI模式，所以当然是GPT。分区容量可以参考[官方推荐](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks)

- 后面的过程主要是挂载格式化后的分区、选择镜像并安装各种基本包和功能包、将挂载信息写入配置文件（*这个过程是用`genfstab`自动完成的*）、切换root进入新系统然后完成本地化、完成网络配置。

- 最后一步是选择并安装一个启动装载程序（*boot loader*）。这一步尤其重要，不过选择grub基本上能适用所有情况。

### 其二是LVM
没能尝鲜快照、缓存等进阶用法难免遗憾，但基本用法还是扎扎实实在用。
对于LVM我目前直观感受到的好处就是扩展性强，能满足我多个磁盘零散空间合并使用的需求。比如我需要把第一块磁盘的一大半给C（Windows系统盘），第二块磁盘的一大半给D（软件）和E（游戏）。然后两块磁盘各剩下几十G的零散空间，这种情况下使用LVM再合适不过，命令如下：

```shell
# 创建pv
pvcreate /dev/sda4
pvcreate /dev/sdb4

# 创建vg
vgcreate vgname /dev/sda4 /dev/sdb4

# 创建lv
lvcreate -l 100%FREE vgname -n lvname
```

最终得到的lv层级相当于sdax或sdbx。

---

**好了，该回到标题相关了！**
~~其实上面这些经验教训也不能说是毫不相关，没有一步一脚印的踩下这些完全陌生的领域，今天的装机或许不会这么顺利。~~

## 在Pentium上安装Arch
有了前一天对这些过程的大量实践，所以以上安装Arch的绝大部分步骤都异常顺利。
那么问题聚焦在哪里呢？

首先我使用`screenfetch`获取了系统信息（*如封面*），然后根据[奔腾具体型号](https://www.intel.com/content/www/us/en/products/sku/42809/intel-pentium-processor-e6700-2m-cache-3-20-ghz-1066-fsb/specifications.html)又去Intel官网查询了更详细的信息，发现这台2012年以前（*应该还要更早*）买下的机器居然是64位的，这让我感到无限欣慰。但是UEFI肯定就别想了。

本来非常简单的联网在这遇到了一点小挫折，因为这老古董甚至没有无线网卡，使用`iwctl`压根列不出设备。好歹是翻出了一根电缆，插上以后直接联网，反而更香？

因为不需要双系统，所以直接把整个磁盘都重新分区了，摧毁Win7的感觉只能用🥳🥳🥳来形容。

还有一个比较小心的地方是BIOS的Grub。
查阅了[官方文档](https://wiki.archlinux.org/title/Partitioning#Example_layouts)，如果使用BIOS/GPT是需要在磁盘首部分出1M的空间，类型为`BIOS BOOT`，如果使用BIOS/MBR是需要在磁盘尾部留出16.5KB未分配空间。

由于我当时已经分好了前边的`swap`、`/`和`/home`，所以直接走BIOS/MBR路线了。命令如下：

```shell
pacman -S grub # install grub
grub-install --target=i386-pc /dev/sdX # where i386-pc is deliberately used regardless of your actual architecture, and /dev/sdX is the disk (not a partition) where GRUB is to be installed.
```

## Post Installation
### yay
AUR 为 archlinux user repository。任何用户都可以上传自己制作的 AUR 包，这也是 Arch Linux 可用软件众多的原因。由于任何人都可上传，也存在对应的风险，一般选用大众认可的包即可。
使用 [yay](https://github.com/Jguer/yay) 可以安装 AUR 中的包。

```shell
cd /opt # 我选择将下载的文件放在/opt目录
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

### 显卡驱动
通过以下命令可得到显卡及驱动信息：

```shell
lspci -v | grep 'VGA'
# 查看可用的驱动和正在使用的驱动
lspci -v | less # 然后在less中搜索‘VGA’
```

通过以上命令查询到我的[显卡详情](https://www.techpowerup.com/gpu-specs/radeon-hd-8350-oem.c1976)，然后参照[官方对照文档](https://wiki.archlinux.org/title/Xorg#AMD)，最终选择[ATI](https://wiki.archlinux.org/title/ATI)作为显卡驱动

### 包管理

```shell
sudo pacman -Qdt                # 找出孤立包 Q为查询本地软件包数据库 d标记依赖包 t标记不需要的包 dt合并标记孤立包
sudo pacman -Rs $(pacman -Qtdq) # 删除孤立软件包

sudo pacman -Fy                 # 更新命令查询文件列表数据库
sudo pacman -F xxx              # 当不知道某个命令属于哪个包时，用来查询某个xxx命令属于哪个包

sudo pacman -Sc                 # 清理缓存
```

### 系统服务
以`dhcpcd`服务为例：

```shell
systemctl start dhcpcd          # 启动服务
systemctl stop dhcpcd           # 停止服务
systemctl restart dhcpcd        # 重启服务
systemctl reload dhcpcd         # 重新加载服务以及它的配置文件
systemctl status dhcpcd         # 查看服务状态
systemctl enable dhcpcd         # 设置开机启动服务
systemctl enable --now dhcpcd   # 设置服务为开机启动并立即启动这个单元:
systemctl disable dhcpcd        # 取消开机自动启动
systemctl daemon-reload dhcpcd  # 重新载入 systemd 配置 扫描新增或变更的服务单元 不会重新加载变更的配置 加载变更的配置用 reload
```

---

后续主要的用途打算是作为一台**伪·服务器**使用。在局域网内通过ssh连接从而进行各种Linux操作。

另外这台机器还有500G的硬盘呢！😋

## 详细教程
- [https://wiki.archlinux.org/title/Installation_guide](https://wiki.archlinux.org/title/Installation_guide)
- [https://arch.icekylin.online/](https://arch.icekylin.online/)
- [https://archlinuxstudio.github.io/ArchLinuxTutorial/#/](https://archlinuxstudio.github.io/ArchLinuxTutorial/#/)