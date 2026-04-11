---
layout: article_post
title:  "[Leetcode解題] 206. Reverse Linked List"
description:  "206. Reverse Linked List"
categories: easy
tags: linked-list
langs: python
excerpt_separator: <!--more-->
---

## 題目
[206. Reverse Linked List](https://leetcode.com/problems/reverse-linked-list/)
給定一個單向鏈結串列的頭節點 `head`，請你將整個鏈結串列反轉，並回傳反轉後的頭節點。
<!--more-->

### 範例
#### **範例 1**
```
輸入：head = [1,2,3,4,5]
輸出：[5,4,3,2,1]
```
#### **範例 2**
```
輸入：head = [1,2]
輸出：[2,1]
```
#### **範例 3**
```
輸入：head = []
輸出：[]
```

## **解題思路**
我們可以使用 **兩種方法** 來解這題：
1. **迭代法 (Iterative Approach)** → 使用三個指標 (`prev, curr, next`)
2. **遞迴法 (Recursive Approach)** → 遞迴反轉每個節點

### **方法 1：迭代法**
我們可以使用三個指標來處理：
- `prev` 指向已經反轉的部分 (初始為 `NULL`)
- `curr` 指向目前要處理的節點
- `next` 暫存 `curr` 的下一個節點，避免鏈結遺失

反轉的步驟如下：
1. 用 `next` 暫存 `curr->next`
2. 把 `curr->next` 指向 `prev`
3. `prev` 移動到 `curr`
4. `curr` 移動到 `next`
5. 直到 `curr` 變成 `NULL`，此時 `prev` 就是新的頭節點

**時間複雜度**：O(n)  
**空間複雜度**：O(1) (只使用了額外的指標)

### **方法 2：遞迴法**
在遞迴方法中，每次反轉 `head->next`，然後將 `head->next->next = head` 來讓下一個節點指向自己，最後把 `head->next` 設為 `NULL`。

遞迴的核心步驟：
1. 如果 `head` 為空或 `head->next` 為空，直接回傳 `head` (表示只有一個節點)
2. 遞迴處理 `head->next`
3. 反轉 `head->next->next = head`
4. `head->next = NULL`
5. 回傳新的頭節點

**時間複雜度**：O(n)  
**空間複雜度**：O(n) (遞迴的堆疊佔用)
## C++ 解法
### **方法 1：迭代法**
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
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = NULL;
        ListNode* curr = head;
        ListNode* next;

        while (curr) {
            next = curr->next; // 暫存下一個節點
            curr->next = prev; // 反轉指標
            prev = curr;       // prev 前進
            curr = next;       // curr 前進
        }
        return prev; // 最後 prev 會是新的頭
    }
};
```

### **方法 2：遞迴法**
```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (!head || !head->next) return head; // base case

        ListNode* newHead = reverseList(head->next); // 反轉剩下的部分
        head->next->next = head; // 讓下一個節點指向自己
        head->next = NULL; // 斷開原本的連結
        return newHead;
    }
};
```

## **Python 解法**
### **方法 1：迭代法**
```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        prev = None
        curr = head
        
        while curr:
            next_node = curr.next  # 暫存下一個節點
            curr.next = prev       # 反轉指標
            prev = curr            # prev 前進
            curr = next_node       # curr 前進
        
        return prev  # prev 變成新的頭節點
```

### **方法 2：遞迴法**
```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if not head or not head.next:
            return head  # base case
        
        new_head = self.reverseList(head.next)  # 反轉剩下的部分
        head.next.next = head  # 讓下一個節點指向自己
        head.next = None  # 斷開原本的連結
        return new_head
```

## **時間與空間複雜度分析**
- 迭代法: 時間複雜度$O(n)$, 空間複雜度$O(1)$
- 遞迴法: 時間複雜度$O(n)$, 空間複雜度$O(n)$ (遞迴堆疊)

如果 **記憶體有限**，建議使用 **迭代法**，因為它只需要幾個指標變數，不會佔用額外的遞迴堆疊空間。
