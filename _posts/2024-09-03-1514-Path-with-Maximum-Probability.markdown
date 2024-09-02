---
layout: article_post
title:  "[Leetcode解題]  1514. Path with Maximum Probability"
description:  "Dijkstra's Algorithm必寫題目，了解貪婪策略以及Priority Queue"
categories: medium
tags: greedy heap priority-queue dijkstra graph shortest-path
langs: python
excerpt_separator: <!--more-->
---

# 題目

[1514. Path with Maximum Probability](https://leetcode.com/problems/path-with-maximum-probability/)

給定一個無向圖，圖的每條Edge上表示一個機率，求從起始點到終點經過，有最大機率的那條路徑，若不存在則回傳0。

 <!--more-->

# Dijkstra's Algorithm思考

## Dijkstra's Algorithm 一般適用於求最短路徑

這題使用`Dijkstra's Algorithm`來解，大家不知道對這個演算法還有沒有印象，可以使用來找尋最短路徑，但我們這邊是要求最大機率乘積，是否適用呢？

我們先思考一下，在最短路徑的情況，`Dijkstra's Algorithm`其實是一種`貪婪(greedy)`的策略，我們每次都選擇距離起點最近的點(node)來做下一次更新，每次更新是更新鄰近點到起點的距離。

這樣我們一定能保證，不可能有一種情況是，我選一個距離起點較遠的點，但之後可以變得更近，這有一個前題，如果圖上的權重都是正的，就不可能發生這種狀況。

## Dijkstra's Algorithm 能求最長路徑嗎？

但反過來想，如果我們今天是要求`最長路徑`，這個假設就不成立。想像我們每次都選距離起點較遠的點，而有沒有可能我們能選一個距離起點較近的點，但後來卻能距離起點更遠走到終點？答案是可以的。所以如果今天是要求最長路徑，就不太適用`Dijkstra's Algorithm`。

我們回到這題，但這題不就是要求最大的機率嗎？這邊我們再思考一下如果今天是機率乘積的情況，是否適用這個貪婪策略。

我們每次選擇較大的機率，是否有可能存在一個路徑，可以透過選較小的機率而後達到更大機率，

答案是不可能，想像我們有一個起點分別有兩條edge為`0.2`跟`0.3`，我們今天一但走`0.2`，它後面乘以再大的乘積都不可能大於`0.3`，所以在機率乘積的情況下，此貪婪策略仍成立。

只是，這是因為`edge`的值域限制在`[0, 1]`的情況下才有此特性，如果不是的話，那麼`0.2`可以透過乘以像是`5`之類的，就會超越`0.3`，那貪婪策略就不成立。

所以`Dijkstra's Algorithm`在非常特定的情況下，是可以用來求最長路徑的。

我們這邊可以再做延伸思考，如果我們使用對數機率的話呢？因為對數機率值域介於[0, -inf]，並且此時路徑是透過相加而非相乘，是否此貪婪機率仍舊成立。

如果今天我們一個起點分別有兩條edge為`-0.6`跟`-0.3`，我們不可能能選`-0.6`然後得到一條比`-0.3`更大的路徑，因為`-0.6`再加只會變得更小，因為每個權重都是負權重。

# 解題思路

所以我們使用`Dijkstra's Algorithm`，可以透過一個`Priority Queue`來得到每次距離起點最短路徑的點，這樣每次只需$O(logn)$的時間。

所以這題的流程會是，我們從起點開始，得到鄰近點的路徑值（這邊為機率），如果大於鄰近點目前的最大路徑值，再加鄰近點加入`Priority Queue`中並且更新最大路徑值，因為如果小於的話就沒有加入的必要，因為同個點一定會有個比較大的路徑值在`max-heap`中。

但是，這樣仍有可能同個點在`Priority Queue`中被重複加入，如果在更新最大路徑值後，又再出現一條更大的路徑，這樣就會加入同樣的點，但是其實這不影響結果，因為較大路徑的會先被`pop`出並且更新，而後較小的一定沒辦法更新任何鄰近點的最大路徑值。不過，我們仍能加入一個判斷式避免重複計算。

這題還有許多小細節：

1. 由於如果我們使用機率乘積，有可能會讓誤差累積的越來越大，這時我們可以改用$log$，並且本來路徑之間是機率乘積，改成對數和。
2. 由於`heapq`預設是`min-heap`，但我們的情況是需要`max-heap`，所以我們可以乘以-1達到`max-heap`的效果

# 程式碼

```python
import heapq
import math
class Solution(object):
    def maxProbability(self, n, edges, succProb, start_node, end_node):
        """
        :type n: int
        :type edges: List[List[int]]
        :type succProb: List[float]
        :type start_node: int
        :type end_node: int
        :rtype: float
        """
        graph = dict()
        for i in range(n):
            graph[i] = []
            
        w = [float('-inf') for i in range(n)]
        
        for edge, prob in zip(edges, succProb):
            safeProb = float('-inf') if prob == 0 else math.log(prob)
            graph[edge[0]].append((edge[1], safeProb))
            graph[edge[1]].append((edge[0], safeProb))
        
        h = [(0, start_node)]  # max_heap
        
        while h:
            curLogProb, cur = heapq.heappop(h)
            
            if curLogProb < w[cur]:
                continue
            
            if cur == end_node:
                return math.exp(-1 * curLogProb)
            for neighbor, logProb in graph[cur]:
                nextLogProb = -curLogProb + logProb
                if nextLogProb > w[neighbor]:
                    w[neighbor] = nextLogProb
                    heapq.heappush(h, (-nextLogProb, neighbor))
        return 0.0
```

# 時間複雜度

$O(Elog(E))$，因為最壞的情況可能要走過每個Edge才找到最終的路徑，而heap中可能會有重複的點出現

