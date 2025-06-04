---
title: SIP协议
index_img: https://cdn.sxrekord.com/v2/image-20250526170809978.png
banner_img: https://cdn.sxrekord.com/v2/image-20250526170809978.png
date: 2025-05-26 17:52:46
updated: 2025-05-26 17:52:46
categories:
- 技术
tags:
- 学习笔记
---

SIP是一种应用层的控制协议，它可以创建，修改和结束多媒体会话（会议），例如网络电话呼叫。SIP也可以邀请参与对象加入到已存在的会话，例如多方广播会议。它可以从当前存在的会话中再加入媒体也可以移除媒体。

SIP支持创建和结束多媒体通信的五个方面：

○ 用户位置：确定用于通信的终端系统；

○ 用户有效性: 确定被呼叫方是否有意愿决定加入通信；

○ 用户能力: 决定用户可使用的媒体和其媒体参数；

○ 会话创建: "ringing"，在呼叫方和被呼叫方之间创建会话参数；

○ 会话管理: 包括结束会话，修改会话参数和调用服务。

> SIP可以支持IPv4和IPv6两种网络环境。

# 层次结构

![SIP层次结构](https://cdn.sxrekord.com/v2/image-20250526155301-5l7qhap.png)

# 消息定义

```ascii
         generic-message  =  start-line
                             *header
                             CRLF
                             [ message-body ]
         start-line       =  Request-Line / Status-Line

         Request-Line  =  Method SP Request-URI SP SIP-Version CRLF
         Status-Line  =  SIP-Version SP Status-Code SP Reason-Phrase CRLF

         header  =  "header-name" HCOLON header-value *(COMMA header-value)
         header-value = value *(;parameter-name=parameter-value)
```

每个头部字段值中的参数名不得出现超过一次。字段名不区分大小写。除非另有说明，否则字段值、参数名和参数值都不区分大小写。**值中被引号包裹的部分区分大小写**。

出现的不合适的头部应当被忽略。

# UAC行为（dialog之外）

UAC产生的合法 SIP 请求至少必须包含：To、From、CSeq、Call-ID、Max-Forwards 和 Via。这六个头部字段是 SIP 消息的基本构建模块，因为它们共同提供了大多数关键消息路由服务，包括消息寻址、响应路由、限制消息传播、消息排序和事务的唯一标识。

### Request-URI

Request-URI 是 SIP 请求的**主要路由目标**。它指定了请求应该被发送到哪个 SIP 实体（通常是域或特定的服务器）。

消息的初始 Request-URI 应设置为 To 字段中的 URI 值。一个例外是 REGISTER 方法，因为在注册流程中，Request-URI表示registrar的地址，而To表示将被注册的用户。

> 一般通过Route头配置出站代理。

### To

To头部字段指定请求的“逻辑”接收者，或者是用户或资源的目标地址。这可能不是请求的直接接收者。收件人头部字段可以包含 SIP 或 SIPS URI，但在适当的情况下也可以使用其他 URI 方案（例如 RFC 2806 中的 tel URL）。所有 SIP 实现都必须支持 SIP URI 方案。任何支持 TLS 的实现都必须支持 SIPS URI 方案。收件人头部字段允许包含显示名称。

一个 UAC 可以通过多种方式学习如何为特定请求填充 To 头字段。通常，用户会通过人工界面建议 To 头字段，可能是手动输入 URI 或从某种地址簿中选择。

### From

From 头字段指示请求发起者的逻辑身份。与 To 头字段类似，它包含一个 URI，并且可以包含一个可选的显示名称。SIP 实体使用它来确定对请求应用哪些处理规则（例如，自动呼叫拒绝）。

### Call-ID

用于唯一标识符。此外，某个UAC向某个registrar发起的所有REGISTER消息的Call-ID都应该是相同的。

Call-IDs 区分大小写，并且简单地逐字节比较。

### CSeq

CSeq 头字段用于识别和排序事务。它由一个序列号和一个方法组成。序列号值必须可以表示为 32 位无符号整数，并且必须小于 2**31。

### Max-Forwards

作用同ttl，如果 Max-Forwards 的值在请求到达目的地之前减至 0，请求将被拒绝，并返回 483(跳数过多)的错误响应。

一般初始值为70.

### Via

Via 头部字段指示用于事务的传输方式，并标识响应应送回的位置。Via 头部字段的值只在选择了将用于到达下一个跳的传输方式后才被添加。

Via中的协议名称和协议版本必须是 SIP 和 2.0，**必须包含一个 branch 参数。此参数用于标识由该请求创建的事务。此参数由客户端和服务器共同使用。**

branch 参数的值必须在空间和时间上对所有 UAC 发送的请求都是唯一的。**此规则的例外情况是非 2xx 响应的 ACK 和 CANCEL。** CANCEL 请求将具有与其取消的请求相同的 branch 参数值。非 2xx 响应的 ACK 也将具有其确认的 INVITE 相同的 branch ID。

**该规范符合的元素插入的分支 ID 必须始终以字符&quot;z9hG4bK&quot;开头。**

当请求被传输层处理时，Via 头部的 maddr、ttl 和 sent-by 将被设置。

### Contact

Contact 头字段提供一个 SIP 或 SIPS URI，该 URI 可用于后续请求以联系该特定实例的 UA。并且该 URI 即使在会话之外的后续请求中使用也必须有效。在任何可能导致会话建立的请求中，Contact 头字段必须存在且包含一个 SIP 或 SIPS URI。

如果请求 URI 或顶部 Route 头字段值包含 SIPS URI，则 Contact 头字段也必须包含 SIPS URI。

### Supported & Require

如果 UAC 支持服务器可以应用于响应的 SIP 扩展，则 UAC 应在请求中包含一个 Supported 头字段，列出这些扩展的选项标签。

如果 UAC 希望坚持让 UAS 理解它将应用于请求的扩展，它必须在请求中插入一个包含该扩展选项标签的 Require 头字段。

如果 UAC 希望坚持让代理理解它将应用于请求的扩展，它必须在请求中插入一个包含该扩展选项标签的 Proxy-Require 头字段。

> 列出的选项标签必须仅指代标准 RFC 中定义的扩展。

## 发送请求

通过Route集合和Request URI确定下一跳的地址，不论是严格路由还是松散路由，Route优先级都比Request URI更高。

## 处理响应

响应首先由传输层处理，然后传递到事务层。事务层执行其处理，然后将响应传递到 TU。TU 中的大多数响应处理是方法特定的。

在某些情况下，事务层返回的响应可能不是 SIP 消息，而是一个事务层错误。当从事务层收到超时错误时，必须将其视为收到了 408（请求超时）状态码。如果传输层报告了致命的传输错误（通常是由于 UDP 中的致命 ICMP 错误或 TCP 中的连接失败），该情况必须被视为 503（服务不可用）状态码。

当UAC收到响应后，如果无法处理该响应码，应将这类响应码视为x00。比如不支持431的处理，则将其等同视为400处理。一个例外是1xx临时响应，如果收到了非100的临时响应，必须将其视为183处理。**所以每一个UAC都必须能够处理100、183、200、300、400、500和600.**

如果响应中存在多个 Via 头，UAC 应该丢弃该消息。因为这表明消息可能被错误路由或损坏。

## 重定向处理

​收到重定向响应（例如301）时，客户端应使用 Contact 头字段中的 URI(s)根据重定向的请求制定一个或多个新请求。

其中Contact中的URI(s)中可能带有q这个参数，它用于指导权重排序，值越大优先级越高；其中也有可能带有一些头部参数，指示使用该URI时需加上或替换成对应的头部。

新的请求的Request-URI替换成Contact中的URI。

## 4xx处理

根据具体的响应码决定是修改请求后重试还是报告错误。**若选择重试，则此新请求构成一个新的事务，并应该带有和之前请求相同的Call-ID、To和From，但CSeq加一。**

# UAS行为

一旦请求被认证（或跳过认证），UAS 必须检查请求的方法。如果 UAS 识别到但不支持请求的方法，它必须生成一个 405（方法不允许）响应。UAS 还必须在 405（方法不允许）响应中添加一个 Allow 头字段。Allow 头字段必须列出生成消息的 UAS 所支持的方法集。

​如果方法是服务器支持的方法，则继续处理。

如果 UAS 不理解请求中的头字段，服务器必须忽略该头字段并继续处理消息。UAS 应忽略任何不需要处理头字段的格式错误。

如果To字段和UAS身份不符，UAS也可以选择接受该请求，反之则发送一个403.

如果Request-URI使用了UAS不支持的格式（如tel），它应该发送一个416（不支持的URI方案）响应。

如果请求 URI 不是 UAS 愿意接受的地址，它应该使用 404（未找到）响应来拒绝请求。

同一个请求已经通过不同的路径到达 UAS 多次，这很可能是由于分叉造成的。UAS 处理收到的第一个此类请求，并对其余的请求响应 482（检测到循环）。

如果 UAS 不理解 Require 头字段中列出的选项标签，它必须通过生成状态码为 420（无效扩展）的响应来响应。UAS 必须添加一个 Unsupported 头字段，并列出请求的 Require 头字段中它不理解的那些选项。

> 注意，Require 和 Proxy-Require 不应用于 CANCEL 请求和向非 2xx 响应发送的 ACK 请求。如果这些请求中包含这些头字段，则必须忽略它们。
>
> 对于 2xx 响应的 ACK 请求必须只包含初始请求中存在的 Require 和 Proxy-Require 值。

如果存在任何类型（由 Content-Type 指示）、语言（由 Content-Language 指示）或编码（由 Content-Encoding 指示）不被理解，并且该部分不是可选的（由 Content-Disposition 头部字段指示），则 UAS 必须使用 415（不支持的媒体类型）响应拒绝请求。响应必须包含一个 Accept 头部字段，列出它理解的所有body类型，以防请求包含 UAS 不支持的body类型。如果请求包含 UAS 不理解的内容编码，则响应必须包含一个 Accept-Encoding 头部字段，列出 UAS 理解的编码。如果请求包含 UAS 不理解的语言内容，则响应必须包含一个 Accept-Language 头部字段，指示 UAS 理解的语言。除了这些检查之外，body处理取决于方法和类型。

如果用户代理（UAS）希望在生成响应时应用某些扩展，则除非请求中的“支持”（Supported）头字段指示了该扩展的支持，否则不得这样做。在极少数情况下，如果服务器不使用扩展就无法处理请求，服务器可以发送 421（扩展必需）响应。所需的扩展必须包含在响应的Require头字段中。

## 生成响应

**UAS 不应针对非INVITE发出临时响应。** 相反，UAS 应尽快为非INVITE生成最终响应。

当生成 100 响应时，请求中存在的任何时间戳（Timestamp）头字段必须复制到这个 100 响应中。如果生成响应有延迟，UAS 应在该响应的时间戳值中添加延迟值。该值必须包含发送响应和接收请求之间的时间差，以秒为单位。

​响应的 From 字段必须等于请求的 From 头字段。响应的 Call-ID 头字段必须等于请求的 Call-ID 头字段。响应的 CSeq 字段必须等于请求的 CSeq 字段。响应中的 Via 头字段值必须等于请求中的 Via 头字段值，并保持相同的顺序。

如果一个请求中包含一个 To 标签，则响应中的 To 头字段必须与请求中的相同；如果不包含标签，则响应应在原先To的基础上加上一个To标签。（100响应除外）

> 无状态 UAS 是一种不维护事务状态的 UAS。它正常回复请求，但会丢弃通常由 UAS 在发送响应后保留的状态。如果无状态 UAS 收到请求的重传，它会重新生成响应并重新发送，就像它正在回复请求的第一个实例一样。

# CANCEL a Request

不应向非 INVITE 请求发送 CANCEL。

CANCEL 请求中的 Request-URI、Call-ID、To、CSeq 的数值部分以及 From 头字段必须与被取消的请求中的这些字段完全相同，包括标签。由客户端构建的 CANCEL 请求必须只有一个 Via 头字段值与被取消请求的顶部 Via 值匹配。使用相同的头字段值允许 CANCEL 与其取消的请求匹配。但是，CSeq 头字段的 method 部分必须具有 CANCEL 值。这允许它被识别并作为自己的事务进行处理。

​如果被取消的请求包含 Route 头字段，CANCEL 请求必须包括该 Route 头字段的值。

CANCEL 请求不得包含任何 Require 或 Proxy-Require 头字段。

一旦构建了 CANCEL 消息，客户端应当检查是否已收到任何关于原始请求的响应（临时或最终）。如果没有收到临时响应，客户端不得发送 CANCEL 请求；相反，客户端必须等待临时响应到达后再发送请求。如果原始请求已经生成了最终响应，则不应发送 CANCEL。

当客户端决定发送 CANCEL 时，它会为 CANCEL 创建一个客户端事务，并将 CANCEL 请求以及目标地址、端口和传输方式传递给它。

# 注册

流程中最重要的头部说明如下：

Request-URI：指明了用于注册的位置服务的域名（例如，“sip:chicago.com”）。

To：To 头字段包含要创建、查询或修改的记录地址。此记录地址必须是 SIP URI 或 SIPS URI。

From: 表明发起注册的来源（负责人），一般来说，都是用户为自己注册，这时候From和To肯定是相同的，但有时，第三方会帮某个用户进行注册，这时候From表示第三方的地址，而To表示真正被注册的逻辑实体。

Call-ID：一个UAC向某个registrar发起的所有REGISTER请求的Call-ID都应当相同。再通过CSeq就能确定出多个REGISTER请求的顺序关系。

CSeq：每次+1

Contact：被注册用户的物理地址，可携带多个。其中的expires 参数表示用户代理希望绑定有效的时间长度。该值是一个表示秒数的数字。如果未提供此参数，则使用 Expires 头字段的值。实现应可以视为大于 2**32-1（4294967295 秒或 136 年）的值等同于 2**32-1。应将格式错误值视为等同于 3600。

```ascii
                                                 bob
                                               +----+
                                               | UA |
                                               |    |
                                               +----+
                                                  |
                                                  |3)INVITE
                                                  |   carol@chicago.com
         chicago.com        +--------+            V
         +---------+ 2)Store|Location|4)Query +-----+
         |Registrar|=======>| Service|<=======|Proxy|sip.chicago.com
         +---------+        +--------+=======>+-----+
               A                      5)Resp      |
               |                                  |
               |                                  |
     1)REGISTER|                                  |
               |                                  |
            +----+                                |
            | UA |<-------------------------------+
   cube2214a|    |                            6)INVITE
            +----+                    carol@cube2214a.chicago.com
             carol
```

终端设备在收到先前注册的最终响应或先前 REGISTER 请求超时之前，不得发送新的注册。

注册请求的 2xx 响应将在 Contact 头字段中包含已为此地址记录在此注册器上注册的完整绑定列表。

如果没有任何expire指示，则表明客户端希望由服务器来选择。

可以使用 Contact 头字段中的"q"参数进行优先级排序。

UAC 通过在 REGISTER 请求中将Expire置为"0"来请求立即移除绑定。

使用值为"*"的Contact 头字段允许注册用户代理（UA）在不了解其精确值的情况下移除所有与地址记录相关联的绑定。

如果事务层因为注册请求没有获得响应而返回超时错误，UAC 不应立即重新向同一个注册器进行注册，应等待一个合理的时间间隔。

如果用户代理收到一个 423（间隔太短）的响应，它可以在将注册请求中所有联系地址的过期间隔设置为大于或等于响应中 Min-Expires 头字段中的过期间隔后重试注册。

registrar不得生成 6xx 响应。

registrar如果接收到包含Record-Route头字段的注册请求，必须忽略该头字段。registrar在任何对注册请求的响应中不得包含Record-Route头字段。

registrar必须按照接收的顺序处理注册请求。注册请求还必须原子性地处理。

每个绑定记录记录了请求的 Call-ID 和 CSeq 值。

注册器返回 200（OK）响应。响应必须包含一个 Contact 头字段值，列出所有当前的绑定。每个 Contact 值必须包含一个"expires"参数，指示注册器选择的过期间隔。响应也应该包含一个 Date 头字段，客户端可以使用此头字段来获取当前时间，以设置任何内部时钟。

# 查询能力

OPTIONS 允许用户代理查询另一个用户代理或代理服务器的能力。这允许客户端在不“响铃”对方的情况下发现关于支持的方法、内容类型、扩展、编解码器等信息。例如，在客户端在 INVITE 中插入一个 Require 头字段，列出一个它不确定目的地 UAS 是否支持的功能之前，**客户端可以使用 OPTIONS 查询目的地 UAS，看看这个功能是否在 Supported 头字段中返回。**

**所有用户代理必须支持 OPTIONS 方法。**

OPTIONS 请求中可以包含 Contact 头字段。还应包含 Accept 头字段，以指示 UAC 希望在响应中接收的消息体类型。通常，这设置为描述 UA 媒体能力的格式，例如 SDP（application/sdp）。

只有当 OPTIONS 作为已建立对话的一部分发送时，才保证能够接收到响应。

示例OPTIONS请求如下：

```ascii
      OPTIONS sip:carol@chicago.com SIP/2.0
      Via: SIP/2.0/UDP pc33.atlanta.com;branch=z9hG4bKhjhs8ass877
      Max-Forwards: 70
      To: <sip:carol@chicago.com>
      From: Alice <sip:alice@atlanta.com>;tag=1928301774
      Call-ID: a84b4c76e66710
      CSeq: 63104 OPTIONS
      Contact: <sip:alice@pc33.atlanta.com>
      Accept: application/sdp
      Content-Length: 0
```

UAS返回的响应码必须与请求是 INVITE 时所返回的相同。也就是说，如果 UAS 准备接受呼叫，则返回 200（OK）；如果 UAS 忙碌，则返回 486（此处忙碌）等。这允许 OPTIONS 请求用于确定 UAS 的基本状态，这可以提前得知 UAS 是否会接受 INVITE 请求。

分叉的 INVITE 可以导致返回多个 200（OK）响应，但分叉的 OPTIONS 只会返回一个 200（OK）响应。

如果对 OPTIONS 请求的响应是由UAS生成的，UAS将返回 200（OK），并列出服务器的功能。Allow、Accept、Accept-Encoding、Accept-Language 和 Supported 头部字段应在 OPTIONS 请求的 200（OK）响应中存在；如果响应是由代理生成的，Allow 头部字段应被省略。Warning 头部字段也可以存在。

Contact 头部字段可以存在于 200（OK）响应中，并具有与 3xx 响应中相同的语义。也就是说，它们可以列出一组替代的名称和到达用户的方法。

OPTIONS也可以通过包含一个消息体提前进行媒体能力探知。

示例OPTIONS响应如下：

```ascii
      SIP/2.0 200 OK
      Via: SIP/2.0/UDP pc33.atlanta.com;branch=z9hG4bKhjhs8ass877
       ;received=192.0.2.4
      To: <sip:carol@chicago.com>;tag=93810874
      From: Alice <sip:alice@atlanta.com>;tag=1928301774
      Call-ID: a84b4c76e66710
      CSeq: 63104 OPTIONS
      Contact: <sip:carol@chicago.com>
      Contact: <mailto:carol@chicago.com>
      Allow: INVITE, ACK, CANCEL, OPTIONS, BYE
      Accept: application/sdp
      Accept-Encoding: gzip
      Accept-Language: en
      Supported: foo
      Content-Type: application/sdp
      Content-Length: 274

      (SDP not shown)
```

# Dialog

对话代表了两个用户代理之间的点对点 SIP 关系，这种关系会持续一段时间。对话促进了用户代理之间消息的排序，并在两者之间正确路由请求。它代表了解释 SIP 消息的上下文。

在每个用户代理（UA）中，每个对话都通过对话 ID 来标识，该对话 ID 由一个Call-ID、一个本地标签和一个远程标签组成。对话中每个参与的用户代理的对话 ID 并不相同。具体来说，在一个用户代理中的本地标签与对端用户代理中的远程标签相同。

对话包含某些用于在对话内进一步消息传输所需的状态。此状态包括对话 ID、本地序列号（用于按顺序排列从 UA 到其对端的请求）、远程序列号（用于按顺序排列从其对端到 UA 的请求）、本地 URI、远程 URI、远程目标、一个称为“安全”的布尔标志以及路由集，路由集是发送请求到其对端需要遍历的服务器的 URI 列表。对话也可以处于“早期”状态，这发生在它使用临时响应创建时，然后当收到 2xx 最终响应时过渡到“确认”状态。对于其他响应，或者如果在该对话上没有收到任何响应，则早期对话终止。

请求为INVITE，并收到有带有 To 标签的 2xx 或 101-199 响应才能建立对话。

## UAS行为

当 UAS 使用建立对话的响应（例如对 INVITE 的 2xx 响应）来响应请求时，UAS 必须将请求中的所有 Record-Route 头字段值复制到响应中（包括 URI、URI 参数以及任何 Record-Route 头字段参数，无论 UAS 是否知道这些参数），并必须保持这些值的顺序。UAS 必须在响应中添加一个 Contact 头字段。Contact 头字段包含一个地址，UAS 希望在该对话中通过该地址接收后续请求（包括对 2xx 响应的 ACK）。通常，此 URI 的主机部分是主机的 IP 地址或 FQDN。Contact 头字段中提供的 URI 必须是 SIP 或 SIPS URI。Contact头字段中的 URI 范围也不限于此对话，它可以在对话之外发送消息时使用。如果请求通过 TLS 到达，并且请求-URI 包含 SIPS URI，则“安全”标志设置为 TRUE。路由集必须设置为请求中Record-Route头字段中的 URI 列表，按顺序并保留所有 URI 参数。远程目标必须设置为请求中Contact头字段的 URI。远程序列号必须设置为请求中 CSeq 头字段中的序列号值。本地序列号必须为空。对话 ID 的呼叫标识符必须设置为请求中的 Call-ID 值。本地标签必须设置为对请求的响应中 To 字段的标签。远程标签必须设置为请求中 From 字段的标签。为了保证向后兼容性，如果From中未携带标签，并不视为一个错误，而是将远程标签置为一个空值。远程 URI 必须设置为 From 字段中的 URI，本地 URI 必须设置为 To 字段中的 URI。

## UAC行为

几乎与UAS行为相同，但路由集必须按照响应中 Record-Route 头字段中的 URI 列表的相反顺序构造。

## 对话内的请求

​对话内的请求可以包含 Record-Route，但这些请求不会导致对话的路由集被修改。

可以通过带有Contact头的re-INVITE来修改远程目标。这个re-INVITE请求对话双方都可以发送。

**UAC 使用远程目标和路由集来构建请求的 Request-URI 和 Route 头字段。** 如果是严格路由，则将第一个Route作为Request-URI，将远程目标作为最后一个Route；如果是松散路由，则将远程目标作为Request-URI。

例如，如果​远程目标是 sip:user@remoteua，并且路由集包含： <sip:proxy1>,<sip:proxy2>,<sip:proxy3;lr>,<sip:proxy4>，请求将使用以下 Request-URI 和 Route 头字段形成：

```ascii
   METHOD sip:proxy1
   Route: <sip:proxy2>,<sip:proxy3;lr>,<sip:proxy4>,<sip:user@remoteua>
```

如果对话中的一个请求的响应是 481（呼叫/事务不存在）或 408（请求超时），UAC 应终止该对话。如果请求完全没有收到响应（客户端事务会通知 TU 超时），UAC 也应终止对话。对于由 INVITE 发起的对话，终止对话包括发送一个 BYE。

如果请求在 To 头字段中有一个标签，但对话标识符不匹配任何现有对话，UAS 可能已经崩溃并重新启动，或者它可能收到了针对不同（可能失败的）UAS 的请求（UAS 可以构造 To 标签，以便 UAS 可以识别该标签是为它提供恢复的 UAS）。另一种可能是传入的请求被简单地错误路由了。根据 To 标签，UAS 可以接受或拒绝请求。这样即使发生崩溃，对话也可以持续存在。希望支持此功能的 UA 必须考虑一些问题，例如即使在重新启动时也要选择单调递增的 CSeq 序列号，重建路由集，并接受超出范围的 RTP 时间戳和序列号。如果 UAS 不希望重新创建对话而拒绝请求，它必须使用 481（呼叫/事务不存在）状态代码响应请求。

如果远程序列号是空的，它必须设置为请求中 CSeq 头字段值的序列号。如果远程序列号不为空，但请求的序列号低于远程序列号，则请求无序，必须使用 500（服务器内部错误）响应拒绝。如果远程序列号不为空，且请求的序列号高于远程序列号，则请求有序。CSeq 序列号可能比远程序列号高超过一个。这不是错误条件，UAS 应准备好接收和处理这类请求。然后 UAS 必须将远程序列号设置为请求中 CSeq 头字段值的序列号。

> 例如代理对 UAC 发出的请求提出挑战，UAC 必须使用凭证重新提交该请求。重新提交的请求将具有新的 CSeq 编号。UAS 将永远不会看到第一个请求，因此它将注意到 CSeq 编号空间中的空白。这种空白不代表任何错误条件。

# 发起会话

一旦收到最终响应，UAC 需要为每个收到的最终响应发送 ACK。每一个2xx响应都会建立一个dialog，一次呼叫（call）可能由多个dialog组成。

INVITE 消息中应包含一个Allow头字段；还应包含一个Supported头字段；也可以存在Accept头字段，它指示可以被接受的Content-Type。

INVITE消息中的Expires头用于限制邀请的有效时间。如果在指示的时间内都没有收到最终相应，UAC core会生成一个CANCEL请求。

INVITE消息中还可以包含Subject/Organization/User-Agent等头部字段用于向接收方提供更多信息。

可以携带一个Content-Disposition头以指示消息体的处置方式。如sdp的处置方式为session，照片的处置方式为render。Content-Type为application/sdp的body隐含的处置方式为“session”，而其他Content-Type隐含的处置方式为“render”。

INVITE 可能会收到一个非 2xx 的最终响应。4xx、5xx 和 6xx 响应可以包含一个 Contact 头字段值，指示可以找到有关错误附加信息的地点。

在收到最终响应后，UAC 核心认为 INVITE 事务已完成。UAC为响应生成 ACK。否则UAS将重传响应。

UAS 拒绝 INVITE 时，应返回 488（这里不接受）响应。此类响应应包含一个警告头字段值，解释为什么拒绝。

INVITE 的2xx响应消息中应包含一个Allow头字段；还应包含一个Supported头字段；也可以存在Accept头字段，它指示可以被接受的Content-Type。

# 修改现有会话

与 INVITE 不同，INVITE 可以分叉，而re-INVITE 永远不会分叉，因此只会生成一个最终响应。

UAC 在任一方向上有一个正在进行的 INVITE 事务时，绝不能在一个对话中发起新的 INVITE 事务。

**如果 UA 收到一个 re-INVITE 的非 2xx 最终响应，而且响应码不为481/408，会话参数必须保持不变，就好像没有发出 re-INVITE。如果收到的是481、408或是超时，将终止对话。**

# 终止会话

主叫可以对早期的或已经确认的对话发送BYE来结束会话，**但被叫直到收到其 2xx 响应的 ACK 或服务器事务超时之前，不得发送 BYE。**

CANCEL 试图迫使对 INVITE 产生非 2xx 响应。一般在收到最终响应之前，主叫其实都是采用CANCEL执行“挂断”这一操作。

被叫在建立对话之前可以通过返回4xx（比如403）来拒绝建立会话。

# 代理行为

# 事务

一个 SIP 事务由一个请求及其所有响应组成，这些响应包括零个或多个临时响应和一个或多个最终响应。

在请求为 INVITE（称为 INVITE 事务）的事务中，只有当最终响应不是 2xx 响应时，事务才包括 ACK。如果响应是 2xx，ACK 不被视为事务的一部分。

客户端事务状态机有两种类型。一种处理 INVITE 请求的客户端事务。这种类型的状态机被称为 INVITE 客户端事务。另一种处理除 INVITE 和 ACK 之外的所有请求的客户端事务。这被称为非 INVITE 客户端事务。ACK 没有客户端事务。如果 TU 希望发送 ACK，它会直接将其传递给传输层进行传输。

顶层 Via 头字段中的 branch 参数和 CSeq 的 method 字段共同用于匹配事务。需要后者是因为 CANCEL 请求构成不同的事务，但共享相同的 branch 参数值。

# 传输

必须实现TCP和UDP，也可以实现其他协议。

如果请求大小在路径 MTU 的 200 字节以内，或者如果它大于 1300 字节且路径 MTU 未知，请求必须使用拥塞控制传输协议（如 TCP）发送。但是也必须能够处理最大的udp数据报。

如果试图使用tcp发送失败，如收到ICMP协议不支持消息，则会使用UDP重传。

向多播地址发送请求的客户端必须在包含目标多播地址的 Via 头字段值中添加"maddr"参数。

在发送请求之前，客户端传输必须在 Via 头字段中插入"sent-by"字段的值。该字段包含一个 IP 地址或主机名和端口。推荐使用完全限定域名。该字段在某些条件下用于发送响应，如果端口缺失，默认值取决于传输方式。对于 UDP、TCP 和 SCTP，默认值是 5060；对于 TLS，默认值是 5061。

当收到响应时，客户端传输会检查顶部 Via 头字段值。如果该头字段值中"sent-by"参数的值与客户端传输配置插入到请求中的值不匹配，则该响应必须被静默丢弃。

# 常见消息组件

默认传输方式取决于scheme。对于 sip: 是 UDP。对于 sips: 是 TCP。

SIP 和 SIPS URI 的用户信息部分是作为区分大小写的字符串进行比较的。tel URL 中不区分大小写部分的变化并且 tel URL 参数的重新排序不会影响 tel URL 的等效性，但会影响由它们形成的 SIP URI 的等效性。

​Contact、From 和 To 头字段包含 URI。如果 URI 中包含逗号、问号或分号，URI 必须用尖括号（<和>）括起来。任何 URI 参数都包含在这些括号内。如果 URI 没有用尖括号括起来，任何分号分隔的参数都是头部参数，而不是 URI 参数。

## Accept

**where列中的可选值及其解释如下：**

R：只能出现在请求中

r：只能出现在响应中

2xx，4xx等：只能出现在特定响应码或响应码范围的响应中

c：从请求复制到响应中

<empty>：可能出现在任何请求或响应中

**proxy列中的可选值及其解释如下：**

a：如果不存在，代理可以添加或拼接

m：代理可以修改

d：代理可以删除

r：代理必须能够读取，所以该头不能被加密

其他**列中的可选值及其解释如下：**

c：conditional

m：mandatory

o：optional

t：发送时应当带上，但是接受时不报期望，但如果使用基于流（如TCP）的传输层，则一定需要带上

*：如果body不为空，则必须带上

-：不适用，不得出现

> ​如果不存在 Accept 头部字段，服务器应假定默认值为 application/sdp。

```ascii
          Header field          where        proxy ACK BYE CAN INV OPT REG
          ________________________________________________________________
          Accept                  R                 -   o   -   o   m*  o
          Accept                 2xx                -   -   -   o   m*  o
          Accept                 415                -   c   -   c   c   c
          Accept-Encoding         R                 -   o   -   o   o   o
          Accept-Encoding        2xx                -   -   -   o   m*  o
          Accept-Encoding        415                -   c   -   c   c   c
          Accept-Language         R                 -   o   -   o   o   o
          Accept-Language        2xx                -   -   -   o   m*  o
          Accept-Language        415                -   c   -   c   c   c
          Alert-Info              R           ar    -   -   -   o   -   -
          Alert-Info             180          ar    -   -   -   o   -   -
          Allow                   R                 -   o   -   o   o   o
          Allow                  2xx                -   o   -   m*  m*  o
          Allow                   r                 -   o   -   o   o   o
          Allow                  405                -   m   -   m   m   m
          Authentication-Info    2xx                -   o   -   o   o   o
          Authorization           R                 o   o   o   o   o   o
          Call-ID                 c            r    m   m   m   m   m   m
          Call-Info                           ar    -   -   -   o   o   o
          Contact                 R                 o   -   -   m   o   o
          Contact                1xx                -   -   -   o   -   -
          Contact                2xx                -   -   -   m   o   o
          Contact                3xx           d    -   o   -   o   o   o
          Contact                485                -   o   -   o   o   o
          Content-Disposition                       o   o   -   o   o   o
          Content-Encoding                          o   o   -   o   o   o
          Content-Language                          o   o   -   o   o   o
          Content-Length                      ar    t   t   t   t   t   t
          Content-Type                              *   *   -   *   *   *
          CSeq                    c            r    m   m   m   m   m   m
          Date                                 a    o   o   o   o   o   o
          Error-Info           300-699         a    -   o   o   o   o   o
          Expires                                   -   -   -   o   -   o
          From                    c            r    m   m   m   m   m   m
          In-Reply-To             R                 -   -   -   o   -   -
          Max-Forwards            R           amr   m   m   m   m   m   m
          Min-Expires            423                -   -   -   -   -   m
          MIME-Version                              o   o   -   o   o   o
          Organization                        ar    -   -   -   o   o   o
       	  Priority                R           ar    -   -   -   o   -   -
       	  Proxy-Authenticate     407          ar    -   m   -   m   m   m
       	  Proxy-Authenticate     401          ar    -   o   o   o   o   o
       	  Proxy-Authorization     R           dr    o   o   -   o   o   o
       	  Proxy-Require           R           ar    -   o   -   o   o   o
       	  Record-Route            R           ar    o   o   o   o   o   -
       	  Record-Route         2xx,18x        mr    -   o   o   o   o   -
       	  Reply-To                                  -   -   -   o   -   -
          Require                             ar    -   c   -   c   c   c
       	  Retry-After      404,413,480,486          -   o   o   o   o   o
       	                       500,503              -   o   o   o   o   o
       	                       600,603              -   o   o   o   o   o
       	  Route                   R           adr   c   c   c   c   c   c
       	  Server                  r                 -   o   o   o   o   o
       	  Subject                 R                 -   -   -   o   -   -
       	  Supported               R                 -   o   o   m*  o   o
       	  Supported              2xx                -   o   o   m*  m*  o
       	  Timestamp                                 o   o   o   o   o   o
       	  To                    c(1)           r    m   m   m   m   m   m
       	  Unsupported            420                -   m   -   m   m   m
       	  User-Agent                                o   o   o   o   o   o
       	  Via                     R           amr   m   m   m   m   m   m
       	  Via                    rc           dr    m   m   m   m   m   m
       	  Warning                 r                 -   o   o   o   o   o
       	  WWW-Authenticate       401          ar    -   m   -   m   m   m
       	  WWW-Authenticate       407          ar    -   o   -   o   o   o
```

## Accept-Encoding

一个空的 Accept-Encoding 头字段是允许的。它等同于 Accept-Encoding: identity

## Accept-Language

如果不存在 Accept-Language 头部字段，服务器应假定所有语言对客户端都是可接受的。

## Alert-Info

`Alert-Info 头字段指定一个替代的响铃音给 UAS，用户应该能够选择性地禁用此功能。`​

## Authorization

UAC收到服务端要求认证的响应后（401/407），会通过响应WWW-Authenticate/Proxy-Authenticate头部中的认证挑战信息生成密钥信息，并将其放在Authorization头部中重新发送给服务端。

## Authentication-Info

服务端认证成功后发送的响应可能会带上该头部，其中可能带有nextnonce和rspauth（用于验证服务端身份）。

## Contact

## Content-Disposition

描述 UAC 或 UAS 如何解释消息体，对于多部分消息，则描述如何解释消息体的一部分。

值"session"表示消息体部分描述了一个会话；"render"值表示消息体部分应该显示或以其他方式渲染给用户；值"icon"表示该消息体包含适合作为呼叫者或被呼叫者的图标表示的图像，当收到消息时，用户代理可以信息性地渲染它，或者在会话过程中持久地显示；值 "alert" 表示该消息体包含信息，例如音频片段，用户代理应尝试渲染这些信息以提醒用户收到请求。

任何具有 "disposition-type" 且向用户渲染内容的 MIME 消息体，只有在消息经过适当认证后才能处理。

## Content-Encoding

如果对实体主体应用了多个编码，内容编码值必须按其应用的顺序列出。

所有内容编码值都是大小写不敏感的。IANA 作为内容编码值的注册机构。

# PRACK

PRACK消息是sip协议的扩展，在RFC3262中定义，标准的名称是sip协议中的可靠临时响应，即provisional ack。

由于某些场景下临时响应消息也很重要，在RFC3262中对临时响应进行了扩展，可以简单分为普通临时响应和可靠临时响应：

* 普通临时响应，响应码范围100-199，UAS针对invite消息的普通的临时响应，不需要UAC确认消息，没有“Require: 100rel”和“RSeq”头域。

* 可靠临时响应，响应码范围101-199，UAS针对invite消息的可靠的临时响应，需要UAC确认消息，使用PRACK确认，与普通临时响应的主要区别在于多了两个头域，“Require: 100rel”和“RSeq: 1852321830”。

PRACK，可靠临时响应的确认消息，由UAC发起，用来保证可靠临时响应的传递。流程示例如下：

```ascii
UAS->UAC: 183 Session Progress | CSeq xx INVITE | RSeq yy

UAC->UAS: PRACK | CSeq xx+1 PRACK | RAck yy xx INVITE

UAS->UAC: 200 OK(PRACK) | CSeq xx+1 PRACK
```

使用“CSeq: xx PRACK”和“RAck: yy xx+1 INVITE”头域匹配可靠临时响应。

RFC3262中对于UAS和UAC处理可靠临时响应的流程描述：

1. UAS在发送第一个可靠临时响应之后，未收到PRACK确认之前，不能发送第二个可靠临时响应。

2. UAC在收到第一个可靠临时响应之后，发送PRACK确认之前，如果收到第二个可靠临时响应，可以采用丢弃或缓存的处理方式，收到普通临时响应也可以采用丢弃或缓存的处理方式。

# Header Compact form

为了减小包大小，可以使用头的简写形式。

|头|缩写|
| ------------------| :----: |
|Call-ID|i|
|Contact|m|
|Content-Encoding|e|
|Content-Length|l|
|Content-Type|c|
|From|f|
|Subject|s|
|Supported|k|
|To|t|
|Via|v|

# 术语定义

AOR：SIP/SIPS标识与其真实地址之间的映射

B2BUA：UAC+UAS

Core：一个SIP实体表现怎样的行为是通过它的core决定的

Dialog：两个UA之间建立的、持续一段时间的一对一SIP关系，在RFC2543中曾被称为Call Leg

Downstream：UAC->UAS

Upstream：UAS->UAC

Header Field：

Header Field Value

Header：*(Header Fileld: Header Field Value)

Home Domain：为SIP用户提供服务的域

Information Response/Provisional Response：临时响应，1xx

Location Service：位置服务被重定向服务器或代理服务器用来获取被叫方可能的地址信息。

Loop：一个请求到达代理服务器，被转发，然后又回到同一个代理服务器。当它第二次到达时，其 Request-URI 与第一次相同，且其他影响代理操作的头部字段未改变，因此代理会做出与第一次相同的处理决定。循环请求是错误

Strict Routing：如果Route头存在，代理会将其中最顶端的URI取出，用它来替换Request-URI。然后代理会将这个被修改过的请求转发到新的Request-URI所指示的下一个跳点。

**Loose Routing：正常情况下Route最顶端的地址就是当前代理地址，移除该地址并将下一个Route地址作为下一跳，但是不再修改Request-URI。符合这一机制的代理被称为Loose Router。**

Outbound Proxy：即使它可能不是Request-URI解析的服务器，也会直接从客户端接收请求

Sequential Search：一个接一个的发送请求，发送下一个请求之前必须等待上一个请求的**最终响应**。2xx或6xx响应会终止顺序搜索。

Parallel Search：收到一个请求后向多个目的地同时转发请求而无需等待最终响应。

Recursion：UAC发起一个请求，却因为收到了3xx响应，此时需要根据响应中的 Contact 头字段中的一个或多个 URI 生成新的请求时，就叫递归。

Redirect Server：通过生成3xx响应来指导客户端联系备用URIs。（通过Contact头）

Regular Transaction：任何非INVITE、ACK或CANCEL方法的事务

SIP Transaction：一个请求+与之相关的所有响应。PRACK也算在一个事物之中，但是ACK就是另一个单独的事务了。

Spiral：一个被路由到代理的SIP请求，然后被转发，最终再次到达该代理，但通常再次到达后的请求的Request-URI与其之前的不同，所以Spiral不像loop，它不是错误

stateless proxy：将接收到的每个请求转发到下游，将接收到的每个响应转发到上游。

Transaction User（TU）：包括UAC core，UAS core，proxy core

UAC Core：UAC所必需的一组处理功能

UAS Core：UAS所必需的一组处理功能

# 参考

* [rfc3261](https://www.rfc-editor.org/rfc/rfc3261.html)
* [SIP协议中文版](https://docs.qq.com/doc/p/6fd0da6854b814b76296741bcd06e5686d14880b)
* [PRACK消息](https://www.cnblogs.com/qiuzhendezhen/p/17657553.html)

