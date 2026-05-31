---
title: Rust 核心概念（四）：结构体、枚举与模式匹配
date: 2026/06/02
updated: 2026/06/02
index_img: https://cdn.sxrekord.com/v2/rust.png
banner_img: https://cdn.sxrekord.com/v2/rust.png
categories:
- 技术
tags:
- Rust
- 学习笔记
---

这一篇开始讲 Rust 的类型表达能力。

核心问题是：

> 如何用类型表达数据和状态？

# struct

`struct` 用来组织一组相关数据。

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

    println!("{} {}", user.name, user.age);
}
```

`User` 表示一种数据结构，它有两个字段：

- `name`
- `age`

结构体本身不复杂，关键是：字段也遵守所有权规则。

# 字段所有权

结构体字段同样有所有权。

```rust
struct User {
    name: String,
}

fn main() {
    let user = User {
        name: String::from("rekord"),
    };

    let name = user.name;

    println!("{}", name);
    // println!("{}", user.name); // 错误：name 字段已经被移动
}
```

`user.name` 是一个 `String`，赋值给 `name` 时发生 move。

字段被移动后，不能再使用这个字段。

如果只是想读取字段，通常使用引用：

```rust
struct User {
    name: String,
}

fn main() {
    let user = User {
        name: String::from("rekord"),
    };

    let name = &user.name;

    println!("{}", name);
    println!("{}", user.name);
}
```

结构体不会绕过所有权，它只是把多个值组合在一起。

# 字段初始化简写

如果变量名和字段名相同，可以简写。

```rust
struct User {
    name: String,
    age: u8,
}

fn new_user(name: String, age: u8) -> User {
    User { name, age }
}
```

`User { name, age }` 等价于：

```rust
User {
    name: name,
    age: age,
}
```

# 结构体更新语法

可以基于已有结构体创建新结构体。

```rust
struct User {
    name: String,
    age: u8,
}

fn main() {
    let user1 = User {
        name: String::from("rekord"),
        age: 18,
    };

    let user2 = User {
        age: 20,
        ..user1
    };

    println!("{}", user2.name);
}
```

`..user1` 会把没有显式指定的字段从 `user1` 移动或复制到 `user2`。

这里 `name` 是 `String`，会 move；`age` 是 `u8`，会 copy。

所以结构体更新语法也要考虑所有权。

# tuple struct

tuple struct 有名字，但字段没有名字。

```rust
struct Point(i32, i32);

fn main() {
    let p = Point(1, 2);
    println!("{} {}", p.0, p.1);
}
```

它适合给 tuple 加一个明确类型名。

例如：

```rust
struct UserId(u64);
struct OrderId(u64);
```

虽然底层都是 `u64`，但 `UserId` 和 `OrderId` 是不同类型，可以避免误传。

# unit-like struct

单元型结构体没有字段。

```rust
struct AlwaysEqual;

fn main() {
    let value = AlwaysEqual;
}
```

它看起来像没有数据，但仍然是一个独立类型。

常见用途是只需要类型身份，不需要保存字段。

例如，用一个类型实现某个 trait：

```rust
trait Formatter {
    fn format(&self, text: &str) -> String;
}

struct PlainText;

impl Formatter for PlainText {
    fn format(&self, text: &str) -> String {
        text.to_string()
    }
}
```

`PlainText` 没有字段，但它可以作为一种策略类型存在。

# interior mutability

通常情况下，`&self` 方法只能读取，不能修改字段。

但有些类型提供内部可变性。

这意味着：外部只拿到不可变引用，内部某些字段仍然可以被修改。

例如 `Cell<T>`：

```rust
use std::cell::Cell;

struct Counter {
    value: Cell<u32>,
}

impl Counter {
    fn inc(&self) {
        self.value.set(self.value.get() + 1);
    }

    fn get(&self) -> u32 {
        self.value.get()
    }
}

fn main() {
    let counter = Counter {
        value: Cell::new(0),
    };

    counter.inc();
    println!("{}", counter.get());
}
```

`inc` 接收的是 `&self`，但它仍然修改了 `value`。

这不是绕过 Rust 规则，而是把“可变性规则”封装进了字段类型里。

常见内部可变性类型包括 `Cell<T>`、`RefCell<T>` 和 `Mutex<T>`。

它们都能让结构体在 `&self` 方法里修改内部状态，但安全机制不同。

## Cell

`Cell<T>` 的特点是：不把内部值的引用交给你。

它通常通过复制、替换整个值来完成修改。

```rust
use std::cell::Cell;

struct Counter {
    value: Cell<u32>,
}

