---
layout: article_post
title:  "[Leetcode解題] 1716. Calculate Money in Leetcode Bank"
description:  "1716. Calculate Money in Leetcode Bank"
categories: easy
tags: math
langs: python
excerpt_separator: <!--more-->
---

## 題目

[1716. Calculate Money in Leetcode Bank](https://leetcode.com/problems/calculate-money-in-leetcode-bank/description/?envType=daily-question&envId=2025-10-25)

這個人每天都要存點錢，從禮拜一開始，第一個禮拜一存1元，隔天禮拜二會多存1元，並且從下個禮拜一開始，會多存1元，從2元開始

<!--more-->

## 解題思路

這題算簡單，我們可以有兩種做法，一種就是迴圈，一種就是我們其實可以用簡單的數學式子表示整個過程

## Python 實作

```python
class Solution:
    def totalMoney(self, n: int) -> int:
        total = 0
        for i in range(n // 7):
            total += (i+1+i+7) * 7 // 2
        
        s = n // 7
        total += (s+1+s+n%7) * (n%7) // 2
        return total

```


```python
class Solution:
    def totalMoney(self, n: int) -> int:
        daysum = [0,1,3,6,10,15,21,28]
        num_of_complete_weeks = n // 7
        num_of_remaining_days = n % 7
        
        offset = 7 * (num_of_complete_weeks-1) * num_of_complete_weeks // 2 + num_of_remaining_days * num_of_complete_weeks
        return num_of_complete_weeks * daysum[7] + daysum[num_of_remaining_days] + offset  
```

## 時間複雜度

用簡單的數學式子的話，時間複雜度為$O(1)$