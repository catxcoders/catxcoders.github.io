---
layout: article_post
title:  "[Leetcode解題] Satisfiability of Equality Equations - 使用DisjoinSet算法"
description: "[Leetcode解題] Satisfiability of Equality Equations - 使用DisjoinSet算法"
categories: medium
tags: disjointSet graph
langs: python
excerpt_separator: <!--more-->
---

# 題目
[990. Satisfiability of Equality Equations](https://leetcode.com/problems/satisfiability-of-equality-equations/)
給定一個字串序列 $equations$，表示變量之間的關係。每個字串 `equations[i]` 的長度為4，有兩種不同的形式：`"xi==yi"` 或 `"xi!=yi"`。其中，$x_i$ 和 $y_i$ 是小寫字母（可以相同），表示單個字母的變量名。

如果能夠對變量名分配整數，使得滿足所有給定的等式關係，則返回 $true$；否則返回 $false$。

<!--more-->

# 解題思路
這道題目可以使用不相交集（$DisjointSet$）的策略來解決。我們將相等的變量視為連接的點，並使用DisjointSet來維護它們之間的關係。如果在同一個連接分量中出現了不等關係，則無法滿足所有的等式。

我們可以使用以下步驟來解決問題：

1. 創建一個空的DisjointSet `dsu`。
2. 遍歷 `equations` 序列，對於每個等式 `equation`：
    - 如果 `equation` 的操作符是 `==`，則將兩個變量 `x` 和 `y` 連接起來。
3. 再次遍歷 `equations` 序列，對於每個不等式 `equation`：
    - 如果 `equation` 的操作符是 `!=`，則獲取兩個變量 `x` 和 `y`。
    - 如果 `x` 和 `y` 在同一個連接分量中，則返回 $false$。
4. 返回 $true$，表示能夠滿足所有等式。

# 算法
```python
class DisjointSet:
        def __init__(self):
            self.parent = {}

        def find(self, x):
            if x not in self.parent:
                self.parent[x] = x
            elif self.parent[x] != x:
                self.parent[x] = self.find(self.parent[x])
            return self.parent[x]

        def union(self, x, y):
            root_x = self.find(x)
            root_y = self.find(y)
            if root_x != root_y:
                self.parent[root_x] = root_y

class Solution:
    def equationsPossible(self, equations: List[str]) -> bool:
        dsu = DisjointSet()

        # Union操作：將相等的變量連接在一起
        for equation in equations:
            x, operator, _, y = equation
            if operator == '=':
                dsu.union(x, y)

        # 檢查不等關係是否與相等關係矛盾
        for equation in equations:
            x, operator, _, y = equation
            if operator == '!':
                if dsu.find(x) == dsu.find(y):
                    return False

        return True
```
使用DisjointSet的策略可以有效地解決這個問題。我們首先建立一個空的不相交集，然後根據等式建立相等關係。最後，我們檢查所有不等關係是否與相等關係矛盾，即兩個變量是否在同一個連接分量中。如果存在矛盾，則無法滿足所有等式，返回 false；否則返回 true。

# 複雜度分析
假設 $n$ 是 `equations` 的長度，其中每個等式的長度固定為4。
- 建立DisjointSet的過程需要遍歷 `equations` 序列，時間複雜度為 $O(n)$。
- 檢查不等關係的過程同樣需要遍歷 `equations` 序列，時間複雜度為 $O(n)$。
- 在DisjointSet中，find 和 union 操作的時間複雜度很小，可以忽略不計。

綜上所述，算法的時間複雜度為 $O(n)$。