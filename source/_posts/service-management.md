---
title: 服务管理
date: 2025-03-03 01:32:59
updated: 2025-03-03 01:32:59
index_img: https://cdn.sxrekord.com/blog/cplus.png
banner_img: https://cdn.sxrekord.com/blog/cplus.png
categories:
- 技术
tags:
- C/C++
---

最近想要实现一个服务动态加载/卸载/启停的feature。

![架构图](https://cdn.sxrekord.com/v2/image-20250303092554-yzq6of6.png)

整个系统通过lua编写业务，而lua的能力是通过c/c++库赋予的。

在整个架构设计上，我们将其中的c/c++库二次拆分，即拆分为控制库和实现库。

控制库提供的均为抽象的逻辑，对业务也是不可知的。其主要作用在于对涉及的网络链路管理、会话控制做了对应的封装（Lua本身无法具备网络能力）。

而实现库和业务之间多少会存在一定耦合，当然我们仍然希望这种耦合可以最小化。其中当然也要涉及链路管理，但不仅仅是常规的http或websocket，还包括sctp或sip等（依库自身提供的服务而定）。所以到了这一层才真正发送/接收/控制信令。



基于上述架构，不难看出服务库与控制库是一一对应的，但二者同时也与整个调度系统是分离的。

在这种情况下，想要实现对服务生命周期的完全动态控制就不难理解了。

不难发现，最危险也最难的操作肯定是卸载，因为稍有不慎整个系统就会因为无效指针而发生`segment fault`。

但真正在实现该feature时，还是遇到了不少难题。

# 引用线程

服务提供的能力几乎都是在多线程环境下被使用，以一个最常规的服务举例：

1. lua调用，一个任务对应一个`lua_state`，每一个任务都跑在自己的线程之上。所以可能同时存在多条lua任务线程访问某一特定服务。
2. 服务消息回调，每个任务都有一个自身的消息队列，服务会在自身的线程上产生消息，如收到一条有效的websocket消息可能就会产生一条服务消息，任何一个服务消息根据任务ID或特定规则置入对应的任务消息队列中，由任务线程取出并执行回调。所以可能同时存在多条lua任务线程通过消息访问某一特定服务。

在这两大类之上，还可以进一步拆分为4小类。

其中的lua调用分为实例调用和函数调用，实例调用依赖于实例，调用方式形如：`xxx:func(xxx, xxx)`，诸如添加规则就需要使用这种调用，因为我们的系统中某一个任务产生的规则是需要在任务结束后统一清理的，所以一般会通过实例保存状态。而函数调用则与之相反，不依赖特定实例，即纯粹的过程函数，是无状态的。

其中的服务消息回调会在两阶段引用服务对象，其一是生成服务消息时，其二是在回调处理或分发时引用服务，因为只有通过服务，才能知晓如何分发。不难看出生成消息位于服务线程，如若我们需要unload某一服务，首先会停止该服务，所以并没有线程安全问题。

# 方案1——引用计数

优点：实现较为简单（但仍旧繁琐）

缺点：在上述的几类情况下服务被引用后，引用计数自增；但当我们试图卸载某一服务时，这些引用计数无法自减。导致卸载操作发生失败或成为一个非常耗时的异步操作。

整个系统是会同时存在大量任务的，而且设计时并没有考虑任务与角色的对应，即每个角色都能看到所有任务，甚至是操作他人创建的任务。

另外许多脚本的业务逻辑几乎都是异步操作或伪异步操作，这也意味着它们所在的任务可能长期处于运行状态。

在这种情况下，引用计数的缺陷被放大到几乎不可接受的地步。

试想，如果你想要卸载一个服务，首先需要停止所有任务，或更不实际的等待所有任务结束。最让人啼笑皆非的是，在你停止任务后，可能紧接着就有用户重启了某个任务或新建了另一个任务。

总而言之，这种方案在实际应用场景是没有价值的。

# 方案2——观察者模式

为了避免出现方案1的情况，就需要使服务在卸载时显式的让“引用自减”。

当然，这里并不是真正的引用自减，而是让引用变更为不可用的状态。

这其中，非常经典的方案当属观察者模式了。

让所有引用服务的类/对象在引用之前事先attach到对应服务。这样当服务在销毁时，能够通过调用notify回调显式的通知所有过去曾attach过自身的对象。

类图大致如下：

![服务管理类图](https://cdn.sxrekord.com/v2/image-20250303091638-93df31g.png)

时序图大致如下：

![服务管理时序图](https://cdn.sxrekord.com/v2/image-20250303092228-25wgj8h.png)

其最大优势当属完全消除了方案1所面临的最大痛点。但缺点也很明显，想要让引用安全的变更为失效，意味着所有观察者在引用服务之前都需要锁住与notify时使用的同一个互斥量以保证状态操作的安全性。

然而，从前文可知，系统中存在多类对象在不同场景下对服务的引用。

想要让这些对象在不同的场景下均做到安全的attach/detach不啻为梦魇编程。

效果不错，但是导致的代码臃肿以及对日后可维护性的破坏都是不可估量的。甚至还要求每一个服务都需要做到这一点:)

# 方案3——借助任务管理器

进一步思考，发现所有代码处理的复杂性均是因为粒度太细导致的，比如上述多线程下的消息对象/luac对象等。

当我们把抽象维度抬高，那么剩下的主要就只有任务线程与服务线程了。**简言之就是多个任务线程并发引用单个服务。**

所以我们可以直接对任务使用观察者模式，当任务启动时attach对应服务，当服务停止时通知所有任务。

当然，实际情况下，我们并不需要真的使用这种方案，因为过去在我们的系统中所有任务都是由任务管理器统一进行管理的。

所以在卸载服务时，我们仅需要通过任务管理器**停止所有任务**即可，接下来就可以愉快且安全的卸载服务了。

这种方案的缺点显然是卸载服务时对系统所有任务的状态的巨大破坏。但仔细想想，想要安全卸载服务，停止所有任务也不得不成为一个必要条件。

# tricky `dlclose`

前两个方案我也并非都是纸上谈兵，二者均完成了实现落地，但也因为上述缺陷不得不全部抛弃。

在实际编写代码时，虽然需要考虑的很仔细，但也可算作耗时劳力，毕竟想好了方案，下笔无非就是dump想法罢了。

第三个方案本应是实现最为简单的，然而却遇到了好几个棘手的bug。其中我觉得一定要记录下来的当属dlclose了。

当我在外部通过HTTP接口调用unload卸载服务时，dlclose返回0。

本以为万事大吉，没想到更新了服务再load，更新并没有被实际应用。

从[dlopen.3](https://man7.org/linux/man-pages/man3/dlopen.3.html)得知，dlclose并不保证卸载服务，只有当引用计数为0时动态库才能真正被munmap，所以紧接着我打了break dlopen和break dlclose两处函数断点，但并没有发现不对称的dlopen调用。

而后又排除了gdb的影响，我开始使用各种工具对动态库是否卸载进行探测，并写了一个简单的dlopen/dlclose测试程序进行对比测试，下面是我一些行之有效的检验方法：

1. gdb中查看程序已经加载的动态库

```gdb
info sharedlibrary
(*): Shared library is missing debugging information.
```

2. 使用lsof查看被某一个进程引用的符号

```shell
lsof -p pid
```

3. 查看某个库正在被哪些程序引用：

```shell
lsof xxx.so
```

4. 查看某个程序的内存映射情况：

```shell
cat /proc/pidof/maps | grep libxxx.so
pmap -x pidof | grep libxxx.so
```

5. 通过strace追踪系统调用：

```shell
strace -e trace=openat,close,mmap,munmap ./program
```

当然所有的检验结果都清楚的告知着我动态服务库并没有被真正的卸载。穷途末路之际，我找到了这条[帖子](https://stackoverflow.com/questions/24467404/dlclose-doesnt-really-unload-shared-object-no-matter-how-many-times-it-is-call)。

其中明确提到UNIQUE类型的符号是无法被卸载的，我赶紧使用下面的命令查询了我的符号类型：

```shell
readelf -CWs install/lib/x86_64-linux-gnu/libxxx.so | grep UNIQUE
```

发现动态库中真的存在不少UNIQUE，紧接着我又写了一个有UNIQUE符号的dlopen/dlclose测试程序，发现含有UNIQUE符号的动态库真的无法被卸载。

但解决方案很简单，即在编译参数中加上`-fno-gnu-unique`从而显式的告诉编译器不要生成这种类型的符号。
