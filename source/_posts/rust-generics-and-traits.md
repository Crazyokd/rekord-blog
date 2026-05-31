---
title: Rust 核心概念（六）：泛型、trait 与 trait bound
date: 2026/06/04
updated: 2026/06/04
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

这一篇讲 Rust 的抽象能力，核心问题是：

> 如何写一份代码，适配多种类型？

Rust 的答案主要是泛型和 trait。

# 泛型

泛型让函数或类型不绑定到某一个具体类型。

例如，下面这个函数只能接收 `i32`：

```rust
fn first_i32(list: &[i32]) -> &i32 {
    &list[0]
}
```

如果想让它适配更多类型，可以使用泛型：

```rust
fn first<T>(list: &[T]) -> &T {
    &list[0]
}
```

`T` 是类型参数。

调用时，编译器会根据参数推导出具体类型。

```rust
let nums = vec![1, 2, 3];
let names = vec!["a", "b", "c"];

println!("{}", first(&nums));
println!("{}", first(&names));
```

泛型解决的是重复代码问题。

# 泛型结构体

结构体也可以使用泛型。

```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let p1 = Point { x: 1, y: 2 };
    let p2 = Point { x: 1.0, y: 2.0 };
}
```

这里 `Point<i32>` 和 `Point<f64>` 是不同的具体类型。

如果两个字段允许不同类型，可以写两个类型参数：

```rust
struct Pair<T, U> {
    left: T,
    right: U,
}
```

# 泛型枚举

前面讲过的 `Option` 和 `Result` 都是泛型 enum。

```rust
enum Option<T> {
    Some(T),
    None,
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

# trait

泛型只解决“适配多种类型”，但还没解决一个问题：

> 这些类型必须具备什么能力？

这就需要 trait。

trait 可以理解为一组行为约定。

```rust
trait Summary {
    fn summarize(&self) -> String;
}
```

任何类型只要实现了这个 trait，就表示它支持 `summarize` 行为。

```rust
struct Article {
    title: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        self.title.clone()
    }
}
```

调用时：

```rust
let article = Article {
    title: String::from("Rust"),
};

println!("{}", article.summarize());
```

trait 是 Rust 抽象的核心。

# 默认实现

trait 可以提供默认实现。

```rust
trait Summary {
    fn summarize(&self) -> String {
        String::from("read more")
    }
}

struct Article;

impl Summary for Article {}
```

# supertrait 和 subtrait

trait 之间也可以有依赖关系。

```rust
trait Summary {
    fn summarize(&self) -> String;
}

trait DisplaySummary: Summary {
    fn display(&self) {
        println!("{}", self.summarize());
    }
}
```

`DisplaySummary: Summary` 表示：

> 想实现 `DisplaySummary`，必须也实现 `Summary`。

这里 `Summary` 是 supertrait。

`DisplaySummary` 是 subtrait。

注意，这不是继承字段或实现。

它只是表达能力依赖：

> 具备后一个能力之前，必须先具备前一个能力。

# trait bound

泛型函数经常需要限制类型必须实现某个 trait。

```rust
fn notify<T: Summary>(item: &T) {
    println!("{}", item.summarize());
}
```

`T: Summary` 就是 trait bound。

它表示：

> T 可以是任意类型，但必须实现 Summary。

也可以写成 `impl Trait`：

```rust
fn notify(item: &impl Summary) {
    println!("{}", item.summarize());
}
```

# 多个 trait bound

一个类型可以被要求同时实现多个 trait。

```rust
use std::fmt::Debug;

fn print<T: Summary + Debug>(item: &T) {
    println!("{:?}", item);
    println!("{}", item.summarize());
}
```

如果 bound 很长，可以用 `where`：

```rust
use std::fmt::Debug;

fn print<T>(item: &T)
where
    T: Summary + Debug,
{
    println!("{:?}", item);
    println!("{}", item.summarize());
}
```

# trait bound 和生命周期

泛型约束里也经常同时出现 trait bound 和生命周期。

例如，函数返回一个引用，同时要求泛型类型能被打印：

```rust
use std::fmt::Debug;

fn choose<'a, T>(x: &'a T, y: &'a T) -> &'a T
where
    T: Debug,
{
    println!("{:?}", x);
    x
}
```

这里有两类约束：

- `'a`：说明返回引用和参数引用之间的生命周期关系。
- `T: Debug`：说明 `T` 必须能用 `{:?}` 打印。

也可以约束引用本身的生命周期。

```rust
use std::fmt::Debug;

fn print_ref<'a, T>(value: &'a T)
where
    T: Debug + 'a,
{
    println!("{:?}", value);
}
```

