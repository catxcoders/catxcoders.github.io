---
layout: article_post
title:  "[Leetcode解題] 978. Longest Turbulent Subarray"
description:  "978. Longest Turbulent Subarray"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

## 題目

[978. Longest Turbulent Subarray](https://leetcode.com/problems/longest-turbulent-subarray/description/)

給定一個整數陣列 arr，請找出其中最長的「湍流子陣列」(Turbulent Subarray) 的長度。

所謂的「湍流」，是指陣列中的數字大小變化必須呈現一高一低的鋸齒狀波動。簡單來說，相鄰數字之間的比較符號必須不斷翻轉（例如：先大於、再小於、再大於...）。

重點提示：

合法情況： 必須是 A > B < C > D 或 A < B > C < D 這種交替模式。

中斷情況： 如果出現連續遞增、連續遞減，或是兩個數字相等（A == B），則該段湍流序列中斷，必須重新計算。

<!--more-->

## 解題思路

這題的目標是尋找最長的「湍流」子陣列，所謂湍流是指陣列中相鄰元素的大小關係（上升或下降）必須交替出現（例如 $$A > B < C > D$$）。解題思路採用**一次遍歷（One Pass）**的貪婪策略來維護當前的連續長度。

程式碼中使用變數 `v` 記錄當前連續湍流子陣列的長度，`mv` 記錄全域最大長度，並使用 `sign` 變數來記錄前一次的比較狀態（例如設 `1` 為上升，`0` 為下降，`-1` 為初始或重置狀態）。

在遍歷陣列時，比較 `arr[i]` 與 `arr[i+1]` 的關係：
1.  **若當前為下降**（`arr[i] > arr[i+1]`）：檢查前一次狀態 `sign` 是否為上升（`1`）。若是，代表符合交替規則，當前長度 `v` 加 1；否則（前一次也是下降或是起點），則無法延續舊序列，將長度 `v` 重置為 2（包含當前這兩個元素），並更新 `sign` 為下降狀態。
2.  **若當前為上升**（`arr[i] < arr[i+1]`）：檢查前一次狀態 `sign` 是否為下降（`0`）。若是，則長度 `v` 加 1；否則，重置長度 `v` 為 2，並更新 `sign` 為上升狀態。
3.  **若兩者相等**：不符合湍流定義，序列中斷。將 `sign` 重置為 `-1`，當前長度 `v` 重置為 1。

## Python 實作

```python
class Solution:
    def maxTurbulenceSize(self, arr: List[int]) -> int:
        if not arr:
            return 0
        if len(arr) == 1:
            return 1

        mv = v = 1
        sign = -1
        for i in range(len(arr)-1):
            if arr[i] > arr[i+1]:
                if sign == 1:
                    v += 1
                else:
                    v = 2
                sign = 0
            elif arr[i] < arr[i+1]:
                if sign == 0:
                    v += 1
                else:
                    v = 2
                sign = 1
            else:
                sign = -1
                v = 1
            mv = max(v, mv)
```

## 時間複雜度

每次比較後都會更新最大值 `mv`。這種解法只需要對陣列進行一次掃描，時間複雜度為 $$O(N)$$，且僅使用常數個變數，空間複雜度為 $$O(1)$$。