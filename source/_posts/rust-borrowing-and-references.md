---
title: Rust 核心概念（二）：借用与引用
date: 2026/05/31
updated: 2026/05/31
index_img: https://cdn.sxrekord.com/blog/code.jpg
banner_img: https://cdn.sxrekord.com/blog/code.jpg
categories:
- 技术
tags:
- Rust
- 学习笔记
---

借用与引用，核心问题是：

> 不拿走所有权，能不能使用这个值？

答案是可以，这就是借用。

# 为什么需要借用

如果函数每次使用一个值都要拿走所有权，代码会很别扭。

这时应该使用引用。

# 不可变引用

引用写作 `&T`。

```rust
fn len(s: &String) -> usize {
    s.len()
}

fn main() {
    let s = String::from("hello");
    let n = len(&s);

    println!("{}", s);
    println!("{}", n);
}
```

`&s` 表示借用 `s`，但不拿走所有权。

函数参数 `s: &String` 表示：这个函数只借用一个 `String`，不会拥有它。

所以函数结束后，原来的 `s` 仍然有效。

这就是借用。

# 引用变量能不能换指向

引用本身不是所有者，它只是临时指向一个有效的值。

如果保存引用的变量是 `mut`，它可以重新绑定到另一个引用。

```rust
fn main() {
    let a = String::from("a");
    let b = String::from("b");

    let mut r = &a;
    println!("{}", r);

    r = &b;
    println!("{}", r);
}
```

这里变的是 `r` 这个变量保存的引用值。

它不代表 `r` 拥有了 `a` 或 `b`，也不代表 `r` 能决定它们什么时候释放。

要区分两个写法：

- `let mut r = &a`：变量 `r` 可以重新绑定到别的引用。
- `let r = &mut a`：通过 `r` 可以修改被借用的值。

前者改的是引用变量。

后者改的是被引用的值。

# 可变引用

如果想通过引用修改值，需要可变引用 `&mut T`。

```rust
fn change(s: &mut String) {
    s.push_str(" world");
}

fn main() {
    let mut s = String::from("hello");
    change(&mut s);

    println!("{}", s);
}
```

这里有两个 `mut`：

- `let mut s`：变量本身可变。
- `&mut s`：以可变方式借用。

少任何一个都不行。

# 可变变量和可变引用不是两个修改入口

这里容易有一个误解：

> 既然有一个可变变量 `s`，又有一个可变引用 `&mut s`，是不是就有两个地方可以同时修改？

答案是否定的。

创建可变引用后，原变量会被独占借用。

```rust
fn main() {
    let mut s = String::from("hello");

    let r = &mut s;

    // s.push_str(" world"); // 错误：s 正在被 r 可变借用
    r.push_str(" rust");

    println!("{}", r);
}
```

在 `r` 还会被使用期间，不能再通过 `s` 修改同一个值。

所以同一时间真正可用的修改入口只有一个。

如果 `r` 最后一次使用结束，借用也结束，之后才能重新使用 `s`：

```rust
fn main() {
    let mut s = String::from("hello");

    let r = &mut s;
    r.push_str(" rust");
    println!("{}", r);

    s.push_str(" world");
    println!("{}", s);
}
```

这也是 Rust 借用规则的核心：

> 可变引用不是多开一个修改入口，而是暂时把修改权从原变量转交给引用。

# 多个不可变引用

同一时间可以有多个不可变引用。

```rust
fn main() {
    let s = String::from("hello");

    let a = &s;
    let b = &s;

    println!("{} {}", a, b);
}
```

因为大家都只是读，不会修改数据，所以可以共存。

# 只能有一个可变引用

同一时间只能有一个可变引用。

```rust
fn main() {
    let mut s = String::from("hello");

    let a = &mut s;
    // let b = &mut s; // 错误

    println!("{}", a);
}
```

如果允许多个可变引用同时存在，就可能出现两个地方同时修改同一份数据。

Rust 直接在编译期禁止这种情况。

# 可变引用和不可变引用不能同时存在

下面这段代码不能通过编译：

```rust
fn main() {
    let mut s = String::from("hello");

    let a = &s;
    let b = &mut s; // 错误

    println!("{}", a);
    println!("{}", b);
}
```

原因是：`a` 正在不可变借用 `s`，它期待数据不会变化；此时再创建 `b` 去修改 `s`，就破坏了这个假设。

Rust 的借用规则可以压缩成一句话：

> 同一时间，要么有多个不可变引用，要么只有一个可变引用。

# 引用的作用域

引用的作用域通常到最后一次使用为止。

```rust
fn main() {
    let mut s = String::from("hello");

    let a = &s;
    println!("{}", a);

    let b = &mut s;
    b.push_str(" world");

    println!("{}", b);
}
```

这段代码可以通过编译。

虽然 `a` 和 `b` 写在同一个作用域里，但 `a` 在 `println!("{}", a)` 后就不再使用了。所以创建 `b` 时，不可变借用已经结束。

这叫非词法生命周期，简称 NLL。

> 引用活到最后一次使用，而不一定活到大括号结束。

# 悬空引用

Rust 不允许返回悬空引用。

```rust
fn dangling() -> &String {
    let s = String::from("hello");
    &s
}
```

这段代码不能通过编译。

因为 `s` 在函数结束时会被释放，返回 `&s` 就会让外部拿到一个指向已释放内存的引用。

Rust 会直接拒绝这种代码。

正确做法是返回所有权：

```rust
fn no_dangling() -> String {
    let s = String::from("hello");
    s
}
```

这时 `String` 的所有权从函数返回给调用者，不会悬空。

# `&String` 和 `&str`

很多新手会写：

```rust
fn len(s: &String) -> usize {
    s.len()
}
```

但实际更推荐：

```rust
fn len(s: &str) -> usize {
    s.len()
}
```

原因是 `&str` 更通用。

```rust
fn main() {
    let a = String::from("hello");
    let b = "world";

    println!("{}", len(&a));
    println!("{}", len(b));
}

fn len(s: &str) -> usize {
    s.len()
}
```

`&String` 只能接收 `String` 的引用，而 `&str` 可以接收 `String` 的切片，也可以接收字符串字面量。

简单说：

> 函数只需要读字符串时，优先用 `&str`。

# slice

slice 是对一段连续数据的引用。

字符串切片：

```rust
fn main() {
    let s = String::from("hello world");
    let hello = &s[0..5];

    println!("{}", hello);
}
```

`hello` 并不拥有数据，它只是引用了 `s` 的一部分。

数组切片：

```rust
fn main() {
    let nums = [1, 2, 3, 4];
    let part = &nums[1..3];

    println!("{:?}", part);
}
```

slice 的本质仍然是引用，所以它也遵守借用规则。

# 借用解决了什么

借用解决的是所有权太严格带来的使用问题。

所有权保证资源只有一个负责人，但代码经常需要临时使用一个值。

借用提供了一种方式：

- 不移动所有权。
- 可以读取值。
- 在明确可变借用时可以修改值。
- 编译器保证引用不会乱用。

这就是 Rust 能同时做到安全和高性能的重要原因。

# 总结

借用与引用可以先记住这几句话：

- `&T` 是不可变引用，只能读。
- `&mut T` 是可变引用，可以改。
- 借用不会转移所有权。
- 同一时间可以有多个不可变引用。
- 同一时间只能有一个可变引用。
- 可变引用和不可变引用不能同时存在。
- slice 是引用，也遵守借用规则。

所有权回答“值归谁”。

借用回答“不拿走所有权，能不能用”。
