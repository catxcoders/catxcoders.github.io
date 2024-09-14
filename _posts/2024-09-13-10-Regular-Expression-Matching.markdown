---
layout: article_post
title:  "[Leetcode解題]  10. Regular Expression Matching - DP解"
description:  "[Leetcode解題]  10. Regular Expression Matching - DP解"
categories: medium
tags: dp
langs: python
excerpt_separator: <!--more-->
---

# 10. Regular Expression Matching

## 題目說明
[10. Regular Expression Matching](https://leetcode.com/problems/regular-expression-matching/)
給定一個輸入字串 `s` 和一個模式 `p`，實作正則表達式匹配，支援以下兩種特殊符號：

- `.` 可以匹配任意單一字元。
- `*` 可以匹配零個或多個它前一個字元。

匹配必須覆蓋整個輸入字串，不能只匹配部分字串。

## 一般 DP 解題思路

1. **初始化 DP 陣列**：
   - 建立一個二維陣列 `dp`，其中 `dp[i][j]` 表示 **`s[0:i]` 是否能被 `p[0:j]` 匹配**。
   - 初始化 `dp[0][0] = True`，因為空字串和空模式是匹配的。
   - 初始化第一行的情況(當s為空字串)，如果模式中有 `*`，需要檢查 `*` 的前一個字元是否可以忽略，這時 `dp[0][j] = dp[0][j-2]`。

2. **填充 DP 陣列**：
   - 當 **`s[i-1]` 與 `p[j-1]` 相同**或 **`p[j-1]` 為 `.`**，則 `dp[i][j] = dp[i-1][j-1]`。
   - 當 `p[j-1]` 為 `*`，有兩種情況：
     - **`*` 代表匹配零個前面的字元**：`dp[i][j] = dp[i][j-2]`。
     - **`*` 代表匹配一個或多個前面的字元**：這時如果 **`s`少了最後一個字元(`s[0:i-1]`)** 與 **`p[0:j]`** 匹配 (`dp[i - 1][j] == True`) 且 `s[i-1]` 與`*`前面的字元(`p[j-2]`)相同，那`s[0:i]` 與 `p[0:j]` 就匹配。

## 一般 DP 實作

### Python 實作

```python
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        m, n = len(s), len(p)
        dp = [[False] * (n + 1) for _ in range(m + 1)]
        dp[0][0] = True  # 空字串與空模式匹配

        def matches(char_s, char_p):
            return char_p == '.' or char_s == char_p
        
        # 初始化第一行
        for j in range(2, n + 1):
            if p[j - 1] == '*':
                dp[0][j] = dp[0][j - 2]

        # 填充 DP 陣列
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if matches(s[i - 1], p[j - 1]):
                    dp[i][j] = dp[i - 1][j - 1]
                elif p[j - 1] == '*':
                    dp[i][j] = dp[i][j - 2] or (matches(s[i - 1], p[j - 2]) and dp[i - 1][j])
        
        return dp[m][n]
```

### C++ 實作

```cpp
class Solution {
public:
    bool matches(char char_s, char char_p) {
        return char_p == '.' || char_s == char_p;
    }

    bool isMatch(string s, string p) {
        int m = s.size(), n = p.size();
        vector<vector<bool>> dp(m + 1, vector<bool>(n + 1, false));
        dp[0][0] = true; // 空字串與空模式匹配

        // 初始化第一行
        for (int j = 2; j <= n; j++) {
            if (p[j - 1] == '*') {
                dp[0][j] = dp[0][j - 2];
            }
        }

        // 填充 DP 陣列
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (matches(s[i - 1], p[j - 1])) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else if (p[j - 1] == '*') {
                    dp[i][j] = dp[i][j - 2] || (matches(s[i - 1], p[j - 2]) && dp[i - 1][j]);
                }
            }
        }

        return dp[m][n];
    }
};
```

### Rolling DP 解題思路

Rolling DP 是對一般 DP 的空間優化，每次僅使用兩個一維陣列 `prev` 和 `curr` 來表示前一行和當前行。

1. **初始化**：
   - `prev[0] = True`，表示空字串與空模式匹配。
   - 處理模式中含有 `*` 的情況。

2. **滾動更新**：
   - 用 `prev` 和 `curr` 來表示狀態，並每次計算完 `curr` 後，將其更新到 `prev`。

### Rolling DP 實作

#### Python 實作（Rolling DP）

```python
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
    
        m, n = len(s), len(p)
        prev = [False] * (n + 1)
        curr = [False] * (n + 1)
        
        prev[0] = True  # 空字串與空模式匹配
        def matches(char_s, char_p):
            return char_p == '.' or char_s == char_p

        # 初始化 prev 陣列
        for j in range(2, n + 1):
            if p[j - 1] == '*':
                prev[j] = prev[j - 2]

        # 填充 DP 陣列
        for i in range(1, m + 1):
            curr[0] = False
            for j in range(1, n + 1):
                if matches(s[i - 1], p[j - 1]):
                    curr[j] = prev[j - 1]
                elif p[j - 1] == '*':
                    curr[j] = curr[j - 2] or (matches(s[i - 1], p[j - 2]) and prev[j])
                else:
                    curr[j] = False
            prev, curr = curr, prev

        return prev[n]
```

#### C++ 實作（Rolling DP）

```cpp
class Solution {
public:
    bool matches(char char_s, char char_p) {
        return char_p == '.' || char_s == char_p;
    }
    bool isMatch(string s, string p) {
        int m = s.size(), n = p.size();
        vector<bool> prev(n + 1, false); // 前一行
        vector<bool> curr(n + 1, false); // 當前行
        
        prev[0] = true; // 空字串與空模式匹配

        // 初始化 prev 陣列
        for (int j = 2; j <= n; j++) {
            if (p[j - 1] == '*') {
                prev[j] = prev[j - 2];
            }
        }

        // 填充 DP 陣列
        for (int i = 1; i <= m; i++) {
            curr[0] = false;
            for (int j = 1; j <= n; j++) {
                if (matches(s[i - 1], p[j - 1])) {
                    curr[j] = prev[j - 1];
                } else if (p[j - 1] == '*') {
                    curr[j] = curr[j - 2] || (matches(s[i - 1], p[j - 2]) && prev[j]);
                } else {
                    curr[j] = false;
                }
            }
            prev.swap(curr); // 更新 prev 為當前計算行
        }

        return prev[n];
    }
};
```

## 時間與空間複雜度

- **時間複雜度**：`O(m * n)`，因為必須遍歷 `s` 和 `p` 的所有可能組合。
- **空間複雜度**：
  - 一般 DP：`O(m * n)`。
  - 滾動 DP：`O(n)`，只需保留當前行和前一行的狀態。
