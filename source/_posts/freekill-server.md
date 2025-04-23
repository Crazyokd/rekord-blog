---
title: 新月杀v0.5.4私服搭建
index_img: https://cdn.sxrekord.com/v2/sanguosha.webp
date: 2025-03-23 12:00:19
updated: 2025-03-23 12:00:19
categories:
- 折腾
tags:
- 游戏
- Lua
---

年前家里人多，偶然间几人一起玩了简单的扑克桌游，效果颇佳。

很快我就想起了三国杀，也想起了小时候晚上在被子里研究说明书的日子，不免苦笑。

但想想其复杂度，并不特别适合作为一个大众游戏，更不用说其中对于技能说明、卡牌摆放、阶段进行的问题了。

但对于这些繁琐的内容有一种方式能够大大简化，即使用线上模式但实际线下进行的方案。

推而广之，这种模式还能应用到所有桌游游戏，不论是简单的斗地主还是复杂的三国杀都能很好的适配。

另外计费/记分既可以通过额外的小软件完成也可以由游戏内置。

# 现实

但实际上述构想很多时候仅仅是一个理想情况。

既然侧重多人Online，现行方案基本都是采用C-S模式，即需要服务器成本，对应游戏厂商一般不会让你白嫖这部分成本，所以它们基本都在各种地方各种程度上进行了限制。

常见的限制有：

* 压根不支持完全自组队房间；e.g. 不管你双排还是五排都需要匹配对手。
* 机制削弱；e.g. 原本游戏至少支持100个角色，但现在需要你的账号拥有这些角色才能使用。

其他小动作包括游玩次数限制和等级达标才能开启该模式等等。

毕竟都是商业，从开发商的角度上来看倒也无可厚非，但作为普通玩家面对这种现实也只能望而却步。

# 行动

作为一名程序员，这次我觉得可以试图稍稍动摇这种局面。

1. 如果存在先行者，那么我至少具备使用和部署的知识，甚至有贡献的机会。
2. 否则我或许能够在这方面稍稍先行向前迈进一步？

但好在有这种想法甚至付诸行动的人已然存在，简单搜索一下就能发现不少已存在的相关开源项目。一些典型的案例如下：

