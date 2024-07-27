---
layout: article_post
title:  "[Leetcode解題] 1143. Longest Common Subsequence - 使用 Rolling DP 指針解"
description:  "[Leetcode解題] 1143. Longest Common Subsequence - 使用 Rolling DP 指針解"
categories: medium
tags: array two-pointers
langs: python
excerpt_separator: <!--more-->
---

## 題目
[1143. Longest Common Subsequence](https://leetcode.com/problems/longest-common-subsequence/)
給定兩個字串 `text1` 和 `text2`，返回它們的最長共同子序列的長度。如果沒有共同的子序列，返回 0。
<!--more-->

## 解題思路 - DP

這題的目的是找出兩個字串的最長共同子序列。我們可以使用動態規劃來解決這個問題。

具體步驟如下：
1. 建立一個二維的 DP 陣列，其中 `dp[i][j]` 表示 `text1` 的前 `i` 個字符和 `text2` 的前 `j` 個字符的最長共同子序列的長度。
2. 初始化邊界條件，即當 `i` 或 `j` 為 0 時，`dp[i][j]` 應該為 0，因為一個字串和空字串的最長共同子序列長度為 0。
3. 遍歷 `text1` 和 `text2`，如果 `text1[i-1]` 等於 `text2[j-1]`，則 `dp[i][j] = dp[i-1][j-1] + 1`，否則 `dp[i][j] = max(dp[i-1][j], dp[i][j-1])`。
4. 最後，`dp[m][n]` 即為最長共同子序列的長度，其中 `m` 和 `n` 分別是 `text1` 和 `text2` 的長度。

## 範例

假設有兩個字串：
- `text1 = "abcde"`
- `text2 = "ace"`

####  1. 建立一個 2D DP 陣列，初始化為 0

|     |     | a   | c   | e   |
| --- | --- | --- | --- | --- |
|     | 0   | 0   | 0   | 0   |
| a   | 0   | 0   | 0   | 0   |
| b   | 0   | 0   | 0   | 0   |
| c   | 0   | 0   | 0   | 0   |
| d   | 0   | 0   | 0   | 0   |
| e   | 0   | 0   | 0   | 0   |

####  2. 逐步填充 DP 陣列

|   |   | a | c | e |
|---|---|---|---|---|
|   | 0 | 0 | 0 | 0 |
| a | 0 | 1 | 1 | 1 |
| b | 0 | 1 | 1 | 1 |
| c | 0 | 1 | 2 | 2 |
| d | 0 | 1 | 2 | 2 |
| e | 0 | 1 | 2 | 3 |

- 當 `text1[i-1]` 等於 `text2[j-1]`，代表當前字符是共同字符，`dp[i-1][j-1]` 是不包括這個共同字符之前的 LCS 長度，因此`dp[i][j]` 是 `dp[i-1][j-1]` 加 1*
    - e.g. `"ac"`與`"abcd"`的LCS是2，如果兩個字串都加上`'e'`， *`"ace"`與`"abcde"`的LCS* 是 *`"ac"`與`"abcd"`的LCS*加1
- 否則，`dp[i][j] = max(dp[i-1][j], dp[i][j-1])`
    - 這表示當 `text1[i-1]` 不等於 `text2[j-1]` 時，LCS 的長度不會增加。
    - 我們需要在兩個選擇中取最大的 LCS 長度：`dp[i-1][j]` 或 `dp[i][j-1]`。
        - `dp[i-1][j]` 是忽略 `text1[i-1]`，只考慮 `text1` 的前 $i-1$ 個字符和 `text2` 的前 $j$ 個字符的 LCS。
        - `dp[i][j-1]` 是忽略 `text2[j-1]`，只考慮 `text1` 的前 $i$ 個字符和 `text2` 的前 $j-1$ 個字符的 LCS。

#### 3. 輸出結果

最後 DP 陣列中的右下角 `dp[5][3]` 就是 "abcde" 和 "ace" 的最長共同子序列的長度，即 3。

## Python 代碼實現

```python
def longestCommonSubsequence(text1, text2):
    m, n = len(text1), len(text2)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if text1[i - 1] == text2[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

    return dp[m][n]
```

## 複雜度分析

- 時間複雜度：O(m * n)，其中 m 和 n 分別是 `text1` 和 `text2` 的長度。我們需要遍歷 DP 陣列中的每一個元素。
- 空間複雜度：O(m * n)，我們使用了一個二維陣列來存儲中間結果。

---

## 解題思路 - rolling DP

***避免重複計算。使用 rolling DP（滾動動態規劃）的方法可以節省空間。***

### 具體步驟

1. **建立 DP 陣列**：我們只需要兩個一維陣列 `previous` 和 `current` 來儲存每一步的計算結果。`previous` 保存上一行的 DP 值，`current` 保存當前行的 DP 值。

2. **初始化**：初始化 `previous` 和 `current` 陣列為 0，長度為 `text1` 的長度加 1。

3. **遍歷字符**：遍歷 `text2` 的每個字符，對每個字符再遍歷 `text1` 的每個字符進行比較。如果字符相同，則 `current[i] = previous[i-1] + 1`；否則，`current[i] = max(previous[i], current[i-1])`。

4. **更新陣列**：每次內層循環結束後，將 `current` 複製到 `previous`，以便進行下一輪比較。

5. **結果**：最終，`previous` 陣列的最後一個元素就是最長共同子序列的長度。

## Python 代碼實現

```python
def longestCommonSubsequence(text1, text2):
    m, n = len(text1), len(text2)
    previous = [0] * (m + 1)
    current = [0] * (m + 1)

    for j in range(1, n + 1):
        for i in range(1, m + 1):
            if text1[i - 1] == text2[j - 1]:
                current[i] = previous[i - 1] + 1
            else:
                current[i] = max(previous[i], current[i - 1])
        previous = current[:]

    return previous[m]
```

## 複雜度分析

- **時間複雜度**：O(m * n)，其中 m 和 n 分別是 `text1` 和 `text2` 的長度。我們需要遍歷 DP 陣列中的每一個元素。
- **空間複雜度**：O(m)，使用了兩個長度為 m + 1 的一維陣列來存儲中間結果。

