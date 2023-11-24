---
layout: article_post
title:  "[Leetcode解題] 994. rotted oranges - BFS"
description: "[Leetcode解題] 經典Leetcode必刷題目"
categories: medium
tags: graph bfs graph
langs: python
excerpt_separator: <!--more-->
---

# 題目
[994. rotted oranges](https://leetcode.com/problems/rotting-oranges/)

這題題目給定一個二維矩陣，矩陣中每個值代表一顆橘子的狀態，橘子的狀態可能有三種，可能為`腐爛(2)`, `新鮮(1)`, `空(0)`，如果空代表該格沒有橘子。

每過一秒，腐爛的橘子會讓其上下左右的橘子也變腐爛，題目問過幾秒後，所有橘子都會腐爛，如果沒辦法使所有橘子腐爛，則回傳`-1`

<!--more-->

# 解題思路

這題我們首先就會想到該二維矩陣可以轉換成一個`graph`，這個graph可能有好幾個`connected component`，只要任一個裡面沒有腐爛的橘子，那就沒辦法使所有橘子腐爛。

因為這題想要求最短時間，我們會想到使用`BFS`，用一個矩陣存剛變腐爛的橘子，每次往前走一步，就把鄰近的橘子便腐爛並放到矩陣中，如果矩陣為空就代表走完了。

走完的時候可能代表兩種情況，可能是所有橘子都變腐爛了，所以此步數即為答案，也有可能還有剩下我們永遠接觸不到的新鮮橘子，需要回傳為`-1`。

再來，我們來考慮`edge cases`，如果一開始發現矩陣裡面都沒有腐爛的橘子，有可能是以下兩種狀況：

1. 矩陣裡都是空的，這樣代表在時間t=0的時候，所有橘子(0顆)都變腐爛了，所以回傳`0`
2. 矩陣裡有橘子但沒有腐爛的橘子，這樣無法成功，所以回傳`-1`

# 實作
```python
class Solution:
    def nearby(self, grid, i, j):
        if i-1 >= 0:
            yield i-1, j
        if j-1 >= 0:
            yield i, j-1
        if i+1 < len(grid):
            yield i+1, j
        if j+1 < len(grid[0]):
            yield i, j+1

    def orangesRotting(self, grid: List[List[int]]) -> int:
        rotted_oranges = []
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j] == 2:
                    rotted_oranges.append((i, j))
        if not rotted_oranges:
            if sum([sum(row) for row in grid]) == 0:
                return 0
            return -1
        
        t = 0
        while True:
            next_rotted_oranges = []
            for (ri, rj) in rotted_oranges:
                for i, j in self.nearby(grid, ri, rj):
                    if grid[i][j] == 1:
                        grid[i][j] = 2
                        next_rotted_oranges.append((i, j))
            if not next_rotted_oranges:
                break
            rotted_oranges = next_rotted_oranges
            t += 1
        
        for row in grid:
            for orange in row:
                if orange == 1:
                    return -1
        return t
```

# 時間複雜度

因為我們需要遍歷整個二維矩陣，所以時間複雜度維$O(nm)$