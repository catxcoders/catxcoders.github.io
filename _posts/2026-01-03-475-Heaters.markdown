---
layout: article_post
title:  "[Leetcode解題] 475. Heaters"
description:  "475. Heaters - 使用Binary Search解"
categories: medium
tags: binary_search, bs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[475. Heaters](https://leetcode.com/problems/heaters/?envType=problem-list-v2&envId=binary-search)

題目給定兩個矩陣`houses`和`heaters`，heaters可以溫暖半徑內的房子，比如半徑為1，heater的位置在2，那`[1,3]`範圍內的房子都會被溫暖到，題目要問半徑最短為多少，可以讓所有的暖氣溫暖到所有房子。

<!--more-->

## 解題思路

### 1. 直接binary search

隨著半徑變大，暖氣的範圍就會越來越大，到一個臨界值就能覆蓋到所有的房子，所以這題一定有解，那我們就可以透過binary search來做，實作一個`canCover`的函數，給定一個半徑判斷是否能夠涵蓋所有房子。

實作`[left, right)`的二分搜尋法，最後得到的半徑就是最小可以涵蓋所有房子的半徑。

可是這個方法的問題是，我們的`canCover`函數的時間複雜度太高，會需要$O(mn)$，導致總共的時間複雜度為$O(mnlogk)$, k為最大可能的位置。

```python
class Solution:

    def canCover(self, houses: List[int],  heaters: List[int], radius: int) -> bool:
        """Determines if all the houses could be warmed by the heaters with the given raidus."""
        # O(mn)
        for house in houses:
            for heater in heaters:
                if heater - radius <= house <= heater + radius:
                    break
            else:
                return False  # No heaters can cover it
        return True

    def findRadius(self, houses: List[int], heaters: List[int]) -> int:
        lower_bound = 0
        upper_bound = max(houses + heaters)

        while lower_bound < upper_bound:
            mid = (lower_bound + upper_bound) // 2
            if self.canCover(houses, heaters, mid):
                upper_bound = mid
            else:
                lower_bound = mid + 1
        return lower_bound
```

### 2. Greedy + Binary Search

我們可以對每個房子搜尋最近的暖氣，計算該暖氣需要涵蓋該房子的半徑，最後我們對所有的半徑求max，即可以涵蓋所有的房子。

搜尋暖氣的時候，最近的暖氣可以是在房子的左邊或右邊，我們一樣對暖氣位置進行`[left, right)`的二分搜尋法，所以我們會找到離房子最近`右邊`的暖氣，如果房子左邊也有暖氣，那我們也要一同考慮，取兩者絕對值比較小的那個。

所以總共時間複雜度為$O(mlogn)+O(nlogn)$, m為房子的數量，n為暖氣的數量，因為給定的暖氣位置沒有保證是排序好的，所以必須先排序。

```python
class Solution:

    def bs(self, heaters: List[int], target: int) -> int:
        lb = 0
        ub = len(heaters)
        while lb < ub:
            mid = (lb+ub) // 2
            if heaters[mid] < target:
                lb = mid + 1
            else:
                ub = mid
        return lb

    def findRadius(self, houses: List[int], heaters: List[int]) -> int:
        min_radius = 0
        heaters = sorted(list(set(heaters)))
        # O(mlogn) + O(nlogn)
        for house in houses:
            idx = self.bs(heaters, house)
            if idx >= len(heaters):
                radius = abs(heaters[-1]-house)
            elif idx == 0:
                radius = abs(heaters[0]-house)
            else:
                radius = min(abs(heaters[idx]-house), abs(heaters[idx-1]-house))
            min_radius = max(min_radius, radius)
        return min_radius

```