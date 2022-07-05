---
layout: post
title: Java 泛型
date: 2022/07/05
updated: 2022/07/05
cover: /assets/java.webp
coverWidth: 889
coverHeight: 500
comments: true
categories: 
- 技术
tags:
- Java
---

## 什么是泛型

### 1. 背景：

`Java`推出泛型以前，程序员可以构建一个元素类型为`Object`的集合，该集合能够存储任意的数据类型对象，而在使用该集合的过程中，需要程序员明确知道存储每个元素的数据类型，否则很容易引发`ClassCastException`异常。

### 2. 概念：

Java泛型（generics）是JDK5中引入的一个新特性，泛型提供了编译时类型安全监测机制，该机制允许我们在编译时检测到非法的类型数据结构。泛型的本质就是参数化类型，也就是所操作的数据类型被指定为一个参数。

### 3. 好处：

- 类型安全
- 代码复用
- 消除了强制类型的转换

### 4. 类型参数：

- E - Element (在集合中使用，因为集合中存放的是元素)
- T - Type（表示Java 类，包括基本的类和我们自定义的类）
- K - Key（表示键，比如Map中的key）
- V - Value（表示值）
- N - Number（表示数值类型）
- ？ - （表示不确定的java类型）
- S、U、V - 2nd、3rd、4th types

## 泛型类、接口

### 1. 泛型类

1. 使用语法
类名<具体的数据类型> 对象名 = new 类名<具体的数据类型>();

2. Java1.7以后，后面的<>中的具体的数据类型可以省略不写
类名<具体的数据类型> 对象名 = new 类名<>(); // 菱形语法

### 2. 泛型类注意事项：

- 泛型类，如果没有指定具体的数据类型，此时，操作类型是Object
- 泛型的类型参数只能是类类型，不能是基本数据类型
- 泛型类型在逻辑上可以看成是多个不同的类型，但实际上都是相同类型，代码如下：
```java
package com.sxrekord.generic;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 8:44  
 */public class Generic<T> {  
}  
  
class GenericTest {  
    public static void main(String[] args) {  
        Generic<String> stringGeneric = new Generic<>();  
        Generic<Integer> integerGeneric = new Generic<>();  
  
        System.out.println(stringGeneric.getClass());  
        System.out.println(integerGeneric.getClass());  
  
        System.out.println(stringGeneric.getClass() == integerGeneric.getClass());  
    }  
}

/** output  
 * class com.sxrekord.generic.Generic 
 * class com.sxrekord.generic.Generic 
 * true 
 */
```

### 3. 从泛型类派生子类

- 子类也是泛型类，子类和父类的泛型类型要一致
```java
//父类
public class Parent<E> {
    private E value;
    public E getValue() {
        return value;
    }
    public void setValue(E value) {
        this.value = value;
    }
}

/**
 * 泛型类派生子类，子类也是泛型类，那么子类的泛型标识要和父类一致。
 * @param <T>
 */
public class ChildFirst<T> extends Parent<T> {
    @Override
    public T getValue() {
        return super.getValue();
    }
}

// or
public class ChildFirst<T, S> extends Parent<T> {
    @Override
    public T getValue() {
        return super.getValue();
    }
}
```
- 子类不是泛型类，父类要明确泛型的数据类型
```java
class ChildGeneric extends Generic<String>
/**
 * 泛型类派生子类，如果子类不是泛型类，那么父类要明确数据类型
 */
public class ChildSecond extends Parent<Integer> {
    @Override
    public Integer getValue() {
        return super.getValue();
    }
    @Override
    public void setValue(Integer value) {
        super.setValue(value);
    }
}
```

### 4. 泛型接口

泛型接口的定义语法：
```java
interface 接口名称 <泛型标识，泛型标识，…> {
	泛型标识 方法名(); 
	.....
}
```

### 5. 泛型接口的使用
- 实现类也是泛型类，实现类和接口的泛型类型要一致
- 实现类不是泛型类，接口要明确数据类型

## 泛型方法

### 1. 用法

泛型方法是在调用方法的时候指明泛型的具体类型。

### 2. 语法:

修饰符 <T，E, ...> 返回值类型 方法名(形参列表) { 方法体... }

### 3. 说明：

