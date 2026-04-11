---
layout: article_post
title:  "[Leetcode解題] 257. Binary Tree Paths"
description:  "257. Binary Tree Paths"
categories: medium
tags: dfs
langs: python
excerpt_separator: <!--more-->
---

## 題目
[257. Binary Tree Paths](https://leetcode.com/problems/binary-tree-paths/)
給定一棵binary tree的 `root`，請回傳所有「從`root`到`leaf`」的路徑，順序不限。
`leaf`的定義是：該節點沒有任何子節點（`left` 與 `right` 都為空）。
<!--more-->

## 解題思路
這題的關鍵是要走訪整棵`binary tree`，並且在走訪的過程中記錄路徑。一旦走到`leaf`，就把目前的路徑存下來。

作法是：
1. **DFS 深度優先搜尋**
   從`root`一路往下走，沿途把節點值加到路徑中。
2. **遇到`leaf`時儲存路徑**
   當 `node.left` 與 `node.right` 都是 `None`，表示路徑完成，加入答案。
3. **回溯 (backtracking)**
   為了避免影響其他路徑，在遞迴結束後要把剛加進去的節點值移除。
4. **字串格式處理**
   題目要求格式是 `"node1->node2->node3"`，所以在組合路徑時要注意加上箭頭。

## Python 實作
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right

class Solution:
    def binaryTreePaths(self, root: TreeNode) -> list[str]:
        paths = []
        self.dfs(root, "", paths)
        return paths

    def dfs(self, node: TreeNode, path: str, paths: list[str]):
        if not node:
            return
        
        # 更新當前路徑
        if path:
            path += "->"
        path += str(node.val)

        # 如果是leaf，加入答案
        if not node.left and not node.right:
            paths.append(path)
            return
        
        # 繼續往左右子樹走
        self.dfs(node.left, path, paths)
        self.dfs(node.right, path, paths)
```

## 時間複雜度分析

* **時間複雜度：** `O(N)`
  每個node只會被拜訪一次，其中 `N` 是節點數量。
  另外，每條路徑需要輸出成字串，輸出部分的時間依路徑長度而定，但整體仍為線性。

* **空間複雜度：** `O(H)`
  主要來自遞迴的呼叫stack，其中 `H` 是樹的高度。最壞情況（完全偏斜樹）下，`H = N`。