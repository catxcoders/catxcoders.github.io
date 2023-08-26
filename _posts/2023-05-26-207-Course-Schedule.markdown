---
layout: article_post
title:  "[Leetcode解題] Course Schedule - 使用DFS解法"
description: "[Leetcode解題] Course Schedule - 使用DFS解法"
categories: medium
tags: dfs
langs: python
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [207. ](https://leetcode.com/problems/course-schedule)

# 題目

這題我們給定一個序列，序列中的元素為課程編號以及其先修課程，舉例來說[$a_i$, $b_i$]代表我們必須先修過$b_i$才能選修$a_i$。另外會給定課程總數$numCourses$，課程的編號從$0$至$numCourses-1$，而題目要求我們是否能夠完成全部課程。

# 解題思路

我們發現當課程先修的關係有一個循環的時候，那麼就沒辦法修循環中的所有課程，於是這題可以看做一個判斷圖(graph)中是否有循環的題目。

我們如果從每個點都走到盡頭，而沒有循環出現的話，那這個圖就沒有循環，於是我們可以想出使用`DFS`來進行：

```python
def contains_cycle(i):
    if v[i] == 1:
        return True
    for j in graph[i]: # i點所連結的所有點
        if contains_cycle(i):
            return True
    return False

...
for i in range(numCourses):
    v = [0] * numCourses
    if contains_cycle(i):
        return False
return True
```

不過，上述的程式碼中，你會發現有許多重複計算的部分，對於每個點來說，從該點出發後是否會碰到循環的結果是固定的，所以我們每個點只要經過一次就可以，我們可以使用一個矩陣`v`來記錄拜訪的狀態，如果狀態為

`v[i]=1`: 代表此點已經確定沒有包含循環(loop)
`v[i]=-1`: 代表此點正在被拜訪中，也就是是DFS前面經過的點之一，表示循環出現
`v[i]=0`: 代表此點沒有被拜訪過

```python
class Solution(object):
    def canFinish(self, numCourses, prerequisites):
        """
        :type numCourses: int
        :type prerequisites: List[List[int]]
        :rtype: bool
        """
        def dfs(i):
            if v[i] == -1:
                return False
            if v[i] == 1:
                return True
            v[i] = -1 # visiting
            for j in graph[i]:
                if not dfs(j):
                    return False
            v[i] = 1 # visited
            return True

        graph = {}
        for i in range(numCourses):
            graph[i] = []
        for pre in prerequisites:
            graph[pre[1]].append(pre[0])

        v = [0] * numCourses
        for i in range(numCourses):
            if not dfs(i):
                return False
        return True
```

# 時間複雜度

因為每個點我們只會拜訪一次，所以時間複雜度為$O(n)$，$n$為$numCourses$，而空間複雜度為$O(m)$，$m$為$len(prerequisites)$。