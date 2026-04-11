---
layout: article_post
title:  "[Leetcode解題] 2560. House Robber IV"
description:  "2560. House Robber IV"
categories: medium
tags: array greedy binary-search
langs: python
excerpt_separator: <!--more-->
---

[2560. House Robber IV](https://leetcode.com/problems/house-robber-iv/description/)

<!--more-->

# 題目

這題的題目非常繞，給定一個矩陣表示房屋內的金錢，小偷不能偷相鄰的房屋，而且至少要偷`k`間房屋

小偷的`capability`表示小偷偷的房屋中最多錢的數目

因為小偷在符合條件下，可以有多種不同的偷法，題目要求小偷最小的capacbility為何

# 解題心得

這題我覺得有點難度，我們使用`Binary Search`搭配`Greedy`來解，我們要找偷k間房屋最小的報酬。

這邊可以將題目轉化一下，如果目前的`capability`是`x`，那我是不是能找到符合的`k`間房屋（不相鄰）來偷

那我們只要找到符合此條件下的最小的`x`，即是題目的解

另外，我們在找符合的`k`間房屋的時候，可以透過`Greedy`來找，因為我們一定想選越靠左越好的

# 題目類型

這類型的題目，我把他稱為「在答案值域內直接二分搜尋」類型的題目

通常二分搜尋法，直覺會是在給定的矩陣內搜尋，但項是這題或相似類型的題目

有一種是直接對可能的答案解中做搜尋，並且有判斷條件內移動二分搜尋的範圍

所以有時候可能得往這種可能性去想，才不會困在題目框架中

# 程式碼

```python
class Solution:
    def minCapability(self, nums: List[int], k: int) -> int:
        min_reward, max_reward = min(nums), max(nums)

        while min_reward < max_reward:
            mid = (min_reward + max_reward) // 2
            possible_thefts = 0

            i = 0
            while i < len(nums):
                if nums[i] <= mid:
                    possible_thefts += 1
                    i += 2
                else:
                    i += 1
            if possible_thefts >= k:
                max_reward = mid
            else:
                min_reward = mid + 1
        return min_reward

```

# 時間複雜度

假設最大報酬為m，做二分搜尋法為$O(log(m))$，每次搜尋要判斷又沒有符合條件要遍歷一次房屋矩陣為$O(n)$

總時間複雜度為$O(nlog(m))$