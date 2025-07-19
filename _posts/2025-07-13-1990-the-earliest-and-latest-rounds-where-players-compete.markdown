---
layout: article_post
title:  "[Leetcode解題] 1900. The Earliest and Latest Rounds Where Players Compete"
description:  "1900. The Earliest and Latest Rounds Where Players Compete"
categories: hard
tags: bit-operation bit
langs: python
excerpt_separator: <!--more-->
---

## 題目
[1900. The Earliest and Latest Rounds Where Players Compete](https://leetcode.com/problems/the-earliest-and-latest-rounds-where-players-compete/)

這是一個有 n 個玩家的淘汰賽。玩家們一開始會排成一列，編號從 1 到 n。每回合的比賽方式是：隊伍最前面的玩家會和隊伍最後面的玩家對戰，第二個玩家和倒數第二個玩家對戰，以此類推。如果玩家數量是奇數，中間的玩家會自動晉級到下一回合。每回合結束後，晉級的玩家會依照他們最初的編號順序重新排好。

題目中說，firstPlayer 和 secondPlayer 是最強的玩家，他們能擊敗其他所有玩家，直到他們兩個互相對戰。而其他玩家之間的對戰結果，你可以自由決定。

現在，給你總玩家數 n，firstPlayer 和 secondPlayer 的編號，請回傳一個包含兩個數字的陣列，分別代表這兩位最強玩家「最早」和「最晚」可能在哪個回合中對戰。

 <!--more-->
 
## 解題思路

因為如果對戰中沒有包含firstPlayer跟secondPlayer，會衍生出兩種可能

我們必須去考慮所有可能，並且從中選出最少跟最多的回合數

所以我們的思路是，先找出所有這類的對戰，然後窮舉所有的可能

因為每次對戰只會衍生出兩種可能，所以假設有n個這樣的對戰，會衍生出$2^n$種可能

我們可以透過bit operation來判斷所有可能

假設我們有8個這樣的對戰，所以我們要去判斷$2^8$個可能，可以直接用`1 << 8`得到

所以每一個數的位元可以代表該局是由誰獲勝，舉例來說`11000000`就表示第一二場由b獲勝，其他由a獲勝

可以透過`(mask >> idx) & 1`來判斷每一個位元是0還是1

這樣的操作讓我們可以比較高效的判斷完每一種可能

## 程式碼

```python
from functools import lru_cache

class Solution:
    def earliestAndLatest(self, n: int, firstPlayer: int, secondPlayer: int) -> list[int]:
        @lru_cache(None)
        def dp(n, i, j):
            if i + j == n + 1:
                return (1, 1)
            pairs = n // 2
            other = []
            for k in range(1, pairs + 1):
                left, right = k, n - k + 1
                if left != i and left != j and right != i and right != j:
                    other.append((left, right))
            mid = (n + 1) // 2
            m = (n + 1) // 2
            early, latest = float('inf'), 0
            tot = len(other)
            for mask in range(1 << tot):
                surv = []
                for idx, (left, right) in enumerate(other):
                    if (mask >> idx) & 1:
                        surv.append(right)
                    else:
                        surv.append(left)
                surv.append(i)
                surv.append(j)
                if (n % 2 == 1) and mid != i and mid != j:
                    surv.append(mid)
                surv.sort()
                e1, l1 = dp(m, surv.index(i) + 1, surv.index(j) + 1)
                early = min(early, e1 + 1)
                latest = max(latest, l1 + 1)
            return (early, latest)
            
        return list(dp(n, firstPlayer, secondPlayer))


```

## 時間與空間複雜度分析

每一次要判斷$2^{n-2}$種可能，每一次判斷需要跑過$n$個位元，並且做sort為$O(n+nlogn)$

可能有$O(n^2)$種不同的dp狀態，所以總共為$O(n^3 2^n logn)$