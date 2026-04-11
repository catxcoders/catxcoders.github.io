---
layout: article_post
title:  "[Leetcode解題] 3143. Maximum Points Inside the Square"
description:  "[Leetcode解題] 3143. Maximum Points Inside the Square"
categories: medium
tags: array sort
langs: python
excerpt_separator: <!--more-->
---

## 題目

[3143. Maximum Points Inside the Square](https://leetcode.com/problems/maximum-points-inside-the-square/)

給定一個二維陣列 points 和一個字符串 s，其中 points[i] 表示第 i 個點的坐標，s[i] 表示第 i 個點的標籤。

一個有效的正方形必須以原點 (0, 0) 為中心，邊與軸平行，且不能包含兩個標籤相同的點。

返回一個有效的正方形內最多可以包含的點數。

如果一個點位於正方形的邊界上或內部，則認為該點在正方形內。正方形的邊長可以為零。
<!--more-->

## 解題思路

我們需要先把這些點由內到外進行排列，排列的標準是基於該點落在那一圈，例如落在邊長為1的正方型為第一圈(L1)、邊長為2的為第二圈(L2)，以此類推。這件事情可以透過$max(abs(x), abs(y))$得到。

這麼做之後，我們只需要從內點看到外，若出現重複的標籤時，就結束。唯一要注意的是，我們要確定該Level的所有點都沒有重複，我們才能算進去，然後移動到下一個層級。

## 程式碼

```python
class Solution(object):
    def maxPointsInsideSquare(self, points, s):
        """
        :type points: List[List[int]]
        :type s: str
        :rtype: int
        """
        
        points_with_tags = zip(points, s)
                
        points_with_tags = sorted(points_with_tags, key=lambda (x, _): max(abs(x[0]), abs(x[1])))
                
        cur = 0
        total = 0
        count = 0
        shown = set()
        for (point, tag) in points_with_tags:
            side_length = max(abs(point[0]), abs(point[1]))
           
            if side_length == cur and tag in shown:
                return total
            
            if side_length == cur and tag not in shown:
                shown.add(tag)
                count += 1
            
            if side_length > cur and tag in shown:
                return total+count
            
            if side_length > cur and tag not in shown:
                shown.add(tag)
                cur = side_length
                total += count
                count = 1
        return total+count
```

## 時間複雜度

n為點的數量，要進行一次sort，所以複雜度為$O(log(n))$