---
layout: article_post
title:  "[Leetcode解題] Longest Increasing Subsequence - dp解"
description:  "[Leetcode解題] Longest Increasing Subsequence - dp解"
categories: medium
tags: dp
langs: python
excerpt_separator: <!--more-->
---

# 題目
[300. Longest Increasing Subsequence](https://leetcode.com/submissions/detail/310107536/)

<!--more-->

# 解題思路

## dp解，$O(n^2)$

這題我們想要找最長的嚴格遞增序列(LIS)，我們可以透過DP的想法來解這題。

首先，我們需要先想像k和k+1的情況，也就是找到sub optimitic structure。

假設我們有一個數列：

x x x x x x o


如果我們知道每個x位置為結束點的LIS長度，那我們就可以得到以o位置為結束點的LIS長度，透過以下方法，我們用nums[]表示該點的值，LISL[]來表示該位置上LIS的長度：

1. 如果nums[o] > nums[x]：那麼我們的LIS長度可以再擴展，所以LISL[o] = LISL[x]+1
2. 如果nums[o] <= nums[x]：那麼我們的LIS長度無法擴展，所以就跳過

我們必須考慮前面o前面所有x點的狀況，並取最大值，如果都沒辦法擴展的話，代表以o點為結尾的LIS長度為1(預設值)，也就是LISL[o] = 1。

## 實作
```python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        dp = [1 for i in range(len(nums))]
        for i in range(len(nums)):
            for j in range(i):
                if nums[i] > nums[j]:
                    dp[i] = max(dp[i], dp[j]+1)
        return max(dp)
```

這麼做的話，我們有兩個迴圈迭代數列，所以時間複雜度為$O(n^2)$

## Binary Search，$O(nlog(n))$

假設我們的數列為：[1,3,100,8,2,3,4,5]

我們可以從左至右一步一步來看：

[1]
[1,3]
[1,3,100]
[1,3,8]：8比100小，所以我們的LIS沒辦法繼續擴展，但我們會想說[1,3,8]這個LIS會比[1,3,100]來得好，因為他更有可能可以繼續擴展
[1,3,8], [1,2]：2比8小，所以我們的LIS沒辦法繼續擴展，但我們會想說[1,2]這個IS，可能在後面也有可能會得到一個更好的LIS，也就是說[1,3,8],[1,2]，在現階段，他們都有可能會產生最後最好的LIS
[1,2,3]：由於[1,2,3]的序列跟[1,3,8]的長度一樣，而3比8小，所以[1,2,3]比[1,3,8]來得好
[1,2,3,4]
[1,2,3,4,5]

從上面的過程來觀察，如果我們今天只需要知道長度，而不需要知道完整的最長序列，那麼其實我們只需要維護一個序列就好，過程是這樣

[1]
[1,3]
[1,3,100]
[1,3,8]
[1,2,8]：原來的過程我們要維護兩個序列，不過第一個序列其實我們要注意的只有最後一個數字，只要觀察有沒有比8大的數字即可，前面的空間其實是可以拿來利用的，所以我們可以找序列中，找到一個適合的位置讓序列維持是排序好的狀態(嚴格遞增)，而這個過程是可以透過二分搜尋法做到。
[1,2,3]
[1,2,3,4]
[1,2,3,4,5]

## 實作
```python
class Solution:
    def bs(self, nums, target, offset):
        mid = len(nums) // 2
        if mid == 0:
            return offset
        if nums[mid] == target:
            return offset+mid
        if nums[mid-1] == target:
            return offset+mid-1
        if nums[mid-1] < target and nums[mid] > target:
            return offset+mid
        if nums[mid-1] > target and nums[mid] > target:
            return self.bs(nums[:mid], target, offset)
        if nums[mid-1] < target and nums[mid] < target:
            return self.bs(nums[mid+1:], target, offset+mid+1)

        
    def lengthOfLIS(self, nums: List[int]) -> int:
        LIS = [nums[0]]
        for num in nums[1:]:
            if num > LIS[-1]:
                LIS.append(num)
            else:
                pos = self.bs(LIS, num, offset=0)
                LIS[pos] = num
        return len(LIS)
```
