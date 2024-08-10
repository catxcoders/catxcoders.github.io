---
layout: article_post
title:  "[Leetcode解題]  959. Regions Cut By Slashes 以DFS解"
description:  "[Leetcode解題]  959. Regions Cut By Slashes"
categories: medium
tags: graph dfs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[959. Regions Cut By Slashes
](https://leetcode.com/problems/regions-cut-by-slashes/)

一個 n x n 的網格由 1 x 1 的方格組成，每個方格內包含 '/', '\\' 或空格 ' '，這些字符將方格劃分為連續的區域。給定表示為字符串數組的網格 grid，返回區域的數量。

## 解題思路

這題可以用圖的思路來想，每個區域如果可以跟旁邊的區域連通，那就是有一條Edge，然後我們用計算有多少個`connected graph`就等同於有多少連通區域。

但如果是原來的樣子，我們會不太好計算連通區域，我們可以把每個點再切更小，然後把斜線的區域以'x'表示，這麼以來我們只要簡單的判斷上下左右是否遇到'x'，如果遇到則不能走。

我們可以看兩個例子：

例子1
["/\\","\\/"]
我們把它展開細分後3x3會變成
```python
001100
010010
100001
100001
010010
001100
```

例子2
["//","/ "]

```python
001001
010010
100100
001000
010000
100000
```

所以切分後，我們只要把0的區域流通即可，可以透過DFS

## 程式碼

```python=
class Solution(object):
    def regionsBySlashes(self, grid):
        """
        :type grid: List[str]
        :rtype: int
        """
        def dfs(i, j, subgrid):
            subgrid[i][j] = 'v'
            if i > 0 and subgrid[i-1][j] == ' ':
                dfs(i-1, j, subgrid)
            if i < len(subgrid)-1 and subgrid[i+1][j] == ' ':
                dfs(i+1, j, subgrid)
            if j > 0 and subgrid[i][j-1] == ' ':
                dfs(i, j-1, subgrid)
            if j < len(subgrid)-1 and subgrid[i][j+1] == ' ':
                dfs(i, j+1, subgrid)
            
        n = len(grid)
        subgrid = [[' ' for i in range(n*3)] for j in range(n*3)]
        for i in range(n):
            for j in range(n):
                if grid[i][j] == '/':
                    subgrid[i*3][j*3+2] = 'x'
                    subgrid[i*3+1][j*3+1] = 'x'
                    subgrid[i*3+2][j*3] = 'x'
                elif grid[i][j] == '\\':
                    subgrid[i*3][j*3] = 'x'
                    subgrid[i*3+1][j*3+1] = 'x'
                    subgrid[i*3+2][j*3+2] = 'x'
        total = 0
        for i in range(n*3):
            for j in range(n*3):
                if subgrid[i][j] == 'x':
                    continue
                if subgrid[i][j] == 'v':
                    continue
                dfs(i, j, subgrid)
                total += 1
        return total
```

## 時間複雜度

因為我們要跑過所有切分過的小格子，所以時間複雜度為$O(3 \times 3 \times n \times n)=O(n^2)$