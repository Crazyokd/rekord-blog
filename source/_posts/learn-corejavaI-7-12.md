---
layout: post
title: 学习-Java核心技术卷I-7~12章
date: 2022/3/20
updated: 2022/3/20
cover: /assets/corejavaI.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- 学习笔记
- Java
---

## 7. 异常、断言和日志
### 7.1 处理错误
- 异常分类
- 声明检查型异常
- 如何抛出异常
- 创建异常类

### 7.2 捕获异常
- 捕获异常
- 捕获多个异常
- 再次抛出异常与异常链
- finally 子句
- try-with-Resources 语句
	```java
	try (Resource res = ...) {
		work with res
	}
	```
	try 块退出时，会自动调用 res.close() 
	**还可以指定多个资源**
	**`try-with-resource` 语句自身也可以有 catch 子句，甚至还可以有一个 finally 子句。这些子句会在关闭资源之后执行。**
	
- 分析堆栈轨迹元素

### 7.3 使用异常的技巧
1. 异常处理不能代替简单的测试
2. 不要过分的细化异常
3. 充分利用异常层次结构
4. 不要压制异常
5. 在检测错误时，“苛刻”要比放任更好
6. 不要羞于传递异常

### 7.4 使用断言
- 断言的概念
	断言机制允许在测试期间向代码中插入一些检查，而在生产代码中会自动删除这些检查。
	```java
	assert condition;
	assert condition : expression;
	```
	上述这两个语句都会计算条件，如果结果为 false，则抛出一个 AssertionError 异常。在第二个语句中，表达式将传入 AssertionError 对象的构造器，并转换成一个消息字符串。
	
- 启用和禁用断言
	* 可以在运行程序时用 -enableassertions 或 -ea 选项启用断言。
	* 可以在某个类或整个包中启用断言
		```shell
		java -ea:MyClass -ea:com.mycompany.mylib MyApp
		```
	* 可以用选项 -disableassertions 或 -da 在某个特定类和包中禁用断言。有些类不是由类加载器加载，而是直接由虚拟机加载的。可以使用这些开关有选择的启用或禁用那些类中的断言。
	* 不必重新编译程序来启用或禁用断言。启用或禁用断言是 类加载器 的功能。
	
- 使用断言完成参数检查
	when?
	* 断言失败是致命的、不可恢复的错误
	* 断言检查只是在开发和测试阶段打开
	
- 使用断言提供假设文档
	
### 7.5 日志
- 日志 API 优点
	* 可以很容易的取消全部日志记录，或者仅仅取消某个级别以下的日志，而且可以很容易的再次打开日志开关
	* 可以很简单的禁止日志记录，因此，将这些日志代码留在程序中的开销很小
	* 日志记录可以被定向到不同的处理器，如在控制台显示、写至文件，等等
	* 日志记录器和处理器都可以对记录进行过滤。过滤器可以根据过滤器实现器指定的标准丢弃那些无用的记录项
	* 日志记录可以采用不同的方式格式化
	* 应用程序可以使用多个日志记录器，他们使用与包名类似的有层次结构的名字
	* 日志系统的配置由配置文件控制
	
- 基本日志
	```java
	// 使用全局日志记录器
	Logger.getGlobal().info("File->Open menu item selected");
	// 取消所有日志
	Logger.getGlobal().setLevel(Level.OFF);
	```
- 高级日志
	```java
	// 创建或获取日志记录器
	private static final Logger myLogger = Logger.getLogger("com.mycompany.myapp");
	```
	7个日志级别
	* SEVERE
	* WARNING
	* INFO
	* CONFIG
	* FINE
	* FINER
	* FINEST
- 修改日志管理器配置
	`conf/logging.properties`
- 本地化
- 处理器
	在默认情况下，日志记录器将记录发送到 ConsoleHandler，并由它输出到 System.err 流
- 过滤器
	在默认情况下，会根据日志记录的级别进行过滤。每个日志记录器和处理器都有一个可选的过滤器来完成附加的过滤。
- 格式化器
	ConsoleHandler 类和 FileHandler 类可以生成文本和 XML 格式的日志记录。也可以扩展 Formatter 自定义格式化器。
