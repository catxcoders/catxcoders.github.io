---
layout: article_post
title: "[Leetcode解題] Merge Two Sorted Lists - 指針解"
description: "[Leetcode解題] Merge Two Sorted Lists - 指針解"
categories: easy
tags: linked-list pointer
langs: python
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [21. Merge Two Sorted Lists](https://leetcode.com/problems/merge-two-sorted-lists/description/)

# 解題思路
不論這兩條`List`有沒有排序過，都可以直接將這兩條`List`拼起來再做sort，這樣的時間複雜度是O(nlogn), n為兩條`List`總元素個數。
因為兩條`List`都是排序好的，因此可以試著運用這個特性，來減少計算量。
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [label=5 fillcolor=lightgray] 2.5
node [ label="\N"]
1.1 -> 1.2 -> 1.4
2.1 -> 2.3 -> 2.4 -> 2.5
}
{% endgraphviz %}
比較兩條排序好的`list`的第一個元素，將比較小的元素接到比較result後，直到至少有一條List為空

{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [label=5 fillcolor=lightgray] 2.5
node [ label="\N"]
1.2 -> 1.4
2.1 ->2.3 -> 2.4 -> 2.5
result -> 1.1  
}

{% endgraphviz %}
---

{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [label=5 fillcolor=lightgray] 2.5
node [ label="\N"]
1.2 -> 1.4
2.3 -> 2.4 -> 2.5
result -> 1.1 -> 2.1
}

{% endgraphviz %}
---

{% graphviz %}

digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [label=5 fillcolor=lightgray] 2.5
node [ label="\N"]
1.4
2.3 -> 2.4 -> 2.5
result ->1.1 -> 2.1 -> 1.2
}

{% endgraphviz %}
---
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [label=5 fillcolor=lightgray] 2.5
node [ label="\N"]
1.4
2.4 -> 2.5
result ->1.1 -> 2.1 -> 1.2 -> 2.3
}

{% endgraphviz %}
---
只剩下一條list還有元素，把這條list剩餘的元素按照順序直接放到result的最尾端
{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [label=5 fillcolor=lightgray] 2.5
node [ label="\N"]

2.4 -> 2.5
result ->1.1 -> 2.1 -> 1.2 -> 2.3 -> 1.4
}

{% endgraphviz %}

---
我們就成功把兩條排序好的List合成一條排序好的List了!!

{% graphviz %}
digraph {
rankdir=LR
ranksep=0.3
node [shape=box style="rounded,filled" height=0.3]
node [label=1 fillcolor=pink] 1.1
node [label=2 fillcolor=pink] 1.2
node [label=4 fillcolor=pink] 1.4
node [label=1 fillcolor=lightgray] 2.1
node [label=3 fillcolor=lightgray] 2.3
node [label=4 fillcolor=lightgray] 2.4
node [ label="\N"]

result ->1.1 -> 2.1 -> 1.2 -> 2.3 -> 1.4 -> 2.4 -> 2.5
}

{% endgraphviz %}

# 實作
```python
# Definition for singly-linked list.
# class ListNode:
#     def __init__(self, val=0, next=None):
#         self.val = val
#         self.next = next
class Solution:
    def mergeTwoLists(self, list1: Optional[ListNode], list2: Optional[ListNode]) -> Optional[ListNode]:
        cr = mergeList = ListNode()
        while list1 and list2:
            if list1.val < list2.val:
                cr.next = list1
                list1 = list1.next
                cr = cr.next
            else:
                cr.next = list2
                list2 = list2.next
                cr = cr.next
        
        cr.next = list1 if list1 else list2
        return mergeList.next
```