impl Counter {
    fn inc(&self) {
        self.value.set(self.value.get() + 1);
    }
}
```

`Cell<T>` 可以保存任意 `T`，但 `get()` 只有在 `T: Copy` 时可用。

所以它最常用于数字、布尔值、枚举这类小的 `Copy` 值。

`mut Cell<T>` 只有在你要重新绑定整个变量，或者通过 `get_mut()` 拿内部值的可变引用时才需要。

它的关键限制是：

> 你不能从 `Cell<T>` 里拿到普通的 `&T` 或 `&mut T`。

这就是它能安全修改内部值的原因。

它是单线程内部可变性类型，不能用来让多个线程安全地共享修改同一个值。

## RefCell

`RefCell<T>` 适合单线程场景下的复杂值。

它允许在 `&self` 方法里临时拿到可变借用。

```rust
use std::cell::RefCell;

struct Log {
    items: RefCell<Vec<String>>,
}

impl Log {
    fn push(&self, item: String) {
        self.items.borrow_mut().push(item);
    }
}
```

`RefCell` 不是取消借用规则。

它只是把借用检查从编译期推迟到运行时。

```rust
use std::cell::RefCell;

fn main() {
    let items = RefCell::new(vec![1]);

    let a = items.borrow_mut();
    let b = items.borrow_mut(); // panic
}
```

这里第二次 `borrow_mut()` 会 panic。

原因还是同一条规则：

> 同一时间，要么多个不可变借用，要么一个可变借用。

只是这条规则由 `RefCell` 在运行时检查。

## Mutex

`Mutex<T>` 适合多线程场景。

它通过加锁保证同一时间只有一个线程能修改内部值。

```rust
use std::sync::Mutex;

struct SharedCounter {
    value: Mutex<u32>,
}

impl SharedCounter {
    fn inc(&self) {
        let mut value = self.value.lock().unwrap();
        *value += 1;
    }
}
```

`lock()` 返回一个 guard。

guard 存在期间，当前线程拥有修改权。

guard 离开作用域时，锁会自动释放。

如果持有锁的线程 panic，锁会进入 poisoned 状态，所以 `lock()` 返回 `Result`。

示例里的 `unwrap()` 表示：如果锁已经 poisoned，就直接 panic。

## 怎么选

可以先按这个思路判断：

- 小的 `Copy` 值：`Cell<T>`。
- 单线程复杂值：`RefCell<T>`。
- 多线程共享修改：`Mutex<T>`。

内部可变性不是默认选择。

它适合封装内部状态，而不是让外部随便绕过借用规则。

更准确地说：

> 内部可变性不是取消借用规则，而是把“什么时候允许修改”的判断封装进特定类型里。

# impl

`impl` 用来给类型定义方法。

```rust
struct User {
    name: String,
    age: u8,
}

impl User {
    fn is_adult(&self) -> bool {
        self.age >= 18
    }
}

fn main() {
    let user = User {
        name: String::from("rekord"),
        age: 18,
    };

    println!("{}", user.is_adult());
}
```

# associated function

不带 `self` 的函数叫关联函数。

最常见的是构造函数风格的 `new`。

```rust
struct User {
    name: String,
    age: u8,
}

impl User {
    fn new(name: String, age: u8) -> Self {
        Self { name, age }
    }
}

fn main() {
    let user = User::new(String::from("rekord"), 18);
    println!("{}", user.name);
}
```

`Self` 表示当前实现块对应的类型，这里就是 `User`。

# associated constant

`impl` 里也可以定义关联常量。

关联常量属于类型本身，不属于某个具体实例。

```rust
struct User {
    name: String,
    age: u8,
}

impl User {
    const MIN_AGE: u8 = 18;

    fn is_adult(&self) -> bool {
        self.age >= Self::MIN_AGE
    }
}

fn main() {
    println!("{}", User::MIN_AGE);
}
```

`User::MIN_AGE` 通过类型访问。

方法内部可以用 `Self::MIN_AGE` 访问，表示当前类型上的常量。

它和字段不同：

- 字段属于具体对象，每个对象都有自己的字段值。
- 关联常量属于类型，所有对象共享同一个常量定义。

它也比散落在外面的普通常量更有归属感。

如果一个常量只对某个类型有意义，就适合放到这个类型的 `impl` 里。

# const generic parameter

结构体也可以接收常量值作为参数。

这叫 const generic parameter。

最常见的例子是数组长度：

```rust
struct Buffer<const N: usize> {
    data: [u8; N],
}