* 太阳神三国杀
* 新月杀
* [无名杀](https://github.com/libnoname/noname)

简单考察了一番后我选择新月杀作为目标。

过年期间也在局域网中和小伙伴快乐的游玩了一些时日。

最近表弟又想和我联机，虽然有不少公开服，但扩展选择和规则限制毕竟是由管理员设置的，个人并没有任何自定义机会，故干脆自己也来搭建一个私服。

截至笔者成文最新的版本为v0.5.5，由于该版本尚不稳定，故选择v0.5.4，这也是目前其他公开服最常使用的版本。

# 方案

由于囊中羞涩，服务器配置不太够，故还是使用自己的笔记本作为游戏服务器，白嫖[natfrp](https://www.natfrp.com/)实现frp能力。

![网络架构](https://cdn.sxrekord.com/v2/image-20250323102235-8tjm6qc.png)

游戏亦支持IPv6，这玩意刚好我有，所以也允许其他手机直接使用IPv6与服务器直连，另外内网IP当然也能直连。

基于此，并行允许IPv6直连、内网直连和Frp间接跳转连接。

# 编译

编译步骤可参考[官方文档](https://fkbook-all-in-one.readthedocs.io/zh-cn/latest/server/13-start-server.html#id3)。

```shell
$ apt install git gcc g++ cmake
$ apt install liblua5.4-dev libsqlite3-dev libreadline-dev libssl-dev
$ apt install libgit2-dev swig qt6-base-dev qt6-tools-dev-tools
$ git clone https://gitee.com/notify-ctrl/FreeKill
$ cd FreeKill && git checkout v0.5.4 && mkdir build && cd build
$ cp -r /usr/include/lua5.4/* ../include
$ cmake .. -DFK_SERVER_ONLY=ON
$ make

$ cd .. && ln -s build/FreeKill
$ ./FreeKill -s
03/23 14:46:33 Main[I] Server is listening on port 9527
FreeKill, Copyright (C) 2022-2023, GNU GPL'd, by Notify et al.
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under
certain conditions; For more information visit http://www.gnu.org/licenses.

[v0.5.4] This is server cli. Enter "help" for usage hints.
fk>
```

## 操作命令

服务端在运行时支持一些操作命令，主要包括：

1. 玩家管理
2. 房间管理
3. 广播消息
4. 扩展管理

## 配置文件

另外还支持一个服务端配置文件`freekill.server.config.json`，默认内容如下：

```
{
  "banwords": [],
  "description": "FreeKill Server",
  "iconUrl": "https://img1.imgtp.com/2023/07/01/DGUdj8eu.png",
  "capacity": 100,
  "tempBanTime": 20,
  "motd": "Welcome!",
  "hiddenPacks": [],
  "enableBots": true
}
```

编辑他们即可修改服务器的相关设置，各项含义如下：

* banwords: 字符串数组，服务器的违禁词汇列表。 违禁词发不出去也不能作为用户名/房间名。
* description: 服务器简介，显示在加入服务器界面的那行文字。
* iconUrl: 服务器图标对应的图片链接，必须是网络图片。最好是http协议的图片， 就目前来看只能是挂在自己服务器上了。
* capacity: 服务器最大承载玩家的容量。新月杀服务器主要瓶颈在于带宽， 保守一点估计的话，每1 Mbps可以承载60名玩家同时游戏。
* tempBanTime: 对于逃跑玩家的自动封禁时长，单位为分钟。设为0 即可关闭自动封禁功能，不要设为负数。
* motd: 用户进入大厅时候在屏幕右侧看到的文字，支持markdown格式。 不过因为JSON不能写多行字符串，你得把写好的markdown中所有换行符全替换成n才好哦。
* hiddenPacks: 服务器想要隐藏的拓展包列表，对于DIY服应该是需要的。
* enableBots: 是否允许玩家添加机器人，视情况设定。

## 数据库

服务器使用sqlite作为数据库，我这次主要关注的是`server/users.db`和`packages/packages.db`。

操作方式非常简单：

```shell
apt install sqlite
sqlite3 packages.db
# 接下来就可以使用基本的SQL语法进行查询了
SELECT name,url,hash from packages;
```

# 设置Frp隧道

## 安装并启动SakuraFrp启动器

sudo bash -c ". <(curl -sSL https://doc.natfrp.com/launcher.sh)"

这阶段需要用到[账户的访问密钥](https://www.natfrp.com/user/profile)。

## 创建主机与natfrp之间的隧道

https://www.natfrp.com/tunnel/

![创建隧道](https://cdn.sxrekord.com/v2/image-20250321165216-9hb16d8.png)

> 第一次创建隧道需要先实名认证，实名认证另外还收费1元。

## 登录管理端口添加之前创建的隧道

```txt
============= 启动器连接信息 =============
远程管理模式已开启, 请到管理面板使用远程管理连接
WebUI 端口: 7102
WebUI 密码: xxxxxxxxxxxxxxxxxxxxxxx

使用 https://192.168.6.5:7102 进行连接
```

## 外部客户连接

```txt
frpc[home_frp|Info] TCP 隧道启动成功
frpc[home_frp|Info] 使用 >>domain:12345<< 连接你的隧道
frpc[home_frp|Info] 或使用 IP 地址连接: >>xxx.xxx.xxx.xxx:12345<<
frpc[home_frp|Info] 2025/03/21 08:40:24 [I] 隧道启动成功
```

# 游玩

现在所有设备均可以依据所处的网络环境选择对应的连接方式进入服务器了。

# 扩展

上述过程实施的非常顺利，但是这游戏基本包只有25个武将，显然是不够玩的，所以扩展必不可少。

但也正由于扩展和版本交织而来的种种问题，导致额外花费了半天时间。

## 版本管理问题

1. 游戏本身含有版本管理，但扩展仅一个分支，没有任何Tag，仅仅是基于Git提交而已。

2. 服务端的install命令基于Git下载扩展，但不支持任何额外参数，比如指定分支或提交。

**上述两点导致服务端只能下载最新版本的扩展，但扩展实际存在兼容问题，即新版扩展并不支持早版游戏。**

因为下载的扩展实际被clone到packages/目录下，其内容都是由Lua编写，不需要重新编译，故我手动到扩展目录下进行checkout试图回退版本。

由于没有版本管理，我只能摸索着checkout到v0.5.4即25/01/14之前的提交。然而仍然出现了版本兼容性错误。

进一步观察发现报错仍然是因为手机端自动同步的扩展是最新版本导致。

接下来发现同步的扩展Hash信息是保存在数据库中的，这点既可以使用sqlite对packages.db进行查询也可以通过pkgs命令进行查询得到验证。

## 解决方案

1. fork想要安装的扩展仓库，将版本回退到25/01/14之前，然后安装时使用自己的仓库链接
2. 手动修改数据库的扩展Hash信息，并将packages目录下的对应扩展也回退到相同版本。

> 虽然pkgs命令下查到的hash只有前八个字节，但手动修改hash时注意使用完整提交Hash。
>
> **不要直接往数据库插入扩展信息，虽然实施这种方式后服务端的包管理命令似乎并无任何异常，但客户端仍会报错。**

下面是我😤收集到的适用于v0.5.4的扩展版本Hash信息：

```txt
https://gitee.com/Qsgs-Fans/freekill-core   87d239e52ddb2cd413ca2bdb36b45430e4d12722
https://gitee.com/Qsgs-Fans/utility         97f7da6dadc502f3aed5c3f8b8cd232f5fe449d6 # 通用工具函数
https://gitee.com/Qsgs-Fans/mobile          414500394f88d833ac832e48af45cea064efc29f # 手杀扩展包
https://gitee.com/Qsgs-Fans/sp              56b8525da85ce76dcf74b8078c4781eac06f6d45 # sp
https://gitee.com/Qsgs-Fans/ol              1729e4c8e2b70cc229dae25f137a21e5162fb3db # ol
https://gitee.com/Qsgs-Fans/yj              9ebc24b13d1cfdb0ee4d444be6f4c3285b4e7ecb # 一将成名
https://gitee.com/Qsgs-Fans/mougong         a80e0f0937b977c5ab7604c886534ac92ecf82ea # 谋攻篇
https://gitee.com/Qsgs-Fans/tuguo           5d18e0face8f005b87b65f5bf69eba6bc6fb4c74 # 图国
https://gitee.com/Qsgs-Fans/jsrg            f20b0da1765e88f4be1dd55be8096db0e64c4394 # 江山如故
https://gitee.com/Qsgs-Fans/shzl            8a52a88c27876a6b3c3e5b2280af76b6573788e8 # 神话再临
https://gitee.com/Qsgs-Fans/tenyear         753f86cc6683f04ee97594ccc841e5c1722db583 # 十周年

https://gitee.com/notify-ctrl/mobile_effect	bf3799679c8e32c595fba4801bd8a9839266c3bd
https://gitee.com/Qsgs-Fans/standard_ex	    d0e033579e8a93a1a1376a53b58042180526b321
```

第一种解决方案使用示例：

```shell
# fork 仓库
...
# 克隆仓库
git clone https://gitee.com/rekord/utility
# 回退版本
cd utility && git branch -D master && git checkout -b master 87d239e52ddb2cd413ca2bdb36b45430e4d12722
git push origin master -f
# 安装扩展
install https://gitee.com/rekord/utility
```

第二种解决方案使用实例：

```shell
# 在服务端安装最新扩展
install https://gitee.com/Qsgs-Fans/utility
# checkout回退扩展版本
cd packages/utility && git checkout 87d239e52ddb2cd413ca2bdb36b45430e4d12722
# 修改数据库以同步客户端行为
cd packages && sqlite3 packages.db
UPDATE packages
SET hash = '87d239e52ddb2cd413ca2bdb36b45430e4d12722'
WHERE name = 'utility';
```
# 代码
为简化后续再度搭建，以上涉及的代码我整合成了一个仓库，托管在[GitHub](https://github.com/Crazyokd/fk-svr)。
clone项目以后的操作请参考仓库文档。

# 注意

* 游玩过程中有时候会报错卡住，目前还不清楚是游戏本身、扩展抑或是网络问题。

* 若放在容器中运行并映射端口(9527)，需注意`same address`问题，这种情况下游戏似乎会把所有外部客户端IP视为容器桥接的网关地址。但哪怕是放在宿主机上运行，通过frp连接的客户端似乎也都会被视为127.0.0.1（frp绑定的服务端地址）。
* 服务器地址部分不支持填写域名，也就是说ddns-go的能力无法在此加持。

