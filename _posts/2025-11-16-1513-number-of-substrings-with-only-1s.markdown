---
layout: article_post
title:  "[Leetcode解題] 1513. Number of Substrings With Only 1s"
description:  "1513. Number of Substrings With Only 1s"
categories: medium
tags: math
langs: python
excerpt_separator: <!--more-->
---

## 題目

[1513. Number of Substrings With Only 1s](https://leetcode.com/problems/number-of-substrings-with-only-1s/description/?envType=daily-question&envId=2025-11-16)

給一個binary字串，求有幾個全為1的子字串(substring)，結果要求`10^9 + 7`的餘數

<!--more-->

## 解題思路

這題算簡單，我們發現，其實對於長度為n的1字串，他總共會有`(1+n) * n / 2`個1的子字串

## Python 實作

```python
class Solution:
    def numSub(self, s: str) -> int:
        LARGE_CONSTANT = int(1e9) + 7
        subs = s.split('0')
        ans = 0
        for sub in subs:
            ans += (1 + len(sub)) * len(sub) // 2
        return ans % LARGE_CONSTANT
```

## 時間複雜度

用簡單的數學式子的話，時間複雜度為$O(n)$