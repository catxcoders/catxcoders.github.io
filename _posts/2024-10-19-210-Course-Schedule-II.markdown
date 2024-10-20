---
layout: article_post
title:  "[Leetcode解題]  210. Course Schedule II"
description:  "210. Course Schedule II - 用BFS解"
categories: medium
tags: bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目
[210. Course Schedule II](https://leetcode.com/problems/course-schedule-ii/)
給定一個包含 `numCourses` 門課程的課程表，課程標號從 `0` 到 `numCourses - 1`。同時，還有一個「先修課程」陣列 `prerequisites`，其中 `prerequisites[i] = [a_i, b_i]` 表示想要修課程 `a_i`，需要先修完課程 `b_i`。

例如，`[0, 1]` 表示要修課程 `0` 必須先修課程 `1`。

你需要返回一個修課程的順序，若有多種有效順序，返回任意一個。若無法修完所有課程，返回空陣列。

## 解題思路
這道題的本質是**拓撲排序**。我們將課程依賴關係看成一個有向圖，課程作為節點，先修課程的依賴關係為有向邊。要完成所有課程，就是要找到這個有向圖的一個拓撲排序。

### 步驟：
1. **構建圖與計算入度**：用adjacency list表示有向圖，並計算每個節點的入度（指向該節點的邊數）。
2. **入度為 0 的節點進入queue**：首先將所有入度為 0 的課程放入queue中，這表示這些課程可以最先修完，因為它們沒有前置依賴。
3. **進行廣度優先搜索（BFS）**：
   - 從queue中取出一個課程，將其加入結果列表。
   - 將這個課程指向的所有課程的入度減 1，若某個課程的入度變為 0(代表要先修的課都已經修完)，將其加入queue。
4. **判斷是否可行**：如果所有課程都能排入結果列表，則存在有效的課程安排；否則，說明圖中存在環，無法完成所有課程。

## python實現

```python
class Solution:
    def findOrder(self, numCourses: int, prerequisites: List[List[int]]) -> List[int]:
        # 構建adjacency list和入度陣列
        graph = {i: [] for i in range(numCourses)}
        in_degree = [0] * numCourses
        
        # 填充adjacency list和計算每個節點的入度
        for course, pre in prerequisites:
            graph[pre].append(course)
            in_degree[course] += 1
        
        # 將所有入度為 0 的節點放入隊列
        queue = deque([i for i in range(numCourses) if in_degree[i] == 0])
        
        # 進行拓撲排序
        topo_order = []
        while queue:
            node = queue.popleft()
            topo_order.append(node)
            
            # 更新後繼節點的入度
            for neighbor in graph[node]:
                in_degree[neighbor] -= 1
                if in_degree[neighbor] == 0:
                    queue.append(neighbor)
        
        # 如果拓撲排序的結果中包含所有課程，則返回順序；否則返回空陣列
        return topo_order if len(topo_order) == numCourses else []
```

## C++實現
```cpp
class Solution {
public:
    vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
        vector<int> inDegree(numCourses, 0);
        vector<int> results;
        vector<vector<int>> adj(numCourses);
        queue<int> que;
        for(auto &p: prerequisites){
            ++inDegree[p[0]];
            adj[p[1]].push_back(p[0]);
        }

        for(int i=0; i<numCourses; i++)
            if (inDegree[i]==0)
                que.push(i);
        

        while(!que.empty()){
            auto f = que.front();
            results.push_back(f);
            que.pop();
            for(const auto &n: adj[f]){
                
                --inDegree[n];
                if (inDegree[n]==0){
                    que.push(n);
                }
                
            }
        }
        return (results.size()==numCourses)? results: vector<int>();
    }
};
```

## 時間複雜度
- **構建圖與計算入度**：每條先修課程對應一條邊，總共遍歷 `prerequisites` 一次，因此這一步的時間複雜度是 `O(E)`，其中 `E` 是邊的數量。
- **廣度優先搜索**：每個課程只會被訪問一次，並且每條邊也只會被處理一次，這一步的時間複雜度是 `O(V + E)`，其中 `V` 是課程數量，`E` 是先修課程的數量。
- **總時間複雜度**：`O(V + E)`，其中 `V` 是節點數（課程數量），`E` 是邊數（先修課程的數量）。

## 空間複雜度
- 我們使用了一個adjacency list來存儲圖和一個入度陣列，因此空間複雜度是 `O(V + E)`。

## 結論
這個問題可以通過拓撲排序來解決，具體步驟是構建圖、計算入度、進行廣度優先搜索，並最終判斷是否存在環。如果能完成所有課程，返回一個可行的課程順序；如果無法完成，則返回空陣列。

