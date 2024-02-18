---
layout: article_post
title:  "[Leetcode解題] 199. Binary Tree Right Side View - BFS解"
description:  "[Leetcode解題] 199. Binary Tree Right Side View - BFS解"
categories: medium 
tags: dfs bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[199. Binary Tree Right Side View](https://leetcode.com/problems/binary-tree-right-side-view/)
給定一棵二元樹的根節點，想像自己站在樹的右側，然後要返回你能看到的節點值，並且按照從上到下的順序排列。
<!--more-->

## 解題思路
我們可以使用**廣度優先搜尋（BFS）** 來解決這個問題。當我們從右側看這棵樹時，我們只會看到每一層最右邊的節點。所以我們可以使用 BFS，但是每一層先從右邊開始遍歷，這樣我們就能確保每一層都是從右側看到的節點。

具體步驟如下：
1. 初始化一個空列表 visible_nodes 來存放從右側看到的節點值。
2. 使用 BFS 來遍歷二元樹。從根節點開始，逐層遍歷，每一層從右側開始。
3. 在 BFS 的每一層中，將最右邊的節點值添加到 visible_nodes 中。
4. 最後返回 visible_nodes。

## Python實作
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return []

        visible_nodes = []
        queue = [root]

        while queue:
            visible_nodes.append(queue[-1].val) 
            next_level = []

            for node in queue:
                if node.left:
                    next_level.append(node.left)
                if node.right:
                    next_level.append(node.right)

            queue = next_level

        return visible_nodes
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
/*
Using BFS traverse all the node
queue keep track of the same depth node, from right to left
each iteration is the same depth, so we just push the first one in the visible_nodes
*/

class Solution {
public:
    vector<int> rightSideView(TreeNode* root) {
        vector<int> visible_nodes;
        queue<TreeNode*> q;
        if (root) q.push(root);

        while(!q.empty()){
            queue<TreeNode*> nextLayer;
            auto right = q.front();
            visible_nodes.push_back(right->val);
            while(!q.empty()){
                auto cr = q.front();
                q.pop();
                if (cr->right) nextLayer.push(cr->right);
                if (cr->left) nextLayer.push(cr->left);
            }
            q = move(nextLayer); // 避免複製
        }
        return visible_nodes;
        
    }
};
```

## 複雜度分析：
$O(N)$，其中 $N$ 是binary tree中的節點數。我們需要遍歷每個節點一次。