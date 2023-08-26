---
layout: article_post
title:  "[Leetcode解題] Detonate the Maximum Bombs - 使用圖算法"
description: "[Leetcode解題] Detonate the Maximum Bombs - 使用圖算法"
categories: medium
tags: dfs graph
langs: python
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [2101. ](https://leetcode.com/problems/detonate-the-maximum-bombs/)

# 題目

給定一個列表，列表中的每個元素有三個組成元素，$(x, y, r)$表示圓中心點的位置，以及其半徑$r$，每個點表示一顆炸彈，圓的面積表示炸彈可以炸的範圍，爆炸時會引爆其他炸彈，題目要求，若只能引爆一顆炸彈，最多可以引爆幾顆炸彈。

# 解題思路

這題一開始會想說能不能使用貪婪算法(greedy)，因為如果是一維的狀況，確實可以透過排序(sort)+貪婪(greedy)的方法求。

我們發現，炸彈引爆的關係，其實可以透過圖來表示，如果炸彈$A$可以引爆炸彈$B$，那麼我們給$A \rightarrow B$，此圖為有向圖，因為$A \rightarrow B$不一定表示$B \rightarrow A$。我們求的是，從圖上某一個點，能夠走到的點的數量最多，這是比較特別的，因為通常圖的問題是要求最長路徑等等，就能透過深度搜尋來求。

所以，我們要求「從圖上某一個點，能夠走到的點的數量最多」，可以試過從所有的點出發，然後計算能踏過的所有的點的數量，最後再求最大值。

我們可以看下圖的一個狀況，假如我們先選引爆$D$，我們知道$D$可以引爆$A, B, C$，假如我們是用一般$DFS$的話，我們紀錄引爆的數量為4，但是下一回合，假如我們選到$E$，我們不能直接用紀錄的D數量，因為這樣的話$B$這個點會被重複計算到。


```graphviz
digraph {
node [style="filled" height=0.3]
node [fillcolor=lightblue] D
node [fillcolor=lightgray]
D -> C
C->A
C->B
}
```

```graphviz
digraph {
node [style="filled" height=0.3]
node [fillcolor=lightblue] E
node [fillcolor=lightgray]
E -> D
E -> B
D -> C
C->A
C->B
}
```



```python=
import math

class Solution:

    def traverse(self, cur, v, g, count, n):
        if v[cur] == 1:
            return 0
        # v[cur] == 0
        v[cur] = 1
        count += 1
        for i in range(n):
            if g[cur][i]:
                count += self.traverse(i, v, g, 0, n)
        return count


    def maximumDetonation(self, bombs: List[List[int]]) -> int:
        g = [[False for i in range(len(bombs))] for j in range(len(bombs))]

        for idxA, bombA in enumerate(bombs):
            for idxB, bombB in enumerate(bombs):
                if idxA == idxB:
                    continue
                dist = math.sqrt(pow(bombB[0] - bombA[0], 2) + pow(bombB[1] - bombA[1], 2))
                if dist <= bombA[2]:
                    g[idxA][idxB] = True


        maximum = 0
        for i in range(len(bombs)):
            v = [0 for i in range(len(bombs))]
            num_of_bombs = self.traverse(i, v, g, 0, len(bombs))
            if num_of_bombs > maximum:
                maximum = num_of_bombs
        return maximum

```

# 複雜度

假設炸彈的數量為$n$，我們要先求炸彈之間能不能互相引爆，所以為$O(n^2)$，再來，我們要試從$n$個點出發，最多走過$n$個點，也是$O(n^2)$，所以時間複雜度為$O(n^2)$

空間複雜度需用一個二維矩陣來記錄炸彈引爆關係，故也是$O(n^2)$