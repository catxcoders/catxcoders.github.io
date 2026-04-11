---
layout: article_post
title:  "[Leetcode解題] 2477. Minimum Fuel Cost to Report to the Capital"
description:  "2477. Minimum Fuel Cost to Report to the Capital"
categories: medium
tags: dfs graph
langs: python
excerpt_separator: <!--more-->
---

## 題目
[2477. Minimum Fuel Cost to Report to the Capital](https://leetcode.com/problems/minimum-fuel-cost-to-report-to-the-capital/)
給定一個由 `n` 個城市組成的國家網路，這些城市形成一棵樹狀結構（也就是沒有環、連通的無向圖）。
每條道路連接兩個城市，首都為城市 `0`。

每個城市都有一台車，且車上有 `seats` 個座位。
每個城市的代表都要前往首都開會，可以選擇開自己的車或搭乘別的代表的車。

移動一單位距離（經過一條路）會花費 **1 公升油**。
請回傳所有代表都到達首都所需的最少燃料量（公升數）。
<!--more-->

## 解題思路：
這題的重點在於「如何讓每條邊上的代表移動成本最小」。
由於這是一棵樹，我們可以從leaf節點（沒有子節點的城市）開始，往首都方向（root節點）計算。

* 每個城市都會有一位代表。
* 我們需要計算從該城市出發的所有代表，要花多少油到上層城市。
* 一台車最多可坐 `seats` 人，
  所以如果有 `people` 人要往上走，所需車數為：
  ```
  cars = ceil(people / seats)
  ```
  而每台車經過一條路（上移一層）都要耗費 1 公升油。
* 為什麼從下往上？
因為代表可以在上層城市重新分車或併車，所以我們必須知道子樹有多少人，才能決定開幾台車往上走。

### 遞迴 (DFS) 的想法：
1. 從首都 (city 0) 開始 DFS。
2. 對每個子節點：
   * 計算該子樹中總共有多少代表（`people`）。
   * 每個非首都城市，貢獻的燃料是 `(people + seats - 1) // seats`。
3. 回傳該節點的總代表數（包含自己）。

## C++ 實作：
```cpp
class Solution {
public:
    int seatNum;
    long long ans = 0;
    long long minimumFuelCost(vector<vector<int>>& roads, int seats) {
        vector<vector<int>> graph(roads.size() + 1);
        for (const vector<int>& road : roads) {
            graph[road[0]].push_back(road[1]);
            graph[road[1]].push_back(road[0]);
        }

        seatNum = seats;
        dfs(graph, 0, -1);
        return ans;
    }

    int dfs(const vector<vector<int>> &graph, int curCity, int preCity){
        int people = 1;
        for (const int neighbor : graph[curCity]) {
            if (neighbor == preCity)
                continue;
            people += dfs(graph, neighbor, curCity);
        }
        if (curCity > 0)
            ans += (people + seatNum - 1) / seatNum;
        return people;
    }
};
```

## Python 實作：

```python
class Solution:
    def minimumFuelCost(self, roads, seats):
        n = len(roads) + 1
        graph = defaultdict(list)
        for a, b in roads:
            graph[a].append(b)
            graph[b].append(a)

        self.ans = 0
        self.seats = seats

        def dfs(city, parent):
            people = 1  # 包含自己
            for nei in graph[city]:
                if nei == parent:
                    continue
                people += dfs(nei, city)
            if city != 0:
                self.ans += ceil(people / self.seats)
            return people

        dfs(0, -1)
        return self.ans
```

## 時間與空間複雜度分析：
* **時間複雜度：** `O(n)`
  每個城市（節點）只會被 DFS 探訪一次。

* **空間複雜度：** `O(n)`
  用來儲存樹的鄰接表，以及 DFS 遞迴的stack深度。
