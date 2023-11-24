---
layout: article_post
title:  "[Leetcode解題] Longest Valid Parentheses - Stack解"
description:  "[Leetcode解題] Longest Valid Parentheses - Stack解"
categories: medium
tags: stack
langs: python
excerpt_separator: <!--more-->
---

題目網址: [32. Longest Valid Parentheses](https://leetcode.com/problems/longest-valid-parentheses/)

# 題目
最長有效括號子字串長度。

<!--more-->

# 解題思路

這個問題可以使用堆疊(stack)的概念來解決。我們可以遍歷字符串，並維護一個stack，使得stack的最新的索引(index)`k`，代表子字串`s[k+1, cr]`是以`cr`結尾的最長有效括號。

## 算法
1. 在Python中使用List創建一個堆疊(stack)，並將`-1`放入堆疊(stack)作為起始索引(index)，由於`stack[-1]`是非有效但離`cr`最近的索引`idx`，而s[0]有可能為有效括號，因此要預放入index `-1`。
3. 遍歷字串`s`，對於每個字符：
    - 如果遇到`(`，將其索引(index)放入(push)堆疊（stack）
    - 如果遇到`)`，從堆疊（stack）中彈出(pop)一個元素，*表示配對的`(`的索引(index)*
        - 如果堆疊(stack)為空
            - **將當前索放入堆疊(stack)**，*因為我們要維護stack，使得最新的索引(index)`stack[-1]`是非有效但離`cr`最近的索引`idx`，與一開始放入`-1`同理*
        - 否則，
            - **計算當前有效括號子字串的長度**: 由於最新的元素`stack[-1]`是非有效但離cr最近的索引idx，所以**當前有效括號子字串的長度 = 當前索引`cr`-堆疊(stack)最新的元素`stack[-1]`**
            - 更新最長有效括號子字串的長度
4. 返回最長有效括號子字串的長度

## 實作

```python
class Solution:
    def longestValidParentheses(self, s: str) -> int:
        stack = [-1]  # 堆疊，起始索引為-1
        max_length = 0  # 最長有效括號子字串的長度

        for cr in range(len(s)):
            if s[cr] == '(':
                stack.append(cr)  # 遇到'('，將其索引壓入堆疊
            else:  # 遇到')'
                stack.pop()  # 彈出一個元素（表示配對的'('的索引）
                if len(stack) == 0:  # 如果堆疊變為空
                    stack.append(cr)  # 將當前索引壓入堆疊
                else:  # 堆疊不為空
                    # 當前有效括號子字串的長度
                    length = cr - stack[-1]  
                    
                    # 更新最長有效括號子字串的長度
                    max_length = max(max_length, length)  

        return max_length

```


## 複雜度
* 時間複雜度：該算法遍歷一次字符串，所以時間複雜度為$O(n)$，其中$n$是字符串的長度。
* 空間複雜度：該算法使用了一個堆疊來存儲索引，最壞情況下，堆疊的大小為$n$，所以空間複雜度為$O(n)$。