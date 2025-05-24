---
title: 搭建邮件服务
index_img: https://cdn.sxrekord.com/v2/using_gmail_to_send_large_files_via_email_9eaebaf630.jpg
banner_img: https://cdn.sxrekord.com/v2/using_gmail_to_send_large_files_via_email_9eaebaf630.jpg
date: 2025-05-23 12:25:43
updated: 2025-05-23 12:25:43
categories:
- 折腾
tags:
- email
---

通过[上次介绍的邮件服务](https://sxrekord.com/email-service/)，心中对整个邮件系统的运作已然有了清晰的认知。接下来就是折腾环节。

# 本地环境
我家里的环境是一台Windows娱乐机+一台Ubuntu22.04服务机。由于本地尝试更加容易抓包分析（不敢想自己能够一遍过），故选择先在本地搭建邮件服务。

## 发邮件

内网环境SPF验证显然是过不了的，然而DKIM验证并不难通过，只要本地生成一对密钥，将公钥通过DNS TXT记录暴露给收件方即可。

基于此，将DMARC策略配置为不校验SPF，但必须校验DKIM，满足这个条件即通过验证。

具体的SPF记录如下：

```ascii
TXT	sxrekord.com.	v=spf1 a ra=postmaster +all
TXT	sxrekord.com.	v=spf1 mx ra=postmaster +all
```
v表示版本，a和mx表明允许a记录和mx记录对应的ip地址发送邮件，+all表示其他所有ip地址也允许。

具体的DKIM记录如下：

```ascii
TXT	202505e._domainkey.sxrekord.com.	v=DKIM1; k=ed25519; h=sha256; p=HXpzd3vZu7DcfUVg4li5K1H2puzMtz9qWzXaKopwpX4=
TXT	202505r._domainkey.sxrekord.com.	v=DKIM1; k=rsa; h=sha256; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7hgG4Rw7bRvkwTarymenJk5slJPU5C05rkIkXXRNS89t8sNjc7fnk6JF7AiDqAagBGG3TKdp7QwPLwgI2aIfv8p+pY20EhIdgc52Saz6TF6bhxt0L2fY1Yo3rwbAfm0O2Lt0chVvXGJw2zf2HkiDZwVY/oKSvevhu2mgW48bm1h4atPQVgeNHIdEn/+pF1cPd3Yn5vQf6J/Y5OdUzKeoeES8Bc9nDzBY2GRWNvUmAPrJWoF/p0uiLbA6nqfx2zMAqF0wBicV5qo9+XyCW/Ko8EP1wUm1/gy/BOQUBne2tKlSpPXTiMdDdDrY6yCD3cLZjLvSQ4lysUv679Tm+iqD8wIDAQAB
```

具体的DMARC记录如下：

```ascii
TXT	_dmarc.sxrekord.com.	v=DMARC1; p=reject; aspf=r; adkim=s; rua=mailto:postmaster@sxrekord.com; ruf=mailto:postmaster@sxrekord.com
```

v表示版本，必须作为第一个标签，p表示邮件接收者根据域名所有者的要求制定的策略，aspf=r表明要求使用relaxed mode验证spf，adkim=s表明要求使用strict mode验证dkim，rua表示发送综合反馈的邮件地址，ruf表示发送消息详细故障信息的邮件地址。

**收件人写好邮件并提交后，由MTA加上DKIM签名，通过DNS将邮件发送出去，由于配置了以上记录，大部分的邮件服务提供商都不会拒绝接收。**

> 谷歌邮件强制通过DNS PTR记录反查域名，所以会拒收通过一个随机IPv4发送的邮件。

## 收邮件

对方会通过DNS查询为sxrekord域提供邮件服务的IP地址，所以流量一定会经过这个公网服务器，一种最简单的解决方案就是在它之上将流量透明转发到内网机器上。

我实际是通过[frp](https://github.com/fatedier/frp)实现流量转发的，frpc.toml具体配置如下：

```toml
[[proxies]]
name = "smtp-receiver"
type = "tcp"
localIP = "127.0.0.1"
localPort = 25
remotePort = 25
transport.useEncryption = true
transport.useCompression = true
transport.tcpMux = true
transport.poolCount = 1
```

## 网络拓扑

![网络拓扑](https://cdn.sxrekord.com/v2/image-20250523194727-g7532nm.png)

## 结果

谷歌邮件因为PTR查询失败直接拒收。

网易邮箱实测可行。

QQ邮箱有时正常，有时会抽风提示DMARC验证失败。

# 云端环境

使用这种方式网络拓扑没有弯弯绕绕，所以这里就不专门画图了。

实测发现25端口出境异常，具体来说就是无法向任何IP的25端口通信，但接收正常（当然你还是需要手动在云服务器上放行对应的端口）。

搜索后发现是云服务器厂商为了避免客户滥用25端口发送推广或者垃圾邮件而[故意禁掉](https://developer.aliyun.com/article/792798?spm=5176.21213303.J_6704733920.10.754e53c9M4zxa4&amp;scm=20140722.S_community%40%40%E6%96%87%E7%AB%A0%40%40792798._.ID_community%40%40%E6%96%87%E7%AB%A0%40%40792798-RL_25%E7%AB%AF%E5%8F%A3-LOC_main-OR_ser-V_2-P0_1)的。

我已经提交申请，也不知道给不给通过。

# 相关软件

MUA我选择的是Foxmail，MTA我选择的是[stalwart](https://github.com/stalwartlabs/stalwart)。

stalwart将邮件交互的各个阶段和步骤都进行了拆分，这样就能进行非常细粒度的控制。而其中的大部分阶段都支持条件表达式以实现灵活的处理和拦截。

但我实际使用过程中发现日志更多的是一些网络层的信息，并没有诸如各个阶段条件表达式的通过情况，具体经历了哪些处理等细节。

> 上面的说法基于默认的INFO日志级别，我试过将日志调整为DEBUG已查看更多细节，但这样有效信息反而都被淹没了。

另外，邮件属于重灾区，经常会被莫名其妙的拒收（在此点名批评QQ邮箱），从网络抓包也只能分析到与第三方邮件的SMTP传输正常结束。

总之，调试过程中不乏苦不堪言的经历。

# FQA

客户端勾选SSL后认证失败，请勾选Allow plain text authentication.

![Allow plain](https://cdn.sxrekord.com/v2/image-20250523201757-7gcqb8x.png)

EHLO失败，请将Reject Non-FQDN设置为false。

![Reject Non-FQDN](https://cdn.sxrekord.com/v2/image-20250523202217-m49nqng.png)

域内发送邮件失败，请允许Relay：

![Allow Relay](https://cdn.sxrekord.com/v2/image-20250523201924-av1d4j3.png)

# 参考
- https://service.mail.qq.com/detail/124/64?expand=11
- https://service.mail.qq.com/detail/124/62?expand=11
- https://service.mail.qq.com/detail/124/61?expand=11

# 最后

现在你可以尝试给[rekord@sxrekord.com](mailto:rekord@sxrekord.com)发送邮件了！

