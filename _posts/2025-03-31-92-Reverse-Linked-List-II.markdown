---
layout: article_post
title:  "[Leetcode解題] 92. Reverse Linked List II"
description:  "92. Reverse Linked List II"
categories: medium
tags: linked-list
langs: python
excerpt_separator: <!--more-->
---

## 題目
[92. Reverse Linked List II](https://leetcode.com/problems/reverse-linked-list-ii/)
給定一個單向鏈表的頭節點 `head`，以及兩個整數 `left` 和 `right`，其中 `1 <= left <= right <= 鏈表長度`。請反轉從位置 `left` 到 `right` 的節點（從 1 開始計數），並返回**修改後的鏈表頭節點**。

## 解題思路
這題目是一個典型的鏈表操作問題，重點在於：  
- 先走到 `left` 節點的**前一個節點**（`left - 1`）。
- 再找到 `right` 節點。
- 將這段區間的鏈表**截斷並反轉**。
- 最後**接回原本的鏈表**。

步驟拆解如下：
1. 使用 dummy node（虛擬頭節點）來簡化邊界條件（例如反轉從 head 開始的情況）。
2. 走訪鏈表，找到反轉開始點前一節點 `s`（`left - 1`）和反轉結束點 `e`（`right`）。
3. 暫時截斷這段子鏈表，並呼叫輔助函數反轉它。
4. 再將反轉後的結果接回原來的鏈表。

## Python 實作
```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

class Solution:
    def reverse(self, head):
        prev = None
        curr = head
        while curr:
            nxt = curr.next
            curr.next = prev
            prev = curr
            curr = nxt
        return prev

    def reverseBetween(self, head: ListNode, left: int, right: int) -> ListNode:
        dummy = ListNode(0)
        dummy.next = head
        prev = dummy

        for _ in range(left - 1):
            prev = prev.next
        
        # Reverse the segment
        start = prev.next
        end = start
        for _ in range(right - left):
            end = end.next
        next_segment = end.next
        end.next = None

        # Reverse and reconnect
        prev.next = self.reverse(start)
        start.next = next_segment

        return dummy.next
```

## C++ 實作
```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    // 反轉整個鏈表（工具函式）
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;

        while (curr) {
            ListNode* nextTemp = curr->next;
            curr->next = prev;
            prev = curr;
            curr = nextTemp;
        }
        return prev;
    }

    ListNode* reverseBetween(ListNode* head, int left, int right) {
        // 加入 dummy node，避免 head 就是要反轉的情況不好處理
        ListNode* dummy = new ListNode(0);
        dummy->next = head;

        // 1. 找到 left 前一個節點 prev
        ListNode* prev = dummy;
        for (int i = 1; i < left; ++i) {
            prev = prev->next;
        }

        // 2. 找到要反轉的子鏈表的頭 start 和尾 end
        ListNode* start = prev->next;      // left 節點
        ListNode* end = start;
        for (int i = left; i < right; ++i) {
            end = end->next;
        }

        // 3. 保存 end 後面的節點
        ListNode* nextSegment = end->next;
        end->next = nullptr;  // 暫時切斷

        // 4. 反轉 start 到 end
        prev->next = reverseList(start);

        // 5. 接回後段
        start->next = nextSegment;

        return dummy->next;
    }
};
```

## 時間複雜度分析
- **時間複雜度**：`O(n)`  
  - 我們走訪了整個鏈表一次來定位 `left` 和 `right`，然後反轉中間的子鏈表（最多也是 `n` 長度），所以總體是線性時間。

- **空間複雜度**：`O(1)`  
  - 只使用了常數個指標變數，沒有額外的空間開銷。
