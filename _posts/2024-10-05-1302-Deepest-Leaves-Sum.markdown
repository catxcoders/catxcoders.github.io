---
layout: article_post
title:  "[Leetcode解題]  1302. Deepest Leaves Sum"
description:  "1302. Deepest Leaves Sum - 用BFS解"
categories: medium
tags: tree binary-tree bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目

[1302. Deepest Leaves Sum](https://leetcode.com/problems/deepest-leaves-sum/)

這題給定一顆Binary Tree，要求最深的Leaves值的總和

## 解題思路

這題最直觀的解法是先Traverse一次樹得到最深深度，然後再Traverse一次去計算最深深度的Leaves的總和

但我們也能直接在第一次Traverse的時候就記錄下最深的Leaves，可以直遍歷一次樹

所以我們透過BFS來做，用一個queue來存每個點跟每個點的level，然後去計算每個depth所有點的總和

但如果發現還可以往下的話，就洗掉這個總和，所以它永遠存的是最深的level(depth)點的總和

另外，也能透過多加一個內層迴圈，每次都只對當層來做和，這樣就不用像下面的程式碼存level的值了，大家有興趣可以自己implement看看

<!--more-->

## 程式碼

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
from collections import deque
class Solution:
    def deepestLeavesSum(self, root: Optional[TreeNode]) -> int:
        queue = deque([(root, 0)])
        cur_level = 0
        cur_total = 0
        while queue:
            cur, level = queue.popleft()
            if cur.left:
                queue.append((cur.left, level+1))
            if cur.right:
                queue.append((cur.right, level+1))
            if level != cur_level:
                cur_level = level
                cur_total = cur.val
            else:
                cur_total += cur.val
        return cur_total
```

## 時間複雜度

Traverse一次樹為 $O(n)$