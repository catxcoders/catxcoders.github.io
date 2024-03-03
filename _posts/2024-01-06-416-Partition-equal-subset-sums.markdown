---
layout: article_post
title:  "[Leetcode解題] 416. Partition Equal Subset Sum"
description:  "[Leetcode解題] 416. Partition Equal Subset Sum"
categories: medium
tags: hashmap dp marked
langs: python
excerpt_separator: <!--more-->
---

# 題目

[416. Partition Equal Subset Sum](https://leetcode.com/problems/partition-equal-subset-sum/description/)

給定一個矩陣，判定是否能將此矩陣分開成兩個子集(subsets)，並且兩個子集的和相等。

# 解題思路

首先，子集(subset)和子矩陣(subarray)的差別在於，子集可以不連續，而子矩陣必須連續，所以此題所求的子集可以為不連續。

因為我們想將其一分為二，所以如果矩陣和為奇數，那一定不可被一分為二，而如果為偶數則有可能。

所以題目能被簡化成，如果為偶數，求矩陣中有沒有子集的和為原矩陣和的一半，有的為則得解。舉個例子來說，如果矩陣和為$100$，我們如果可以求得一子集和為$50$，則其他未被選中的數總和也為$50$，故得解。

若給定一個矩陣，以及一個目標數(target)，若此矩陣中能找到一個子集總和為target，則回傳True，反之則回傳False。

我們可以使用dp來解這題，dp可以設計成:

`dp[k][target] = dp[k-1][target] or dp[k-1][target-nums[k]]`

也就是如果前(k-1)個數已經可以得到target，則前k個數也一定可以，若不行若前k-1個數可以得到(target-nums[k])，再加上第k個數nums[k]則可得到target。

此方法可行的一個前提是因為矩陣總和的target最大為$10000$，故可以直接創一個二維矩陣，但若範圍更大，則可以用$dict$來存會更節省空間。


```python
class Solution:
    def canPartition(self, nums: List[int]) -> bool:
        def partition(nums, target):
            dp = [[False for i in range(target+1)] for j in range(len(nums))]

            for i in range(len(nums)):
                dp[i][0] = True
            for i in range(1, len(nums)):
                for t in range(1, target+1):
                    prev = dp[i-1][t]

                    if nums[i] > t:
                        dp[i][t] = prev
                    else:
                        dp[i][t] = prev or dp[i-1][t-nums[i]]
            return dp[-1][-1]

        total = sum(nums)
        if total % 2 == 1:
            return False
        
        return partition(nums,  total // 2)
```

# 時間複雜度

由於dp為一個$m \times n$的二維矩陣，$m$為原矩陣長度，而$n$為$target$，最大可為$100 \times 200 / 2$。