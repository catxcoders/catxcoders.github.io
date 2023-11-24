---
layout: article_post
title:  "[Leetcode解題] Minimum Size Subarray Sum - Presum + 前後指針解法"
description: "[Leetcode解題] 經典Leetcode必刷題目，學習使用前後指針以及Presum"
categories: medium
tags: presum two-pointers
langs: python
excerpt_separator: <!--more-->
---

# 題目
[209. Minimum Size Subarray Sum](https://leetcode.com/problems/minimum-size-subarray-sum/)
這題給定一個正整數陣列，以及一個正整數`target`，要求陣列中最短的子陣列和大於或等於`target`。

<!--more-->

# 解題思路

首先，我們可以先想到使用暴力法來解決，假設一個陣列長度為`n`，所有自陣列的組合從1到n，只要窮舉出來並且求和去判斷即可。

```python
for i in range(len(nums)):
    for j in range(i, len(nums)):
        val = sum(nums[i:j+1])
```

此外，求和的部分，我們可以透過`presum`的技巧來優化，將複雜度壓到`O(1)`

## 實作
```python
presum = [0]
total = 0
for num in range(nums):
    total += num
    presum.append(total)

for i in range(len(nums)):
    for j in range(i, len(nums)):
        val = presum[j+1] - presum[i]
```

這樣一來時間複雜度是$O(n^2)$，我們會發現其實當中有一些不必要的計算，舉例來說，如果有一個子矩陣`nums[i:j]`和已經大於等於`target`，那麼我們其實就沒有必要繼續看`nums[i:j+1]`和`nums[i-1:j]`了，跟著這個思路，我們其實可以透過前後指針來解。

當我們目前的和小於目標時，後指針就往後一步(加大矩陣)，當目前的和大於或等於目標的時候就將前指針往後一步(縮小矩陣)，並且紀錄目前的長度，這個過程中，我們會計算到所有符合的子矩陣。

## 實作
```python
class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        presum = [0]
        val = 0
        for num in nums:
            val += num
            presum.append(val)
        
        minlen = len(nums)+1
        head = 0
        tail = 1
        while head < tail and tail < len(nums)+1:
            x = presum[tail] - presum[head]
            if x < target:
                tail += 1
            else:
                length = tail - head
                if length < minlen:
                    minlen = length
                head += 1
        if minlen == len(nums)+1:
            return 0
        return minlen

```

# 複雜度

我們使用前後指針搭配`presum`解，建造`presum`為`O(n)`，而指針移動最多`2n`，時間複雜度為`O(n)`。

