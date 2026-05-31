---
title: Rust 核心概念（七）：闭包与迭代器
date: 2026/06/05
updated: 2026/06/05
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

闭包和迭代器看起来像语法糖，但它们背后依然是所有权、借用和 trait。

# 闭包是什么

闭包是一段可以保存到变量里、传给函数、从函数返回的匿名函数。

```rust
fn main() {
    let add_one = |x| x + 1;

    println!("{}", add_one(1));
}
```

`|x| x + 1` 就是闭包。

闭包可以捕获外部变量。

```rust
fn main() {
    let base = 10;
    let add_base = |x| x + base;

    println!("{}", add_base(5));
}
```

这里闭包使用了外部变量 `base`。

# 捕获变量

闭包捕获变量有三种方式：

- 不可变借用
- 可变借用
- 获取所有权

例如，只读外部变量：

```rust
fn main() {
    let name = String::from("rekord");

    let print = || {
        println!("{}", name);
    };

    print();
    println!("{}", name);
}
```

这里只需要不可变借用。

如果要修改外部变量：

```rust
fn main() {
    let mut count = 0;

    let mut inc = || {
        count += 1;
    };

    inc();
    println!("{}", count);
}
```

这里闭包需要可变借用 `count`。

# move 闭包

如果希望闭包拿走外部变量所有权，可以使用 `move`。

```rust
fn main() {
    let name = String::from("rekord");

    let print = move || {
        println!("{}", name);
    };

    print();
    // println!("{}", name); // 错误：name 已经被移动
}
```

`move` 常见于线程和异步场景，因为闭包可能比当前作用域活得更久。

# fn 和函数指针

Rust 里的普通函数用 `fn` 定义。

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}
```

普通函数不能捕获外部变量。

如果要把函数作为值传递，可以使用函数指针类型：

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}

fn apply(f: fn(i32) -> i32, value: i32) -> i32 {
    f(value)
}

fn main() {
    println!("{}", apply(add_one, 1));
}
```

这里的 `fn(i32) -> i32` 是函数指针类型。

普通函数可以传给需要闭包 trait 的地方，因为函数不会捕获环境。

# Fn、FnMut、FnOnce

闭包会根据捕获方式自动实现不同 trait。

- `Fn`：只读使用捕获值，可以调用多次。
- `FnMut`：会修改捕获值，可以调用多次，但调用时需要可变闭包。
- `FnOnce`：会消耗捕获值，只能调用一次。

这三个 trait 的区别，本质上是调用闭包时怎么使用捕获的环境。

## Fn

如果闭包只读取捕获值，它通常实现 `Fn`。

```rust
fn call_twice<F>(f: F)
where
    F: Fn(),
{
    f();
    f();
}

fn main() {
    let name = String::from("rekord");

    let print = || {
        println!("{}", name);
    };

    call_twice(print);
}
```

`print` 只是不可变借用 `name`，所以可以调用多次。

## FnMut

如果闭包会修改捕获值，它通常实现 `FnMut`。

```rust
fn call_twice<F>(mut f: F)
where
    F: FnMut(),
{
    f();
    f();
}

fn main() {
    let mut count = 0;

    let inc = || {
        count += 1;
    };

    call_twice(inc);
}
```

这里闭包需要可变借用 `count`。

所以调用闭包的函数也要把 `f` 声明成 `mut`。

## FnOnce

如果闭包会消耗捕获值，它只能实现 `FnOnce`。

```rust
fn call_once<F>(f: F)
where
    F: FnOnce(),
{
    f();
}

fn main() {
    let name = String::from("rekord");

    let consume = || {
        drop(name);
    };

    call_once(consume);
}
```

`drop(name)` 会拿走 `name` 的所有权。

所以这个闭包只能调用一次。

三者还有包含关系：

