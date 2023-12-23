---
layout: article_post
title:  "[Leetcode解題] K Closest Points to Origin - Quick Select解"
description:  "[Leetcode解題] K Closest Points to Origin - Quick Select解"
categories: medium
tags: quickselect
langs: python
excerpt_separator: <!--more-->
---
# 題目
[973. K Closest Points to Origin](https://leetcode.com/problems/k-closest-points-to-origin/)
給定一個`points`陣列，其中 $points[i] = [x_i, y_i]$ 代表 $XY$ 平面上的一個點，以及一個整數 `k`，請返回距離原點 $(0, 0)$ 最近的前 $k$ 個點。

- 兩點之間的距離: 使用歐幾里得距離（$\sqrt{(x1 - x2)^2 + (y1 - y2)^2}$）。
- 可以以任何順序返回答案，且答案保證是唯一的（除了順序不同）。
<!--more-->

# 解題思路
這個問題與[Kth Largest Element in an Array](https://www.catxcoder.com/medium/2023/10/21/215-Kth-Largest-Element-in-an-Array.html)很類似，可以使用**快速選擇**（*Quick Select*）的思想來解決。*Quick Select*是一種修改版的*Quick Sort*，用於找到第 $k$ 小的元素。我們可以使用這個方法來找到最近的 $k$ 個點。

1. 計算每個點到原點的距離，並存儲在一個陣列中。
2. 使用快速選擇，找到第 k 小的距離，以及對應的點的索引。
3. 返回前 k 個最近的點。

這樣的實現方式可以在不需要對整個陣列進行排序的情況下找到最近的 $k$ 個點，從而提高效率。

# 實作
```python
class Solution:
    def kClosest(self, points: List[List[int]], k: int) -> List[List[int]]:
        n = len(points)
        disSqr = [pow(points[i][0], 2) + pow(points[i][1], 2) for i in range(n)]
        pointsIdx = list(range(n))

        # Quick Select to get k closest points to Origin
        def quick_select(pointsIdx, k):
            if not pointsIdx:
                return []

            pivotIdx = random.choice(pointsIdx)
            pivot = disSqr[pivotIdx]

            L, M, R = [], [], []  # L={x|x<pivot}, M={x|x=pivot}, R={x|x>pivot}
            for pId in pointsIdx:
                if disSqr[pId] < pivot:
                    L.append(pId)
                elif disSqr[pId] == pivot:
                    M.append(pId)
                else:
                    R.append(pId)

            def add_points(ids):
                return [points[id] for id in ids]

            if len(L) > k:
                return quick_select(L, k)
            elif len(L) == k:
                return add_points(L)
            else:
                result = add_points(L)
                k -= len(L)
                if len(M) > k:
                    result += add_points(M[:k])
                    k = 0
                elif len(M) == k:
                    result += add_points(M)
                    k = 0
                else:
                    result += add_points(M)
                    k -= len(M)
                    result += quick_select(R, k)
                return result

        return quick_select(pointsIdx, k)
        
```

# 時間複雜度
遍歷一次字串`s`，每次操作stack的時間複雜度為$O(1)$。因此，總的時間複雜度為$O(n)$，其中$n$是字串`s`的長度。