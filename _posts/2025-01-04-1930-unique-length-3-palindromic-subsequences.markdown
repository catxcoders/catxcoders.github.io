---
layout: article_post
title:  "[Leetcode解題] 1930. Unique Length-3 Palindromic Subsequences"
description:  "1930. Unique Length-3 Palindromic Subsequences"
categories: medium
tags: string greedy hashmap
langs: python
excerpt_separator: <!--more-->
---

# 1930. Unique Length-3 Palindromic Subsequences

# 題目

[1930. Unique Length-3 Palindromic Subsequences](https://leetcode.com/problems/unique-length-3-palindromic-subsequences/description/)

這題給一個字串，我們要求所有長度為3的回文sub-sequence，並且如果重複的話只算一次，求有幾種可能？

 <!--more-->

# 解題思路

這題我們一開始會想要用前後指針解，但遇到一個問題，在下面這個狀況：

`abxxxxab`

當我們判斷第一個字元跟最後一個字元不同時，通常前後指針會要有一個機制可以移動

但在這題的狀況，如果我們移動`head`，我們能考慮到`bxxxxab`的狀況

如果我們移動`tail`，我們能考慮到`abxxxxa`的狀況

但沒有辦法在一次iteration中考慮到兩個狀況，所以我不考慮使用前後指針解

再來，我們發現這題的特殊限制是長度為3的回文子序列

我們可以簡化成`外字母`跟`內字母`，並且可以用Tuple表示

舉例來說，如果`aga`可以寫成`(a,g)`，外字母為a，內字母為g

所以我們可以一個字母一個字母考慮

當一個字母當外字母的時候，所有子序列的可能就是夾在最左跟最右的該字母之間

舉例來說

`kkaccaxa`

這個狀況，我們可以考慮`accaxa`，也可以考慮`axa`，但是`accaxa`必定可以包含到`axa`的狀況

所以我們只需考慮最左跟最右之間就好

因此，我們先記錄下各字母最左跟最右的索引，然後將中間的字母取set，即為以該字母為外子母時，可能的子序列的數量

# 程式碼

```python
class Solution:
    def countPalindromicSubsequence(self, s: str) -> int:
        leftmost = dict()
        for idx, c in enumerate(s):
            if c in leftmost:
                continue
            leftmost[c] = idx
        
        rightmost = dict()
        for idx, c in enumerate(s[::-1]):
            if c in rightmost:
                continue
            rightmost[c] = len(s) - idx - 1

        ans = 0
        for c in list(set(s)):
            # print(c, ans, leftmost[c], rightmost[c])
            if leftmost[c] == rightmost[c]:
                continue
            ans += len(set(s[leftmost[c]+1:rightmost[c]]))
        return ans
```

# 時間複雜度

`O(cn)`，c為字母的可能為26為常數