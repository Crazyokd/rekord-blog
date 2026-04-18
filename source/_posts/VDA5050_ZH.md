---
title: VDA5050-ZH
date: 2026/04/18
updated: 2026/04/18
index_img: https://cdn.sxrekord.com/v2/csagv.png
banner_img: https://cdn.sxrekord.com/v2/csagv.png
categories:
- 技术
tags:
- 规范
- 学习笔记
---


# 移动机器人与车队控制系统之间的通信接口

## VDA 5050

## 版本 3.0.0


# 免责声明
以下说明旨在为实现一种可在移动机器人与车队管理系统之间进行通信的接口提供指导。其目标是向所有用户免费开放，且不具有约束力。任何选择采用这些指南的一方，都有责任确保其在具体场景中的正确和适当使用。

用户在采用这些指南时，必须考虑当时适用的技术发展水平。使用这些建议并不免除任何一方对其自身行为承担责任。这些说明并不声称穷尽所有情况，也不构成对现行法律的权威性解释。它们不能替代对相关政策、法律和法规的审查与遵循。

此外，还必须考虑各自产品的具体特性及其各种潜在应用场景。所有用户均自行承担风险。VDA、VDMA 及任何参与这些建议开发或应用的个人均不承担任何责任。

如果你发现这些建议在应用中存在不准确之处，或存在可能导致误解的风险，请立即通知 VDA，以便进行必要的更正。

**发布方**  
德国汽车工业协会（Verband der Automobilindustrie e. V., VDA）  
Behrenstraße 35, 10117 Berlin,  
Germany  
www.vda.de

**版权**  
德国汽车工业协会（VDA）  
仅在注明来源的情况下，方可复制或以其他形式转载。

版本 3.0.0


# 0 前言

本接口规范由德国汽车工业协会（VDA）与德国机械设备制造业联合会（VDMA）联合制定。  
VDA 代表德国汽车产业，包括 OEM 和 Tier‑1/Tier‑n 供应商，并在车辆架构、系统集成和安全关键通信方面贡献其专业知识。  
VDMA 代表欧洲机械与设备工程行业的企业，在自动化技术、机械互操作性和生产系统标准化方面具有广泛经验。

双方共同协作，以确保该接口规范能够反映当前工程需求，支持稳健且可扩展的系统集成，并在异构环境中实现一致的数据交换。其联合开发过程强调通信模型的协调一致、与成熟工业标准的兼容性，以及跨领域接口的长期可维护性。这种合作确保最终规范能够在汽车、机械及混合行业应用中可靠实施，支撑高互操作性、运行安全性和面向未来的系统架构。

卡尔斯鲁厄理工学院（KIT）物料搬运与物流研究所（IFL）隶属于机械工程学院，专注于结合科研、教学和工业应用。其跨学科团队致力于研究未来物流挑战，包括物流流分析、自动化、机器人、数字化、人工智能、可持续性和系统设计。

VDA 与 VDMA 已委托该研究所监督 VDA 5050 的开发。研究所在该过程中负责牵头开发、支持问题评审以及管理官方 GitHub 仓库。

<a id="1-introduction"></a>
# 1 引言

本建议描述了中央车队控制系统与移动机器人之间交换信息的通信接口。

本建议的目标是在集中式车队控制系统监管下，支持移动机器人车队的集成与高效运行。为此，规范定义了一个标准化、厂商中立的通信接口，以确保车队控制系统与各移动机器人之间的互操作性。

不同国家的技术指南与法律框架可以在此背景下提供一般性参考，例如在自动化系统的规划、运行、安全或协调等方面提供指引。此外，国家标准和监管规定也有助于确保技术流程和术语在一致的总体框架下得到考虑。

本建议采用语义化版本控制方案。主版本变更（`x.0.0`）通常包含不兼容变更，例如引入新的非可选字段。次版本变更（`3.x.0`）通常引入新特性，例如新增一个可选的可视化参数。补丁版本变更（`3.0.x`）通常处理较小修正，例如修正文档中的拼写错误。

欢迎相关方提交对该接口的修改或增强建议。此类建议应通过 GitHub 仓库提交：<https://github.com/vda5050/vda5050>。

<a id="2-scope"></a>
# 2 范围

本文档描述了车队控制系统与移动机器人之间一种标准化、厂商中立的通信接口。其目的是提供一个通用参考，以支持在多个移动机器人由车队控制系统协调运行的环境中实现互操作性。该规范的使用是可选且不具约束力的，是否采用由相关方自行决定。

本规范的目标包括：

- 降低移动机器人接入车队控制系统时的复杂度。
- 支持不同制造商的异构移动机器人车队在共享物理环境中的协同运行。
- 提供一组通用、领域无关的接口定义，适用于导航原理、物理尺寸、载荷处理或操作能力以及自主等级各不相同的移动机器人。

本规范不涉及以下主题：

- 安全要求：本文档不定义功能安全、运行安全或系统安全要求，也不应被视为或应用为安全标准。
- 交通管理逻辑：不包括交通协调的策略、算法或决策过程，例如路径规划、优先级、拥堵处理或死锁消解。
- 其他通信接口：不属于车队控制系统与移动机器人之间通信的接口不在范围内，例如与外围设备、基础设施组件或外部 IT 系统的接口。
- 项目协调与实施流程：不涵盖项目管理活动、集成方法、调试上线工作流、验证与验收流程，以及类似的组织性过程。
- 运行职责划分：本文档不对运营方、系统集成商、车辆制造商或车队控制系统提供方在规划、运行、维护或安全方面的职责进行分配。
- 网络安全措施：不规定安全通信或数据保护的机制、技术或流程。

<a id="3-definitions"></a>
# 3 定义

以下术语和定义适用于本文档。对于尚未由标准化组织正式定义的术语，在其他语境中可能存在不同解释。

<a id="31-mobile-robot"></a>
## 3.1 移动机器人

一种主要用于运营场景中的无人驾驶物料运输系统，由自动化系统控制，与其自主等级无关。[来源：ISO 3691-4]

<a id="32-moving"></a>
## 3.2 移动

移动机器人或其任一组成部分在空间位置或朝向上发生变化的状态，包括车轮、载荷处理装置或机器人本体的运动。

<a id="33-driving"></a>
## 3.3 行驶

移动机器人具有非零平移速度和/或旋转速度的运行状态。

<a id="34-automatic-driving"></a>
## 3.4 自动行驶

移动机器人在无人干预的情况下运行的行驶状态。

<a id="35-manual-driving"></a>
## 3.5 手动行驶

移动机器人在人工直接控制下运行的行驶状态。

<a id="36-line-guided-mobile-robot"></a>
## 3.6 线路引导型移动机器人

沿预定义轨迹运动的移动机器人。预定义轨迹可以由车队控制系统作为订单的一部分发送，也可以定义在机器人上，形式可以是显式的，也可以是节点之间的直接连接这种隐式形式。

<a id="37-freely-navigating-mobile-robot"></a>
## 3.7 自由导航型移动机器人

自行规划轨迹的移动机器人。如果车队控制系统在订单中发送了一条轨迹，机器人应遵循该轨迹。

<a id="4-transport-protocol"></a>
# 4 传输协议

通信预计通过无线网络进行，因此需要考虑连接故障和消息丢失的影响。

消息协议采用消息队列遥测传输协议（MQTT），并结合 JSON 格式使用。  
兼容性要求的最低 MQTT 版本为 `3.1.1`。  
MQTT 支持将消息分发到不同 Topic。
MQTT 网络中的参与方订阅这些 Topic，并接收与其相关的信息。

JSON 格式支持未来在协议中扩展附加参数，并可结合 JSON Schema 进行校验。

<a id="41-connection-handling-security-and-qos"></a>
### 4.1 连接处理、安全与 QoS

MQTT 协议允许为客户端设置遗嘱消息（Last Will）。

