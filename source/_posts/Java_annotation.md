---
layout: post
title: Java 注解
date: 2022/07/07
updated: 2022/07/07
cover: /assets/java.webp
coverWidth: 889
coverHeight: 500
comments: true
categories: 
- 技术
tags:
- Java
---

## 1. 什么是注解
### 1.1 概念

>百度上的解释： 
>Java 注解（Annotation）又称 Java 标注，是 JDK5.0 引入的一种注释机制，是一种代码级别的说明。Java 语言中的类、方法、变量、参数和包等都可以被标注。和 Javadoc 不同，Java 标注可以通过反射获取标注内容。在编译器生成类文件时，标注可以被嵌入到字节码中。Java 虚拟机可以保留标注内容，在运行时可以获取到标注内容 。 当然它也支持自定义 Java 标注。

概念描述：
- JDK1.5 之后的新特性
- 用来说明程序的
- 使用注解：@注解名称

### 1.2 作用分类
- 编译检查：通过代码里标识的注解让编译器能够实现基本的编译检查【Override】
- 编写文档：通过代码里标识的注解生成文档【生成文档doc文档】，API文档是通过抽取代码中的文档注释生成的。
- 代码分析：通过代码里标识的注解对代码进行分析【使用反射】

## 2. JDK中预定义的一些注解
- @Override ： 检测被该注解标注的方法是否搜集继承自父类(接口)的
- @Deprecated ：将该注解标注的内容，表示已过时
- @SuppressWarnings ：压制警告，一般传递参数all @SuppressWarnings("all")

## 3. 自定义注解
### 3.1 格式
元注解：`public @interface AnnotationName{}`

### 3.2 本质
注解本质上就是一个接口，该接口默认继承`Annotation`接口
```java
public interface MyAnno extends java.lang.annotation.Annotation{
	returnType methodName1();
	returnType methodName2() default value;
}
```

### 3.3 属性
可以理解为接口中可以定义的抽象方法。

要求： 
1. 属性的返回值类型只能为以下几种：
	- 基本数据类型
	- String
	- 枚举
	- 注解
	- 以上类型的数组
2. 定义了的属性（本质上是抽象方法），在使用时需要进行赋值
	- 格式：`(methodName1 = value1, methodName2 = value2)`
	- 如果定义属性时，使用default关键字给属性默认初始化值，则使用注解时，可以不进行属性的赋值。
	- 如果只有一个属性需要赋值，并且这个属性的名称是value，那么value可以省略，直接赋值即可。
	- 数组赋值时，值使用大括号包裹。如果数组中只有一个值，那么{}可以省略

### 3.4 元注解
概念：用于描述注解的注解。

- @Target：描述能够作用的位置

```java
@Target(value = {ElementType.TYPE}) //表示该MyAnno注解只能作用于类上
public @interface MyAnno {
}

其中value中的ElementType是一个枚举类型，取值可以有以下几种情况：
- TYPE:可以作用在类上
- METHOD:可以作用在方法上
- FIELD：可以作用于成员变量上
```
- @Retention：描述注解被保留的阶段
>@Retention(RetentionPolicy.RUNTIME)：当前被描述的注解，会保留到字节码文件中，并被JVM读取到，一般自己定义的注解都加RUNTIME

- @Documented：描述该注解是否会被抽取到api文档中
- @Inherited：描述注解是否被子类继承

## 4. 在程序中使用注解
注解在程序中经常和反射一起使用，注解大多数来说都是用来替换配置文件的，拿之前反射的程序来举例：

```java
// 被测试的类AnnoTest1：

public class AnnoTest1 {
    public void play(){
        System.out.println("AnnoTest1 method play()");
    }
}

// 原始的反射代码：
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Properties;
 
/**
 * @author liwenlong
 * @data 2020/3/6
 */
public class ReflectTest {
    public static void main(String[] args) throws Exception {
 
        /**
         * 前提：不能改变该类的任何代码。可以创建任意类的对象，可以执行任意方法
         * 即：拒绝硬编码
         */
 
        //1.加载配置文件
        //1.1创建Properties对象
        Properties pro = new Properties();
        //1.2加载配置文件，转换为一个集合
        //1.2.1获取class目录下的配置文件  使用类加载器
        ClassLoader classLoader = ReflectTest.class.getClassLoader();
        InputStream is = classLoader.getResourceAsStream("pro.properties");
        pro.load(is);
 
        //2.获取配置文件中定义的数据
        String className = pro.getProperty("className");
        String methodName = pro.getProperty("methodName");
 
        //3.加载该类进内存
        Class cls = Class.forName(className);
        //4.创建对象
        Object obj = cls.newInstance();
        //5.获取方法对象
        Method method = cls.getMethod(methodName);
        //6.执行方法
        method.invoke(obj);
    }
 
}

// 对应的配置文件pro：

className=cn.other.annotation.AnnoTest1
methodName=play


// 新建注解AnnoReflect ：
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
 
/** 描述需要执行的类名和方法名
 * @author liwenlong
 * @data 2020/3/6
 */
@Target(ElementType.TYPE) //可以被作用在类上
@Retention(RetentionPolicy.RUNTIME)
public @interface AnnoReflect {
    String className();
    String methodName();
}
 
// 使用注解的方式来淘汰配置文件(注释很重要)：
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Properties;
 
/**
 * @author liwenlong
 * @data 2020/3/6
 */
 
@AnnoReflect(className = "cn.other.annotation.AnnoTest1",methodName = "play")
public class ReflectAnnotationTest {
    public static void main(String[] args) throws Exception {
 
        /**
         * 前提：不能改变该类的任何代码。可以创建任意类的对象，可以执行任意方法
         * 即：拒绝硬编码
         */
 
        //1. 解析注解
        //1.1 获取该类的字节码文件对象
        Class<ReflectAnnotationTest> rac = ReflectAnnotationTest.class;
        //1.2 获取上面的注解对象,其实就是在内存中生成了一个该注解接口的子类实现对象
        AnnoReflect an = rac.getAnnotation(AnnoReflect.class);
        /*
        相当于
        public class AnnotationReflect implements AnnoReflect{
            public String className(){
                return "cn.other.annotation.AnnoTest1";
            }
            public String methodName(){
                return "play";
            }
        }
        */
        //2. 调用注解对象中定义的抽象方法，获取返回值
        String className = an.className();
        String methodName = an.methodName();
 
        //3.加载该类进内存
        Class cls = Class.forName(className);
        //4.创建对象
        Object obj = cls.newInstance();
        //5.获取方法对象
        Method method = cls.getMethod(methodName);
        //6.执行方法
        method.invoke(obj);
 
    }
}
```