- public与返回值中间\<T>非常重要，可以理解为声明此方法为泛型方法。
- 只有声明了\<T>的方法才是泛型方法，泛型类中的使用了泛型的成员方法并不是泛型方法。
- \<T>表明该方法将使用泛型类型T，此时才可以在方法中使用泛型类型T。
- 与泛型类的定义一样，此处T可以随便写为任意标识，常见的如T、E、K、V等形式的参数常用于表示泛型。

### 4. 泛型方法与可变参数

```java
public <E> void print(E... e){
	for (E e1 : e) {
		System.out.println(e1);
	}
}
```

### 5. 泛型方法总结

- 泛型方法能使方法独立于类而产生变化
```java
package com.sxrekord.generic;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 9:30  
 */public class StaticGeneric<T> {  
    // 报错：无法从 static 上下文引用 'com.sxrekord.generic.StaticGeneric.this'//    public static void staticPrint(T t) {  
//        System.out.println("I am in staticPrint");  
//        System.out.println(t);  
//    }  
  
    public void print(T t) {  
        System.out.println("I am in print");  
        System.out.println(t);  
    }  
  
    public <E> void genericPrint(E e) {  
        System.out.println("I am in genericPrint");  
        System.out.println(e);  
    }  
  
    public static <E> void genericStaticPrint(E e) {  
        System.out.println("I am in genericPrint");  
        System.out.println(e);  
    }  
}  
  
  
class StaticGenericTest {  
    public static void main(String[] args) {  
        StaticGeneric<String> stringStaticGeneric = new StaticGeneric<>();  
        stringStaticGeneric.print("abc");  
        // 报错：类型不正确  
//        stringStaticGeneric.print(123);  
  
        // test genericPrint        System.out.println("--------------------------------------");  
        stringStaticGeneric.genericPrint("abc");  
        stringStaticGeneric.genericPrint(123);  
  
        // test genericStaticPrint  
        System.out.println("-------------------------------------");  
        StaticGeneric.genericStaticPrint("abc");  
        StaticGeneric.genericStaticPrint(123);  
        // compile error  
//        StaticGeneric<Integer>.genericStaticPrint("abc");  
//        StaticGeneric<Integer>.genericStaticPrint(123);  
    }  
}  
/** output  
 * I am in print 
 * abc 
 * -------------------------------------- 
 * I am in genericPrint 
 * abc 
 * I am in genericPrint 
 * 123 
 * ------------------------------------- 
 * I am in genericPrint 
 * abc 
 * I am in genericPrint 
 * 123 
 */
```

## 类型通配符

### 1. 什么是类型通配符

类型通配符一般是使用"?"代替具体的类型实参。所以，类型通配符是类型实参，而不是类型形参。
```java
package com.sxrekord.generic;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 9:50  
 */public class Box<T> {  
    private T val;  
    public Box(T t) {  
        val = t;  
    }  
  
    public T get() {  
        return val;  
    }  
}  
  
class BoxTest {  
    public static void main(String[] args) {  
        Box<Number> box = new Box<>(100);  
        showBox(box);  
  
        Box<Integer> integerBox = new Box<>(200);  
        // compile error  
//        showBox(integerBox);  
        showBox(integerBox);  
  
        Box<?> bbox = new Box<Double>(120.123);  
        Object obj = bbox.get();  
        System.out.println(obj);  
    }  
  
//    public static void showBox(Box<Number> box) {  
//        Number number = box.get();  
//        System.out.println(number);  
//    }  
  
    public static void showBox(Box<?> box) {  
        // compile error  
//        Integer integer = box.get();  
//        Number number = box.get();  
  
        Object object = box.get();  
        System.out.println(object);  
    }  
  
    // compile error：方法冲突  
//    public static void showBox(Box<Integer> box) {  
//        Integer integer = box.get();  
//        System.out.println(integer);  
//    }  
}  
  
/**  
 * 1. 泛型类型的具体类型之间无法重载：如 Box<Integer> 与 Box<Number> 被视为同一种类型  
 * 2. 泛型类型的具体类型存续的继承关系不再有效，如 Box<Number> box = new Box<Integer>(); // compile error  
 * 3. 由于第二点存在的问题，故引出通配符 ? 。 Box<?> box = new Box<Number>; // compile success  
 * 4. 同时由于使用了通配符，得到的类型也将回到原点，成为 Object  
 */
```

### 2. 类型通配符的上限
语法：
类/接口\<? extends 实参类型>
要求该泛型的类型，只能是实参类型，或实参类型的子类类型。

