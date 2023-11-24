---
layout: article_post
title:  "[Leetcode解題] Flatten Binary Tree to Linked List - 遍歷二叉樹"
description:  "[Leetcode解題] Flatten Binary Tree to Linked List - 遍歷二叉樹"
categories: medium
tags: tree linked-list
langs: python
excerpt_separator: <!--more-->
---

題目網址: [114. Flatten Binary Tree to Linked List](https://leetcode.com/problems/flatten-binary-tree-to-linked-list/description/)

# 題目
給一個二叉樹的`root`，將樹壓平成一個`linked list`。
這個`linked list`應該與二叉樹的[前序遍歷](https://en.wikipedia.org/wiki/Tree_traversal#Pre-order,_NLR)順序相同。

<!--more-->

## 解法一
### 解題思路
從這棵樹的前序遍歷最遠的`Node`開始(下圖中的`6`)

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
//node [label=1 fillcolor="#cce8ff"] 1.1
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [ label="\N"]
1 -> 2 -> 3
2 -> 4
1 -> 5 -> null
5 -> 6
}
{% endgraphviz %}
---
將這個`Node`(下圖中的`6`)的指標存到`pre`
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=pre fillcolor="#cce8ff"] pre
node [label=6 fillcolor=lightgray] 6
node [ label="\N"]

pre -> 6
}
{% endgraphviz %}

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
//node [label=null fillcolor=lightgray] n2
node [ label="\N"]
1 -> 2 -> 3
2 -> 4
1 -> 5 -> n1
5 -> 6
}
{% endgraphviz %}

---
不是`pre`的child且前序遍歷最遠的`Node`(下圖中的`5`)的`left`設為NULL，並將上一步的`pre`接到`Node`(下圖中的`5`)的`right`，將`pre`設為`Node`(下圖中的`5`)
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=pre fillcolor="#cce8ff"] pre
node [label=6 fillcolor=lightgray] 6
node [label=5 fillcolor=lightgray] 5
node [ label="\N"]

pre -> 5 -> 6
}
{% endgraphviz %}

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
//node [label=null fillcolor=lightgray] n2
node [ label="\N"]
1 -> 2 -> 3
2 -> 4
1 -> 5 -> n1
5 -> 6
}
{% endgraphviz %}
---
不是`pre`的child且前序遍歷最遠的`Node`(下圖中的`4`)的`left`設為NULL，並將上一步的`pre`接到`Node`(下圖中的`4`)的`right`，將`pre`設為`Node`(下圖中的`4`)
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=pre fillcolor="#cce8ff"] pre
node [label=6 fillcolor=lightgray] 6
node [label=5 fillcolor=lightgray] 5
node [label=4 fillcolor=lightgray] 4
node [ label="\N"]

pre -> 4 -> 5 -> 6
}
{% endgraphviz %}

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
node [label=null fillcolor=lightgray] n2
node [ label="\N"]
1 -> 2 -> 3
2 -> 4 ->5 -> 6
1 -> n1
4 -> n2
5 -> n3
}
{% endgraphviz %}

---
依此類推...
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=pre fillcolor="#cce8ff"] pre
node [label=6 fillcolor=lightgray] 6
node [label=5 fillcolor=lightgray] 5
node [label=4 fillcolor=lightgray] 4
node [label=3 fillcolor=lightgray] 3
node [ label="\N"]

pre -> 3 -> 4 -> 5 -> 6
}
{% endgraphviz %}

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=null fillcolor=lightgray] n4
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n5
node [ label="\N"]
1 -> 2 -> 3 -> n4
3 -> 4 ->5 -> 6
1 -> n1
4 -> n2
5 -> n3
2 -> n5
}
{% endgraphviz %}

---
依此類推...
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=pre fillcolor="#cce8ff"] pre
node [label=6 fillcolor=lightgray] 6
node [label=5 fillcolor=lightgray] 5
node [label=4 fillcolor=lightgray] 4
node [label=3 fillcolor=lightgray] 3
node [label=2 fillcolor=lightgray] 2
node [ label="\N"]

pre -> 2 -> 3 -> 4 -> 5 -> 6
}
{% endgraphviz %}

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=null fillcolor=lightgray] n4
node [label=null fillcolor=lightgray] n5
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
node [label=null fillcolor=lightgray] n2

node [ label="\N"]
1 -> 2 -> 3 -> n4
3 -> 4 ->5 -> 6
1 -> n1
4 -> n2
5 -> n3
2 -> n5
}
{% endgraphviz %}
---
依此類推...
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=pre fillcolor="#cce8ff"] pre
node [label=6 fillcolor=lightgray] 6
node [label=5 fillcolor=lightgray] 5
node [label=4 fillcolor=lightgray] 4
node [label=3 fillcolor=lightgray] 3
node [label=2 fillcolor=lightgray] 2
node [label=1 fillcolor=lightgray] 1
node [ label="\N"]

pre -> 1 -> 2 -> 3 -> 4 -> 5 -> 6
}
{% endgraphviz %}

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n1
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=null fillcolor=lightgray] n4
node [label=null fillcolor=lightgray] n5
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5

node [label=6 fillcolor=lightgray] 6
node [label=null fillcolor=lightgray] n2

node [ label="\N"]
1 -> 2 -> 3 -> n4
3 -> 4 ->5 -> 6
1 -> n1
4 -> n2
5 -> n3
2 -> n5
}
{% endgraphviz %}

