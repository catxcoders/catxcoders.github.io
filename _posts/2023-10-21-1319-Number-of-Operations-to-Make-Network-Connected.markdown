---
layout: article_post
title:  "[Leetcode解題] 1319. Number of Operations to Make Network Connected - DisjointSet解法"
description: "[Leetcode解題] 經典Leetcode必刷題目，學習使用DisjointSet解法"
categories: medium
tags: presum DisjointSet
langs: python
excerpt_separator: <!--more-->
---

題目網址: [1319. Number of Operations to Make Network Connected](https://leetcode.com/problems/number-of-operations-to-make-network-connected/)

# 題目

連接所有計算機的最少操作次數

給定$n$台計算機，編號從$0$到$n-1$，它們之間通過以太網電纜相互連接，形成一個網絡。給定初始的連接配置connections，其中`connections[i] = [ai, bi]`表示計算機`ai`和`bi`之間有一條連接。任何一台計算機都可以通過網絡直接或間接地連接到任何其他計算機。

你可以提取某些已經連接的電纜，將它們連接到任意一對未連接的計算機上，使它們直接連接起來。

請計算出需要執行的最小操作次數，使得所有計算機都能連接在一起。如果無法實現，請返回$-1$。

<!--more-->

# 解題思路

由於，$n$個點至少需要$n-1$條邊才能把全部點都連在一起；如果連接的數量小於 $n-1$，則無法將所有電腦連接在一起，直接返回 $-1$。

這道題可以使用「不相交集合」（Disjoint Set）的算法來解決。不相交集合是一種用於解決「集合合併」和「查找元素所屬集合」的問題的資料結構。

首先，我們創建一個不相交集合（也稱為Union-Find集合），其中每個電腦都是一個單獨的集合。

然後，我們遍歷connections列表，將每個連接中的兩個電腦所屬的集合進行合併操作。這樣做可以建立起電腦之間的直接連接關係。

最後，我們需要計算需要移動多少邊才能將所有點都串在一起。連通兩個不相交集合需要移動一個邊，因此集合數量減去 1，即移動次數。


# 算法
1. 如果連接的數量小於 $n-1$，則返回 $-1$，因為無法將所有電腦連接在一起。
2. 初始化不相交集，每個節點的初始根節點為自身。
3. 遍歷所有連接，使用 union 函數將連接的兩個節點合併。
4. 使用一個無序集合 roots，統計所有的根節點。
5. 返回 roots 的大小減去 1，即需要連接的次數。


# 實作
```python
def makeConnected(self, n: int, connections: List[List[int]]) -> int:
    if len(connections) + 1 < n:
        return -1

    ds = list(range(n))

    def root(idx: int) -> int:
        if idx != ds[idx]:
            ds[idx] = root(ds[idx])
        return ds[idx]

    def union(a: int, b: int) -> None:
        ds[root(a)] = root(b)

    for a, b in connections:
        union(a, b)

    roots = set()
    for i in range(n):
        roots.add(root(i))

    return len(roots) - 1
```
# 複雜度
## 時間複雜度
* 構建不相交集的時間複雜度為 $O(n)$。
* 合併連接的時間複雜度為 $O(m)$，其中 $m$ 是連接的數量。
* 統計連通分量的時間複雜度為 $O(n)$。
* 最終的時間複雜度為 $O(n + m)$。

## 空間複雜度
* 空間複雜度為 $O(n)$，用於存儲不相交集。