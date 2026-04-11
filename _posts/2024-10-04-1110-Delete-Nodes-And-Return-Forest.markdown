---
layout: article_post
title:  "[Leetcode解題]  1110. Delete Nodes And Return Forest - DFS解"
description:  "1110. Delete Nodes And Return Forest"
categories: medium
tags: dfs 
langs: python
excerpt_separator: <!--more-->
---



## 題目
[1110. Delete Nodes And Return Forest](https://leetcode.com/problems/delete-nodes-and-return-forest/description/)
當你有一棵二元樹，其中每個節點的值都不一樣，我們的目標是刪除一些節點，這些節點的值在一個叫 `to_delete` 的列表裡。當這些節點被刪除後，樹會被分成幾個不連接的小樹，這些小樹被稱為森林。你需要返回這些小樹的根節點，順序沒有關係。
<!--more-->

## 解題思路

這題的重點在於，我們需要用遞迴的方式遍歷整棵樹，逐一檢查每個節點是不是要被刪掉。如果某個節點需要被刪除，我們就把它的子節點（如果有的話）加入到森林裡，然後把這個節點刪掉。最終，留下來的節點會形成幾棵新的小樹，這些小樹就是我們的「森林」。

具體步驟：
1. 使用深度優先搜索 (DFS) 遍歷整棵樹，並檢查每個節點。
2. 如果節點的值存在於 `to_delete` 列表中，將它的左子節點和右子節點（如果存在）加入到森林中，然後刪除此節點。
3. 遞迴結束後，檢查根節點，如果根節點本身未被刪除，將其加入森林。
4. 使用一個*hash set* `toDelete` 來快速查找要刪除的節點。

## Python 實作

```python
# 定義二元樹節點
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def delNodes(self, root: TreeNode, to_delete: list[int]) -> list[TreeNode]:
        toDelete = set(to_delete)  # 使用集合來提高查找效率
        forest = []  # 存放結果的森林

        def dfs(node: TreeNode) -> TreeNode:
            if not node:
                return None

            # 遞迴處理左子樹和右子樹
            node.left = dfs(node.left)
            node.right = dfs(node.right)

            # 如果當前節點需要被刪除
            if node.val in toDelete:
                if node.left:
                    forest.append(node.left)  # 左子樹加入森林
                if node.right:
                    forest.append(node.right)  # 右子樹加入森林
                return None  # 刪除當前節點，返回 None

            return node  # 保留當前節點

        # 處理根節點
        if dfs(root):
            forest.append(root)

        return forest
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
    vector<TreeNode*> forest;
    void dfs(TreeNode* &root, const unordered_set<int> &toDelete){
        if (!root) return;
        dfs(root -> left, toDelete);
        dfs(root -> right, toDelete);
        if (toDelete.find(root->val)!=toDelete.end()){
            if (root -> left) forest.push_back(root->left);
            if (root -> right) forest.push_back(root->right);
            delete root;
            root = nullptr;
        }
        return;
    }

    vector<TreeNode*> delNodes(TreeNode* root, vector<int>& to_delete) {
        
        unordered_set<int> toDelete(to_delete.begin(), to_delete.end());

        dfs(root, toDelete);
        if (root) forest.push_back(root);
        
        return forest;

    }
};
```

## 時間複雜度分析

- **時間複雜度**: `O(N)`，其中 `N` 是樹中節點的數量。每個節點只被訪問一次，並且每次訪問的操作都是常數時間。
- **空間複雜度**: `O(N)`，最壞情況下，遞迴堆疊需要存儲樹的所有節點。