```java
package com.sxrekord.generic;  
  
import java.util.ArrayList;  
import java.util.List;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 9:50  
 */
  
class BoxTest {  
    public static void main(String[] args) {  
        Box<Number> box = new Box<>(100);  
        showBox(box);  
  
        Box<Integer> integerBox = new Box<>(200);  
        showBox(integerBox);  
  
        Box<String> stringBox = new Box<>("abc");  
        // compile error  
//        showBox(stringBox);  
  
        List<? extends Number> list1 = new ArrayList<>();  
        Double d = 32.34;  
//        list1.add(d);  
//        list1.add(123);  
//        list1.add(new Object());  
        List<? extends Number> list2 = new ArrayList<Integer>();  
        Integer i = 233;  
//        list2.add(i);  
    }  
  
    // compile error  
//    public static void showBox(Box<?> box) {  
//        Object object = box.get();  
//        System.out.println(object);  
//    }  
  
    public static void showBox(Box<? extends Number> box) {  
        Number number = box.get();  
        System.out.println(number);  
    }  
}  
  
/**  
 * 1. Box<?> 与 Box<? extends Number> 也被视为同一种类型  
 * 2. 使用带上限的通配符泛型不能填充任何类型的元素  
 */
```

```java
package com.sxrekord.generic;  
  
import java.util.ArrayList;  
import java.util.List;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 10:53  
 */public class Animal {  
}  
  
class Cat extends Animal {  
    public void show() {  
        System.out.println("I am in Animal show()");  
    }  
}  
  
class MiniCat extends Cat {  
    private String name;  
}  
  
class AnimalTest {  
    public static void main(String[] args) {  
        List<Animal> animals = new ArrayList<>();  
        List<Cat> cats = new ArrayList<>();  
        cats.add(new Cat());  
        List<MiniCat> miniCats = new ArrayList<>();  
        miniCats.add(new MiniCat());  
        // compile error  
//        testExtends(animals);  
  
        testExtends(cats);  
        testExtends(miniCats);  
    }  
  
    public static void testExtends(List<? extends Cat> list) {  
        // compile error  
//        list.add(new Animal());  
//        list.add(new Cat());  
//        list.add(new MiniCat());  
  
        // compile error
//        List<Object> objects = (List<Object>)list;
//        List<String> strings = (List<String>)list;  
//        List<Animal> animals = (List<Animal>)list; 
        List<Cat> cats = (List<Cat>)list;  
        List<MiniCat> miniCats = (List<MiniCat>)list;  
  
        if (!list.isEmpty()) {  
            // compile error  
//            MiniCat miniCat = list.get(0);  
            Cat cat = list.get(0);  
            cat.show();  
        }  
    }  
}  
  
/** output  
 * 1. 带上限的通配符泛型类型支持强转，但只能强转为上限或上限的子类。  
 * 2. 由于 List<? extends Cat> 可以接收多种具体类型的泛型类型，故不可以放置任何元素。  
 * 3. 因为泛型的初衷就是编译时将泛化类型确定为某一种特定类型  
 */
```
### 3. 类型通配符的下限
语法：
类/接口\<? super 实参类型>
要求该泛型的类型，只能是实参类型，或实参类型的父类类型。
```java
package com.sxrekord.generic;  
  
import java.util.ArrayList;  
import java.util.List;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 10:53  
 */public class Animal {  
}  
  
class Cat extends Animal {  
    public void show() {  
        System.out.println("I am in Animal show()");  
    }  
}  
  
class MiniCat extends Cat {  
    private String name;  
}  
  
class AnimalTest {  
    public static void main(String[] args) {  
        List<Animal> animals = new ArrayList<>();  
        List<Cat> cats = new ArrayList<>();  
        cats.add(new Cat());  
        List<MiniCat> miniCats = new ArrayList<>();  
        miniCats.add(new MiniCat());  
        // compile error  
//        testExtends(animals);  
  
        testExtends(cats);  
        testExtends(miniCats);  
  
        System.out.println("----------------------------");  
        testSuper(animals);  
        testSuper(cats);  
        // compile error  
//        testSuper(miniCats);  
    }  
  
    public static void testSuper(List<? super Cat> list) {  
        list.add(new Cat());  
        list.add(new MiniCat());  
//        list.add(new Animal());  
//        list.add(new Object());  
  
        for (Object o : list) {  
            System.out.println(o);  
        }  
  
        List<Object> objects = (List<Object>)list;  
        List<Animal> animals = (List<Animal>)list;  
        List<Cat> cats = (List<Cat>)list;  
//        List<String> strings = (List<String>)list;  
//        List<MiniCat> miniCats = (List<MiniCat>)list;  
    }  
}  
  
/** output  
 * 1. <? super AnyType> 能添加元素，但要求这些元素必须是 AnyType 或其子类  
 * 2. 支持强转，但只能强转为下限或下限的父类型  
 * 3. 由于支持强转，故可能在代码中将其强转为下限的某一个父类型，所以只要添加的是下限或下限的子类型，那么整个过程就不会出问题。  
 */
```

