---
layout: article_post
title:  "[Leetcode解題] 986. Interval List Intersections - 雙指針解"
description:  "[Leetcode解題] 986. Interval List Intersections - 雙指針解"
categories: medium 
tags: array two-pointers
langs: python
excerpt_separator: <!--more-->
---

## 題目：求兩個區間列表的交集

[986. Interval List Intersections ](https://leetcode.com/problems/interval-list-intersections/)
給定兩個封閉區間的列表 `firstList` 和 `secondList`，其中 `firstList[i] = [starti, endi]` 和 `secondList[j] = [startj, endj]`。這些區間都是兩兩不相交的，並且按排序順序排列。

返回這兩個區間列表的交集。

一個封閉區間 `[a, b]`（其中 `a <= b`）表示實數 `x` 的集合，使得 `a <= x <= b`。

兩個封閉區間的交集是一組實數，要麼為空，要麼表示為一個封閉區間。例如，`[1, 3]` 和 `[2, 4]` 的交集是 `[2, 3]`。
<!--more-->

## 解題思路

1. **初始化指針**：我們用兩個指針 `idx1` 和 `idx2` 分別來遍歷 `firstList` 和 `secondList`。
2. **比較區間**：
   - 對於 `firstList[idx1]` 和 `secondList[idx2]`，我們計算它們的交集。交集的起始位置是兩個區間起始位置的最大值，結束位置是兩個區間結束位置的最小值。
   - 如果計算得到的交集是一個有效的區間（起始位置<=結束位置），我們就把這個交集加入結果列表中。
3. **移動指針**：
   - 由於在`firstList`與`secondList`中的區間都是兩兩不相交的，並且按排序順序排列，因此我們比較當下兩個區間的結束位置，***結束位置較小的區間無法與當下兩個區間之後的所有區間產生交集***，因此可以把指針向下一個區間移動。
4. **重複以上步驟**，直到任一列表的指針到底。

這種方法確保了我們能夠有效地找到所有的交集區間。

## Python 實作

```python
class Solution:
    def intervalIntersection(self, firstList: List[List[int]], secondList: List[List[int]]) -> List[List[int]]:
        idx1, idx2 = 0, 0
        intersections = []

        while idx1 < len(firstList) and idx2 < len(secondList):
            start1, end1 = firstList[idx1]
            start2, end2 = secondList[idx2]

            # 求交集
            start = max(start1, start2)
            end = min(end1, end2)

            if start <= end:
                intersections.append([start, end])

            # 移動指針
            if end1 < end2:
                idx1 += 1
            else:
                idx2 += 1

        return intersections
```

## C++ 實作
```cpp
class Solution {
public:
    vector<vector<int>> intervalIntersection(vector<vector<int>>& firstList, vector<vector<int>>& secondList) {
        size_t idx1 = 0;
        size_t idx2 = 0;

        vector<vector<int>> intersections;

        while(idx1<firstList.size() && idx2<secondList.size()){
            auto &Itv1 = firstList[idx1];
            auto &Itv2 = secondList[idx2];

            int l = max(Itv1[0], Itv2[0]);
            int r = min(Itv1[1], Itv2[1]);

            if (l<=r) {
                intersections.push_back({l, r});
            }

            if (Itv2[1]<Itv1[1]) idx2++;
            else idx1++;
        }
        return intersections;
    }
};
```

## 時間複雜度分析

假設 `firstList` 和 `secondList` 的長度分別為 `m` 和 `n`。在最壞的情況下，我們需要比較每一個區間，因此時間複雜度為 `O(m + n)`。

- 每一步驟中，至少有一個指針會移動，這樣我們最多需要進行 `m + n` 次比較操作。
- 因此，這個算法的時間複雜度是線性的，即 `O(m + n)`。