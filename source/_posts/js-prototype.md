---
title: JavaScript 中的原型与原型链
date: 2023/02/01
updated: 2023/02/01
index_img: https://cdn.sxrekord.com/blog/js.png
banner_img: https://cdn.sxrekord.com/blog/js.png
categories: 
- 技术
tags:
- JavaScript
---

## 前置代码

```javascript
function Foo() {

}
```

## 原型
每个函数对象都有一个`prototype`属性, 它默认指向一个Object实例对象(这个对象也被称为: 原型对象)。

```javascript
console.log(typeof Foo.prototype); // object
```

普通的实例对象没有`prototype`属性，只有`__proto__`属性。而函数对象既有`prototype`属性，又有`__proto__`属性。（*具体原因见后文*）。
所以通过下面的代码可知原型对象为实例对象。

```javascript
console.log(Foo.prototype.prototype); // undefined
console.log(Foo.prototype.__proto__)
```

在读取对象的属性或方法时，会自动到原型中查找，所以我们常常将方法放入原型对象当中。（*属性应当由实例对象自身保存维护*）
```javascript
Foo.prototype.a = 123;
Foo.prototype.f = function() {
    console.log("print function f");
}
let foo = new Foo();
// 在原型对象中查找属性与方法
console.log(foo.a); // 123
foo.f(); // print function f
```

默认情况下，原型对象中有一个constructor属性，它指向函数对象本身。

```javascript
console.log(Foo.prototype.constructor);
console.log(Foo.prototype.constructor === Foo); // true
console.log(Foo.prototype.__proto__.constructor === Object) // true
```

`prototype`属性所指向的对象常常被称为显式原型，而`__proto__`属性所指向的对象常常被称为隐式原型。
实例对象的隐式原型与对应的函数对象的显式原型指向的对象相同。

```javascript
console.log(Foo.prototype === new Foo().__proto__) // true
```

Object函数对象的显式原型是原型链的尽头（*其类型为object*），因为Object函数对象的显式原型的隐式原型属性值为null。

```javascript
console.log(typeof Object.prototype); // 'object'
console.log(Object.prototype.__proto__); // null
```

所有函数对象的隐式原型所指向的对象均相同，因为`function fun_name() {}` <=> `fun_name = new Function();` <=> `fun_name = function() {}`，即所有函数对象的隐式原型等于`Function`对象的显式原型。

```javascript
function FA() {
    console.log("FA");
}

let FB = function() {
    console.log("FB");
}

console.log(FA.__proto__ === FB.__proto__); // true
console.log(FA.__proto__ === Function.prototype); // true
console.log(FA.__proto__.constructor === FB.__proto__.constructor) // true
console.log(FA.__proto__.constructor === Function) // true
```

由于`Function = new Function()`，故Function的显式原型对象与隐式原型对象相同，类型为function（**使用typeof求值的结果为function，但实际上是Object实例对象，因为其隐式原型等于Object函数对象的显式原型**）。
另外，该原型对象为实例对象，因为没有显式原型。

```javascript
console.log(Function.__proto__ === Function.prototype); // true
console.log(typeof Function.prototype); // 'function'
console.log(Function.prototype.__proto__ === Object.prototype);

console.log(Function.prototype.prototype); // undefined
console.log(typeof Function.prototype.__proto__); // 'object'
console.log(Function.prototype.__proto__.__proto__); // null
```

函数的显式原型指向的对象默认是仅带有`constructor`属性的Object实例对象(但`Object`和`Function`不满足，`Object.prototype`还有很多方法，而`Function.prototype`类型为function)。（*关于Function是否是一个例外，请根据上文结合自己的理解，因为Function的显式对象本质上确实属于Object实例对象*）

```javascript
console.log(typeof Foo.prototype); // 'object'
console.log(typeof Object.prototype); // 'object'
console.log(typeof Function.prototype === 'function'); // true
```

## 原型链

* 访问一个对象的属性/方法时：
    * 先在自身属性中查找，找到返回
    * 如果没有，再沿着__proto__这条链向上查找，找到返回
    * 如果最终没找到，返回undefined
* 别名: 隐式原型链
* 作用: 查找对象的属性(方法)

### 读取/设置属性
1. 读取对象的属性值时: 会自动到原型链中查找
2. 设置对象的属性值时: 不会查找原型链, 如果当前对象中没有此属性, 直接添加此属性并设置其值

## 总结
相信有了上面的基础，下面的图示应该一目了然了。
![prototype](https://cdn.sxrekord.com/blog/prototype.png)

## `instanceof`
instanceof是如何判断的？
  * 表达式：A instanceof B
  * 如果B函数的显式原型对象在A对象的原型链上，返回true，否则返回false。

> **C.prototype instanceof C // false**

```javascript
console.log(Foo.prototype instanceof Object); // true
console.log(Object.prototype instanceof Object); // false
console.log(Function.prototype instanceof Object); // true
```

## 检验
如果对于下面的各个结果没有任何疑惑，那么恭喜你！应该就算是基本掌握了上面所述内容。

```javascript
// 案例1
function Foo() {}
let f1 = new Foo();
console.log(f1 instanceof Foo); // true
console.log(f1 instanceof Object); // true

// 案例2
console.log(Object instanceof Function); // true
console.log(Object instanceof Object); // true
console.log(Function instanceof Function); // true
console.log(Function instanceof Object); // true
```
