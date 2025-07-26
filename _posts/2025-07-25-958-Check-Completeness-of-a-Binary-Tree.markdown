---
layout: article_post
title:  "[Leetcode解題] 958. Check Completeness of a Binary Treer"
description:  "958. Check Completeness of a Binary Tree"
categories: medium
tags: bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目說明
[958. Check Completeness of a Binary Tree](https://leetcode.com/problems/check-completeness-of-a-binary-tree/)
給定一個二元樹的根節點 `root`，判斷這棵樹是否為**完全二元樹** (Complete Binary Tree)。
<!--more-->

**Complete Binary Tree 完全二元樹的定義**

1. 除了最後一層之外，其他層都必須被完全填滿。
2. 最後一層的節點必須從左到右依序填滿，不能出現右邊有節點但左邊空缺的情況。

換句話說，完全二元樹的節點在「層序遍歷 (BFS)」中，**一旦出現 `null`，後面不應再出現非空節點**，否則不是完全二元樹。

## 解題思路
* 完全二元樹在層序遍歷時，**不能在 `null` 之後出現非 `null` 節點**。
* 因此，我們可以用 BFS（層序遍歷）來檢查：

  1. 使用佇列 `queue` 依序遍歷所有節點。
  2. 當遇到 `null` 時，標記 `seenNull = true`。
  3. 如果 `seenNull == true` 後還遇到非 `null` 節點，代表後面還有節點，**違反完全二元樹定義**，回傳 `false`。
  4. 若 BFS 結束後都沒違反條件，則是完全二元樹。

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
    bool isCompleteTree(TreeNode* root) {
        queue<TreeNode*> q;
        q.push(root);
        bool seenNull = false;

        while (!q.empty()) {
            TreeNode* node = q.front(); q.pop();
            if (!node) {
                seenNull = true; // 遇到空節點後，後面不該有非空節點
            } else {
                if (seenNull) return false; // 遇到空後又遇到非空 => 非完全二元樹
                q.push(node->left);
                q.push(node->right);
            }
        }
        return true;
    }
};
```

## Python 實作
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def isCompleteTree(self, root: Optional[TreeNode]) -> bool:
        q = deque([root])
        seen_null = False
        
        while q:
            node = q.popleft()
            if not node:
                seen_null = True
            else:
                if seen_null:
                    return False
                q.append(node.left)
                q.append(node.right)
        
        return True
```

## 時間與空間複雜度
* **時間複雜度：$O(N)$**
  * 每個節點只會被訪問一次，N 為節點數。

* **空間複雜度：$O(N)$**
  * 最壞情況下會儲存整層的節點（接近 $N/2$）。
