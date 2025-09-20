---
layout: article_post
title:  "[Leetcode解題] 753. Cracking the Safe"
description:  "753. Cracking the Safe - Use Eulerian Path"
categories: medium
tags: graph 
langs: python
excerpt_separator: <!--more-->
---

# 753. Cracking the Safe

## 題目

[753. Cracking the Safe](https://leetcode.com/problems/cracking-the-safe/description/)



 <!--more-->

## 解題思路

這題我們要用`Eulerian Path`的思路來解，也就是我們能不能用一筆劃來走完所有的edge跟node。

## 程式碼

```python
class Solution:
    def crackSafe(self, n: int, k: int) -> str:
        seen = set()
        ans = []
        def dfs(node):
            for x in map(str, range(k)):
                nei = node + x
                if nei not in seen:
                    seen.add(nei)
                    dfs(nei[1:])
                    ans.append(x)

        dfs("0" * (n-1))
        return "".join(ans) + "0" * (n-1)
```

## 時間複雜度

$O(k^n)$