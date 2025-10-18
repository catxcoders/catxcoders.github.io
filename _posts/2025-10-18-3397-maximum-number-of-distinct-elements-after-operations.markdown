---
layout: article_post
title:  "[Leetcode解題] 3397. Maximum Number of Distinct Elements After Operations"
description:  "3397. Maximum Number of Distinct Elements After Operations"
categories: medium
tags: greedy
langs: python
excerpt_separator: <!--more-->
---

## 題目
[3397. Maximum Number of Distinct Elements After Operations](https://leetcode.com/problems/maximum-number-of-distinct-elements-after-operations/description/?envType=daily-question)

給一個整數陣列nums，還有一個k，每次可以至多對每個元素做1個操作，每次操作可以+[-k, k]，求最多可以有多少個distinct的數字。

<!--more-->

## 解題思路（Greedy 貪心）

這題我們可以使用greedy，我們先對數列做sort，之後列出每個數字調整後可能的數字區間，之後我們就慢慢從低挑到高，這樣必定能使得後面的區間有更多選擇，所以會是最優


## Python實作

```python
class Solution:
    def maxDistinctElements(self, nums: List[int], k: int) -> int:
        nums.sort()
        current = -float('inf')
        count = 0

        for num in nums:
            L, R = num - k, num + k

            if current < L:
                current = L

            if current <= R:
                count += 1
                current += 1
        return count
```

## 時間與空間複雜度

做一次sort，所以是 $O(nlogn)$
