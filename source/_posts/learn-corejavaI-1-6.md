---
layout: post
title: 学习-Java核心技术卷I-1~6章
date: 2022/3/15
updated: 2022/3/15
cover: /assets/corejavaI.jpg
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- 学习笔记
- Java
---
## 1. Java程序设计概述
### 1.1 Java程序设计平台
Java是一个完整的平台，有一个庞大的库，其中包含了很多可重用的代码，以及一个提供诸如安全性、跨操作系统的可移植性以及自动垃圾收集等服务的执行环境。
### 1.2 Java“白皮书”的关键术语
- 简单性
- 面向对象
- 分布式
- 健壮性
- 安全性
- 体系结构中立
- 可移植性
- 解释型
- 高性能
- 多线程
- 动态性

### 1.3 Java applet 与 Internet
### 1.4 Java发展简史
- Sun公司开发
- 原本叫Oak，后改名叫Java
- 1996年初Sun发布了Java的第一个版本
- 2009年Sun公司被Oracle收购
- 2011年Oracle发布了Java的一个新版本——Java7
### 关于Java的常见误解
## 2. Java程序设计环境
### JShell
Java9引入了另一种使用Java的方法。Jshell程序提供了一个“读取－计算－打印循环”【REPL】。键入一个Java表达式；JShell会评估你的输入，打印结果，等待你的下一个输入。
	要启动JShell，只需要**在终端窗口中键入jshell**。

## 3. Java的基本程序设计结构
### 3.1 一个简单的Java应用程序
> 标准的命名规范为：类名是以大写字母开头的名词。如果名字由多个单词组成，每个单词的第一个字母都应该大写。
>  
>  源代码的文件名必须与公共类的名字相同，并用`.java`作为拓展名。

### 3.2 注释
```
// 单行注释

/*
多行注释
*/

/**
 * 文档注释
 * 
 */ 
```

### 3.3 数据类型
- 整型
	|类型| 存储需求 |
	|--|--|
	|int|4B|
	|short|2B|
	|long|8B|
	|byte|1B|
	
- 浮点类型
- char类型
- Unicode和char类型
- boolean类型
	* true
	* false
	
### 3.4 变量与常量
- 常量
	利用关键字`final`指示常量
	类常量：`static final`
- 枚举类型
	```
	enum Size {SMALL, MEDIUM, LARGE, EXTRA_LARGE}
	Size s = Size.MEDIUM;
	```
### 3.5 运算符
- 算术运算符
- 数学函数与常量
- 数值类型之间的转换【从小往大】
- 强制类型转换
- 结合赋值和运算符
- 自增与自减运算符
- 关系和boolean运算符
- 位运算符
- 括号与运算符级别

### 3.6 字符串
	从概念上来讲，Java字符串就是Unicode字符序列。例如，字符串“Java\u2122”由5个Unicode字符组成。
	Java没有内置的字符串类型，而是在标准Java类库中提供了一个预定义类，很自然地叫做String。
	每个用双括号括起来的字符串都是String类的一个实例：
	```
	String e = "";
	String greeting = "Hello";
	```
- 子串
- 拼接
	使用“+”号
- 不可变字符串
	String类没有提供修改字符串中某个字符的方法。
- 检测字符串是否相等
	equals方法
- 空串与null串
- 码点与代码单元
- String API
	所有字符串都属于`CharSequence`接口
- 阅读联机API文档
- 构建字符串
	`StringBuilder`

### 3.7 输入与输出
- 读取普通输入
	```
	import java.util.*;
	Scanner in = new Scanner(System.in);
	String name = in.nextLine();
	String firstName = in.next();
	int age = in.nextInt();
	```
- 读取密码
	```
	Console cons = System.console();
	String username = cons.readLine("User name:");
	char[] passwd = cons.readPassword("Password:"):
	```
- 格式化输出
	```
	System.out.printf("%8.2f", x);
	// 创建一个格式化的字符串，而不打印输出
	String message = String.format("Hello, %s. Next year, you'll be %d", name, age);
	System.out.printf("%tc", new Date());
	```
