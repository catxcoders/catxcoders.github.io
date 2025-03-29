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
<!--more-->

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

