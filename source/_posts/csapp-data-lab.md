---
layout: post
title: csapp：data-lab
date: 2022/4/10
updated: 2022/4/10
cover: /assets/csapp.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- csapp
---

## bitXor
题目要求仅使用`~`和`&`实现异或功能。
不难发现 `(~x & y)` 和 `(x & ~y)`对相同位的针对意味都十分明显，因为只要对应位相同，上面两个式子结果必定为0。从而题目得解。
```C++
//1
/*
 * bitXor - x^y using only ~ and &
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
    /*  */
    return ~(~(~x & y) & ~(x & ~y));
}
```

## tmin
由于可以使用左移，故十分简单，不再赘述。
```C++
/*
 * tmin - return minimum two's complement integer
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
    return 1 << 31;
}
```

## isTmax
不能使用左移，也不能使用大常数，所以想通过构造一个 Tmax 然后再异或取非就行不通了。
这个时候可以把目光聚焦在参数本身。不难发现，如果 x 为 Tmax，将 x+1 将会导致溢出，实际表现就是 Tmax+1 = Tmin，而 Tmin 的特点就是正负的位级表现相同。所以题目就迎刃而解了。
> **另外还要注意 0 的正负位级表现也相同！**
```C++
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {
    return !(!(x + 1)) & !((x + 1) ^ (~(x+1)+1));
}
```

## allOddBits
假设 x 为 allOddBits，不难肯定 ```0x55555555 | x```必定为全一，题目得解。

```C++
/*
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
    int cons = 0x55;
    int comp = 0x55;
    comp = (comp << 8) + cons;
    comp = (comp << 8) + cons;
    comp = (comp << 8) + cons;
    return !(~(comp | x));
}
```
## negate
基操了属于是。
```C++
/*
 * negate - return -x
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {
    return ~x + 1;
}
```

## isAsciiDigit
下面的注释写的很清楚了。
这里主要再说一下，可以使用加一个数判断某一个数是否大于另一个数。
```C++
//3
/*
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
    int low_8 = 0xFF & x;             // 取出低八位
    int exclude_30 = ((low_8 & 0xF0) ^ 0x30);      // 排除第四位到第八位不等于0011的
    int exclude_g39 = ((low_8 + 6) & 0xF0) ^ 0x30;  // 排除低四位大于9的
    return !((x ^ (low_8)) | exclude_30 | exclude_g39);
}
```

## conditional
可以结合 `!(x ^ 0)`轻易判断出 x 是否为0，从而构造出 t。
另外 t 要保证要么全0；要么全1，从而使得 x 和 y 中的一个保持不变，一个置0。
```C++
/*
 * conditional - same as x ? y : z
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
    int t = ((!(x ^ 0)) << 31) >> 31;
    return (t & z) + (~t & y);
}
```

## isLessOrEqual
这题我采用的是分情况讨论。
注意这题不能直接一个减法解决，因为**减法结果可能溢出**。
另外还要注意**一个负数转化为对应的正数也可能发生溢出**。
```C++
/*
 * isLessOrEqual - if x <= y  then return 1, else return 0
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
    /* y-x >= 0 */
    int sign_x = ((x >> 31) & 1);
    int sign_y = ((y >> 31) & 1);

    return (!(x ^ (1 << 31)) | (~(((sign_x ^ sign_y) << 31) >> 31) & !((y + (~x + 1)) >> 31) & 1)) | ((sign_x ^ 0) & (sign_y ^ 1));
}
```

