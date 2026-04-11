---
layout: article_post
title:  "[Leetcode解題] 1460. Make Two Arrays Equal by Reversing Subarrays"
description:  "[Leetcode解題] 1460. Make Two Arrays Equal by Reversing Subarrays"
categories: easy
tags: array hashtable
langs: python
excerpt_separator: <!--more-->
---

## 題目

[1460. Make Two Arrays Equal by Reversing Subarrays](https://leetcode.com/problems/make-two-arrays-equal-by-reversing-subarrays/)

給你兩個長度相同的整數矩陣`target`和`arr`。在一步操作中，你可以選擇`arr`的任意非空子矩陣(non-empty subarry)並將其反轉。你可以進行任意次數的操作。

如果你能使`arr`變得與`target`相等，返回`true`否則返回`false`。
<!--more-->
## 解題思路

其實我們只需要使用一個dict來記錄所有元素及其數量，只要兩個矩陣元素及元素數量相等，就會是True，但前提是，能透過`reverse subarray`來移動任意元素到正確位置。

證明其實蠻簡單的，我們只需要從頭到尾把正確的元素移動到該位置即可，舉一個例子，i=0的時候，假設target[0]=80，我們只需要去找在arr中80的位置在哪，假設是在idx=13，那我們只要選擇\[0:14\)的子矩陣進行reverse，就能把元素轉到i=0, arr[0]=80。

## 程式碼

```python
class Solution(object):
    def canBeEqual(self, target, arr):
        """
        :type target: List[int]
        :type arr: List[int]
        :rtype: bool
        """
        d = {}
        for i in arr:
            d.setdefault(i, 0)
            d[i] += 1
        
        for i in target:
            if i not in d:
                return False
            if not d[i]:
                return False
            d[i] -= 1
        return True
```

## 時間複雜度

跑過兩次矩陣所以為$O(n)$