使用总结：
- 获取注解定义的位置的对象  (Class, Method, Field)
- 获取指定的注解：getAnnotation(Class)
- 调用注解中的抽象方法获取配置的属性值

## 5. 案例：简单的测试框架
需求：设计一个框架，检测一个类中的方法使用有异常，并进行统计。

```java
// 待测试的类

/** 计算器类
 * @author liwenlong
 * @data 2020/3/6
 */
public class calculator {
 
    public void add(){
        System.out.println("1+0="+(1+0));
    }
 
    public void sub(){
        System.out.println("1-0="+(1-0));
    }
 
    public void mul(){
        System.out.println("1*0="+(1*0));
    }
 
    public void div(){
        System.out.println("1/0="+(1/0));
    }
    
    public void show(){
        System.out.println("今天天气真不错！");
    }
}

// 首先自定义一个注解：

@Retention(RetentionPolicy.RUNTIME) //运行时
@Target(ElementType.METHOD) //加在方法前面
public @interface Check {}

// 然后编写一个类专门用于检查(注意注释)：
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
 
/** 简单的测试框架
 * 当主方法执行后，会自动自行检测所有方法(加了check注解的方法)，判断方法是否有异常并记录
 * @author liwenlong
 * @data 2020/3/6
 */
public class TestCheck {
    public static void main(String[] args) throws IOException {
        //1. 创建计算机对象
        calculator c = new calculator();
        //2. 获取字节码文件对象
        Class cls = c.getClass();
        //3. 获取所有方法
        Method[] methods = cls.getMethods();
 
        int num = 0; //记录出现异常的次数
        BufferedWriter bw = new BufferedWriter(new FileWriter("bug.txt"));
 
        for(Method method:methods){
            //4. 判断方法上是否有Check注解
            if(method.isAnnotationPresent(Check.class)){
                //5. 有注解就执行,捕获异常
                try {
                    method.invoke(c);
                } catch (Exception e) {
                    e.printStackTrace();
                    //6.将异常记录在文件中
                    num++;
                    bw.write(method.getName()+"方法出异常了");
                    bw.newLine();
                    bw.write("异常的名称是："+e.getCause().getClass().getSimpleName());
                    bw.newLine();
                    bw.write("异常原因："+e.getCause().getMessage());
                    bw.newLine();
                    bw.write("=====================");
                    bw.newLine();
                }
            }
        }
        bw.write("本次测试一共出现"+num+"次异常");
        bw.flush();
        bw.close();
 
    }
 
}

// 在待测试的类中每个需要测试的方法前面都加上@Check

/** 计算器类
 * @author liwenlong
 * @data 2020/3/6
 */
public class calculator {
    @Check
    public void add(){
        System.out.println("1+0="+(1+0));
    }
    @Check
    public void sub(){
        System.out.println("1-0="+(1-0));
    }
    @Check
    public void mul(){
        System.out.println("1*0="+(1*0));
    }
    @Check
    public void div(){
        System.out.println("1/0="+(1/0));
    }
 
    public void show(){
        System.out.println("今天天气真不错！");
    }
}

// 运行TestCheck类中的主方法，就会自动检查所有注解@Check的方法是否异常：
```
小结 ：
- 大多数时候，我们会使用注解而不是自定义注解
- 注解给编译器和解析程序用
- 注解不是程序的一部分，可以理解为标签

## 参考材料
- [【黑马程序员-Java语言高级部分9.3】Java注解](https://www.bilibili.com/video/BV1Vt411g7RP?spm_id_from=333.337.search-card.all.click&vd_source=63cc3f528a2c894db6eb5fbd094eeb54)
- [【Java基础】 注解](https://blog.csdn.net/zzu_seu/article/details/104673681)