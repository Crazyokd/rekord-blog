---
title: Java char 类型
date: 2022/06/16
updated: 2022/06/16
index_img: https://cdn.sxrekord.com/blog/java.png
banner_img: https://cdn.sxrekord.com/blog/java.png
categories: 
- 技术
tags:
- Java
---

Java 的 char 类型采用 UTF-16 编码。

提到 UTF-16 ，那就绕不开 [Unicode](https://home.unicode.org/) 字符集。
关于 Unicode 的相关知识在本文中不再进行赘述，毕竟本文的重点在于《Java 中的 char 类型》，还不了解的可以看看 [字符编码笔记：ASCII，Unicode 和 UTF-8](https://www.ruanyifeng.com/blog/2007/10/ascii_unicode_and_utf-8.html)

看了很多相关博客，谈到这个话题无一例外一般都会涉及到下面两个名词：
- 码点(Unicode code point)
- 代码单元(code unit)

## 码点
那么什么是码点呢？
**码点是指一个编码表中的某个字符所对应的代码值**。
顾名思义`Unicode code point`(~~即本文中的码点~~)指的就是 Unicode 编码集中的某个字符所对应的代码值。
由这个定义不难发现，一个字符串中有多少个字符就有多少个码点。
即 **CodePointCount = CharacterCount**

Unicode的码点分为17个代码级别，第一个级别是基本的多语言级别，码点从U+0000——U+FFFF，其余的16个级别从U+10000——U+10FFFF，其中包括一些辅助字符。
基本的多语言级别，每个字符用16位表示，而辅助字符采用连续的代码单元进行编码。

## 代码单元
接下来是代码单元。
代码单元的定义其实更简单。
代码单元即在具体编码形式中的最小单位，比如，使用 UTF-16 编码时一个代码单元为16位，使用 UTF-8 编码时一个代码单元为8位。

Java 中的 String 类的 length 方法 是以 代码单元 为单位计数，故一个字符串的 **length >= codePointCount**

## Code
```java

/**
 * This code is used to test the code point of the character.
 * @version 1.0 2022-06-16
 * @author Rekord
 */

// Code Point
// Code Unit
public class CodePoint {
    public static void main(String[] args) {
        String hello = "h𝕆i";
        System.out.println(hello.length());//4
        System.out.println(hello.codePointCount(0, hello.length()));//3
        System.out.println(hello.codePointBefore(4)); // 识别前一个码点

        for (int i = 0; i < hello.length(); i++) {
            char c = hello.charAt(i);
            System.out.println(c + ": " + Integer.toHexString(c));
        }
        System.out.println('\u997e' + " " + '\u6662');

        int codePointCount = hello.codePointCount(0, hello.length());
        for(int i = 0; i < codePointCount; i++) {
            int index = hello.offsetByCodePoints(0, i);
            int charAt = hello.codePointAt(index);
            System.out.println("index: " + index + "; HexValue: " + Integer.toHexString(charAt));
        }
        boolean isValid = Character.isValidCodePoint(0x997e);
        System.out.println(isValid);

        String str_en = "Hello, World!";
        String str_cn = "你好，世界！";

        System.out.println(str_cn.length()); // 6
        System.out.println(str_cn.codePointCount(0, str_cn.length())); // 6

//        char ch = '𝕆'; // 编译不通过
        char[] chars = Character.toChars(0x1d546);
        String str = new String(chars);
        System.out.println(str); // 𝕆
    }
}
```

## 分析
上述代码的13行和14行：

```java
System.out.println(hello.length());//4
System.out.println(hello.codePointCount(0, hello.length()));//3
```

输出为什么是4和3呢？
由于 `hello = "h𝕆i"` 包含3个字符，故码点数(codePointCount)为3。
由于 `𝕆` 字符不属于基本的多语言级别，从编码`0x1d546`就可见一斑（>2B），在底层该字符需要两个 utf-16 才能正确表示（即需要两个代码单元）。
而 length 的计数方式又是依据代码单元，故 length = 1 + 2 + 1 。

另外因为 Java 中的 char 都是 UTF-16 ，即占两个字节（一个代码单元）。所以
```java

char ch = '𝕆'; // '𝕆' 需要两个代码单元
```
是错误的。

后面的17~28行也验证了上述理论的合理性。

正因为上述种种，故40行的`Charater.toChars`方法返回的是一个 char 数组，而非单个 char 。
因为某些字符是无法使用一个代码单元（char）就能正确表示的。

## “不恰当”的插曲
在学习这些知识时，由于涉及到的内容相当基础，所以仅仅使用 vscode 作为编辑器，并且没有使用任何 Java 插件，均为手动编译运行。

然而在印证这些理论知识时出现了很多奇怪的问题。
最终问题定位于**手动编译时没有指定自定义参数**。

因为在和编码打交道，然而 javac 编译时默认编码又不为 utf-8 。（~~话说这年头不会有人源文件还不使用 UTF-8 编码吧？~~）
所以严重的时候（不严重的时候更加难以定位错误）就会报类似于 **“未结束的字符文字”** 这种错误。
解决方案倒是很简单:

```bash

javac -encoding UTF-8 xxx.java
java xxx
```

> 所以在这里还是建议大家在研究、测试和验证这个主题时尽量使用 IDE 。

## 参考链接
- [https://blog.csdn.net/diehuang3426/article/details/83422309](https://blog.csdn.net/diehuang3426/article/details/83422309)
