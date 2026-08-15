---
layout: article_post
title:  "[Leetcode解題] 1584. Min Cost to Connect All Points"
description:  "1584. Min Cost to Connect All Points - 使用 Kruskal 演算法與 Union-Find (MST)"
categories: medium
tags: graph disjointSet kruskal mst
langs: python
excerpt_separator: <!--more-->
---

# 1584. Min Cost to Connect All Points

## 題目

[1584. Min Cost to Connect All Points](https://leetcode.com/problems/min-cost-to-connect-all-points/)

給定一個包含 $n$ 個點的二維陣列 `points`，其中 `points[i] = [xi, yi]` 表示點的座標。

連接任意兩點 `[xi, yi]` 與 `[xj, yj]` 的成本為兩點之間的**曼哈頓距離（Manhattan Distance）**：
$$\text{dist} = |x_i - x_j| + |y_i - y_j|$$

請回傳將所有點連接在一起的**最小總成本**。當所有點之間都存在至少一條路徑互相連通時，即視為點集已完全連通（相當於尋找最小生成樹 Minimum Spanning Tree, MST）。

<!--more-->

## 解題思路

這道題目是標準的**最小生成樹（Minimum Spanning Tree, MST）**問題。我們可以使用 **Kruskal 演算法** 結合 **並查集（Disjoint Set Union, DSU / Union-Find）** 來求解：

1. **建立所有邊 (Edges)**：
   - 遍歷所有兩兩點對 $(i, j)$，計算它們之間的曼哈頓距離並作為邊的權重。
   - 共有 $E = \frac{n(n-1)}{2}$ 條邊。
2. **依照邊權重排序**：
   - 將所有邊按距離從小到大排序，時間複雜度為 $O(E \log E)$。
3. **貪婪選擇與 Union-Find 避環**：
   - 依序取出最小的邊，使用 `find` 檢查邊的兩個端點是否已在同一個連通分量中。
   - 若不在同一連通分量中（`union` 回傳 `True`），將這條邊加入 MST，累加成本，並將連通邊數 `count` 加 1。
   - 當加入的邊數達到 $n - 1$ 條時，說明所有點已成功連通，可提前結束迴圈。

### Union-Find 優化
在並查集中我們使用了兩項經典優化：
- **路徑壓縮（Path Compression）**：在 `find` 過程中將節點直接指向根節點。
- **按秩合併（Union by Rank）**：將樹高（rank）較小的樹合併到較大的樹之下，保持樹的高度盡量扁平。

攤還後每次 `find` 與 `union` 操作的時間複雜度接近 $O(\alpha(V))$，其中 $\alpha$ 為反阿克曼函數（Inverse Ackermann function）。

## Python 實作

```python
class Solution:
    def minCostConnectPoints(self, points: List[List[int]]) -> int:
        n = len(points)
        parent = list(range(n))
        rank = [0] * n

        # Find 函式 (包含路徑壓縮 Path Compression)
        def find(x):
            if parent[x] != x:
                parent[x] = find(parent[x])  # Path compression
            return parent[x]

        # Union 函式 (包含按秩合併 Union by Rank)
        # 攤還時間複雜度 = O(alpha(N))
        def union(a, b):
            root_a = find(a)
            root_b = find(b)

            if root_a == root_b:
                return False
            
            # 按秩合併 (Union by Rank)
            if rank[root_a] < rank[root_b]:
                root_a, root_b = root_b, root_a
            
            parent[root_b] = root_a
            
            if rank[root_a] == rank[root_b]:
                rank[root_a] += 1
            
            return True

        # Kruskal 演算法
        edges = []

        # 計算所有點對之間的曼哈頓距離
        # 點數為 N，邊數 E = N * (N - 1) / 2
        for i in range(n):
            for j in range(i + 1, n):
                dist = abs(points[i][0] - points[j][0]) + abs(points[i][1] - points[j][1])
                edges.append((i, j, dist))
        
        # 依距離從小到大排序 (O(E log E))
        edges.sort(key=lambda x: x[2])

        total = 0
        count = 0  # 已連接的邊數

        # 貪婪選擇邊 (O(E))
        for u, v, dist in edges:
            if union(u, v):
                total += dist
                count += 1
            
                if count == n - 1:  # MST 恰好需要 N-1 條邊
                    break

        return total
```

## 複雜度分析

- **時間複雜度**：$O(E \log E)$
  其中 $V = n$ 為點數，$E = \frac{n(n-1)}{2} = O(V^2)$ 為邊數。
  - 計算所有邊距離需要 $O(E)$。
  - 對 $E$ 條邊進行排序需要 $O(E \log E)$。
  - 遍歷每條邊並執行 `union` 需要 $O(E \cdot \alpha(V))$。
  - 整體主要由邊排序決定，時間複雜度為 $O(E \log E)$（亦可寫作 $O(V^2 \log V)$）。

- **空間複雜度**：$O(E + V)$
  - 儲存所有邊的陣列 `edges` 需要 $O(E)$ 空間。
  - 並查集的 `parent` 與 `rank` 陣列需要 $O(V)$ 空間。
