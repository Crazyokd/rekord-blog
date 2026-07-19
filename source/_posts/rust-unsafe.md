---
title: Rust 核心概念（十三）：unsafe
date: 2026/07/14
updated: 2026/07/14
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

这一篇讲 `unsafe`，核心问题是：

> 当编译器无法证明某些操作安全时，Rust 如何表达这段责任由程序员承担？

`unsafe` 不是关闭 Rust 的所有检查。

它只是开放少数编译器无法保证安全的能力。

# unsafe 能做什么

`unsafe` 代码块允许做五类事情：

- 解引用裸指针。
- 调用 unsafe 函数或方法。
- 访问或修改可变静态变量。
- 实现 unsafe trait。
- 访问 union 字段。

注意：即使在 `unsafe` 块里，所有权和借用的大部分规则仍然存在。

# 裸指针

Rust 有两种裸指针：

- `*const T`：不可变裸指针。
- `*mut T`：可变裸指针。

```rust
fn main() {
    let mut n = 5;

    let p1 = &n as *const i32;
    let p2 = &mut n as *mut i32;
}
```

创建裸指针是安全的。

解引用裸指针才需要 `unsafe`。

```rust
fn main() {
    let n = 5;
    let p = &n as *const i32;

    unsafe {
        println!("{}", *p);
    }
}
```

裸指针可能为空、悬空，也可能违反别名规则。

所以编译器要求你显式写 `unsafe`。

# unsafe function

如果一个函数要求调用者满足额外安全条件，可以声明为 `unsafe fn`。

```rust
unsafe fn dangerous() {
    println!("dangerous");
}

fn main() {
    unsafe {
        dangerous();
    }
}
```

`unsafe fn` 的意思是：

> 调用这个函数前，调用者必须自己保证某些前提成立。

函数本身应该用文档写清这些前提。

# safe abstraction

写 unsafe 的目标通常不是让用户直接使用 unsafe。

更好的做法是把 unsafe 封装成安全 API。

标准库里很多安全 API 内部使用了 unsafe。

用户看到的是安全接口，unsafe 被限制在很小范围内。

核心原则：

> unsafe 可以出现在实现里，但不应该随意泄漏到调用方。

# FFI

调用 C 函数通常需要 unsafe。

```rust
unsafe extern "C" {
    fn abs(input: i32) -> i32;
}

fn main() {
    unsafe {
        println!("{}", abs(-3));
    }
}
```

Rust 编译器无法检查外部语言函数是否真的安全。

所以调用方必须承担责任。

# mutable static

全局可变变量是不安全的。

```rust
static mut COUNTER: u32 = 0;

fn main() {
    unsafe {
        COUNTER += 1;
        println!("{}", COUNTER);
    }
}
```

多线程访问全局可变状态很容易产生数据竞争。

一般应优先使用更安全的同步类型，而不是直接使用 `static mut`。

# unsafe trait

如果某个 trait 的正确实现需要额外安全保证，可以定义为 unsafe trait。

```rust
unsafe trait Trusted {}

unsafe impl Trusted for i32 {}
```

`unsafe impl` 表示实现者承诺满足这个 trait 要求的安全约束。

典型例子是底层并发和内存抽象。

# union

`union` 是一种 C 风格联合体，多个字段共享同一块内存。

它的大小由最大的字段决定，布局通常用于和 C 代码对接或做底层二进制处理。

```rust
#[repr(C)]
union IntOrFloat {
    i: u32,
    f: f32,
}

fn main() {
    let value = IntOrFloat { i: 0x3f800000 };

    unsafe {
        println!("{}", value.f);
    }
}
```

和 `enum` 不同，`union` 不会替你记录“当前到底是哪一个字段有效”。

所以读取字段必须放进 `unsafe`，因为你需要自己保证这块内存此刻按这个字段解释是合法的。

它常见于：

- C FFI。
- 低层二进制解析。
- 需要从不同角度查看同一段原始内存。

普通业务代码里，优先考虑 `enum`、字节转换函数，或者更明确的类型。

# unsafe 不等于不安全

`unsafe` 的含义不是“这里一定有 bug”。

它的意思是：

> 编译器无法完全证明这里安全，需要程序员证明。

优秀的 unsafe 代码通常有几个特点：

- 范围小。
- 前提写清楚。
- 外部 API 尽量安全。
- 有测试和审查。
- 不把裸指针到处传。

# 什么时候需要 unsafe

常见场景包括：

- 调用 C 库。
- 写底层数据结构。
- 做性能极端敏感的内存操作。
- 实现编译器无法表达的安全抽象。

普通业务代码通常不需要 unsafe。

# 总结

unsafe 的核心不是“逃离 Rust”，而是：

> 在编译器证明不了的地方，把安全责任明确交给程序员。