## 类型擦除

### 1. 动机

擦除的核心动机是它使得泛化的客户端可以使用非泛化的类库，反之亦然。这经常被称为“迁移兼容性”。

### 2. 概念
泛型是Java 1.5版本才引进的概念，在这之前是没有泛型的，但是泛型代码能够很好地和之前版本的代码兼容。那是因为，泛型信息只存在于代码编译阶段，在进入JVM之前，与泛型相关的信息会被擦除掉，我们称之为–类型擦除。

### 3. 分类：
- 无限制类型擦除：
![无限制类型擦除](/assets/无限制类型擦除.png)
```java
package com.sxrekord.generic.erase;  
  
import java.lang.reflect.Field;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 12:47  
 */public class Erasure<T> {  
    private T key;  
  
    public T getKey() {  
        return key;  
    }  
  
    public void setKey(T key) {  
        this.key = key;  
    }  
}  
  
class ErasureTest {  
    public static void main(String[] args) {  
        Erasure<Integer> integerErasure = new Erasure<>();  
        Class<? extends Erasure> clz = integerErasure.getClass();  
        Field[] declaredFields = clz.getDeclaredFields();  
        for (Field field : declaredFields) {  
            // 打印成员变量的名称和类型  
            System.out.println(field.getName() + ":" + field.getType().getSimpleName());  
        }  
    }  
}  
  
/** output  
 * key:Object 
 */
```

- 有限制类型擦除
```java
package com.sxrekord.generic.erase;  
  
import java.lang.reflect.Field;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 12:47  
 */public class Erasure<T extends Number> {  
    private T key;  
  
    public T getKey() {  
        return key;  
    }  
  
    public void setKey(T key) {  
        this.key = key;  
    }  
}  
  
class ErasureTest {  
    public static void main(String[] args) {  
        Erasure<Integer> integerErasure = new Erasure<>();  
        Class<? extends Erasure> clz = integerErasure.getClass();  
        Field[] declaredFields = clz.getDeclaredFields();  
        for (Field field : declaredFields) {  
            // 打印成员变量的名称和类型  
            System.out.println(field.getName() + ":" + field.getType().getSimpleName());  
        }  
    }  
}  
  
/** output  
 * key:Number 
 */
```
- 擦除方法中类型定义的参数
```java
package com.sxrekord.generic.erase;  
  
import java.lang.reflect.Field;  
import java.lang.reflect.Method;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 12:47  
 */public class Erasure<T extends Number> {  
    private T key;  
  
    public T getKey() {  
        return key;  
    }  
  
    public void setKey(T key) {  
        this.key = key;  
    }  
  
    public <E> E show1(E e) {  
        return e;  
    }  
  
    public <E extends Number> E show2(E e) {  
        return e;  
    }  
}  
  
class ErasureTest {  
    public static void main(String[] args) {  
        Erasure<Integer> integerErasure = new Erasure<>();  
        Class<? extends Erasure> clz = integerErasure.getClass();  
        Field[] declaredFields = clz.getDeclaredFields();  
        for (Field field : declaredFields) {  
            // 打印成员变量的名称和类型  
            System.out.println(field.getName() + ":" + field.getType().getSimpleName());  
        }  
  
        System.out.println("---------------------");  
        Method[] methods = clz.getDeclaredMethods();  
        for (Method method : methods) {  
            System.out.println(method.getName() + ":" + method.getReturnType().getSimpleName());  
        }  
    }  
}  
  
/** output  
 * key:Number 
 * --------------------- 
 * getKey:Number 
 * show1:Object 
 * show2:Number 
 * setKey:void 
 */
```
- 桥接方法
![桥接方法](/assets/桥接方法.png)
```java
package com.sxrekord.generic.erase;  
  
import java.lang.reflect.Method;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 20:20  
 */public interface Info<T> {  
    T info(T t);  
}  
  
class InfoImpl implements Info<Integer> {  
    @Override  
    public Integer info(Integer t) {  
        return t;  
    }  
}  
  
class InfoTest {  
    public static void main(String[] args) {  
        Class<InfoImpl> infoClass = InfoImpl.class;  
        Method[] methods = infoClass.getDeclaredMethods();  
        for (Method method : methods) {  
            System.out.println(method.getName() + ":" + method.getReturnType().getSimpleName());  
        }  
    }  
}  
  
/** output  
 * info:Integer 
 * info:Object 
 */
```

