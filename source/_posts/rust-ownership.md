---
title: Rust 核心概念（一）：所有权
date: 2026/05/30
updated: 2026/05/30
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

所有权是 Rust 最核心的概念，因为 Rust 要求你明确回答一个问题：

> 一个值到底归谁负责？

所有权就是 Rust 对这个问题的回答。

# 所有权规则

Rust 的所有权规则可以压缩成三条：

1. 每个值都有一个所有者。
2. 同一时间只能有一个所有者。
3. 所有者离开作用域时，值会被释放。

例如：

```rust
fn main() {
    let s = String::from("hello");
    println!("{}", s);
}
```

`s` 是这个 `String` 的所有者。`main` 结束时，`s` 离开作用域，Rust 自动释放它占用的内存。

这里没有手动 `free`，也没有垃圾回收。Rust 靠所有权规则在编译期决定资源什么时候释放。

所有权管理的不只是内存。

文件句柄、网络连接、锁守卫、堆内存，本质上都是资源。Rust 希望每份资源都有明确负责人，负责人离开作用域时资源被释放。

# 作用域

作用域决定变量什么时候有效。

```rust
fn main() {
    {
        let s = String::from("hello");
        println!("{}", s);
    }

    // println!("{}", s); // 错误：s 已经离开作用域
}
```

内部大括号结束后，`s` 离开作用域。它拥有的 `String` 会被释放。

# move

Rust 中很多赋值不是复制，而是移动所有权。

```rust
fn main() {
    let a = String::from("hello");
    let b = a;

    println!("{}", b);
    // println!("{}", a); // 错误：a 已经被移动
}
```

`String` 的数据在堆上。变量 `a` 本身保存的是指向堆内存的指针、长度和容量。

如果 `let b = a` 之后，`a` 和 `b` 都还能使用，那么它们就会指向同一块堆内存。离开作用域时，两者都尝试释放这块内存，就会出现二次释放。

Rust 的处理方式是：所有权从 `a` 移动到 `b`，之后 `a` 不再有效。

这就是 move。

对 `String` 来说，移动的通常只是栈上的指针、长度、容量这些元数据，堆上的字符串内容不会复制一份。变化的是：谁有权负责这块堆内存。

这点和 C++ 很适合对照。C++ 也有 move，但移动后的对象通常仍然有效，只是状态未指定；Rust 更强硬，旧绑定直接不能再用。

Rust 关心的不只是“数据有没有搬动”，而是“谁还被允许使用和释放这份资源”。

# Copy

不是所有赋值都会 move。

```rust
fn main() {
    let a = 1;
    let b = a;

    println!("{}", a);
    println!("{}", b);
}
```

这段代码可以通过编译，因为整数实现了 `Copy`。

`Copy` 类型在赋值时会直接复制值，而不是移动所有权。

`Clone` 是 `Copy` 的父 trait。

标准库里的关系可以简化理解成：

```rust
trait Copy: Clone {}
```

也就是说：

- 所有 `Copy` 类型都必须同时是 `Clone`。
- 但不是所有 `Clone` 类型都能是 `Copy`。

常见 `Copy` 类型包括：

- 整数
- 浮点数
- `bool`
- `char`
- 只包含 `Copy` 类型的 tuple

# Clone

如果想显式复制一份堆数据，可以使用 `clone`。

```rust
fn main() {
    let a = String::from("hello");
    let b = a.clone();

    println!("{}", a);
    println!("{}", b);
}
```

`clone` 会创建一份新的堆数据，所以 `a` 和 `b` 都有效。

但这也意味着成本更高。

所以要区分：

- `Copy`：隐式复制，语义上就是“复制一份仍然安全”。
- `Clone`：显式复制，由类型自己定义复制逻辑，可能有成本。

Rust 要求你写出 `clone()`，就是在提醒你：这里发生了一次真正的复制。

`String` 是 `Clone`，但不是 `Copy`。

因为 `String` 拥有堆内存，隐式复制会带来重复释放风险；但显式 `clone()` 可以重新分配一份堆数据，所以它可以实现 `Clone`。

# Drop

当所有者离开作用域时，Rust 会调用 `drop` 释放资源。

```rust
struct User {
    name: String,
}

fn main() {
    let user = User {
        name: String::from("rekord"),
    };

    println!("{}", user.name);
}
```

`main` 结束时，`user` 离开作用域。`User` 被释放，它内部的 `String` 也会被释放。

如果类型实现了 `Drop`，离开作用域时会执行自定义清理逻辑。

这就是 RAII：资源的生命周期绑定到变量的作用域。

# Copy、Clone、Drop 的边界

`Copy`、`Clone`、`Drop` 不是随便组合的。

如果一个类型实现了 `Drop`，它就不能实现 `Copy`。

原因很直接：`Copy` 会让一个值被隐式复制出多份，而 `Drop` 又意味着这个类型需要负责释放资源。如果两者同时存在，就很容易让多份值重复释放同一份资源。

所以：

- `Copy` 适合简单值，复制便宜，也不需要自定义清理。
- `Clone` 适合显式复制，可能有成本。
- `Drop` 表示这个类型离开作用域时有资源要清理。

所以这三个关系可以压缩成一句话：

> `Copy` 依赖 `Clone`，但 `Copy` 和 `Drop` 不能共存。

# 共享所有权：Rc 和 Arc

“同一时间只能有一个所有者”是默认模型，但 Rust 也允许共享所有权。

共享所有权不是让多个变量都随便释放同一份资源，而是把“还有多少所有者”记录下来。

