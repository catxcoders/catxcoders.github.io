---
layout: article_post
title:  "[Leetcode解題] Uncrossed Lines - DP + scrolling array解"
description:  "[Leetcode解題] Uncrossed Lines - DP + scrolling array解"
categories: medium
tags: dp scrolling-array
langs: python
excerpt_separator: <!--more-->
---

# 題目
[1035. Uncrossed Lines](https://leetcode.com/problems/uncrossed-lines/)
給定兩個整數列表 $nums1$ 和 $nums2$，我們將列表 $nums1$ 和 $nums2$ 中的整數（按照給定順序）分別寫在兩條水平線上。

我們可以繪製連接線：一條直線連接兩個數字 `nums1[i]` 和 `nums2[j]`，滿足以下條件：

<!--more-->

**`nums1[i] == nums2[j]`**
所繪製的連接線不會與其他連接線（非水平線）交叉。
注意，連接線甚至不能在端點交叉（即每個數字只能屬於一條連接線）。

返回我們可以以這種方式繪製的最大連接線數目。

# 解題思路
這個問題可以轉化為**最長公共子序列**（$Longest Common Subsequence$）的問題。我們可以將兩個列表視為兩個字符串，並找到它們的最長公共子序列的長度。

最長公共子序列（LCS）是指兩個序列中的最長的共同子序列（可以不連續）。在這個問題中，我們需要找到兩個列表中相等的元素並保持它們的相對順序，即找到它們的最長公共子序列。

## DP算法
我們可以使用**動態規劃**（$Dynamic Programming$）來解決這個問題。我們可以建立一個二維的動態規劃表 `dp`，其中 `dp[i][j]` 表示 nums1 前 `i` 個元素和 `nums2` 前 `j` 個元素的最長公共子序列長度。

我們可以根據以下規則填充動態規劃表：

1. 如果 `nums1[i] == nums2[j]`，則 `dp[i][j] = dp[i-1][j-1] + 1`，表示找到一個公共元素，並將最長公共子序列長度加 $1$。
2. 如果 `nums1[i] != nums2[j]`，則 `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`，表示在當前位置沒有公共元素，則最長公共子序列長度等於前一個位置的最長公共子序列長度。
3. 最後，`dp[nums1.length][nums2.length]` 就是所求的最大連接線數目。

## DP實作
```python
def maxUncrossedLines(self, nums1: List[int], nums2: List[int]) -> int:
    m, n = len(nums1), len(nums2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if nums1[i - 1] == nums2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

    return dp[m][n]
```
## 時間複雜度：
- **時間複雜度**: 填充動態規劃表需要雙重迴圈。外部迴圈遍歷 $m$ 個元素，內部迴圈遍歷 $n$ 個元素。因此，算法的時間複雜度為 $O(m * n)$。

- **空間複雜度**: 空間複雜度主要取決於動態規劃表 dp。我們使用了一個長度為 $n+1$ 寬度為 $m+1$的列表 dp 來保存中間結果，因此空間複雜度為 $O(n*m)$。

**當我們觀察到解決動態規劃問題時，只需要保留最近的幾個狀態，而不是整個矩陣，我們可以使用"滾動列表"（Scrolling Array）的方法來進一步優化空間複雜度。**

## 滾動列表（Scrolling Array）算法
我們可以使用**動態規劃**（$Dynamic Programming$）來解決這個問題。我們可以建立一個二維的動態規劃表 `dp`，其中 `dp[i][j]` 表示 nums1 前 `i` 個元素和 `nums2` 前 `j` 個元素的最長公共子序列長度。

我們可以根據以下規則填充動態規劃表：

1. 如果 `nums1[i] == nums2[j]`，則 `dp[i][j] = dp[i-1][j-1] + 1`，表示找到一個公共元素，並將最長公共子序列長度加 $1$。
2. 如果 `nums1[i] != nums2[j]`，則 `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`，表示在當前位置沒有公共元素，則最長公共子序列長度等於前一個位置的最長公共子序列長度。
3. 最後，`dp[nums1.length][nums2.length]` 就是所求的最大連接線數目。

## 滾動列表（Scrolling Array）實作
```python
def maxUncrossedLines(self, nums1: List[int], nums2: List[int]) -> int:
    m = len(nums1)
    n = len(nums2)
    if (m<n) :
        return self.maxUncrossedLines(nums2, nums1)
    dp = [0] * (n + 1)

    for i in range(1, m + 1):
        cr = 0
        for j in range(1, n + 1):
            pre = cr
            cr = dp[j]
            dp[j] = max(dp[j], dp[j - 1])
            if nums1[i - 1] == nums2[j - 1]:
                dp[j] = max(dp[j], pre + 1)

    return dp[n]
```
讓我們一步一步解釋這段程式碼：

1. 檢查列表(List)大小：在方法的開始處，我們檢查 nums1 和 nums2 的大小。如果 nums1 的大小小於 nums2，則調用方法自身，將較大的列表作為 nums1，較小的列表作為 nums2。這樣做是為了確保我們遍歷較小的列表，減少迴圈的次數，從而優化算法的性能。
2. 初始化動態規劃表：我們創建了一個長度為 $n+1$ 的列表 `dp`，並將其初始化為全零。這個列表用於保存中間結果。
3. 更新動態規劃表：
    - 我們使用兩個嵌套的 for 迴圈遍歷 `nums1` 和 `nums2`。在每次遍歷時，我們使用變量 `cr`和`pre` 來保存上一輪(dp做法的上一列(row))這一行(col)和前一行(col)的值，`pre`為dp做法的左上角的值，`cr`為dp做法的上方的值。
    - 更新動態規劃表：我們首先將 `cr` 更新為當前行的值，然後將 `dp[j]` 更新為 `dp[j]` 和 `dp[j-1]` 中的最大值。這是因為我們需要保留前一行的值作為參考，同時也需要根據當前行的情況進行更新。
    - 檢查相等的數字：如果 `nums1[i-1] = nums2[j-1]`，表示找到一個公共元素，我們將 `dp[j]` 更新為`pre`(dp做法的左上角的值)$+1$ 。

4. 返回結果：最後，我們返回 `dp[n]`，其中 n 是 `nums2` 的長度，表示最大連接線數目。


## 時間複雜度：
這個算法通過動態規劃的方式計算最大連接線數目，並使用滾動列表的技巧來優化空間使用。
- **時間複雜度**: 填充動態規劃表需要雙重迴圈。外部迴圈遍歷 $m$ 個元素，內部迴圈遍歷 $n$ 個元素。因此，算法的時間複雜度為 $O(m * n)$。

- **空間複雜度**: 空間複雜度主要取決於動態規劃表 dp。我們使用了一個長度為 $n+1$ 的列表 dp 來保存中間結果，因此空間複雜度為 $O(n)$。