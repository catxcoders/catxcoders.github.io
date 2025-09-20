---
layout: article_post
title:  "[Leetcode解題] 785. Is Graph Bipartite?"
description:  "785. Is Graph Bipartite?"
categories: medium
tags: greedy graph
langs: python
excerpt_separator: <!--more-->
---

## 題目

[785. Is Graph Bipartite?](https://leetcode.com/problems/is-graph-bipartite/?envType=problem-list-v2&envId=graph)

給一個undirected graph，要判斷是不是bipartite，也就是可以將所有的點分為兩個group，並且所有的edge都是連接A跟B的點

<!--more-->

## 解題思路

我們這題有點需要採取`greedy`的思路，我們假設就是要把點分成兩類，我們記錄成`第1組`跟`第2組`

今天如果這個點還沒被分組，那我就預設把它分到`第1組`，之後跟它相鄰的點自動就要被歸類到`第2組`

之後，因為與它相鄰的點確定了，所以我接下來換看該點（用一個stack來存確定的點），並將相鄰的點設成另外一組，過程中，如果發現有衝突發生，表示該圖非`bipartite`，所以就可以直接回傳False

因為題目說不保證為`connected graph`，所以我們一開始要把所有的點都放到stack中，已保證我們可以看到所有的點

## 程式碼

```python
class Solution:
    def isBipartite(self, graph: List[List[int]]) -> bool:
        # 0 means not classified, 1 means group 1, and 2 means group 2
        group = [0] * len(graph)
        v = [0] * len(graph)

        stack = [i for i in range(len(graph))]

        while stack:
            cur = stack.pop()
            if v[cur] == 1:
                continue
            v[cur] = 1
            if group[cur] == 0:
                group[cur] = 1
            
            another = 2 if group[cur] == 1 else 1
            for neighbor in graph[cur]:
                if group[neighbor] == 0:
                    group[neighbor] = another
                    stack.append(neighbor)
                elif group[neighbor] == group[cur]:
                    return False
        return True
```

## 時間複雜度

會需要看到所有的node跟edge，所以複雜度為$O(E+V)$