---
layout: article_post
title:  "[Leetcode解題] 1161. Maximum Level Sum of a Binary Tree"
description:  "1161. Maximum Level Sum of a Binary Tree"
categories: medium
tags: bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目
[1161. Maximum Level Sum of a Binary Tree](https://leetcode.com/problems/maximum-level-sum-of-a-binary-tree/)
給你一棵二元樹的根節點，根節點的層級為 1，它的child為第 2 層，以此類推。
請回傳「節點值總和最大」的最小層級 `x`。
<!--more-->

## 解題思路
這題最自然就是「一層一層」去掃，也就是 **BFS 層序走訪**：
1. 用*queue*從根節點開始。
2. 每次處理同一層的所有節點，累加該層的 `sum`。
3. 維護兩個變數：目前為止的最大總和 `max_sum`，以及對應層級 `max_level`。若當前層的總和更大，就更新；若相同則不用動（因為要最小層級）。
4. 走完整棵樹後，回傳 `max_level`。

## Python 實作
```python
class TreeNode:
    def __init__(self, val=0, left: Optional['TreeNode']=None, right: Optional['TreeNode']=None):
        self.val = val
        self.left = left
        self.right = right

def maxLevelSum(root: Optional[TreeNode]) -> int:
    q = deque([root])
    level = 1
    max_sum = float('-inf')
    max_level = 1

    while q:
        size = len(q)
        cur_sum = 0
        for _ in range(size):
            node = q.popleft()
            cur_sum += node.val
            if node.left:
                q.append(node.left)
            if node.right:
                q.append(node.right)

        if cur_sum > max_sum:
            max_sum = cur_sum
            max_level = level
        level += 1

    return max_level
```

## C++ 實作
```cpp
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int maxLevelSum(TreeNode* root) {
        queue<TreeNode*> que;
        int level = 0;
        int maxLevel = 1;
        int maxSum = INT_MIN;

        if(root) que.push(root);
        while(!que.empty()){
            int sum = 0;
            int size = que.size();
            level++;
            for(int i=0; i<size; i++){
                auto front = que.front();
                sum += front->val;
                if(front -> left) que.push(front -> left);
                if(front -> right) que.push(front -> right);
                que.pop();
            }

            if (sum > maxSum){
                maxSum = sum;
                maxLevel = level;
            }
        }
        return maxLevel;
    }
};
```

## 複雜度分析
* **時間複雜度**：`O(n)`，每個節點恰好被訪問一次。
* **空間複雜度**：`O(w)`，`w` 為樹的最大寬度（queue最多同層節點）。
  