- 能实现 `Fn` 的闭包，也能当作 `FnMut` 和 `FnOnce` 使用。
- 能实现 `FnMut` 的闭包，也能当作 `FnOnce` 使用。
- 只能实现 `FnOnce` 的闭包，不能当作 `Fn` 或 `FnMut` 使用。

# 闭包的 Copy 和 Clone

闭包本身也可能实现 `Copy` 或 `Clone`。

关键取决于它捕获了什么，以及如何捕获。

- 不捕获环境：通常 `Copy + Clone`。
- 只捕获 `Copy` 值：通常 `Copy + Clone`。
- 捕获 `Clone` 但非 `Copy` 的值：可能 `Clone`，通常不是 `Copy`。
- 调用时会消耗捕获值：通常只能 `FnOnce`，也不适合作为可复制闭包。

# 迭代器是什么

迭代器是一种按顺序产出值的对象。

Rust 的迭代器核心是 `Iterator` trait。

简化后可以理解为：

```rust
trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}
```

`next` 每次返回一个值：

- `Some(value)`：还有下一个值。
- `None`：迭代结束。

# iter、iter_mut、into_iter

集合常见三种迭代方式。

```rust
let nums = vec![1, 2, 3];

for n in nums.iter() {
    println!("{}", n);
}
```

`iter()` 产生不可变引用。

```rust
let mut nums = vec![1, 2, 3];

for n in nums.iter_mut() {
    *n += 1;
}
```

`iter_mut()` 产生可变引用。

```rust
let nums = vec![1, 2, 3];

for n in nums.into_iter() {
    println!("{}", n);
}
```

`into_iter()` 消耗集合，产出拥有所有权的值。

# map

`map` 用来把每个元素转换成另一个值。

```rust
let nums = vec![1, 2, 3];

let doubled: Vec<i32> = nums
    .iter()
    .map(|n| n * 2)
    .collect();

println!("{:?}", doubled);
```

`map` 接收一个闭包。

这里的 `|n| n * 2` 表示每个元素如何转换。

# filter

`filter` 用来保留满足条件的元素。

```rust
let nums = vec![1, 2, 3, 4];

let even: Vec<&i32> = nums
    .iter()
    .filter(|n| *n % 2 == 0)
    .collect();

println!("{:?}", even);
```

注意这里使用 `iter()`，所以收集到的是引用。

如果想拿到值，可以配合 `copied()`：

```rust
let even: Vec<i32> = nums
    .iter()
    .copied()
    .filter(|n| n % 2 == 0)
    .collect();
```

# fold

`fold` 用来把一组值折叠成一个结果。

```rust
let nums = vec![1, 2, 3, 4];

let sum = nums
    .iter()
    .fold(0, |acc, n| acc + n);

println!("{}", sum);
```

`0` 是初始值。

`acc` 是上一步累积结果。

# collect

迭代器通常是惰性的。

```rust
let nums = vec![1, 2, 3];

let iter = nums.iter().map(|n| n * 2);
```

这里只创建了一个迭代器，还没有真正收集结果。

需要 `collect` 才会变成集合：

```rust
let result: Vec<i32> = nums
    .iter()
    .map(|n| n * 2)
    .collect();
```

`collect` 需要知道目标集合类型，所以经常要写类型标注。

# for 循环也是迭代器

`for` 循环本质上也是基于迭代器。

```rust
for n in vec![1, 2, 3] {
    println!("{}", n);
}
```

可以理解为不断调用 `next()`，直到返回 `None`。

# 总结

- 闭包是可以捕获环境的匿名函数。
- 闭包捕获变量时仍然遵守所有权和借用规则。
- `move` 闭包会拿走捕获变量所有权。
- `Fn`、`FnMut`、`FnOnce` 描述闭包如何使用捕获值。
- 迭代器核心是 `Iterator` trait。
- `iter` 借用元素。
- `iter_mut` 可变借用元素。
- `into_iter` 消耗集合。
- `map` 转换元素。
- `filter` 过滤元素。
- `fold` 累积结果。
- `collect` 把迭代器收集成集合。