如果客户端因任何原因意外断开连接，broker 会将该遗嘱消息分发给其他已订阅的客户端。  
本特性的使用方式见 [6.5 连接](#65-connection)。

如果移动机器人与 broker 断开连接，它会保留全部订单信息，并将订单执行到最后一个已释放节点为止。

为降低通信开销，Topic `order`、`instantActions`、`state`、`factsheet`、`zoneSet`、`responses` 和 `visualization` 应使用 MQTT QoS 0（Best Effort）。Topic `connection` 应使用 QoS 1（At Least Once）。

协议安全性需要通过 broker 配置加以考虑，但不在本指南中展开规定。

<a id="42-topic-levels"></a>
### 4.2 Topic 层级

由于云服务提供商通常对 Topic 结构有强制要求，因此 MQTT Topic 结构并未被严格限定。

对于基于云的 MQTT broker，Topic 结构可能需要针对具体平台单独调整，但总体上应尽量遵循本文提出的结构。以下章节定义的 Topic 名称是强制性的。

对于本地 broker，建议的 MQTT Topic 层级如下：

**interfaceName/majorVersion/manufacturer/serialNumber/topic**

示例：
```text
vda5050/v3/KIT/0001/order
```

MQTT Topic 层级 | 数据类型 | 描述
---|---|---
interfaceName | string | 所使用接口的名称
majorVersion | string | VDA 5050 建议的主版本号，前缀为 `"v"`
manufacturer | string | 移动机器人的制造商
serialNumber | string | 移动机器人唯一序列号，可包含如下字符：<br>A-Z <br>a-z <br>0-9 <br>_ <br>. <br>: <br>-
topic | string | Topic（例如 `order` 或 `state`），见 [4.3 通信用 Topic](#43-topics-for-communication)

>表 1 建议的 MQTT Topic 层级说明

由于字符 `/` 用于定义 Topic 层级，因此不得在上述任何字段中使用。通配符字符 `+` 和 `#`，以及保留给 broker 内部 Topic 的字符 `$` 也不应使用。

<a id="43-topics-for-communication"></a>
### 4.3 通信用 Topic

该协议使用以下 Topic 在车队控制系统与移动机器人之间交换信息。

Topic 名称 | 发布方 | 订阅方 | 用途 | 实现要求 | Schema
---|---|---|---|---|---
order | 车队控制系统 | 移动机器人 | 订单通信 | 必选 | order.schema
instantActions | 车队控制系统 | 移动机器人 | 通知需要立即执行的动作 | 必选 | instantActions.schema
state | 移动机器人 | 车队控制系统 | 移动机器人状态通信 | 必选 | state.schema
visualization | 移动机器人 | 可视化系统 | 高频位置与规划路径通信 | 可选 | visualization.schema
connection | broker / 移动机器人 | 车队控制系统 | 指示移动机器人连接何时丢失。不得由车队控制系统用作健康检查，仅用于 MQTT 协议层连接检查 | 必选 | connection.schema
factsheet | 移动机器人 | 车队控制系统 | 参数或厂商特定信息，用于辅助在车队控制系统中完成移动机器人配置 | 必选 | factsheet.schema
zoneSet | 车队控制系统 | 移动机器人 | 将区域集从车队控制系统传输到移动机器人 | 可选 | zoneSet.schema
responses | 车队控制系统 | 移动机器人 | 对移动机器人 `state` 中请求的响应 | 可选 | responses.schema

>表 2 车队控制系统与移动机器人之间的通信 Topic

<a id="5-process-and-content-of-communication"></a>
# 5 通信流程与内容

<a id="51-general"></a>
## 5.1 概述

无人驾驶运输系统（DTS）的运行至少涉及以下参与方：

- DTS 运营方提供基础信息。
- 车队控制系统组织并管理运行。
- 移动机器人执行订单。

图 1 描述了运行阶段中的通信内容。  
在实施或修改阶段，移动机器人与车队控制系统通过人工方式进行配置。

![Figure 1 Structure of the information flow](https://cdn.sxrekord.com/v2/information_flow_VDA5050.png)
>图 1 信息流结构

<a id="52-implementation-phase"></a>
## 5.2 实施阶段

在实施阶段，由车队控制系统和移动机器人组成的 DTS 被建立起来。  
必要的边界条件由运营方定义，所需信息要么由其手动录入，要么通过从其他系统导入并存储到车队控制系统中。

主要包括以下内容：

- 路径定义：  
使用 Layout Interchange Format（LIF）可以将路径导入车队控制系统。LIF 是一种轨道布局文件格式，用于在无人驾驶运输移动机器人的集成商与（第三方）车队控制系统之间交换布局（LIF – Layout Interchange Format, VDMA 2024-03）。  
另外，路径也可由运营方在车队控制系统中手动配置。  
路径可以是单行道、对特定移动机器人组受限（基于尺寸比例）等。
- 路网配置：  
在路径中定义装卸站、电池充电站、外围环境（门、升降机、道闸）、等待位置、缓存站等。
- 移动机器人配置：  
移动机器人的物理属性（尺寸、可用载具接口等）由运营方存储。  
移动机器人应通过 Topic `factsheet` 按本文档 [7.10 参数说明表（`factsheet`）消息实现](#710-implementation-of-the-factsheet-message) 中定义的方式传达此信息。

上述路径和路网配置不属于本文档范围。  
它们构成了车队控制系统基于这些信息以及待完成运输需求来进行订单控制和路径分配的基础。

最终要由机器人车队执行的订单通过 MQTT 传输给各个移动机器人。  
移动机器人在执行订单的同时，也会持续通过 MQTT 向车队控制系统报告其状态。

<a id="53-functions-of-the-fleet-control"></a>
## 5.3 车队控制系统的功能

车队控制系统至少执行以下功能：

- 向移动机器人分配订单
- 线路引导型移动机器人的路径计算与引导（考虑每台移动机器人物理属性的限制，例如尺寸、机动性等）
- 阻塞（“死锁”）检测与消解
- 能源管理：充电订单可以中断运输订单
- 交通控制：缓存路径与等待位置管理
- 环境中的（临时）变化处理，例如开放特定区域或调整最高速度
- 与外围系统通信，例如门、闸门、升降机等
- 通信错误的检测与处理

<a id="54-functions-of-the-mobile-robots"></a>
## 5.4 移动机器人的功能

每个移动机器人应执行以下功能：

- 定位
- 执行对应路径（线路引导或自由导航）
- 执行动作
- 持续传输自身状态

<a id="6-protocol-specification"></a>
# 6 协议规范

以下章节描述通信协议的详细内容。  
该协议规定了车队控制系统与移动机器人之间的通信方式。

<a id="61-order"></a>
## 6.1 订单

Topic `order` 是移动机器人接收订单的 MQTT Topic，其中包含机器人移动或执行动作的指令。

<a id="611-concept-and-logic"></a>
### 6.1.1 概念与逻辑

运输订单的核心是一个定义待行驶路径的节点-边图段。  
移动机器人应遍历这些节点和边来完成订单。

由所有相连节点和边构成的完整图保存在车队控制系统中。该图可能包含限制，例如哪台移动机器人允许通过哪条边。  
这些限制不会传递给移动机器人。  
车队控制系统只会在订单中包含该移动机器人允许通过的边。

![Figure 2 Graph representation in fleet control and graph transmitted in orders](https://cdn.sxrekord.com/v2/graph_representation_transmission.png)
>图 2 车队控制系统中的图表示以及订单中传输的图

节点和边通过订单消息中的两个列表传递。  
这两个列表中节点和边的顺序，也决定了它们应被遍历的顺序。`sequenceId` 在节点和边之间共享，用于定义遍历序列。第一个节点的 `sequenceId` 为 `0`，第一条边为 `1`，第二个节点为 `2`，依此类推。`sequenceId` 为 `n` 的边连接 `sequenceId` 为 `n-1` 和 `n+1` 的节点。`sequenceId` 在同一个订单中应连续。

一个有效订单至少应包含一个节点，并且边的数量应等于节点数量减一。

订单的第一个节点（`sequenceId = 0`）对移动机器人而言应当是可直接到达的，并且始终处于已释放状态。
这意味着移动机器人要么已经位于该节点上，要么处于该节点的偏差容许范围内。  
因此，第一个节点不应出现在 `nodeStates` 中。

节点和边都具有布尔属性 `released`。  
如果某个节点或边已释放，则表示移动机器人应遍历它。  
如果某个节点或边未释放，则移动机器人不得遍历它。

只有当一条边的起点和终点节点都已释放时，该边才能被释放。

在未释放边之后，序列中不得再出现任何已释放的节点或边。

已释放的节点和边集合称为“已释放段（Base）”。
未释放的节点和边集合称为“前瞻段（Horizon）”。

发送不包含前瞻段（Horizon）的订单也是有效的。

一个 `order` 消息不一定描述完整运输订单。  
出于交通控制和适应资源受限移动机器人的需要，完整运输订单（可能包含大量节点和边）可以被拆分成多个子订单，这些子订单通过 `orderId` 与 `orderUpdateId` 关联。  
订单更新流程将在下一节描述。

<a id="612-orders-and-order-update"></a>
### 6.1.2 订单与订单更新

为了支持交通管理，车队控制系统可以将通过订单传达的路径拆分为两部分：

- **已释放段（Base）**：这是移动机器人当前被允许行驶的已定义路径。该路径中的所有节点和边都已由车队控制系统释放给移动机器人。已释放段的最后一个节点称为决策点（decision point）。
- **前瞻段（Horizon）**：这是车队控制系统当前为移动机器人在决策点之后规划的路径。前瞻段尚未被车队控制系统释放。

如果没有进一步的节点和边被加入已释放段，移动机器人应在决策点停止。为了保证运行连续性，如果交通情况允许，车队控制系统应在移动机器人到达决策点之前扩展已释放段。

由于 MQTT 是异步协议，且无线网络传输并不可靠，因此已释放段不能被更改。
因此，车队控制系统应假定已释放段已经被移动机器人执行。
后文会描述取消订单的过程，但考虑到上述通信限制，该过程同样被视为不可靠。

车队控制系统可以通过向移动机器人发送包含更新后节点和边列表的新路径，来修改前瞻段。
前瞻段的变更过程见图 3。

![Figure 3 Procedure for changing the driving route "Horizon"](https://cdn.sxrekord.com/v2/driving_route_horizon.png)
>图 3 扩展行驶路径“前瞻段（Horizon）”的流程

在图 3 中，车队控制系统首先在 `t = 0` 时发送初始订单。  
图 4 给出了一个可能订单的伪代码。  
为便于阅读，此处省略完整 JSON 示例。

```text
{
	orderId: "1234"
	orderUpdateId:0,
	nodes: [
	 	 f {released: true},
	 	 d {released: true},
	 	 g {released: true},
	 	 b {released: false},
	 	 h {released: false}
	],
	edges: [
		e1 {released: true},
		e3 {released: true},
		e8 {released: false},
		e9 {released: false}
	]
}
```
>图 4 订单伪代码

在后续某个时刻，通过发送订单更新来扩展订单（见图 5 的伪代码）。  
请注意，`orderUpdateId` 已递增，且订单更新的第一个节点对应于前一个订单消息的最后一个已释放节点，即拼接节点（stitching node）。
前一个已释放段中的其他节点和边不会被重新发送。

这可以确保移动机器人能够执行订单更新，即订单更新的第一个节点可以通过执行机器人已知的边到达。

```text
{
	orderId: "1234",
	orderUpdateId: 1,
	nodes: [
		g {released: true},
		b {released: true},
		h {released: true},
		i {released: false}
	],
	edges: [
		e8 {released: true},
		e9 {released: true},
		e10 {released: false}
	]
}
```
>图 5 订单更新伪代码。注意 `orderUpdateId` 已变化。

这也有助于处理订单更新丢失的情况（例如由于无线网络不可靠）。  
移动机器人始终可以检查，已知的最后一个已释放节点是否与新订单更新中的第一个节点具有相同的 `nodeId`（以及 `sequenceId`）。

还请注意，节点 `g` 是唯一被重新发送的已释放节点。
由于已释放段不能更改，因此重新发送节点 `f` 和 `d` 是无效的。

![Figure 6 Regular update process - order extension](https://cdn.sxrekord.com/v2/update_order_extension.png)
>图 6 常规更新流程：订单扩展

图 6 描述了订单应如何被扩展。  
它展示了当前移动机器人可见的信息。  
`orderId` 保持不变，而 `orderUpdateId` 递增。

必须确保决策点内容（图 6 中的节点 `g`）不发生变化。  
这意味着其动作、偏差范围等元数据都必须被重新发送（见图 7 中的 `orderUpdateId` 1）。

若要通过订单更新在移动机器人当前所处节点上释放新的动作供其执行，车队控制系统应先重新发送一次该节点，并带上前一次订单更新中的全部元数据（包括可能已经是 `'FINISHED'` / `'RUNNING'` 的动作）；这些动作不会被移动机器人再次执行。随后，再新增一个包含本次新释放动作的节点。这个新节点可以与决策节点使用相同 `nodeId`，也可以使用不同 `nodeId` 但与决策节点位置相同。该新节点的 `sequenceId` 始终为决策节点 `sequenceId + 2`。

![Figure 7 Order update with additional stitching node.](https://cdn.sxrekord.com/v2/update_order_stitching_node.png)
>图 7 含附加拼接节点的订单更新（例如在决策点执行新动作）

在任意订单更新中，前瞻段都可以被修改，甚至被完全删除；已释放段也可以以不同于先前前瞻段的方式被扩展。

一旦某个 `sequenceId` 被赋给节点并且该节点已释放，那么在后续订单更新中它就不能改变（见图 6）。

图 8 描述了接收订单或订单更新的流程。

![Figure 8 The process of accepting an order or orderUpdate](https://cdn.sxrekord.com/v2/process_order_update.png)
>图 8 接收订单或订单更新的流程

1. **收到的订单是否有效？**  
所有格式和 JSON 数据类型是否正确？
2. **收到的是新订单还是当前订单的更新？**  
收到订单的 `orderId` 是否与移动机器人当前持有订单的 `orderId` 不同？
3. **移动机器人是否处于空闲且未等待更新？**  
移动机器人是否处于 [6.6.8 移动机器人的空闲状态](#668-idle-state-of-the-mobile-robot) 所定义的空闲状态，且当前未等待更新？由于订单前瞻段中的节点、边和对应动作状态也会包含在 `state` 中，因此移动机器人可能仍带有前瞻段，从而处于等待更新并执行订单的状态。
4. **`OrderUpdateId` 是否为 0？**  
新订单的 `orderUpdateId` 是否为 `0`？
5. **新订单起点是否足够接近当前位置？**  
移动机器人是否已经在该节点上，或处于该节点的偏差容许范围内（见 [6.1.1 概念与逻辑](#611-concept-and-logic)）？
6. **收到的订单更新是否已过时？**  
其 `orderUpdateId` 是否小于或等于移动机器人当前持有的值？
7. **该订单更新是否出现在 `cancelOrder` 之后？**  
车队控制系统不得再发送已取消订单的后续更新，移动机器人也不得接受。
8. **收到的订单更新是否对应移动机器人当前订单？**  
其 `orderUpdateId` 是否等于移动机器人当前持有的值？
9. **该更新是否是当前仍在运行订单的有效延续？**  
收到订单的第一个节点是否为订单更新章节所述的当前决策点？此时移动机器人仍在移动，或仍在执行之前订单更新中已释放段对应的动作，或仍带有前瞻段并等待订单延续。在这种情况下，只有当新已释放段的第一个节点等于前一个已释放段的最后一个节点时，该订单更新才应被接受。
10. **该更新是否是先前已完成订单的有效延续？**  
收到订单的第一个节点是否为订单更新章节所述的当前决策点？此时移动机器人不再执行任何动作，且不再等待订单延续（即其已完成已释放段及相关动作，且没有前瞻段）。在这种情况下，只有当新已释放段的第一个节点等于前一个已释放段的最后一个节点时，该订单更新才应被接受。
11. **向 `actionStates` / `nodeStates` / `edgeStates` 填充或追加** 新状态。

<a id="61121-finishing-an-order"></a>
#### 6.1.2.1 完成订单

当移动机器人通过了订单的最后一个节点，并完成与该订单相关的所有运动和动作后，它即处于空闲状态，并应准备好接收新订单（见 [6.6.8 移动机器人的空闲状态](#668-idle-state-of-the-mobile-robot)）。

<a id="613-order-cancellation"></a>
### 6.1.3 订单取消

车队控制系统可以通过即时动作 `cancelOrder` 取消一个活动订单。

车队控制系统可以选择传入一个 `orderId`，用以指定要取消的订单。  
收到即时动作 `cancelOrder` 后，移动机器人应尽快尝试停止。  
对于线路引导型移动机器人，这可能意味着在下一个可行节点停止。自由导航型移动机器人则应尽快停止，而不应仅在下一个节点停止。

如果 `actionStates` 中存在已调度动作，这些动作应被取消，并在其 `actionState` 中报告为 `'FAILED'`。  
如果 `actionStates` 中存在正在运行的动作，这些动作也应被取消，并同样报告为 `'FAILED'`。  
如果某个动作无法取消，则在其运行期间，该动作的 `actionState` 应报告为 `'RUNNING'`，之后再报告其实际结束状态（成功则 `'FINISHED'`，失败则 `'FAILED'`）。

只要 `actionStates` 中仍有动作在运行，`cancelOrder` 动作就应报告为 `'RUNNING'`，直到所有动作都被取消或完成。  
不可取消的动作（`cancelAllowed = false`）应执行至完成。

当移动机器人所有运动都已停止，且 `actionStates` 中所有动作也都已停止后，`cancelOrder` 的动作状态应报告为 `'FINISHED'`。  
此后，移动机器人应处于空闲状态，并准备接收新订单。

`orderId` 与 `orderUpdateId` 保持不变。

图 9 展示了不同移动机器人能力下的预期行为。

![Figure 9 Expected behavior after a cancelOrder](https://cdn.sxrekord.com/v2/process_cancel_order.png)
>图 9 `cancelOrder` 后的预期行为

<a id="6131-receiving-a-new-order-after-cancellation"></a>
#### 6.1.3.1 取消后接收新订单

订单取消后，移动机器人处于空闲状态，并应准备好接收新订单。  
车队控制系统不得再向已取消订单发送后续订单更新。  
如果移动机器人收到此类订单更新，应报告错误类型 `'ORDER_UPDATE_FOLLOWING_CANCEL'`，错误级别为 `'WARNING'`。

对于只能在节点上定位自身的移动机器人，新订单应从移动机器人当前所在节点开始（另见图 4）。

对于可以在节点之间停下的移动机器人，车队控制系统可以决定下一张订单如何开始。  
移动机器人应接受以下两种方式：

- 新订单的第一个节点是一个临时节点，位置设为移动机器人当前位置。此时移动机器人应识别该节点为可直接到达，并接受该订单。
- 新订单的第一个节点是上一订单最后通过的节点。该节点的允许偏差范围设置得足够大，以确保移动机器人位于该范围内。因此，移动机器人应立即将该节点视为已通过，并接受该订单。

<a id="6132-receiving-a-cancelorder-action-when-mobile-robot-is-idle"></a>
#### 6.1.3.2 移动机器人空闲时收到 `cancelOrder`

如果移动机器人收到 `cancelOrder` 即时动作，但其当前处于空闲状态，或者该动作中指定的 `orderId` 与移动机器人当前活动订单的 `orderId` 不匹配，则 `cancelOrder` 动作应报告为 `'FAILED'`。

移动机器人应报告错误类型 `'NO_ORDER_TO_CANCEL'`，错误级别为 `'WARNING'`。  
该 `instantAction` 的 `actionId` 应作为一个 `errorReference` 传递。

<a id="614-order-rejection"></a>
### 6.1.4 订单拒收

订单需要被拒绝的场景有多种。  
这些场景在图 8 中给出，并在下文描述。

<a id="6141-mobile-robot-receives-a-malformed-order"></a>
#### 6.1.4.1 移动机器人收到格式错误的订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'VALIDATION_FAILURE'`，错误级别为 `'WARNING'`。
3. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6142-mobile-robot-receives-an-order-with-optional-fields-it-cannot-use"></a>
#### 6.1.4.2 移动机器人收到包含其无法使用的可选字段的订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'UNSUPPORTED_PARAMETER'`，错误级别为 `'CRITICAL'`，并将有问题的字段作为 `errorReferences`。
3. 在移动机器人接受新的订单之前，该错误应持续报告。

<a id="6143-mobile-robot-receives-an-order-with-actions-it-cannot-perform"></a>
#### 6.1.4.3 移动机器人收到包含其无法执行动作的订单

示例：

- 提升高度高于最大提升高度
- 机器人未安装升降机构却收到提升动作等

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'INVALID_ORDER_ACTION'`，错误级别为 `'WARNING'`，并将有问题的字段作为 `errorReferences`。
3. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6144-mobile-robot-receives-an-order-with-the-same-orderid-but-a-lower-orderupdateid-than-the-current-orderupdateid"></a>
#### 6.1.4.4 移动机器人收到相同 `orderId`、但 `orderUpdateId` 小于当前值的订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应保留缓冲区中的前一个订单。
3. 移动机器人应报告错误类型 `'OUTDATED_ORDER_UPDATE'`，错误级别为 `'WARNING'`。
4. 移动机器人应继续执行前一个订单。
5. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6145-mobile-robot-receives-an-order-with-the-same-orderid-and-same-orderupdateid-as-the-current-orderupdateid"></a>
#### 6.1.4.5 移动机器人收到与当前 `orderUpdateId` 完全相同的订单

示例：

- 车队控制系统尚未收到带有相应 `orderUpdateId` 的 `state` 消息，因此重新发送了该订单。

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应保留缓冲区中的前一个订单。
3. 是否报告错误取决于消息内容：  
如果新订单内容与前一个相同，则移动机器人应忽略新订单。  
如果新订单内容不同，则移动机器人应报告错误类型 `'SAME_ORDER_UPDATE_ID'`，错误级别为 `'WARNING'`。
4. 移动机器人应继续执行前一个订单。
5. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6146-mobile-robot-receives-an-order-with-orderid-different-to-the-orderid-of-an-active-order"></a>
#### 6.1.4.6 移动机器人收到 `orderId` 与当前活动订单不同的新订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人保留缓冲区中的前一个订单。
3. 移动机器人应报告错误类型 `'OTHER_ORDER_ACTIVE'`，错误级别为 `'WARNING'`。
4. 移动机器人应继续执行前一个订单。
5. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6147-mobile-robot-receives-an-order-with-the-start-node-being-out-of-range"></a>
#### 6.1.4.7 移动机器人收到起始节点超出范围的订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'START_NODE_OUT_OF_RANGE'`，错误级别为 `'WARNING'`。
3. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6148-mobile-robot-receives-an-order-with-at-least-one-node-not-being-reachable"></a>
#### 6.1.4.8 移动机器人收到至少包含一个不可达节点的订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'NO_ROUTE_TO_TARGET'`，错误级别为 `'WARNING'`。
3. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="6149-mobile-robot-receives-an-order-while-in-an-operating-mode-that-does-not-allow-new-orders"></a>
#### 6.1.4.9 移动机器人在不允许接收新订单的运行模式下收到订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'MOBILE_ROBOT_NOT_AVAILABLE'`，错误级别为 `'WARNING'`。
3. 在移动机器人进入允许接收新订单的模式之前，该警告应持续报告。

<a id="61410-mobile-robot-receives-an-order-containing-nodes-with-unknown-mapid"></a>
#### 6.1.4.10 移动机器人收到包含未知 `mapId` 节点的订单

处理方式：

1. 移动机器人不得将新订单接收入其内部缓冲区。
2. 移动机器人应报告错误类型 `'UNKNOWN_MAP_ID'`，错误级别为 `'WARNING'`。
3. 在移动机器人接受新的订单之前，该警告应持续报告。

<a id="615-corridors"></a>
### 6.1.5 走廊（Corridors）

可选边属性 `corridor` 用于定义走廊（corridor），允许移动机器人为了避障而偏离边的轨迹，并定义其允许运动的边界范围。

要使用 `corridor` 属性，必须存在一条预定义轨迹，即如果没有 `corridor` 时移动机器人本应遵循的轨迹。该轨迹可以是机器人自身已知且车队控制系统也知晓的轨迹，也可以是订单中发送的轨迹。  
使用 `corridor` 属性的移动机器人，其行为本质上仍属于线路引导型移动机器人的行为，只是被允许为了避障而暂时偏离轨迹。

请注意，订单中传递的走廊默认已对移动机器人释放。  
如果设置了 `releaseRequired` 标志，则移动机器人在使用走廊前应按 [6.6.10 请求使用走廊](#6610-request-use-of-corridors) 的描述向车队控制系统申请批准。

*说明：  
订单中的边定义的是两个节点之间的逻辑连接，而不一定是移动机器人从起始节点行驶到终点节点时实际遵循的轨迹。  
根据移动机器人类型，移动机器人在起点与终点之间采用的轨迹，要么由车队控制系统通过边属性 `trajectory` 定义，要么由机器人自身预定义。  
根据移动机器人的内部状态，最终选择的轨迹可能不同。*

![Figure 10 Edges with corridor attribute.](https://cdn.sxrekord.com/v2/edges_with_corridors.png)
>图 10 带有 `corridor` 属性的边。该属性定义了移动机器人可为避障而偏离其预定义轨迹的左右边界。左图中，运动学中心（kinematic center）定义允许偏差；右图中，移动机器人轮廓（可能再加上载荷扩展轮廓）定义允许偏差，这由参数 `corridorReferencePoint` 指定。

移动机器人被允许自主导航（并偏离原始边轨迹）的区域由左边界和右边界共同定义。  
可选字段 `corridorReferencePoint` 指定应位于该边界内的是移动机器人控制点，还是移动机器人轮廓。

边界的定义方式应保证：移动机器人一旦通过某个节点，就已经处于新的当前边的边界之内。  
如果不希望移动机器人偏离轨迹，车队控制系统不应将走廊边界设置为 0，而应直接不使用 `corridor` 属性。

移动机器人的运动控制软件应持续检查其是否位于定义的边界之内。  
如果不在边界内，则移动机器人应停止，因为其已离开允许的导航空间，并报告错误类型 `'OUTSIDE_OF_CORRIDOR'`，错误级别为 `'CRITICAL'`。

车队控制系统可以决定是否需要人工干预，或者是否通过取消当前订单并向移动机器人发送一个带有允许再次运动的走廊信息的新订单，让其继续运行。

*说明：允许移动机器人偏离轨迹，会增加其行驶过程中的潜在占用空间。因此，在初始投运阶段，以及车队控制系统依据移动机器人占用空间做交通控制决策时，都应考虑这一点。*  
更多信息见 [6.6.2 节点与边的通过](#662-traversal-of-nodes-and-edges)。

<a id="62-actions"></a>
## 6.2 动作

如果移动机器人支持除行驶之外的动作，这些动作可以通过附加在订单节点或边上的 `actions` 数组进行下发，也可以通过独立 Topic `instantActions` 发送（见 [6.2.1 即时动作](#621-instant-actions)），还可以通过动作区域（见 [6.4.1 区域类型](#641-zone-types)）进行配置。

附着在边上的动作仅应在移动机器人位于该边上时执行（见 [6.6.2 节点与边的通过](#662-traversal-of-nodes-and-edges)）。

节点触发的动作可以持续运行到其自然结束，并应具有自终止能力（例如持续五秒的声音信号，或完成取货后结束的取货动作），或者应成对定义（例如 `"activateWarningLights"` 与 `"deactivateWarningLights"`）。

<a id="621-instant-actions"></a>
### 6.2.1 即时动作

在某些情况下，需要向移动机器人发送必须立即执行的动作。  
这可以通过向 Topic `instantActions` 发布 `instantAction` 消息来实现。

这些动作不得与移动机器人当前订单内容冲突（例如，`instantAction` 要求叉臂下降，而订单要求叉臂上升）。

即时动作的相关示例包括：

- 在不改变当前订单任何内容的情况下暂停移动机器人
- 在暂停后恢复订单
- 激活信号（光学、声音等）

当移动机器人收到 `instantAction` 时，应在其状态中的 `instantActionStates` 数组里新增一个相应的 `actionStatus`。  
该 `actionStatus` 应根据动作进度进行更新。  
关于 `actionStatus` 的不同状态转换，也可参见图 11。

即时动作的 `blockingType` 始终为 `'NONE'`。

如果移动机器人收到其无法执行的 `instantAction`，则应报告错误类型 `'INVALID_INSTANT_ACTION'`，错误级别为 `'WARNING'`，并将该 `instantAction` 的 `actionId` 作为 `errorReference`。

<a id="622-action-blocking-types-and-sequence"></a>
### 6.2.2 动作阻塞类型与执行顺序

一个列表中多个动作的顺序，定义了移动机器人执行这些动作的先后顺序。

动作是否可以并行执行，由各自动作的 `blockingType` 决定。  
动作可具有四种不同的阻塞类型，如表 3 所示。

- | 允许并行执行 | 不允许并行执行
---|---|---
允许自动行驶 | NONE | SINGLE
不允许自动行驶 | SOFT | HARD

>表 3 动作阻塞类型与行驶/并行执行关系定义

图 11 描述了移动机器人应如何处理动作的阻塞类型。  
每当移动机器人到达需要执行新动作的位置时（即到达节点、边或动作区域），这些动作应按照 `actions` 数组中的顺序入队。系统随后应持续按图 11 所示方式处理该队列。

如果队列中任一动作的阻塞类型为 `'SOFT'` 或 `'HARD'`，移动机器人应停止自动行驶。  
如果动作的阻塞类型为 `'NONE'` 或 `'SOFT'`，则该动作可被收集起来进行并行执行。

如果需要执行一个阻塞类型为 `'SINGLE'` 或 `'HARD'` 的动作，则所有已收集用于并行执行的动作都应先达到 `'FINISHED'` 或 `'FAILED'` 状态，之后才能启动该动作。

如果队列中不再存在 `'SOFT'` 或 `'HARD'` 类型动作，则移动机器人可以恢复自动行驶。  
处于 `'FINISHED'` 或 `'FAILED'` 状态的动作应从队列中移除。

![Figure 11 Handling multiple actions](https://cdn.sxrekord.com/v2/handling_multiple_actions.png)
>图 11 多动作处理

<a id="623-predefined-actions"></a>
### 6.2.3 预定义动作

本节给出一组预定义动作。如果移动机器人的能力与动作描述相匹配，则应使用这些预定义动作。

如果已定义参数存在合理用法，则应使用这些参数。  
如果成功执行动作还需要额外参数，也可以新增扩展参数。

所有移动机器人都应支持 `cancelOrder`、`startPause` 和 `stopPause`。

如果某个动作无法映射到本节后续定义的任何动作，移动机器人制造商可以定义额外动作，供车队控制系统使用。

<a id="6231-definition-parameters-effects-and-scope"></a>
#### 6.2.3.1 定义、参数、效果与适用范围

动作类型 | 反向动作（counter action） | 描述 | 幂等（idempotent） | 参数 | 关联状态（linked state） | 即时 | 节点 | 边 | 区域
---|---|---|---|---|---|---|---|---|---
startPause | stopPause | 激活暂停模式。<br>之所以需要关联状态，是因为许多移动机器人可以通过硬件开关进入暂停。<br>此时不再自动行驶，不要求必须到达下一个节点。可暂停的动作（`pauseAllowed`=`true`）应被暂停，其他动作继续。收到 `stopPause` 后恢复订单执行。 | 是 | - | paused | 是 | 否 | 否 | 否
stopPause | startPause | 解除暂停模式。<br>移动及其他动作（如有）将恢复执行。<br>之所以需要关联状态，是因为许多移动机器人可以通过硬件开关进入暂停。<br>`stopPause` 也可以用于重新启动那些由于触发 `startPause` 的硬件按钮而停止的移动机器人（若已配置）。 | 是 | - | paused | 是 | 否 | 否 | 否
startHibernation | stopHibernation | 进入休眠模式。在该模式下，移动机器人应保持与 MQTT broker 的连接，但不再需要发送状态消息。移动机器人应在停止发布状态消息之前，将该动作报告为 `'FINISHED'`，并发布连接状态 `'HIBERNATING'`。如果移动机器人当前有活动订单，应将其清除。无需到达下一个节点。<br>当连接状态为 `'HIBERNATING'` 时，移动机器人不得运动。其只能接收并响应即时动作 `stopHibernation`，不应响应其他命令，例如订单或其他即时动作。<br>若在此模式下电池电量降至严重偏低，移动机器人可以自主退出 `'HIBERNATING'` 以报告错误。若设置了唤醒时间，移动机器人可在指定时间自主退出 `'HIBERNATING'` 连接状态，并在恢复正常运行前发布相应的连接状态转换。 | 是 | wakeUpTime (string，可选) | - | 是 | 否 | 否 | 否
stopHibernation | startHibernation | 结束休眠模式。要在移动机器人处于 `'HIBERNATING'` 状态时唤醒它，一个控制设备（车载或外部）应订阅 `instantActions` Topic 并保持与 MQTT broker 的连接。由于移动机器人标准控制设备在休眠期间可能部分关闭，唤醒也可以由一个独立 MQTT 客户端触发（区别于机器人常规通信客户端）。<br>成功后，移动机器人应发布连接状态 `ONLINE`。 | 是 | - | - | 是 | 否 | 否 | 否
shutdown | - | 启动移动机器人的协调关机流程，并与 MQTT broker 断开连接。执行该动作要求移动机器人处于空闲状态。由于连接会终止，因此无法通过 VDA 5050 协议自动重启。<br>如果移动机器人当前处于休眠模式而需要关机，则应先退出休眠（通过 `stopHibernation`），再执行 `shutdown`。 | 是 | - | - | 是 | 否 | 否 | 否
startCharging | stopCharging | 启动充电过程。<br>充电可以在充电位进行（机器人停止时），也可以在充电车道上进行（行驶中）。<br>防止过充由移动机器人负责。 | 是 | - | powerSupply.charging | 是 | 是 | 否 | 否
stopCharging | startCharging | 停止充电过程。<br>充电过程也可能由移动机器人或充电站中断，例如电池已满时。 | 是 | - | powerSupply.charging | 是 | 是 | 否 | 否
initializePosition | - | 使用给定参数重置（覆盖）移动机器人的位姿。 | 是 | x (float64)<br>y (float64)<br>theta (float64)<br>mapId (string)<br>lastNodeId (string) | mobileRobotPosition.x<br>mobileRobotPosition.y<br>mobileRobotPosition.theta<br>mobileRobotPosition.mapId<br>lastNodeId<br>maps | 是 | 是<br>(Elevator) | 否 | 否
enableMap | - | 显式启用先前已下载的地图，使其可用于订单，而无需初始化新位置。 | 是 | mapId (string)<br>mapVersion (string) | maps | 是 | 是 | 否 | 否
downloadMap | - | 触发下载新地图。下载期间动作处于活动状态。错误在移动机器人状态中报告。成功下载、完成可用准备并将地图写入状态后，动作结束。 | 是 | mapId (string)<br>mapVersion (string)<br>mapDownloadLink (string)<br>mapHash (string，可选) | maps | 是 | 否 | 否 | 否
deleteMap | - | 触发从移动机器人内存中移除地图。 | 是 | mapId (string)<br>mapVersion (string) | maps | 是 | 否 | 否 | 否
downloadZoneSet | - | 触发下载区域集。下载期间动作处于活动状态。错误在移动机器人状态中报告。成功下载、完成可用准备并将区域集写入状态后，动作结束。 | 是 | zoneSetId (string)<br>zoneSetDownloadLink (string)<br>zoneSetHash (string，可选) | zoneSets | 是 | 否 | 否 | 否
enableZoneSet | - | 显式启用先前已下载的区域集，使其可用于订单。 | 是 | zoneSetId (string)<br> | zoneSets | 是 | 是 | 否 | 否
deleteZoneSet | - | 触发从移动机器人内存中移除区域集。 | 是 | zoneSetId (string) | zoneSets | 是 | 否 | 否 | 否
clearInstantActions | - | 从移动机器人状态中移除所有已完成或已失败的即时动作。 | 是 | - | instantActionStates | 是 | 是 | 否 | 否
clearZoneActions | - | 从移动机器人状态中移除所有已完成或已失败的区域动作。 | 是 | - | zoneActionStates | 是 | 是 | 否 | 否
stateRequest | - | 请求移动机器人发送一条新的状态消息。 | 是 | - | - | 是 | 否 | 否 | 否
logReport | - | 请求移动机器人生成并存储一份日志报告。 | 是 | reason<br>(string) | - | 是 | 否 | 否 | 否
pick | drop<br><br>（如为自动装卸） | 请求移动机器人取货。<br>若移动机器人具有多个载荷处理装置（load handling device），则可并行处理多个取货操作。<br>此时需要提供参数 `lhd`（例如 `LHD1`）。<br>参数 `stationType` 用于说明取货操作的具体处理方式（例如地面工位、货架工位、被动输送机、主动输送机等）。<br>`loadType` 用于说明载荷单元类型，也可用于例如切换场（如 `EPAL`、`INDU` 等）。<br>为了准备载荷处理装置（例如基于高度参数进行预抬升），该动作可以提前在前瞻段（Horizon）中声明。<br>但这些预抬升操作不会在移动机器人状态中被报告为 `'RUNNING'`，因为对应节点尚未释放。<br>如果动作位于边上，移动机器人可以利用其传感装置检测取货位置。 | 否 | lhd (string，可选)<br>stationType (string，可选)<br>stationName (string，可选)<br>loadType (string，可选)<br>loadId (string，可选)<br>height (float64，可选)<br>定义载荷底部相对地面的高度<br>depth (float64，可选) 适用于叉车<br>side (string，可选) 例如 conveyor | .load | 否 | 是 | 是 | 否
drop | pick<br><br>（如为自动装卸） | 请求移动机器人放货。<br>详见动作 `pick`。 | 否 | lhd (string，可选)<br>stationType (string，可选)<br>stationName (string，可选)<br>loadType (string，可选)<br>loadId (string，可选)<br>height (float64，可选)<br>depth (float64，可选)<br>… | .load | 否 | 是 | 是 | 否
detectObject | - | 移动机器人检测对象（例如载荷、充电位、空闲停车位）。 | 是 | objectType (string，可选) | - | 否 | 是 | 是 | 是
finePositioning | - | 在节点上，移动机器人将精确对准目标位置。<br>此时允许其偏离节点位置。<br>在边上，移动机器人可以在通过边时对准固定设备等。 | 是 | stationType (string，可选)<br>stationName (string，可选) | - | 否 | 是 | 是 | 是
waitForTrigger | - | 移动机器人应等待由参数 `triggerType` 指定类型的触发，该参数为字符串数组。两种预定义值应在语义合适时使用：若触发来自车队控制系统，则使用 `'FLEET_CONTROL'`；若触发来自移动机器人本地输入（例如按钮按下、人工装载），则使用 `'LOCAL'`。如果预定义值均不满足具体需求，可以定义自定义值。<br>超时处理由车队控制系统负责，必要时应取消该订单。 | 是 | triggerType [string] (array) | - | 否 | 是 | 否 | 是
trigger | - | 车队控制系统通知移动机器人某个 `waitForTrigger` 动作已被释放。通常发生在车队控制系统从第三方系统获得信息，表明移动机器人所等待的过程已完成时。 | 是 | - | - | 是 | 否 | 否 | 否
retry | - | 移动机器人重试当前处于 `RETRIABLE` 状态、由 `actionId` 指定的动作。 | 是 | actionId (string) | - | 是 | 否 | 否 | 否
skipRetry | - | 移动机器人应跳过当前处于 `RETRIABLE` 状态、由 `actionId` 指定的动作，并将其设置为 `FAILED`。 | 是 | actionId (string) | - | 是 | 否 | 否 | 否
cancelOrder | - | 移动机器人应尽快停止。这可以是立即停止，也可以是在下一个节点停止。见 [6.1.3 订单取消](#613-order-cancellation)。 | 是 | orderId (string，可选) | - | 是 | 否 | 否 | 否
factsheetRequest | - | 请求移动机器人发送参数说明表（factsheet） | 是 | - | - | 是 | 否 | 否 | 否
updateCertificate | - | 请求移动机器人下载并激活一组新证书。参数 `service` 是可扩展枚举，预定义值 `'MQTT'` 用于 MQTT 连接。 | 是 | service (string)<br>keyDownloadLink (string)<br>certificateDownloadLink (string)<br>certificateAuthorityDownloadLink (string，可选) | - | 是 | 否 | 否 | 否

>表 4 预定义动作及其适用范围（即时、节点、边、区域）

<a id="6232-action-states"></a>
#### 6.2.3.2 动作状态

action type | 'INITIALIZING' | 'RUNNING' | 'PAUSED' | 'FINISHED' | 'FAILED' | 'RETRIABLE'
---|---|---|---|---|---|---
startPause | - | 暂停模式正在准备激活。<br>如果移动机器人支持瞬时切换，则可省略该状态。 | - | 移动机器人未运动。<br>所有可暂停动作已暂停。<br>暂停模式已激活。<br>移动机器人报告 `paused: "true"`。 | 暂停模式由于某种原因无法激活（例如被硬件开关覆盖）。 | -
stopPause | - | 暂停模式正在准备解除。<br>如果移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 暂停模式已解除。<br>所有暂停动作已恢复。<br>移动机器人报告 `paused: "false"`。 | 暂停模式由于某种原因无法解除（例如被硬件开关覆盖）。 | -
startHibernation | - | 休眠模式正在准备激活。若移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 移动机器人未运动。如有活动订单，已被清除。移动机器人不再发送状态消息。<br>休眠模式已激活。移动机器人报告连接状态 `"HIBERNATING"`。 | 无法发布 `'HIBERNATING'` 连接状态（例如被硬件开关覆盖）。 | -
stopHibernation | - | 休眠模式正在准备解除。若移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 休眠模式已解除。<br>移动机器人报告 `connectionState "ONLINE"`。 | 休眠模式无法解除（例如被硬件开关覆盖）。 | -
shutdown | - | `OFFLINE` 连接状态正在准备激活。若移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 移动机器人未运动。移动机器人与 broker 的连接以协调方式终止。<br>移动机器人报告连接状态 `"OFFLINE"`。 | 由于某种原因无法执行关机（例如移动机器人不处于空闲状态，或被硬件开关覆盖）。 | -
startCharging | - | 充电过程正在启动中（与充电器通信进行中）。<br>若移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 充电过程已开始。<br>移动机器人报告 `powerSupply.charging: "true"`。 | 充电过程由于某种原因无法启动（例如未与充电器对齐）。充电问题应对应一个错误。 | 充电过程无法启动。移动机器人正在等待车队控制系统或操作员干预。
stopCharging | - | 充电过程正在停止中（与充电器通信进行中）。<br>若移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 充电过程已停止。<br>移动机器人报告 `powerSupply.charging: "false"`。 | 充电过程由于某种原因无法停止（例如未与充电器对齐）。<br>充电问题应对应一个错误。 | -
initializePosition | - | 新位姿正在初始化（置信度检查等）。<br>若移动机器人支持瞬时切换（instant transition），则可省略该状态。 | - | 位姿已重置。<br>移动机器人报告：<br>`mobileRobotPosition.x = x`<br>`mobileRobotPosition.y = y`<br>`mobileRobotPosition.theta = theta`<br>`mobileRobotPosition.mapId = mapId`<br>`mobileRobotPosition.lastNodeId = lastNodeId` | 位姿无效或无法重置。<br>通用定位问题应对应一个错误。 | -
downloadMap | 初始化到地图服务器的连接。 | 移动机器人正在下载地图。 | - | 下载已完成。移动机器人通过设置 `mapId`/`mapVersion` 及对应 `mapStatus` 为 `'DISABLED'` 来更新其状态。 | 下载失败，相关信息更新在移动机器人状态中（例如连接丢失、地图服务器不可达、地图服务器上不存在对应 `mapId`/`mapVersion`）。 | 下载失败或中断。移动机器人正在等待车队控制系统干预。
enableMap | - | 移动机器人启用请求的 `mapId` 和 `mapVersion` 对应地图，并禁用其他具有相同 `mapId` 的地图版本。 | - | 地图已启用。移动机器人将请求地图的 `mapStatus` 更新为 `'ENABLED'`，并将相同 `mapId` 的其他版本设为 `'DISABLED'`。 | 请求的 `mapId`/`mapVersion` 组合不存在。 | -
deleteMap | - | 移动机器人从其内部内存中删除请求的 `mapId` 和 `mapVersion` 对应地图。 | - | 地图已删除。移动机器人从其状态中移除该 `mapId`/`mapVersion`。 | 地图无法删除，例如地图当前正在使用，或请求的 `mapId`/`mapVersion` 组合此前已被删除。 | -
downloadZoneSet | 初始化到区域集服务器（zone set server）的连接。 | 移动机器人正在下载区域集。 | - | 下载已完成。移动机器人在其状态中新增相应 `zoneSet` 对象，并将 `zoneSetStatus` 设为 `'DISABLED'`。 | 下载失败，相关信息更新在移动机器人状态中（例如连接丢失、服务器不可达、区域集不存在、同名 `zoneSetId` 的区域集已存在于机器人上）。 | 下载失败或中断。移动机器人正在等待车队控制系统干预。
enableZoneSet | - | 移动机器人启用请求的 `zoneSetId`，并禁用同一 `mapId` 下的其他区域集。 | - | 区域集已启用。移动机器人将请求区域集的 `zoneSetStatus` 更新为 `'ENABLED'`，并将同一 `mapId` 的其他区域集设为 `'DISABLED'`。 | 请求的区域集不存在。 | -
deleteZoneSet | - | 移动机器人从其内部内存中删除请求的 `zoneSetId` 对应区域集。 | - | 区域集已删除。移动机器人从其状态中移除对应 `zoneSet` 对象。 | 区域集无法删除，例如当前正在使用，或请求的区域集此前已被删除。 | -
clearInstantActions | - |  | - | `instantActions` 数组中所有 `'FINISHED'` 或 `'FAILED'` 的即时动作已被清理。 | - | -
clearZoneActions | - |  | - | `zoneActions` 数组中所有 `'FINISHED'` 或 `'FAILED'` 的区域动作已被清理。 | - | -
stateRequest | - | - | - | 状态已发送。 | - | -
logReport | - | 报告正在生成。<br>若移动机器人支持瞬时生成，则可省略该状态。 | - | 报告已被存储。<br>日志名称作为动作状态的一部分进行报告。 | 报告无法存储（例如空间不足）。 | -
pick | 取货过程初始化中，例如仍有待完成的抬升动作。 | 取货过程正在运行（移动机器人正在驶入工位、载荷处理装置忙碌、与工位通信中等）。 | 取货过程被暂停，例如安全保护区被触发。<br>解除后，取货过程继续。 | 取货完成。<br>载荷已进入移动机器人，机器人报告新的载荷状态。 | 取货失败，例如工位意外为空。<br>失败的取货操作应对应一个错误。 | 取货失败，但可重试。移动机器人正在等待车队控制系统或操作员干预。
drop | 放货过程初始化中，例如仍有待完成的抬升动作。 | 放货过程正在运行（移动机器人正在驶入工位、载荷处理装置忙碌、与工位通信中等）。 | 放货过程被暂停，例如安全保护区被触发。<br>解除后，放货过程继续。 | 放货完成。<br>载荷已离开移动机器人，机器人报告新的载荷状态。 | 放货失败，例如工位意外被占用。<br>失败的放货操作应对应一个错误。 | 放货失败，但可重试。移动机器人正在等待车队控制系统或操作员干预。
detectObject | - | 对象检测正在进行。 | - | 对象已被检测到。 | 无法检测到对象。 | 对象检测失败，但可重试。移动机器人正在等待车队控制系统或操作员干预。
finePositioning | - | 移动机器人正在精确对准目标。 | 精定位过程被暂停，例如安全保护区被触发。<br>例如在故障解除后，精定位继续。 | 已到达相对于工位的目标位置。 | 无法到达相对于工位的目标位置。 | 精定位失败，但可重试。移动机器人正在等待车队控制系统或操作员干预。
waitForTrigger | - | 移动机器人正在等待触发。 | - | 已收到触发。 | 若订单被取消，则 `waitForTrigger` 失败。 | -
cancelOrder | - | 移动机器人正在停止，或继续行驶直到到达下一个节点。 | - | 移动机器人未运动。移动机器人已取消订单执行并处于空闲状态。 | <br>移动机器人没有活动订单。<br>前一个订单已被取消。<br>传入的 `orderId` 与当前活动订单的 `orderId` 不匹配。 | -
factsheetRequest | - | - | - | 参数说明表（factsheet）已发送。 | - | -
updateCertificate | - | 移动机器人正在下载并安装证书。 | - | 证书已下载、安装并处于激活状态。 | 下载或安装失败。 | -

>表 5 预定义动作在各动作状态下的预期行为

<a id="6233-update-mobile-robot-certificate"></a>
#### 6.2.3.3 更新移动机器人证书

出于安全考虑，移动机器人的通信（至少是与车队管理相关的通信）应受到保护。  
通常，与 MQTT broker 的通信通过 TLS 进行保护，这要求存在一个或多个根证书以及一对移动机器人专用密钥。

参数 `service` 指定证书将被用于的服务（例如 `'MQTT'`）。  
参数 `certificateAuthorityDownloadLink` 指定根证书的 URL。  
参数 `certificateDownloadLink` 和 `keyDownloadLink` 分别指定移动机器人专用公钥和私钥的 URL。

下载过程本身也应通过 TLS 保护，因为即时动作的发送方无法被验证。  
在激活证书之前，也建议先验证证书链。

<a id="63-maps"></a>
## 6.3 地图

为了确保不同类型移动机器人之间的导航一致性，位置始终以项目特定坐标系为参照进行指定（见图 12）。项目特定坐标系是指为车队控制系统与移动机器人之间交互所定义的坐标系。

为区分场地或位置中的不同楼层，使用唯一的 `mapId`。  
地图坐标系应定义为右手坐标系，`z` 轴朝上。  
因此，正方向旋转应理解为逆时针旋转。

移动机器人坐标系同样规定为右手坐标系（ISO 9787 4.1），其中 `x` 轴指向移动机器人前进方向，`z` 轴指向上方（ISO 9787 5.5）。  
除非另有规定，移动机器人参考点在其自身坐标系中定义为 `(0,0,0)`。

![Figure 12 Coordinate system with sample mobile robot and orientation](https://cdn.sxrekord.com/v2/coordinate_system_vehicle_orientation.png)
>图 12 带示例移动机器人及朝向的坐标系

`X`、`Y` 和 `Z` 坐标应以米为单位给出。  
朝向应以弧度表示，并位于 `-Pi` 到 `+Pi` 范围内。

<a id="631-map-distribution"></a>
### 6.3.1 地图分发

为了实现自动地图分发，并在必要时智能管理移动机器人的重启，车队控制系统可以管理移动机器人上的地图。

待分发的地图文件存储在移动机器人可访问的专用地图服务器（map server）上。为了保证高效传输，每次传输应尽量只包含单个文件。如果需要多个地图或多个文件，应将其打包为单个文件。
将地图从地图服务器传输到移动机器人采用拉取方式，由车队控制系统通过触发一个 `instantAction` 下载命令来发起。

每张地图由地图标识符（字段 `mapId`）与地图版本（字段 `mapVersion`）的组合唯一标识。  
地图标识符描述移动机器人物理工作空间中的一个特定区域，地图版本则表示对该区域地图的更新版本。

在接受新订单之前，移动机器人应检查：订单中涉及的每个地图标识符，机器人本地是否都存在相应地图。  
如果可用地图列表中缺少对应 `mapId`，移动机器人应报告错误类型 `'UNKNOWN_MAP_ID'`，错误级别为 `'WARNING'`。  
确保移动机器人启用了正确地图，是车队控制系统的责任。

为了尽量减少停机时间，并让车队控制系统更容易同步启用新地图的过程，地图应预先下载或缓存在移动机器人上。  
移动机器人上地图的状态会反映在其状态消息中。  
将地图传输到移动机器人与启用地图是两个不同过程。若要启用一张预加载地图，车队控制系统应发送一个即时动作。作为结果，具有相同地图标识符但不同地图版本的其他地图应由移动机器人禁用。

地图删除也可以由车队控制系统通过即时动作执行。

地图分发过程见图 13。

![Figure 13 Map distribution process](https://cdn.sxrekord.com/v2/map_distribution_process.png)
>图 13 下载、启用和删除地图时，车队控制系统、移动机器人与地图服务器之间所需的通信

<a id="632-maps-in-the-mobile-robot-state"></a>
### 6.3.2 移动机器人状态中的地图

状态中的 `mobileRobotPosition.mapId` 字段表示当前处于活动状态的地图。

关于移动机器人可用地图的信息通过状态消息中的 `maps` 数组给出。  
该数组中的每个条目都是一个 JSON 对象，包含必填字段 `mapId`、`mapVersion` 和 `mapStatus`；其中 `mapStatus` 只能是 `'ENABLED'` 或 `'DISABLED'`。

`'ENABLED'` 地图表示该地图当前可被移动机器人使用。  
`'DISABLED'` 地图表示该地图不得被使用。  
下载过程状态由当前动作是否完成来体现，相关错误也会在状态中报告。

请注意，不同 `mapId` 的多张地图可以同时被启用。  
但对同一个 `mapId` 来说，同一时刻只能有一个版本被启用。  
如果 `maps` 数组为空，则表示当前移动机器人上没有可用地图。

<a id="633-map-download"></a>
### 6.3.3 地图下载

地图下载应由车队控制系统通过即时动作 `downloadMap` 触发。  
该动作应至少包含必填参数 `mapId` 和 `mapDownloadLink`，后者指定地图在地图服务器上的存放位置，并且移动机器人可访问。

移动机器人一旦开始下载地图文件，就应将 `actionStatus` 设为 `'RUNNING'`。  
如果下载成功，`actionStatus` 更新为 `'FINISHED'`；如果下载失败，则设为 `'FAILED'`。  
下载成功完成后，该地图应被加入状态中的 `maps` 数组。地图在尚未准备好被启用之前，不得出现在状态中。

地图下载过程不得修改、删除、启用或禁用移动机器人上现有的任何地图。

如果请求下载的 `mapId` 与 `mapVersion` 组合已经存在于移动机器人上，则移动机器人应拒绝此次下载。  
此时应报告错误类型 `'DUPLICATE_MAP'`，错误级别为 `'WARNING'`，并将该即时动作状态设为 `'FAILED'`。  
车队控制系统应先删除机器人上的该地图，然后再重新发起下载。

<a id="634-enable-downloaded-maps"></a>
### 6.3.4 启用已下载地图

在移动机器人上启用地图有两种方式：

1. **由车队控制系统启用地图**：使用即时动作 `enableMap`，将某张地图在移动机器人上设置为 `'ENABLED'`。同一 `mapId` 下、不同 `mapVersion` 的其他版本会被设置为 `'DISABLED'`。
2. **在移动机器人上手动启用地图**：在某些情况下，可能需要直接在移动机器人本体上启用地图。其结果应报告在移动机器人状态中。

当车队控制系统在订单的 `nodePosition` 中发送相应 `mapId` 时，应确保移动机器人上已启用正确的地图。  
如果需要将移动机器人设置到新地图上的特定位置，应使用即时动作 `initializePosition`。

<a id="635-delete-maps-on-the-mobile-robot"></a>
### 6.3.5 删除移动机器人上的地图

车队控制系统可以请求从移动机器人中删除某个特定地图。  
该操作应通过即时动作 `deleteMap` 完成。

当移动机器人内存不足时，它应向车队控制系统报告，由后者触发地图删除。  
移动机器人自身不应主动删除地图。

成功删除地图后，移动机器人应从状态消息中的 `maps` 数组移除对应条目。

<a id="64-zones"></a>
## 6.4 区域

区域用于为移动机器人工作空间中的特定区域定义规则。通过这种方式，区域既允许移动机器人在节点之间自由导航，又使车队控制系统具备交通管理能力。

区域可用于局部禁止移动机器人进入某些区域，或将进入权限与特定条件绑定（区域类型：`'BLOCKED'` 和 `'RELEASE'`）。  
也可以在区域内部强制执行特定行为（区域类型：`'LINE_GUIDED'`、`'SPEED_LIMIT'`、`'COORDINATED_REPLANNING'` 和 `'ACTION'`）；  
或者通过鼓励/惩罚某些区域来影响行驶行为（区域类型：`'PRIORITY'` 和 `'PENALTY'`）；  
还可以规定预定义行驶方向（区域类型：`'DIRECTED'`、`'BIDIRECTED'`）。

各区域类型将在后续章节中定义。

订单中因区域重叠、或区域属性与边属性组合而引起的潜在冲突，以及如何处理这些冲突，见 [6.4.4 区域之间的相互作用](#644-interactions-between-zones)。  
对于属于订单一部分且已释放、但因区域限制而受约束的节点（例如位于 `'BLOCKED'` 或 `'RELEASE'` 区域内的节点），机器人应按照区域规则行动（例如不得进入，或等待请求进入状态为 `'GRANTED'`）。

部分移动机器人可能完全不支持区域处理，另一些移动机器人可能只支持某些区域类型子集，例如仅支持 `'BLOCKED'`。  
因此，所有移动机器人都应通过在其 `factsheet` 中 `typeSpecifications.supportedZones` 数组内加入相应区域名称，向车队控制系统报告自己能够理解哪些区域类型。

即便是（虚拟）线路引导型移动机器人，只要能够实现以下定义的对应区域类型逻辑，也可以选择支持基于区域的导航。

区域集只能由车队控制系统进行更改和分发，以保持系统一致性。

<a id="641-zone-types"></a>
### 6.4.1 区域类型

区域分为两大类：基于轮廓（contour）的区域，以及基于运动学中心（kinematic center）的区域。
这种区分基于移动机器人何时被视为进入或退出区域的不同判定条件。

<a id="6411-contour-based-zones"></a>
#### 6.4.1.1 基于轮廓（contour）的区域

对于基于轮廓（contour）的区域，移动机器人的轮廓（包括其载荷）决定区域进入与退出。
轮廓的任意部分进入区域，即视为进入区域。  
当移动机器人轮廓的任何部分都不再位于区域内时，即视为退出区域。

![Figure 14 Depiction of a mobile robot entering a zone based on its contour (left) and a loaded mobile robot with corresponding extended bounding box exiting a zone (right)](https://cdn.sxrekord.com/v2/contour_entry.png)
>图 14 基于轮廓的区域进入与退出示意：左图为移动机器人进入区域，右图为带载移动机器人及其扩展包围盒退出区域

以下定义了基于轮廓的区域类型：

| **区域类型** | **区域参数** | **数据类型** | **描述** |
| --- | --- | --- | --- |
| BLOCKED | none |  | 移动机器人不得进入该区域。如果移动机器人已经进入该区域，或发现自己位于该区域内，则应停止并抛出错误 `'BLOCKED_ZONE_VIOLATION'`，错误级别为 `'CRITICAL'`。 |
| LINE_GUIDED | none |  | 在该区域内不允许自由导航，移动机器人应沿边上的预定义轨迹行驶。只有当路线以节点-边图形式被车队控制系统明确指定时，移动机器人才允许进入该区域。任何需要进入该区域的运动都应遵循预定义轨迹。进入区域时，移动机器人应处于穿过该区域的边的轨迹上。进入并位于该线路引导区域内的边，必须带有车队控制系统发送的轨迹，或机器人上预定义的轨迹。可以通过发送 `corridor` 允许移动机器人偏离该轨迹。 |
| RELEASE |  | - | 移动机器人只有在获得车队控制系统授权后，才允许进入该区域。 |
|  | releaseLossBehavior | string | Enum {'STOP', 'CONTINUE', 'EVACUATE'}<br>当该区域访问权限被撤销或到期时，移动机器人可选择 `'STOP'`、`'CONTINUE'` 或 `'EVACUATE'`。只有当移动机器人已经在该区域内，而授权到期或被撤销时，才执行这一行为。若未定义，默认应停止并报告错误。<br>`'STOP'`：移动机器人停止，并发送错误 `'RELEASE_LOST'`，错误级别 `'CRITICAL'`。<br>`'EVACUATE'`：执行移动机器人的撤离行为以离开该区域，并在离开区域之前保留其状态中授予访问权限的 `zoneRequest` 对象。<br>`'CONTINUE'`：如果授权在移动机器人已进入该区域后被撤销或到期，则移动机器人继续沿当前路径前进，并在状态中保留授予该区域权限的 `zoneRequest` 对象。如果订单在区域内结束，则移动机器人等待新订单。 |
| COORDINATED_REPLANNING | none |  | 在该区域内不允许自主重规划。移动机器人只有在获得车队控制系统许可后，才允许调整自身路径。 |
| SPEED_LIMIT |  |  | 移动机器人在该区域内行驶速度不得超过定义的最大速度。 |
|  | maximumSpeed | float64 | 区域内移动机器人的最高允许速度，单位 `m/s`。进入该区域时就应已经达到该限速要求。 |
| ACTION |  |  | 移动机器人应在进入、穿越或离开区域时执行预定义动作。参数说明表（factsheet）定义了何时可执行哪些动作。 |
|  | entryActions[action] | array | 进入区域时触发的动作。若无需动作，则为空数组。 |
|  | duringActions[action] | array | 穿越区域期间执行的动作。若无需动作，则为空数组。 |
|  | exitActions[action] | array | 离开区域时触发的动作。若无需动作，则为空数组。 |

>表 6 基于轮廓的区域类型及其参数

<a id="6412-kinematic-center-based-zones"></a>
#### 6.4.1.2 基于运动学中心（kinematic center）的区域

在基于运动学中心（kinematic center）的区域中，移动机器人的运动学中心决定其进入和退出区域。
当移动机器人的运动学中心位于区域内时，移动机器人应遵循该区域定义的行为。

`'PRIORITY'` 和 `'PENALTY'` 区域仅影响移动机器人的路径规划。  
`'DIRECTED'` 区域定义区域内的优选行驶方向。  
`'BIDIRECTED'` 区域定义一个行驶方向及其反方向（`+ Pi`）可被使用，其他方向应避免。  
枚举 `directedLimitation` 和 `bidirectedLimitation` 指定移动机器人允许偏离其行驶方向的限制程度。这里的行驶方向是项目特定坐标系中的速度向量方向。

![Figure 15 Depiction of a mobile robot entering a zone based on its kinematic center (left) and a loaded mobile robot exiting a zone based on its kinematic center (right)](https://cdn.sxrekord.com/v2/kinematic_center_entry.png)
>图 15 基于运动学中心的区域进入与退出示意：左图为移动机器人进入区域，右图为带载移动机器人退出区域

| **区域类型** | **区域参数** | **数据类型** | **描述** |
| --- | --- | --- | --- |
| PRIORITY |  |  | 该区域所覆盖的工作空间会鼓励移动机器人相较于无区域标记的同等空间，优先规划经过该区域的路径。 |
|  | priorityFactor | float64 | [0.0...1.0]<br>表示该区域相对于无区域空间的偏好程度。`0.0` 表示没有偏好，相当于没有该区域；`1.0` 表示最大偏好。 |
| PENALTY |  |  | 该区域所覆盖的工作空间会使移动机器人相较于无区域标记的同等空间，倾向于不选择经过该区域。 |
|  | penaltyFactor | float64 | [0.0...1.0]<br>表示该区域相对于无区域空间的惩罚程度。`0.0` 表示没有惩罚，相当于没有该区域；`1.0` 表示最大惩罚，仅当找不到其他可行路径时，移动机器人才会选择通过此区域。 |
| DIRECTED |  |  | 移动机器人应沿特定方向通过该区域。 |
|  | direction | float64 | 区域内优选行驶方向，单位为弧度。行驶方向是项目特定坐标系中移动机器人速度向量的角度方向。 |
|  | directedLimitation | string | Enum {'SOFT','RESTRICTED','STRICT'}<br>`SOFT`：移动机器人可以偏离定义的行驶方向，但应尽量避免。`RESTRICTED`：移动机器人可以在例如避障时偏离定义方向，但绝不能沿与定义方向相反的方向通过。`STRICT`：移动机器人应在其技术能力允许范围内尽可能精确地保持定义方向。 |
| BIDIRECTED |  |  | 在该区域内，移动机器人只允许沿定义的行驶方向及其正反方向（`+ Pi`）运动，不应以其他方向穿越该区域。 |
|  | direction | float64 | 区域内优选行驶方向，单位为弧度。行驶方向是项目特定坐标系中移动机器人速度向量的角度方向。 |
|  | bidirectedLimitation | string | Enum {'SOFT', 'RESTRICTED'}<br>`SOFT`：移动机器人可以偏离定义的两个行驶方向，但应尽量避免。`RESTRICTED`：除避障外，移动机器人不得沿定义方向及其反方向以外的任何方向通过。 |

>表 7 基于运动学中心的区域类型及其参数

<a id="642-zone-set-transfer"></a>
### 6.4.2 区域集（zone set）传输

区域集（zone set）只能由车队控制系统进行更改和分发，以保持系统一致性。
推荐通过 Topic `zoneSet` 分发区域集。  
如果移动机器人支持区域，则应支持通过 `zoneSet` Topic 进行更新。  
较大的区域集也可以通过即时动作 `downloadZoneSet` 来共享，其流程与图 13 所示地图分发概念一致。

`zoneSet` 是一个 `zone` 对象数组，并带有全局唯一标识 `zoneSetId`。  
它关联到一张由 `mapId` 引用的地图。  
不应引用 `mapVersion`，因为同一个区域集可能用于同一张地图的多个版本。

一般来说，一张地图之上可以定义多个区域集，确保在移动机器人上为每张地图启用正确的区域集，是车队控制系统的责任。  
与地图类似，`zoneSetStatus` 指示当前移动机器人正在使用哪个区域集。  
在移动机器人上，对于每个 `mapId`，同一时刻只能有一个区域集处于活动状态。  
区域不得超出地图的空间边界。

具有唯一 `zoneSetId` 的区域集，其内容不得被修改。  
如果需要对某个区域集进行更改，则应使用新的 `zoneSetId` 重新引用。

新加入区域集的 `zoneSetStatus` 必须始终设置为 `'DISABLED'`，并在使用前通过即时动作 `enableZoneSet` 启用。

如果移动机器人通过 `zoneSet` Topic 或即时动作 `downloadZoneSet` 收到一个与现有区域集具有相同 `zoneSetId` 的新区域集，则不得将其接收入内部存储，并应在足够长的时间内报告错误类型 `'DUPLICATE_ZONE_SET'`、错误级别 `'WARNING'`，以便车队控制系统注意到区域更新失败。

<a id="643-communication-for-interactive-zones"></a>
### 6.4.3 交互式区域的通信

对于交互式区域 `'RELEASE'` 和 `'COORDINATED_REPLANNING'` 的请求通信，使用状态消息中的字段 `zoneRequests`。  
车队控制系统则通过独立 Topic `responses` 对这些请求作出响应。

在进入交互式区域之前，移动机器人应先提出请求。  
即使订单中已经包含位于该区域内的已释放节点，在进入交互式区域之前，仍必须提出请求。  
移动机器人自行决定在进入区域前的哪个时刻发出请求。  
如果未能及时收到响应，移动机器人不得进入该区域。

请求只能针对已启用区域集中的区域发出。  
也可以针对移动机器人当前不在其上的地图所属区域集发出区域请求。

`requestId` 使车队控制系统能够区分不同请求，也允许移动机器人同时针对同一区域发出多个备选请求。  
每次请求尝试都应在单个移动机器人范围内使用唯一标识。移动机器人重启后可以重复使用这些 ID。

对于进入 `'RELEASE'` 区域的请求，应在状态消息中新增一个 `requestType` 为 `'ACCESS'` 的 `zoneRequest` 对象。  
对于请求进入 `'COORDINATED_REPLANNING'` 区域并使用一条规划路径，或请求在该区域内重规划路径，`requestType` 应设为 `'REPLANNING'`。

对于 `'REPLANNING'` 请求，规划路径应以 NURBS 形式添加到 `zoneRequest.trajectory` 字段中。  
对于同一区域，可以同时提出多条不同轨迹的请求。  
每条路径都必须以独立的 `zoneRequest` 对象请求。

如果移动机器人需要进入被两个或更多 `'RELEASE'` 区域覆盖的工作空间，则在进入该区域前，必须为所有相关区域提出访问请求并获得批准。  
如果移动机器人要穿过地图上由两个或更多 `'COORDINATED REPLANNING'` 区域覆盖的工作空间，则应分别针对每个区域单独请求其在该区域内的路径，并在进入或改变路径之前获得车队控制系统批准。

当移动机器人发出请求时，参数 `requestStatus` 的初始值应为 `'REQUESTED'`。

车队控制系统通过 Topic `responses` 对区域请求进行响应。  
响应消息包含一个 `response` 对象数组。每个 `response` 只应响应一个由 `requestId` 标识的请求。  
每个响应具有一个 `responseType`，其值可为 `'GRANTED'`、`'QUEUED'`、`'REVOKED'` 或 `'REJECTED'`。

如果 `responseType` 为 `'GRANTED'`，则移动机器人被允许进入该区域或使用所请求的轨迹。  
车队控制系统可以将 `responseType` 设为 `'QUEUED'`，以确认已收到移动机器人的请求，但暂未授予权限，从而告知机器人该请求正在处理中。  
如果 `responseType` 为 `'REJECTED'`，则移动机器人不得进入该区域，也不得使用所请求轨迹。

`responseType` 为 `'REVOKED'` 表示权限不再有效。  
在移动机器人的 `requestStatus` 被设置为 `'REVOKED'` 之前，车队控制系统应仍将一个 `'REVOKED'` 请求视作 `'GRANTED'`。

`response` 对象可以包含 `leaseExpiry`，用于指定 `'GRANTED'` 请求的有效截止时间。  
若需延长 `leaseExpiry`，车队控制系统可以使用更新后的 `leaseExpiry` 再次发送响应消息。

移动机器人应通过设置相应的 `requestStatus` 来确认车队控制系统的响应，并在其认为该信息仍然相关时保留该请求。另见 [6.9 请求/响应机制](#69-requestresponse-mechanism)。

对于 `'RELEASE'` 区域，移动机器人与车队控制系统之间的交互应符合图 16。

当移动机器人仍位于 `'RELEASE'` 区域内时，应在状态中保留该 `zoneRequest` 对象，并持续报告 `requestStatus` 为 `'GRANTED'`，以通知车队控制系统其仍在该区域中。  
移动机器人退出该区域后，应从状态消息中移除对应的 `zoneRequest` 条目。

当收到 `responseType` 为 `'REVOKED'` 的响应时，移动机器人应从其状态中移除该请求。  
当 `leaseExpiry` 到达时，`requestStatus` 应设为 `'EXPIRED'`，且移动机器人不得进入该区域。  
如果移动机器人在 `leaseExpiry` 到达时已经位于 `'RELEASE'` 区域内，或者请求被 `'REVOKED'`，则应报告一个警告，并根据区域定义中的 `releaseLossBehavior` 作出反应。

![Figure 16 Zone request behavior for a RELEASE zone.](https://cdn.sxrekord.com/v2/request_release_zone_access.png)
>图 16 `'RELEASE'` 区域的请求行为

对于 `'COORDINATED_REPLANNING'` 区域，移动机器人与车队控制系统之间的交互应符合图 17。

移动机器人应从该区域所有 `'GRANTED'` 请求的轨迹中选择一条，并将对应请求的 `requestStatus` 设为 `'GRANTED'`，同时从其状态中移除其他请求。  
当收到 `responseType` 为 `'REVOKED'` 的响应时，移动机器人应从其状态中移除该请求，并且不得进入 `'COORDINATED_REPLANNING'` 区域。  
当 `leaseExpiry` 到达时，`requestStatus` 应设为 `'EXPIRED'`，且移动机器人不得进入该区域。  
如果移动机器人在 `leaseExpiry` 到达时已经位于 `'RELEASE'` 区域内，或请求被 `'REVOKED'`，则应停止行驶并报告警告。若要继续，移动机器人应重新提出请求。

![Figure 17 Zone request behavior for a COORDINATED_REPLANNING zone.](https://cdn.sxrekord.com/v2/request_coordinated_replanning_zone_replanning.png)
>图 17 `'COORDINATED_REPLANNING'` 区域的请求行为

<a id="644-interactions-between-zones"></a>
### 6.4.4 区域之间的相互作用

下表描述了区域之间可能发生的相互作用。  
该矩阵是对称的，因为两个区域之间的相互作用与考虑顺序无关。  
对于每一种组合，要么存在一个区域行为覆盖另一个区域行为（例如 `'BLOCKED'` 区域覆盖 `'LINE_GUIDED'` 区域），要么不存在冲突（例如 `'LINE_GUIDED'` 区域与 `'COORDINATED_REPLANNING'` 区域）。

`'DIRECTED'` 与 `'BIDIRECTED'` 区域不得重叠，否则可能导致未定义行为。  
列 “No Zone” 定义了基于轮廓的区域在与无区域空间重叠时的行为，因为移动机器人可以同时处于某个定义区域和无区域区域。  
对于基于运动学中心的区域，移动机器人要么完全在区域内，要么完全在区域外，因此不存在这种重叠交互。

| |**BLOCKED**|**RELEASE**|**LINE_GUIDED**|**COORDINATED_REPLANNING**|**SPEED_LIMIT**|**ACTION**|**PRIORITY**|**PENALTY**|**DIRECTED**|**BIDIRECTED**|**No Zone**|**EDGE-PROPERTIES**|
---|---|---|---|---|---|---|---|---|---|---|---|---|
**BLOCKED**|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|BLOCKED|
**RELEASE**||No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|No Conflict|
**LINE_GUIDED**|||No conflict|LINE_GUIDED|No Conflict| (1) |LINE_GUIDED|LINE_GUIDED|LINE_GUIDED|No conflict|LINE_GUIDED|No conflict|
**COORDINATED_REPLANNING**||||(2)|No conflict|(1)|No conflict|No conflict|No conflict|No conflict|COORDINATED_REPLANNING|(3)|
**SPEED_LIMIT** |||||(4)|No conflict|No conflict|No conflict|No conflict|No conflict|SPEED_LIMIT|(4)|
**ACTION** ||||||(5)|No conflict|No conflict|No conflict|No conflict|ACTION|(5)|
**PRIORITY** |||||||(6)|(6)|No conflict|No conflict|(7)|No conflict|
**PENALTY** ||||||||(6)|No conflict|No conflict|(7)|No conflict|
**DIRECTED** |||||||||(8)|(8)|(7)|(9)|
**BIDIRECTED** ||||||||||(8)|(7)|(9)|

>表 8 区域相互作用矩阵

1. 如果动作与其他区域行为冲突，则应报告错误 `'ZONE_ACTION_CONFLICT'`，错误级别 `'CRITICAL'`（订单错误），并停止移动机器人。
2. 对于所有 `'COORDINATED_REPLANNING'` 区域，规划轨迹都必须被批准。
3. 如果该边存在预定义轨迹，则应在区域请求中发送该轨迹。
4. 多个冲突 `maximumSpeed` 中，取最小值。
5. 执行所有动作。
6. 始终选择限制更严格者；对于 `PRIORITY` 区域，取较低的 `priorityFactor`；当 `PRIORITY` 与 `PENALTY` 区域重叠时，取较高的 `penaltyFactor`；当多个 `PENALTY` 区域重叠时，同样取较高的 `penaltyFactor`。
7. 对于基于运动学中心的区域，移动机器人要么完全在区域内，要么完全在区域外，因此这种重叠不可能发生。
8. 区域不得重叠，因为其行为未定义。
9. 边属性中的 `trajectory` 应覆盖 `DIRECTED` 和 `BIDIRECTED` 区域。

<a id="645-error-handling-within-zones"></a>
### 6.4.5 区域内的错误处理

如果在订单执行过程中的任何时刻，移动机器人意识到其无法到达订单中的某个节点，则应向车队控制系统报告错误 `'NODE_UNREACHABLE'`，错误级别 `'CRITICAL'`。  
随后由车队控制系统决定如何继续。  
移动机器人不应再次尝试到达该节点，而应等待车队控制系统进一步指令。

<a id="65-connection"></a>
## 6.5 连接

当移动机器人客户端连接到 broker 时，应设置遗嘱 Topic 及其消息；当该客户端与 broker 断开连接时，broker 会发布该遗嘱消息。

因此，车队控制系统可以通过订阅所有移动机器人的连接 Topic 来检测断连事件。  
断连是通过 broker 与客户端之间交换的心跳来检测的。  
因此，车队控制系统可以通过订阅每个移动机器人的 `connection` Topic 检测断连事件。

因此，`timestamp` 和 `headerId` 字段总会是过时的。

移动机器人希望正常断开连接时：

1. 移动机器人向 `vda5050/v3/manufacturer/serialNumber/connection` 发送一条消息，并将 `connectionState` 设为 `OFFLINE`。
2. 通过 disconnect 命令断开 MQTT 连接。

移动机器人上线时：

1. 在创建 MQTT 连接时，将遗嘱设置为 `vda5050/v3/manufacturer/serialNumber/connection`，并将字段 `connectionState` 设为 `'CONNECTION_BROKEN'`。
2. 向 Topic `vda5050/v3/manufacturer/serialNumber/connection` 发送消息，并将 `connectionState` 设为 `'ONLINE'`。

该 Topic 上的所有消息都应带有 `retained` 标志。

当移动机器人与 broker 的连接意外中断时，broker 会向 Topic `vda5050/v3/manufacturer/serialNumber/connection` 发送遗嘱消息，并将字段 `connectionState` 设为 `'CONNECTION_BROKEN'`。

<a id="66-state"></a>
## 6.6 状态

移动机器人的状态应通过单个 Topic 发布。

与分别发送多条独立消息（例如当前订单进度、电池状态和错误）相比，使用单个 Topic 在 broker 和车队控制系统处理消息时都能降低负载，同时保持移动机器人状态信息同步。

移动机器人的状态消息应在相关事件发生时发布，或者至少每 30 秒发布一次。

以下事件应触发状态消息发送：

- 收到订单
- 收到订单更新
- `load` 对象发生变化
- `errors` 数组发生变化
- `operatingMode` 字段发生变化
- `driving` 字段发生变化
- `paused` 字段发生变化
- `safetyState` 对象发生变化
- `newBaseRequest` 字段发生变化
- `lastNodeId` 或 `lastNodeSequenceId` 字段发生变化
- `edgeRequests` 或 `zoneRequests` 数组发生变化
- `powerSupply.charging` 字段发生变化
- `nodeStates` 或 `edgeStates` 数组发生变化
- `actionStates`、`instantActionStates` 或 `zoneActionStates` 数组发生变化
- `zoneSets` 数组发生变化
- `maps` 数组发生变化

*说明：对于上述数组，数组中单个条目的变化以及条目的增加或删除，都应触发一次状态消息发送。*

应尽量控制通信量。  
如果两个事件彼此相关（例如接收到新订单通常会引起 `nodeStates` 和 `edgeStates` 的更新；通过节点时也会触发这些更新），则发送一次状态更新通常比发送多次更合理。  
连续两条状态消息之间的最小时间间隔由参数说明表（factsheet）中的 `protocolLimits.timing.minimumStateInterval` 定义（见 [7.10 参数说明表（`factsheet`）消息实现](#710-implementation-of-the-factsheet-message)）。

<a id="661-concept-and-logic"></a>
### 6.6.1 概念与逻辑

订单执行进度通过 `nodeStates` 和 `edgeStates` 跟踪。  
此外，如果移动机器人具备确定当前位置的能力，则应通过 `mobileRobotPosition` 字段发布该位置。

`nodeStates` 和 `edgeStates` 包含了移动机器人接下来需要通过的所有节点和边。

![Figure 18 Order information provided by the state topic. Only the ID of the last node and the remaining nodes and edges are transmitted](https://cdn.sxrekord.com/v2/order_information_state_topic.png)
>图 18 `state` Topic 提供的订单信息。仅传输最后一个节点的 ID 以及剩余节点和边

<a id="662-traversal-of-nodes-and-edges"></a>
### 6.6.2 节点与边的通过

移动机器人自行决定何时将某个节点视为已通过。  
通过该节点的前提是：移动机器人的控制点（control point）应位于节点 `allowedDeviationXY` 范围内，且其朝向应位于 `allowedDeviationTheta` 范围内。

`allowedDeviationXY` 定义了线路引导型移动机器人在何时可以偏离其预定义轨迹，从而沿更平滑路径切过拐角，而不是精确经过节点位置。  
当离开 `allowedDeviationXY` 范围时，移动机器人应重新回到后续边的预定义轨迹上。  
如果后续边设置了 `corridor` 属性，也应同时满足该走廊边界约束。

若移动机器人距离订单第一个节点过远，车队控制系统可以在该节点上设置扩展的 `allowedDeviationXY`，以包含移动机器人当前位置。

移动机器人应通过从 `nodeStates` 数组中移除该节点的 `nodeState`，并将 `lastNodeId` 与 `lastNodeSequenceId` 设为已通过节点的对应值，来报告通过该节点。

一旦移动机器人报告某节点已通过，它就应触发与该节点关联的动作（如有）。  
通过该节点也必然意味着离开通往该节点的边。  
该边随后也应从 `edgeStates` 中移除，其上处于活动状态的动作应结束。

通过节点也标志着移动机器人进入后续边（如果存在）。  
该边上的动作（如有）应被触发。  
这一规则的例外是：如果移动机器人需要停在该节点上（例如由于软阻塞或硬阻塞动作），则只有当它重新开始行驶时，才真正进入后续边。

当存在活动订单时，字段 `lastNodeId` 和 `lastNodeSequenceId` 仅应在移动机器人通过该订单中已释放节点时更新。  
例如，如果一台物理线路引导型移动机器人检测到某个不属于当前活动订单 `nodes` 的物理标记/标签，该检测不得导致 `lastNodeId` 或 `lastNodeSequenceId` 改变。

![Figure 19 Depiction of nodeStates, edgeStates, and actionStates during order handling](https://cdn.sxrekord.com/v2/states_during_order_handling.png)
>图 19 订单处理期间 `nodeStates`、`edgeStates` 与 `actionStates` 的示意

<a id="6621-definition-of-alloweddeviationxy-as-an-ellipse"></a>
#### 6.6.2.1 将 `allowedDeviationXY` 定义为椭圆

`allowedDeviationXY` 被定义为围绕节点位置的一个椭圆，以允许更灵活地接近节点。

![Figure 20 allowedDeviationXY ellipse](https://cdn.sxrekord.com/v2/ellipse.png)
>图 20 `allowedDeviationXY` 椭圆

<a id="663-base-request"></a>
### 6.6.3 已释放段（Base）续发请求

如果移动机器人检测到当前已释放段（Base）即将耗尽，它可以将 `newBaseRequest` 标志设为 `"true"`，以尽量避免不必要的减速制动。

<a id="664-information"></a>
### 6.6.4 信息

移动机器人可以通过 `information` 数组向车队控制系统提交任意附加信息。  
至于这些信息应持续报告多久，由移动机器人自行决定。

车队控制系统不得将这些信息用于业务逻辑；它们只能用于可视化和调试目的。

<a id="665-errors"></a>
### 6.6.5 错误

移动机器人通过 `errors` 数组报告任何问题。

<a id="6651-error-levels"></a>
#### 6.6.5.1 错误级别

问题分为四个级别：`'WARNING'`、`'URGENT'`、`'CRITICAL'` 和 `'FATAL'`。

- `'WARNING'` 级别的问题不需要立即关注。移动机器人可以继续当前订单，并能够接收新订单。该类错误可能会自行恢复，例如 LiDAR 扫描器脏污。
- `'URGENT'` 级别的问题（例如电池电量过低）需要立即关注。移动机器人仍可继续当前订单，并能够接收新订单。
- `'CRITICAL'` 级别的问题需要立即关注，例如尝试拾取一个并不存在的物体。移动机器人不得继续行驶，因为其无法继续当前订单，但仍能够接收新订单。
- `'FATAL'` 级别的问题需要人工干预，例如丢失定位。移动机器人不得继续行驶，因为其既无法继续当前活动订单，也无法接收任何新订单。

移动机器人可以通过 `errorReferences` 数组添加有助于定位错误原因的引用信息。  
字段 `errorDescription` 与 `errorHint` 可以提供面向人的可读文本，用于解释错误或建议可能的解决方式。

无论错误级别如何，移动机器人都不得因此自行清除其订单。

<a id="6652-error-references"></a>
#### 6.6.5.2 错误引用

如果错误是由订单内容错误或执行失败引起的，移动机器人可以在字段 `errorReferences` 中返回有意义的引用信息，以帮助定位错误原因。

这些信息可包括：

- `headerId`
- Topic（`order` 或 `instantAction`）
- 若错误由订单更新引起，则包括 `orderId` 和 `orderUpdateId`
- 若错误由动作引起，则包括 `actionId`
- 若错误由错误动作参数引起，则包括相关参数列表

<a id="6653-error-translations"></a>
#### 6.6.5.3 错误翻译

对于 `errorDescription` 和 `errorHint`，移动机器人都可以分别通过 `errorDescriptionTranslations` 和 `errorHintTranslations` 数组提供翻译。  
每条翻译由一个 ISO 639-1 语言代码以及相应的译文组成。

<a id="6654-predefined-error-types"></a>
#### 6.6.5.4 预定义错误类型

移动机器人应使用预定义错误类型报告特定问题。下表列出了预定义错误类型及其说明。

错误类型 | 错误级别 | 描述 | 引用 | 报告持续时间
---|---|---|---|---
'UNSUPPORTED_PARAMETER' | 'CRITICAL' | 收到包含不支持的可选参数的消息。 | 参数名称 | 直到接受新的订单。
'NO_ORDER_TO_CANCEL' | 'WARNING' | 移动机器人收到 `cancelOrder` 动作，但当前没有活动订单可取消。 | `cancelOrder` 的 `actionId` | 直到接受新的订单。
'VALIDATION_FAILURE' | 'WARNING' | 收到格式错误的订单。 | 如可能，使用被拒消息的 `orderId` 和 `orderUpdateId`。 | 直到接受新的订单。
'INVALID_ORDER_ACTION' | 'WARNING' | 收到包含不支持动作的订单。 | 被拒消息的 `orderId` 和 `orderUpdateId` | 直到接受新的订单。
'INVALID_INSTANT_ACTION' | 'WARNING' | 收到不支持的即时动作。 | `instantAction` 的 `actionId` | 直到接受新的即时动作。
'OUTDATED_ORDER_UPDATE' | 'WARNING' | 收到 `orderId` 正确但 `orderUpdateId` 过期的订单。 | 被拒消息的 `orderId` 和 `orderUpdateId` | 直到接受新的订单。
'SAME_ORDER_UPDATE_ID' | 'WARNING' | 收到重复订单消息（相同 `orderId` 与 `orderUpdateId`）。 | 被拒消息的 `orderId` 和 `orderUpdateId` | 直到接受新的订单。
'ORDER_UPDATE_FOLLOWING_CANCEL' | 'WARNING' | 收到针对已经取消订单的更新。 | 被拒消息的 `orderId` 和 `orderUpdateId` | 直到接受新的订单。
'OUTSIDE_OF_CORRIDOR' | 'CRITICAL' | 离开某条边定义的走廊。 | `edgeId` | 直到移动机器人不再违反走廊边界。
'INSUFFICIENT_MEMORY' | 'URGENT' | 移动机器人内存不足，无法处理收到的订单。 | 如可能，使用被拒消息的 `orderId` 和 `orderUpdateId`。 | 直到接受新的订单。
'DUPLICATE_MAP' | 'WARNING' | 收到一个 `mapId` 和 `mapVersion` 已存在的地图。 | 重复地图的 `mapId` 和 `mapVersion` | 直到接受新的地图相关即时动作。
'BLOCKED_ZONE_VIOLATION' | 'CRITICAL' | 进入 `'BLOCKED'` 区域。 | `zoneId` | 直到移动机器人不再违反该阻塞区域。
'DUPLICATE_ZONE_SET' | 'WARNING' | 收到一个 `zoneSetId` 已存在的区域集。 | `zoneSetId` 或 `instantAction` 的 `actionId` | 保持足够长时间，以便车队控制系统注意到区域更新失败。
'RELEASE_LOST' | 'CRITICAL' | 丢失 `'RELEASE'` 区域的授权。 | `zoneId` | 直到移动机器人不再位于该 `'RELEASE'` 区域内，或重新获得授权。
'ZONE_ACTION_CONFLICT' | 'CRITICAL' | 区域行为与区域动作之间发生冲突。 | `'ACTION'` 区域的 `zoneId` | 直到移动机器人不再违反该区域行为。
'NODE_UNREACHABLE' | 'CRITICAL' | 移动机器人无法到达订单中的某个节点。 | `nodeId` | 直到接受新的订单。
'LOCALIZATION_ERROR' | 'FATAL' | 移动机器人未定位。 |  | 直到恢复定位。
'NO_ROUTE_TO_TARGET' | 'WARNING' | 收到的订单中至少有一个节点不可达。 | `orderId` | 直到接受新的订单。
'OTHER_ORDER_ACTIVE' | 'WARNING' | 在另一个订单仍处于活动状态时收到了新订单。 | `orderId` | 直到接受新的订单。
'START_NODE_OUT_OF_RANGE' | 'WARNING' | 收到的订单第一个节点不可达。 | `orderId` | 直到接受新的订单。
'MOBILE_ROBOT_NOT_AVAILABLE' | 'WARNING' | 在非 `'AUTOMATIC'`、`'SEMIAUTOMATIC'` 或 `'INTERVENED'` 运行模式下收到订单。 | `orderId` | 直到运行模式允许接收新订单。
'UNKNOWN_MAP_ID' | 'WARNING' | 收到包含引用未知 `mapId` 节点的订单。 | `orderId` | 直到接受新的订单。

>表 9 预定义错误类型

<a id="666-operating-mode"></a>
### 6.6.6 运行模式

在常规订单执行过程中，车队控制系统应完全控制移动机器人。  
但某些情况下这并不可能，例如需要在移动机器人本体上进行人工干预。  
移动机器人应使用字段 `operatingMode` 报告这一点。

下表给出了 `operatingMode` 字段的取值、其含义以及对移动机器人与车队控制系统交互的影响：

运行模式 | 描述
---|---
AUTOMATIC | 车队控制系统完全控制移动机器人。<br>移动机器人基于车队控制系统下发的订单进行移动和动作执行。
SEMIAUTOMATIC | 车队控制系统控制移动机器人。<br>移动机器人基于车队控制系统下发的订单进行移动和动作执行。<br>行驶速度由 HMI 控制。<br>转向由自动控制。
INTERVENED | 车队控制系统不控制移动机器人，但移动机器人能够正确报告状态。<br>HMI 可用于控制移动机器人的转向、速度和操作装置。<br>车队控制系统仍可向移动机器人发送订单或订单更新，以便其在切回 `'AUTOMATIC'` 或 `'SEMIAUTOMATIC'` 模式后执行。除 `cancelOrder` 外，车队控制系统不得发送任何即时动作。<br>移动机器人不得清除订单，但应从状态中移除所有区域请求，即便其已经位于某个 `'RELEASE'` 区域内。(*说明：如有必要，车队控制系统仍可继续跟踪移动机器人位置，并决定是否可以为其他机器人放行。*) 移动机器人不得请求进入 `'RELEASE'` 区域的许可，也不得请求在 `'COORDINATED_REPLANNING'` 区域内重规划。<br>如果进入 `'INTERVENED'` 模式会影响正在运行的动作，移动机器人应在状态消息中如实反映。<br>如果移动机器人离开该模式后未直接切换到 `'AUTOMATIC'` 或 `'SEMIAUTOMATIC'`，则应按照新的运行模式行为执行。如果它离开该模式后直接切换到 `'AUTOMATIC'` 或 `'SEMIAUTOMATIC'`，则应继续执行当前订单。如果移动机器人在 `'INTERVENED'` 模式下检测到当前订单无法继续执行，则应切换到 `'MANUAL'` 并按该模式处理。
MANUAL | 车队控制系统不控制移动机器人。<br>车队控制系统不得向移动机器人发送订单或动作。<br>HMI 可用于控制移动机器人的转向、速度和操作装置。<br>移动机器人的位置会发送给车队控制系统。<br>进入该模式时，移动机器人应立即清除当前订单。<br>如果在该模式下，移动机器人检测到自己被移动到了一个无法继续使用当前 `lastNodeId` 作为新订单起点的位置，则应将 `lastNodeId` 设为空字符串 `("")`。
STARTUP | 车队控制系统不控制移动机器人。移动机器人正在启动，尚未准备好接收订单。在启动完成之前，状态消息参数可能不完整或无效。
SERVICE | 车队控制系统不控制移动机器人。<br>车队控制系统不得向移动机器人发送订单或动作。<br>进入该模式时，移动机器人应立即清除当前订单。<br>移动机器人应将 `lastNodeId` 设为空字符串 `("")`。<br>授权人员可对移动机器人进行重新配置。
TEACH_IN | 车队控制系统不控制移动机器人。<br>车队控制系统不得向移动机器人发送订单或动作。<br>进入该模式时，移动机器人应立即清除当前订单。<br>移动机器人应将 `lastNodeId` 设为空字符串 `("")`。<br>移动机器人处于示教状态，例如由操作员执行建图。

>表 10 移动机器人的运行模式

运行模式 | 车队控制系统是否控制 | 状态消息内容是否有效 | 进入时清除订单 | 将 `lastNodeId` 设为空 | 进入时清除区域请求 | 是否允许发送即时动作 | 是否允许发送订单
--- | --- | --- | --- | --- | --- | --- | ---
AUTOMATIC | 是 | 是 | 否 | 否 | 否 | 是 | 是
SEMIAUTOMATIC | 是 | 是 | 否 | 否 | 否 | 是 | 是
INTERVENED | 否 | 是 | 否 | 否 | 是 | 仅允许 `cancelOrder` | 是
MANUAL | 否 | 是 | 是 | 是，如无法继续订单 | 是 | 否 | 否
STARTUP | 否 | 否 | 是 | 是 | 是 | 否 | 否
SERVICE | 否 | 是 | 是 | 是 | 是 | 否 | 否
TEACH_IN | 否 | 是 | 是 | 是 | 是 | 否 | 否

>表 11 运行模式概览及其影响

<a id="667-clearing-the-order-on-the-mobile-robot"></a>
### 6.6.7 在移动机器人上清除订单

当发生以下任一事件时，移动机器人应停止执行当前订单：

- 移动机器人切换到 `'MANUAL'`、`'STARTUP'`、`'SERVICE'` 或 `'TEACH_IN'` 模式（另见 [6.6.6 运行模式](#666-operating-mode)）。
- 移动机器人从车队控制系统收到即时动作 `cancelOrder`。
- 移动机器人收到即时动作 `startHibernation`。

在这些情况下，移动机器人应清除其当前订单，这意味着：

- `actionStates` 中所有已调度动作都应被取消，并在 `actionStates` 中报告为 `'FAILED'`。
- `actionStates` 中所有正在运行的动作：  
若可取消（`cancelAllowed = true`），则应被取消，并在 `actionStates` 中报告为 `'FAILED'`。  
若不可取消（`cancelAllowed = false`），则在执行期间应报告为 `'RUNNING'`，之后报告其实际结束状态（成功则 `'FINISHED'`，否则 `'FAILED'`）。
- `orderId`、`orderUpdateId`、`lastNodeId` 与 `lastNodeSequenceId` 的值保持不变。
- 数组 `nodeStates` 与 `edgeStates` 被清空。
- 所有请求对象应从状态中移除。

只要订单相关动作尚未全部进入 `'FINISHED'` 或 `'FAILED'` 状态，移动机器人就不得报告运行模式 `'MANUAL'`、`'SERVICE'` 或 `'TEACH_IN'`。  
在报告运行模式 `'MANUAL'`、`'SERVICE'` 或 `'TEACH_IN'` 之前，不得清空 `nodeStates` 与 `edgeStates`。

订单取消只能由车队控制系统触发。

<a id="668-idle-state-of-the-mobile-robot"></a>
### 6.6.8 移动机器人的空闲状态

当 `nodeStates` 和 `edgeStates` 为空，且 `actionStates` 中所有动作都为 `'FINISHED'` 或 `'FAILED'` 时，移动机器人处于空闲状态。  
只有在移动机器人处于空闲状态时，才应接受新订单。  
订单更新可以在移动机器人空闲时接受，也可以在订单执行期间接受。  
在空闲状态下，移动机器人可以执行 `instantActions`。

<a id="669-action-states"></a>
### 6.6.9 动作状态

当移动机器人收到作为订单一部分的某个 `action`（附着在订单的 `node` 或 `edge` 上）时，应在其 `actionStates` 数组中以一个 `actionState` 来报告该动作。  
当移动机器人收到某个 `instantAction` 时，应在其 `instantActionStates` 数组中以一个 `actionState` 报告该动作。  
当移动机器人执行某个 `zoneAction` 时，应在其 `zoneActionStates` 数组中以一个 `actionState` 报告该动作。作为可选项，移动机器人也可以在这里报告尚未执行的计划中 `zoneAction`。

动作当前阶段应通过对应 `actionState` 的 `actionStatus` 字段反映（见表 12）。

actionStatus | 描述
---|---
'WAITING' | 移动机器人已收到该动作，但对应节点尚未通过，或对应边尚未进入。
'INITIALIZING' | 动作已被触发，正在执行准备步骤。
'RUNNING' | 动作正在运行。
'PAUSED' | 动作因暂停即时动作或外部触发（例如移动机器人上的暂停按钮）而被暂停。
'RETRIABLE' | 动作执行失败，但允许重试；是否允许由订单动作中的 `retriable` 参数指定。从该状态退出通常由即时动作 `retry`、`skipRetry` 或外部触发触发。
'FINISHED' | 动作已完成。<br>结果通过 `actionResult` 报告。
'FAILED' | 动作因某种原因未能完成。

>表 12 `actionStatus` 字段的可选值

图 21 可视化了所有可能的动作状态转换，以下矩阵给出若干示例：

| **from / to →** | **WAITING** | **INITIALIZING** | **PAUSED** | **RUNNING** | **RETRIABLE** | **FAILED** | **FINISHED** |
|---|---|---|---|---|---|---|---|
| **初始状态** | 排队等待后续执行 | 立即开始初始化（例如即时动作） | - | 立即开始执行（例如即时动作） | - | 即时动作执行失败（移动机器人未知动作、参数无效） | 动作立即完成（例如设置某个参数） |
| **WAITING** | - | 需要进行准备（升降、传感器上电） | - | 无需准备 | - | 通过取消、切换到手动模式而中止 | 动作瞬时成功，例如到达节点/边后立即完成 |
| **INITIALIZING** | - | - | 外部触发 | 初始化完成，动作开始 | - | 初始化失败、通过取消中止、切换到手动模式 | - |
| **PAUSED** | - | 外部触发 | - | 外部触发 | - | 通过 `cancelOrder` 中止、切换到手动模式 | - |
| **RUNNING** | - | - | 外部触发 | - | 动作未成功完成，但可重试 | 通过取消中止、切换到手动模式、动作最终未能返回期望结果 | 动作返回期望结果；若动作不可中断且必须完成，则即使经历 `cancelOrder` 后也可能最终进入此状态 |
| **RETRIABLE** | - | 通过 `retry` 或外部触发重试动作 | - | 通过 `retry` 或外部触发重试动作 | - | 通过 `skipRetry` 失败、通过 `cancelOrder` 失败、外部触发失败、切换到手动模式 | 操作员通过外部输入修复后完成 |

>表 13 动作状态可能转换的示例

![Figure 21 All possible status transitions for actionStates](https://cdn.sxrekord.com/v2/action_state_transition.png)
>图 21 `actionStates` 所有可能的状态转换

<a id="6691-reporting-of-horizon-actions-in-the-mobile-robots-state"></a>
#### 6.6.9.1 在移动机器人状态中报告前瞻段（Horizon）动作

移动机器人的状态应始终反映其当前持有订单的完整状态。  
因此，机器人应始终报告其已释放段（Base）与前瞻段（Horizon）中所包含动作的 `actionStates`。
所有前瞻段动作都报告为 `'WAITING'`。

如果移动机器人收到一个订单更新，并且该更新移除了或变更了原先前瞻段（Horizon）的一部分，则附着在这些节点和边上的所有动作都应从 `actionStates` 中移除，以准确反映当前状态。
已释放段（Base）中动作的 `actionStates` 在 `orderUpdate` 场景下永远不得被移除，因为一旦释放，已释放段就不能被修改。

<a id="6610-request-use-of-corridors"></a>
### 6.6.10 请求使用走廊（Corridor）

如果移动机器人当前活动订单中的走廊带有 `releaseRequired = true`，那么在偏离某条边的预定义轨迹之前，它应先发出请求。  
为此，机器人应在其状态消息中增加一个 `edgeRequest` 对象。  
`requestId` 在该移动机器人发出的所有请求中（例如 `zoneRequest`、`edgeRequest`）都应唯一。

`requestStatus` 初始值设为 `REQUESTED`，而 `edgeId` 与 `sequenceId` 的组合用于引用机器人希望偏离的那条边的轨迹。  
只要这些边属于当前已释放段（Base），移动机器人可以同时请求多个边的批准。
每个走廊的使用都应通过独立 `edgeRequest` 请求，并且每个请求都应由车队控制系统通过 Topic `responses` 单独批准（见 [6.9 请求/响应机制](#69-requestresponse-mechanism)）。

车队控制系统只能为属于已释放段（Base）的边释放走廊。
在收到车队控制系统通过 Topic `responses` 返回的响应之前，机器人应始终停留在其当前边的预定义轨迹上。
一旦机器人收到允许其开始机动的批准，它就将 `requestStatus` 设为 `'GRANTED'`，并可开始使用走廊。

只要机器人仍需要该走廊，就应在状态中保留该 `edgeRequest`。  
如果移动机器人不再需要使用走廊（例如其避障过程已成功完成、不再需要避让障碍物等），则应通过从状态中移除对应 `edgeRequest` 对象来告知车队控制系统。  
从此之后，移动机器人应再次按照线路引导型移动机器人的方式行动。  
如果其之后还想再次偏离预定义轨迹，则必须提出新的 `edgeRequest`。

如果机器人在避障过程中到达当前边 `corridor` 的末端，并计划继续使用下一段尚未释放的走廊，则应在当前 `corridor` 边界处停止，发送新的边请求，并等待车队控制系统批准。

如果移动机器人的批准根据响应中的 `leaseExpiry` 到期，或者车队控制系统撤销了已授予的请求，则移动机器人应执行该边 `corridor.releaseLossBehavior` 中预定义的回退动作。

授权丢失后的恢复策略包括：  
沿偏离时的路径返回该边的预定义轨迹，或停在当前位置等待人工干预。

<a id="67-visualization"></a>
## 6.7 可视化（visualization）

为了实现近实时的位置与规划轨迹更新，移动机器人可以在 Topic `visualization` 上广播其位置、速度和规划轨迹。

`visualization` 对象中的字段结构，与 `state` 中的位置、速度、规划路径和中间路径对象结构相同。  
更多信息见 [7.9 `visualization` 消息实现](#79-implementation-of-the-visualization-message)。  
该 Topic 的更新频率由集成方定义。

<a id="68-sharing-of-planned-paths-for-freely-navigating-mobile-robots"></a>
## 6.8 自由导航移动机器人的规划路径共享

自由导航型移动机器人应通过状态消息向车队控制系统通信其规划轨迹。  
如果需要更高频率共享，也可以使用 Topic `visualization`。

移动机器人通过共享 `intermediatePath` 与 `plannedPath` 来表示其路径信息。  
其中，`intermediatePath` 表示机器人可通过其传感器感知到的、较近关键点的预计到达时间；  
`plannedPath` 表示当前活动订单范围内的一条更长路径。

这两条路径都应从移动机器人当前位置开始，与订单中的节点无关。  
路径共享长度可以由移动机器人自行决定，因为它可能取决于当前情境。  
如果移动机器人为自由导航型，则每条状态消息中都应同时共享 `intermediatePath` 和 `plannedPath`。

- `plannedPath` 以 `edgeState.trajectory` 字段定义的 NURBS 形式表示。`plannedPath` 可包含一个节点数组，其中通过 `nodeId` 引用当前路径上将要经过的节点。每当移动机器人的 `plannedPath` 发生显著变化时，都应更新该字段。`plannedPath` 至少应覆盖当前已释放段（Base）。
- `intermediatePath` 以折线（polyline）形式定义。该折线由关键点之间的线段组成。每个 `waypoint` 包括其 `x`、`y` 位置、可选的机器人朝向以及预计到达时间 `ETA`。`intermediatePath` 应在每次发送状态或可视化消息时更新，并始终从移动机器人当前位置开始。

参数 `plannedPath` 和 `intermediatePath` 仅应用于由移动机器人自行规划的轨迹。  
`edgeState` 中的轨迹字段仅应用于“确认”那些在布局中预先定义，或在订单中已给出的轨迹。

<a id="69-requestresponse-mechanism"></a>
## 6.9 请求/响应机制

在移动机器人与车队控制系统之间的某些协调任务中，移动机器人只有在获得车队控制系统明确许可后，才允许执行某项操作。  
对于这种场景，使用请求/响应机制。  
请求的生命周期如图 22 所示。

![Figure 22 Visualization of request state transitions](https://cdn.sxrekord.com/v2/request_state_transitions.png)
>图 22 请求生命周期：请求状态及可能转换逻辑

请求总是由移动机器人发起，并作为状态消息的一部分进行通信。  
车队控制系统应评估该请求，并通过 Topic `responses` 返回其决定。

每个请求都应在移动机器人上表示为一个请求对象（例如 `zoneRequest`），并包含在状态消息中。  
请求对象至少应包含：

- 对于该移动机器人当前所有活动请求唯一的 `requestId`
- 指定请求操作类型的 `requestType`（例如访问、重规划、使用走廊）
- 指向该请求所针对资源的引用（例如区域、区域集、地图、`edgeId`、`sequenceId`）
- `requestStatus`

字段 `requestStatus` 描述请求的生命周期，应支持以下值：

- `'REQUESTED'`：移动机器人提出请求。
- `'GRANTED'`：车队控制系统批准请求。
- `'REVOKED'`：车队控制系统撤销之前已批准的请求。
- `'EXPIRED'`：请求已过期。
- `'QUEUED'`：车队控制系统确认已收到移动机器人的请求，但尚未授予权限；该请求已被加入某种队列。

车队控制系统从状态 Topic 接收请求，并应通过 Topic `responses` 返回一个响应对象，其中包括：

- 对应请求的 `requestId`
- 一个决定值，取值为 `'GRANTED'`、`'QUEUED'`、`'REJECTED'` 或 `'REVOKED'`
- 可选的 `leaseExpiry` 时间戳，用于限制 `'GRANTED'` 决定的有效期

如果请求被回答为 `'QUEUED'`，则表示车队控制系统已确认收到该请求，但尚未授予许可。移动机器人应继续等待，且不得执行该需要许可的操作。  
如果请求被回答为 `'REJECTED'`，则移动机器人不得执行该操作，并且当对应请求不再需要时，可以将其从状态中移除。

如果请求被回答为 `'GRANTED'`，则移动机器人可以根据该请求类型的语义执行相应操作。  
若存在 `leaseExpiry`，则该授权只在该时间点之前有效。  
车队控制系统可通过发送同一 `requestId` 且带有新 `leaseExpiry` 的更新响应，来延长授权时长。

如果请求被回答为 `'REVOKED'`，或当到达 `leaseExpiry` 时，移动机器人应根据该请求资源定义的 `releaseLossBehavior` 作出反应。

如果该请求对应的操作已经开始，移动机器人应将 `requestStatus` 更新为相应值（`'REVOKED'` 或 `'EXPIRED'`），并在其状态中保留，直到 `releaseLossBehavior` 完成。  
如果该请求对应的操作尚未开始，则移动机器人应从状态中移除该请求。

如果在应用场景要求的时限内未收到响应，则移动机器人应按照“未获得授权”的情况处理，即不得执行该需要明确许可的操作。  
超时与重试策略应在系统集成阶段定义。

当对应操作已经完成、被中止或被拒绝，且不再需要车队控制系统作出进一步决定时，该请求应从移动机器人状态中移除。

<a id="610-factsheet"></a>
## 6.10 参数说明表（factsheet）

参数说明表（factsheet）提供某一特定移动机器人型号系列的基础信息。
这些信息可用于比较不同移动机器人类型，也可用于移动机器人系统的规划、选型、仿真和集成。

参数说明表中的某些字段值只能在系统集成期间确定，例如项目特定载荷与移动机器人的适配关系。
参数说明表既面向人类阅读，也可用于机器处理，例如由车队控制系统应用程序导入，因此被定义为一份 JSON 文档。

车队控制系统可以通过发送即时动作 `factsheetRequest` 来请求移动机器人的参数说明表。

该 Topic 上的所有消息都应带有 `retained` 标志。

<a id="7-message-specification"></a>
# 7 消息规范

各类消息以表格形式给出，用于描述 JSON 字段的内容。

此外，公共 Git 仓库（https://github.com/VDA5050/VDA5050）中还提供了用于校验的 JSON Schema。
JSON Schema 会随 VDA5050 每次发布而更新。
如果 JSON Schema 与本文档存在差异，应以本文档为准。

<a id="71-symbols-of-the-tables-and-meaning-of-formatting"></a>
## 7.1 表格符号及格式含义

对象结构表包含标识符名称、其单位、数据类型以及说明（如果有）。

标识方式 | 描述
---|---
普通文本 | 变量是基础数据类型
**粗体** | 变量是非基础数据类型（例如 JSON 对象或数组），并在别处单独定义
*斜体* | 变量为可选
***粗斜体*** | 变量既为可选，又为非基础数据类型
arrayName[arrayDataType] | 变量（此处为 `arrayName`）是一个数组，其数据类型由方括号中的 `arrayDataType` 指定

>表 14 表格符号及格式含义

所有关键字均区分大小写。  
所有字段名均采用 camelCase。

<a id="711-optional-fields"></a>
### 7.1.1 可选字段

如果某个变量被标记为可选，则表示对于发送方来说，该变量在某些情况下可能并不适用（例如车队控制系统向移动机器人发送订单时，某些移动机器人会自行规划轨迹，因此订单 `edge` 对象中的 `trajectory` 字段可以省略）。

如果移动机器人收到的消息中包含在本协议中标记为可选的字段，则应按其语义作出相应处理，而不是忽略该字段。  
如果移动机器人由于不支持某个参数而无法处理该订单，则应通过错误类型 `'UNSUPPORTED_PARAMETER'`、错误级别 `'CRITICAL'` 报告该情况，并拒绝该订单。

车队控制系统只应发送移动机器人所支持的可选字段。

示例：轨迹是可选的。  
如果某台移动机器人无法处理轨迹，则车队控制系统不应向其发送轨迹。

移动机器人应通过 `factsheet` 消息告知其需要或支持哪些可选参数。

<a id="712-permitted-characters-and-field-lengths"></a>
### 7.1.2 允许字符与字段长度

所有通信均采用 UTF-8 编码，以支持说明文本的国际化适配。  
建议 ID 仅使用以下字符：

`A-Z a-z 0-9 _ - . :`

消息最大长度未被显式定义，但会受到 MQTT 协议规范以及参数说明表中定义的技术限制约束。

如果移动机器人的内存不足以处理传入订单，则应拒绝该订单，并报告错误类型 `'INSUFFICIENT_MEMORY'`，错误级别 `'URGENT'`。

最大字段长度、字符串长度或取值范围的匹配，由集成方负责。

为了便于集成，移动机器人厂商应提供一份详细参数说明表，见 [7.10 参数说明表（`factsheet`）消息实现](#710-implementation-of-the-factsheet-message)。

<a id="713-notation-of-fields-topics-and-enumerations"></a>
### 7.1.3 字段、Topic 与枚举的表示法

本文档中的 Topic 和字段以如下形式突出显示：`exampleField` 和 `exampleTopic`。  
枚举应使用全大写，并通过下划线分隔单词，例如 `'EXAMPLE_ENUMERATION'`。这些值在文档中用单引号括起。

这也包括例如 `actionStatus` 字段中的关键字（`'WAITING'`、`'FINISHED'` 等）。  
所谓可扩展枚举（extensible enum）表示除了预定义值之外，还允许其他扩展值。

<a id="714-json-data-types"></a>
### 7.1.4 JSON 数据类型

在可能的情况下，应直接使用 JSON 数据类型。  
例如布尔值应编码为 `"true"` 或 `"false"`，而不是使用枚举（如 `'TRUE'`、`'FALSE'`）或魔法数字。

数值类型使用类型与精度共同描述，例如 `float64` 或 `uint32`。  
不支持 IEEE 754 中的特殊数字值，例如 `NaN` 或无穷大。

<a id="72-protocol-header"></a>
## 7.2 协议头

每条 JSON 消息都以一个头部开始。  
该头部并不是一个 JSON 对象，而是由以下独立元素组成。

对象结构 | 数据类型 | 描述
---|---|---
headerId | uint32 | 消息头 ID。<br>`headerId` 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。
timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。
manufacturer | string | 移动机器人制造商。
serialNumber | string | 移动机器人序列号。

<a id="73-implementation-of-the-order-message"></a>
## 7.3 `order` 消息实现

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
headerId | | uint32 | 消息头 ID。<br>该 ID 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。
timestamp | | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
version | | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。
manufacturer | | string | 移动机器人制造商。
serialNumber | | string | 移动机器人序列号。
orderId | | string | 订单标识。<br>用于标识属于同一订单的多条订单消息。
orderUpdateId | | uint32 | 订单更新标识。<br>对每个 `orderId` 应唯一，并且新订单从 `0` 开始。<br>如果订单更新被拒绝，该字段应在对应错误中返回。
*orderDescription* | | string | 仅用于可视化的附加可读信息；不得用于任何业务逻辑处理。
**nodes [node]** | | array | 为完成订单而需要通过的节点对象数组。
**edges [edge]** | | array | 为完成订单而需要通过的边对象数组。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**node** { | | JSON object |  |
nodeId | | string | 节点唯一标识。<br>同一个节点可以在一个订单消息中被引用多次。通过 `sequenceId` 区分遍历顺序。
sequenceId | | uint32 | 用于跟踪订单中节点和边的顺序，并简化订单更新。<br>其主要用途是区分在同一 `orderId` 中多次经过的同一节点。<br>`sequenceId` 在节点和边之间共享，并定义遍历顺序。
*nodeDescriptor* | | string | 关于节点的附加信息。
released | | boolean | `"true"` 表示该节点属于已释放段（Base）。<br>`"false"` 表示该节点属于前瞻段（Horizon）。
***nodePosition*** | | JSON object | 节点位置。<br>对于不需要节点位置的移动机器人类型（例如线路引导型移动机器人），该字段为可选。
**actions [action]** <br> } | | array | 在该节点上要执行的动作数组。<br>若无需动作，则为空数组。

对象结构 | 单位 | 数据类型 | 描述
---| --- |--- | ---
**nodePosition** { | | JSON object | 定义项目特定全局世界坐标系中的地图位置。<br>每一层楼都有自己的地图。<br>所有地图应使用同一个项目特定全局原点。
x | m | float64 | 地图中的 X 坐标，参照项目特定全局坐标系。<br>精度取决于具体实现。
y | m | float64 | 地图中的 Y 坐标，参照项目特定全局坐标系。<br>精度取决于具体实现。
*theta* | rad | float64 | 范围：`[-Pi ... Pi]`<br><br>移动机器人在节点上被视为已通过时应匹配的绝对朝向。<br>如果定义了该值，移动机器人必须在该节点满足该朝向。<br>如果前一条边不允许旋转，则移动机器人应在节点上旋转。<br>如果后一条边定义了不同朝向且不允许旋转，则移动机器人应在进入该边之前，在节点上旋转到该边要求的朝向。
***allowedDeviationXY*** | m | JSON object | 指示移动机器人应多精确地匹配节点位置，才可视为已通过。<br>（另见 [6.1.3 订单取消](#613-order-cancellation) 和 [6.6.2 节点与边的通过](#662-traversal-of-nodes-and-edges)）
*allowedDeviationTheta* | rad | float64 | 范围：`[0.0 ... Pi]`<br><br>若定义，则表示移动机器人应多精确地匹配节点朝向，才可视为已通过。<br>可接受的最小角度为 *`theta - allowedDeviationTheta`*，最大角度为 *`theta + allowedDeviationTheta`*。若未定义 `theta`，则对移动机器人朝向无要求。<br>若值为 `0.0`：表示不允许偏差，即移动机器人应尽可能精确地达到节点朝向；即使 `allowedDeviationTheta` 小于机器人技术容差，此规定仍然适用。如果移动机器人支持该属性，但该节点未由车队控制系统定义该字段，则移动机器人应默认其值为 `0.0`。
mapId | | string | 引用该位置所对应地图的唯一标识。<br>每张地图都使用同一个项目特定全局坐标原点。<br>例如当移动机器人使用电梯从出发楼层到目标楼层时，它会从出发楼层地图中“消失”，并在目标楼层地图中对应的电梯节点上“出现”。

对象结构 | 单位 | 数据类型 | 描述
---| --- |--- | ---
**allowedDeviationXY** { | | JSON object | 指示移动机器人应多精确地匹配节点位置，才可视为已通过。<br>若 `a = b = 0.0`：表示不允许偏差，即移动机器人应尽可能精确地使其控制点到达或通过节点位置；即使 `allowedDeviationXY` 小于移动机器人技术上可行的偏差范围，此规定仍然适用。如果移动机器人支持该属性，但该节点未由车队控制系统定义该字段，则移动机器人应默认 `a` 与 `b` 均为 `0.0`。<br>节点坐标定义该椭圆的中心。
a | m | float64 | 椭圆长半轴长度，单位米。
b | m | float64 | 椭圆短半轴长度，单位米。
theta<br>} | rad | float64 | 椭圆旋转角（项目特定坐标系中，从正水平轴到椭圆长轴的夹角）。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**action** { | | JSON object | 描述移动机器人可以执行的动作。
actionType | | string | 动作类型。对预定义动作而言，其定义见表 4 第一列。<br>用于标识动作功能。
actionId | | string | 用于标识该动作，并在状态中映射到对应 `actionState` 的唯一 ID。<br>建议：使用 UUID。
*actionDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
blockingType | | string | Enum {'NONE', 'SINGLE', 'SOFT', 'HARD'}：<br>`'NONE'`：允许行驶，也允许其他动作；<br>`'SINGLE'`：允许行驶，但不允许其他动作；<br>`'SOFT'`：允许其他动作，但不允许行驶；<br>`'HARD'`：此时唯一允许执行的动作。
***actionParameters [actionParameter]*** | | array | 该动作的参数对象数组，例如 `"deviceId"`、`"loadId"`、`"external triggers"`。<br><br>示例实现见 [7.3.1 动作参数格式](#731-format-of-action-parameters)。
*retriable* <br> } | | boolean | `"true"`：动作失败时可进入 `RETRIABLE` 状态。<br>`"false"`：动作失败后直接进入 `FAILED` 状态。<br>默认值：`"false"`。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**edge** { | | JSON object | 两个节点之间的有向连接。
edgeId | | string | 边唯一标识。<br>同一条边可以在一个订单消息中被引用多次。通过 `sequenceId` 区分遍历顺序。
sequenceId | | uint32 | 用于跟踪订单中节点和边的顺序，并简化订单更新。<br>`sequenceId` 在节点和边之间共享，并定义遍历顺序。
*edgeDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
released | | boolean | `"true"` 表示该边属于已释放段（Base）。<br>`"false"` 表示该边属于前瞻段（Horizon）。
*maximumSpeed* | m/s | float64 | 该边上的允许最大速度。<br>速度定义按移动机器人测得的最高速度理解。
*maximumMobileRobotHeight* | m | float64 | 该边上允许的移动机器人最大高度（包括载荷）。
*minimumLoadHandlingDeviceHeight* | m | float64 | 该边上载荷处理装置的允许最小高度。
*orientation* | rad | float64 | 移动机器人在该边轨迹上的朝向。值 `orientationType` 定义其应解释为相对于项目特定全局地图坐标系，还是相对于边轨迹的切向。在“相对于轨迹切向”的情况下，`0.0` 表示向前行驶，`Pi` 表示倒车行驶。<br>示例：朝向 `Pi/2 rad` 可能导致 90 度旋转。<br><br>如果移动机器人起始朝向不同，且 `reachOrientationBeforeEntering` 为 `"false"`，则可在边上旋转到所需朝向。<br>如果 `reachOrientationBeforeEntering` 为 `"true"`，则必须在进入边之前旋转。<br>如果无法做到，则该订单应被拒绝。<br><br>若未定义轨迹，则应将该朝向及相应旋转应用于连接该边两端节点的直接路径。<br>若未定义朝向，则移动机器人可在边上采用任意朝向。
*orientationType* | | string | Enum {'GLOBAL', 'TANGENTIAL'}：<br>`'GLOBAL'`：相对于项目特定全局地图坐标系，仅适用于全向移动机器人。<br>`'TANGENTIAL'`：相对于边轨迹的切向。示例：对全向移动机器人，任意朝向都可能可行；对差速驱动移动机器人，则通常只有 `0.0`（前进）和 `Pi`（后退）可能可行。<br><br>默认值：`'TANGENTIAL'`。
*direction* | | string | 用于物理线路引导型移动机器人在路口设定方向，可能取值应预先定义（与机器人相关）。<br>例如：`"left"`、`"right"`、`"straight"`、`"580 Hz"`。
*reachOrientationBeforeEntering* | | boolean | 该参数仅对全向移动机器人有效。`"true"`：进入边之前必须达到所需朝向。<br>`"false"`：移动机器人可在边上旋转到所需朝向。<br>默认值：`"false"`。
*maximumRotationSpeed* | rad/s | float64 | 最大旋转速度。<br><br>可选：<br>若未设置，则表示无限制。
***trajectory*** | | JSON object | 该边对应的 NURBS 轨迹对象。<br>定义移动机器人从起始节点到终止节点期间应沿其运动的路径。<br><br>可选：<br>若移动机器人无法处理轨迹，或其自行规划轨迹，则可省略。
*length* | m | float64 | 从起始节点到终止节点的路径长度。<br><br>可选：<br>线路引导型移动机器人可利用该值在到达停止位置前进行减速。
***corridor*** | | JSON object | 定义移动机器人可偏离轨迹的边界，例如用于避障。<br>
**actions [action]**<br><br><br> } | | array | 在该边上要执行的动作数组。<br>若无需动作，则为空数组。<br>由边触发的动作仅在移动机器人处于触发该动作的边上时有效。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**trajectory** { | | JSON object |  |
*degree* | | uint32 | 定义轨迹的 NURBS 曲线阶数。<br><br>范围：`[1 ... uint32.max]`<br>默认值：`1`
***knotVector [float64]*** | | array | NURBS 的节点向量（knot vector）数组。<br>`knotVector` 的长度应恰好比 `controlPoints` 长度大 `degree + 1`。<br>首尾节点的重数都必须为 `degree + 1`（钳制型 NURBS）。<br>除首尾之外的节点重数不得大于 `degree`（连续性要求）。<br><br>节点取值范围：`[0.0 ... 1.0]`<br>默认值：从 `0.0` 到 `1.0` 的等距节点，其中首尾节点重数为 `degree + 1`，其余节点重数为 `1`（均匀节点）。
**controlPoints [controlPoint]** | | array | 定义 NURBS 控制点（control point）的 `controlPoint` 对象数组，显式包含起点和终点（钳制型 NURBS）。<br>控制点数量至少应为 `degree + 1`。
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**controlPoint** { | | JSON object |  |
x | m | float64 | 项目特定坐标系中的 X 坐标。
y | m | float64 | 项目特定坐标系中的 Y 坐标。
*weight* | | float64 | 控制点在曲线上的权重。<br><br>范围：`]0.0 ... float64.max]`<br>默认值：`1.0`
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
***corridor*** { | | JSON object |  |
leftWidth | m | float64 | 范围：`[0.0 ... float64.max]`<br>定义相对于移动机器人轨迹左侧的走廊宽度，单位米（见图 10）。
rightWidth | m | float64 | 范围：`[0.0 ... float64.max]`<br>定义相对于移动机器人轨迹右侧的走廊宽度，单位米（见图 10）。
*corridorReferencePoint* | | string | 定义这些边界是作用于移动机器人的运动学中心，还是作用于移动机器人轮廓。若未指定，则默认对移动机器人的运动学中心有效。<br>Enum { 'KINEMATIC_CENTER' , 'CONTOUR' }
*releaseRequired* | | boolean | 可选标志，表示机器人是否必须向车队控制系统请求批准。<br>默认值：`"false"`。
*releaseLossBehavior* <br> } | | string | Enum { 'STOP' , 'RETURN' }<br>定义当走廊授权到期，或车队控制系统撤销授权时，机器人应如何行为。<br>`'STOP'`：移动机器人停止并等待人工干预。`'RETURN'`：移动机器人沿其偏离路径返回该边的预定义轨迹。<br>默认值：`'STOP'`。

<a id="731-format-of-action-parameters"></a>
### 7.3.1 动作参数格式

错误、信息和动作的参数均设计为一个 JSON 对象数组，采用键值对形式。

| **字段** | **数据类型** | **描述** |
|---|---|---|
**actionParameter** { | JSON object | 指定动作的参数，例如 `deviceId`、`loadId`、外部触发器等。 |
key | string | 参数的键。 |
value <br><br><br>} | 以下之一：<br>array,<br>boolean,<br>number,<br>integer,<br>string,<br>object | 与该键对应的值。 |

以下是动作 `"someAction"` 的 `actionParameter` 示例，其中包含 `stationType`、`weight` 和 `loadType` 等键值对：

```json
"actionParameters":[
  {"key":"stationType", "value": "floor"},
  {"key":"weight", "value": 8.5},
  {"key":"loadType", "value": "pallet_eu"}
]
```

之所以采用 `"key": "actualKey", "value": "actualValue"` 这种结构，是为了保持实现的通用性。  
其中 `"actualValue"` 可以是任何 JSON 数据类型，例如数组、布尔值、整数、数字、字符串，甚至对象。

<a id="74-implementation-of-the-instantaction-message"></a>
## 7.4 `instantAction` 消息实现

对象结构 | 数据类型 | 描述
---|---|---
headerId | uint32 | 消息头 ID。<br>该 ID 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。
timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。
manufacturer | string | 移动机器人制造商。
serialNumber | string | 移动机器人序列号。
**actions [action]** | array | 需要立即执行且不属于常规订单的一组动作。

对象 `action` 的定义见 [7.3 `order` 消息实现](#73-implementation-of-the-order-message)。

<a id="75-implementation-of-the-response-message"></a>
## 7.5 `response` 消息实现

对象结构/标识符 | 数据类型 | 描述
| --- | --- | --- |
| headerId | uint32 | 消息头 ID。<br>`headerId` 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。 |
| timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。 |
| version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。 |
| manufacturer | string | 移动机器人制造商。 |
| serialNumber | string | 移动机器人序列号。 |
| **responses[response]** | array | 响应对象数组。 |

对象结构/标识符 | 数据类型 | 描述
| --- | --- | --- |
| response <br> { | JSON object | 包含车队控制系统对某一特定请求答复的对象。 |
| requestId | string | 在单个移动机器人当前所有活动请求范围内唯一的标识。 |
| grantType | enum | Enum {'GRANTED','QUEUED','REVOKED','REJECTED'}<br>`'GRANTED'`：车队控制系统已批准请求。`'REVOKED'`：车队控制系统撤销先前批准的请求。`'REJECTED'`：车队控制系统拒绝该请求。`'QUEUED'`：确认已收到移动机器人的请求，但尚未授予权限，请求已加入某种队列。 |
| *leaseExpiry* <br><br> } | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。只有在批准请求的响应中，才应发送该到期时间。 |

<a id="76-implementation-of-the-zoneset-message"></a>
## 7.6 `zoneSet` 消息实现

对象结构 | 数据类型 | 描述
---|---|---
headerId | uint32 | 消息头 ID。<br>该 ID 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。
timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。
manufacturer | string | 移动机器人制造商。
serialNumber | string | 移动机器人序列号。
**zoneSet** | JSON object | 区域集（zone set）。

| 对象结构 | 数据类型 | 描述 |
| --- | --- | --- |
| zoneSet { | JSON object | 描述某张特定地图的区域集（zone set）。 |
| mapId | string | 被该区域集细化描述的地图的全局唯一标识。 |
| zoneSetId | string | 区域集的全局唯一标识。 |
| *zoneSetDescriptor* | string | 用户定义、可读的名称或描述。不得用于逻辑处理。 |
| **zones[zone]** <br> } | array | 区域对象数组。 |

单个区域对象结构如下：

| **对象结构** | **数据类型** | **描述** |
| --- | --- | --- |
| zone { | JSON object |  |
| zoneId | string | 在该区域集内部局部唯一的标识。 |
| zoneType | string | Enum {'BLOCKED', 'LINE_GUIDED', 'RELEASE', 'COORDINATED_REPLANNING', 'SPEED_LIMIT', 'ACTION', 'PRIORITY', 'PENALTY', 'DIRECTED', 'BIDIRECTED'}，区域类型定义见 [6.4.1 区域类型](#641-zone-types)。 |
| *zoneDescriptor* | string | 用户定义、可读的名称或描述。不得用于逻辑处理。 |
| **vertices[vertex]** | array | 以逆时针方向定义区域几何形状的顶点数组。 |
| *maximumSpeed* | float64 | 仅对 `SPEED_LIMIT` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| ***entryActions[zoneAction]*** | array | 仅对 `ACTION` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| ***duringActions[zoneAction]*** | array | 仅对 `ACTION` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| ***exitActions[zoneAction]*** | array | 仅对 `ACTION` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| *releaseLossBehavior* | string | 仅对 `RELEASE` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| *priorityFactor* | float64 | 仅对 `PRIORITY` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| *penaltyFactor* | float64 | 仅对 `PENALTY` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| *direction* | float64 | 仅对 `DIRECTED` 和 `BIDIRECTED` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| *directedLimitation* | string | 仅对 `DIRECTED` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| *bidirectedLimitation* | string | 仅对 `BIDIRECTED` 区域必填，见 [6.4.1 区域类型](#641-zone-types)。 |
| } | | |

`zoneAction` 遵循与 `action` 相同的结构，不同之处在于 `actionId` 由移动机器人自行生成。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**zoneAction** { | | JSON object | 描述移动机器人可以执行的动作。
actionType | | string | 动作名称，定义见“动作与参数”第一列。<br>用于标识动作功能。
*actionDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
blockingType | | string | Enum {'NONE', 'SINGLE', 'SOFT', 'HARD'}：<br>`'NONE'`：允许行驶，也允许其他动作；<br>`'SINGLE'`：允许行驶，但不允许其他动作；<br>`'SOFT'`：允许其他动作，但不允许行驶；<br>`'HARD'`：此时唯一允许执行的动作。
***actionParameters [actionParameter]*** | | array | 该动作的参数对象数组，例如 `"deviceId"`、`"loadId"`、外部触发器等。<br><br>示例实现见 [7.3.1 动作参数格式](#731-format-of-action-parameters)。
*retriable* <br> } | | boolean | `"true"`：动作失败时可进入 `RETRIABLE` 状态。<br>`"false"`：动作失败后直接进入 `FAILED` 状态。<br>默认值：`"false"`。

每个区域对象的形状通过多边形定义，并通过其顶点传输。  
顶点少于 3 个的区域无效，应被拒绝。  
多边形被视为闭合。  
只允许使用简单多边形（即不存在自交）。  
定义区域的顶点数组以项目特定全局坐标系中的 `x-y` 元组列表形式给出，按逆时针顺序排列：

| **对象结构** | **数据类型** | **描述** |
| --- | --- | --- |
| vertex { | JSON object |  |
| x | float64 | 项目特定坐标系中的 X 坐标。 |
| y <br> } | float64 | 项目特定坐标系中的 Y 坐标。 |

<a id="77-implementation-of-the-connection-message"></a>
## 7.7 `connection` 消息实现

标识符 | 数据类型 | 描述
---|---|---
headerId | uint32 | 消息头 ID。<br>`headerId` 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。
timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。
manufacturer | string | 移动机器人制造商。
serialNumber | string | 移动机器人序列号。
connectionState | string | Enum {'ONLINE', 'OFFLINE', 'HIBERNATING', 'CONNECTION_BROKEN'}<br><br>`'ONLINE'`：移动机器人与 broker 的连接处于活动状态。<br><br>`'OFFLINE'`：移动机器人与 broker 的连接以协调方式离线。<br><br>`'HIBERNATING'`：移动机器人进入低功耗状态并停止发送状态消息，但与 MQTT broker 的连接仍保持活动。此模式适用于节能或减少通信。移动机器人之后可在被指示时，或通过配置的唤醒机制切换回 `ONLINE`。<br><br>`'CONNECTION_BROKEN'`：移动机器人与 broker 的连接意外中断。 |

<a id="78-implementation-of-the-state-message"></a>
## 7.8 `state` 消息实现

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
headerId | | uint32 | 消息头 ID。<br>`headerId` 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。
timestamp | | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
version | | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。
manufacturer | | string | 移动机器人制造商。
serialNumber | | string | 移动机器人序列号。
***maps[map]*** | | array | 当前存储在移动机器人上的地图对象数组。
***zoneSets[zoneSet]*** | | array | 当前存储在移动机器人上的区域集对象数组。
orderId | | string | 当前订单或最近已完成订单的唯一标识。<br>该 `orderId` 会保留，直到收到新订单。<br>若不存在历史 `orderId`，则为空字符串 `("")`。
orderUpdateId | | uint32 | 订单更新标识，用于表明移动机器人已接受某个订单更新。<br>若不存在历史 `orderUpdateId`，则为 `"0"`。
lastNodeId | | string | 最近到达节点的 ID；如果移动机器人当前就在某个节点上，则为当前节点 ID（例如 `"node7"`）。若没有可用的 `lastNodeId`，则为空字符串 `("")`。
lastNodeSequenceId | | uint32 | 最近到达节点的 `sequenceId`；如果移动机器人当前就在某个节点上，则为当前节点的 `sequenceId`。<br>仅当 `lastNodeId` 非空时该值才有效。若 `lastNodeId` 为空字符串，则 `lastNodeSequenceId` 的值可以任意，应被忽略。
**nodeStates [nodeState]** | | array | 为完成订单尚需通过的 `nodeState` 对象数组。<br>空闲时为空数组。
**edgeStates [edgeState]** | | array | 为完成订单尚需通过的 `edgeState` 对象数组。<br>空闲时为空数组。
***plannedPath*** | | JSON object | 以 NURBS 表示机器人当前活动订单中的一条路径。
***intermediatePath*** | | JSON object | 表示机器人可通过传感器感知的较近关键点的预计到达时间。
***mobileRobotPosition*** | | JSON object | 移动机器人在地图上的当前位置。<br><br>可选：仅对不具备自定位能力的移动机器人（例如线路引导型移动机器人）可省略。
***velocity*** | | JSON object | 移动机器人的速度，使用其自身坐标系表示。
***loads [load]*** | | array | 当前由移动机器人搬运的载荷。<br><br>可选：如果移动机器人无法判断载荷状态，则应完全省略该字段，而不是报告为空数组。<br>如果移动机器人能够判断载荷状态，但数组为空，则表示该机器人当前无载荷。
driving | | boolean | `"true"`：表示移动机器人正在行驶（手动或自动）。其他运动（例如举升动作）不包含在内。<br>`"false"`：表示移动机器人当前未行驶。
*paused* | | boolean | `"true"`：移动机器人当前处于暂停状态，原因可能是物理按钮被按下，或收到即时动作。<br>移动机器人可以恢复订单。<br><br>`"false"`：移动机器人当前不处于暂停状态。
*newBaseRequest* | | boolean | `"true"`：移动机器人即将到达已释放段（Base）的末端，如未收到新的已释放段，将开始减速。<br>用于触发车队控制系统发送新的已释放段。<br><br>`"false"`：无需更新已释放段。
***zoneRequests [zoneRequest]*** | | array | 当前在移动机器人上处于活动状态的 `zoneRequest` 对象数组。<br>若无活动区域请求，则为空数组。
***edgeRequests [edgeRequest]*** | | array | 当前在移动机器人上处于活动状态的 `edgeRequest` 对象数组。<br>若无活动边请求，则为空数组。
*distanceSinceLastNode* | m | float64 | 线路引导型移动机器人用于表示自 `lastNodeId` 以来已行驶的距离。<br>单位米。
**actionStates [actionState]** | | array | 包含当前订单中全部动作的状态数组。只要订单仍然处于活动状态，这些动作状态就会被保留；接受新订单时会被清除。<br>这其中也可能包含前面节点上仍在进行中的动作。<br><br>当动作完成时，会发布新的状态消息，其中 `actionStatus` 设为 `'FINISHED'`，如适用则带有相应的 `resultDescription`。
**instantActionStates [actionState]** | | array | 移动机器人收到过的全部即时动作状态数组。即时动作会一直保留在状态消息中，直到执行动作 `clearInstantActions`。如果该列表过长导致难以管理，机器人可以抛出错误类型 `'INSTANT_ACTION_STATES_FULL'`，错误级别 `'URGENT'`。建议车队控制系统在实际条件允许时尽快清空此列表。
***zoneActionStates [actionState]*** | | array | 所有区域动作中，已处于结束状态或当前正在运行的动作状态数组；是否共享即将执行的动作是可选的。区域动作状态会一直保留在状态消息中，直到执行动作 `clearZoneActions`。如果支持动作区域，则该字段为必填。若列表过长难以管理，机器人可以抛出错误类型 `'ZONE_ACTION_STATES_FULL'`，错误级别 `'URGENT'`。建议车队控制系统在实际条件允许时尽快清空此列表。
**powerSupply** | | JSON object | 包含所有与供电相关的信息。
operatingMode | | string | Enum {'STARTUP', 'AUTOMATIC', 'SEMIAUTOMATIC', 'INTERVENED', 'MANUAL', 'SERVICE', 'TEACH_IN'}<br>更多信息见 [6.6.6 运行模式](#666-operating-mode)。
**errors [error]** | | array | 错误对象数组。<br>移动机器人所有活动错误都应包含在该数组中。<br>空数组表示移动机器人当前没有活动错误。
***information [info]*** | | array | 信息对象数组。<br>空数组表示移动机器人当前没有信息。<br>仅应将其用于可视化或调试，不得被车队控制系统用于业务逻辑。
**safetyState** | | JSON object | 包含所有与安全相关的信息。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**map** { | | JSON object |  |
mapId | | string | 描述移动机器人工作空间某一区域的地图 ID。
mapVersion | | string | 地图版本。
mapStatus | | string | Enum {'ENABLED', 'DISABLED'}<br>`'ENABLED'`：表示该地图当前正在移动机器人上被主动使用。对于同一 `mapId`，最多只能有一个版本的状态为 `'ENABLED'`。<br>`'DISABLED'`：表示该地图版本当前未在移动机器人上启用，因此可被请求启用或删除。
*mapDescriptor* <br> } | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**zoneSet** { | | JSON object |  |
zoneSetId | | string | 当前为该地图启用的区域集唯一标识。<br>仅当移动机器人对对应地图没有定义任何区域时，该字段才可以为空。
mapId | | string | 对应地图的标识。
zoneSetStatus <br> } | | string | Enum {ENABLED, DISABLED}<br>`'ENABLED'`：表示该区域集当前在移动机器人上被主动使用。对于每个地图，最多只有一个区域集状态可以为 `'ENABLED'`。<br>`'DISABLED'`：表示该区域集当前未启用，因此可被车队控制系统请求启用或删除。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**nodeState** { | JSON object |  |
nodeId | | string | 节点唯一标识。<br>同一个节点可以在同一条状态消息中被引用多次。通过 `sequenceId` 区分遍历顺序。
sequenceId | | uint32 | 节点的 `sequenceId`，用于区分具有相同 `nodeId` 的多个节点。
*nodeDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
released | | boolean | `"true"` 表示该节点属于已释放段（Base）。<br>`"false"` 表示该节点属于前瞻段（Horizon）。
***nodePosition*** <br><br> } | | JSON object | 节点位置。<br>可选：车队控制系统已经掌握该信息；也可以额外发送，例如用于调试。

对象结构 | 单位 | 数据类型 | 描述
---| --- |--- | ---
**nodePosition** { | | JSON object | 定义项目特定坐标系中的地图位置。<br>每一层楼都有自己的地图。<br>所有地图应使用同一个项目特定全局原点。
x | m | float64 | 地图中的 X 坐标，参照项目特定坐标系。<br>精度取决于具体实现。
y | m | float64 | 地图中的 Y 坐标，参照项目特定坐标系。<br>精度取决于具体实现。
*theta* | rad | float64 | 范围：`[-Pi ... Pi]`<br><br>移动机器人在节点上被视为已通过时应匹配的绝对朝向。<br>可选：移动机器人也可以自行规划路径。<br>如果定义了该值，移动机器人应在该节点满足对应角度。<br>如果前一条边不允许旋转，则移动机器人应在节点上旋转。<br>如果后一条边定义了不同朝向且不允许旋转，则移动机器人应在进入该边前于节点上旋转到该朝向。
mapId | | string | 引用该位置所对应地图的唯一标识。<br>每张地图都使用同一个项目特定全局坐标原点。<br>例如当移动机器人通过电梯从出发楼层到目标楼层时，它会从出发楼层地图中消失，并在目标楼层地图的相应电梯节点上出现。
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**edgeState** { | | JSON object |  |
edgeId | | string | 边唯一标识。<br>同一条边可以在同一条状态消息中被引用多次。通过 `sequenceId` 区分遍历顺序。
sequenceId | | uint32 | 边的 `sequenceId`，用于区分具有相同 `edgeId` 的多个边。
*edgeDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
released | | boolean | `"true"` 表示该边属于已释放段（Base）。<br>`"false"` 表示该边属于前瞻段（Horizon）。
***trajectory*** <br><br> } | | JSON object | 报告在布局中预先定义，或作为订单一部分发送给该边的轨迹。<br><br>轨迹以 NURBS 形式通信，定义见 [7.3 `order` 消息实现](#73-implementation-of-the-order-message)。<br><br>轨迹段从移动机器人进入该边的位置开始，到移动机器人报告终止节点已通过的位置结束。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**plannedPath** { | | JSON object |  |
**trajectory** | | JSON object | 轨迹以 NURBS 形式通信，其定义见 [7.3 `order` 消息实现](#73-implementation-of-the-order-message)。 |
***traversedNodes[nodeId]*** | | array | 一个 `nodeId` 数组，表示在当前共享的规划路径中将被通过、且已在当前执行订单中通信过的节点。 |
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**trajectory** { | | JSON object |  |
*degree* | | uint32 | 定义轨迹的 NURBS 曲线阶数。<br><br>范围：`[1 ... uint32.max]`<br>默认值：`1`
***knotVector [float64]*** | | array | NURBS 的节点向量（knot vector）数组。<br>`knotVector` 的长度应恰好比 `controlPoints` 长度大 `degree + 1`。<br>首尾节点的重数都必须为 `degree + 1`（钳制型 NURBS）。<br>除首尾之外的节点重数不得大于 `degree`（连续性要求）。<br><br>节点取值范围：`[0.0 ... 1.0]`<br>默认值：从 `0.0` 到 `1.0` 的等距节点，其中首尾节点重数为 `degree + 1`，其余节点重数为 `1`（均匀节点）。
**controlPoints [controlPoint]** | | array | 定义 NURBS 控制点（control point）的 `controlPoint` 对象数组，显式包含起点和终点（钳制型 NURBS）。<br>控制点数量至少应为 `degree + 1`。
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**controlPoint** { | | JSON object |  |
x | m | float64 | 项目特定坐标系中的 X 坐标。
y | m | float64 | 项目特定坐标系中的 Y 坐标。
*weight* | | float64 | 控制点在曲线上的权重。<br><br>范围：`]0.0 ... float64.max]`<br>默认值：`1.0`
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**intermediatePath** { | | JSON object |  |
**polyline[waypoint]** | | array | 折线（polyline）端点数组。 |
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**waypoint** { | | JSON object | 已定义折线中的路径点（waypoint）。
x | m | float64 | 项目特定坐标系中的 X 坐标。
y | m | float64 | 项目特定坐标系中的 Y 坐标。
*theta* | rad | float64 | 移动机器人在项目特定坐标系中的绝对朝向。<br>范围：`[-Pi ... Pi]`
eta | | string | 预计到达/通过时间。`ETA` 格式与 `timestamp` 相同（ISO 8601，UTC）；`YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**mobileRobotPosition** { | | JSON object | 定义地图上的当前位置，使用项目特定坐标系。每一层楼都有自己的地图。
x | m | float64 | 地图中的 X 坐标，参照项目特定坐标系。<br>精度取决于具体实现。
y | m | float64 | 地图中的 Y 坐标，参照项目特定坐标系。<br>精度取决于具体实现。
theta | | float64 | 范围：`[-Pi ... Pi]`<br><br>移动机器人的朝向。
mapId | | string | 引用该位置所属地图的唯一标识。<br><br>每张地图都使用相同原点。<br>当移动机器人通过电梯从出发楼层到目标楼层时，它会离开出发楼层地图，并在目标楼层地图的对应电梯节点上出现。
localized | | boolean | `"true"`：移动机器人已定位，`x`、`y` 和 `theta` 可被信任。<br>`"false"`：移动机器人未定位，`x`、`y` 和 `theta` 不可被信任。<br>只有在移动机器人已经无法确定位置时，才应将该状态切换为 `"false"`。移动机器人应通过错误（`errorType = 'LOCALIZATION_ERROR'`，`errorLevel = 'FATAL'`）报告该状态。当该字段为 `"false"` 时，移动机器人不得恢复自动行驶，也不得继续执行订单。
*localizationScore* | | float64 | 范围：`[0.0 ... 1.0]`<br>描述定位质量，因此可供例如 SLAM 移动机器人表示当前位置的可信程度。<br>`0.0`：最低可信度。<br>`1.0`：最高可信度。<br>仅用于日志和可视化。
*deviationRange* | m | float64 | 位置偏差范围，单位米。<br>仅用于日志和可视化。
} | | |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**velocity** { | | JSON object |  |
*vx* | m/s | float64 | 移动机器人在其 X 方向上的速度。
*vy* | m/s | float64 | 移动机器人在其 Y 方向上的速度。
*omega* <br> } | rad/s | float64 | 移动机器人绕其 Z 轴的角速度。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**load** { | | JSON object |  |
*loadId* | | string | 载荷唯一标识（例如条码或 RFID）。<br><br>若移动机器人可识别载荷，但尚未完成识别，则该字段可为空。<br><br>若移动机器人无法识别载荷，则该字段为可选。
*loadType* | | string | 载荷类型。
*loadPosition* | | string | 指示移动机器人使用的是哪个载荷处理/承载单元，例如在机器人拥有多个承载位置时。<br><br>例如：`"front"`、`"back"`、`"positionC1"` 等。<br><br>对于仅有一个 `loadPosition` 的移动机器人，该字段为可选。
***boundingBoxReference*** | | JSON object | 用于描述包围盒位置的参考点。<br>该参考点始终为包围盒底面的中心点（`height = 0`），并使用移动机器人坐标系表示。
***loadDimensions*** | | JSON object | 载荷包围盒的尺寸，单位米。
*weight* <br> } | kg | float64 | 范围：`[0.0 ... float64.max]`<br><br>以千克为单位的载荷绝对重量。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**boundingBoxReference** { | | JSON object | 用于描述包围盒位置的参考点。<br>该参考点始终为包围盒底面的中心点（`height = 0`），并使用移动机器人坐标系表示。
x | | float64 | 参考点的 X 坐标。
y | | float64 | 参考点的 Y 坐标。
z | | float64 | 参考点的 Z 坐标。
*theta* <br> } | | float64 | 载荷包围盒的朝向。<br>对牵引车、拖车列等场景尤其重要。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**loadDimensions** { | | JSON object | 载荷包围盒尺寸，单位米。
length | m | float64 | 载荷包围盒的绝对长度（沿移动机器人坐标系 x 轴）。
width | m | float64 | 载荷包围盒的绝对宽度（沿移动机器人坐标系 y 轴）。
*height* <br> } | m | float64 | 载荷包围盒的绝对高度。<br><br>可选：仅在已知时设置该值。

| **对象结构** | **数据类型** | **描述** |
| --- | --- | --- |
| zoneRequest <br> { | JSON object | 由移动机器人发送给车队控制系统的请求信息。 |
| requestId | string | 在单个移动机器人当前所有活动请求范围内唯一的标识。 |
| requestType | string | Enum {'ACCESS', 'REPLANNING'}<br>指定该请求所关联的区域请求类型。可取值为 `'ACCESS'` 或 `'REPLANNING'`。 |
| zoneId | string | 在区域集内部局部唯一的区域标识，表示该请求对应的区域。 |
| zoneSetId | string | 由于 `zoneId` 仅在某个 `zoneSet` 内唯一，因此 `zoneSetId` 也是请求的一部分。 |
| requestStatus | string | Enum {'REQUESTED', 'GRANTED', 'REVOKED', 'EXPIRED'}<br>提出请求时设为 `'REQUESTED'`。收到车队控制系统响应或更新后设为 `'GRANTED'` 或 `'REVOKED'`。若租约过期，则设为 `'EXPIRED'`。 |
| ***trajectory*** <br> } | object | 仅对 `'COORDINATED_REPLANNING'` 请求可选，用于携带穿越该区域的规划轨迹。 |

| **对象结构** | **数据类型** | **描述** |
| --- | --- | --- |
| edgeRequest <br> { | JSON object | 由移动机器人发送给车队控制系统的请求信息。 |
| requestId | string | 在单个移动机器人当前所有活动请求范围内唯一的标识。 |
| requestType | enum | Enum {'CORRIDOR'}<br>指定请求类型。若请求在定义工作空间内偏离预定义轨迹，则该值设为 `CORRIDOR`。 |
| edgeId | string | 全局唯一的边标识，表示该请求所关联的边。 |
| sequenceId | uint32 | 订单中边的序号，用于唯一标识该订单中引用的边。 |
| requestStatus <br><br> } | enum | Enum {'REQUESTED', 'GRANTED', 'REVOKED', 'EXPIRED'}<br>提出请求时设为 `'REQUESTED'`。收到车队控制系统响应或更新后设为 `'GRANTED'` 或 `'REVOKED'`。若租约过期，则设为 `'EXPIRED'`。 |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**actionState** { | | JSON object |  |
actionId | | string | 动作唯一标识。
*actionType* | | string | 动作类型。<br><br>可选：仅用于信息展示或可视化。车队控制系统已经知道订单中下发的动作类型。
*actionDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
actionStatus | | string | Enum {'WAITING', 'INITIALIZING', 'RUNNING', 'PAUSED', 'RETRIABLE', 'FINISHED', 'FAILED'}<br><br>见 [6.6.9 动作状态](#669-action-states)。
*actionResult* <br> } | | string | 动作结果描述，例如 RFID 读取结果。<br><br>错误将通过 `errors` 传输。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**powerSupply** { | | JSON object |  |
stateOfCharge | % | float64 | 范围：`[0 ... 100]`<br><br>移动机器人的电量百分比。对于永久供电型移动机器人，该字段应为 `100`。
*batteryVoltage* | V | float64 | 电池电压。
*batteryCurrent* | A | float64 | 电池电流。
*batteryHealth* | % | int8 | 范围：`[0 ... 100]`<br><br>描述电池健康状态。
charging | | boolean | `"true"`：正在充电。<br>`"false"`：移动机器人当前未充电。仅当机器人可接受订单时，才应报告为 `"false"`。
*range* <br> } | m | uint32 | 范围：`[0 ... uint32.max]`<br><br>按照当前电量状态估算的可行驶距离。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**error** { | | JSON object |  |
errorType | | string | 错误类型，可扩展枚举，包括如下预定义值：<br>Enum {'UNSUPPORTED_PARAMETER', 'NO_ORDER_TO_CANCEL', 'VALIDATION_FAILURE', 'INVALID_ORDER', 'OUTDATED_ORDER_UPDATE', 'SAME_ORDER_UPDATE_ID', 'ORDER_UPDATE_FOLLOWING_CANCEL', 'OUTSIDE_OF_CORRIDOR', 'DUPLICATE_MAP', 'DUPLICATE_ZONE_SET', 'BLOCKED_ZONE_VIOLATION', 'RELEASE_LOST', 'ZONE_ACTION_CONFLICT', 'NODE_UNREACHABLE', 'LOCALIZATION_ERROR', 'UNKNOWN_MAP_ID', ...}。
***errorReferences [errorReference]*** | | array | 引用数组（例如 `nodeId`、`edgeId`、`orderId`、`actionId` 等），用于提供与错误相关的更多信息。
*errorDescription* | | string | 详细描述，说明错误细节及可能原因。
***errorDescriptionTranslations[translation]*** | | array | 错误描述的翻译数组。若某语言未包含在该集合中，则默认使用 `errorDescription` 字段的值（如果存在）。
*errorHint* | | string | 关于如何处理或解决该错误的提示。
***errorHintTranslations[translation]*** | | array | 错误提示的翻译数组。若某语言未包含在该集合中，则默认使用 `errorHint` 字段的值（如果存在）。
errorLevel <br> } | | string | Enum {'WARNING', 'URGENT', 'CRITICAL', 'FATAL'}<br><br>`'WARNING'`：无需立即处理；移动机器人仍可继续当前活动订单（如有），并接受订单更新或新订单。<br>`'URGENT'`：需要立即处理；移动机器人仍可继续当前活动订单（如有），并接受订单更新或新订单。<br>`'CRITICAL'`：需要立即处理；移动机器人无法继续当前活动订单，但仍可接受新订单。<br>`'FATAL'`：需要人工干预；移动机器人既无法继续当前活动订单，也无法接受订单更新或新订单。 |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**errorReference** { | | JSON object |  |
referenceKey | | string | 指明引用类型（例如 `nodeId`、`edgeId`、`orderId`、`actionId` 等）。
referenceValue <br> } | | string | 与该引用键对应的值。例如发生错误的节点 ID。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**translation** { | | JSON object |  |
translationKey | | string | 按 ISO 639-1 指定翻译语言的语言代码。
translationValue <br> } | | string | `translationKey` 所对应语言的翻译文本。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**info** { | | JSON object |  |
infoType | | string | 信息类型/名称。
*infoReferences [infoReference]* | | array | 引用数组。
*infoDescriptor* | | string | 用户定义、可读的名称或描述。不得用于逻辑处理。
infoLevel <br> } | | string | Enum {'DEBUG', 'INFO'}<br><br>`'DEBUG'`：用于调试。<br>`'INFO'`：用于可视化。 |

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**infoReference** { | | JSON object |  |
referenceKey | | string | 指明引用类型（例如 `headerId`、`orderId`、`actionId` 等）。
referenceValue <br> } | | string | 与该引用键对应的值。

对象结构 | 单位 | 数据类型 | 描述
---|---|---|---
**safetyState** { | | JSON object |  |
activeEmergencyStop | | string | Enum {'MANUAL', 'REMOTE', 'NONE'}<br><br>定义当前被激活的急停类型：<br>`'MANUAL'`：急停必须在移动机器人本体上手动确认。<br>`'REMOTE'`：设施级急停应远程确认。<br>`'NONE'`：当前没有急停被激活。
fieldViolation <br> } | | boolean | 防护区域被触发（例如被激光扫描器或保险杠触发）。<br>`"true"`：防护区域被触发。<br>`"false"`：防护区域未被触发。 |

<a id="79-implementation-of-the-visualization-message"></a>
## 7.9 `visualization` 消息实现

| **字段** | **数据类型** | **描述** |
| --- | --- | --- |
| headerId | uint32 | 消息头 ID。<br>`headerId` 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。 |
| timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。 |
| version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。 |
| manufacturer | string | 移动机器人制造商。 |
| serialNumber | string | 移动机器人序列号。 |
| referenceStateHeaderId | uint32 | 该 `visualization` 消息所对应的 `state` 消息的头 ID。 |
| ***plannedPath*** | JSON object | 以 NURBS 表示机器人当前活动订单中的一条路径。 |
| ***intermediatePath*** | JSON object | 表示机器人可通过传感器感知的较近关键点的预计到达时间。 |
| ***mobileRobotPosition*** | JSON object | 移动机器人在地图上的当前位置。 |
| ***velocity*** | JSON object | 使用移动机器人自身坐标系表示的速度。 |

对象 `plannedPath`、`intermediatePath`、`mobileRobotPosition` 和 `velocity` 的定义见 [7.8 `state` 消息实现](#78-implementation-of-the-state-message)。

<a id="710-implementation-of-the-factsheet-message"></a>
## 7.10 参数说明表（`factsheet`）消息实现

| **字段** | **数据类型** | **描述** |
| --- | --- | --- |
| headerId | uint32 | 消息头 ID。<br>`headerId` 按 Topic 分别定义，每发送一条消息（不要求一定被接收），其值加 1。 |
| timestamp | string | 时间戳（ISO 8601，UTC）；格式 `YYYY-MM-DDTHH:mm:ss.fffZ`（例如 `"2017-04-15T11:40:03.123Z"`）。 |
| version | string | 协议版本 `[Major].[Minor].[Patch]`（例如 `1.3.2`）。 |
| manufacturer | string | 移动机器人制造商。 |
| serialNumber | string | 移动机器人序列号。 |
| **typeSpecification** | JSON object | 这些参数总体上描述移动机器人类别及其能力。 |
| **physicalParameters** | JSON object | 这些参数描述移动机器人的基础物理属性。 |
| **protocolLimits** | JSON object | MQTT 通信中标识符、数组、字符串等长度限制。 |
| **protocolFeatures** | JSON object | VDA5050 协议支持的功能特性。 |
| **mobileRobotGeometry** | JSON object | 移动机器人几何形状的详细定义。 |
| **loadSpecification** | JSON object | 载荷能力的抽象描述。 |
| ***mobileRobotConfiguration*** | JSON object | 移动机器人当前软硬件版本的摘要，以及可选的网络信息。 |

#### typeSpecification

该 JSON 对象描述移动机器人型号的一般属性。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| seriesName | string | 制造商指定的系列通用名称，自由文本。 |
| *seriesDescription* | string | 对该移动机器人系列的人类可读描述，自由文本。 |
| mobileRobotKinematics | string | 对移动机器人运动学类型的简化描述。<br>可扩展枚举：{'DIFFERENTIAL', 'OMNIDIRECTIONAL', 'THREE_WHEEL', ...}<br>`'DIFFERENTIAL'`：差速驱动，<br>`'OMNIDIRECTIONAL'`：全向移动机器人，<br>`'THREE_WHEEL'`：三轮驱动移动机器人或具有类似运动学特征的机器人。 |
| mobileRobotClass | string | 对移动机器人类别的简化描述。<br>可扩展枚举：{FORKLIFT, CONVEYOR, TUGGER, CARRIER, ...}<br>`FORKLIFT`：叉车，<br>`CONVEYOR`：带输送装置的移动机器人，<br>`TUGGER`：牵引车，<br>`CARRIER`：带或不带举升装置的载货车。 |
| maximumLoadMass | float64 | [kg] 最大可装载质量。 |
| localizationTypes | array of string | 对定位类型的简化描述。<br>可扩展枚举：{'NATURAL', 'REFLECTOR', 'RFID', 'DMC', 'SPOT', 'GRID', ...}<br>`NATURAL`：自然地标，<br>`REFLECTOR`：激光反射板，<br>`RFID`：RFID 标签，<br>`DMC`：Data Matrix 码，<br>`SPOT`：磁点，<br>`GRID`：磁网格。 |
| navigationTypes | array of string | 移动机器人支持的路径规划类型数组，按优先级排序。<br>可扩展枚举：{'PHYSICAL_LINE_GUIDED', 'VIRTUAL_LINE_GUIDED', 'FREELY_NAVIGATING', ...}<br>`'PHYSICAL_LINE_GUIDED'`：不做路径规划，沿物理铺设路径运行；<br>`'VIRTUAL_LINE_GUIDED'`：沿固定（虚拟）路径运行；<br>`'FREELY_NAVIGATING'`：由移动机器人自行规划路径。 |
| *supportedZones* | array of string | 该移动机器人支持的区域类型数组。<br>Enum {'BLOCKED', 'LINE_GUIDED', 'RELEASE', 'COORDINATED_REPLANNING', 'SPEED_LIMIT', 'ACTION', 'PRIORITY', 'PENALTY', 'DIRECTED', 'BIDIRECTED'}。 |

#### physicalParameters

该 JSON 对象描述移动机器人的物理属性。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| minimumSpeed | float64 | [m/s] 移动机器人可控制的最小连续速度。 |
| maximumSpeed | float64 | [m/s] 移动机器人最大速度。 |
| *minimumAngularSpeed* | float64 | [rad/s] 可控制的最小连续旋转速度。 |
| *maximumAngularSpeed* | float64 | [rad/s] 最大旋转速度。 |
| maximumAcceleration | float64 | [m/s²] 满载时的最大加速度。 |
| maximumDeceleration | float64 | [m/s²] 满载时的最大减速度。 |
| minimumHeight | float64 | [m] 移动机器人最小高度。 |
| maximumHeight | float64 | [m] 移动机器人最大高度。 |
| width | float64 | [m] 移动机器人宽度。 |
| length | float64 | [m] 移动机器人长度。 |

#### protocolLimits

该 JSON 对象描述移动机器人的协议限制。  
如果某个参数未定义或设为零，则表示对此参数没有显式限制。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| **maximumStringLengths** { | JSON object | 字符串最大长度。 |
| &emsp;*maximumMessageLength* | uint32 | MQTT 消息最大长度。 |
| &emsp;*maximumTopicSerialLength* | uint32 | MQTT Topic 中序列号部分的最大长度。<br><br>受影响参数：<br>order.serialNumber<br>instantActions.serialNumber<br>state.serialNumber<br>visualization.serialNumber<br>connection.serialNumber<br>zoneSet.serialNumber<br>response.serialNumber |
| &emsp;*maximumTopicElementLength* | uint32 | MQTT Topic 中其他部分的最大长度。<br><br>受影响参数：<br>order.timestamp<br>order.version<br>order.manufacturer<br>instantActions.timestamp<br>instantActions.version<br>instantActions.manufacturer<br>state.timestamp<br>state.version<br>state.manufacturer<br>visualization.timestamp<br>visualization.version<br>visualization.manufacturer<br>connection.timestamp<br>connection.version<br>connection.manufacturer<br>zoneSet.timestamp<br>zoneSet.version<br>zoneSet.manufacturer<br>response.timestamp<br>response.version<br>response.manufacturer |
| &emsp;*maximumIdLength* | uint32 | ID 字符串最大长度。<br><br>受影响参数：<br>order.orderId<br>node.nodeId<br>nodePosition.mapId<br>action.actionId<br>edge.edgeId<br>map.mapId<br>zoneSet.zoneSetId<br>zone.zoneId<br>zoneRequest.requestId<br>edgeRequest.requestId |
| &emsp;*idNumericalOnly* | boolean | 若为 `"true"`，则包含 ID 的参数只能包含数字值。 |
| &emsp;*maximumLoadIdLength* | uint32 | `loadId` 字符串最大长度。 |
| } | | |
| **maximumArrayLengths** { | JSON object | 数组最大长度。 |
| &emsp;*order.nodes* | uint32 | 移动机器人可处理的单个订单中最大节点数。 |
| &emsp;*order.edges* | uint32 | 移动机器人可处理的单个订单中最大边数。 |
| &emsp;*node.actions* | uint32 | 移动机器人可处理的单个节点上的最大动作数。 |
| &emsp;*edge.actions* | uint32 | 移动机器人可处理的单条边上的最大动作数。 |
| &emsp;*actions.actionsParameters* | uint32 | 移动机器人可处理的单个动作的最大参数数。 |
| &emsp;*instantActions* | uint32 | 移动机器人可处理的单条消息中的最大即时动作数。 |
| &emsp;*trajectory.knotVector* | uint32 | 移动机器人可处理的单条轨迹中的最大节点数。 |
| &emsp;*trajectory.controlPoints* | uint32 | 移动机器人可处理的单条轨迹中的最大控制点数。 |
| &emsp;*zoneSet.zones* | uint32 | 移动机器人可处理的单个 `zoneSet` 中最大区域数。 |
| &emsp;*state.nodeStates* | uint32 | 移动机器人发送的 `nodeStates` 最大数量，也即机器人已释放段（Base）中允许的最大节点数。 |
| &emsp;*state.edgeStates* | uint32 | 移动机器人发送的 `edgeStates` 最大数量，也即机器人已释放段（Base）中允许的最大边数。 |
| &emsp;*state.loads* | uint32 | 移动机器人发送的 `load` 对象最大数量。 |
| &emsp;*state.actionStates* | uint32 | 移动机器人发送的 `actionStates` 中对象最大数量。 |
| &emsp;*state.instantActionStates* | uint32 | 移动机器人发送的 `instantActionStates` 中对象最大数量。 |
| &emsp;*state.zoneActionStates* | uint32 | 移动机器人发送的 `zoneActionStates` 中对象最大数量。 |
| &emsp;*state.errors* | uint32 | 移动机器人在单条状态消息中发送的最大错误数。 |
| &emsp;*state.information* | uint32 | 移动机器人在单条状态消息中发送的最大信息数。 |
| &emsp;*error.errorReferences* | uint32 | 移动机器人为每个错误发送的最大错误引用数。 |
| &emsp;*information.infoReferences* | uint32 | 移动机器人为每条信息发送的最大信息引用数。 |
| } | | |
| **timing** { | JSON object | 时序信息。 |
| &emsp;minimumOrderInterval | float32 | [s] 向移动机器人发送订单消息的最小间隔。 |
| &emsp;minimumStateInterval | float32 | [s] 发送状态消息的最小间隔。 |
| &emsp;*defaultStateInterval* | float32 | [s] 发送状态消息的默认间隔。*若未定义，则使用主文档中的默认值*。 |
| &emsp;*visualizationInterval* | float32 | [s] 发送 `visualization` Topic 消息的默认间隔。 |
| } | | |

#### protocolFeatures

该 JSON 对象定义了移动机器人所支持的订单处理流程、动作及参数。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| **optionalParameters** [**optionalParameters**] | array | 支持和/或要求的可选参数数组。<br>未列出的可选参数默认视为移动机器人不支持。 |
| { | | |
| &emsp;parameter | string | 可选参数完整名称，例如 `"*order.nodes.nodePosition.allowedDeviationTheta"`。 |
| &emsp;support | enum | 对该可选参数的支持类型，可取值如下：<br>`'SUPPORTED'`：按规范支持该可选参数。<br>`'REQUIRED'`：该可选参数对移动机器人正常运行是必须的。 |
| &emsp;*description* | string | 自由文本描述，例如：<ul><li>解释为什么参数 `direction` 对该移动机器人类型是必须的，以及其可取值。</li><li>参数 `nodeMarker` 只能包含无符号整数。</li><li>NURBS 支持仅限于直线和圆弧段。</li></ul> |
| } | | |
| **mobileRobotActions** [**mobileRobotAction**] | array | 该移动机器人支持的所有动作及参数数组，包括 VDA5050 标准动作和制造商自定义动作。 |
| { | | |
| &emsp;actionType | string | 与 `action.actionType` 对应的动作类型唯一标识。 |
| &emsp;*actionDescription* | string | 动作的自由文本说明。 |
| &emsp;actionScopes | array of enum | 允许使用该动作类型的作用域数组。<br><br>`'INSTANT'`：可作为即时动作使用。<br>`'NODE'`：可用于节点。<br>`'EDGE'`：可用于边。<br>`'ZONE'`：可用于区域动作。<br><br>例如：`['INSTANT', 'NODE']` |
| &emsp;***actionParameters** [**actionParameter**]* | array | 动作所具备的参数数组。<br>若未定义，则表示该动作没有参数。<br>这里定义的 JSON 对象不同于 [7.3 `order` 消息实现](#73-implementation-of-the-order-message) 中节点和边里使用的动作参数对象。 |
| &emsp;*{* | | |
| &emsp;&emsp;key | string | 参数键名。 |
| &emsp;&emsp;valueDataType | enum | 值的数据类型，可取：`'BOOL'`、`'NUMBER'`、`'INTEGER'`、`'STRING'`、`'OBJECT'`、`'ARRAY'`。 |
| &emsp;&emsp;*description* | string | 参数的自由文本说明。 |
| &emsp;&emsp;*isOptional* | boolean | `"true"`：表示该参数是可选参数。 |
| &emsp;*}* | | |
| *actionResult* | string | 结果的自由文本说明。 |
| *blockingTypes* | array of enum | 该动作允许的阻塞类型数组。<br>Enum {'NONE', 'SOFT', 'SINGLE', 'HARD'} |
| pauseAllowed | boolean | `"true"`：该动作可通过 `startPause` 暂停；`"false"`：该动作不可暂停。 |
| cancelAllowed | boolean | `"true"`：该动作可通过 `cancelOrder` 取消；`"false"`：该动作不可取消。 |
| *}* | | |

### mobileRobotGeometry

该 JSON 对象定义移动机器人的几何属性，例如外轮廓与车轮位置。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| ***wheelDefinitions** [**wheelDefinition**]* | array | 车轮数组，包含车轮布置和几何参数。 |
| { | | |
| &emsp;type | string | 车轮类型。<br>可扩展枚举 {'DRIVE', 'CASTER', 'FIXED', 'MECANUM', ...}。 |
| &emsp;isActiveDriven | boolean | `"true"`：车轮主动驱动。 |
| &emsp;isActiveSteered | boolean | `"true"`：车轮主动转向。 |
| &emsp;**position** { | JSON object |  |
| &emsp;&emsp;x | float64 | [m] 车轮在移动机器人坐标系中的 X 位置。 |
| &emsp;&emsp;y | float64 | [m] 车轮在移动机器人坐标系中的 Y 位置。 |
| &emsp;&emsp;*theta* | float64 | [rad] 车轮在移动机器人坐标系中的朝向。固定轮需要该参数。 |
| &emsp;} | | |
| &emsp;diameter | float64 | [m] 车轮标称直径。 |
| &emsp;width | float64 | [m] 车轮标称宽度。 |
| &emsp;*centerDisplacement* | float64 | [m] 车轮中心到旋转点的标称偏移量（脚轮需要）。<br>若未定义，则默认其值为 `0`。 |
| &emsp;*constraints* | string | 制造商可用于定义约束的自由文本。 |
| } | | |
| ***envelopes2d** [**envelope2d**]* | array | 2D 轮廓曲线数组，例如空载/满载时的机械包络，以及不同速度情况下的安全区域。 |
| { | | |
| &emsp;envelope2dId | string | 该轮廓曲线集的标识。 |
| &emsp;**vertices[vertex]** | array | 以多边形形式表示的轮廓曲线，默认视为闭合。只允许简单多边形。 |
| &emsp;{ | | |
| &emsp;&emsp;x | float64 | [m] 多边形点的 X 坐标。 |
| &emsp;&emsp;y | float64 | [m] 多边形点的 Y 坐标。 |
| &emsp;} | | |
| &emsp;*description* | string | 对该轮廓曲线集的自由文本说明。 |
| *}* | | |
| ***envelopes3d [envelope3d]*** | array | 3D 轮廓曲线数组。 |
| *{* | | |
| &emsp;envelope3dId | string | 该轮廓曲线集的标识。 |
| &emsp;format | string | 数据格式，例如 DXF。 |
| &emsp;***data*** | JSON object | 3D 轮廓曲线数据，格式由 `format` 指定。 |
| &emsp;*url* | string | 用于下载 3D 轮廓曲线数据的协议与 URL，例如 `<ftp://xxx.yyy.com/ac4dgvhoif5tghji>`。 |
| &emsp;*description* | string | 对该轮廓曲线集的自由文本说明。 |
| *}* | | |

#### loadSpecification

该 JSON 对象定义移动机器人的载荷处理能力以及支持的载荷类型。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| *loadPositions* | array of string | 载荷位置 / 载荷处理装置数组。<br>该数组中的值同时也是 `state.loads[].loadPosition` 参数以及动作 `pick` / `drop` 中参数 `lhd` 的合法取值。<br>*如果该数组不存在或为空，则表示移动机器人没有载荷处理装置。* |
| ***loadSets [loadSet]*** | array | 移动机器人可处理的载荷集合数组。 |
| { | | |
| &emsp;setName | string | 载荷集合唯一名称，例如 `DEFAULT`、`SET1` 等。 |
| &emsp;loadType | string | 载荷类型，例如 `EPAL`、`XLT1200` 等。 |
| &emsp;*loadPositions* | array of string | 该载荷集合适用的载荷位置/载荷处理装置数组。<br>*若该参数不存在或为空，则表示此载荷集合适用于该移动机器人所有载荷处理装置。* |
| &emsp;***boundingBoxReference*** | JSON object | 包围盒参考点，定义同状态消息中的 `loads[]` 参数。 |
| &emsp;***loadDimensions*** | JSON object | 载荷尺寸，定义同状态消息中的 `loads[]` 参数。 |
| &emsp;*maximumWeight* | float64 | [kg] 该载荷类型允许的最大重量。 |
| &emsp;*minimumLoadhandlingHeight* | float64 | [m] 处理该载荷类型和重量时允许的最小高度，参照 `boundingBoxReference`。 |
| &emsp;*maximumLoadhandlingHeight* | float64 | [m] 处理该载荷类型和重量时允许的最大高度，参照 `boundingBoxReference`。 |
| &emsp;*minimumLoadhandlingDepth* | float64 | [m] 处理该载荷类型和重量时允许的最小深度，参照 `boundingBoxReference`。 |
| &emsp;*maximumLoadhandlingDepth* | float64 | [m] 处理该载荷类型和重量时允许的最大深度，参照 `boundingBoxReference`。 |
| &emsp;*minimumLoadhandlingTilt* | float64 | [rad] 处理该载荷类型和重量时允许的最小倾角。 |
| &emsp;*maximumLoadhandlingTilt* | float64 | [rad] 处理该载荷类型和重量时允许的最大倾角。 |
| &emsp;*maximumSpeed* | float64 | [m/s] 处理该载荷类型和重量时允许的最大速度。 |
| &emsp;*maximumAcceleration* | float64 | [m/s²] 处理该载荷类型和重量时允许的最大加速度。 |
| &emsp;*maximumDeceleration* | float64 | [m/s²] 处理该载荷类型和重量时允许的最大减速度。 |
| &emsp;*pickTime* | float64 | [s] 取货所需的大致时间。 |
| &emsp;*dropTime* | float64 | [s] 放货所需的大致时间。 |
| &emsp;*description* | string | 对该载荷处理集合的自由文本说明。 |
| } | | |

#### mobileRobotConfiguration

该 JSON 对象详细描述移动机器人当前运行的软件和硬件版本，以及简要的网络信息。

| **字段** | **数据类型** | **描述** |
|---|---|---|
| ***versions[versionInfo]*** | array | 由键值对对象组成的数组，用于表示软件和硬件信息。 |
| { | | |
| &emsp;key | string | 软件/硬件版本项的键（例如 `softwareVersion`）。 |
| &emsp;value | string | 与该键对应的版本值（例如 `v1.12.4-beta`）。 |
| } | | |
| ***network*** { | JSON object | 移动机器人网络连接信息。所列信息在移动机器人运行期间不应更新。 |
| &emsp;&emsp;*dnsServers* | array of string | 移动机器人所使用的 DNS 服务器数组。 |
| &emsp;&emsp;*ntpServers* | array of string | 移动机器人所使用的 NTP 服务器数组。 |
| &emsp;&emsp;*localIpAddress* | string | 用于与 MQTT broker 通信的预先分配 IP 地址。请注意，该 IP 地址在运行期间不应被更改。 |
| &emsp;&emsp;*netmask* | string | 与本地 IP 地址对应的子网掩码。 |
| &emsp;&emsp;*defaultGateway* | string | 与本地 IP 地址对应的默认网关。 |
| &emsp;} | | |
| ***batteryCharging*** { | JSON object | 电池充电参数信息。 |
| *criticalLowChargingLevel* | float64 | 指定临界低电量百分比；当电量低于或等于该值时，车队控制系统应只向移动机器人发送前往充电站的订单。 |
| *maximumDesiredChargingLevel* | float64 | 指定期望的最大充电百分比。 |
| *minimumDesiredChargingLevel* | float64 | 指定期望的最小充电百分比。 |
| *minimumChargingTime* | uint32 | 指定期望的最小充电时间，单位秒。 |
| &emsp;} | | |

# 参考文献

文档 | 版本 | 描述
---|---|---
ISO 3691-4 | December 2023 | 工业车辆 安全要求与验证 第 4 部分：无人驾驶工业车辆及其系统
ISO 9787 | May 2013 | 机器人与机器人装置：坐标系和运动命名法
ISO 639 | November 2023 | 世界语言和语言组表示用语言代码
ISO 8601 | February 2019 | 日期和时间：信息交换表示法
LIF – Layout Interchange Format | March 2024 | 一种轨道布局交换格式的定义，用于无人驾驶运输移动机器人的集成商与（第三方）车队控制系统之间交换布局信息
