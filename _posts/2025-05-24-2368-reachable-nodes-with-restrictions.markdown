---
layout: article_post
title:  "[Leetcode解題] 2368. Reachable Nodes With Restrictions"
description:  "2368. Reachable Nodes With Restrictions"
categories: medium
tags: tree dfs bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[2368. Reachable Nodes With Restrictions](https://leetcode.com/problems/reachable-nodes-with-restrictions/)

給定一個樹，還有圖上連接每個點的edges，還有一個restricted的node是不能經過的，求從0出發點可以到達幾個點。

 <!--more-->
 
## 解題思路

這題其實蠻簡單的，我們只要從0開始進行DFS或者BFS就可以，但我做了兩個比較特別的事情：

1. 把restricted轉成set，這樣我們判斷的時候只要$O(1)$
2. 把經過的點加入restricted，因為經過的點我們也不能讓它重新造訪

## 程式碼

```python
class Solution:
    def reachableNodes(self, n: int, edges: List[List[int]], restricted: List[int]) -> int:
        graph = [[] for i in range(n)]
        for a, b in edges:
            graph[a].append(b)
            graph[b].append(a)
        
        restricted = set(restricted)

        visited = 0
        queue = [0]
        while queue:
            cur = queue.pop()
            if cur in restricted:
                continue
            restricted.add(cur)
            visited += 1
            queue += graph[cur]
        return visited
```

## 時間複雜度

edge數量為`m`，node數量為為`n`，要先造graph複雜度為$O(m)$，再來最糟的情況要traverse過每一個點為$O(n)$，每次造訪每個點要判斷有沒有在restricted裡面，因為我們使用hash table，所以為$O(1)$，總時間複雜度為$O(m+n)$。