这就是引用计数。

它和多个共享引用 `&T` 解决的问题不同。

多个 `&T` 只是借用：

```rust
let s = String::from("hello");
let a = &s;
let b = &s;

println!("{} {}", a, b);
```

这里 `a` 和 `b` 都不能决定 `s` 活多久。

真正拥有 `String` 的还是变量 `s`。`s` 离开作用域后，所有引用都不能继续存在。

即使引用变量可以重新绑定到别的引用，它也只是换了借用目标，不会变成所有者。

`Rc<T>` / `Arc<T>` 则是共享拥有：

```rust
use std::rc::Rc;

let data = Rc::new(String::from("hello"));
let a = Rc::clone(&data);
let b = Rc::clone(&data);
```

这里 `data`、`a`、`b` 都是所有者的一部分。

只要还有一个 `Rc` 活着，里面的 `String` 就不会释放。

所以区别可以压缩成一句话：

> `&T` 解决“临时一起读”，`Rc<T>` / `Arc<T>` 解决“多个地方都要负责让数据继续活着”。

`Rc<T>` 用于单线程共享所有权：

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

`Rc::clone` 不会复制里面的 `String`。

它只是增加引用计数。

当最后一个 `Rc` 离开作用域时，里面的 `String` 才会被释放。

`Arc<T>` 是线程安全版本：

`Arc` 的引用计数是原子的，可以跨线程使用，成本也比 `Rc` 更高。

简单判断：

- 单线程共享所有权：`Rc<T>`。
- 多线程共享所有权：`Arc<T>`。
- 只是临时使用：优先借用 `&T`，不要上来就用 `Rc` 或 `Arc`。

`Rc` 和 `Arc` 解决的是“多个地方都需要拥有同一份数据”的问题。

它们不自动解决可变性问题。多个所有者共享的数据默认仍然不能随便改。

如果需要共享且修改，通常会组合其他类型：

- 单线程：`Rc<RefCell<T>>`。
- 多线程：`Arc<Mutex<T>>`。

所以共享所有权可以理解成：

> 所有权仍然存在，只是从“唯一所有者”变成了“引用计数管理的一组所有者”。

# 部分移动

move 可以发生在结构体的某个字段上。

```rust
struct User {
    name: String,
    age: u8,
}

fn main() {
    let user = User {
        name: String::from("rekord"),
        age: 18,
    };

    let name = user.name;

    println!("{}", name);
    println!("{}", user.age);
    // println!("{}", user.name); // 错误：name 已经被 move
}
```

`user.name` 被移动后，`user` 这个整体不能再完整使用，但没有被移动的字段仍然可以使用。

这说明所有权不是只作用在变量名上，也会作用在字段级别。

但如果类型实现了 `Drop`，通常不能直接把字段 move 出来。

原因是：析构时需要一个完整有效的值。如果字段被拿走了，`Drop` 逻辑可能面对一个半残的对象。

这时要么重新设计类型，要么用 `Option<T>`、`std::mem::take`、`std::mem::replace` 这类方式显式留下一个有效替代值。

# 主动释放和取出值

Rust 默认在作用域结束时释放资源，但也可以主动提前释放。

```rust
fn main() {
    let s = String::from("hello");
    drop(s);

    // println!("{}", s); // 错误：s 已经被 drop 消耗
}
```

`drop(s)` 本质上是把 `s` 的所有权传给 `drop` 函数，然后立即释放。

如果需要从一个可变位置里取出值，同时留下一个合法值，可以用 `std::mem::take`：

```rust
fn main() {
    let mut name = String::from("rekord");
    let old = std::mem::take(&mut name);

    println!("{}", old);
    println!("{}", name); // 空字符串
}
```

`take` 会把原值拿走，并用 `Default::default()` 填回去。

如果类型没有合适的默认值，可以用 `std::mem::replace`：

```rust
let old = std::mem::replace(&mut name, String::from("new"));
```

这些工具的核心都是同一件事：

> 不能凭空拿走一个值，必须保证原来的位置仍然处于有效状态。

# 析构顺序

所有权还决定资源释放顺序。

局部变量通常按声明顺序的反方向释放：

```rust
fn main() {
    let a = String::from("a");
    let b = String::from("b");
}
```

这里 `b` 会先释放，`a` 后释放。

结构体字段会按字段声明顺序释放。自定义 `Drop::drop` 会先执行，随后字段再自动释放。

多数业务代码不需要手动依赖析构顺序，但写锁、文件、临时目录、事务这类资源封装时，它会影响设计。

# 所有权解决了什么

所有权主要解决三类问题：

1. 什么时候释放资源。
2. 谁负责释放资源。
3. 如何避免重复释放和悬空引用。

在带垃圾回收的语言中，释放时机交给运行时决定。

Rust 的做法不同：

> 资源释放由所有权规则决定，并在编译期检查。

这就是 Rust 能在没有 GC 的情况下保证内存安全的关键。

# 总结

所有权可以先记住这几句话：

- 值有且只有一个所有者。
- 所有者离开作用域时，值会被释放。
- 赋值和传参可能移动所有权。
- `Copy` 类型会复制，不会移动。
- `clone()` 是显式复制，可能有成本。
- `Drop` 负责在作用域结束时清理资源。
- `Rc` 和 `Arc` 用引用计数表达共享所有权。
- 部分字段也可能被 move。
- `drop`、`take`、`replace` 都是在显式处理所有权转移。
- 函数签名和方法签名会表达是否接管所有权。

所有权讲的是“谁负责这个值”。
