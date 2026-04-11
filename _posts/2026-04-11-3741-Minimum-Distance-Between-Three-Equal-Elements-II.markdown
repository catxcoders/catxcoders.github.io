---
layout: article_post
title:  "[Leetcode解題] 3741. Minimum Distance Between Three Equal Elements II"
description:  "3741. Minimum Distance Between Three Equal Elements II"
categories: medium
tags: array hash-table
langs: python
excerpt_separator: <!--more-->
---

# 3741. Minimum Distance Between Three Equal Elements II

## 題目
[3741. Minimum Distance Between Three Equal Elements II](https://leetcode.com/problems/minimum-distance-between-three-equal-elements-ii/description/)

<!--more-->

## 解題思路

使用 Hash Table 將每個數字出現的索引記錄下來，因為我們是依序遍歷原本的字串，所以每個數字對應的索引列表 `v` 自動會是遞增排序好的。
接著針對每一個數字的索引列表 `v`，只要列表長度大於等於 3，我們就可以在該列表中遍歷每一組相鄰的三個索引 `v[i]`, `v[i+1]`, `v[i+2]`（實際上因為只看頭尾的距離，只需要看 `v[i]` 和 `v[i+2]`）。
計算其涵蓋距離 `2 * (v[i+2] - v[i])` 並找出所有的組合中距離最短的作為答案。

## Python 實作

```python
import collections
class Solution:
    def minimumDistance(self, nums: List[int]) -> int:
        if len(nums) < 3:
            return -1
        hm = collections.defaultdict(list)

        for idx, num in enumerate(nums):
            hm[num].append(idx)
        
        min_dist = -1
        for k, v in hm.items():
            # v is sorted
            if len(v) < 3:
                continue
            for i in range(len(v)-2):
                dist = 2 * (v[i+2] - v[i])
                if min_dist == -1 or dist < min_dist:
                    min_dist = dist 
        return min_dist
```

## 時間複雜度

- **時間複雜度**: $O(n)$。遍歷一次陣列建立 HashMap 需要 $O(n)$；接著遍歷 HashMap 中的所有陣列元素總共也是 $O(n)$ 的時間，因此總結為 $O(n)$。
- **空間複雜度**: $O(n)$。使用 HashMap 儲存所有元素的索引，空間不超過 $O(n)$。
