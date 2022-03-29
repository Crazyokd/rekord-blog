---
layout: post
title: leetcode-31-题解
date: 2022/3/29
updated: 2022/3/29
cover: /assets/leetcode.jpg
# coverWidth: 920
# coverHeight: 613
comments: true
categories: 
- 技术
tags:
- leetcode
- C++
---

首先放一个题目链接——[Next Permutation](https://leetcode-cn.com/problems/next-permutation/)

## 题目要求
给定一个整数数组，求出 **下一个排列** 。

## 题意分析
在此之前，容我先在这里解释一下该题所谓的字典序：

该题进行的无非就是两个数列的字典序比较：

将两个数列从左至右一项一项【即数组元素】进行比较。

- 若元素数值不相等，则较大的那个数值元素所对应的数组字典序更大。
- 若元素数值相等，则继续向右进行比较。

那什么是下一个排列呢？我的理解如下：
- 当前排列的下一个更大的字典序
- 若当前排列已经是最大字典序，那下一个排列就是最小字典序
- 所以答案可以在**一段数列所对应的字典序闭环**中找到

## 算法分析
从上述理论不难分析出最小字典序应当是一个升序数组，最大字典序应当是一个降序数组。

总体来说，下一个排列有从升序到降序的趋势【特殊临界点除外】

另外，由于是紧邻的下一个字典序，所以从升序到降序应该是从右到左。

也就是说，下一个排列总是“优先影响右边，而尽量不“惊动”左边”。

另外，当找到 **交换点** 之后，应该挑选一个比交换点大的但又是相对最小的进行交换。

最后，不要忘了将交换点之后的数列进行升序排列。

> 因为交换了之后可以保证字典序一定大于交换之前的字典序，而将交换点之后的数列进行升序排列可以保证是 “下一个排列”。

## 算法步骤
1. 从后向前查找第一个相邻升序的元素对 (i,j)，满足 A[i] < A[j]。此时 [j,end) 必然是降序
2. 在 [j,end) 从后向前查找第一个满足 A[i] < A[k] 的 k。将 A[i] 与 A[k] 交换。【此时k必然比i大但又是相对最小的】
3. 可以断定这时 [j,end) 必然是降序，逆置 [j,end)，使其升序
4. 如果在步骤 1 找不到符合的相邻元素对，说明当前 [begin,end) 为一个降序顺序，则直接跳到步骤 3

## 代码展示
```c++
class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        int swapPoint = -1;
        for (int i = nums.size()-1; i > 0; i--){
            if (nums[i] > nums[i-1]) {
                swapPoint = i-1;
                break;
            }
        }
        if (swapPoint >= 0) {
            for (int i = nums.size()-1; i > swapPoint; i--) {
                if (nums[i] > nums[swapPoint]) {
                    int t = nums[i];
                    nums[i] = nums[swapPoint];
                    nums[swapPoint] = t;
                    break;
                }
            }
        }
        sort(nums.begin()+swapPoint+1, nums.end());
        
    }
};
```

## 参考链接
[https://leetcode-cn.com/problems/next-permutation/solution/xia-yi-ge-pai-lie-suan-fa-xiang-jie-si-lu-tui-dao-/](https://leetcode-cn.com/problems/next-permutation/solution/xia-yi-ge-pai-lie-suan-fa-xiang-jie-si-lu-tui-dao-/)