---
layout: article_post
title:  "[Leetcode解題]  2554. Maximum Number of Integers to Choose From a Range I"
description:  "2554. Maximum Number of Integers to Choose From a Range I"
categories: medium
tags: array greedy
langs: python
excerpt_separator: <!--more-->
---

# 題目

[2554. Maximum Number of Integers to Choose From a Range I](https://leetcode.com/problems/maximum-number-of-integers-to-choose-from-a-range-i/)

給定一個陣列`banned`，以及兩個正整數`n`以及`maxSum`，我們可以從1到n之間挑選盡可能多的正整數，除了`banned`裡面的正整數不能選以外，而這些被挑選的正整數和不能超過`maxSum`，問最多能挑選幾個數字。

<!--more-->

# 解題思路

這題我們想到使用`Greedy`的方法解，因為我們一定是要先從小的數字開始挑慢慢挑到大，才能在`maxSum`的限制中挑選到最多的數字。

另外我們要能很快的辨別數字是不是有被禁止，可以使用一個hashtable來存，如果該數字被禁止，就把該數字當作索引的值設為`False`。

而我們只要從1到n遍歷一次就能計算出答案。

# 程式碼

```python
class Solution:
    def maxCount(self, banned: List[int], n: int, maxSum: int) -> int:
        isBanned = [False] * (n+1)
        for b in banned:
            if b <= n:
                isBanned[b] = True
        curSum = 0
        curCnt = 0
        for i in range(1, n+1):
            if isBanned[i]:
                continue
            curSum += i
            if curSum > maxSum:
                return curCnt
            curCnt += 1
        return curCnt
```

# 時間複雜度

$O(n)$