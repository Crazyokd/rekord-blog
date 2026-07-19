---
title: Rust 核心概念（十一）：智能指针
date: 2026/06/18
updated: 2026/06/18
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

智能指针不是绕过所有权，而是把不同所有权需求编码进类型。

# 指针和智能指针

普通引用 `&T` 只是借用数据。

智能指针通常拥有数据，并附带额外能力。

例如：

- `Box<T>`：把值放到堆上，并拥有它。
- `Rc<T>`：单线程多所有者。
- `Arc<T>`：多线程多所有者。
- `RefCell<T>`：运行时借用检查。
- `Mutex<T>`：多线程互斥访问。

不同智能指针对应不同所有权模型。

# Box

`Box<T>` 表示在堆上分配一个值，并由 Box 拥有。

```rust
fn main() {
    let n = Box::new(5);
    println!("{}", n);
}
```

`Box` 最常见用途之一是递归类型。

```rust
enum List {
    Cons(i32, Box<List>),
    Nil,
}
```

如果没有 `Box`，递归 enum 的大小无法确定。

`Box<List>` 是一个指针，大小固定，所以可以编译。

类似于 C++ 中的 `std::unique_ptr<T>`。

`Box<T>` 另一个常见用途是包装 trait object。

当你只关心“它能做什么”，不关心“它到底是什么类型”时，可以把 trait object 放进 `Box` 里：

```rust
trait Draw {
    fn draw(&self);
}

struct Button;

impl Draw for Button {
    fn draw(&self) {
        println!("button");
    }
}

fn main() {
    let widget: Box<dyn Draw> = Box::new(Button);
    widget.draw();
}
```

`dyn Draw` 自身大小不固定，不能直接作为普通值使用。

`Box` 给它提供了一个固定大小的外壳，所以函数也常用 `Box<dyn Trait>` 来返回“实现同一 trait 的不同具体类型”。

# Deref

智能指针通常实现 `Deref`。

这让它可以像引用一样使用。

```rust
fn main() {
    let x = 5;
    let y = Box::new(x);

    assert_eq!(5, *y);
}
```

`*y` 会解引用 Box，拿到里面的值。

很多时候 Rust 还会自动做 deref coercion。

# Drop

智能指针通常实现 `Drop`，用于释放资源。

```rust
struct Resource;

impl Drop for Resource {
    fn drop(&mut self) {
        println!("drop resource");
    }
}
```

当值离开作用域时，Rust 自动调用 `drop`。

这就是 Rust 不需要手动释放内存的关键之一。

# Rc

`Rc<T>` 是引用计数指针，用于单线程多所有者。

```rust
use std::rc::Rc;

fn main() {
    let data = Rc::new(String::from("hello"));

    let a = Rc::clone(&data);
    let b = Rc::clone(&data);

    println!("{}", a);
    println!("{}", b);
}
```

`Rc::clone` 不会深拷贝字符串。

它只是增加引用计数。

当最后一个 `Rc` 离开作用域时，数据才会被释放。

注意：`Rc<T>` 只能用于单线程。

# Weak

`Rc<T>` 通过引用计数决定什么时候释放数据。

如果两个 `Rc` 互相持有，就可能形成引用循环，导致计数永远不归零。

这种场景应该用 `Weak<T>` 表达“我能找到你，但我不拥有你”。

```rust
use std::rc::{Rc, Weak};

fn main() {
    let data = Rc::new(String::from("hello"));
    let weak: Weak<String> = Rc::downgrade(&data);

    if let Some(value) = weak.upgrade() {
        println!("{}", value);
    }
}
```

`Weak` 不增加强引用计数，所以不会阻止数据释放。

如果数据已经释放，`upgrade()` 会返回 `None`。

简单记：

- `Rc`：拥有数据，增加强引用计数。
- `Weak`：不拥有数据，只是弱引用。

类似于cpp中的`std::weak_ptr<T>`.

# Arc

`Arc<T>` 是原子引用计数指针，可以用于多线程。

```rust
use std::sync::Arc;
use std::thread;

fn main() {
    let data = Arc::new(String::from("hello"));

    let cloned = Arc::clone(&data);
    let handle = thread::spawn(move || {
        println!("{}", cloned);
    });

    handle.join().unwrap();
}
```

