---
layout: article_post
title:  "[Leetcode解題]  3254. Find the Power of K-Size Subarrays I"
description:  "3254. Find the Power of K-Size Subarrays I"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

# 題目

[3254. Find the Power of K-Size Subarrays I](https://leetcode.com/problems/find-the-power-of-k-size-subarrays-i/)

這題要求找到長度為 $𝑘$ 的所有子陣列的「power」

陣列的「power」定義為：如果這個子陣列的元素是連續遞增的，則返回其最大元素；否則返回 -1。我們需要遍歷所有長度為 $k$ 的子陣列，並返回一個結果陣列，其中每個元素是對應子陣列的「power」。

<!--more-->

# 解題思路

1. 處理特殊情況：

如果 k 為 1，直接返回 nums，因為單個數字本身即為連續序列。

2. 初始化變量：

m 用來記錄當前連續遞增數字的長度，初始化為 1。
ans 是結果列表，用來存儲最終結果。

3. 遍歷數組並檢查連續序列：

從第二個數字開始遍歷 nums（索引從 1 開始）。
如果當前數字 nums[i] 與前一個數字 nums[i-1] 的差為 1，表示兩者連續，則將 m 加 1。
如果不是連續的數字，將 m 重置為 1。

4. 檢查連續序列的長度：

當索引 i 大於或等於 k-1 時，即已遍歷至少 k 個數字，可以開始檢查連續序列。
如果 m == k，表示出現了長度為 k 的連續遞增序列，將當前數字 nums[i] 加入 ans，並將 m 減 1（繼續保持剩下的序列長度）。
否則，表示未達到連續的長度 k，在 ans 中加入 -1。

5. 返回結果：

最後返回 ans，其中每個元素代表以當前位置結束的長度為 k 的連續遞增序列的結尾數字（若沒有，則為 -1）。

# 程式碼

```python
class Solution:
    def resultsArray(self, nums: List[int], k: int) -> List[int]:
        if k == 1:
            return nums
        m = 1
        ans = []
        for i in range(1, len(nums)):
            if nums[i] == nums[i-1]+1:
                m += 1
            else:
                m = 1
            if i >= k-1:
                if m == k:
                    ans.append(nums[i])
                    m -= 1
                else:
                    ans.append(-1)
        return ans
```

# 時間複雜度

我們檢查一次陣列，所以複雜度為 $O(n)$