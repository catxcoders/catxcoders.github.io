---
layout: article_post
title:  "[Leetcode解題] Permutations - 遞迴/backtrace解"
description:  "[Leetcode解題] Permutations - 遞迴/backtrace解"
categories: medium
tags: recursion backtrace
langs: python
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [46. Permutations](https://leetcode.com/problems/permutations/)

# 題目
這是一個數組的排列組合題。給定一個元素獨一無二的數組，求出所有可能的排列。

## 解題思路
這道題可以使用回溯算法來解決，解題思路如下：

回溯法是一種通過搜索所有可能的解來找到所有可能解的一种方法。我們可以在數組的每個位置上選擇一個數字，然後對剩下的數字進行遞歸搜索，找到所有可能的排列。

## 算法流程
1. 建立一個空列表，用於存儲當前排列
2. 在數組中選擇一個數字，加入到列表中
3. 對剩下的數字進行遞歸搜索
4. 如果列表長度等於數組長度，就將當前排列加入結果列表
5. 否則，對剩下的數字進行遞歸搜索
6. 刪除列表中的最後一個元素，以便返回上一個狀態
7. 重複2-6步，直到所有排列都被找到


## 實作
以下是一個使用回溯法的 Python 解決方案：
```python
class Solution:
    def permute(self, nums):
        def backtrack(first=0):
            if first == n:
                output.append(nums[:])
            for i in range(first, n):
                nums[first], nums[i] = nums[i], nums[first]
                backtrack(first + 1)
                nums[first], nums[i] = nums[i], nums[first]

        n = len(nums)
        output = []
        backtrack()
        return output
```
代碼說明：

1. 定義一個名為 backtrack 的函數，用於進行回溯搜索。
2. 如果當前位置 first 等於數組長度 n，則將當前排列加入結果列表 output。
3. 在數組的剩下部分中遍歷每個數字，並交換當前位置的數字和遍歷到的數字。
4. 對剩下的數字進行遞歸调用 backtrack 函数，找到所有可能的排列。
5. 交換回原來的數字，以便回溯到上一個狀態。
6. 返回結果列表。

## 複雜度
由於所有整數均為唯一的，則時間複雜度為 $O(n! / (n1! * n2! * ... * nk!))$，其中 $n!$ 表示 $n$ 的階乘，$ni$ 表示數字 $i$ 在數組中的出現次數。因此，如果所有整數均為唯一的，則時間複雜度將等於 $O(n!)$。
