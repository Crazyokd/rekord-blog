---
title: Rust 核心概念（十二）：并发
date: 2026/07/13
updated: 2026/07/13
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

Rust 的并发安全建立在所有权、借用、trait 和智能指针之上。

# 创建线程

使用 `thread::spawn` 创建线程。

```rust
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        println!("hello from thread");
    });

    handle.join().unwrap();
}
```

`join` 会等待线程结束。

如果不 join，主线程结束时，子线程可能还没来得及执行完。

# move closure

线程闭包经常需要 `move`。

```rust
use std::thread;

fn main() {
    let name = String::from("rekord");

    let handle = thread::spawn(move || {
        println!("{}", name);
    });

    handle.join().unwrap();
}
```

`move` 把 `name` 的所有权移动进线程。

原因是线程可能比当前函数活得更久，不能借用一个可能已经失效的局部变量。

# 消息传递

Rust 标准库提供 channel。

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        tx.send(String::from("hello")).unwrap();
    });

    let msg = rx.recv().unwrap();
    println!("{}", msg);
}
```

`tx` 是发送端。

`rx` 是接收端。

`send` 会移动消息所有权。

这符合一个常见并发思想：

> 不要共享内存来通信，而是通过通信转移所有权。

# 多个发送者

发送端可以 clone。

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();
    let tx2 = tx.clone();

    thread::spawn(move || {
        tx.send("from tx").unwrap();
    });

    thread::spawn(move || {
        tx2.send("from tx2").unwrap();
    });

    for msg in rx {
        println!("{}", msg);
    }
}
```

多个线程可以向同一个接收端发送消息。

# 共享状态

有时确实需要多个线程共享同一份数据。

这时通常使用 `Arc<Mutex<T>>`。

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);

        let handle = thread::spawn(move || {
            let mut n = counter.lock().unwrap();
            *n += 1;
        });

        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("{}", *counter.lock().unwrap());
}
```

这里两层含义很明确：

- `Arc`：多个线程共同拥有数据。
- `Mutex`：同一时间只允许一个线程修改数据。

# Send

`Send` 表示一个类型的所有权可以在线程之间转移。

例如，`String` 是 `Send`，可以 move 到新线程里。

如果一个类型不是 `Send`，Rust 不允许把它移动到其他线程。

# Sync

`Sync` 表示一个类型可以被多个线程通过引用共享。

如果 `T` 是 `Sync`，那么 `&T` 可以在线程之间安全共享。

# 数据竞争

数据竞争通常需要三个条件：

- 两个或多个线程同时访问同一数据。
- 至少一个访问是写。
- 没有同步机制。

Rust 的目标是让安全 Rust 中的数据竞争无法通过编译。

如果要共享可变状态，你必须用 `Mutex`、原子类型等同步工具把规则写清楚。

# 总结

Rust 并发的核心是把线程间所有权、共享和修改规则放进类型系统里。

