---
layout: article_post
title:  "[Leetcode解題]  2458. Height of Binary Tree After Subtree Removal Queries"
description:  "2458. Height of Binary Tree After Subtree Removal Queries - Preorder解"
categories: hard
tags: preorder tree binary-tree
langs: python
excerpt_separator: <!--more-->
---

# 題目

[2458. Height of Binary Tree After Subtree Removal Queries](https://leetcode.com/problems/height-of-binary-tree-after-subtree-removal-queries/)

給一個`Binary Tree`，以及一串`Queries`，`Queries`表示要移除的點，此題要回傳移除該點後該樹的高度(heights)為多少，並且每個`Query`之間是獨立的。

<!--more-->

# 解題思路

這題我一開始沒什麼想法，最直接的是直接暴力，每次都移除掉該點後，然後DFS計算該樹的高度。

但這麼做的話，複雜度會是$O(mn)$，$m$為queries的數量，$n$為樹節點的數量。

根據題目給的範圍，這樣會達到$10^9$有TLE的可能，所以我們必須更優化算法。

我們可以透過`preorder`的順序來遍歷這棵樹，然後可以得到一個矩陣，矩陣表示的是如果我還沒有走道該點時，樹的高度為何。

我們要透過兩種不同走法的`preorder`

1. 標準的走法：中左右
2. Reverse: 中右左

這樣一來，如果最長的路徑在左樹，我們移除右樹的點的話，會在`1`的情況能夠判別，因為走到右樹的時候，我已經走完左樹，並知道樹的Height了。

反之，如果最長在右樹，我們移除左樹的點的話，能在`2`的走法得知樹的Height。

# 程式碼

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def treeQueries(self, root: Optional[TreeNode], queries: List[int]) -> List[int]:
        heights = [0] * (pow(10, 5) + 1)
        self.max_height = 0
        
        def traverse_from_left_to_right(node: TreeNode, height: int):
            if not node:
                return
            heights[node.val] = self.max_height
            self.max_height = max(self.max_height, height)
            traverse_from_left_to_right(node.left, height+1)
            traverse_from_left_to_right(node.right, height+1)
        
        def traverse_from_right_to_left(node: TreeNode, height: int):
            if not node:
                return
            heights[node.val] = max(heights[node.val], self.max_height)
            self.max_height = max(self.max_height, height)
            traverse_from_right_to_left(node.right, height+1)
            traverse_from_right_to_left(node.left, height+1)
            
        # pre-order
        traverse_from_left_to_right(root, 0)
        self.max_height = 0
        traverse_from_right_to_left(root, 0)
        return [heights[q] for q in queries]
```

# 時間複雜度

所以我們要走遍歷兩次樹，並且遍歷一次Query，所以時間複雜度為$O(m+n)$