---
layout: article_post
title:  "[Leetcode解題] 433. Minimum Genetic Mutation"
description:  "433. Minimum Genetic Mutation"
categories: medium
tags: bfs graph
langs: python
excerpt_separator: <!--more-->
---

[433. Minimum Genetic Mutation](https://leetcode.com/problems/minimum-genetic-mutation/description/)

## 題目

給定一個基因序(startGene)，每次可以基因操控轉換一個字元，問能不能轉換成另一個基因序(endGene)，要注意的是，每次轉換的基因必須存在geneBank中，且endGene也必須存在geneBank中，否則回傳-1，題目問最少需要幾次操控才能轉換成功。

<!--more-->

## 解題思路

這題我們需要建立一個函式來判斷兩個基因的距離是否1，有的話就可以建立一條edge，再透過BFS來查找最短路徑。這題或許也可以使用雙向BFS，但因為其實geneBank的size也不大，所以應該還好，雙向BFS可以減少搜尋空間。

## 程式碼

```python
class Solution:
    def minMutation(self, startGene: str, endGene: str, bank: List[str]) -> int:
        def is_edge(a, b):
            dist = 0
            for char_a, char_b in  zip(a, b):
                if char_a != char_b:
                    dist += 1
            return dist == 1

        if startGene == endGene:
            return 0
        if endGene not in bank:
            return -1
        
        gene = [startGene] + bank + [endGene]
        v =  [0 for i in range(len(gene))]

        graph = [[] for i in range(len(gene))]
        for i in range(len(bank)+2):
            for j in range(i+1, len(bank)+2):
                if is_edge(gene[i], gene[j]):
                    graph[i].append(j)
                    graph[j].append(i)
    
        cur = 0
        queue = [(0, 0)]
        while queue:
            cur, dist = queue.pop(0)
            v[cur] = 1
            if cur == len(gene)-1:
                return dist
            for neighbor in graph[cur]:
                if not v[neighbor]:
                    queue.append((neighbor, dist+1))
        return -1
```

## 時間複雜度

$O(N^2 \dot L)$，N為基因序的數量，L是基因的長度，這裡為8