- 文件输入与输出
	```
	// 读取文件
	Scanner in = new Scanner(Path.of("myfile.txt"), StandardCharsets.UTF_8);
	//写入文件
	PrintWriter out = new PrintWriter("myfile.txt", StandardCharsets.UTF_8);
	```
	
	> 读取一个文本文件时，要知道它的字符编码。如果省略字符编码，则会使用运行这个Java程序的机器的“默认编码”。 
	>
	> 文件位于相对于Java虚拟机启动目录的位置
	> 启动目录就是命令解释器的当前目录
	> 可以使用如下命令找到这个目录的位置：
			```
			String dir = System.getProperty("user.dir");
	  ```
 
 
 ### 3.8 控制流程
 - 块作用域
 - 条件语句
 - 循环
 - 确定循环
 - 多重选择：switch语句
 - 中断控制流程的语句
 	> 带标签的break语句
 
 ### 3.9 大数
 - BigInteger——大整数
 - BigDecimal——大浮点
 
 ### 3.10 数组
 - 声明数组
	```
	int[] a;
	int a[];
	int[] a = new int[100];
	int[] smallPrimes = {2, 3, 5, 7, 11};
	String[] authors = {
		"James Gosling",
		"Bill Joy",
		"Guy Steele",
		// add more names here and put a comma after each name
	};
	// 声明匿名数组
	new int[] {17, 19, 23, 29};
	```

	> 在Java中，允许有长度为0的数组。
 - 访问数组元素
 - for each 循环
	```java
	// collection 这一集合表达式必须是一个数组或者是一个实现了 Iterable 接口的类对象
	for (variable : collection) statement
	```
	```
	for (int element : a)
		System.out.println(element);
	```
 - 数组拷贝
 - 命令行参数
	```shell
	java Class -g cruel world
	```
 - 数组排序
 	底层使用快排
 	`Arrays.sort(a);`
 - 多维数组
 - 不规则数组
 	> 理解：多维数组中的元素已经不再是单纯的数值了，而是指针，甚至是多维指针。

## 4. 对象和类
### 4.1 面向对象程序设计概述
- 类
- 对象
- 识别类【v n】
- 类之间的关系
	* 依赖（uses-a)
	* 聚合 (has-a)
	* 继承 (is-a)
### 4.2 使用预定义类
- 对象与对象变量
- LocalDate类
	> 用来表示时间点的Date类
	> 用日历表示法表示日期的LocalDate类
	`LocalDate.now();`
	`LocalDate.of(1999, 12, 31);`
	`LocalDate newYearsEve = LocalDate.of(1999, 12, 31);`
	`int year = newYearEve.getYear();`
	`int month = newYearEve.getMonthValue();`
	`int day = newYearEve.getDayOfMonth();`
- 更改器方法与访问器方法
### 4.3 用户自定义类
- 多个源文件的使用
	> 每次编译只需编译main方法所在的类
	> 当Java编译器发现当前编译类使用了其他类时，它会查找相应的`.class`文件。
	> 如果没有找到，就会自动搜索相应的`.java`文件，然后，对它进行编译。
	> **更重要的是：如果.java版本较已有的.class文件版本更新，Java编译器就会自动地重新编译这个文件。**
	
- 构造器
	> 有权限设定，无返回值类型
	> 构造器方法名同类名
	> 构造器总是结合 new 运算符来调用。不能对一个已经存在的对象调用构造器来达到重新设置实例字段的目的。
- 用 var 声明局部变量
	```
	Employee harry = new Employee("Harry Hacker", 5000, 1989, 10, 1);
	var harry = new Employee("Harry Hacker", 5000, 1989, 10, 1);
	```
	> **注意 var 关键字只能用于方法中的局部变量。参数和字段的类型必须声明**

- 使用 null 引用
- 隐式参数与显式参数
	> 隐式参数：this
	> 显式参数：

- final 实例字段
	> 如果类中的所有方法都不会改变其对象，这样的类就是不可变的类。例如，String 类就是不可变的。
	> final 关键字只是表示存储在evaluation变量中的对象引用不会再指示另一个不同的 StringBuilder 对象。不过这个对象可以更改。

### 4.4 静态字段与静态方法
- 静态字段
- 静态常量
	> `System.out`
- 静态方法
	> 没有 this 参数
	> 静态方法不能访问实例字段，但可以访问静态字段
	> 建议使用类名而不是对象来调用静态方法
- 工厂方法
- main方法

### 4.5 方法参数
**Java程序设计语言总是采用按值调用**
### 4.6 对象构造
- 重载
	> 查找匹配的过程被称为重载解析
	> 方法签名：方法名 + 参数类型
