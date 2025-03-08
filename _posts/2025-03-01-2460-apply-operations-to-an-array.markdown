---
layout: article_post
title:  "[Leetcode解題] 2460. Apply Operations to an Array"
description:  "2460. Apply Operations to an Array"
categories: easy
tags: array
langs: python
excerpt_separator: <!--more-->
---

[2460. Apply Operations to an Array](https://leetcode.com/problems/apply-operations-to-an-array/description)

# 題目

這題給定一個矩陣，要求做$n-1$次的操作，每次操作會判斷`nums[i]==nums[i+1]`，如果相等的話，就要進行`nums[i]*2, nums[i+1]=0`，並且最後回傳的矩陣，要把零都往後推。

舉例來說，給定矩陣為`[1,2,2,1,1,0]`的話，最後要回傳`[1,4,2,0,0,0]`

# 解題思路

這題因為是Easy題，其實可以很簡單，就跑過一次矩陣判斷即可

基本思路為另建一個`_nums`的矩陣，如果不符合條件，就將`nums[i]`加進去

如果符合條件的話，就將`nums[i]*2`丟進去，並且從下一個非零的位置開始即可

然後做完全部的判斷後，再將後面補零。

只是這樣的話，我們要另創一個list，我們想有沒有可以inplace操作的方法，在同個矩陣上修改

因為我們發現，每次條件成立時，會多出一個零，然後這個零之後要被推往後面

所以我們可以使用兩個pointer來操作，一個用來記錄現在可以存值的位置在哪裡，一個用來traverse整個矩陣

# 程式碼

```python3
class Solution:
    def applyOperations(self, nums: List[int]) -> List[int]:
        ptr1 = 0
        ptr2 = 0
        while ptr2 < len(nums):
            if nums[ptr2] == 0:
                ptr2 += 1
                continue
            if ptr2 < len(nums) - 1 and nums[ptr2] == nums[ptr2 + 1]:
                nums[ptr1] = nums[ptr2] * 2
                nums[ptr2 + 1] = 0
            else:
                nums[ptr1] = nums[ptr2]
            ptr1 += 1
            ptr2 += 1
        while ptr1 < len(nums):
            nums[ptr1] = 0
            ptr1 += 1
        return nums
```

# 複雜度

時間複雜度為$O(n)$