`T: 'a` 表示：

> T 中如果包含引用，这些引用必须至少和 `'a` 一样久。

# associated type

trait 可以定义关联类型。

```rust
trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}
```

`Item` 是实现这个 trait 时要指定的类型。

真实的迭代器就是这样表达“每次产出什么类型”。

# generic trait

trait 本身也可以带泛型参数。

```rust
trait Serializer<T> {
    fn serialize(&self, value: &T) -> String;
}
```

这里的 `T` 表示：

> 这个 serializer 可以序列化哪种类型。

同一个类型可以为不同 `T` 实现同一个泛型 trait。

```rust
struct Json;

struct User {
    name: String,
}

struct Order {
    id: u64,
}

impl Serializer<User> for Json {
    fn serialize(&self, value: &User) -> String {
        value.name.clone()
    }
}

impl Serializer<Order> for Json {
    fn serialize(&self, value: &Order) -> String {
        value.id.to_string()
    }
}
```

这里 `Json` 分别实现了：

- `Serializer<User>`
- `Serializer<Order>`

它们是两个不同的 trait。

所以泛型 trait 适合表达：

> 同一种能力，可以针对不同输入类型分别实现。

- 一个实现者可能为多个类型分别实现：优先考虑泛型 trait。
- 一个实现者天然只有一个相关类型：优先考虑 associated type。

# 常用工具 trait

Rust 标准库里有很多非常重要的工具 trait。

它们不一定复杂，但会频繁出现在真实代码里。

## Drop

`Drop` 用来定义值离开作用域时的清理逻辑。

```rust
struct Resource;

impl Drop for Resource {
    fn drop(&mut self) {
        println!("cleanup");
    }
}
```

常见用途包括释放文件、连接、锁、临时资源。

一般不需要手动调用 `drop` 方法。如果要提前释放值，使用标准库函数：

```rust
drop(value);
```

## Sized

`Sized` 表示类型在编译期大小已知。

大多数普通类型都是 `Sized`。

泛型参数默认带有 `Sized` 约束：

```rust
fn print<T>(value: T) {}
```

可以理解成：

```rust
fn print<T: Sized>(value: T) {}
```

如果想接收动态大小类型，需要显式放宽：

```rust
fn print<T: ?Sized>(value: &T) {}
```

`?Sized` 表示：

> T 可以是 Sized，也可以不是 Sized。

常见非 `Sized` 类型包括 `str`、`[T]` 和 `dyn Trait`。


## From 和 Into

`From` 和 `Into` 用来表达类型转换。

实现 `From`：

```rust
struct UserId(u64);

impl From<u64> for UserId {
    fn from(value: u64) -> Self {
        UserId(value)
    }
}
```

使用：

```rust
let id = UserId::from(1);
```

只要实现了 `From<A> for B`，标准库会自动提供 `Into<B> for A`。

所以也可以写：

```rust
let id: UserId = 1u64.into();
```

- 实现转换时，优先实现 `From`。
- 调用函数时，参数可以用 `Into` 让调用方更灵活。

例如：

```rust
fn create_user(id: impl Into<UserId>) {
    let id = id.into();
}
```

这样调用方既可以传 `u64`，也可以传 `UserId`。

## Default

`Default` 表示类型有默认值。

```rust
#[derive(Default)]
struct Config {
    debug: bool,
    port: u16,
}
```

常见用途是配置结构体、测试数据、`std::mem::take`。

```rust
let mut name = String::from("rekord");
let old = std::mem::take(&mut name);
```

`take` 能工作，是因为 `String` 实现了 `Default`，可以用空字符串填回去。

## AsRef 和 AsMut

`AsRef<T>` 用来把一个值临时借成 `&T`。

它不拿走所有权，也不创建新的拥有值。

例如，一个函数只需要读取字符串内容：

```rust
fn print_text(text: impl AsRef<str>) {
    let text: &str = text.as_ref();
    println!("{}", text);
}
```

调用方可以传不同形式的字符串：

```rust
print_text("hello");
print_text(String::from("hello"));
```

函数内部统一拿到的是 `&str`。

这就是 `AsRef` 的核心价值：

> API 只需要一种引用视图，但调用方可以传多种输入类型。

路径参数也经常这样写：

```rust
fn print_path(path: impl AsRef<std::path::Path>) {
    let path: &std::path::Path = path.as_ref();
    println!("{:?}", path);
}
```

这样函数可以接收 `&Path`、`PathBuf`、`&str` 等能被借成 `Path` 的类型。

