---
layout: article_post
title:  "[Leetcode解題] 2563. Count the Number of Fair Pairs"
description:  "2563. Count the Number of Fair Pairs"
categories: medium
tags: array binary-search
langs: python
excerpt_separator: <!--more-->
---

# 題目
[2563. Count the Number of Fair Pairs](https://leetcode.com/problems/count-the-number-of-fair-pairs/description/?envType=daily-question&envId=2025-04-19)

給定一個矩陣，以及上界(upper bound)跟下界(lower bound)，找一對數字相加後介於之間，求符合條件之數目。

<!--more-->

# 解題思路

這題我們可以使用暴力法，去比較所有對數，但這樣時間複雜度為$O(n^2)$。我們可以先透過排序，再透過binary search來比較快速的找到upper bound跟lower bound，這樣時間複雜度為$O(nlogn)$。

這邊binary search不是要直接找某個數字，而是要找upper bound跟lower bound，所以會有點不同，但這也是蠻常見的兩個操作。

我們要找第一個比lower bound大的數字，跟最後一個比upper bound小的數字，求這個範圍的大小就是能形成的`fair pairs`數目。

這兩個操作，可以透過`bisect.bisect_left`跟`bisect.bisect_right`來達成

我們可以這樣來記憶`bisect`的用法，它會找到元素插入在序列的位置，並使原序列保持排序好的狀態。

兩者的差別主要是等於的狀態下，是插入成為第一個（最左），還是最後一個（最右）

所以在我們這個情況，我們要用`bisect_left`去找lower bound，找到的位置會是第一個`>=lower_bound`的索引，若找不到則會是回傳`len(a), a是給定排序好的序列`（序列最後）

要用`bisect_right`去找upper bound，找到的位置會是第一個`>upper_bound`的索引，若比序列中所有元素都大，那也是回傳`len(a)`

來看一個例子，假設序列

`1,2,3,4,5,5,5,6,7,8`, `lower_bound=3`, `upper_bound=5`，`bisect_left`會找到`index=2`，`bisect_right`會找到`index=7`，所以中間有`7-2=5`個元素

# 程式碼

```python
class Solution:
    def countFairPairs(self, nums: List[int], lower: int, upper: int) -> int:
        nums = sorted(nums)
        num_fair_pairs = 0
        for i in range(len(nums)-1):

            lidx = bisect.bisect_left(nums, lower-nums[i], i+1)
            ridx = bisect.bisect_right(nums, upper-nums[i], i+1)

            if ridx - lidx >= 0:
                num_fair_pairs += ridx - lidx
        return num_fair_pairs
```

# 時間複雜度

做排序跟對每個元素做一次BS，時間複雜度為$O(nlogn)$
