---
layout: article_post
title:  "[Leetcode解題] 2573. Find the String with LCP"
description:  "2573. Find the String with LCP"
categories: hard
tags: string
langs: python
excerpt_separator: <!--more-->
---

# 2573. Find the String with LCP

## 題目
[2573. Find the String with LCP](https://leetcode.com/problems/find-the-string-with-lcp/description/)

<!--more-->

## 解題思路

這題考驗的是對於字串的 Longest Common Prefix (LCP) 的理解。
給定一個 LCP 的二維矩陣，我們需要構造出原本的字串，若無法構造則回傳空字串。
首先可以觀察到，`lcp[i][j]` 可以幫助我們推斷 `s[i]` 和 `s[j]` 是否相同。如果 `lcp[i][j] > 0`，代表從索引 `i` 開始和從索引 `j` 開始的子字串至少有共同的前綴長度為 1，因此 `s[i] == s[j]`。

我們可以利用貪婪構造法（Greedy Approach）：
1. 建立長度為 `n` 的目標字串陣列 `chars`，初始為空。
2. 從頭開始遍歷，如果遇到尚未被填寫的字元，就從可用的英文字母（由 'a' 開始往下遞增）指派給它。
3. 因為若 `lcp[i][j] > 0` 代表 `s[i]` 與 `s[j]` 一定是相同的字元，所以我們可以把後面所有符合此條件的 `chars[j]` 都填上相同的字母。
4. 如果所需字母數量超過 26 個，代表無法合法構造，回傳空字串。若還有字元沒有被填寫到（`None`），同樣也不合法。

在構造完字串之後，因為一開始提供的 LCP 矩陣不一定保證完全相符且合法（可能存在矛盾），所以我們必須再做一次「驗證」。
我們重頭計算一次構造出來字串的 LCP，利用字尾遞迴（倒序遍歷）的方式：
只要 `s[i] == s[j]`，則 `_lcp = lcp[i+1][j+1] + 1`，確認計算結果是否與輸入的 `lcp` 矩陣完全相同，若有任何不合就回傳空字串。

## Python 實作

```python
class Solution:
    def findTheString(self, lcp: List[List[int]]) -> str:
        n = len(lcp)
        chars = [None] * n
        cur = 0
        
        # 假設LCP是合法的，可以這樣構造
        for i in range(n):
            if chars[i] is None:
                if cur >= 26:
                    return ''
                char = chr(ord('a') + cur)
                cur += 1
                for j in range(i, n):
                    if lcp[i][j] > 0:
                        chars[j] = char
        
        if None in chars:
            return ''
        s = ''.join(chars)
        
        # 驗證
        for i in range(n-1, -1, -1):
            for j in range(n-1, -1, -1):
                _lcp = 0
                if s[i] == s[j]:
                    _lcp = lcp[i+1][j+1] + 1 if i + 1 < n and j + 1 < n else 1
                
                if _lcp != lcp[i][j]:
                    return ''
        return s
```

## 時間複雜度

字串構造需遍歷 $n^2$，驗證的過程也是遍歷 $n^2$ 次。
因此總體時間複雜度為 $O(n^2)$。
