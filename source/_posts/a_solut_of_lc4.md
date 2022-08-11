---
layout: post
title: leetcode-4-题解
date: 2022/7/11
updated: 2022/7/11
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

[原题链接](https://leetcode.cn/problems/median-of-two-sorted-arrays/)
## 题目大意
给定两个有序（正序）的整数数组，求出他们合并后的中位数。

## 题目要求
算法的时间复杂度应该为`O(log (m+n)) `。

## 题目标签
- 数组
- 二分查找

## 题目分析
### 算法初探
看完题目大意，第一时间联想到的就是合并两个数组然后求出中位数。
但这样做的话，时间复杂度大概为`O((m+n)/2)`，显然不符合题目要求。

从要求的时间复杂度和题目标签中的二分查找不难想到应使用二分。

那么如何二分呢？

设总长度 totalLen = nums1.length + nums2.length
如果 totalLen 是奇数，需要寻找一个数，反之需要寻找两个数。

设 mid = (totalLen + 1) / 2
不难得知，第一个中位数（如果是奇数，则是唯一一个中位数）为合并后的数组的第 mid 个数。

假设下面的`index`从1开始。
那么只要满足`nums1[index] >= nums2[mid-index] && nums1[index] <= nums2[mid-index+1]`，则 nums1[index] 为第一个中位数。
否则就需要根据具体情况左右移动 index 。

但是这样就行了吗？当然不行!
设想一种情况：
```plain
nums1 = [1, 5, 7]
nums2 = [2, 3, 4, 6, 8]
```

使用以上算法对这个给定的测试集进行模拟，不难发现最终算出的第一个中位数为5，但5显然是第二个中位数。

这还只是这个算法的第一个问题，还有涉及到求出第二个中位数的一系列问题。比如还需要考虑四数比较、临界判断等等。（涉及的逻辑判断复杂度甚至超过前一部分的算法）

---

那么如何优化呢？下面参考的是[halfrost](https://leetcode.cn/leetbook/read/leetcode-cookbook/5ltgev/)大佬的解法。

### 算法优化
因为是优化，所以大体思路是相同的，但不同的是这次明确涉及到四个 index 。
```plain
nums1Mid + nums2Mid = mid，所以一共有 mid+2 个元素，其中第 mid 个元素是第一个中位数
nums1:  ……………… nums1[nums1Mid-1] | nums1[nums1Mid] ……………………
nums2:  ……………… nums2[nums2Mid-1] | nums2[nums2Mid] ……………………
```

显然，只要满足`nums1[nums1Mid] >= nums2[nums2Mid-1] && nums2[nums2Mid] >= nums1[nums1Mid-1]`，则第一个中位数必定为`max(nums1[nums1Mid-1], nums2[nums2Mid-1])`，因为nums1[nums1Mid-1] 和 nums2[nums2Mid-1] 必定是第 mid 个数 或者第 mid-1 个数。

而求解第二个中位数的过程也变得十分简单了，就是`min(nums1[num1Mid], nums2[nums2Mid])`。

> 当用这种方式求解时，如果有临界值，直接排除即可。

当然，在二分查找过程中，index左右移动的条件和规则与上一个算法基本相同。

## 示例代码
```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        // 保证 len(nums1) <= len(nums2)
        if (nums1.length > nums2.length) {
            return findMedianSortedArrays(nums2, nums1);
        }

        int low = 0, high = nums1.length, mid = (nums1.length + nums2.length + 1)/2;
        int nums1Mid, nums2Mid;
        do {
            nums1Mid = low + ((high - low) >> 1);
            nums2Mid = mid - nums1Mid;
            // nums1Mid + nums2Mid = mid，所以一共有 mid+2 个元素，其中第 mid 个元素是第一个中位数
            // nums1:  ……………… nums1[nums1Mid-1] | nums1[nums1Mid] ……………………
            // nums2:  ……………… nums2[nums2Mid-1] | nums2[nums2Mid] ……………………
            // 需要向右移
            if (nums1Mid > 0 && nums1[nums1Mid-1] > nums2[nums2Mid]) {
                high = nums1Mid - 1;
                // 需要向左移
            } else if (nums1Mid < nums1.length && nums1[nums1Mid] < nums2[nums2Mid-1]) {
                low = nums1Mid + 1;
            } else {
                break;
            }
        } while (high >= low);

        double firstMedian;
        if (nums1Mid == 0) {
            firstMedian = nums2[nums2Mid-1];
        } else if (nums2Mid == 0) {
            firstMedian = nums1[nums1Mid-1];
        } else {
            firstMedian = Math.max(nums1[nums1Mid-1], nums2[nums2Mid-1]);
        }
        if ((nums1.length + nums2.length) % 2 == 1) {
            return firstMedian;
        }

        double secondMedian;
        if (nums1Mid == nums1.length) {
            secondMedian = nums2[nums2Mid];
        } else if (nums2Mid == nums2.length) {
            secondMedian = nums1[nums1Mid];
        } else {
            secondMedian = Math.min(nums1[nums1Mid], nums2[nums2Mid]);
        }
        return (firstMedian + secondMedian) / 2;
    }

}
```

## 效果截图
beats 100% Java code.

![leetcode-4-solution](/assets/4.jpg)