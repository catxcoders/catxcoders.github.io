---
layout: article_post
title:  "[Leetcode解題] Median of Two Sorted Arrays  - 使用分治法(Divide-and-conquer)算法"
description: "[Leetcode解題] Median of Two Sorted Arrays  - 使用分治法(Divide-and-conquer)算法"
categories: hard
tags: divide-and-conquer apple amazon
langs: python
excerpt_separator: <!--more-->
---

# 題目
[4. Median of Two Sorted Arrays](https://leetcode.com/problems/median-of-two-sorted-arrays/)
兩個已排序陣列的中位數

給定兩個大小分別為 $m$ 和 $n$ 的已排序陣列 $nums1$ 和 $nums2$，找出這兩個陣列的中位數。

整體運行時間複雜度應為 $O(log(m+n))$。

<!--more-->

# 解題思路

這個問題可以轉換為在兩個已排序陣列中尋找第 $K$ 個元素，其中 $K$ 為兩個陣列元素總數的中位數位置。

為了達到 $O(log(m+n))$ 的時間複雜度，我們可以使用一種分治法(Divide-and-conquer)的思路。


1. 首先，我們找到兩個陣列的中間元素($K/2$)，分別為 $mid1$ 和 $mid2$。
2. 比較 $mid1$ 和 $mid2$ 的值：
    - 如果 $mid1$ 小於 $mid2$，那麼 $nums1$ 中的前半部分不可能包含第 $K$ 大的元素。所以，我們可以將 $nums1$ 的前半部分丟棄，並更新 $K$ 的值。
    - 如果 $mid1$ 大於等於 $mid2$，那麼 $nums2$ 中的前半部分不可能包含第 $K$ 大的元素。所以，我們可以將 $nums2$ 的前半部分丟棄，並更新 $K$ 的值。
3. 重複上述步驟，直到 $K$ 的值等於 $1$。
4. 當 $K$ 的值等於 $1$ 時，我們找到了第 $K$ 大的元素，即為 $min(nums1[mid1], nums2[mid2])$。


## 範例
在這個例子中，我們可以根據上述步驟找到第 5 大的元素：
```
nums1 = [1, 3, 5, 7, 9]
nums2 = [2, 4, 6, 8, 10]
```

1. $mid1$ 為 $nums1[k/2] = 5$，$mid2$ 為 $nums2[k/2] = 6$。
2. $mid1$ 小於 $mid2$，所以我們丟棄 $nums1$ 的前半部分，更新 $K$ 的值為 $5-2=3$。
3. 再次進行比較，$mid1$ 為 $nums1[k/2] = 7$，$mid2$ 為 $nums2[k/2] = 6$。
    - $mid1$ 大於等於 $mid2$，所以我們丟棄 $nums2$ 的前半部分，更新 $K$ 的值為 3-2=1。
4. 當 $K$ 的值等於 $1$ 時，我們找到了第 $K$ 大的元素，即為 $5$。
所以，在這個例子中，兩個已排序陣列中的第 $5$ 大元素為 $5$。


# 算法
1. 定義一個輔助函數 `findKthInSortedArrays(nums1, nums2, s1, s2, k)`。
2. 在 `findKthInSortedArrays` 中，處理特殊情況：如果 nums1 中沒有剩餘元素，則返回 `nums2[s2+k]`；如果 nums2 中沒有剩餘元素，則返回 `nums1[s1+k]`。
3. 如果 `k=0`，則返回 $min(nums1[s1], nums2[s2])$。
4. 計算 $mid = (k-1)/2$。
5. 防止 $mid1$ 和 $mid2$ 超出陣列界限，設置 $mid1 = min(s1+mid, nums1.size()-1)$ 和 $mid2 = min(s2+mid, nums2.size()-1)$。
6. 如果 $nums1[mid1] > nums2[mid2]$，則遞歸調用 `findKthInSortedArrays(nums1, nums2, s1, mid2+1, k-(mid2-s2+1))`。
7. 如果 $nums1[mid1] <= nums2[mid2]$，則遞歸調用 `findKthInSortedArrays(nums1, nums2, mid1+1, s2, k-(mid1-s1+1))`。
8. 在主函數 `findMedianSortedArrays(nums1, nums2)` 中，計算 `mid_left = findKthInSortedArrays(nums1, nums2, 0, 0, (nums1.size()+nums2.size()-1)/2)` 和 `mid_right = findKthInSortedArrays(nums1, nums2, 0, 0, (nums1.size()+nums2.size())/2)`。
9. 返回 (mid_left+mid_right)/2 作為中位數。


# 實作
```python
class Solution:
    def findKthInSortedArrays(self, nums1, nums2, s1, s2, k):
        if len(nums1) <= s1:
            return nums2[s2 + k]
        if len(nums2) <= s2:
            return nums1[s1 + k]

        if k == 0:
            return min(nums1[s1], nums2[s2])

        mid = (k - 1) // 2
        mid1 = min(s1 + mid, len(nums1) - 1)
        mid2 = min(s2 + mid, len(nums2) - 1)

        if nums1[mid1] > nums2[mid2]:
            return self.findKthInSortedArrays(nums1, nums2, s1, mid2 + 1, k - (mid2 - s2 + 1))
        else:
            return self.findKthInSortedArrays(nums1, nums2, mid1 + 1, s2, k - (mid1 - s1 + 1))

    def findMedianSortedArrays(self, nums1: List[int], nums2: List[int]) -> float:
        mid_left = self.findKthInSortedArrays(nums1, nums2, 0, 0, (len(nums1) + len(nums2) - 1) // 2)
        mid_right = self.findKthInSortedArrays(nums1, nums2, 0, 0, (len(nums1) + len(nums2)) // 2)
        return (mid_left + mid_right) / 2


```
# 複雜度
* 時間複雜度：由於使用了分治法，每次遞歸將問題規模縮小為原來的一半，因此運行時間複雜度為 $O(log(m+n))$。
* 空間複雜度：遞歸過程中需要使用額外的堆疊空間，空間複雜度為 $O(log(m+n))$。