- 默认字段初始化
- 无参数的构造器
- 显式字段初始化
- 参数名
- 调用另一个构造器
	> 构造器第一条语句为 `this(...)`

- 初始化块
	> 首先运行初始化块，然后再调用构造器？
	> 初始化块之间按顺序执行
	> 静态初始化块
- 对象析构与 finalize 方法【废弃】

### 4.7 包
- 包名
	> oct.rekord.project_name
	> com.sxrekord.project_name
	> 个人使用上述两种包名都蛮不错的耶！
	> **从编译器的角度来看，嵌套的包之间没有任何关系。例如，java.util 包与 java.util.jar 包毫无关系。每一个包都是独立的类集合**
- 类的导入
- 静态导入
	`import static package`
- 在包中增加类
	> 无名包
- 包访问
- 类路径
	> JAR 文件使用 ZIP 格式组织文件和子目录。
	> 类路径所列出的目录和归档文件是搜寻类的**起始点**。
- 设置类路径
	```shell
	java -classpath dir MyProg
	java -classpath dir1:dir2:dir3 MyProg

	export CLASSPATH=dir1:dir2:dir3
	```

### 4.8 JAR 文件
一个 JAR 文件即可以包含类文件，也可以包含诸如图像和声音等其他类型的文件。此外，JAR文件是压缩的，它使用了我们熟悉的 ZIP 压缩格式。
- 创建 JAR 文件
	```
	jar cvf jarFileName file1 file2 ...
	jar options file1 file2 ...
	```
- 清单文件
	> 除了类文件、图像和其它资源外，每个 JAR 文件还包含一个清单文件（manifest)，用于描述归档文件的特殊特性。
	> 清单文件被命名为 MANIFEST.MF ，它位于 JAR 文件的一个特殊的 META-INF 子目录中。符合标准的最小清单文件极其简单：
		> Manifest-Version: 1.0
		
- 可执行 JAR 文件
- 多版本 JAR 文件
- 关于命令行选项的说明

### 4.9 文档注释
JDK 包含一个很有用的工具，叫做 javadoc，它可以由源文件生成一个 HTML 文档。
- 注释的插入
- 类注释
	> 类注释必须放在 import 语句之后，类定义之前。
	```java
	/**
	 * A {@code Card} object represents a playing card, such
	 * as "Queen of Hearts". A card has s suit (Diamond, Heart, 
	 * Spade or Club) and a value (1 = Ace, 2 ... 10, 11 = Jack,
	 * 12 = Queen, 13 = King) 	
	 */		
	```
- 方法注释
	> 每一个方法注释必须放在所描述的方法之前。
	+ @param variable description
	+ @return description
	+ throws class description
- 字段注释
	> 只需要对公共字段（通常指的是静态常量）建立文档
- 通用注释
	* @since 1.7.1
	* @author name
	* @version text
	* @see
	* @link
- 包注释
	1. 提供一个名为package-info.java 的 Java 文件。这个文件必须包含一个初始的以/**和*/界定的 Javadoc 注释，后面是一个 package 语句。它不能包含更多的代码或注释。
	2. 提供一个名为package.html 的 HTML 文件。会抽取标记 `<body>...<body>`之间的所有文本。
- 注释抽取
	```shell
	javadoc -d docDirectory nameofPackage
	javadoc -d docDirectory nameofPackage1 nameofPackage2
	javadoc -d docDirectory *.java
	```

### 4.10 类设计技巧
1. 一定要保证数据私有
2. 一定要对数据进行初始化
3. 不要在类中使用过多的基本类型
4. 不是所有的字段都需要单独的字段访问器和字段更改器。
5. 分解有过多职责的类
6. 类名和方法名要能够体现他们的职责
7. 优先使用不可变的类

## 5. 继承
### 5.1 类、超类、子类
- 定义子类
	`extends`
- 覆盖方法
	`super`
	子类方法不能低于超类方法的**可见性**。
- 子类构造器
	如果子类的构造器没有显式的调用超类的构造器，将自动的调用超类的无参构造器。
- 继承层次
	由一个公共超类派生出来的所有类的集合称为继承层次。
- 多态
	程序中出现超类对象的任何地方都可以使用子类对象替换
	在 Java 中，子类引用的数组可以转换成超类引用的数组，而不需要使用强制类型转换。
