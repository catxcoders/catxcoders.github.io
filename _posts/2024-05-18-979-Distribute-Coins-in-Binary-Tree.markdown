---
layout: article_post
title:  "[Leetcode解題] 979. Distribute Coins in Binary Tree"
description:  "[Leetcode解題] 979. Distribute Coins in Binary Tree"
categories: medium 
tags: dfs binary-tree
langs: python
excerpt_separator: <!--more-->
---

## 題目
[979. Distribute Coins in Binary Tree
](https://leetcode.com/problems/distribute-coins-in-binary-tree/)

給一棵二元樹，上面每個點可能會有硬幣，但所有硬幣總和的數量跟節點的數量一樣，求最小要移動幾步才能讓每個點剛好有一個硬幣。
<!--more-->
## 解題思路

我們可以從`leaf nodes`開始做，如果一個`node`，有多餘的金幣，就把他丟給`parent node`，反之，如果缺金幣，就從`parent node`，放一個金幣到該點，這邊有一個關鍵是，`parent node`，也有可能沒有足夠的金幣，但我們可以先用負數來表示。

每進行一步，我們會把左子樹點(cur.left)跟右子樹(cur.right)的點填滿剛好一個金幣，然後就可以拔掉該點，繼續往上看。

這個函式的意義表示的是該點需要跟parent拿幾顆(負的狀況)、或要給parent幾顆(正的狀況)。

## 程式碼

```python
class Solution(object):
    def distributeCoins(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        self.moves = 0
        def dfs(cur):
            if not cur:
                return 0
            
            left_node_coins = dfs(cur.left)
            right_node_coins = dfs(cur.right)
            
            self.moves += abs(left_node_coins) + abs(right_node_coins)
            
            return (cur.val-1) + left_node_coins + right_node_coins
        dfs(root)
        return self.moves
```

## 時間複雜度

遍歷整棵樹，所以是$O(n)$