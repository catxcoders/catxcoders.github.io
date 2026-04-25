---
layout: article_post
title:  "[Leetcode解題] 3783. Mirror Distance of an Integer"
description:  "3783. Mirror Distance of an Integer"
categories: easy
tags: math
langs: python
excerpt_separator: <!--more-->
---

## 題目
[3783. Mirror Distance of an Integer](https://leetcode.com/problems/mirror-distance-of-an-integer/description/)

給定一個整數 `n`。請計算並回傳 `n` 的「鏡像距離」（Mirror Distance）。
「鏡像距離」定義為 `n` 與其反轉後的數字之間的絕對差值：
`Mirror Distance = |n - reverse(n)|`
其中 `reverse(n)` 是將 `n` 的十進制數字反轉所形成的新整數。

<!--more-->

## 解題思路

這是一道基礎的數學與數字操作題。題目要求我們算出原數字與反轉數字之間的絕對差值。

我們可以使用取餘數和除法來依序取得數字的每一個位數。
1. 使用 `while` 迴圈，每次取出 `n % 10` 得到最後一位數，並將其存入陣列 `digits` 中，然後更新 `n = n // 10`。
2. 因為我們是由後往前取位數，所以 `digits` 陣列中儲存的順序剛好就是反轉後的位數順序。
3. 接著，我們利用另一個迴圈遍歷 `digits`。將反轉後的各個位數依照對應的權重乘以 $10^{\text{len}-i-1}$，然後累加得到反轉後的新數字 `m`。
4. 最後，回傳原數字 `n_` 和反轉後的數字 `m` 的絕對差值 `abs(n_ - m)`。

## Python 實作

```python
class Solution:
    def mirrorDistance(self, n: int) -> int:
        digits = []
        n_ = n
        while n:
            digit = n % 10
            n = n // 10
            digits.append(digit)

        m = 0
        for i in range(len(digits)):
            m += digits[i] * pow(10, len(digits)-i-1)
        
        return abs(n_-m)
```

## 時間複雜度

- 取得每個位數的時間為 $O(d)$，其中 $d$ 是數字 `n` 的位數長度。
- 重新計算反轉後數字的時間也是 $O(d)$。
- 總時間複雜度為 $O(d)$。

空間複雜度部分，因為使用了一個 `digits` 陣列來存儲每個位數，所以空間複雜度為 $O(d)$。
