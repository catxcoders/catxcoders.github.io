---
layout: article_post
title:  "[Leetcode解題] 368. Largest Divisible Subset"
description:  "368. Largest Divisible Subset"
categories: medium
tags: dp math
langs: python
excerpt_separator: <!--more-->
---

[368. Largest Divisible Subset](https://leetcode.com/problems/largest-divisible-subset/description/)

## 題目

給定一個distinct possitive integers set，要找出最大的`divisible subset`，定義為`subset`中的任意兩個整數必定存在`a % b == 0`或`b % a == 0`。

<!--more-->

## 解題思路

首先，當`a < b`時，`a % b != 0`必定存在，所以我們必須先做排序。

當我們有了 a_1 < a_2 < a_3 < a_4，我們可以使用dp來解，dp的值為該位置的divisible subset。

一開始每個位置初始化為包含自己的list，因為每個divisible subset至少都能包含自己。

對於任何一個數，可以看過前面所有的數字，如果可以整除，我就考慮加入它（以及他目前有的divisible subset），不行整除就跳過。

舉例來說，當前位置在a_4，如果a_2可以整除，那我考慮`dp[a_4]`跟`dp[a_2]+1`，如果更新後divisible subset更大那就更新dp。

## 程式碼

```python
class Solution:
    def largestDivisibleSubset(self, nums: List[int]) -> List[int]:
        nums = sorted(nums)
        dp = [[num] for num in nums]

        for i in range(len(nums)):
            for j in range(i):
                if nums[i] % nums[j] == 0 and len(dp[j]) + 1 > len(dp[i]):
                    dp[i] = dp[j] + [nums[i]]

        return max(dp, key=len)

```

## 時間複雜度

$O(n^2)$