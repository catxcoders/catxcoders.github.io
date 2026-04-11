---
layout: article_post
title:  "[Leetcode解題] 452. Minimum Number of Arrows to Burst Balloons"
description:  "452. Minimum Number of Arrows to Burst Balloons"
categories: medium
tags: array greedy sorting
langs: python c++
excerpt_separator: <!--more-->
---

<!--more-->

# 452. Minimum Number of Arrows to Burst Balloons

## 題目
[452. Minimum Number of Arrows to Burst Balloons](https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/description/)

給定一個二維陣列 `points`，其中 `points[i] = [x_start, x_end]` 代表一個氣球的水平位置。
你可以從 X 軸的任意位置向上射出箭，若箭的 X 座標落在氣球的範圍內（並且包含邊界），該氣球就會被射破。
求：最少需要射出幾支箭才能將所有的氣球射破？

## 解題思路

這題考驗的是對於區間重疊（Interval Overlapping）的理解，是一道經典的貪婪演算法（Greedy Algorithm）題目。
題目給定一組氣球的水平區間 `[x_start, x_end]`，一支從 `x` 射出的箭可以射破所有滿足 `x_start <= x <= x_end` 的氣球。我們要求出最少需要幾支箭才能射破所有氣球。

我們可以利用貪婪法：
1. 先將所有的氣球區間**依照結束點（`x_end`）由小到大排序**。為什麼要看結束點呢？因為為了這顆氣球，我們最晚必須在它的結束點射出一支箭，否則它就不會破。
2. 排序後，我們總是選擇在「當下最早結束的氣球的右邊界（結束點）」射出一支箭。這樣的一射可以盡所有可能地涵蓋到後面開始的氣球。
3. 我們記錄第一支箭的位置為 `pos = points[0][1]`，並初始化箭的數量 `arrows = 1`。
4. 接著從第二個氣球開始遍歷排序後的氣球陣列 `points[i]`：
   - 如果當前氣球的起始位置 `points[i][0]` 小於等於 `pos`，代表它可以被同一支箭射破，不需要增加箭。
   - 如果當前氣球的起始位置 `points[i][0]` 大於 `pos`，代表原本的那支箭射不到這顆氣球，我們需要新的一支箭。同時將這支新箭的位置更新為當前氣球的結束位置 `pos = points[i][1]`，並將 `arrows` 遞增。
5. 遍歷完成後回傳 `arrows` 即可。

## Python 實作

```python
class Solution:
    def findMinArrowShots(self, points: List[List[int]]) -> int:
        if not points:
            return 0
            
        # 依照氣球的結束位置進行排序
        points.sort(key=lambda x: x[1])
        
        arrows = 1
        pos = points[0][1]
        
        for i in range(1, len(points)):
            # 當氣球的起點超過了目前箭的涵蓋範圍，代表必須射出一支新箭
            if points[i][0] > pos:
                arrows += 1
                pos = points[i][1]
                
        return arrows
```

## C++ 實作

```cpp
class Solution {
public:
    int findMinArrowShots(vector<vector<int>>& points) {
        if (points.empty()) return 0;
        
        // 依照氣球的結束位置由小到大排序
        sort(points.begin(), points.end(), [](const vector<int>& a, const vector<int>& b) {
            return a[1] < b[1];
        });
        
        int arrows = 1;
        int pos = points[0][1];
        
        for (int i = 1; i < points.size(); ++i) {
            // 當前氣球的起點大於箭的涵蓋範圍時，需射出新箭
            if (points[i][0] > pos) {
                arrows++;
                pos = points[i][1];
            }
        }
        
        return arrows;
    }
};
```

## 時間複雜度

陣列排序所需的時間為 $O(n \log n)$，遍歷陣列需花費 $O(n)$。
因此總體時間複雜度為 $O(n \log n)$。

空間複雜度部分，取決於內建排序系統的實作，大部分語言（如 Python 的 Timsort）會需要 $O(n)$ 的空間，所以為 $O(n)$。
