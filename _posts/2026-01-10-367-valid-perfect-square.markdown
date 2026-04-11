---
layout: article_post
title:  "[Leetcode解題] 367. Valid Perfect Square"
description:  "367. Valid Perfect Square - 使用Binary Search解"
categories: medium
tags: binary_search, bs
langs: python
excerpt_separator: <!--more-->
---

# 911. Online Election

## 題目
[367. Valid Perfect Square](https://leetcode.com/problems/valid-perfect-square/description/?envType=problem-list-v2&envId=binary-search)

這題給一個正數字，要判斷是不是平方數

<!--more-->

## 解題思路

這題我們就使用binary search找看有沒有相乘後剛好等於目標值的數字，有一個點是，因為有可能相乘後會超出int的範圍，如果用python的話沒有差別，但c++可能需要注意型別，使用long之類的來存。

又或者可以用除的方式來比較，當餘數等於0，且`num//mid==mid`的時候就`return True`。

## Python 實作

```python
class Solution:
    def isPerfectSquare(self, num: int) -> bool:

        if num == 1:
            return True

        lb = 1
        ub = num // 2 + 1

        while lb < ub:
            mid = (lb+ub) // 2

            value = num // mid
            remainder = num % mid

            if value == mid and remainder == 0:
                return True
            elif value > mid or (value == mid and remainder > 0):
                lb = mid + 1
            else:
                ub = mid
        return False
```

## 時間複雜度

$O(logn)$