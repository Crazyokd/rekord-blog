---
title: Rust 核心概念（九）：Cargo 与项目管理
date: 2026/06/16
updated: 2026/06/16
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

Cargo 是 Rust 官方工具链的一部分。不会 Cargo，就很难写真实 Rust 项目。

# 创建项目

创建一个可执行项目：

```bash
cargo new hello
```

目录大致是：

```text
hello/
  Cargo.toml
  src/
    main.rs
```

创建库项目：

```bash
cargo new hello --lib
```

库项目入口通常是：

```text
src/lib.rs
```

# Cargo.toml

`Cargo.toml` 是项目配置文件。

常见内容：

```toml
[package]
name = "hello"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = "1"
```

`[package]` 描述当前包。

`[dependencies]` 描述依赖。

Cargo 会根据这个文件解析依赖、构建项目。

# Cargo.lock

`Cargo.lock` 记录实际解析出来的依赖版本。

它的作用是保证构建可复现。

一般规则：

- 应用程序应该提交 `Cargo.lock`。
- 库是否提交 `Cargo.lock` 要看项目策略。

# 构建

构建项目：

```bash
cargo build
```

默认是 debug 构建，产物在：

```text
target/debug/
```

release 构建：

```bash
cargo build --release
```

产物在：

```text
target/release/
```

# 运行

运行项目：

```bash
cargo run
```

它会先构建，再运行。

如果要传参数给程序：

```bash
cargo run -- input.txt
```

`--` 后面的内容会传给你的程序。

# 检查

只检查是否能通过编译，不生成最终产物：

```bash
cargo check
```

`cargo check` 通常比 `cargo build` 快。

开发时频繁验证代码，优先用它。

# 测试

运行测试：

```bash
cargo test
```

它会执行：

- 单元测试
- 集成测试
- 文档测试

# 文档

生成文档：

```bash
cargo doc
```

打开生成的文档：

```bash
cargo doc --open
```

Rust 很重视文档，公开 API 的文档会成为项目质量的一部分。

# 依赖

依赖写在 `[dependencies]` 下。

```toml
[dependencies]
serde = "1"
tokio = { version = "1", features = ["full"] }
```

有些 crate 通过 feature 控制功能。

例如 `tokio` 的 `full` 会打开一组常用功能。

# feature

feature 用来控制可选功能。

库可以声明自己的 feature：

```toml
[features]
default = ["json"]
json = []
```

依赖也可以启用 feature：

```toml
[dependencies]
serde = { version = "1", features = ["derive"] }
```

# attribute

attribute 是写给编译器、工具或宏看的元信息。它会影响编译器如何处理某个 crate、module、item、表达式或宏输入。

在 Cargo 这一篇里，可以把 attribute 理解成“和构建、条件编译、派生、测试相关的配置层”。

attribute 有两种形式：

```rust
#![deny(unsafe_code)]

#[derive(Debug)]
pub struct User {
    name: String,
}
```

`#![...]` 是 inner attribute，作用在它所在的外围对象上。

在 `src/lib.rs` 或 `src/main.rs` 顶部，inner attribute 作用在整个 crate 上：

```rust
#![deny(unsafe_code)]
#![warn(missing_docs)]
```

在模块内部，inner attribute 作用在当前模块上：

```rust
mod user {
    #![allow(dead_code)]

    fn validate() {}
}
```

`#[...]` 是 outer attribute，作用在紧跟着它的 item 上：

```rust
#[derive(Debug, Clone)]
pub struct User {
    pub name: String,
}

#[test]
fn create_user() {}
```

## #[path]

正常情况下，`mod user;` 会按约定找：

```text
src/user.rs
src/user/mod.rs
```

`#[path]` 可以改这个查找路径：

```rust
#[path = "models/user.rs"]
mod user;
```

这表示模块名仍然是 `user`，但源码来自 `models/user.rs`。

它改变的是模块文件的位置，不改变模块在模块树里的名字。

也就是说，外部路径仍然是：

```rust
crate::user::create();
```

不是：

```rust
crate::models::user::create();
```

