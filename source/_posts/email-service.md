---
title: 邮件服务
index_img: https://cdn.sxrekord.com/v2/using_gmail_to_send_large_files_via_email_9eaebaf630.jpg
banner_img: https://cdn.sxrekord.com/v2/using_gmail_to_send_large_files_via_email_9eaebaf630.jpg
date: 2025-05-23 10:50:56
updated: 2025-05-23 10:50:56
categories:
- 技术
tags:
- email
---

一个完整的电子邮件系统主要由以下三类角色构成：

1. MUA：即邮件用户代理，它通过SMTP协议提交邮件，并通过POP/IMAP协议获取收到的邮件。常见的客户端有outlook/foxmail等。
2. MTA：即邮件传输代理，它接收MUA提交上来的邮件，并通过SMTP协议将之发送到接收方的MTA，并接收其他MTA发送过来的邮件。常见的MTA如本文中将提到的stalwart-mail和postfix等。
3. MDA：即邮件投递代理，MDA负责将邮件通过POP3/IMAP协议提供给MUA访问。MDA在物理上往往与MTA集成在一起。

通用流程如下图所示：

![邮件系统流程](https://cdn.sxrekord.com/v2/image-20250518164426-qpzvnue.png)

1. MUA通过SMTP协议将邮件发送到MTA上。
2. 服务器再使用SMTP协议将邮件发送到目标的邮件服务器上。
3. MTA将邮件放到邮箱内部的存储空间上。
4. MUA通过IMAP/POP3协议向MDA获取最新邮箱状态。
5. MDA查询内部储存空间。
6. 将最新的邮箱状态同步到本地。

# 邮件协议

从上文不难得知，邮件协议主要分为两大类：

1. IMAP/POP3：用户MUA与MDA之间的交互，所谓的交互就是访问服务器上的数据，收取邮件，更新状态等。其中IMAP更加现代化，支持在邮件服务器上浏览邮件，而POP只是简单拉取至本地然后删除服务器上的副本。
2. SMTP：用于邮件的提交和传输

下图是一个非常典型的Foxmail账号配置：

![Foxmail账号配置](https://cdn.sxrekord.com/v2/image-20250523173322-n8nlp2g.png)

这时候应该能理解为什么配置一个邮件服务端至少需要配置两类协议。

> 早期互联网协议尤其偏好纯文本协议（从UNIX沿袭而来的文化传统），而邮件发迹很早，所以每一种都是纯文本协议，到了现代，各自都衍生出了SSL版本。

## 端口

|协议名|常用端口|用途|协议|
| --------| ----------| ------------------------------| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|SMTP|25|MUA提交邮件，MTA之间传输邮件|SMTP（Simple Mail Transfer Protocol，简单邮件传输协议）用于发送邮件。当用户发送一封邮件时，SMTP 协议会被用来将邮件从发件人的邮件客户端传输到发件人的邮件服务器，然后邮件服务器使用 SMTP 将邮件传输到收件人的邮件服务器，最后邮件会被存储在收件人的邮箱中。|
|SMTPS|465|||
|POP|110|MUA与MDA之间的交互|POP3（Post Office Protocol version 3，邮局协议版本 3）是一种较老的邮件检索协议，它允许用户从邮件服务器下载邮件到本地计算机。一旦邮件被下载，通常会在服务器上删除，这意味着用户只能在下载邮件的设备上访问邮件。|
|POPS|995|||
|IMAP|143|MUA与MDA之间的交互|IMAP（Internet Message Access Protocol，互联网邮件访问协议）是一种邮件检索协议，允许用户在邮件服务器上直接管理邮件。使用 IMAP，用户可以查看、组织和搜索存储在服务器上的邮件，而不需要将邮件下载到本地计算机。|
|IMAPS|993|||

**事实上MTA之间传输邮件还是以25端口为主，但会配合使用STARTTLS以避免明文传输。**

> STARTTLS是一种协商级别的tls，即如果服务端支持tls，那么后续流程就全部使用tls加密；与之相对的叫做隐式TLS（implicit TLS），这种方式会强制使用TLS传输。
>
> ![STARTTLS](https://cdn.sxrekord.com/v2/image-20250523174646-pwyxnq3.png)

# 认证

由于邮件容易被滥用，毕竟只要知道收件人的地址即可随意发送邮件，如果是发件人自己搭建的邮件服务器，甚至可以做到无成本发送垃圾邮件。

基于此考量，出现了相关的认证和信任机制。

## SPF/DKIM/DMARC

SPF：通过TXT记录指明有哪些记录有资格代表该域名发送邮件。这样能避免其他IP伪冒发送者发送垃圾邮件。

DKIM：邮件发送者使用自己的私钥加密邮件并生成数字签名，然后再通过TXT记录提供了公钥信息，这样收件人就能够验证发件人是否假冒或者邮件是否被篡改。

DMARC：通过TXT记录指明了发件人具体采用的策略以及建议收件人采取的措施。比如指示收件人在SPF验证不通过时直接拒绝接收邮件，并向指定的邮件发送报告。

## ARC

邮件在转发过程中可能会经过中间服务器，这些服务器有时候会对原始邮件的头字段进行修改，比如修改From以保证响应仍然经过当前中间服务器。

其特征主要体现在增加了三个头字段，分别为ARC-Authentication-Results(AAR)、ARC-Message-Signature(AMS)和ARC-Seal (AS)。

* AAR记录当前中间服务器对邮件的SPF、DKIM和DMARC验证结果，以及之前所有ARC Set的验证结果。

  ```ascii
  ARC-Authentication-Results: i=1; mx.google.com;
         dkim=pass header.i=@pingro.com header.s=resend header.b=6913Ztoi;
         dkim=pass header.i=@amazonses.com header.s=suwteswkahkjx5z3rgaujjw4zqymtlt2 header.b="xV1lId/K";
         spf=pass (google.com: domain of 01060196fa7dfc84-d3b86bc5-a23b-4fe5-bf07-90a7c6fdb6a3-000000@send.pingro.com designates 23.251.234.51 as permitted sender) smtp.mailfrom=01060196fa7dfc84-d3b86bc5-a23b-4fe5-bf07-90a7c6fdb6a3-000000@send.pingro.com
  ```

* AMS对邮件的原始头部信息（包括To、From、Subject、Body等）以及新增或修改的头部信息进行签名。

  ```ascii
  ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
          h=feedback-id:mime-version:date:content-transfer-encoding:message-id
           :subject:to:from:dkim-signature:dkim-signature;
          bh=5WkmCLGO0BN+h7/kMtFHPAI35S4stO1xtXj/EE2lAQE=;
          fh=66BFIJPh7/cxULEHMR8Uwy+l70fPbt/AlBPcVhGxDXI=;
          b=FPb3y7W8zXliEGK7+hU3hxRsWWfGMTce6QwuKIBbTpUCgYVw7jqO0tj0x9ADbUI4x/
           gdKMTn4BqBSy8ayrThQpjTndcLGLBRCktzNt0zhIH5U5dSJpMM9evVcZf5sPNMqEBxjR
           yttQVi08maENHq3RNJenYj47Sa0gEf/tbB/EOMou52dkg49QnIcoyZHcnuwZ7HJYUuXJ
           j5joJailOve31Z/EgwQZ1m/UxGaR78Nq71l7KZwvkbHmHQOkMg98hLe046blvGG7YODY
           bFfMQdlOZDQsEv+f30psxcgpyzyrlG/WkOjmYiUFs179EKt0gnJusyyCC1LTChULG191
           u4Og==;
          dara=google.com
  ```

* AS包含了之前所有ARC Set的签名以及当前的AAR和AMS，就像在层层印章上再盖上自己的名字，表示对整个信任链的认可。

  ```ascii
  ARC-Seal: i=1; a=rsa-sha256; t=1747959283; cv=none;
          d=google.com; s=arc-20240605;
          b=dLyoV20CxHDb4otvwzMToFK7HaM8OdiDsaRlbwzg2SDfHPR9nXuu3tj0fc8AX5awGN
           jwMsUgq8Rmbqcan+iiE3tvqKCCnc5Oki3iBmF4OIYGIF+8yqzuNVTPQ1/wtuROJ0sBcE
           o7ZqriQUQ9Ee3nEitzXRbE7f0C9cYLrfyRJUF7gpZrlI0d1NH/wJoqPGGkNcckv6SmnT
           PylULhrXdJ841XndgQjJXZDkU376NYctVA3PyQPpwooRg7fj/MPjDhjZZtfx6TDo9Izs
           dSwrhrI4HzO71tyObEdLZRoBRwEudj/xZsGtQ/q7hqCpVGAIW+uUxOxMKuZf1ok94xsS
           3Yfw==
  ```

# 疑惑

MUA使用SMTPS提交邮件这一步顺利完成，但我一直没懂服务器明明没有有效证书，客户端是怎么通过tls协商的？

通过抓包直接导出wireshark中服务端给出的证书：

![wireshark-certificate](https://cdn.sxrekord.com/v2/image-20250523134347-8siexoz.png)

导出后保存为cer文件，预览如下：

![windows-certificate](https://cdn.sxrekord.com/v2/image-20250523134424-7t8mpyf.png)

显然这是个自签名证书，虽说即使这样，客户端如果使用证书中的公钥传递加密后的对称密钥，整个过程仍然是安全的。~~如果不考虑服务端不可信的问题的话。~~

> 无法确定是不是因为smtp我填的是一个ip地址。

# 参考

* https://github.com/stalwartlabs/mail-server

* https://www.cnblogs.com/ysocean/p/7652934.html

* https://service.mail.qq.com/detail/124/61
