---
layout: article_post
title:  "[Leetcode解題] 1248. Count Number of Nice Subarrays - 使用presum+hashtable解"
description:  "Count Number of Nice Subarrays"
categories: medium 
tags: array presum hash hashtable
langs: python
excerpt_separator: <!--more-->
---

## 題目

[1248. Count Number of Nice Subarrays](https://leetcode.com/problems/count-number-of-nice-subarrays/)

給定一個整數矩陣`nums`和一個整數`k`。如果一個連續子陣列包含恰好`k`個奇數元素，則稱其為漂亮子陣列`nice sub-arrays`。求全部漂亮子陣列的數量。

## 解題思路

這題的思路跟[523](https://www.catxcoder.com/medium/2024/05/18/523-Continuous-subarray-sum.html)蠻像的，我們都是要使用`presum`搭配`hashtable`來解題，這邊還有一些觀察，如果這邊的`presum`紀錄的是從開始到當前索引的奇數數字數量，那它會是一個遞增數列，舉例來說：

原數列：[1,1,2,1,1,1]

計算開始到當前索引的奇數個數：[1,2,2,3,4,5], k = 3

當我們求出這個數列後，可以搭配`hashtable`來記錄，每個回合我們要去找`num - k`有沒有存在於`hashtable`中，如果有的話，代表可以形成`nice sub-arrays`，並且可以形成`hashtable[num-k]`個。

以上面的例子舉例來說，在`idx=4, num=4`的那個點，若`k=3`，則要找`hashtable`中有沒有`1(4-3)`，有的話則代表有`hashtable[1]`個`nice sub-arrays`以4為結尾。

## 程式碼

```python
class Solution(object):
    def numberOfSubarrays(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: int
        """
        ht = {0: 1}
        
        num_nice_arr = 0
        cur = 0
        for num in nums:
            if num % 2 == 1:
                cur += 1
            ht.setdefault(cur, 0)
            ht[cur] += 1
            if cur - k in ht:
                num_nice_arr += ht[cur-k]
        return num_nice_arr
```

## 時間複雜度

所以我們只需進行一次迴圈，時間複雜度為$O(n)$