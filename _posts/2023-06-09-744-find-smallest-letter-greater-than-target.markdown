---
layout: article_post
title:  "[Leetcode解題] Find Smallest Letter Greater Than Target - 使用二分搜尋法"
description: "[Leetcode解題] Find Smallest Letter Greater Than Target - 使用二分搜尋法"
categories: easy
tags: binary-search bs
langs: python
excerpt_separator: <!--more-->
---

題目網址: [744. ](https://leetcode.com/problems/find-smallest-letter-greater-than-target)

# 題目

給定一個排序過後的列表(根據字母順序)，列表中的元素為小寫的英文字母，另外給定一個`target`為英文單字，我們要回傳列表中，大於`target`的最小英文字母，這邊的大小判定是根據字母順序(lexicographical order)。

題目給定的列表，至少包含兩個相異的英文字母，並且有可能出現重複的字母。

<!--more-->

# 解題思路

這題我們很直覺可以想到要使用二分搜尋法(binary search)來解，因為題目給定的列表是一個排序過的，且我們要找的位置，也是可以透過二分搜尋法來找到，當然，也可以直接透過一層迴圈重頭掃到尾也可以找到答案，但時間複雜度為$O(n)$，而二分搜尋法為$O(logn)$。


```python
class Solution:

    def bs(self, lower, upper, letters, target):
        if lower >= upper:
            return letters[0]
        mid = (lower + upper) // 2
        if mid == 0:
            return letters[0]
        if letters[mid] > target and letters[mid-1] <= target:
            return letters[mid]
        elif letters[mid] > target and letters[mid-1] > target:
            return self.bs(lower, mid, letters, target)
        elif letters[mid] <= target:
            return self.bs(mid+1, upper, letters, target)


    def nextGreatestLetter(self, letters: List[str], target: str) -> str:
        return self.bs(0, len(letters), letters, target)
```