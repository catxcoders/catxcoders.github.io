---
layout: article_post
title:  "[Leetcode解題] 2364. Count Number of Bad Pairs"
description:  "2364. Count Number of Bad Pairs"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

# 題目

[2364. Count Number of Bad Pairs](https://leetcode.com/problems/count-number-of-bad-pairs/description/?envType=daily-question&envId=2025-02-09)

給定一個矩陣，如果矩陣內有符合以下條件的情況，則為一組bad pairs

`j - i != nums[j] - nums[i]`

求總共有幾組bad pairs

 <!--more-->

# 解題心得

這題我覺得不好想，一開始會覺得，如果要判斷所有的可能並且計數，就不可避免的需要判斷$O(n^2)$次

但如果直接暴力解，會TLE，解法如下：

```python
class Solution:
    def countBadPairs(self, nums: List[int]) -> int:
        cnt = 0
        for i in range(len(nums)):
            for j in range(i+1, len(nums)):
                if j - i != nums[j] - nums[i]:
                    cnt += 1
                if j - nums[j] == i - nums[i]:
        return cnt
```

我們這邊可以再回顧一下`bad_pairs`的算式

`j - i != nums[j] - nums[i]` 為 bad pairs

換句話說：

`j - i == nums[j] - nums[i]` 為 good pairs

我們能計算所有可能pairs數為 $C^n_2$，扣除後即可得bad pairs

那這個算式，可以再稍作移項為：

`nums[j] - j == nums[i] - i`

有沒有發現！我們只要將矩陣每一項減去自己的索引，之後判斷哪些值相等，他們即能產生一對good pairs

舉例來說

nums = [4,1,3,3]
_nums = [4, 0, 2, 0]

經過處理後，我們會發現 `_nums[1] == _nums[3]`，可以產生一對good pairs

所以，我們只需要經過一次$O(n)$配合一個`hashmap`去計數每個值，如果出現次數大於一次，即可以產生good pairs，產生的數目也可以透過$C^k_2$得到，$k$為出現次數。

# 程式碼

```python
class Solution:
    def countBadPairs(self, nums: List[int]) -> int:
        num_pairs = len(nums) * (len(nums)-1) // 2
        for i in range(len(nums)):
            nums[i] = nums[i] - i
        
        counter = dict()
        for i in range(len(nums)):
            counter.setdefault(nums[i], 0)
            counter[nums[i]] += 1
        
        num_good_pairs = 0
        for v in counter.values():
            if v > 1:
                num_good_pairs += v * (v-1) // 2
        
        return num_pairs - num_good_pairs
```

# 時間複雜度

需後處理一次矩陣$O(n)$，並且計數$O(n)$，以及計算good_pairs$O(n)$

總時間複雜度為$O(n)$