---
layout: article_post
title:  "[Leetcode解題]  641. Design Circular Deque"
description:  "Design Circular Deque"
categories: medium
tags: deque 
langs: python
excerpt_separator: <!--more-->
---

# 題目 

[641. Design Circular Deque](https://leetcode.com/problems/design-circular-deque/)

這題應該就是要我們設計一個deque，注意每個operation都要是 $O(1)$

# 解題思路

這題我們使用雙指針來記錄，一個head一個tail，當我們往前插入，head就往左移動一格，往後插入，tail。

<!--more-->

# 程式碼

```python
class MyCircularDeque:

    def __init__(self, k: int):
        self.head = 0
        self.tail = 0
        self.deque = [-1] * k
        self.k = k
        

    def insertFront(self, value: int) -> bool:
        next_head = (self.head  - 1 + self.k) % self.k
        if self.deque[next_head] != -1:
            return False
        self.deque[next_head] = value
        self.head = next_head
        return True

    def insertLast(self, value: int) -> bool:
        next_tail = (self.tail + 1) % self.k
        if self.deque[self.tail] != -1:
            return False
        self.deque[next_tail-1] = value
        self.tail = next_tail
        return True
        
    def deleteFront(self) -> bool:
        if self.isEmpty():
            return False
        self.deque[self.head] = -1
        self.head = (self.head + 1) % self.k
        return True

    def deleteLast(self) -> bool:
        next_tail = (self.tail - 1 + self.k) % self.k
        if self.isEmpty():
            return False
        self.deque[next_tail] = -1
        self.tail = next_tail
        return True

    def getFront(self) -> int:
        if self.isEmpty():
            return -1
        return self.deque[self.head]

    def getRear(self) -> int:
        if self.isEmpty():
            return -1
        return self.deque[self.tail-1]

    def isEmpty(self) -> bool:
        if self.head == self.tail and self.deque[self.head] == -1:
            return True
        return False

    def isFull(self) -> bool:
        if self.head == self.tail and self.deque[self.head] != -1:
            return True
        return False
```