---
layout: article_post
title:  "[Leetcode解題] 1028. Recover a Tree From Preorder Traversal"
description:  "1028. Recover a Tree From Preorder Traversal"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

# 1028. Recover a Tree From Preorder Traversal

# 題目

[1028. Recover a Tree From Preorder Traversal](https://leetcode.com/problems/recover-a-tree-from-preorder-traversal/description/?envType=daily-question&envId=2025-02-22)

這題給定一個preorder DFS的樹，以字串表達，並且以`dash('-')` 表達深度，求我們還原成用資料結構表示的樹

<!--more-->

# 解題思路

這題的重點是，我們要如何紀錄下當時正確的`parent`

舉例來說，給定一個字串`"1-2--3--4-5--6--7"`，我可以知道，2因為深度增加，所以會是上一個點的子節點，但關鍵是我們要如何取得正確的父節點。

我們可以透過一個stack，並且維持這個stack的長度不大於當前點的深度，這樣可以確保`stack.top()`就是該點的父節點。

通常需要這種取得特殊位置值的情況，可以考慮`stack`或者`monotonic stack`來想

```python
class Solution:
    def recoverFromPreorder(self, traversal: str) -> Optional[TreeNode]:
        stack = []
        i = 0
        while i < len(traversal):
            depth = 0
            while i < len(traversal) and traversal[i] == '-':
                depth += 1
                i += 1

            num = 0
            while i < len(traversal) and traversal[i].isdigit():
                num = num * 10 + int(traversal[i])
                i += 1

            node = TreeNode(num)

            while len(stack) > depth:
                stack.pop()

            if stack:
                if stack[-1].left is None:
                    stack[-1].left = node
                else:
                    stack[-1].right = node

            stack.append(node)

        return stack[0]
```

# 時間複雜度

要跑過一輪traversal字串，複雜度為$O(n)$, $n$為traversal字串的長度