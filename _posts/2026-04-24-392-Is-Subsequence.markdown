---
layout: article_post
title:  "[Leetcode解題] 392. Is Subsequence"
description:  "392. Is Subsequence"
categories: easy
tags: string two-pointers
langs: python c++
excerpt_separator: <!--more-->
---

## 題目
[392. Is Subsequence](https://leetcode.com/problems/is-subsequence/description/)

給定兩個字串 `s` 和 `t`，如果 `s` 是 `t` 的**子序列**，則回傳 `true`，否則回傳 `false`。

字串的子序列是透過刪除原字串中的某些字元（也可以不刪除）後，不改變剩餘字元相對位置所形成的新字串。（例如，`"ace"` 是 `"abcde"` 的子序列，而 `"aec"` 則不是）。

<!--more-->

## 解題思路

這是一道典型的雙指標（Two Pointers）問題。我們需要檢查字串 `s` 的所有字元是否按順序出現在字串 `t` 中。

我們可以使用兩個指標來實作：
1. 定義指標 `p1` 指向字串 `s` 的開頭，指標 `p2` 指向字串 `t` 的開頭。
2. 當 `p1` 與 `p2` 皆未走訪完所屬的字串時，進行迴圈處理：
   - 比較 `s[p1]` 和 `t[p2]`：如果兩字元相同，代表我們在 `t` 中找到了 `s` 目前的字元，此時將 `p1` 和 `p2` 同時向右移動。
   - 如果兩字元不同，代表 `t` 目前的字元無法配對，我們只需將 `p2` 向右移動，繼續在 `t` 中尋找下一個配對的字元。
3. 迴圈結束後，檢查 `p1` 是否走訪完了字串 `s`。如果 `p1` 等於 `s` 的長度，代表 `s` 的所有字元都已經在 `t` 中依序找到，回傳 `true`；否則回傳 `false`。

特別留意字串長度的邊界條件，例如當 `s` 為空字串時，空字串永遠是任何字串的子序列，此寫法也能正確處理到。

## Python 實作

```python
class Solution:
    def isSubsequence(self, s: str, t: str) -> bool:
        p1, p2 = 0, 0
        
        while p1 < len(s) and p2 < len(t):
            if s[p1] == t[p2]:
                p1 += 1
            p2 += 1
            
        return p1 == len(s)
```

## C++ 實作

```cpp
class Solution {
public:
    bool isSubsequence(string s, string t) {
        int p1 = 0, p2 = 0;
        
        while (p1 < s.length() && p2 < t.length()) {
            if (s[p1] == t[p2]) {
                p1++;
            }
            p2++;
        }
        
        return p1 == s.length();
    }
};
```

## 時間複雜度

兩個指標 `p1` 與 `p2` 走訪字串時，最多只會將字串 `s` 和字串 `t` 走訪一次。
因此總體時間複雜度為 $O(|s| + |t|)$，其中 $|s|$ 與 $|t|$ 分別為字串 `s` 與 `t` 的長度。

空間複雜度部分，由於只使用了常數個變數進行狀態維護，故空間複雜度為 $O(1)$。
