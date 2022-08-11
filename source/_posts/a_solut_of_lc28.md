---
layout: post
title: leetcode-28-题解 (KMP)
date: 2022/7/13
updated: 2022/7/13
cover: /assets/leetcode.webp
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- leetcode
- Java
---

KMP 算法于1977年被提出，全称 Knuth–Morris–Pratt 算法。让我们记住前辈们的名字：[Donald Knuth](https://en.wikipedia.org/wiki/Donald_Knuth)(K), [James H. Morris](https://en.wikipedia.org/wiki/James_H._Morris)(M), [Vaughan Pratt](https://en.wikipedia.org/wiki/Vaughan_Pratt)(P)。

KMP 算法是一个快速查找匹配串的算法。它解决的问题就是：
**如何快速在【原字符串】中找到【匹配字符串】**。

KMP 算法的复杂度为`O(m+n)`。

**KMP 之所以能够在`O(m+n)`复杂度内完成查找，是因为其能在【非完全匹配】的过程中提取到有效信息进行复用，以减少【重复匹配】的消耗。**

关于 KMP 算法的理解这里我推荐[字符串匹配的KMP算法](https://www.ruanyifeng.com/blog/2013/05/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm.html)

更详细的推导过程和代码实现可参考[【宫水三叶】简单题学 KMP 算法](https://leetcode.cn/problems/implement-strstr/solution/shua-chuan-lc-shuang-bai-po-su-jie-fa-km-tb86/)

[原题链接](https://leetcode.cn/problems/implement-strstr/)

代码示例：
```java
class Solution {
    // KMP 算法
    // ss: 原串(string)  pp: 匹配串(pattern)
    public int strStr(String ss, String pp) {
        if (pp.isEmpty()) return 0;

        // 分别读取原串和匹配串的长度
        int n = ss.length(), m = pp.length();
        // 原串和匹配串前面都加空格，使其下标从 1 开始
        ss = " " + ss;
        pp = " " + pp;

        char[] s = ss.toCharArray();
        char[] p = pp.toCharArray();

        // 构建 next 数组，数组长度为匹配串的长度（next 数组是和匹配串相关的）
        int[] next = new int[m + 1];
        for (int i = 2, j = 0; i < m; i++) {
            while (j > 0 && p[i] != p[j + 1]) {
                j = next[j];
            }
            if (p[i] == p[j + 1]) {
                j++;
            }
            next[i] = j;
        }
        
        for (int i = 1, j = 0; i <= n; i++) {
            while(j > 0 && s[i] != p[j + 1]) {
                j = next[j];
            }
            if (p[j + 1] == s[i]) {
                j++;
            }
            if (j == m) {
                return i - m;
            }
        }
        return -1;
    }
}
```