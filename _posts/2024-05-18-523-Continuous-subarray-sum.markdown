---
layout: article_post
title:  "[Leetcode解題] 523. Continuous Subarray Sum"
description:  "[Leetcode解題] 523. Continuous Subarray Sum"
categories: medium 
tags: array presum hash hashtable
langs: python
excerpt_separator: <!--more-->
---

## 題目
[523. Continuous Subarray Sum](https://leetcode.com/problems/continuous-subarray-sum/)

給一個矩陣看是否包含長度大於1的子矩陣的和可以被給定的k給整除。

矩陣內的數字皆為正整數。

<!--more-->

## 解題思路

說到求子矩陣和(sum of maximum subarray)，最直覺想到的是使用`presum`，這題我們也能先求`presum array`，然後再用一個雙層迴圈去驗證所有可能的子矩陣和，時間複雜度為$O(n^2)$

```python
presum = [0] * (len(nums)+1)
for i in range(len(nums)):
    presum[i+1] = presum[i] + nums[i]

for i in range(len(presum)-2):
    for j in range(i+2, len(presum)):
        if (presum[j] - presum[i]) % k == 0:
            return True
return False
```

但簡單用這個方法是過不了的會超時(TLE)

這邊我們可以先小小的改造原先的`presum`，原本我們是先用presum矩陣來計算`subarray和`，再去求餘數，像是：

`(presum[j] - presum[i]) mod k, j - i > 1`

但其實我們可以直接先求餘數，變為

`(presum[j] mod k) - (presum[i] mod k), j - i > 1`

更改完後我們發現，我們發現如果`presum[j]`跟`presum[i]`的餘數相同時即符合條件。

所以如此，我們可以將餘數存在一個hashtable，一旦發現該餘數已出現在hashtable中，則可以得解，若沒出現，則把該值存在表中。

另外還有一個小細節，如果餘數在表中，但$j - i <= 1$，則也不是解，但此時需不需要更新呢？

因為這題只需要判定是否符合條件即可，所以同樣餘數的狀況，索引(index)越靠前則越有機會成功，所以此時不需要更新。

## 程式碼

```python
class Solution(object):
    def checkSubarraySum(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: bool
        """
        prefix = 0
        mod_map = {0: -1}
        for i in range(len(nums)):
            prefix = (prefix + nums[i]) % k
            
            if prefix in mod_map:
                if i - mod_map[prefix] > 1:
                    return True
            else:
                mod_map[prefix] = i
        return False
```

## 時間複雜度

所以用`presum` + `hash table`的方法，時間複雜度為$O(n)$