---
title: Rust 核心概念（十）：测试
date: 2026/06/17
updated: 2026/06/17
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

Rust 把测试纳入官方工具链，直接用 `cargo test` 运行。

# 单元测试

单元测试通常写在被测试代码同一个文件里。

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_two_numbers() {
        assert_eq!(add(1, 2), 3);
    }
}
```

几个关键点：

- `#[cfg(test)]` 表示只在测试时编译。
- `#[test]` 标记测试函数。
- `use super::*` 引入父模块内容。

运行：

```bash
cargo test
```

# assert!

`assert!` 用来断言一个布尔表达式为真。

```rust
#[test]
fn number_is_positive() {
    let n = 3;
    assert!(n > 0);
}
```

如果表达式为 false，测试失败。

# assert_eq!

`assert_eq!` 用来比较两个值是否相等。

```rust
#[test]
fn add_two_numbers() {
    assert_eq!(1 + 2, 3);
}
```

失败时，它会打印左右两边的值，更容易定位问题。

如果比较不相等，用 `assert_ne!`。

# 测试 panic

有些行为就是应该 panic。

```rust
fn divide(a: i32, b: i32) -> i32 {
    if b == 0 {
        panic!("divide by zero");
    }

    a / b
}

#[test]
#[should_panic]
fn divide_by_zero_should_panic() {
    divide(1, 0);
}
```

`#[should_panic]` 表示这个测试必须 panic 才算通过。

# 返回 Result

测试函数也可以返回 `Result`。

```rust
#[test]
fn parse_number() -> Result<(), std::num::ParseIntError> {
    let n: i32 = "42".parse()?;
    assert_eq!(n, 42);
    Ok(())
}
```

这样可以在测试里使用 `?`。

如果返回 `Err`，测试失败。

# 忽略测试

耗时测试可以先标记为忽略。

```rust
#[test]
#[ignore]
fn expensive_test() {
    // ...
}
```

默认 `cargo test` 不会运行它。

运行被忽略的测试：

```bash
cargo test -- --ignored
```

# 过滤测试

可以按名字过滤测试。

```bash
cargo test add
```

这会运行名字里包含 `add` 的测试。

当测试很多时很有用。

# 集成测试

集成测试放在项目根目录的 `tests` 目录。

```text
my-crate/
  src/
    lib.rs
  tests/
    api_test.rs
```

`tests/api_test.rs`：

```rust
use my_crate::add;

#[test]
fn add_two_numbers() {
    assert_eq!(add(1, 2), 3);
}
```

集成测试像外部用户一样使用你的库。

它只能访问公开 API。

# 文档测试

Rust 文档里的代码示例也可以被测试。

```rust
/// Adds two numbers.
///
/// ```
/// let result = my_crate::add(1, 2);
/// assert_eq!(result, 3);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

运行 `cargo test` 时，文档测试也会执行。

这能防止文档示例过期。

# 测试私有函数

单元测试写在同一文件的子模块里，可以访问私有函数。

```rust
fn normalize(s: &str) -> String {
    s.trim().to_lowercase()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn normalize_text() {
        assert_eq!(normalize(" Rust "), "rust");
    }
}
```

集成测试不能访问私有函数。

这正好对应两种测试目标：

- 单元测试：验证内部细节。
- 集成测试：验证公开行为。

# 总结

Rust 测试体系的核心是：测试不是外部工具补丁，而是语言和 Cargo 工作流的一部分。