- 日志技巧
	* 对一个简单的应用，选择一个日志记录器。可以把日志记录器命名为与主应用包一样的名字。
	* 默认的日志配置会把级别等于或高于 INFO 的所有消息记录到控制台。用户可以覆盖这个默认配置。
	* 将程序员想要的日志消息设定为 FINE 级别是一个很好的选择。

### 7.6 调试技巧
1. 可以用下面的方法记录任意变量的值
	```java
	Logger.getGlobal().info("x=" + x);
	```
 		
2. 可以在每一个类中放置一个单独的 main 方法。这样就可以提供一个单元测试桩，能够独立地测试类。
3. 尝试使用JUnit
4. 日志代理（logging proxy）是一个子类的对象，他可以截获方法调用，记录日志，然后调用超类中的方法。
5.  利用 Throwable 类的printStackTrace 方法，可以从任意的异常对象获得堆栈轨迹。
6. 一般来说，堆栈轨迹显示在 System.err 上。如果想要记录或显示堆栈轨迹，可以如下将它捕获到一个字符串中：
	```java
	var out = new StringWriter();
	new Throwable().printStackTrace(new PrintWriter(out));
	String description = out.toString();
	```
7. 通常，将程序错误记入一个文件会很有用
8. 要想观察类的加载过程，启动 Java 虚拟机时可以使用 -verbose 标志。
9. -Xlint 选项告诉编译器找出常见的代码问题。
10. Java 虚拟机增加了对 Java 应用程序的监控和管理支持，允许在虚拟机中安装代理来跟踪内存消耗、线程使用、类加载等情况。【 jconsole】
11. Java 任务控制器是一个专业级性能分析和诊断工具，包含在 Oracle JDK 中，可以免费用于开发。

## 8. 泛型程序设计
### 8.1 为什么要使用泛型程序设计
- 类型参数的好处
- 谁想成为泛型程序员

### 8.2 定义简单泛型类
1. 泛型类就是有一个或多个类型变量的类。
2. 常见的做法是类型变量使用大写字母，而且很简短。Java 库使用变量 E 表示集合的元素类型，K 和 V 分别表示表的键和值的类型。T（必要时还可以用相邻的字母 U 和 S）表示“任意类型”。

### 8.3 泛型方法
1. 类型变量放在修饰符的后面，并在返回类型的前面
2. 泛型方法可以在普通类中定义，也可以在泛型类中定义。
3. 当调用一个泛型方法时，可以把具体类型包围在尖括号中，放在方法名前面
	```java
	String middle = ArrayAlg.<String>getMiddle("John", "Q.", "Public");
	```
4. 如果编译器有足够的信息推断出你想要的方法。可以省略尖括号

### 8.4 类型变量的限定
```java
<T extends BoundingType>
// 如果有一个类作为限定，它必须是限定列表中的第一个限定。
<T extends Comparable & Serializable>
```
### 8.5 泛型代码和虚拟机
虚拟机没有泛型类型对象——所有对象都属于普通类
- 类型擦除
	无论何时定义一个泛型类型，都会自动提供一个相应的原始类型。这个原始类型的名字就是去掉类型参数后的泛型类型名。类型变量会被擦除，并替换为其第一个限定类型（或者，对于无限定的变量则替换为 Object）。
	
- 转换泛型表达式
	自动强制类型转换
- 转换泛型方法
	类型转换也会出现在泛型方法中。
	**请记住以下几点：**
	* 虚拟机中没有泛型，只有普通的类和方法
	* 所有的类型参数都会替换为它们的限定类型
	* 会合成桥方法来保持多态
	* 为保持类型安全性，必要时会插入强制类型转换
- 调用遗留代码

### 8.6 限制与局限性
1. 不能用基本类型实例化类型参数
2. 运行时类型查询只适用于原始类型
3. 不能创建参数化类型的数组，但仍可以合法声明
4. Varargs 警告
5. 不能实例化类型变量
6. 不能构造泛型数组
7. 泛型类的静态上下文中类型变量无效
8. 不能抛出或捕获泛型类的实例
9. 可以取消对检查型异常的检查
10. 注意擦除后的冲突 

### 8.7 泛型类型的继承规则
总是可以将参数化类型转换为一个原始类型
### 8.8 通配符类型
- 通配符概念
- 通配符的超类型限定
	```java
	<? super Type>
	```

	**带有超类型限定的通配符允许你写入一个泛型对象，而带有子类型限定的通配符允许你读取一个泛型对象**
