---
layout: article_post
title:  "[Leetcode解題]  841. Keys and Rooms"
description:  "DFS and BFS 造訪圖上所有點"
categories: medium
tags: graph dfs bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[841. Keys and Rooms](https://leetcode.com/problems/keys-and-rooms/)

有 n 個房間，標號從 0 到 n-1，除了房間 0 之外，所有房間都被鎖住。你的目標是訪問所有房間，但沒有鑰匙你無法進入被鎖的房間。

當你訪問一個房間時，可能會找到一組不同的鑰匙，每把鑰匙上都有一個數字，表示它可以打開的房間，你可以帶上所有鑰匙去打開其他房間。

給定一個數組 `rooms`，其中 `rooms[i]` 表示訪問房間 i 時可以獲得的鑰匙集合，如果你能訪問所有房間，返回 true，否則返回 false。

 <!--more-->

## 解題心得

這題是要造訪圖上所有點的，這類題目我們使用`DFS`或`BFS`都可以解

## 程式碼

```python
class Solution(object):
    def canVisitAllRooms(self, rooms):
        """
        :type rooms: List[List[int]]
        :rtype: bool
        """
        n = len(rooms)
        v = [0 for i in range(n)]
        q = [0]
        while q:  # bfs and dfs both work
            cur = q.pop()
            v[cur] = 1
            for key in rooms[cur]:
                if v[key] != 1:
                    q.append(key)
        return False if sum(v) != n else True
```

## 時間複雜度

$O(V+E)$，因為我會走過每條Edge跟每個node