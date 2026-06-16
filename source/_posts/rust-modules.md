---
title: Rust 核心概念（八）：模块系统
date: 2026/06/06
updated: 2026/06/16
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

模块系统不是语法细节，它决定了项目结构能不能长期维护。

# package、crate、module

先区分三个词。

`package` 是 Cargo 管理、构建和发布的项目单元。

一个 package 里有 `Cargo.toml`。

`crate` 是 Rust 编译单元，也是 Rust 做名称解析、可见性检查、依赖连接和最终产物生成的基本边界。

crate 分两类：

- binary crate：编译成可执行程序。
- library crate：编译成库。

一个 package 可以同时包含一个 library crate 和多个 binary crate。

例如：

```text
my-app/
  Cargo.toml
  src/
    lib.rs
    main.rs
  src/bin/
    worker.rs
    admin.rs
```

这里通常会产生这些 crate：

- `src/lib.rs`：library crate。
- `src/main.rs`：默认 binary crate。
- `src/bin/worker.rs`：名为 `worker` 的 binary crate。
- `src/bin/admin.rs`：名为 `admin` 的 binary crate。

这些 crate 属于同一个 package，但它们是不同的编译入口。

`module` 是 crate 内部组织代码的方式。

简单理解：

- package：项目。
- crate：编译单元和 API 边界。
- module：代码命名空间。

这三个层次不要混在一起：

- Cargo 先根据 `Cargo.toml` 找到 package 和目标 crate。
- 编译器从每个 crate root 开始构建模块树。
- 模块树里的 item 再通过 `pub`、`use` 和路径规则组织起来。

# workspace

workspace 也是 Cargo 的工程组织概念，但它管的是多个 package，不是单个 crate 里的模块树。

典型结构像这样：

```text
my-workspace/
  Cargo.toml
  api/
    Cargo.toml
    src/
      lib.rs
  worker/
    Cargo.toml
    src/
      main.rs
```

根 `Cargo.toml` 里会列出成员 package。这样做的意义是把多个 package 放在同一个仓库、同一个依赖解析结果和同一个构建入口下。

但要注意：

- workspace 不会把不同 package 的模块树合并成一棵树。
- 每个 package 还是各自拥有自己的 crate root。
- 一个 package 不能直接访问另一个 package 的私有模块。

跨 package 复用代码，依然要通过公开 API 和依赖关系：

```rust
// worker/src/main.rs
use api::user::create;

fn main() {
    create();
}
```

这里 `worker` 之所以能用 `api::user::create`，不是因为它们在同一个 workspace，而是因为 `worker` 依赖了 `api`，并且 `api` 把这个 item 公开了。


# crate root

crate root 是编译器开始构建模块树的入口。

常见入口是：

- `src/main.rs`：binary crate 的 crate root。
- `src/lib.rs`：library crate 的 crate root。

`main.rs` 就是这个 binary crate 的根，`lib.rs` 就是这个 library crate 的根。

crate root 不是“项目根目录”，而是某个 crate 的模块树根节点。

例如：

```text
src/
  lib.rs
  user.rs
  main.rs
```

如果 `lib.rs` 中写：

```rust
pub mod user;
```

那么 `user` 是 library crate 的子模块。

如果 `main.rs` 中也写：

```rust
mod user;
```

那么这个 `user` 是 binary crate 的子模块。

它们读取的文件路径可能相同，但处在不同 crate 的模块树里。真实项目通常不要在 `main.rs` 和 `lib.rs` 里重复声明同一套模块，而是让 binary crate 通过 package 的 library crate 使用公共逻辑：

```rust
// src/main.rs
use my_app::user;

fn main() {
    user::create();
}
```

# mod

`mod` 用来声明模块。

```rust
mod user {
    pub fn create() {
        println!("create user");
    }
}

fn main() {
    user::create();
}
```

这里 `user` 是一个模块。

模块形成一棵树。

# 文件模块

真实项目不会把所有模块都写在一个文件里。

如果在 `src/main.rs` 里写：

```rust
mod user;

fn main() {
    user::create();
}
```

Rust 会去找：

```text
src/user.rs
```

然后在 `src/user.rs` 中写：

```rust
pub fn create() {
    println!("create user");
}
```

这就是最常见的拆文件方式。

# 子模块目录

如果模块继续变大，可以放到目录里。

```text
src/
  main.rs
  user/
    mod.rs
    service.rs
```

在 `main.rs` 中：

```rust
mod user;
```

在 `user/mod.rs` 中：

```rust
mod service;

pub fn create() {
    service::create();
}
```

在 `user/service.rs` 中：

```rust
pub fn create() {
    println!("create user");
}
```

也可以使用较新的文件布局：

```text
src/
  user.rs
  user/
    service.rs
```

在 `user.rs` 中声明：

```rust
mod service;
```

两种方式都能用，项目里保持一致更重要。

# attribute

