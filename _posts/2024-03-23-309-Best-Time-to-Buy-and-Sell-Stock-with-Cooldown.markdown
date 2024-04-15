---
layout: article_post
title:  "[Leetcode解題] 309. Best Time to Buy and Sell Stock with Cooldown"
description:  "[Leetcode解題] 309. Best Time to Buy and Sell Stock with Cooldown"
categories: medium 
tags: dp dynamic-programming 
langs: python
excerpt_separator: <!--more-->
---

# 309. Best Time to Buy and Sell Stock with Cooldown

# 題目

[309. Best Time to Buy and Sell Stock with Cooldown](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/)

想像你在買賣股票，給定一個股票價格的序列表示每天的股價，每次可以選擇買或是賣，如果賣出的時候，會有一天的cooldown不能買，每次只能持有一個股票。
 <!--more-->

# 解題思路

這題我們可以從有限狀態機(finite state machine)的想法來切入，每天我們會有三種可能的狀態，`hold(持有股票)`、`not_hold(沒有股票)`、`cooldown(不能買賣的一天)`，同時，每天可以的三種行為（買、賣、不動），可以改變狀態。

hold可能是`not_hold`的狀態下買股票，或者 `hold`不買賣的狀態，寫成:

```python
hold = max(not_hold-price, hold)
```

這邊要加max，是因為我們想要最優的情況，用低的價格買股票的情況。

假設題目給的價格是[1,2,10]

在2的時候，可能是已經在1買的hold，或者1選擇沒買的not_hold，所以取值max之後，得到max(0-2, -1)=-1，隱含我們選擇hold，倒推回去表示應該要在1就買。

# 程式碼

```python
class Solution(object):
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        not_hold, cooldown, hold = 0, float('-inf'), float('-inf')
        for price in prices:
            hold, not_hold, cooldown = max(not_hold-price, hold), max(cooldown, not_hold), hold+price
        return max(not_hold, cooldown)
```

# 時間複雜度

遍歷過一次矩陣，所以為$O(n)$