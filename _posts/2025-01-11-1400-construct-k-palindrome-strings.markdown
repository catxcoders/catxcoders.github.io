---
layout: article_post
title:  "[Leetcode解題] 1400. Construct K Palindrome Strings"
description:  "1400. Construct K Palindrome Strings"
categories: medium
tags: string greedy hashmap
langs: python
excerpt_separator: <!--more-->
---

# 題目

[1400. Construct K Palindrome Strings][(](https://leetcode.com/problems/construct-k-palindrome-strings/description/?envType=daily-question&envId=2025-01-11))

這題給定一個字串，以及一個數字k，求能不能將字串切成k組，並且各組皆為回文字串

<!--more-->

# 解題思路

這題我們可以數每個字元出現的次數，因為我們要特別注意的只有出現奇數次的狀況，如果出現奇數次字母的次數大於k的話，那麼一定無法滿足需求。

另外，如果k比字串長度大的話，也無法滿足需求，這兩個狀況都相當直覺。

那我們來想反面，為什麼只要奇數次字母的次數小於等於k的話，就一定能找到相符的組合。

首先，我們先考慮等於的狀況，等於的狀況，其實就是將每個字母單獨拆開，所以必定可以。

而小於的狀況，我們可以先把所有奇數次的字母，假設有m個，單獨拆開為一組，而剩下所有為出現偶數次的字母，可以以任意方式組成剩下(k-m)個回文字串。

# 程式碼

```python
class Solution:
    def canConstruct(self, s: str, k: int) -> bool:
        if k > len(s):
            return False
        count = dict()
        for c in s:
            count.setdefault(c, 0)
            count[c] += 1

        num_of_odds = 0
        for v in count.values():
            if v % 2 == 1:
                num_of_odds += 1
        
        if num_of_odds <= k:
            return True
        return False
```

# 時間複雜度

$O(n)$