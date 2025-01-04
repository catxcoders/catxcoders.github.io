---
layout: article_post
title:  "[Leetcode解題] 62. Unique Paths"
description:  "62. Unique Paths"
categories: medium
tags: dp 
langs: python
excerpt_separator: <!--more-->
---

## 題目
[62. Unique Paths](https://leetcode.com/problems/unique-paths/)
一個機器人位於 $m \times n$ 的網格的左上角（即 $\text{grid}[0][0]$）。機器人嘗試移動到網格的右下角（即 $\text{grid}[m - 1][n - 1]$）。在任意時刻，機器人只能向下或向右移動。

給定兩個整數 $m$ 和 $n$，返回機器人從左上角移動到右下角的所有**唯一路徑**的數量。

**約束條件**：  
測試數據保證答案小於等於 $2 \times 10^9$。
<!--more-->

## 解題思路

這是一道典型的動態規劃（Dynamic Programming）問題，也可以用數學組合的方法解決。以下分別介紹兩種解法：

### 方法一：動態規劃 (Dynamic Programming)
1. 定義一個 $dp$ 二維陣列，$dp[i][j]$ 表示從左上角移動到 $(i, j)$ 的唯一路徑數量。
2. 初始化：  
   - $dp[0][0] = 1$（起始位置）。
   - 第一列 $dp[i][0] = 1$，因為從 $(0, 0)$ 移到任意位置 $(i, 0)$ 都只能向下移動。
   - 第一行 $dp[0][j] = 1$，因為從 $(0, 0)$ 移到任意位置 $(0, j)$ 都只能向右移動。
3. 狀態轉移方程：  
   $dp[i][j] = dp[i-1][j] + dp[i][j-1]$  
   即到達 $(i, j)$ 的路徑數為從上方 $(i-1, j)$ 到達的路徑數加上從左側 $(i, j-1)$ 到達的路徑數。
4. 最終結果為 $dp[m-1][n-1]$。

### 方法二：數學組合
機器人從左上角移動到右下角，需要總共移動 $m-1$ 步向下，和 $n-1$ 步向右，共 $m+n-2$ 步。從這些步數中選出 $m-1$ 步向下或 $n-1$ 步向右的組合數為答案：
$\text{C}(m+n-2, m-1) = \frac{(m+n-2)!}{(m-1)!(n-1)!}$

這種方法利用排列組合公式，計算速度快且不需要額外空間。


## Python 實作

### 動態規劃解法
```python
class Solution:
    def uniquePaths(self, m: int, n: int) -> int:
        # 初始化 dp 陣列
        dp = [[1] * n for _ in range(m)]
        
        # 填充 dp 陣列
        for i in range(1, m):
            for j in range(1, n):
                dp[i][j] = dp[i - 1][j] + dp[i][j - 1]
        
        return dp[m - 1][n - 1]

```

### 數學組合解法
```python
class Solution:
    def uniquePaths(self, m: int, n: int) -> int:
        return math.comb(m + n - 2, m - 1)
```


## 時間與空間複雜度分析

### 動態規劃
- **時間複雜度**：$O(m \times n)$，需要填滿 $m \times n$ 的 dp 表格。
- **空間複雜度**：  
  - $O(m \times n)$，需要存儲 dp 表格。
  - 如果優化為一維陣列(使用滾動陣列)，空間複雜度可降為 $O(n)$。

### 數學組合
- **時間複雜度**：$O(\min(m, n))$，$(m−1)$ 和 $(n−1)$ 中較小的那一項，決定了需要計算多少步。
    - 組合數公式為：$C(m+n-2, m-1) = \frac{(m+n-2)!}{(m-1)! \cdot (n-1)!}$。計算這個公式時，實際上只需要計算部分階乘，而不需要完整地展開所有階乘。
    - 如果 $m≤n$, 計算為: $C(m+n-2, m-1) = \frac{(m+n-2) \cdot (m+n-3) \cdot \dots \cdot n}{(m-1)!}$
    - 如果 $n≤m$, 計算為: $C(m+n-2, n-1) = \frac{(m+n-2) \cdot (m+n-3) \cdot \dots \cdot m}{(n-1)!}$

- **空間複雜度**：$O(1)$，僅用常數空間。