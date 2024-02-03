---
layout: article_post
title:  "[Leetcode解題] 200. Number of Islands - DFS解"
description:  "[Leetcode解題] 200. Number of Islands - DFS解"
categories: medium amazon microsoft apple google nvidia
tags: dfs bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[200. Number of Islands](https://leetcode.com/problems/number-of-islands/)

給定一個m x n的2D二進制網格grid，代表一張地圖，其中'1'代表陸地，'0'代表水域。請計算並返回地圖上的島嶼數量。

島嶼是由水域包圍並由相鄰的陸地水平或垂直連接形成的。請注意，網格的四個邊緣都被水域包圍。
<!--more-->



## 解題思路
這個問題可以使用深度優先搜尋(DFS)或廣度優先搜尋(BFS)的方式解決。我們可以遍歷整個網格，當遇到一個陸地'1'時，就開始一個搜尋過程，將相鄰的陸地都標記為已訪問，直到遍歷完整個島嶼。這樣，我們就能確保每個島嶼只被計算一次。

## Python實作
```python
class Solution:
    def numIslands(self, grid: List[List[str]]) -> int:
        if not grid or not grid[0]:
            return 0
        
        def dfs(i, j):
            # 檢查邊界條件
            if i < 0 or i >= len(grid) or j < 0 or j >= len(grid[0]) or grid[i][j] == '0':
                return
            
            # 將目前的陸地標記為已訪問
            grid[i][j] = '0'
            
            # 遞歸搜尋相鄰的陸地
            dfs(i+1, j)
            dfs(i-1, j)
            dfs(i, j+1)
            dfs(i, j-1)
        
        island_count = 0
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j] == '1':
                    # 若遇到陸地，開始搜尋並增加島嶼數量
                    island_count += 1
                    dfs(i, j)
        
        return island_count
            
```

## 時間複雜度
時間複雜度為$O(m * n)$，其中m和n分別是網格的行數和列數。這是因為我們需要遍歷整個網格，並在每個陸地上進行DFS操作。