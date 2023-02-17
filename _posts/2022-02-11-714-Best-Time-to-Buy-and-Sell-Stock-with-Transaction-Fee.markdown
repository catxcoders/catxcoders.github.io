---
layout: custom_post
title:  "714. Best Time to Buy and Sell Stock with Transaction Fee"
date:   2022-02-11 21:27:53 +0800
categories: medium, greedy, coder
---

## 題目
給定一個數組prices，其中prices[i]表示第i天的股票價格，以及一個代表交易費用的整數fee。

找到您可以實現的最大利潤。您可以進行任意多次交易，但每次交易都需要支付交易費用。

注意：您不能同時進行多個交易（即，在買入股票之前必須先將其出售）。
題目網址: [714. Best Time to Buy and Sell Stock with Transaction Fee](https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-transaction-fee/)


## 解題思路
解法：貪心算法

將問題分成多個「區間」來考慮，每個區間的結尾就是購買的時間，在接下來的最低價格時出售股票。

## 算法
我們可以使用貪心算法來解決這個問題。我們在數組的每一個元素之間跳躍，如果當前元素的價格比下一個元素的價格高，則我們將當前元素出售，並使用下一個元素購買，同時累加利潤。

## 實作

```python=
class Solution:
    def maxProfit(self, prices: List[int], fee: int) -> int:
        cash, hold = 0, -prices[0]
        for i in range(1, len(prices)):
            cash = max(cash, hold + prices[i] - fee)
            hold = max(hold, cash - prices[i])
        return cash
```


## 複雜度
因為只需要遍歷一遍股價序列，所以是 $O(n)$ 的。