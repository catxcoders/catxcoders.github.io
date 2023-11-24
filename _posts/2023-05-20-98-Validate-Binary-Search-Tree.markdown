---
layout: article_post
title:  "[Leetcode解題] Validate Binary Search Tree - 遞迴解"
description:  "[Leetcode解題] Validate Binary Search Tree - 遞迴解"
categories: medium
tags: bst binary-tree binary-search-tree recursion
langs: python
excerpt_separator: <!--more-->
---

題目網址: [98. Validate Binary Search Tree](https://leetcode.com/problems/validate-binary-search-tree/)

# 題目

這題我們要驗證給定的樹是否為一個合法的二元搜尋樹(Binary Search Tree)，一個合法的`BTS`需要符合以下幾點：

1. 所有左子樹的節點都必須小於根節點(root)
2. 所有右子樹的節點都必須大於根節點
3. 左子樹跟右子樹也要是二元搜尋樹

<!--more-->

## 解題思路

根據以上的定義，我們可以想到利用`遞迴(recursion)`的算法來解，唯一有一個重點是，我們可以觀察到，二元搜尋樹有一個特質，它的最小值在樹的最左邊，而它的最大值在最右邊，所以如果我們想驗證一個樹是不是合法的二元搜尋樹，可以按照以下步驟：

1. 先判定左右子樹是否合法
2. 若合法，我們取左子樹的最右邊的節點(最大值)，判定是否小於根節點，同理，右子樹判定右子樹的最左節點是否大於根節點
3. 如果都符合，則合法

## 實作

```python
class Solution(object):
     def isValidBST(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        def BSTMax(root):
            while root.right:
                root = root.right
            return root.val

        def BSTMin(root):
            while root.left:
                root = root.left
            return root.val

        if root.left and not self.isValidBST(root.left):
            return False
       
        if root.right and not self.isValidBST(root.right):
            return False
        
        # Check that is the maxima in the left tree is less than the root
        if root.left and BSTMax(root.left) > root.val:
            return False
        
        # Check that is the minima in the right tree is larger than the root
        if root.right and BSTMin(root.right) < root.val:
            return False
        return True
```

## 時間複雜度

這邊的時間複雜度推導稍微比較複雜一點，首先我們先考慮Best Case，也就是如果這是一個平衡的BTS，我們還是需要去遍歷每個點，所以可以想見時間複雜度為$O(n)$，我們再從根節點來看，每次我們都還需要去找左子樹的最右節點跟右子樹的最左節點，複雜度為$O(\log n)$，我們可以把複雜度寫成$T(n)=2T(n/2) + 1og(n)$，根據[Master Theorem](https://www.csd.uwo.ca/~mmorenom/CS433-CS9624/Resources/master.pdf)，時間複雜度為$O(n)$。

而在`Worst case`，時間複雜度來到$O(n^2)$，想像如果是一棵`skewed tree`，我們取得左子樹的最右節點或右子樹的最左節點的時間複雜度會來到$O(n)$