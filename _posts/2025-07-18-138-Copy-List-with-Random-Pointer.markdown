---
layout: article_post
title:  "[Leetcode解題] 138. Copy List with Random Pointer"
description:  "138. Copy List with Random Pointer"
categories: medium
tags: hashmap linked-list
langs: python
excerpt_separator: <!--more-->
---

## 題目
[138. Copy List with Random Pointer](https://leetcode.com/problems/copy-list-with-random-pointer/)
給你一個 **含有 random 指標的鏈結串列 (Linked List)**，每個節點除了 `next` 還多了一個 `random`，可以指到串列裡的任意節點，或者是 `null`。

現在要 **深拷貝 (deep copy)** 這個串列，回傳一個全新的鏈結串列。

條件是：
* 新串列的節點要跟舊串列 **完全對應**，值一樣、`next` 指向新串列的對應節點，`random` 也要對應到新串列的對應節點。
* 絕對不能讓新串列的指標指到舊串列的節點。


## 解題思路

這題有兩種常見做法：

1. **用 Hash Map 記錄對應關係 (簡單易懂，$O(n)$ 空間)**

* 第一次遍歷，把每個舊節點 `old` 建一個新節點 `new`，並存在 `map[old] = new`。
* 第二次遍歷，補上 `random` 連結，因為 `old.random` 的對應新節點就是 `map[old.random]`。

這個方法比較直覺，程式碼簡單，但需要額外 $O(n)$ 記憶體。

2. **新舊穿插的 $O(1)$ 空間做法 (進階技巧)**

* 先把新節點插在舊節點後面：`A → A' → B → B' → C → C'`
* 然後設定 `A'.random = A.random.next`
* 最後拆開兩條串列。

空間省，但比較不好懂。


## **Hash Map 版本** C++ 實作
```cpp
/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* next;
    Node* random;
    
    Node(int _val) {
        val = _val;
        next = NULL;
        random = NULL;
    }
};
*/

class Solution {
public:
    Node* copyRandomList(Node* head) {
        if (!head) return nullptr;  // 空串列直接回傳
        
        unordered_map<Node*, Node*> oldToNew;
        
        // 第一次走訪：先把所有節點複製出來
        Node* curr = head;
        while (curr) {
            oldToNew[curr] = new Node(curr->val);
            curr = curr->next;
        }
        
        // 第二次走訪：補上 next & random
        curr = head;
        while (curr) {
            oldToNew[curr]->next = curr->next ? oldToNew[curr->next] : nullptr;
            oldToNew[curr]->random = curr->random ? oldToNew[curr->random] : nullptr;
            curr = curr->next;
        }
        
        return oldToNew[head];
    }
};
```


## **Hash Map 版本** Python 實作
```python
"""
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None, random: 'Node' = None):
        self.val = int(x)
        self.next = next
        self.random = random
"""

class Solution:
    def copyRandomList(self, head: 'Optional[Node]') -> 'Optional[Node]':
        if not head:
            return None
        
        old_to_new = {}
        
        # 第一次遍歷，複製每個節點
        curr = head
        while curr:
            old_to_new[curr] = Node(curr.val)
            curr = curr.next
        
        # 第二次遍歷，補上 next 跟 random
        curr = head
        while curr:
            old_to_new[curr].next = old_to_new.get(curr.next)
            old_to_new[curr].random = old_to_new.get(curr.random)
            curr = curr.next
        
        return old_to_new[head]
```


## 新舊穿插的 C++ 做法

```cpp
/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* next;
    Node* random;
    
    Node(int _val) {
        val = _val;
        next = NULL;
        random = NULL;
    }
};
*/

class Solution {
public:
    Node* copyRandomList(Node* head) {
        if (!head) return nullptr;

        // 1. 插入拷貝節點
        Node* curr = head;
        while (curr) {
            Node* newNode = new Node(curr->val);
            newNode->next = curr->next;
            curr->next = newNode;
            curr = newNode->next;
        }

        // 2. 設定 random
        curr = head;
        while (curr) {
            if (curr->random)
                curr->next->random = curr->random->next;
            curr = curr->next->next;  // 跳過拷貝節點
        }

        // 3. 拆成兩條串列
        curr = head;
        Node* newHead = head->next;
        while (curr) {
            Node* copyNode = curr->next;
            curr->next = copyNode->next;  // 還原舊串列
            if (copyNode->next)
                copyNode->next = copyNode->next->next;  // 連接新串列
            curr = curr->next;
        }

        return newHead;
    }
};
```

## 新舊穿插的 Python 做法
```python
"""
# Definition for a Node.
class Node:
    def __init__(self, x: int, next: 'Node' = None, random: 'Node' = None):
        self.val = int(x)
        self.next = next
        self.random = random
"""
class Solution:
    def copyRandomList(self, head: 'Optional[Node]') -> 'Optional[Node]':
        if not head:
            return None

        # 1. 插入拷貝節點
        curr = head
        while curr:
            copy = Node(curr.val)
            copy.next = curr.next
            curr.next = copy
            curr = copy.next

        # 2. 設定 random
        curr = head
        while curr:
            if curr.random:
                curr.next.random = curr.random.next
            curr = curr.next.next

        # 3. 拆成兩條串列
        curr = head
        new_head = head.next
        while curr:
            copy = curr.next
            curr.next = copy.next
            if copy.next:
                copy.next = copy.next.next
            curr = curr.next

        return new_head
```

## 複雜度分析

### Hash Map 版本
* 時間：$O(n)$
* 空間：$O(n)$ （Hash Map 存對應關係）

### 新舊穿插的做法
* 時間：$O(n)$ （還是走兩遍）
* 空間：$O(1)$ （沒額外用 Map）