- 理解方法调用
	重载解析
	覆盖一个方法时，不但需要保证方法签名相同，**还需要保证返回类型的兼容性**。
	静态绑定【private 方法、static 方法、final 方法或者构造器】与动态绑定
	
- 阻止继承：final 类和方法
	final 类中的所有方法自动的成为 final 方法，**但不包括字段**。
- 强制类型转换
	多态过程中的“**承诺过多**”
	1. 只能在继承层次内进行强制类型转换。
	2. 在将超类强制转换成子类之前，应该使用`instanceof`进行检查。【null也适用】
- 抽象类
	1. abstract 可以修饰类
	2. 若使用 abstract 修饰了类中的某一个或多个方法，则该类必须被声明为 abstract
	3. 抽象类也可以包含字段和具体方法
	4. 抽象类不能实例化
	5. 可以声明一个抽象类的对象变量
- 受保护访问
	`protected`
- **访问控制修饰符**
	| 关键字 | 权限范围 |
	|--|--|
	| private | 仅对本类可见 |
	| public | 对外部完全可见 |
	| protected | 对本包和所有子类可见 |
	| 不需要修饰符（默认） | 对本包可见 |

### 5.2 Object：所有类的超类
- Object类型的变量
	1. 所有的数组类型，不管是对象数组还是基本类型的数组都扩展了 Object类。
	
	```java
		Object obj = null;
		Employee[] staff = new Employee[10];
		obj = staff;
		obj = new int[10];
	```
	
- equals 方法
	Object.equals 方法：如果两个参数都为 null ，返回true；如果两个参数都不为 null ，返回 a.equals(b)；如果其中有一个参数为 null ，返回 false 。
- 相等测试与继承
	* 要求：
		1.  自反性
		2. 对称性
		3. 传递性
		4. 一致性
		5. 对于任意非空引用 x， x.equals(null) 应该返回 false 。
	* 建议：
		1. 显式参数命名为 otherObject
		2. 检测 this 与 otherObject 是否相等
		3. 检测 otherObject 是否为 null
		4. 比较 this 与 otherObject 的类。
			+ getClass : 如果equals的语义可以在子类中改变
			+ instanceof : 如果所有的子类都有相同的相等性语义
		5. 将 otherObject 强制转换为相应类类型的变量
		6. 比较字段
			+ 使用 == 比较基本字段
			+ 使用 Objects.equals 比较对象字段
		
		> 对于数组类型的字段，可以使用静态的 Arrays.equals() 方法检测相应的数组元素是否相等。
		
- hashCode 方法
	> 散列码（hash code）是由对象导出的一个整型值。散列码是没有规律的。
	>
	> 由于 hashCode 方法定义在 Object 类中，因此每个对象都有一个默认的散列码，其值由对象的存储地址得出。
	>
	> **字符串 String 的散列码由内容导出**
	>
	> return Object.hash(field1, field2, field3);
	>
	> 如果存在数组类型的字段，那么可以使用静态的 Arrays.hashCoe 方法计算一个散列码，这个散列码由数组元素的散列码组成。
- toString 方法
	> 打印数组：Arrays.toString
	>
	> 打印多维数组：Arrays.deepToString

### 5.3 泛型数组列表
- 声明数组列表
- 访问数组列表元素
- 类型化与原始数组列表的兼容性	
### 5.4 对象包装器与自动装箱
1. 对应基本类型的类称为包装器（wrapper）
2. 包装器类是不可变的
3. 包装器类还是 final
4. 装箱和拆箱是编译器要做的工作，而不是虚拟机
### 5.5 参数数量可变的方法
返回值 方法名(类型... 形参名){}
### 5.6 枚举类
```java
public enum Size {
	SMALL("S"), MEDIUM("M"), LARGE("L"), EXTRA_LARGE("XL");
	private String abbreviation;
	
	private Size(String abbreviation) {
		this. abbreviation = abbreviation;
	}
	public String getAbbreviation() { return abbreviation; }
```
- 在比较两个枚举类型的值时，并不需要调用 equals ，直接使用 “==”  即可。
- 枚举的构造器总是私有的。
- 所有的枚举类型都是Enum类的子类
- toString
- valueOf
- values
- ordinal
- compareTo
### 5.7 反射
- 作用：
	* 在运行时分析类的能力
	* 在运行时检查对象
	* 实现泛型数组操作代码
	* 利用Method对象
