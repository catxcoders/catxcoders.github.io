---
layout: article_post
title:  "[Leetcode解題] 3186. Maximum Total Damage With Spell Casting"
description:  "3186. Maximum Total Damage With Spell Casting"
categories: medium
tags: dp
langs: python
excerpt_separator: <!--more-->
---

# 3186. Maximum Total Damage With Spell Casting

# 題目

[3186. Maximum Total Damage With Spell Casting](https://leetcode.com/problems/maximum-total-damage-with-spell-casting/description/?envType=daily-question&envId=2025-10-11)

題目給一個整數陣列 power，代表了一系列法術的傷害值。您可以施放任意數量的法術，但有一個重要的限制：

如果施放了一個傷害值為 p 的法術，那麼就不能再施放傷害值為 p-1、p-2、p+1 或 p+2 的法術。

目標是，在遵守這個規則的前提下，最大化您能造成的總傷害。

舉個例子：
假設 power = [1, 1, 3, 4]

如果選擇傷害為 4 的法術，總傷害是 4。那就不能再選 3 了。接著可以選 1，因為 1 和 4 的差大於 2。所以可以選兩個 1。總傷害是 4 + 1 + 1 = 6。

如果選擇傷害為 3 的法術，總傷害是 3。那就不能選 1 和 4。總傷害就是 3。

比較之下，最大總傷害是 6。

<!--more-->

# 解題思路

這題我們先計算每個法術傷害值出現的次數，並且用一個hashset來表示所有不同傷害值的法術，再進行sort由大排到小

接下來使用dp求解，dp存放的是，考慮到該法術時，能造成的最大傷害為何？

所以每次做的時候，可以施放該法術，或者不施放法術，來求得當前的dp值

如果施放法術p，那麼當前的dp值為

```
dp[i] = p * counts[p] + dp[last_p_idx]
```

last_p_idx為上一個在法術限制範圍外，可施放法術的索引，我們要取得他的dp值

如果不施放法術p，那dp值即為上一個法術的dp值（考慮到i-1），最後取兩者最大的值

```
dp[i] = max(take_p, not_take_p)
```


# 程式碼

```python
class Solution:
    def maximumTotalDamage(self, power: List[int]) -> int:
        counts = Counter(power)
        unique_power = sorted(counts.keys())
        
        n = len(unique_power)
        dp = [0] * n

        for i in range(n):
            p = unique_power[i]
            current_damage = p * counts[p]

            last_p_idx = -1
            for j in range(i-1, -1, -1):
                if unique_power[j] < p - 2:
                    last_p_idx = j
                    break
            
            take_p = current_damage + dp[last_p_idx] if last_p_idx != -1 else current_damage

            not_take_p = dp[i-1] if i >= 1 else 0

            dp[i] = max(take_p, not_take_p)
        return dp[-1]

```

# 時間複雜度

遍歷過一遍，但有做sort，所以為$O(n log n)$，$n$為不重複法術傷害的數量