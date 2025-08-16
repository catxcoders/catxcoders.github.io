---
layout: article_post
title:  "[Leetcode解題] 743. Network Delay Time"
description:  "743. Network Delay Time 經典求最小路徑題目"
categories: medium
tags: shortest-path graph 
langs: python
excerpt_separator: <!--more-->
---

# 743. Network Delay Time

## 題目

[743. Network Delay Time](https://leetcode.com/problems/network-delay-time/description/?envType=problem-list-v2&envId=shortest-path)

給定一個有向圖，node表示一個網路節點，edge表示信號從一個節點傳到另一個節點須花費的時間，求少需花多久時間可以將信號傳送到所有節點，如果無法傳送到所有節點的話，回傳-1

 <!--more-->

## 解題思路

這題就是經典的shortest path題目，因為我們要求所有節點最快接受到信號的時間，而對所有節點時間取max，也就是題目所要求的，傳送到所有節點的最短時間。

因此我們可以使用Dijkstra搭配heap來解

我們首先要先建立一個矩陣，他存放每個節點最快接收到信號的時間，當該節點被遍歷時，則該值就會鎖定不會再改變（因為edge為正整數）

每次我們從heap中pop一個節點，也就是當前信號會播送到的點，如果這個點已經有存放值，並且比當前時間短，那代表該點已經遍歷完畢，所以可以跳過。

反之，我們接著遍歷該點的neighbor，計算edge+當前時間即為經當前節點到下個節點的時間，更新並加入到heap中

## 程式碼

```python
import heapq
class Solution:
    def networkDelayTime(self, times: List[List[int]], n: int, k: int) -> int:
        # dijkstra to calculate the shortest path for all the nodes
        _INF = n * 100 + 1
        dists = [_INF] * (n+1)
        dists[0] = 0  # not used
        dists[k] = 0

        edges = [[] for i in range(n+1)]

        for u, v, w in times:
            edges[u].append((v, w))
        
        pq = [(0, k)]

        while pq:
            cur_dist, cur = heapq.heappop(pq)

            # Out-dated
            if cur_dist > dists[cur]:
                continue

            for neighbor, w in edges[cur]:
                if cur_dist + w < dists[neighbor]:
                    dists[neighbor] = cur_dist + w
                    heapq.heappush(pq, (cur_dist + w, neighbor))
        
        min_time = max(dists)
        return min_time if min_time != _INF else -1
```


### 遞迴

$O((V+E)log(V))$

