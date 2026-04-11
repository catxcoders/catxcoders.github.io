---
layout: article_post
title:  "[Leetcode解題] 368. Largest Divisible Subset - 使用dp 算法 "
description:  "[Leetcode解題] 368. Largest Divisible Subset - 使用dp 算法 "
categories: medium 
tags: dp
langs: python
excerpt_separator: <!--more-->
---

# 題目
[368. Largest Divisible Subset](https://leetcode.com/problems/largest-divisible-subset/)
給定一組不同的正整數 nums，返回最大的子集 answer，使得該子集中的每對元素 $(answer[i], answer[j])$ 都滿足以下條件：
$answer[i] \% answer[j] == 0$，或者 $answer[j] \% answer[i] == 0$

如果有多個解，返回其中任意一個。
<!--more-->

# 解題思路
- 首先，**將 `nums` 排序**，排序的目的是為了確保對於每個數字，我們只需要檢查它之前的數字是否能整除它，這樣可以減少重複的計算。
- 我們可以利用 **動態規劃（Dynamic Programming）** 來解決這個問題
    - 創建兩個陣列 `dp` 和 `parent`
        - `dp[i]` 表示以 `nums[i]` 結尾的最大子集的大小
        - `parent[i]` 表示在該最大子集中，`nums[i]` 的前一個數字的index(可以理解為當$nums[i]\%nums[j]==0$，`j`是`i`的`parent`)。
    - 遍歷`nums`，對於每個 `nums[i]`，再從 `nums[0]` 到 `nums[i-1]` 中找出可以整除 `nums[i]` 的數字 `nums[j]` ($nums[i]\%nums[j]==0$)，並更新 `dp[i]` 和 `parent[i]`。這樣，我們就可以得到**以每個數字結尾的最大子集的大小`dp[i]`以及它的前一個數字`parent[i]`**。
- 最後，我們找出 `dp` 中最大的值及其對應的index，根據 `parent` 陣列，倒推出最大子集。


# Python 實作
```python
def largestDivisibleSubset(nums):
    if not nums:
        return []
    
    nums.sort()
    n = len(nums)
    dp = [1] * n
    parent = [-1] * n
    max_length, max_index = 1, 0
    
    for i in range(n):
        for j in range(i):
            if nums[i] % nums[j] == 0:
                if dp[i] < dp[j] + 1:
                    dp[i] = dp[j] + 1
                    parent[i] = j
                if dp[i] > max_length:
                    max_length = dp[i]
                    max_index = i
    
    result = []
    while max_index != -1:
        result.append(nums[max_index])
        max_index = parent[max_index]
    
    return result[::-1]
```
# C++ 實作
這個做法加入了剪枝的技巧，把`nums`中的每個點視為一個node，按照該node能往上找幾層來分類，由層數大到小找出可以整除 nums[i] 的數字，一但找到，更新parent，就不用繼續搜索下去。
```cpp
class Solution {
public:
    vector<int> largestDivisibleSubset(vector<int>& nums) {
        sort(nums.begin(), nums.end());

        vector<int> parent(nums.size(), -1);
        vector<vector<int>> layerNodes;
        layerNodes.push_back({0});

        for (auto i=1; i<nums.size(); i++){
            bool find = false;
            for (int layer=layerNodes.size()-1; layer>=0; layer--){
                for (const auto node_idx: layerNodes[layer]){
                    if (nums[i]%nums[node_idx]==0){
                        parent[i] = node_idx;
                        if (layer==layerNodes.size()-1)
                            layerNodes.push_back({});
                        layerNodes[layer+1].push_back(i);
                        find = true;
                        break;
                    }
                }
                if (find) break;
            }
            if (!find) layerNodes[0].push_back(i);
        }

        auto idx = layerNodes[layerNodes.size()-1][0];
        vector<int> LargestDivisibleSubset;
        while(idx!= -1){
            LargestDivisibleSubset.push_back(nums[idx]);
            idx = parent[idx];
        }
        return LargestDivisibleSubset;
    }
};
```


# 時間複雜度
排序 `nums` 需要 $O(n log n)$ 的時間。接著遍歷 `nums` ，對於每個數字，內部還有一個遍歷，因此時間複雜度為 $O(n^2)$。總體時間複雜度為 $O(n^2)$。