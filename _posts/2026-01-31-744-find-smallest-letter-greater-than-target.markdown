---
layout: article_post
title:  "[Leetcode解題] 744. Find Smallest Letter Greater Than Target"
description:  "744. Find Smallest Letter Greater Than Target - 使用Binary Search解"
categories: easy
tags: binary_search, bs
langs: python
excerpt_separator: <!--more-->
---

# 911. Online Election

## 題目
[744. Find Smallest Letter Greater Than Target](https://leetcode.com/problems/find-smallest-letter-greater-than-target/description/)

給定一個字元序列跟一個目標字元，回傳在序列中第一個比目標字元大的字元，如果沒有的話就回傳第一個字元

<!--more-->

## 解題思路

這題就是考二分搜尋法，我們找第一個比目標值大的值，也可以用`bisect.bisect_right`來解

## Python 實作

```python
class Solution:
    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
                
        lower = 0
        upper = len(letters)
        while lower < upper:
            mid = (lower + upper) // 2

            if letters[mid] <= target:
                lower = mid + 1
            elif letters[mid] > target:
                upper = mid
        if upper == len(letters):
            return letters[0]
        return letters[lower]```

## 時間複雜度

$O(logn)$