fn main() {
    let small = Buffer::<8> { data: [0; 8] };
    let large = Buffer::<1024> { data: [0; 1024] };
}
```

这里的 `N` 不是普通字段，而是类型参数的一部分。

**所以 `Buffer<8>` 和 `Buffer<1024>` 是两个不同类型。**

这和字段不同：

```rust
struct Buffer {
    size: usize,
}
```

字段 `size` 是运行时数据。

`const N: usize` 是编译期常量参数。

> 如果某个数值会影响类型本身，就可以考虑 const generic parameter。

# enum

`enum` 用来表达一个值可能属于多种状态之一。

```rust
enum Direction {
    Up,
    Down,
    Left,
    Right,
}
```

`Direction` 的值只能是四种之一。

这比用字符串或数字表达状态更安全。

```rust
fn move_to(direction: Direction) {
    match direction {
        Direction::Up => println!("up"),
        Direction::Down => println!("down"),
        Direction::Left => println!("left"),
        Direction::Right => println!("right"),
    }
}
```

如果以后新增一个方向，`match` 没处理到，编译器会提醒。

# enum 携带数据

Rust 的 enum 不只是常量集合，每个分支都可以携带数据。

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

不同分支可以携带不同类型的数据。

```rust
fn handle(msg: Message) {
    match msg {
        Message::Quit => println!("quit"),
        Message::Move { x, y } => println!("move to {}, {}", x, y),
        Message::Write(text) => println!("{}", text),
        Message::ChangeColor(r, g, b) => println!("{} {} {}", r, g, b),
    }
}
```

这让 enum 非常适合表达状态和事件。

# Option

`Option<T>` 是 Rust 标准库里的 enum。

它表示一个值可能存在，也可能不存在。

```rust
enum Option<T> {
    Some(T),
    None,
}
```

例如：

```rust
fn find_user(id: u64) -> Option<String> {
    if id == 1 {
        Some(String::from("rekord"))
    } else {
        None
    }
}
```

使用时必须处理两种情况：

```rust
match find_user(1) {
    Some(name) => println!("{}", name),
    None => println!("not found"),
}
```

这就是 Rust 不需要 `null` 的原因之一。

可能没有值，就用类型明确表达出来。

# match

`match` 是模式匹配。

它不只是其他语言里的 `switch`。

```rust
let value = Some(3);

match value {
    Some(n) => println!("{}", n),
    None => println!("none"),
}
```

`Some(n)` 不只是判断分支，还把里面的值绑定到 `n`。

`match` 要求穷尽所有可能情况。

```rust
enum Status {
    Ready,
    Running,
    Done,
}

fn print_status(status: Status) {
    match status {
        Status::Ready => println!("ready"),
        Status::Running => println!("running"),
        // Status::Done 没处理会报错
    }
}
```

这种穷尽性检查非常重要。它让新增状态时，编译器能帮你找到没处理的地方。

# if let

如果只关心一种模式，可以用 `if let`。

```rust
let value = Some(3);

if let Some(n) = value {
    println!("{}", n);
}
```

它等价于只处理一个分支的 `match`：

```rust
match value {
    Some(n) => println!("{}", n),
    _ => (),
}
```

`match` 适合完整处理所有情况。

`if let` 适合只关心一种情况。

# pattern

模式匹配不只出现在 `match` 里。

`let` 也可以解构：

```rust
let point = (1, 2);
let (x, y) = point;

println!("{} {}", x, y);
```

函数参数也可以解构：

```rust
fn print_point((x, y): (i32, i32)) {
    println!("{} {}", x, y);
}
```

`if let`、`while let`、`for` 里也都有模式。

所以 pattern 是 Rust 里很基础的语法能力。

# 让非法状态无法表示

Rust 类型系统的一个重要思想是：

> 用类型表达状态，让错误状态尽量无法构造出来。

例如，一个订单可能有三种状态：

```rust
enum OrderStatus {
    Created,
    Paid,
    Shipped,
}
```

这比用字符串更安全：

```rust
let status = "paied"; // 拼错了也只是普通字符串
```

用 enum 后，状态只能是预定义的几种。

再比如，查询用户可能失败：

```rust
fn find_user(id: u64) -> Option<User> {
    // ...
}
```

调用者必须处理 `Some` 和 `None`。

这就是“把可能性写进类型里”。

# 总结

- `struct` 用来组织数据。
- 结构体字段同样遵守所有权规则。
- `impl` 用来给类型定义方法。
- `enum` 用来表达多种状态。
- enum 分支可以携带数据。
- `Option<T>` 用类型表达“可能没有值”。
- `match` 要求穷尽所有情况。
- `if let` 适合只关心一种分支。
- pattern 不只是 `match`，也存在于 `let`、函数参数、循环等位置。