- 无限定通配符
	```java
	<?>
	```

- 通配符捕获

### 8.9 反射和泛型
- 泛型 Class 类
- 使用 Class<T> 参数进行类型匹配
- 虚拟机中的泛型类型信息
	擦除的类仍然保留原先泛型的微弱记忆。
- 类型字面量

## 9. 集合
### 9.1 Java 集合框架
- 集合接口与实现分离
- Collection 接口
	```java
	public interface Collection<E> {
		boolean add(E element);
		Iterator<E> iterator();

		// 泛型实用方法
		int size();
		boolean isEmpty();
		boolean contains(Object obj);
		boolean containsAll(Collection<?> c);
		boolean equals(Object other);
		boolean addAll(Collection<? extends E> from);
		boolean remove(Object obj);
		boolean removeAll(Collection<?> c);
		void clear();
		boolean retailAll(Collection<?> c);
		Object[] toArray();
		<T> T[] toArray(T[] arrayToFill);
	}
	```
- 迭代器
	```java
	public interface Iterator<E> {
		E next();
		boolean hasNext();
		void remove();
		default void forEachRemaining(Consumer<? super E> action);
	}
	```
	可以认为 Java 迭代器位于两个元素之间。当调用 next 时，迭代器就越过下一个元素，并返回刚刚越过的那个元素的引用


### 9.2 集合框架中的接口
集合有两个基本接口：Collection 和 Map

### 9.3 具体集合
- 链表
	1. **在 Java 程序设计语言中，所有链表实际上都是双向链接的**
	2. 链表是一个有序集合，每个对象的位置十分重要
	
- 数组列表
	Vector 类的所有方法都是同步的。
- 散列集
	集是没有重复元素的元素集合
	无序不重复
- 树集
	有序不重复（红黑树）
- 队列与双端队列
	队列允许你高效的在尾部添加元素，并在头部删除元素。双端队列允许在头部和尾部都高效的添加或删除元素。不支持在队列中间添加元素
- 优先队列
优先队列中的元素可以按照任意的顺序插入，但会按照有序的顺序进行检索【堆】

### 9.4 映射
- 基本映射操作
	* put
	* get
	* forEach
- 更新映射条目
- 映射视图
	* keySet()
	* values()
	* entrySet()
- WeakHashMap
- LinkedHashSet 和 LinkedHashMap
- EnumSet、EnumMap
- IdentityHashMap

### 9.5 视图与包装器
- 小集合
	```java
	List<String> names = List.of("Peter", "Paul", "Mary");
	Set<Integer> numbers = Set.of(2, 3, 5);
	// 这些集合对象是不可修改的
	```
- 子范围
- 不可修改的视图
- 同步视图
- 检查型视图
- 关于可选操作的说明

### 9.6 算法
- 为什么使用泛型算法
- 排序与混排
- 简单算法
- 批操作
- 集合与数组的转换
- 编写自己的算法

### 9.7 遗留的集合
- Hashtable 类
	同步
- Enumeration
- Properties
- Stack
- BitSet


## 10. GUI 程序设计

## 11. Swing 用户界面组件

## 12. 并发
### 12.1 什么是线程

### 12.2 线程状态
1. New
2. Runnable
3. Blocked
4. Waiting
5. Timed waiting
6. Terminated
> 要确定一个线程的当前状态，只需要调用 getState 方法。

- 新建线程
	当用 new 操作符创建一个新线程时，这个线程还没有开始运行。这意味着它的状态是新建。
	
- 可运行线程
	一旦调用 start 方法，线程就处于可运行状态。一个可运行的线程可能正在运行也可能没有运行。要由操作系统为线程提供具体的运行时间。【Java 规范没有将正在运行作为一个单独的状态。一个正在运行的线程仍然处于可运行状态。】
	
- 阻塞和等待线程
	当线程处于阻塞或等待状态时，它暂时是不活动的。它不运行任何代码，而且消耗最少的资源。要由线程调度器重新激活这个线程。具体细节取决于它是怎样到达非活动状态的。
	
- 终止线程
	* run 方法正常退出，线程自然终止
	* 因为一个没有捕获的异常终止了 run 方法，使线程意外终止
	