## 泛型与数组
### 1. 泛型数组的创建

- 可以声明带泛型的数组引用，但是不能直接创建带泛型的数组对象
```java
package com.sxrekord.generic;  
  
import java.lang.reflect.Array;  
import java.util.ArrayList;  
  
/**  
 * @author Rekord  
 * @date 2022/7/5 20:30  
 */public class GenericArray {  
    public static void main(String[] args) {  
        // compile error  
//        ArrayList<String>[] arrayLists = new ArrayList<String>[5];  
        ArrayList<String>[] arrayLists = new ArrayList[5];  
  
        ArrayList<Integer> integers = new ArrayList<>();  
        ArrayList<String> strings = new ArrayList<>();  
  
        // compile error  
//        arrayLists[0] = integers;  
        arrayLists[0] = strings;  
    }  
}
```
- 可以通过java.lang.reflect.Array的newInstance(Class,int)创建T[]数组
```java
public class Fruit<T> {
    private T[] array;

    public Fruit(Class<T> clz, int length){
        //通过Array.newInstance创建泛型数组
        array = (T[])Array.newInstance(clz, length);
    }
}
```

## 泛型和反射
### 1. 反射常用的泛型类
- Class
- Constructor
```java
public class Person {
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
/**
 *泛型与反射
 */
public class Test11 {
	public static void main(String[] args) throws Exception {
	     Class<Person> personClass = Person.class;
	     Constructor<Person> constructor = personClass.getConstructor();
	     Person person = constructor.newInstance();
	 }
}
```

## 个人思考

### \<? extends AnyType>
1. 能接收所有泛型类型参数为 AnyType 或 AnyType 子类的泛型类型。
2. 支持强转为 AnyType 或 AnyType 的子类类型。

根据以上两点既定事实，我们可以有以下解释：
**由于 \<? extends AnyType> 类型仅仅只是作为一个形参，并且它满足第一点和第二点，故它可能在程序中被强转为 AnyType 或 AnyType 的子类类型。 那么如果它可以放置某一种类型的元素（不管是AnyType 还是 AnyType 的子类亦或是其他任何类），那么势必会破坏`Java`泛型的初衷，因为当它被强转为某一种特定类型时，这种可能的特定类型无法确定，为了保证同一种泛型类中的所有元素为同一类型，所以不能冒昧的往里面添加任何类型的元素。**
最终，我们得到第三点：
3. **不能往其内部添加任何类型的元素**

### \<? super AnyType>
1. 能接受所有泛型类型参数为 AnyType 或 AnyType 父类的泛型类型。
2. 支持强转为 AnyType 或 AnyType 的父类类型

根据以上两点既定事实，我们可以有以下解释：
**由于 \<? super AnyType> 类型仅仅只是作为一个形参，并且它满足第一点和第二点，故它可能在程序中被强转为 AnyType 或 AnyType 的父类类型。那么如果它放置 AnyType 或 AnyType 的子类类型元素后，对强转后的使用是不构成任何影响的。反之，如果它放置 AnyType 的父类类型元素后，会出现与 \<? extends AnyType> 相似的问题。**
最终，我们得到第三点：
3. **能够往其内部添加 AnyType 或 AnyType 的子类元素**

### 总结
从以上两个看似”奇怪“和难以理解的问题分析得知，**泛型一切现象的背后不过是在维护着泛型最初的动机。**

## 参考材料
- [黑马程序员/JavaSE强化教程泛型，由点到面的讲解了整个泛型体系](https://www.bilibili.com/video/BV1xJ411n77R?p=1&vd_source=63cc3f528a2c894db6eb5fbd094eeb54)
- [https://blog.csdn.net/Beyondczn/article/details/107093693](https://blog.csdn.net/Beyondczn/article/details/107093693)
- [Java编程思想]()