---
layout: article_post
title:  "[Leetcode解題] Maximal Network Rank - 圖算法"
description: "[Leetcode解題] 經典Leetcode必刷題目"
categories: medium
tags: graph rank
langs: python
excerpt_separator: <!--more-->
---

# 題目
[1615. Maximal Network Rank](https://leetcode.com/problems/maximal-network-rank/)
給定$n$個城市，每個城市之間可以連結道路，給定一個陣列$roads$描述任兩城市之間的道路，求最大的`network rank`為何? 

 <!--more-->

# 解題思路

這題很單純，我們就是直接去窮舉所有可能，首先計算每個城市的`rank`，再去加總任兩城市間的`network rank`。

# 實作
```python
class Solution:
    def maximalNetworkRank(self, n: int, roads: List[List[int]]) -> int:
        graph = [[0 for i in range(n)] for j in range(n)]
        for road in roads:
            i, j = road
            graph[i][j] = 1
            graph[j][i] = 1
        count = [0 for i in range(n)]
        for i in range(n):
            count[i] = sum(graph[i])
        
        max_val = -1
        for i in range(n):
            for j in range(i+1, n):
                val = count[i] + count[j]
                val = val-1 if graph[i][j] == 1 else val
                max_val = max_val if val < max_val else val
        return max_val
```

# 複雜度

驗證任意兩點的組合，時間複雜度為$O(n^2)$