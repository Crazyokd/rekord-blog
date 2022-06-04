---
layout: post
title: Web页面请求的历程
date: 2022/05/25
updated: 2022/05/25
cover: /assets/Internet.jpg
coverWidth: 1512
coverHeight: 786
comments: true
categories: 
- 技术
tags:
- 计算机网络
---

> 下文摘抄自《计算机网络 自顶向下方法》第七版第六章最后一小节
>
> 灵感来自于[what-happens-when-zh_CN](https://github.com/skyline75489/what-happens-when-zh_CN)，但本文仅聚焦在网络部分。

![6-32](/assets/5-32.jpg)

图 6-32 图示了我们的场景：一名学生 Bob 将他的便携机与学校的以太网交换机相连，下载一个 Web 页面（比如说 [www.google.com](https://www.google.com.hk/) 主页）。如我们所知，为满足这个看起来简单的请求，背后隐藏了许多细节。
## 准备：DHCP 、UDP 、IP 和以太网
​   我们假定 Bob 启动他的便携机，然后将其用一根以太网电缆连接到学校的以太网交换机，交换机又与学校的路由器相连，如图 6-32 所示。 学校的这台路由器与一个 ISP 连接， 本例中 ISP 为 comcast.net 。在本例中，comcast.net 为学校提供了 DNS 服务；所以，DNS 服务器驻留在 Comcast 网络中而不是学校网络中。我们将假设 DHCP 服务器运行在路由器中，就像常见情况那样。 当 Bob 首先将其便携机与网络连接时，因为没有 IP 地址他就不能做任何事情（例如下载一个 Web 网页）。所以，Bob 的便携机所采取的一个网络相关的动作是运行 DHCP 协议、 以从本地 DHCP 服务器获得一个 IP 地址以及其他信息。

### step1

Bob 便携机上的操作系统生成一个 DHCP 请求报文，并将这个报文放入具有目的端口 67 (DHCP 服务器）和源端口 68 (DHCP 客户）的 UDP 报文段中。该 UDP 报文段则被放置在一个具有广播 lP 目的地址 (255. 255. 255. 255) 和源 IP 地址 0.0.0.0 的 IP 数据报中，因为 Bob 的便携机还没有一个 IP 地址。

### step 2

包含 DHCP 请求报文的 IP 数据报则被放置在以太网帧中。该以太网帧具有目的 MAC 地址 FF: FF: FF: FF: FF: FF, 使该帧将广播到与交换机连接的所有设备 （如果顺利的话也包括 DHCP 服务器 ） ；该帧的源 MAC 地址是 Bob 便携机的 MAC 地址 00: I6: D3: 23: 68: 8A。

### step3	

包含 DHCP 请求的广播以太网帧是第一个由 Bob 便携机发送到以太网交换机的帧。该交换机在所有的出端口广播入帧，包括连接到路由器的端口。

### step4
路由器在它的具有 MAC 地址 00:22:6B:45:1F 的接口接收到该广播以太网帧，该帧中包含 DHCP 请求、并且从该以太网帧中抽取出 IP 数据报。该数据报的广播 IP 目的地址指示了这个 IP 数据报应当由在该节点的高层协议处理，因此该数据报的载荷（一个 UDP 报文段）被分解向上到达 UDP, DHCP 请求报文从此 UDP 报文段中抽取出来。 此时 DHCP 服务器有了 DHCP 请求报文。
### step5
我们假设运行在路由器中的 DHCP 服务器能够以 CIDR块 68.85.2.0/24 分配 IP 地址。所以本例中，在学校内使用的所有 IP 地址都在 Comcast 的地址块中。我们假设 DHCP 服务器分配地址 68. 85. 2. 101 给 Bob 的便携机。DHCP 服务器生成包含这个 IP 地址以及 DNS 服务器的 IP 地址 ( 68. 87. 71. 226) 、默认网关路由器的 IP 地址 ( 68. 85. 2. l ) 和子网块 (68. 85. 2. 0/ 24) (等价为 “网络掩码”) 的一个 DHCP ACK 报文。该 DHCP 报文被放入一个 UDP 报文段中，UDP 报文段被放人一个 IP 数据报中，IP 数据报再被放入一个以太网帧中。这个以太网帧的源 MAC 地址是路由器连到归属网络时接口的 MAC 地址 (00:22:6B:45:1F:lB) , 目的 MAC 地址是 Bob 便携机的 MAC 地 址 (00: t6: D3 : 23 : 68 : 8A)
### step6
包含 DHCP ACK 的以太网帧由路由器发送给交换机。 因为交换机是自学习的、并且先前从 Bob 便携机收到（包含 DHCP 请求的）以太网帧，所以该交换机知道寻址到 00: 16: 03: 23: 68: 8A 的帧仅从通向 Bob 便携机的输出端口转发。

### step7
Bob 便携机接收到包含 DHCP ACK 的以太网帧，从该以太网帧中抽取 IP 数据报，从 IP 数据报中抽取 UDP 报文段，从 UDP 报文段抽取 DHCP ACK 报文。 Bob 的 DHCP 客户 则记录下它的 IP 地址和它的 DNS 服务器的 IP 地址。 它还在其 IP 转发表中安装默认网关的地址。Bob 便携机将向该默认网关发送目的地址为其子网 68. 85.2.0/24 以外的所有数据报。此时，Bob 便携机已经初始化好它的网络组件，并准备开始处理 Web 网页获取。

## 仍在准备：DNS 和 ARP
​	当 Bob 将 [www.google.com](https://www.google.com.hk/) 的 URL 键入其 Web 浏览器时，他开启了一长串事件，这将导致谷歌主页最终显示在其 Web 浏览器上。Bob 的 Web 浏览器通过生成一个 TCP 套接字开始了该过程，套接字用于向 [www.google.com](https://www.google.com.hk/) 发送 HTTP 请求。为了生成该套接字，Bob 便携机将需要知道[www.google.com](https://www.google.com.hk/) 的 IP 地址。 

### step8
Bob 便携机上的操作系统因此生成一个 DNS 查询报文，将字符串 [www.google.com](https://www.google.com.hk/) 放入 DNS 报文的问题段中。 该 DNS 报文则放置在一个具有 53 号 (DNS 服务器）目的端口的 UDP 报文段中。该 UDP 报文段则被放入具有 IP 目的地址 68. 87. 71. 226 (在第 5 步中 DHCP ACK 返回的 DNS 服务器地址）和源 IP 地址 68.85.2.101 的 IP 数据报中。
### step9
Bob 便携机则将包含 DNS 请求报文的数据报放入一个以太网帧中。该帧将发送（在链路层寻址）到 Bob 学校网络中的网关路由器。然而，即使 Bob 便携机经过上述第 5 步中的 DHCP ACK 报文知道了学校网关路由器的 IP 地址 (68. 85. 2. 1) , 但仍不知道该网关路由器的 MAC 地址。为了获得该网关路由器的 MAC 地址， Bob 便携机将需要使用 ARP 协议。
### step10
Bob 便携机生成一个具有目的 lP 地址 68. 85. 2. 1 (默认网关）的 ARP 查询报文，将该 ARP 报文放置在一个具有广播目的地址 (FF:FF:FF:FF:FF:FF ) 的以太网帧中，并向交换机发送该以太网帧，交换机将该帧交付给所有连接的设备，包括网关路由器。
### step11
网关路由器在通往学校网络的接口上接收到包含该 ARP 查询报文的帧，发现在 ARP 报文中目标 IP 地址 68.85.2.1 匹配其接口的 IP 地址。网关路由器因此准备一个 ARP 回答，指示它的 MAC 地址 00: 22: 6B: 45 : IF: 1B 对应 IP 地址 68. 85. 2. 1。它将 ARP 回答放在一个以太网帧中， 其目的地址为 00: 16: D3: 23: 68: 8A (Bob 便携机），并向交换机发送该帧，再由交换机将帧交付给 Bob 便携机。
### step12
Bob 便携机接收包含 ARP 回答报文的帧，并从 ARP 回答报文中抽取网关路由器的 MAC 地址 ( 00 : 22: 6B: 45: lF: lB)。
### step13
Bob 便携机现在能够使包含 DNS 查询的以太网帧寻址到网关路由器的 MAC 地址。注意到在该帧中的 IP 数据报具有 IP 目的地址 68. 87. 71. 226 (DNS 服务器），而该帧具有目的地址 00:22:68:45:JF:1B (网关路由器）。Bob 便携机向交换机发送该帧，交换机将该帧交付给网关路由器。

## 仍在准备：域内路由选择到 DNS 服务器
### step14
网关路由器接收该帧并抽取包含 DNS 查询的 IP 数据报。 路由器查找该数据报的目的地址 (68.87.71.226),并根据其转发表决定该数据报应当发送到图 6-32 的 Comcast 网络中最左边的路由器。IP 数据报放置在链路层帧中，该链路适合将学校路由器连接到最 左边 Comcast 路由器，并且该帧经这条链路发送。
### step15
在 Comcast 网络中最左边的路由器接收到该帧，抽取 IP 数据报，检查该数据报的目的地址(68.87.71.226),并根据其转发表确定出接口，经过该接口朝着 DNS 服务器转发数据报，而转发表己根据 Comcast 的域内协议（如 RIP 、OSPF 或 IS-IS）以及因特网的域间协议 BGP 所填写。
### step16
最终包含 DNS 查询的 IP 数据报到达了 DNS 服务器。 DNS 服务器抽取出 DNS 查询报文，在它的 DNS 数据库中查找名字 [www.google.com](https://www.google.com.hk/)，找到包含对应 [www.google.com](https://www.google.com.hk/) 的 IP 地址 (64.233.169.105) 的 DNS 源记录。（假设它当前缓存在 DNS 服务器中。）这种缓存数据源于 google.com 的权威 DNS 服务器。 该 DNS 服务器形成了一个包含这种主机名到 IP 地址映射的 DNS 回答报文，将该 DNS 回答报文放入 UDP 报文段中，该报文段放入寻址到 Bob 便携机 ( 68.85.2.101 ) 的 IP 数据报中。该数据报将通过 Comcast 网络反向转发到学校的路由器，并从这里经过以太网交换机到 Bob 便携机。
### step17
Bob 便携机从 DNS 报文抽取出服务器 [www.google.com](https://www.google.com.hk/) 的 IP 地址。最终，在大量工作后，Bob 便携机此时准备接触 [www.google.com](https://www.google.com.hk/) 服务器！

## Web 客户－服务器交互：TCP 和 HTTP
### step18
既然 Bob 便携机有了 [www.google.com](https://www.google.com.hk/) 的 IP 地址， 它就能够生成 TCP 套接字，该套接字将用于向 [www.google.com](https://www.google.com.hk/) 发送 HTTP GET 报文。当 Bob 生成 TCP 套接字时，在 Bob 便携机中的 TCP 必须首先与 [www.google.com](https://www.google.com.hk/) 中的 TCP 执行三次握手。Bob 便携机因此首先生成一个具有目的端口 80 (针对 HTTP 的）的 TCP SYN 报文段，将该 TCP 报文段放置在具有目的 IP 地址 64.233.169.105 ([www.google.com](https://www.google.com.hk/) ) 的 IP 数据报中， 将该数据报放置在 MAC 地址为 00:22:68:45:IF:1B ( 网关路由器）的帧中， 并向交换机发送该帧。 
### step19
在学校网络、Comcast 网络和谷歌网络中的路由器朝着 [www.google.com](https://www.google.com.hk/) 转发包含 TCP SYN 的数据报，使用每台路由器中的转发表，如前面步骤 14 ~ 16 那样。支配分组经 Comcast 和谷歌网络之间域间链路转发的路由器转发表项，是由 BGP 协议决定 的。 
### step20
最终，包含 TCP SYN 的数据报到达 [www.google.com](https://www.google.com.hk/) 。从数据报抽取出 TCP SYN 报文并分解到与端口 80 相联系的欢迎套接字。对于谷歌 HTTP 服务器和 Bob 便携机之间的 TCP 连接生成一个连接套接字。产生一个 TCP SYNACK 报文段，将其放入向 Bob 便携机寻址的一个数据报中，最后放入链路层帧中，该链路适合将 [www.google.com](https://www.google.com.hk/) 连接到其第一跳路由器。
### step21
包含 TCP SYNACK 报文段的数据报通过谷歌、Comcast 和学校网络，最终到达 Bob 便携机的以太网卡，数据报在操作系统中分解到步骤 18 生成的 TCP 套接字，从而进入连接状态。
### step22
借助于 Bob 便携机上的套接字，现在准备向 [www.google.com](https://www.google.com.hk/) 发送字节了，Bob 的浏览器生成包含要获取的 URL 的 HTTP GET 报文。HTTP GET 报文则写入套接字，其中 GET 报文成为一个 TCP 报文段的载荷。该 TCP 报文段放置进一个数据报中，并交付到 [www.google.com](https://www.google.com.hk/),如前面步骤 18 -20 所述。 
### step23
在 [www.google.com](https://www.google.com.hk/) 的 HTTP 服务器从 TCP 套接字读取 HTTP GET 报文，生成一个 HTTP 响应报文，将请求的 Web 页内容放入 HTTP 响应体中，并将报文发送进 TCP 套接字中。
### step24
包含 HTTP 回答报文的数据报通过谷歌、Comcast 和学校网络转发，到达 Bob 便携机。Bob 的 Web 浏览器程序从套接字读取 HTTP 响应，从 HTTP 响应体中抽取 Web 网页 的 html,并最终显示了 Web 网页。