`Arc` 比 `Rc` 成本更高，因为它的引用计数是线程安全的。

类似于cpp中的`std::shared_ptr<T>`.

# RefCell

`RefCell<T>` 提供内部可变性。

它把借用检查从编译期推迟到运行时。

```rust
use std::cell::RefCell;

fn main() {
    let data = RefCell::new(1);

    *data.borrow_mut() += 1;

    println!("{}", data.borrow());
}
```

`borrow()` 获取不可变借用。

`borrow_mut()` 获取可变借用。

如果运行时违反借用规则，程序会 panic。

所以 `RefCell` 不是取消借用规则，而是把检查时间后移。

# Rc<RefCell<T>>

`Rc<RefCell<T>>` 是常见组合。

它表示：

- `Rc`：多个所有者。
- `RefCell`：内部可以修改。

```rust
use std::cell::RefCell;
use std::rc::Rc;

fn main() {
    let data = Rc::new(RefCell::new(1));

    let a = Rc::clone(&data);
    let b = Rc::clone(&data);

    *a.borrow_mut() += 1; // 执行完就drop，不影响下面继续borrow_mut
    *b.borrow_mut() += 1;

    println!("{}", data.borrow());
}
```

这种组合有用，但不要滥用。

它会让部分错误从编译期变成运行时。

# Mutex

`Mutex<T>` 用于多线程共享可变状态。

```rust
use std::sync::Mutex;

fn main() {
    let data = Mutex::new(1);

    {
        let mut value = data.lock().unwrap();
        *value += 1;
    }

    println!("{:?}", data);
}
```

`lock()` 会获得锁。

返回的 guard 离开作用域时会自动释放锁。

`lock()` 返回 `Result`，因为持有锁的线程如果 panic，锁会进入 poisoned 状态。

示例里的 `unwrap()` 表示：如果锁被 poisoned，就让当前线程也 panic。

多线程共享时常和 `Arc` 一起用：

```rust
use std::sync::{Arc, Mutex};

let data = Arc::new(Mutex::new(0));
```

# 选择规则

可以先按这个思路选择：

- 只想放到堆上：`Box<T>`。
- 单线程多个所有者：`Rc<T>`。
- 多线程多个所有者：`Arc<T>`。
- 线程内部可变：`RefCell<T>`。
- 单线程多所有者且可变：`Rc<RefCell<T>>`。
- 多线程多所有者且可变：`Arc<Mutex<T>>`。

# 延伸

`Cow` 和 `Pin` 也常和智能指针放在一起提，但它们解决的是另一类问题。

## Cow

`Cow` 是 `clone on write`。

它解决的是“默认只借用，必要时才拥有或复制”的场景。

```rust
use std::borrow::Cow;

fn normalize(input: &str) -> Cow<'_, str> {
    if input.trim() == input {
        Cow::Borrowed(input)
    } else {
        Cow::Owned(input.trim().to_string())
    }
}
```

它适合这类 API：

- 大多数时候只读。
- 只有少数分支才需要修改结果。
- 不想一开始就无条件 `clone`。

## Pin

`Pin` 解决的是“值被放到某个位置后，不能再被移动”的问题。

它管的是地址稳定，不是所有权共享，也不是“能不能修改值”。

有些类型会在内部保存指向自己的指针，或者在被 `poll` / 访问时依赖固定地址。
一旦值被 move，这些内部地址就可能失效。

`Pin` 的作用就是把“已经固定住”的值标出来，让安全代码不能再把它搬来搬去。

```rust
use std::pin::Pin;

fn takes_pinned(value: Pin<Box<String>>) {
    // 这里拿到的是一个已经固定地址的值
    println!("{}", value);
}
```

它最常见的形式是 `Pin<Box<T>>`。
`Box` 先把值放到堆上，`Pin` 再保证这个值不会被安全代码移动出去。

它常见于：

- `async` 生成的 future。
- 自引用结构。
- 依赖稳定内存地址的类型。

`Unpin` 表示这个类型即使被 pin 住，也仍然可以安全移动。
大多数普通类型都是 `Unpin`，所以你平时通常不会直接碰到 `Pin`，更多是库签名里出现它。

# 总结

智能指针的核心不是“指针”，而是：

> 用明确的类型说明这份数据到底如何被拥有、共享和修改。