`AsMut` 类似，但返回可变引用。

# 静态分发

泛型默认使用静态分发。

可以理解为：编译器在编译期为具体类型生成对应代码。

```rust
fn first<T>(list: &[T]) -> &T {
    &list[0]
}
```

当你分别用 `i32` 和 `String` 调用它时，编译器会生成适配具体类型的代码。

优点是性能好。

代价是编译产物可能变大。

# trait object

有时你希望在运行时处理不同类型，但它们都实现了同一个 trait。

这时可以使用 trait object。

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

fn render(item: &dyn Draw) {
    item.draw();
}
```

`dyn Draw` 表示动态分发。

调用哪个实现，要到运行时决定。

这通常意味着一次间接调用，性能上比静态分发多一点成本。

但它换来的是运行时多态：不同具体类型可以通过同一个 `dyn Trait` 接口处理。

简单区别：

- 泛型：编译期确定具体类型。
- `dyn Trait`：运行时通过 trait object 调用。

不是所有 trait 都能直接做 trait object。

原因在于 trait object 背后依赖一张虚表。

可以粗略理解成：

```text
&dyn Draw = 数据指针 + 方法表指针
```

数据指针指向真实对象。

方法表指针指向这个类型对 trait 方法的具体实现。

所以 trait object 有一个前提：

> 调用方法时，只靠这张固定的方法表就能完成调用。

如果方法返回 `Self`，这个前提就会出问题。

看一个更具体的例子：

```rust
trait Duplicate {
    fn duplicate(&self) -> Self;
}

struct Button;
struct Input;

impl Duplicate for Button {
    fn duplicate(&self) -> Self {
        Button
    }
}

impl Duplicate for Input {
    fn duplicate(&self) -> Self {
        Input
    }
}
```

对 `Button` 来说，`Self` 是 `Button`。

对 `Input` 来说，`Self` 是 `Input`。

但如果把它们都当成 `dyn Duplicate`：

```rust
fn duplicate(value: &dyn Duplicate) {
    let copied = value.duplicate();
}
```

问题是：

> `copied` 的具体类型到底是什么？

它可能是 `Button`，也可能是 `Input`。

但 `dyn Duplicate` 已经抹掉了具体类型，调用方无法得到一个确定类型、确定大小的返回值。

所以返回裸 `Self` 的方法不能直接通过 trait object 调用。

如果方法有自己的泛型参数，也会出问题：

```rust
trait Parser {
    fn parse<T>(&self, input: &str) -> T;
}
```

泛型方法需要针对不同 `T` 生成不同版本。

但 trait object 的方法表需要是固定的，不能为未知数量的 `T` 准备无限多个入口。

所以这种 trait 也不能直接做 trait object。

常见处理方式是把不能用于 trait object 的方法限制为 `Self: Sized`：

```rust
trait Duplicate {
    fn duplicate(&self) -> Self
    where
        Self: Sized;
}
```

这样 `duplicate` 只能在具体类型上调用，不能通过 `dyn Duplicate` 调用。

如果确实想通过 trait object 返回一个新对象，通常要把返回值也装进指针里，例如返回 `Box<dyn Trait>`。

> trait object 需要固定方法表；如果方法签名依赖具体 `Self` 或带泛型方法，就可能不满足对象安全要求。

# orphan rule

Rust 有一条重要规则：不能随便给任意外部类型实现任意外部 trait。

至少 trait 或类型有一个必须定义在当前 crate 中。

例如：

```rust
// 如果 Display 和 Vec 都来自标准库，这种实现不允许
// impl std::fmt::Display for Vec<i32> {}
```

这条规则避免不同 crate 对同一类型和同一 trait 给出冲突实现。

# 总结

- 泛型让代码适配多种类型。
- trait 定义类型必须具备的行为。
- supertrait / subtrait 表达 trait 之间的能力依赖。
- trait bound 限制泛型类型必须实现某些 trait。
- `impl Trait` 适合简单参数和返回值。
- `where` 适合复杂约束。
- trait bound 和生命周期约束可以同时出现在 `where` 里。
- generic trait 表示 trait 本身接收类型参数。
- associated type 用来表达 trait 关联的类型。
- `Drop`、`Sized`、`From`、`Into`、`AsRef`、`Default` 是常用工具 trait。
- 泛型通常是静态分发。
- `dyn Trait` 是动态分发。
- trait object 有对象安全限制。
- orphan rule 避免 trait 实现冲突。

Rust 的抽象不是继承优先，而是：

> 用 trait 描述能力，用泛型复用代码。
