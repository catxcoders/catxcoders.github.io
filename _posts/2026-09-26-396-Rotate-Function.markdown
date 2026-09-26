---
layout: article_post
title:  "[Leetcode解題] 396. Rotate Function"
description:  "396. Rotate Function - 旋轉函數的最大值，利用狀態轉移數學推導將時間複雜度優化至 O(n)"
categories: medium
tags: array math sliding-window
langs: python
excerpt_separator: <!--more-->
---

# 396. Rotate Function

## 題目

[396. Rotate Function](https://leetcode.com/problems/rotate-function/)

給定一個長度為 $n$ 的整數陣列 `nums`。

假設 $arr_k$ 是將 `nums` 順時針旋轉 $k$ 個位置後得到的陣列。

定義旋轉函數 $F(k)$ 為：

$$F(k) = 0 \times arr_k[0] + 1 \times arr_k[1] + \dots + (n - 1) \times arr_k[n - 1]$$

請回傳 $F(0), F(1), \dots, F(n - 1)$ 中的最大值。

<!--more-->

## 解題思路

### 暴力法（Brute Force）
若對於每個 $k \in [0, n-1]$ 都直接計算 $F(k)$，每次計算需要 $O(n)$ 時間，總共旋轉 $n$ 次，整體時間複雜度為 $O(n^2)$。對於 $n \le 10^5$ 的數據範圍會導致 Timeout。

### 狀態轉移與數學推導 $O(n)$

我們可以觀察 $F(k)$ 與 $F(k-1)$ 之間的關係。
設 $S = \sum_{i=0}^{n-1} \text{nums}[i]$，陣列長度為 $n$。

- $F(0) = 0 \cdot \text{nums}[0] + 1 \cdot \text{nums}[1] + 2 \cdot \text{nums}[2] + \dots + (n-1) \cdot \text{nums}[n-1]$
- 當陣列順時針旋轉 1 次時，原先最後一個元素 $\text{nums}[n-1]$ 移動到最前面（索引 0，權重變成 0），其餘每個元素的索引均增加 1（權重加 1）：
  $F(1) = 0 \cdot \text{nums}[n-1] + 1 \cdot \text{nums}[0] + 2 \cdot \text{nums}[1] + \dots + (n-1) \cdot \text{nums}[n-2]$

將 $F(1) - F(0)$ 展開：
$$
\begin{aligned}
F(1) - F(0) &= (\text{nums}[0] + \text{nums}[1] + \dots + \text{nums}[n-2]) - (n-1) \cdot \text{nums}[n-1] \\
&= (\text{nums}[0] + \text{nums}[1] + \dots + \text{nums}[n-1]) - n \cdot \text{nums}[n-1] \\
&= S - n \cdot \text{nums}[n-1]
\end{aligned}
$$

推廣至第 $i$ 次旋轉（其中 $i \ge 1$）：
$$F(i) = F(i-1) + S - n \cdot \text{nums}[n-i]$$

因此，我們只需要：
1. 計算陣列總和 $S = \text{sum(nums)}$ 以及初始旋轉函數值 $F(0)$（即程式碼中的 `value`）。
2. 進行 $n-1$ 次疊代，每次利用公式 $F(i) = F(i-1) + S - n \cdot \text{nums}[n-i]$ 在 $O(1)$ 時間內更新當前值。
3. 過程中維持最大值 `max_` 即為解答。

---

## Python 實作

```python
class Solution:
    def maxRotateFunction(self, nums: list[int]) -> int:
        sum_ = sum(nums)

        value = 0
        for i in range(len(nums)):
            value += nums[i] * i
        max_ = value

        for i in range(len(nums)-1):
            value_ = value + sum_ - nums[-1 - i] * len(nums)
            max_ = max(max_, value_)
            value = value_
        return max_
```

---

## 複雜度分析

- **時間複雜度**：$O(n)$
  求和與計算 $F(0)$ 各需 $O(n)$，後續迴圈執行 $n-1$ 次，每次運算為 $O(1)$。總時間複雜度為 $O(n)$。
- **空間複雜度**：$O(1)$
  僅使用常數級輔助變數（`sum_`, `value`, `max_`, `value_`）。