### 實作
1. 以[前序遍歷](https://en.wikipedia.org/wiki/Tree_traversal#Pre-order,_NLR)倒序遞迴的方式去遍歷所有節點
    1.1 遞迴遍歷當前節點的右子樹。
    1.2 遞迴遍歷當前節點的左子樹。 
    1.3 訪問當前節點。 
2. 訪問到當前節點時，將當前節點的`left`設為None, 並將`right`設為前一次存在pre中的結點
3. 將當前存在`pre`(代表已經flatten好的部分)

~~~ python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def __init__(self):
        self.pre = None

    def flatten(self, root: Optional[TreeNode]) -> None:
        """
        Do not return anything, modify root in-place instead.
        """
        if (not root):
            return
        self.flatten(root.right)
        self.flatten(root.left)
        root.left = None
        root.right = self.pre
        self.pre = root
~~~

### 時間複雜度
由於`pre`會指到每個節點一次，更新節點狀態的時間複雜度為$O(1)$，圖中有n個節點，時間複雜度為$O(n)$

---
## 解法二
### 解題思路
一開始，我們將指標`cr`指到`root`，以下用黃色代表`cr`
`cr`(節點`1`)的左邊子樹(淺粉色區域)的`root`(節點`2`)，左邊子樹前序遍歷最遠的點(節點`4`)
{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor="#ffe66d"] 1
node [label=2 fillcolor="#cce8ff"] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor="#cce8ff"] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
//node [label=null fillcolor=lightgray] n2
node [ label="\N"]
graph [style="filled,rounded" fillcolor="#ffdddda7"]
subgraph cluster_1 {2 3 4}
1 -> 2 -> 3
2 -> 4
1 -> 5 -> n1
5 -> 6
}
{% endgraphviz %}

將左邊子樹(淺粉色區域)移到`cr`(節點`1`)和`cr.right`(節點`5`)的中間:
1. 將`cr`右側子樹接到前序遍歷最遠的點(節點4)的右側
2. 將`cr`左側子樹接到`cr`右側



{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=1 fillcolor="#ffe66d"] 1
node [label=2 fillcolor="#cce8ff"] 2
node [label=3 fillcolor=lightgray] 3
node [label=4 fillcolor="#cce8ff"] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
//node [label=null fillcolor=lightgray] n2
node [ label="\N"]
graph [style="filled,rounded" fillcolor="#ffdddda7"]
subgraph cluster_1 {2 3 4}
1 -> n2
1 -> 2 -> 3
2 -> 4 -> 5 -> n1
4 -> n3
5 -> 6
}
{% endgraphviz %}
`cr`向右移動，此時`cr`為節點`2`。
`cr`(節點`2`)的左邊子樹(淺粉色區域)的`root`(節點`3`)，左邊子樹前序遍歷最遠的點(節點`3`)


{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor="#ffe66d"] 2
node [label=3 fillcolor="#cce8ff"] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5
node [label=null fillcolor=lightgray] n1
node [label=6 fillcolor=lightgray] 6
//node [label=null fillcolor=lightgray] n2
node [ label="\N"]
graph [style="filled,rounded" fillcolor="#ffdddda7"]
subgraph cluster_1 {3}
1 -> n2
1 -> 2 -> 3
2 -> 4 -> 5 -> n1
4 -> n3
5 -> 6
}
{% endgraphviz %}
將`cr`左邊子樹(淺粉色區域)移到`cr`(節點`2`)和`cr.right`(節點`4`)的中間
{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n1
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=null fillcolor=lightgray] n4
node [label=null fillcolor=lightgray] n5
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor="#ffe66d"] 2
node [label=3 fillcolor="#cce8ff"] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5

node [label=6 fillcolor=lightgray] 6
node [label=null fillcolor=lightgray] n2

node [ label="\N"]
graph [style="filled,rounded" fillcolor="#ffdddda7"]
subgraph cluster_1 {3}
1 -> 2 -> 3 -> n4
3 -> 4 ->5 -> 6
1 -> n1
4 -> n2
5 -> n3
2 -> n5
}
{% endgraphviz %}
`cr`向右移動，此時`cr`為節點`3`。
`cr`的左側為空，不需要做任何事情。
`cr`持續向右移動，如果`cr`的左側不為空，按照之前的方式將左側子樹移到`cr`和`cr.right`中間

{% graphviz %}
digraph {
//rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=null fillcolor=lightgray] n1
node [label=null fillcolor=lightgray] n2
node [label=null fillcolor=lightgray] n3
node [label=null fillcolor=lightgray] n4
node [label=null fillcolor=lightgray] n5
node [label=1 fillcolor=lightgray] 1
node [label=2 fillcolor=lightgray] 2
node [label=3 fillcolor="#ffe66d"] 3
node [label=4 fillcolor=lightgray] 4
node [label=5 fillcolor=lightgray] 5

node [label=6 fillcolor=lightgray] 6
node [label=null fillcolor=lightgray] n2

node [ label="\N"]
1 -> 2 -> 3 -> n4
3 -> 4 ->5 -> 6
1 -> n1
4 -> n2
5 -> n3
2 -> n5
}
{% endgraphviz %}

### 實作
```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:

    def flatten(self, root: Optional[TreeNode]) -> None:
        """
        Do not return anything, modify root in-place instead.
        """
        cr = root
        while cr:
            if cr.left:
                left_tail = cr.left
                while left_tail.right:
                    left_tail = left_tail.right
                left_tail.right = cr.right
                cr.right = cr.left
                cr.left = None
            cr = cr.right
```
### 時間複雜度
這個做法由於每個節點會成為一次`cr`，將`cr`的右側的子樹合併至左側的時間複雜度為$O(1)$，圖中有n個節點，時間複雜度為$O(n)$
