---
title: Rust 核心概念
date: 2026/05/29
updated: 2026/05/29
index_img: https://cdn.sxrekord.com/blog/code.jpg
banner_img: https://cdn.sxrekord.com/blog/code.jpg
categories:
- 技术
tags:
- Rust
- 学习笔记
---

Rust 的核心不在语法，而在它如何用类型系统、所有权和工具链把很多运行时问题提前到编译期。

这篇文章只做总览，不试图把每个概念一次讲完。后续会按主题逐篇展开。

# 官方资料分工

梳理 Rust 核心概念，应该先看官方资料各自负责什么。

## The Rust Programming Language

也就是常说的 Rust Book。

它覆盖的是学习 Rust 最核心的概念：

- 变量、可变性、基础类型
- 所有权
- 借用与引用
- 结构体
- 枚举和模式匹配
- 模块系统
- 集合
- 错误处理
- 泛型、trait、生命周期
- 测试
- 闭包和迭代器
- 智能指针
- 并发
- 面向对象风格讨论
- 模式
- unsafe
- 高级 trait、类型、函数、闭包、宏

## Rust Reference

Rust Reference 更像语言规范。

它适合用来查准确定义，而不是从零学习。比如：

- 类型系统
- 表达式
- item
- pattern
- trait
- lifetime
- memory model
- unsafe

写概念文章时，Reference 适合用来校准术语和边界。

## Rust By Example

Rust By Example 适合补代码例子。

如果某个概念在 Rust Book 里解释得比较抽象，可以用 Rust By Example 的例子让读者更快看到实际写法。

## Cargo Book

Cargo Book 负责项目和构建系统。

它覆盖：

- package
- crate
- dependency
- feature
- workspace
- build script
- publish

这些不是语言语义本身，但是真实写 Rust 项目绕不开。

## Async Book

Async Book 负责异步 Rust。

它覆盖：

- `Future`
- `async`
- `await`
- executor
- runtime
- pin
- async ecosystem

异步不是 Rust 入门第一步，但现代 Rust 服务端开发基本绕不开。

## Rustonomicon

Rustonomicon 负责 unsafe Rust。

它讨论的是编译器无法完全保证安全的边界，例如：

- raw pointer
- aliasing
- ownership model 的底层细节
- unsafe abstraction
- FFI

新手不应该一开始读它，但后面理解 unsafe 时绕不开。


# 总结

Rust 的主线可以压缩成一句话：

> 所有权决定资源归属，借用和生命周期保证引用安全，类型系统和 trait 负责表达抽象，Cargo 和模块系统负责工程组织。