Rust 的 attribute 是写给编译器、工具或宏看的元信息。它会影响编译器如何处理某个 crate、module、item、表达式或宏输入。

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

理解模块系统时，最常见的几个 attribute 是 `path`、`cfg`、lint 控制和宏相关 attribute。

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

---

所以阅读 Rust 项目时，不能只看 `mod` 和 `pub`。如果模块声明上面有 attribute，要先理解 attribute 对模块树做了什么。

# pub

Rust 默认私有。模块里的 item 如果不加 `pub`，外部模块不能访问。

```rust
mod user {
    fn validate() {
        println!("validate");
    }

    pub fn create() {
        validate();
    }
}

fn main() {
    user::create();
    // user::validate(); // 错误：validate 是私有的
}
```

# 受限可见性

`pub` 表示对外公开，但真实项目里经常需要更细的范围。

常见写法：

```rust
pub(crate) fn only_in_current_crate() {}

pub(super) fn only_for_parent_module() {}
```

含义是：

- `pub(crate)`：当前 crate 内可见。
- `pub(super)`：父模块可见。

# pub struct 的字段

结构体本身 `pub`，不代表字段也是 `pub`。

```rust
pub struct User {
    pub name: String,
    age: u8,
}
```

外部可以构造或访问 `name`，但不能访问 `age`。

# use

`use` 用来把路径引入当前作用域。

```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert("a", 1);
}
```

没有 `use` 时也能写完整路径：

```rust
let mut map = std::collections::HashMap::new();
```

`use` 只是让代码更短，不改变可见性。

`use` 的作用域也是词法作用域。在哪个模块里写 `use`，名字就主要在那个模块里可用：

```rust
mod user {
    use std::collections::HashMap;

    pub fn create_cache() -> HashMap<String, String> {
        HashMap::new()
    }
}
```

外层模块不会因为子模块写了 `use HashMap` 就也能直接写 `HashMap`。

在函数内部写 `use` 也可以：

```rust
fn create_cache() {
    use std::collections::HashMap;

    let mut map = HashMap::new();
    map.insert("name", "rekord");
}
```

这种写法适合只在局部使用的名字。

# prelude

有些类型和 trait 平时没写 `use` 也能直接用，例如：

```rust
let names = vec![String::from("alice"), String::from("bob")];
let result: Result<i32, std::num::ParseIntError> = "42".parse();
```

这里的 `Vec`、`String`、`Result`、`Option`、`Some`、`None`、`Ok`、`Err` 以及很多常用 trait，并不是语言关键字，而是标准库预导入的一部分。

Rust 会给每个 crate 自动引入一组常用名字，这组名字叫 prelude。

可以粗略理解为编译器在每个模块前面帮你放了一些常用导入：

```rust
use std::prelude::rust_2021::*;
```

这只是理解模型，不是要求你真的手写这一行。

prelude 解决的是常用 API 的噪音问题。如果没有 prelude，很多基础代码会变成：

```rust
let name = std::string::String::from("alice");
let list = std::vec::Vec::new();
```

prelude 里还包含一些 trait。trait 被导入后，它的方法才能参与方法调用解析。

例如 `parse` 依赖 `FromStr`：

```rust
let port: u16 = "8080".parse().unwrap();
```

你通常不用写：

```rust
use std::str::FromStr;
```

因为相关能力已经通过 prelude 进入作用域。

但 prelude 不是“自动导入整个标准库”。例如 `HashMap` 不在标准 prelude 中，所以仍然要写：

```rust
use std::collections::HashMap;
```

外部 crate 也不会自动进入作用域。依赖写进 `Cargo.toml` 只是告诉 Cargo 下载和连接它，代码里仍然要通过路径或 `use` 使用：

```toml
[dependencies]
serde_json = "1"
```

```rust
use serde_json::Value;
```

一些框架会提供自己的 prelude，例如：

```rust
use axum::prelude::*;
```

或者：

```rust
use diesel::prelude::*;
```

这种 prelude 不是编译器自动导入的，而是库作者为了集中暴露常用 trait、类型和扩展方法提供的普通模块。它的本质仍然是 `use`。


- 标准库 prelude：编译器按 edition 自动导入。
- 第三方库 prelude：你显式 `use xxx::prelude::*`。
- 普通 `use`：按需引入具体路径。

# as

如果名字冲突，可以使用 `as` 重命名。

```rust
use std::fmt::Result as FmtResult;
use std::io::Result as IoResult;
```

这样可以同时使用两个同名类型。

# re-export

模块可以重新导出内部 item。

```rust
mod user {
    pub mod service {
        pub fn create() {}
    }

    pub use service::create;
}

fn main() {
    user::create();
}
```

`pub use` 常用于整理对外 API。

内部可以有复杂目录结构，对外暴露一个更简单的入口。

# super、self、crate

路径里常见三个关键字：

- `crate`：当前 crate 根。
- `self`：当前模块。
- `super`：父模块。

例如：

```rust
crate::user::create();
self::create();
super::create();
```
