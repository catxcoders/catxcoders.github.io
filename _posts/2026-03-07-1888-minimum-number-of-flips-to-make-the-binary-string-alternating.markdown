---
layout: article_post
title:  "[Leetcode解題] 1888. Minimum Number of Flips to Make the Binary String Alternating"
description:  "1888. Minimum Number of Flips to Make the Binary String Alternating "
categories: medium
tags: sliding_window
langs: python
excerpt_separator: <!--more-->
---

<!--more-->

# 1888. Minimum Number of Flips to Make the Binary String Alternating

## 題目
[1888. Minimum Number of Flips to Make the Binary String Alternating](https://leetcode.com/problems/minimum-number-of-flips-to-make-the-binary-string-alternating/description/)

## 解題思路

這題我們可以使用slideing window來解，在長度為偶數為狀況，其實只有兩種狀況`010101..`跟`1010101..`，不需要考慮`Type-1`的狀況，所以就可以直接算`Type-2`的數量即可。

但是如果是長度為奇數的情況，`Type-1`的使用會大大影響`Type-2`可能的數目，所以我們想考慮使用不同的`Type-1`算出來的`Type-2`的數目，並且取最小值。

這可以透過複製一次字串，再作sliding window即可。

## Python 實作

```python
class Solution:
    def minFlips(self, s: str) -> int:
        n = len(s)

        if n % 2 == 1:
            s = s + s
        alt1, alt2 = "", ""

        for i in range(len(s)):
            alt1 += "0" if i % 2 == 0 else "1"
            alt2 += "1" if i % 2 == 0 else "0"
        
        res = len(s)
        diff1, diff2 = 0, 0
        l = 0
        for r in range(len(s)):
            if s[r] != alt1[r]:
                diff1 += 1
            if s[r] != alt2[r]:
                diff2 += 1
            
            # 當窗口大小超過 n，左端縮小
            if (r - l + 1) > n:
                if s[l] != alt1[l]:
                    diff1 -= 1
                if s[l] != alt2[l]:
                    diff2 -= 1
                l += 1
            
            # 當窗口剛好為 n，紀錄最小值
            if (r - l + 1) == n:
                res = min(res, diff1, diff2)
                
        return res
 ```

## 時間複雜度

$O(n)$