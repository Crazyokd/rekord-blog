---
title: Rust 核心概念（十五）：异步
date: 2026/07/16
updated: 2026/07/16
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

# 同步和异步

同步代码遇到耗时 IO 时，线程会等待。

例如读取网络请求、等待数据库返回、等待文件系统响应。

异步的目标是：

> 当前任务等待 IO 时，让线程去执行别的任务。

这适合高并发 IO 场景。

# async fn

Rust 用 `async fn` 定义异步函数。

```rust
async fn fetch_user() -> String {
    String::from("rekord")
}
```

但调用异步函数时，函数体不会立刻执行完成。

它会返回一个 `Future`。

# Future

`Future` 表示一个未来会完成的值。

简化理解：

```rust
use core::pin::Pin;
use core::task::{Context, Poll};

trait Future {
    type Output;

    fn poll(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Self::Output>;
}
```

`Future` 不是“正在运行的任务”，而是“可以被轮询的计算”。

`poll` 的结果只有两种：

- `Poll::Pending`：现在还没准备好。
- `Poll::Ready(value)`：已经完成并产出结果。

这里有几个关键点：

- `Pin<&mut Self>` 表示这个 `Future` 轮询期间不能被随意移动。
- `Context` 里带着 `Waker`，future 可以把它保存起来。
- 当 IO、定时器或别的事件准备好时，`Waker` 会通知 executor 重新轮询。
- `poll` 本身不能阻塞；它要么尽快返回 `Pending`，要么返回 `Ready`。

`async fn` 本质上会生成一个实现了 `Future` 的状态机。

如果跨 `.await` 持有借用，编译器生成的状态机还会依赖 pinning 的约束，这也是 `Pin` / `Unpin` 会在异步里出现的原因。

# await

`.await` 用来等待 Future 完成。

```rust
async fn run() {
    let user = fetch_user().await;
    println!("{}", user);
}
```

`.await` 不应该理解成简单阻塞线程。

它更像是把当前 future 挂起，把控制权交回 executor，等 future 被唤醒后再从这里继续执行。

# executor

Future 自己不会运行。

它需要 executor 轮询。

executor 负责：

- 调度异步任务。
- 轮询 Future。
- 在任务可继续时唤醒它。

Rust 标准库定义了 Future，但不内置完整异步运行时。

# Tokio

Tokio 是 Rust 生态中最常用的异步运行时之一。

常见写法：

```rust
#[tokio::main]
async fn main() {
    println!("hello async");
}
```

`#[tokio::main]` 会生成启动运行时的代码。

然后你就可以在 `main` 里使用 `.await`。

Tokio 还把任务调度、计时器、网络 IO 和 blocking 线程池这些常用能力一起打包好了，所以一般写业务异步代码时只接触它的高层 API。

# 并发执行

异步适合同时等待多个 IO。

```rust
async fn task(name: &str) -> String {
    name.to_string()
}

#[tokio::main]
async fn main() {
    let a = task("a");
    let b = task("b");

    let result_a = a.await;
    let result_b = b.await;

    println!("{} {}", result_a, result_b);
}
```

要真正并发执行多个任务，通常会使用运行时提供的任务 API。

```rust
#[tokio::main]
async fn main() {
    let a = tokio::spawn(async {
        "a"
    });

    let b = tokio::spawn(async {
        "b"
    });

    println!("{} {}", a.await.unwrap(), b.await.unwrap());
}
```

`spawn` 会把任务交给运行时调度。

它还会返回一个 `JoinHandle`，你可以 `await` 这个句柄拿到任务结果；如果把句柄丢掉，任务通常仍会继续跑，只是你不再等待它。

需要主动取消时，可以调用 `abort()`。

# join

如果只是想同时等待多个 Future，不一定要 `spawn`。可以使用 `join!`。

```rust
async fn task(name: &str) -> String {
    name.to_string()
}

#[tokio::main]
async fn main() {
    let (a, b) = tokio::join!(task("a"), task("b"));
    println!("{} {}", a, b);
}
```

`join!` 会在同一个异步任务里并发轮询多个 Future。

它适合“当前逻辑需要同时等几个异步操作完成”的场景。

`spawn` 则是把任务交给运行时独立调度。

简单区别：

