---
layout: article_post
title:  "[Leetcode解題] Trapping Rain Water"
description:  "[Leetcode解題] Trapping Rain Water"
categories: hard
tags: greedy amazon
langs: python
excerpt_separator: <!--more-->
---

# 題目
[42. Trapping Rain Water](https://leetcode.com/problems/trapping-rain-water/)

<!--more-->

# 解題思路
「困住雨水」這個問題是在想像一個有長條狀物（代表高度）的地圖上下雨的情況，我們要計算雨水在這個地圖上最多能夠被困住多少。

想像一下，如果兩側都有較高的長條，那麼中間的空間就可以儲存更多的雨水。因此，我們可以從兩邊向中間遍歷，並計算每個空間能儲存多少雨水。最終，我們就可以得出整個地圖上困住的雨水總量。

這題的關鍵是以比較細的維度來思考，每個位置可以困住多少雨水，而這取決於該位置左最高跟右最高的牆。

# 算法

初始化兩個指針，一個在高度數組的開頭，另一個在末尾。

初始化兩個變量 left_max 和 right_max，以兩個迴圈求每個位置左側和右側的最大高度。

再透過一個迴圈，來求每個位置可以困住的雨水量，可以通過將 left_max 和 right_max 的最小值減去當前位置的高度，追蹤困住的水的總量。

# 實作

```python
class Solution:
    def trap(self, height: List[int]) -> int:
        lh = []
        rh = []
        left_highest = 0
        for wall in height:
            lh.append(left_highest)
            if wall > left_highest:
                left_highest = wall
        right_highest = 0
        for wall in height[::-1]:
            rh.append(right_highest)
            if wall > right_highest:
                right_highest = wall
        rh = rh[::-1]
        water = 0
        for idx, wall in enumerate(height):
            can_trap = min(rh[idx], lh[idx])
            if can_trap > wall:
                water += can_trap - wall
        return water
            
```

# 複雜度
這個算法的時間複雜度是 $O(n)$，因為我們總共使用三次迴圈來以求得各位置能困住的雨水。

空間複雜度是 $O(1)$，因為我們只需要幾個變量來維護遍歷的狀態。因此，我們不需要額外的空間來儲存答案，也不需要額外的空間來進行遞迴計算。