- Class类
	> 在程序运行期间，Java 运行时系统始终为所有对象维护一个运行时类型标识。这个信息会跟踪每个对象所属的类。
	>
	> 虚拟机利用运行时类型信息选择要执行的正确的方法
	>
	> 可以使用一个特殊的 Java 类访问这些信息。保存这些信息的类名为 **Class**。
	>
	> Class 类实际上是一个泛型类
	>
	> 获取 Class 对象的两种方式
		1. 对象.getClass()
		2. Class.forName(全类名);
		3. 对象.class
	>
	> 虚拟机为每个类型管理一个唯一的 Class 对象。因此，可以利用 == 运算符实现两个类对象的比较。
	
- 声明异常入门
- 资源
- 利用反射分析类的能力
- 使用反射在运行时分析对象 
- 使用反射编写泛型数组代码
- 调用任意方法和构造器

### 5.8 继承的设计技巧
1. 将公共操作和字段放在超类中。
2. 不要使用受保护的字段
3. 使用继承实现 “is-a” 关系
4. 除非所有继承的方法都有意义，否则不要使用继承
5. 在覆盖方法时，不要改变预期的行为
6. 使用多态，而不要使用类型信息
7. 不要滥用反射
## 接口、lambda表达式与内部类
### 6.1 接口
- 接口的概念
	* 接口中的所有方法都自动是 public 方法
	* **接口不能有实例字段**
	* 在实现接口时，必须把方法声明为 public
- 接口的属性
	* 可以声明接口类型的变量
	* 可以使用 instanceof 检查一个对象是否实现了某个特定的接口
	* 接口的扩展使用关键字 **extends**
	* 接口中可以包含常量
	* 接口中的字段总是 **public static final**
	* 多个接口之间使用逗号分割
- 接口与抽象类
- 静态和私有方法
	* 在 Java8 中，允许在接口中增加静态方法。
	* 在 Java9 中，接口中的方法可以是 private
- 默认方法
	> 可以为接口方法提供一个默认实现。必须用 default 修饰符标记这样一个方法。
	>
	> 默认方法可以调用其他方法
- 解决默认方法冲突
	1. 超类优先
	2. 接口冲突
	
- 接口与回调
	> 回调是一种常见的程序设计模式。在这种模式中，可以指定某个特定事件发生时应该采取的动作。
	
- Comparator 接口
	> 接口方法：compare
	
- 对象克隆
	1. 实现 Cloneable 接口
	2. 重新定义 clone 方法，并指定 public 访问修饰符
	> Cloneable 属于标记接口【不包含任何方法的接口】
### 6.2 lambda 表达式
- 为什么引入 lambda 表达式
	> lambda 表达式是一个可传递的代码快，可以在以后执行一次或多次。
	
- lambda 表达式的语法
	```java
	(Type1 arg1, Type2 arg2) -> {
		statement;
		...;
	}
	```

	1. 即使 lambda 表达式没有参数，仍然要提供空括号，就像无参数方法一样
	2. 如果可以推导出一个 lambda 表达式的参数类型，则可以忽略其类型。
	3. 如果方法只有一个参数，而且这个参数的类型可以推导得出，那么甚至还可以忽略小括号
	4. 无须指定 lambda 表达式的返回类型。
	5. 如果只有一条代码，则可以省略花括号及分号。

- 函数式接口
	对于只有一个抽象方法的接口，需要这种接口的对象时，就可以提供一个 lambda 表达式。这种接口称为函数式接口。

- 方法引用
	```java
	var timer = new Timer(1000, System.out::println);
	Arrays.sort(strings, String::compareToIgnoreCase)
	```

	1. object::instanceMethod ==> x -> System.out.println(x)
	2. Class::instanceMethod ==> (x, y) -> x.compareToIgnoreCase(y)
	3. Class::staticMethod ==> (x, y) -> pow(x, y)

	> 只有当 lambda 表达式的体只调用一个方法而不做其他操作时，才能把 lambda 表达式重写为方法引用

- 构造器引用
	方法名为 new 的方法引用？
- 变量作用域
- 处理 lambda 表达式
- 再谈 Comparator
### 6.3 内部类
- 使用内部类访问对象状态
- 内部类的特殊语法规则
- 内部类是否有用、必要和安全
- 局部内部类
- 由外部方法访问变量
- 匿名内部类
- 静态内部类
### 6.4 服务加载器
### 6.5 代理
- 何时使用代理
- 创建代理对象
- 代理类的特性