`#[path]` 有用，但不要滥用。它会打破 Rust 默认的文件布局约定，让读代码的人不能只靠 `mod user;` 推出文件位置。只有在迁移旧目录、绑定生成代码、或者确实需要和外部目录结构对齐时，才值得使用。

## cfg

`cfg` 用来做条件编译。

例如按平台选择不同模块：

```rust
#[cfg(unix)]
mod platform;

#[cfg(windows)]
mod platform;
```

这两个模块名字都叫 `platform`，但同一次编译里只会启用其中一个。

也可以配合 feature：

```rust
#[cfg(feature = "sqlite")]
mod sqlite;

#[cfg(feature = "postgres")]
mod postgres;
```

这里的 `feature` 来自 `Cargo.toml`：

```toml
[features]
sqlite = []
postgres = []
```

`cfg` 是编译期选择，不是运行时 `if`。

被 `cfg` 排除的代码不会进入本次编译，所以它甚至可以引用当前平台不存在的系统 API。

`cfg_attr` 则表示“条件满足时才添加某个 attribute”：

```rust
#![cfg_attr(not(test), deny(unsafe_code))]
```

意思是非测试编译时启用 `deny(unsafe_code)`。

## lint attribute

lint attribute 常用于控制警告级别：

```rust
#![deny(unsafe_code)]
#![warn(missing_docs)]

#[allow(dead_code)]
fn helper_for_later() {}
```

常见级别有：

- `allow`：允许，不报警。
- `warn`：给警告。
- `deny`：当作错误。
- `forbid`：禁止，并且后面不能再降低级别。

crate 级别适合表达项目规则，item 级别适合处理局部例外。

例如不要为了一个没用到的函数在整个 crate 上写：

```rust
#![allow(dead_code)]
```

更好的做法是把范围收窄：

```rust
#[allow(dead_code)]
fn helper_for_later() {}
```

## 宏相关 attribute

有些 attribute 会触发宏展开。

最常见的是派生宏：

```rust
#[derive(Debug, Clone, PartialEq)]
pub struct User {
    pub name: String,
}
```

还有属性宏：

```rust
#[tokio::main]
async fn main() {
}
```

这里的 `#[tokio::main]` 不是普通注释，而是过程宏。它会在编译期改写 `main` 函数，让异步运行时能够启动。

# workspace

workspace 用来管理多个 package。

```text
my-workspace/
  Cargo.toml
  api/
    Cargo.toml
    src/
      lib.rs
  core/
    Cargo.toml
    src/
      lib.rs
  worker/
    Cargo.toml
    src/
      main.rs
```

根 `Cargo.toml`：

```toml
[workspace]
members = ["api", "core", "worker"]
```

workspace 适合拆分大型项目。

多个 package 可以共享同一个 `target` 目录和依赖解析结果。

但 workspace 只是工程组织关系，不是模块系统的一层。

这几个边界要分清：

- workspace 管多个 package。
- package 里可以有一个或多个 crate。
- crate 里才有 module tree。

所以 workspace 不会把不同 package 的模块树合并成一棵树。

每个 package 还是各自拥有自己的 crate root。一个 package 也不能因为和另一个 package 在同一个 workspace，就直接访问它的私有模块。

跨 package 复用代码，依然要通过依赖关系和公开 API。

例如 `worker` 要使用 `api`：

```toml
# worker/Cargo.toml
[dependencies]
api = { path = "../api" }
```

然后在 `worker` 的代码里：

```rust
// worker/src/main.rs
use api::user::create;

fn main() {
    create();
}
```

这里 `worker` 能使用 `api::user::create`，不是因为它们在同一个 workspace，而是因为：

- `worker` 在 `Cargo.toml` 里依赖了 `api`。
- `api` 把 `user::create` 通过 `pub` 暴露了出来。

workspace 解决的是“多个 package 怎么一起构建和管理”，不是“多个模块怎么互相访问”。

# bin 和 lib

一个 package 可以同时有库和可执行程序。

常见结构：

```text
src/
  lib.rs
  main.rs
```

`lib.rs` 放可复用逻辑。

`main.rs` 放程序入口。

这样测试和复用都会更方便。