- `join!`：并发等待几个 Future，通常仍属于当前任务。
- `spawn`：创建独立任务，交给运行时调度。

如果多个 Future 返回 `Result`，常见的是 `try_join!`。

它会在某个 Future 返回 `Err` 时提前返回错误。

# select 和 timeout

如果要等“最先完成的那个”，通常用 `select!`。

```rust
tokio::select! {
    user = fetch_user() => println!("{}", user),
    _ = tokio::time::sleep(std::time::Duration::from_secs(3)) => println!("timeout"),
}
```

`select!` 会在第一个分支完成时返回，其他分支会被取消。

它常用于：

- 超时控制。
- 在多个 IO 里抢先拿到第一个结果。
- 监听多个异步来源，谁先来就先处理谁。

要注意，`select!` 里被取消的分支不一定都能无损恢复，遇到读写缓冲区这类场景时要看具体 API 是否支持 cancellation safety。

如果只是给单个 Future 加超时，`tokio::time::timeout` 更直接：

```rust
let result = tokio::time::timeout(std::time::Duration::from_secs(3), fetch_user()).await;
```

超时后它会返回错误，底层 future 会被取消。

# Stream

`Stream` 可以理解成“异步版迭代器”。

`Future` 只会产出一个结果，`Stream` 会连续产出多个结果。

常见用法是配合 `next().await` 一项一项读取：

```rust
use futures::StreamExt;

while let Some(item) = stream.next().await {
    println!("{:?}", item);
}
```

它常见于：

- WebSocket / socket 持续收消息。
- 分页读取数据。
- 事件流和订阅消息。

标准库里还没有统一收进来，生态里通常用 `futures::Stream` / `StreamExt` 或 Tokio 相关扩展。

# async move

异步块经常使用 `async move`。

```rust
let name = String::from("rekord");

let task = async move {
    println!("{}", name);
};
```

这里的 `move` 不是为了“异步”，而是把捕获到的值移进 future 里。

这通常有两个原因：

- future 可能比当前作用域活得更久。
- 变量如果要跨 `.await` 使用，借用关系会变得很难满足生命周期要求。

所以在 `tokio::spawn`、`join!` 这类场景里，`async move` 很常见。

# Send 问题

多线程异步运行时中，被 `spawn` 的 Future 通常需要是 `Send`。

也就是说，它可以在线程之间移动。

如果 Future 捕获了不能跨线程的类型，例如 `Rc<T>`，就可能编译失败。

更准确地说：

- `Send` 表示值可以安全地移动到别的线程。
- `Sync` 表示 `&T` 可以安全地被多个线程共享。
- `Rc<T>` 两者都不满足，`Arc<T>` 才适合跨线程共享引用计数。
- 如果还要可变共享，通常会再包一层 `Mutex` 或 `RwLock`。

如果要跑 `!Send` 的 future，可以把它放到单线程上下文里，比如 `spawn_local` 和 `LocalSet`。

`spawn_local` 只适合当前线程上的 local task；如果在多线程 runtime 里直接用 `tokio::spawn`，这个 future 还是得满足 `Send`。

```rust
#[tokio::main(flavor = "current_thread")]
async fn main() {
    let local = tokio::task::LocalSet::new();

    local
        .run_until(async {
            let value = std::rc::Rc::new(String::from("rekord"));
            let handle = tokio::task::spawn_local(async move {
                println!("{}", value);
            });

            handle.await.unwrap();
        })
        .await;
}
```

这个模式常见于 GUI、FFI 封装、JS bridge，或者明确只能在单线程上使用的状态。

# 阻塞工作

异步任务里不要直接放长时间的同步阻塞。

比如同步文件 IO、重 CPU 计算、`std::thread::sleep`，都会占住 worker 线程，让其他协程也跟着卡住。

Tokio 提供 `spawn_blocking` 来处理这类工作：

```rust
let handle = tokio::task::spawn_blocking(|| {
    42
});

let value = handle.await.unwrap();
```

它适合“会结束”的阻塞任务。

如果工作很长，或者数量很多，通常还是要考虑单独线程池或别的架构。

# 总结

异步 Rust 的核心不是语法，而是用 Future 表达可暂停的计算，再由运行时调度这些计算。
