---
layout: article_post
title:  "[Leetcode解題] 543. Diameter of Binary Tree - 使用DFS解"
description:  "Robot Collisions"
categories: easy
tags: dfs
langs: python cpp
excerpt_separator: <!--more-->
---

## 題目：
[543. Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/)
給定一個`binary tree`，求樹中任兩點最遠的距離。


## 解題思路

想要找出binary tree的直徑，我們要算出樹裡面任意兩個節點之間的最長路徑。
這條路徑可能經過`root`，也可能不經過。所以我們得考慮這兩種情況：

1. 如果**最長路徑經過`root`**，這條路徑就是`root`左子樹的深度加上右子樹的深度。
2. 如果**最長路徑不經過`root`**，那就要看左右子樹中哪個直徑比較大。

我們可以寫一個**遞迴函數**來幫我們計算每個節點的最大深度，然後更新整棵樹的最大直徑。

### 具體步驟
1. 如果節點是空的，那就回傳深度是0，直徑也是0。
2. 遞迴計算左子樹和右子樹的最大深度和直徑。
3. **節點的深度**: 左右子樹深度的最大值加1。
4. **節點的直徑**: 左子樹深度加右子樹深度，以及左子樹直徑和右子樹直徑中的最大值。

## Python 代碼實現

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def diameterOfBinaryTree(self, root: Optional[TreeNode]) -> int:
        
        def dfs(node):
            if node is None: 
                return 0, 0  # (直徑, 深度)

            left_diameter, left_depth = dfs(node.left)
            right_diameter, right_depth = dfs(node.right)

            # 計算當前節點的直徑
            current_diameter = max(left_diameter, right_diameter, left_depth + right_depth)
            # 計算當前節點的深度
            current_depth = 1 + max(left_depth, right_depth)

            return current_diameter, current_depth
        
        return dfs(root)[0]
        
```

## C++ 代碼實現
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
    pair<int, int> depthAndDiameter(TreeNode* root){
        if (!root) return {0, 0};
        auto left = depthAndDiameter(root -> left);
        auto right = depthAndDiameter(root -> right);
        return {max(left.first, right.first)+1, max( left.first+ right.first, max(left.second, right.second))};
    }

    int diameterOfBinaryTree(TreeNode* root) {
        return depthAndDiameter(root).second;
    }
};
```

## 時間複雜度分析

這個算法的時間複雜度是 $O(N)$，其中 $N$ 是`binary tree`裡的節點數。因為我們需要訪問每個節點一次，來計算它的深度和直徑。

具體來說，我們對樹進行了一次深度優先搜索（DFS），在每個節點上進行了常數時間的操作，所以總時間複雜度就是 $O(N)$。