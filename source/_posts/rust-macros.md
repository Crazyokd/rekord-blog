---
title: Rust 核心概念（十四）：宏
date: 2026/07/15
updated: 2026/07/15
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

宏解决的核心问题是 Rust 如何在编译期生成代码？

宏是 Rust 的元编程能力。它很强，但不应该过早滥用。

# 为什么需要宏

函数可以复用运行时逻辑。

宏可以生成代码。

例如：

```rust
println!("hello {}", "rust");
vec![1, 2, 3];
```

`println!` 和 `vec!` 都是宏。

名字后面有 `!`，这是 Rust 宏的明显标志。

# 宏和函数的区别

函数接收已经确定类型和数量的参数。

宏接收的是 token，可以在编译期展开成代码。

它只能看到输入长什么样，不能直接根据运行时值做判断，也看不到类型推导的最终结果。

例如 `println!` 能接收不同数量的参数：

```rust
println!("hello");
println!("hello {}", "rust");
println!("{} {}", "hello", "rust");
```

普通函数很难以同样方式表达这种参数形式。

# macro_rules!

`macro_rules!` 用来定义声明宏。

```rust
macro_rules! say_hello {
    () => {
        println!("hello");
    };
}

fn main() {
    say_hello!();
}
```

调用 `say_hello!()` 时，编译器会把它展开成 `println!("hello")`。

## 匹配模式

宏可以匹配不同输入形式。

```rust
macro_rules! create_vec {
    ($($x:expr),*) => {
        {
            let mut temp = Vec::new();
            $(
                temp.push($x);
            )*
            temp
        }
    };
}

fn main() {
    let nums = create_vec![1, 2, 3];
    println!("{:?}", nums);
}
```

这里：

- `$x:expr` 匹配表达式。
- `*` 表示重复零次或多次。

这就是 `vec!` 一类宏的基本思想。

`macro_rules!` 匹配的是 token tree，不是类型。

常见的 fragment specifier 还有：

- `ident`
- `ty`
- `path`
- `pat`
- `block`
- `tt`

`tt` 最宽松，适合把一段语法继续向下传。

`macro_rules!` 还带卫生机制，宏里定义的临时名字通常不会和调用方冲突。
如果需要跨 crate 引用宏导出的项，常会看到 `$crate`。

# 过程宏

Rust 宏大体分两类：

- 声明宏：`macro_rules!`
- 过程宏：接收 token stream，输出 token stream

过程宏又常见三种：

- derive macro
- attribute macro
- function-like macro

过程宏通常放在独立的 `proc-macro` crate 中实现。入口函数拿到的是 `proc_macro::TokenStream`，常见做法是先用 `syn` 解析，再用 `quote` 生成输出。

```rust
use proc_macro::TokenStream;

#[proc_macro_derive(Hello)]
pub fn hello(input: TokenStream) -> TokenStream {
    // parse with syn, emit with quote
    todo!()
}
```

这类宏只处理 token，不直接理解类型系统里的语义。

## derive macro

derive macro 用来自动实现 trait。

```rust
#[derive(Debug, Clone)]
struct User {
    name: String,
}
```

`Debug` 和 `Clone` 的实现由编译器和宏生成。

没有 derive，就要手写这些实现。

如果结构体带泛型或 `where` 约束，derive 生成的 `impl` 也会把这些信息一起带上。

derive macro 常见于：

- `Debug`
- `Clone`
- `Copy`
- `PartialEq`
- `Eq`
- `Serialize`
- `Deserialize`

## attribute macro

不是所有 `#[...]` 都是 attribute macro。

像 `#[test]`、`#[allow(...)]`、`#[cfg(...)]` 这类很多是内建属性，不是宏。

真正的 attribute macro 会在编译期改写 item。`#[tokio::main]` 是更典型的例子。

```rust
#[tokio::main]
async fn main() {
}
```

`#[derive(...)]` 则单独算 derive macro。

它会在编译期改写或包装相关代码。

## function-like macro

function-like macro 看起来像函数调用，但带 `!`。

```rust
println!("hello");
format!("hello {}", "rust");
vec![1, 2, 3];
```

这类宏长得像函数调用，但实现方式不一定相同。

`println!`、`format!`、`vec!` 这些最常见的其实是 `macro_rules!` 宏。
真正的 function-like procedural macro 也存在，但日常没那么常见。

它们可以接收更灵活的 token 输入。

# 调试宏

宏出问题时，先看展开后的代码。

- `cargo expand` 可以直接看最终展开。
- `compile_error!` 适合把错误尽量推到更具体的位置。
- 读报错时，不要只盯着宏调用点，也要看展开后的实现。

# 宏的代价

宏能减少重复，但也有代价：

- 展开后的代码不直观。
- 错误信息可能更难读。
- IDE 跳转和调试可能更复杂。
- 展开后代码量会变大，编译时间也可能上升。
- 过度使用会降低可维护性。

# 什么时候适合宏

宏适合：

- 需要可变数量参数。
- 需要生成重复代码。
- 需要编译期代码转换。
- 需要为类型自动实现 trait。
- 需要定义小型 DSL。

例如序列化、ORM、Web 框架、测试框架中经常能看到宏。

# 总结

宏的核心是当普通函数和 trait 难以消除重复时，用编译期生成代码表达模式。
