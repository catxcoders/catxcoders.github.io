---
layout: article_post
title:  "[Leetcode解題]  1105. Filling Bookcase Shelves"
description:  "[Leetcode解題]  1105. Filling Bookcase Shelves"
categories: medium
tags: dp
langs: python
excerpt_separator: <!--more-->
---

## 題目描述
[1105. Filling Bookcase Shelves](https://leetcode.com/problems/filling-bookcase-shelves/)
給定一個二維陣列 `books`，其中 `books[i] = [thicknessi, heighti]` 表示第 `i` 本書的厚度和高度。還給定一個整數 `shelfWidth`，表示書架每層的最大寬度。

我們要按照書的順序，依次把書放在書架上。每一層的書總厚度不能超過 shelfWidth，而這一層的高度就是放上去的書裡面最高的那本書的高度。我們需要重複這個過程直到所有書都放好，目標是讓書架的總高度最小。
<!--more-->
## 解題思路

1. **動態規劃**：我們使用動態規劃來解決這個問題。定義一個動態規劃陣列 `dp`，其中 `dp[i]` 表示放置到第 `i` 本書時的最小書架高度。

2. **遞推關係**：
   - 初始化 `dp[0] = 0`，表示沒有書時的高度為0。
   - 對於每一本書 `b`，我們可以考慮將它放置在不同的層次。使用內層循環 `j` 倒序遍歷從 `b-1` 開始的書，計算累積的寬度 `width` 和當前層的最大高度 `maxHeight`。
   - 如果累積的寬度超過 `shelfWidth`，則停止。
   - 否則，更新 `dp[b]` 為放置書後的最小高度：`dp[b] = min(dp[j] + maxHeight, dp[b])`。

3. **時間複雜度**：時間複雜度為 `O(n^2)`，其中 `n` 是書的數量。每本書需要遍歷之前的書來計算放置狀態。

## Python實作

```python
class Solution:
    def minHeightShelves(self, books: List[List[int]], shelfWidth: int) -> int:
        # 初始化動態規劃陣列，初始值為無限大
        dp = [float('inf')] * (len(books) + 1)
        dp[0] = 0  # 沒有書時，高度為0

        # 外層循環處理每一本書
        for b in range(1, len(books) + 1):
            width = 0
            maxHeight = 0
            # 內層循環處理不同的擺放狀況
            for j in range(b - 1, -1, -1):
                width += books[j][0]  # 累積書的厚度
                if width > shelfWidth:  # 如果超過書架寬度，跳出循環
                    break
                maxHeight = max(maxHeight, books[j][1])  # 更新該層的最大高度
                # 更新動態規劃陣列
                dp[b] = min(dp[j] + maxHeight, dp[b])

        # 返回放置所有書後的最小高度
        return dp[-1]
```

## C++實作
```cpp
class Solution {
public:
    int minHeightShelves(vector<vector<int>>& books, int shelfWidth) {
        // 初始化動態規劃陣列，dp[i] 表示放到第 i 本書後的最小高度
        vector<int> dp(books.size() + 1, INT_MAX);
        dp[0] = 0; // 初始情況，沒有書的時候高度為 0

        // 外層循環處理每一本書
        for (int b = 1; b <= books.size(); ++b) {
            int width = 0; // 當前層的寬度
            int maxHeight = 0; // 當前層的最大高度
            // 內層循環處理不同的擺放狀況
            for (int j = b - 1; j >= 0; --j) {
                width += books[j][0]; // 累積書的厚度
                if (width > shelfWidth) break; // 如果超過書架寬度，停止
                maxHeight = max(maxHeight, books[j][1]); // 更新當前層的最大高度
                dp[b] = min(dp[j] + maxHeight, dp[b]); // 更新最小高度
            }
        }

        // 返回放置所有書後的最小高度
        return dp.back();
    }
};
```

## 時間複雜度

- **時間複雜度**：`O(n^2)`，其中 `n` 是書的數量，每本書需要遍歷之前的書來計算不同的擺放狀況。
- **空間複雜度**：`O(n)`，動態規劃陣列 `dp` 佔用的空間。