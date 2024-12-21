---
layout: article_post
title:  "[Leetcode解題] 2872. Maximum Number of K-Divisible Components"
description:  "2872. Maximum Number of K-Divisible Components"
categories: hard
tags: dfs 
langs: python
excerpt_separator: <!--more-->
---

# 題目

[2872. Maximum Number of K-Divisible Components](https://leetcode.com/problems/maximum-number-of-k-divisible-components/)

這題給定一棵樹，包含從0到n-1的點，另外給定一個矩陣edges表示相連的點，以及一個values表示各點上的值。

題目另外給定一個數k，求我們最多可以把這棵樹切成幾個connected graph，並且每個graph上點的值(values)和可以被k整除。

這題題目較難理解，可以搭配題目網址的圖看。

<!--more-->

# 解題方式

首先我們要注意到給定的一定是一棵樹，所以會是一個單獨的connected component，並且不會有loop

我們可以使用DFS，從樹的底端開始進行，往上慢慢算總和，到每個點的時候，會計算包含該點以下所有點總和的值。

所以從Leaves開始，如果該點的值可以被k整除，那麼我們理論上就可以斷開連結。

我們在計算每個點的總和值的時候，只需要計算除以k餘數的部分，想像如果我有一個點A並且連結到左點B以及右點C。

如果右點C的值已經是整除k了，那麼我可以直接斷開他

如果左點B的值帶有餘數1，那這個值會被往上貢獻回A（因為他們還是連接的狀態）

# 程式碼

```python
class Solution:
    
    count = 0
    
    def maxKDivisibleComponents(self, n: int, edges: List[List[int]], values: List[int], k: int) -> int:
        
        def dfs(cur, parent, graph, values, k):
            sum_values = 0
            for neighbor in graph[cur]:
                if neighbor != parent:
                    sum_values += dfs(neighbor, cur, graph, values, k)
                    sum_values %= k
            
            sum_values += values[cur]
            sum_values %= k
            
            if sum_values == 0:
                self.count += 1
            return sum_values     
        
        graph = [[] for i in range(n)]
        for edge in edges:
            graph[edge[0]].append(edge[1])
            graph[edge[1]].append(edge[0])
        
        dfs(0, -1, graph, values, k)
        return self.count
```

# 時間複雜度

因為我們我們要走過所有nodes跟所有edges，所以複雜度為 $O(n+m)$

但要注意的是，因為這一定是樹，所以edges的數量為n-1（題目的constraints部分也有註記）