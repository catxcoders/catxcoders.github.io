---
layout: article_post
title:  "42. Trapping Rain Water"
categories: hard
tags: leetcode hard python coder greedy
excerpt_separator: <!--more-->
---

題目網址: [42. Trapping Rain Water](https://leetcode.com/problems/trapping-rain-water/)


## 解題思路
「困住雨水」這個問題是在想像一個有長條狀物（代表高度）的地圖上下雨的情況，我們要計算雨水在這個地圖上最多能夠被困住多少。

想像一下，如果兩側都有較高的長條，那麼中間的空間就可以存储更多的雨水。因此，我們可以從兩邊向中間遍歷，並計算每個空間能存储多少雨水。最終，我們就可以得出整個地圖上困住的雨水總量。

## 算法
初始化兩個指針，一個在高度數組的開頭，另一個在末尾。

初始化兩個變量 left_max 和 right_max，用於存儲高度數組左側和右側的最大高度。

在兩個指針沒有相遇的情況下，執行以下操作：
a. 如果左指針上的條的高度小於右指針上的條的高度，增加左指針並更新 left_max，如果新位置的高度大於 left_max。
b. 否則，減少右指針並更新 right_max，如果新位置的高度大於 right_max。

通過將 left_max 和 right_max 的最小值減去當前位置的高度，追蹤困住的水的總量。

重複步驟3和4，直到兩個指針相遇。

返回困住的水的總量。

就是這樣！解決「困住雨水」問題的方法涉及使用兩個指針遍歷高度數組，並追蹤左側和右側的最大高度。通過求出這些最大高度的最小值和當前條的高度的差，我們可以計算每個位置的困住水量。

## 實作
以下是一個使用「双指针」演算法的 Python 實現：
```python
def trap(height):
    n = len(height)
    left, right = 0, n - 1
    left_max, right_max = 0, 0
    trapped_water = 0
    
    while left < right:
        if height[left] < height[right]:
            if height[left] > left_max:
                left_max = height[left]
            else:
                trapped_water += left_max - height[left]
            left += 1
        else:
            if height[right] > right_max:
                right_max = height[right]
            else:
                trapped_water += right_max - height[right]
            right -= 1
    
    return trapped_water
```
這個算法使用了「双指针」的技巧，從兩側向中間遍歷。我們維護了兩個變量 left_max 和 right_max，分別代表當前的左側和右側的最高條的高度。然後，我們比較當前位置的左條和右條，並選擇較低的一側繼續遍歷。如果當前條的高度比維護的最高條的高度低，那麼當前位置就可以存储水，我們就可以更新困住水的總量。否則，我們就更新最高條的高度。

## 複雜度
這個算法的時間複雜度是 $O(n)$，因為我們從兩側向中間遍歷，每個位置只被遍歷一次。因此，我們可以在較短的時間內找到答案。

空間複雜度是 $O(1)$，因為我們只需要幾個變量來維護遍歷的狀態。因此，我們不需要額外的空間來存儲答案，也不需要額外的空間來進行遞歸計算。