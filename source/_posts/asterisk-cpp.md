---
title: asterisk-cpp源码解读
date: 2024/6/29
index_img: https://cdn.sxrekord.com/blog/code.jpg
categories: 
- 技术
tags:
- 源码赏析
---

# 项目地址

https://github.com/augcampos/asterisk-cpp

# 为什么读
最近的工作上可能要对Asterisk做相关控制，在阅读[《Asterisk权威指南》](http://www.asteriskdocs.org/)时，官方有推荐asterisk-java作为第三方AMI客户端。
但是项目中主要用的还是C/CPP/Lua，故尽量还是找原生解决方案。

`asterisk-cpp`仓库介绍上有提及**asterisk-java port**。
所以直接阅读源码以方便进一步打算。

> asterisk-java 现在还在更新，故也可能考虑直接使用java版作为解决方案。

# 项目结构

```txt
asterisk-cpp/asteriskcpp/
├── exceptions
│   ├── Exception.h
│   ├── ExceptionHandler.h
│   ├── IOException.h
│   └── RuntimeException.h
├── manager
│   ├── actions
│   ├── Actions.hpp
│   ├── AsteriskVersion.h
│   ├── Dispatcher.h
│   ├── EventBuilder.h
│   ├── events
│   ├── Events.hpp
│   ├── ManagerConnection.h
│   ├── ManagerEventListener.h
│   ├── ManagerEventsHandler.h
│   ├── ManagerResponsesHandler.h
│   ├── Reader.h
│   ├── ResponseBuilder.h
│   ├── responses
│   └── Writer.h
├── Manager.hpp
├── net
│   ├── IPAddress.h
│   ├── SSLContext.h
│   ├── SSLSocket.h
│   └── TCPSocket.h
├── structs
│   ├── PropertyMap.h
│   ├── Singleton.h
│   ├── SynchronisedQueue.h
│   └── Thread.h
└── utils
    ├── Base64.h
    ├── LogHandler.h
    ├── MD5.h
    ├── StringUtils.h
    └── timesupport.h
```

项目目录结构如上所示，其中

structs目录下是一些通用数据结构

net目录下是一些有关网络动作的封装

utils目录下封装了一些通用的工具类

exceptions目录下是本项目的异常层次结构

manager目录下包含了本项目中**最重要的文件**

‍

# 网络模型

1. receive Event from server

​![image](https://cdn.sxrekord.com/blog/asterisk-cpp/image-20240629162800-iy22gof.png)​

2. receive Response from server（action与response一一匹配）

​![image](https://cdn.sxrekord.com/blog/asterisk-cpp/image-20240629162854-czar21a.png)​

3. 实际模型

​![image](https://cdn.sxrekord.com/blog/asterisk-cpp/image-20240629162922-nwr8hsy.png)​

# 设计架构

1. 对于模型中每一个类别（即Event、Action和Response），都有大量对应的实例类。

对应的类图如下：

​![image](https://cdn.sxrekord.com/blog/asterisk-cpp/image-20240629163855-7g79br6.png)​

2. 从网络模型中可以得知，服务器可能接收response/event，也有可能发送action。

所以存在两种类别的callback，即ResponseCallBack和EventCallBack，但其实后者叫做EventListener更为恰当（项目中两种名称都有使用）。

同时，项目中也需要ResponseBuilder和EventBuilder。通过响应报文的内容可以判断是Event还是Response，如果是Event，就构造对应Event实例对象；如果是Response，就提取其中的ActionID，得到对应的ResponseCallback（该实例中含有对应action的引用指针）。然后要么通过ResponseCallback中的action指针调用其自身的`expectedResponce`​函数；要么生成默认的ManagerError实例或ManagerResponse实例。

而ResponseCallback又分为同步和异步两种类型。顾名思义，同步就是等待响应并处理完响应后再进行下一步，所以不需要真正的回调函数逻辑；而异步就是响应在某一时刻到来后**可能**直接调用对应的回调函数，然后销毁相关资源。

3. ManagerEventsHandler和ManagerResponseHandler负责对应回调/事件的处理，二者分别是Event/Response的聚合类

所以当事件/响应到来后，它们负责具体如何处理。比如查找对应EventListener/ResponseCallBack然后进行一系列相关操作。

4. Dispatcher配合MessageTable负责消息的分发

当消息到来后，判断消息类型，然后将消息放入对应的table中（event和response各对应一个消息表）。

EventDispatchThread和ResponseDispatchThread各启动一条线程，循环的从消息表中获取可用的消息，然后通过Dispatcher分发出去（Dispatcher是在构造对象或启动线程时传递进来的，本质上就是调用Dispatcher的fireDispatch方法）。

5. Reader和Writer负责接收和发送网络消息

当上层发送action后，由writer最终对接socket将消息从网络上发送出去。

当接收到网络消息后，由reader将消息内容放入消息表。

EventDispatchThread和ResponseDispatchThread都是由Reader管理的。

5. ManagerConnection是本项目的核心，使用该库的大部分时候都是操作该类，客户将几乎所有的工作交由该类实例处理。

该类继承了ManagerEventsHandler、ManagerResponsesHandler和Dispatcher。

该类封装了一些高层常见方法，比如登录、注销、连接、断开连接等，同时也支持发送action和注册事件监听器等低层行为。

由于继承了两个Handler，所以内部实现了具体的分发逻辑。

# 使用案例

```c++
/*
 * Test.cpp
 *
 *  Created on: Dec 30, 2011
 *      Author: augcampos
 */

//man 8 ldconfig (dont forget)

#include <iostream>
#include <asteriskcpp/Manager.hpp>
#include <asteriskcpp/manager/responses/ManagerError.h>


using namespace asteriskcpp;

void eventCallback(const ManagerEvent& me) {
    std::cout << "TEST EVENT START: " << me.getEventName() << std::endl;
    if (me.getEventName() == "NewChannel") {
        std::cout << "E - " << me.toString() << std::endl;
    }
    std::cout << "TEST EVENT: " << me.toLog() << std::endl;
}

int main() {
    std::cout << asteriskcpp::getCurrentTimeStamp() << " START ASTERISK-CPP-TEST" << std::endl;
    LogHandler::getInstance()->setLevel(LL_TRACE);

    ManagerConnection mc;

    try {
        mc.addEventCallback(&eventCallback);

        if (mc.connect("192.168.1.10")) {

            if (mc.login("administrator", "secret")) {

                for (int i = 0; i < 1; i++) {
                    asteriskcpp::EventsAction *ea = new asteriskcpp::EventsAction("OFF");
                    mc.sendAction(ea);
                    asteriskcpp::EventsAction *ea2 = new asteriskcpp::EventsAction("ON");
                    mc.sendAction(ea2);
                    asteriskcpp::ManagerResponse* rpc;

                    asteriskcpp::AbsoluteTimeoutAction ata("SIP/1000", 30);
                    rpc = mc.syncSendAction(ata);
                    delete (rpc);

                    asteriskcpp::ListCommandsAction lca;
                    rpc = mc.syncSendAction(lca);
                    delete (rpc);

                    asteriskcpp::CommandAction coma("sip show peers");
                    asteriskcpp::ManagerResponse* mr = mc.syncSendAction(coma);
                    if (mr->getType() == asteriskcpp::ManagerResponse::Type_ERROR) {
                        asteriskcpp::ManagerError *me = (asteriskcpp::ManagerError*)mr;
                        std::cout << std::endl << "XXXXXX" << me->toLog() << std::endl;
                    } else {
                        asteriskcpp::CommandResponse* cr = (asteriskcpp::CommandResponse*)mr;
                        std::cout << std::endl << "ZZZZZZ" << cr->toLog() << std::endl;
                        for (std::vector<std::string>::const_iterator it = cr->getResult().begin(); it != cr->getResult().end(); it++) {
                            std::cout << "[" << (*it) << "]" << std::endl;
                        }
                    }
                    delete mr;
                }
                mc.logoff();
            }
            mc.disconnect();
        }
    } catch (Exception e) {
        std::cout << " ERROR :" << e.getMessage() << std::endl;
    }
    std::cout << asteriskcpp::getCurrentTimeStamp() << " END ASTERISK-CPP-TEST" << std::endl;
    exit(0);
}
```

1. 程序首先打印启动输出并设置日志级别。
2. 创建一个ManagerConnection并添加一个事件监听器。
3. 连接并登录
4. 首先发送两个异步事件（二者都没有提供回调函数），然后发送三个同步事件。由于最后一个事件有对响应做具体逻辑，所以需要判断最终的消息是错误还是恰当的响应，而后分别进行处理。
5. 注销、断开连接然后打印退出输出
