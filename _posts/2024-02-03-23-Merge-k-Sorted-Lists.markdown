---
layout: article_post
title:  "[Leetcode解題] 23. Merge k Sorted Lists - heap(Priority Queue)解"
description:  "[Leetcode解題] 23. Merge k Sorted Lists - heap(Priority Queue)解"
categories: hard amazon microsoft apple
tags: heap
langs: python
excerpt_separator: <!--more-->
---

## 題目

[23. Merge k Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/description/)

給定 $k$ 個已經排序的 `linked-lists`，將它們合併成一個排序的 `linked-list`，並返回。
<!--more-->


## 解題思路：
1. 我們可以使用*Priority Queue*（優先級佇列）來維護每個list的head節點。
2. 將每個list的head節點加入*Priority Queue*，以確保優先出現最小值的head節點。
3. 依次從*Priority Queue*中取出最小值的head節點，將其加入結果list。
4. 如果取出的head節點有下一個節點，將其加回*Priority Queue*。
5. 重複以上步驟，直到*Priority Queue*為空，即所有list都被合併。

## Python 實作：
```python
class Solution:
    def mergeKLists(self, lists: List[Optional[ListNode]]) -> Optional[ListNode]:
        # 定義Priority Queue
        min_heap = []
        
        # 初始化，將每個list的頭節點加入Priority Queue
        for i, lst in enumerate(lists):
            if lst:
                heapq.heappush(min_heap, (lst.val, i, lst))
        
        # 初始化結果list的頭節點
        dummy = ListNode()
        current = dummy
        
        # 開始合併
        while min_heap:
            val, i, node = heapq.heappop(min_heap)
            current.next = node
            current = current.next
            
            # 如果head節點有下一個節點，將其加回Priority Queue
            if node.next:
                heapq.heappush(min_heap, (node.next.val, i, node.next))
        
        return dummy.next
```

## C++ 實作：
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
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        auto cmp = [](const  ListNode* a, const ListNode* b){
            return a->val > b->val;
        };
        priority_queue<ListNode*, vector<ListNode*>, decltype(cmp)> pq(cmp);
        ListNode* merged_list = new ListNode();
        ListNode* cr = merged_list;

        for (auto list: lists){
            if (list){
                pq.push(list);
            }
        }

        while(!pq.empty()){
            cr -> next = pq.top();
            pq.pop();
            cr = cr -> next;
            if (cr -> next){
                pq.push(cr -> next);
            }
        }

        auto result = merged_list->next;
        delete merged_list;
        return result;
    }
};
```

## 時間複雜度：
假設 $k$ 為`list`數量，$n$ 為所有`list`節點的總數。在最壞情況下，每個`list`的每個節點都需要進出Priority Queue一次，所以時間複雜度為 $O(n log k)$。