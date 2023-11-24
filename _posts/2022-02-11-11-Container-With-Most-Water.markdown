---
layout: article_post
title:  "[Leetcode解題] Container With Most Water - 使用前後指針解"
description: "[Leetcode解題] Container With Most Water - 使用前後指針解"
categories: medium
tags: greedy two-pointers
langs: python
excerpt_separator: <!--more-->
---

# 題目
[11. Container With Most Water](https://leetcode.com/problems/container-with-most-water/)
給定一個長度為 $n$ 的整數數組 $height$，在平面直角坐標系上有 $n$ 條垂直線，其中第 $i$ 條線的兩端點分別為 $(i, 0)$ 和 $(i, height[i])$。
找到兩條線，與 $x$ 軸一起形成一個容器，使得該容器包含最多的水。
返回容器可以存儲的最大水量。

<!--more-->

# 解題思路
該代碼使用兩個指針 $left$ 和 $right$，分別指向數組的頭尾。每次比較 $height[left]$ 和 $height[right]$ 的值，然後移動較小值的指針。這樣，對於數組中的每個點，都會計算一次與其相鄰的兩個點的組合的面積。最後，我們可以返回最大的面積。

# 實作
```python
class Solution:
    def maxArea(self, height: List[int]) -> int:
        left, right = 0, len(height) - 1
        max_area = 0
        while left < right:
            width = right - left
            if height[left] < height[right]:
                max_area = max(max_area, height[left] * width)
                left += 1
            else:
                max_area = max(max_area, height[right] * width)
                right -= 1
        return max_area

```


# 複雜度
這個算法的時間複雜度是$O(n)$。因為每一個元素最多只會被訪問一次，所以時間複雜度隨著$n$的增加而線性增長。