### 12.3 线程属性
- 中断线程
	除了已经废弃的 stop 方法，没有办法可以强制线程终止。不过， interrupt 方法可以用来*请求* 终止一个线程。
	
- 守护线程
	`t.setDaemon(true);`	这一方法必须在线程启动之前调用
	当只剩下守护线程时，虚拟机就会退出。

- 线程名
	`t.setName("name");`
	
- 未捕获异常的处理器
	
- 线程优先级
	默认情况下，一个线程会继承构造它的那个线程的优先级。
	可以用 setPriority 方法提高或降低任何一个线程的优先级。

### 12.4 同步
- 竞态条件的一个例子
- 竞态条件详解

- 锁对象
	* 锁用来保护代码片段，一次只能有一个线程执行被保护的代码。
	* 锁可以管理试图进入被保护代码段的线程
	* 一个锁可以有一个或多个相关联的条件对象
	
- 条件对象
	* 每个条件对象管理哪些已经进入被保护代码段但还不能运行的线程。

- synchronized 关键字
- 同步块
- 监视器概念
	* 只包含私有字段的类
	* 监视器类的每个对象有一个关联的锁
	* 所有方法由这个锁锁定
	* 锁可以有任意多个相关联的条件
	
- volatile 字段
	volatile 关键字为实例字段的同步访问提供了一种免锁机制。如果声明一个字段为 volatile，那么编译器和虚拟机就知道该字段可能被另一个线程并发更新。
	
- final 变量
	
- 原子性
	
- 死锁
- ThreadLocal
	使用ThreadLocal 辅助类为各个线程提供各自的实例。

- 为什么废弃 stop 和 suspend 方法？
	试图控制一个给定线程的行为，而没有线程的互操作。

### 12.5 线程安全的集合
- BlockingQueue
- 高效的映射、集和队列
	* ConcurrentHashMap
	* ConcurrentSkipListMap
	* ConcurrentSkipListSet
	* ConcurrentLinkedQueue
	
- 映射条目的原子更新
- 对并发散列映射的批操作
- 并发集视图
- 写数组的拷贝
- 并行数组算法
- 较早的线程安全集合

### 12.6 任务和线程池
- Collable 与 Future
- 执行器
	执行器类有许多静态工厂方法，用来构造线程池
	**总结：**
	1. 调用 Executors 类的静态方法 newCachedThreadPool 或 newFixedThreadPool
	2. 调用 submit 提交 Runnable 或 Callable 对象。
	3. 保存好返回的 Future 对象，以便得到结果或者取消任务
	4. 当不想再提交任何任务时，调用 shutdown
	
- 控制任务组
	
- fork-join 框架

### 12.7 异步计算
- 可完成 Future
- 组合可完成 Future
- 用户界面回调中的长时间运行任务

### 12.8 进程
- 建立一个进程
	```java
	// 首先指定你想要执行的命令
	var builder = new ProcessBuilder("gcc", "myapp.c");
	// 配置工作目录
	builder = builder.directory(path.toFile());
	// 配置流
	builder.redirectIO();
	```
- 运行一个进程
	```java
	Process process = new ProcessBuilder("/bin/ls", "-l")
		.directory(Path.of("/tmp").toFile()).start();
	try (var in = new Scanner(process.getInputStream())) {
		while (in.hasNextLine()) 
			System.out.println(in.nextLine());
	}
	```
- 进程句柄
	要获得程序启动的一个进程的更多信息，或者想更多地了解你的计算机上正在运行的任何其他进程，可以使用 ProcessHandle 接口。
	可以用4种方式得到一个 ProcessHandle：
	1. 给定一个 Process 对象 p，p.toHandle() 会生成它的 ProcessHandle。
	2. 给定一个 long 类型的操作系统进程 ID，processHandle.of(id) 可以生成这个进程的句柄。
	3. Process.current() 是运行这个 Java 虚拟机的进程的句柄
	4. ProcessHandle.allProcesses() 可以生成对当前进程可见的所有操作系统进程的 `Stream<ProcessHandle>`

	给定一个进程句柄，可以得到它的进程 ID、父进程、子进程和后代进程：
	```java
	long pid = handle.pid();
	Optional<ProcessHandle> parent = handle.parent();
	Stream<ProcessHandle> children = handle.children();
	Stream<ProcessHandle> descendants = handle.descendants();
	```