## logicalNeg
如果 x 为0，满足正负一致。
另外注意区分Tmin。
```C++
//4
/*
 * logicalNeg - implement the ! operator, using all of
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4
 */
int logicalNeg(int x) {
    return ~((x >> 31) | ((~x + 1) >> 31)) & 1;
}
```
## howManyBits
这一题折腾了很久，最终也只想出一种不符合题目要求的解法【_注释的前几行_】
最后在大佬[jax](https://jaxvanyang.github.io/)的帮助下，才得出下面的题解。
以下代码来源其本人解法，但我对其正负区分部分进行了优化，也可以说是教学相长了。
大体思路就是先将最高位1前面的所有低位通过 移位+或 全置0，然后统计1的数量即可。
```C++
/* howManyBits - return the minimum number of bits required to represent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
    // // 如果x为负数，则将x取反
    // x ^= (x >> 31);
    // int cnt = 0;
    // int flag = 0;
    // for (int i = 31; i >= 0; i--) {
    //     flag += ((x >> i) & 1);
    //     cnt += !flag;
    // }
    // return 34+~(cnt);

    // fill = x < 0 ? ~x : x;
    unsigned fill = x ^ (x >> 31);
    fill = (fill >> 1) | fill;
    fill = (fill >> 2) | fill;
    fill = (fill >> 4) | fill;
    fill = (fill >> 8) | fill;
    fill = (fill >> 16) | fill;

    // add up all bits

    // mask_16 = 0101...
    unsigned mask_16 = 0x55;
    mask_16 = (mask_16 << 8) | mask_16;
    mask_16 = (mask_16 << 16) | mask_16;
    unsigned a_16 = fill & mask_16;
    unsigned b_16 = (fill & ~mask_16) >> 1;
    unsigned sum = a_16 + b_16;

    // mask_8 = 0011...
    unsigned mask_8 = 0x33;
    mask_8 = (mask_8 << 8) | mask_8;
    mask_8 = (mask_8 << 16) | mask_8;
    unsigned a_8 = sum & mask_8;
    unsigned b_8 = (sum & ~mask_8) >> 2;
    sum = a_8 + b_8;

    // mask_4 = 00001111...
    unsigned mask_4 = 0x0F;
    mask_4 = (mask_4 << 8) | mask_4;
    mask_4 = (mask_4 << 16) | mask_4;
    unsigned a_4 = sum & mask_4;
    unsigned b_4 = (sum & ~mask_4) >> 4;
    sum = a_4 + b_4;

    // mask_2 = 0x00FF00FF
    unsigned mask_2 = 0xFF;
    mask_2 = (mask_2 << 16) | mask_2;
    unsigned a_2 = sum & mask_2;
    unsigned b_2 = (sum & ~mask_2) >> 8;
    sum = a_2 + b_2;

    // mask_1 should be 0x0000FFFF, but sum won't be greater than 16
    unsigned mask_1 = 0xFF;
    unsigned a_1 = sum & mask_1;
    unsigned b_1 = (sum & ~mask_1) >> 16;
    sum = a_1 + b_1;

    return sum + 1;
}
```
## floatScale2
首先按三部分分离所有数位。
然后分情况讨论。
> 通过本例题，你也能明显发现非规格化数字设计的是多么精妙。
```C++
//float
/*
 * floatScale2 - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatScale2(unsigned uf) {
    unsigned s = (uf >> 31) & 1;   // 取出符号
    unsigned e = (uf >> 23) & 0xFF;  // 取出阶码
    unsigned m = (uf << 9) >> 9;  // 取出小数
    if (e == 0xFF)      // NaN or 无穷大
        return uf;
    if (e == 0) {       // 非规格化数
        m <<= 1;        // 非规格化数平滑过渡
    } else {
        e += 1;
    }
    return (((s << 8) + e) << 23) + m;
}
```

## floatFloat2Int
这题也是按照 IEEE 的设计特点来分情况讨论。
请特别注意如果发生溢出结果都是 Tmin，不用考虑正负因素。
```C++
/*
 * floatFloat2Int - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
int floatFloat2Int(unsigned uf) {
    unsigned s = (uf >> 31) & 1;   // 取出符号
    unsigned e = (uf >> 23) & 0xFF;  // 取出阶码
    unsigned m = (1 << 23) + ((uf << 9) >> 9);  // 取出小数

    if (e == 0xFF) {
        return 1 << 31;
    }
    if (e >= 127) {
        if (e <= 127+23) {
            m >>= (23-e+127);
        } else {
            if (e-127-23 >= 8) {    //溢出
                return 1 << 31;
            }
            m <<= e-150;
        }
        if (s == 1) return ~m + 1;
        else return m;
    } else {
        return 0;
    }
}
```

## floatPower2
由于 IEEE 设计浮点数的特点就是基于`x*2^y`。所以这题非常简单。
另外别忘了按照题目要求处理 too small 和 too large。
```C++
/*
 * floatPower2 - Return bit-level equivalent of the expression 2.0^x
 *   (2.0 raised to the power x) for any 32-bit integer x.
 *
 *   The unsigned value that is returned should have the identical bit
 *   representation as the single-precision floating-point number 2.0^x.
 *   If the result is too small to be represented as a denorm, return
 *   0. If too large, return +INF.
 *
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. Also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatPower2(int x) {
    if (x > 127){   // too large
        return (0xFF << 23);
    } else if (x < -126) {  // too small
        return 0;
    } else {
        return ((127+x) << 23);
    }
}%
```
