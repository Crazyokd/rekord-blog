---
title: Rust 核心概念（五）：错误处理
date: 2026/06/03
updated: 2026/06/03
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

Rust 的错误处理不是以异常为主，而是把错误写进类型系统。

# 两类错误

Rust 通常把错误分成两类：

- 不可恢复错误：程序无法继续，直接终止。
- 可恢复错误：调用方可以处理，继续运行。

不可恢复错误通常用 `panic!`。

可恢复错误通常用 `Result<T, E>`。

# panic!

`panic!` 表示程序遇到了无法继续执行的问题。

```rust
fn main() {
    panic!("something went wrong");
}
```

常见场景包括：

- 数组越界
- 明显违反程序不变量
- 示例代码中快速暴露问题

例如：

```rust
fn main() {
    let nums = vec![1, 2, 3];
    println!("{}", nums[10]);
}
```

索引越界会触发 panic。

`panic!` 适合表达“这里不应该发生，一旦发生程序无法安全继续”。

# Result

大多数业务错误不应该用 `panic!`，而应该用 `Result<T, E>`。

`Result` 本质上是一个 enum：

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

它表示：

- `Ok(T)`：成功，里面是结果值。
- `Err(E)`：失败，里面是错误值。

例如：

```rust
use std::fs::File;

fn main() {
    let result = File::open("hello.txt");

    match result {
        Ok(file) => println!("opened"),
        Err(error) => println!("failed: {}", error),
    }
}
```

文件不存在不是程序崩溃级错误，调用者可以决定如何处理。

# unwrap

`unwrap` 会取出 `Ok` 里的值。

如果是 `Err`，就 panic。

```rust
use std::fs::File;

fn main() {
    let file = File::open("hello.txt").unwrap();
}
```

`unwrap` 很方便，但它等于告诉 Rust：

> 我确信这里一定成功，否则直接崩溃。

所以它适合：

- 临时代码
- 示例代码
- 测试代码
- 真的不可能失败的地方

业务代码里不要滥用 `unwrap`。

# expect

`expect` 和 `unwrap` 类似，但可以写清楚 panic 信息。

```rust
use std::fs::File;

fn main() {
    let file = File::open("hello.txt")
        .expect("hello.txt should exist");
}
```

如果失败，错误信息会更明确。

相比 `unwrap`，`expect` 至少说明了你的假设。

# 错误传播

很多函数自己不处理错误，而是把错误交给调用者。

不用 `?` 时，代码通常这样写：

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username() -> Result<String, io::Error> {
    let file_result = File::open("username.txt");

    let mut file = match file_result {
        Ok(file) => file,
        Err(error) => return Err(error),
    };

    let mut name = String::new();

    match file.read_to_string(&mut name) {
        Ok(_) => Ok(name),
        Err(error) => Err(error),
    }
}
```

这段代码能工作，但很啰嗦。

# ? 操作符

`?` 用来简化错误传播。

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_username() -> Result<String, io::Error> {
    let mut file = File::open("username.txt")?;
    let mut name = String::new();
    file.read_to_string(&mut name)?;
    Ok(name)
}
```

`?` 的意思是：

- 如果是 `Ok(value)`，取出 `value` 继续执行。
- 如果是 `Err(error)`，直接从当前函数返回 `Err(error)`。

所以使用 `?` 的函数，返回值通常也必须是 `Result`。

# 错误类型转换

`?` 不只是提前返回错误。

如果当前函数返回的错误类型和实际错误类型不同，`?` 会尝试用 `From` 做转换。

例如：

```rust
use std::fs;
use std::num::ParseIntError;

#[derive(Debug)]
enum AppError {
    Io(std::io::Error),
    Parse(ParseIntError),
}

impl From<std::io::Error> for AppError {
    fn from(error: std::io::Error) -> Self {
        AppError::Io(error)
    }
}

impl From<ParseIntError> for AppError {
    fn from(error: ParseIntError) -> Self {
        AppError::Parse(error)
    }
}

fn read_number() -> Result<i32, AppError> {
    let text = fs::read_to_string("number.txt")?;
    let number = text.trim().parse::<i32>()?;
    Ok(number)
}
```

这里 `read_to_string` 返回 `std::io::Error`，`parse` 返回 `ParseIntError`。

但函数统一返回 `AppError`，因为两个错误都实现了 `From` 转换。

如果只想临时改一下错误，也可以用 `map_err`：

```rust
let number = text
    .trim()
    .parse::<i32>()
    .map_err(AppError::Parse)?;
```

小项目里也常见这种写法：

```rust
fn run() -> Result<(), Box<dyn std::error::Error>> {
    let text = std::fs::read_to_string("number.txt")?;
    let number: i32 = text.trim().parse()?;
    println!("{}", number);
    Ok(())
}
```

`Box<dyn Error>` 适合快速合并多种错误。

如果是长期维护的业务代码，更推荐定义清晰的错误类型。

# Option 也能用 ?

`?` 不只用于 `Result`，也能用于 `Option`。

```rust
fn first_char(s: Option<&str>) -> Option<char> {
    let text = s?;
    text.chars().next()
}
```

这里的规则是：

- `Some(value)`：取出 value。
- `None`：直接返回 `None`。

# Result 和 Option 的区别

`Option<T>` 表示：

> 值可能存在，也可能不存在。

`Result<T, E>` 表示：

> 操作可能成功，也可能失败；失败时要说明原因。

例如：

```rust
fn find_user(id: u64) -> Option<User> {
    // 找不到就是没有
}

fn read_config() -> Result<String, std::io::Error> {
    // 失败需要说明 IO 错误
}
```

如果调用者需要知道失败原因，用 `Result`。

如果只关心有没有，用 `Option`。

# 总结

- `panic!` 用于不可恢复错误。
- `Result<T, E>` 用于可恢复错误。
- `Ok(T)` 表示成功。
- `Err(E)` 表示失败。
- `unwrap` 失败会 panic，不要滥用。
- `expect` 至少应该写清楚失败假设。
- `?` 用来把错误传播给调用者。
- `?` 可以通过 `From` 转换错误类型。
- `map_err` 可以手动转换错误。
- `Option` 表达有没有值。
- `Result` 表达成功或失败，并携带失败原因。

Rust 错误处理的核心不是语法技巧，而是：

> 把可能失败这件事写进函数签名里。
