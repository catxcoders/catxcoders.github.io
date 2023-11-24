---
layout: article_post
title:  "[Leetcode解題] Kth Largest Element in an Array - 最小堆（Min Heap）& Quick Select 解 "
description: "[Leetcode解題] 經典Leetcode必刷題目"
categories: medium
tags: heap quick-select meta
langs: python
excerpt_separator: <!--more-->
---

# 215. Kth Largest Element in an Array

## 題目描述

給定一個整數陣列 `nums` 和一個整數 `k`，請找出陣列中第 k 大的元素。請注意，這裡指的是陣列按照升序排序後的第 k 大元素，而非第 k 個不同的元素。我們可以不使用sort解決這個問題嗎?

Example 1:
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
```

Example 2:
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
```

<!--more-->

## [解法1: Min Heap]
### Min Heap解題思路
為了找到第 $k$ 大的元素，我們可以使用**最小堆**（*Min Heap*）來維護目前陣列中的前 $k$ 大元素。我們首先建立一個大小為 $k$ 的*Min Heap* `heap`，然後將陣列中的元素依次加入`heap`中。當`heap`的大小超過 $k$ 時，我們將`top`元素（最小值）彈出，保持`heap`的大小為 $k$。最終，`top`元素即為第 $k$ 大的元素。

### Min Heap 實作
```python
class Solution:
    def findKthLargest(self, nums: List[int], k: int) -> int:
        min_heap = []
    
        # 將前 k 個元素加入min_heap
        for num in nums[:k]:
            heapq.heappush(min_heap, num)
        
        # 遍歷剩餘的元素，維護min_heap的大小為 k
        for num in nums[k:]:
            if num > min_heap[0]:
                heapq.heappop(min_heap)
                heapq.heappush(min_heap, num)
        
        # min_heap的top即為第 k 大的元素
        return min_heap[0]
```

### Min Heap 時間複雜度
在最壞情況下，我們需要遍歷整個陣列，並將每個元素加入或彈出最小堆，時間複雜度為 $O(N log k)$，其中 $N$ 為陣列的長度。這是因為最小堆的大小為 $k$，每次堆操作的時間複雜度為 $log k$。

## [解法2: Quick Select]
### Quick Select 解題思路
*Quick Select* 是一種基於**快速排序**(*Quick Sort*)的演算法，用於在未完全排序的數組中找到第 $k$ 大（或第 $k$ 小）的元素。其基本思想是選擇一個基準元素(`pivot`)，將數組分為比`pivot`小和比`pivot`大的兩部分。然後，根據 $k$ 與`pivot`的位置關係，決定繼續在左半部分或右半部分進行搜索。

### Quick Select 實作
```python
class Solution:
    def quickSelect(self, nums, k):
        # 遞迴實現 Quick Select 算法
        if not nums:
            return None

        # 選擇一個隨機基準元素
        pivot = random.choice(nums)

        # 初始化2個列表，分別存放大於、小於pivot
        L = [x for x in nums if x > pivot]
        R = [x for x in nums if x < pivot]
        
        # 等於基準元素的元素個數
        M_len = len(nums)-len(L)-len(R)

        # 遞迴執行 Quick Select
        if k <= len(L):
            return self.quickSelect(L, k)
        elif k <= len(L) + M_len:
            return pivot
        else:
            return self.quickSelect(R, k - len(L) - M_len)

    def findKthLargest(self, nums: List[int], k: int) -> int:
        return self.quickSelect(nums, k)
```

### Quick Select時間複雜度
*Quick Select* 的平均時間複雜度為 $O(N)$，其中 $N$ 為陣列的長度。在最壞情況下，時間複雜度仍然為 $O(N^2)$，但通常情況下它的效率比 *heap* 排序要好。
