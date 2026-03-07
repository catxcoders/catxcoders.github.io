---
layout: article_post
title:  "[Leetcode解題] 3203. Find Minimum Diameter After Merging Two Trees"
description:  "同餘定理"
categories: hard
tags: tree, dfs, bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目描述

給予兩棵獨立的無向樹（分別有 $n$ 個與 $m$ 個節點）。你必須從第一棵樹挑選一個點，從第二棵樹挑選一個點，並在兩點間連上一條邊。
**目標：** 找出連接後，新樹的**最小可能直徑**。

* **直徑定義：** 樹中任意兩點之間的最長路徑。
<!--more-->

## 解題思路
### 1. 核心觀察：連接在哪裡最划算？
要讓合併後的直徑最小，我們直覺上應該選擇兩棵樹的「**中心**」來進行連接。

* 當我們把兩棵樹連起來時，新的潛在直徑由三部分組成：
1. **第一棵樹內部的直徑** ($d1$)。
2. **第二棵樹內部的直徑** ($d2$)。
3. **跨越兩棵樹的路徑**：(第一棵樹的半徑) + (第二棵樹的半徑) + 1 (新連的邊)。

因此，最終答案為：

$$\max(d1, d2, \text{radius1} + \text{radius2} + 1)$$

### 2. 如何定義半徑 (Radius)？

在樹中，半徑是「從中心點到最遠葉子的距離」。

* 如果直徑為 $D$，則半徑 $R = \lceil D / 2 \rceil$。
* 在程式中可以使用 `(D + 1) // 2` 來計算。

### 3. 如何計算直徑？（剝洋蔥法 / 多源 BFS）

我們採用最直觀的「**剝洋蔥法**」（類似拓撲排序）：

1. 找出所有度數（Degree）為 1 的節點（葉子）。
2. 同時向內縮排，每一輪刪除所有當前的葉子。
3. 每縮一層，距離就加 1，直到剩下 1 個或 2 個節點（這就是樹的中心）。
4. **直徑計算公式：**
* 若最後剩 1 個點：$D = 2 \times \text{layers}$
* 若最後剩 2 個點：$D = 2 \times \text{layers} + 1$


## C++ 實作
```cpp
class Solution {
public:
    int minimumDiameterAfterMerge(vector<vector<int>>& edges1, vector<vector<int>>& edges2) {
        int d1 = getDiameter(edges1);
        int d2 = getDiameter(edges2);
        int r1 = (d1 + 1) / 2;
        int r2 = (d2 + 1) / 2;
        
        return max({d1, d2, r1 + r2 + 1});
    }

private:
    int getDiameter(vector<vector<int>>& edges) {
        int n = edges.size() + 1;
        if (n == 1) return 0;
        if (n == 2) return 1;

        vector<vector<int>> adj(n);
        vector<int> degree(n, 0);
        for (const auto& e : edges) {
            adj[e[0]].push_back(e[1]);
            adj[e[1]].push_back(e[0]);
            degree[e[0]]++;
            degree[e[1]]++;
        }

        queue<int> q;
        for (int i = 0; i < n; i++) {
            if (degree[i] == 1) {
                q.push(i);
            }
        }

        int layers = 0;
        int remainingNodes = n;

        while (remainingNodes > 2) {
            int currentLayerSize = q.size();
            remainingNodes -= currentLayerSize;
            layers++;

            for (int i = 0; i < currentLayerSize; i++) {
                int u = q.front();
                q.pop();

                for (int v : adj[u]) {
                    if (--degree[v] == 1) {
                        q.push(v);
                    }
                }
            }
        }
        // 根據最後剩下的節點數決定直徑
        // 剩 2 個點代表中心是一條邊 (2*layers + 1)
        // 剩 1 個點代表中心是一個點 (2*layers)
        return (remainingNodes == 2) ? (2 * layers + 1) : (2 * layers);
    }
};
```

## Python 實作

```python
class Solution:
    def minimumDiameterAfterMerge(self, edges1: list[list[int]], edges2: list[list[int]]) -> int:
        
        def get_diameter(edges):
            n = len(edges) + 1
            if n == 1: return 0
            if n == 2: return 1
            
            # 建立鄰接表與度數統計
            adj = [[] for _ in range(n)]
            degree = [0] * n
            for u, v in edges:
                adj[u].append(v)
                adj[v].append(u)
                degree[u] += 1
                degree[v] += 1
            
            # 將所有葉子加入隊列
            queue = deque([i for i in range(n) if degree[i] == 1])
            
            layers = 0
            remaining_nodes = n
            
            # 剝洋蔥：向內縮減直到剩下 1 或 2 個節點
            while remaining_nodes > 2:
                layer_size = len(queue)
                remaining_nodes -= layer_size
                layers += 1
                for _ in range(layer_size):
                    u = queue.popleft()
                    for v in adj[u]:
                        degree[v] -= 1
                        if degree[v] == 1:
                            queue.append(v)
            
            # 根據剩餘節點數計算直徑
            return 2 * layers + 1 if remaining_nodes == 2 else 2 * layers

        # 1. 分別計算兩棵樹的直徑
        d1 = get_diameter(edges1)
        d2 = get_diameter(edges2)
        
        # 2. 計算兩棵樹的半徑 (向上取整)
        r1 = (d1 + 1) // 2
        r2 = (d2 + 1) // 2
        
        # 3. 回傳三種可能的最大值
        return max(d1, d2, r1 + r2 + 1)
```

## 複雜度分析
### 時間複雜度：$O(N + M)$
* **建立圖：** 走訪兩棵樹的所有邊，分別需要 $O(N)$ 與 $O(M)$。
* **剝洋蔥 BFS：** 每個節點與每條邊都只會被處理一次，複雜度為 $O(N + M)$。
* **總結：** 整體為線性時間，非常高效。

### 空間複雜度：$O(N + M)$
* 我們需要存儲鄰接表（Adjacency List）來記錄節點關係。
* 需要額外的 `degree` 陣列與 `queue`，空間消耗與節點數成正比。
