---
layout: article_post
title:  "[Leetcode解題] Minimum Add to Make Parentheses Valid - stack解"
description:  "[Leetcode解題] Minimum Add to Make Parentheses Valid - stack解"
categories: medium meta
tags: stack
langs: python
excerpt_separator: <!--more-->
---
# 題目
[921. Minimum Add to Make Parentheses Valid](https://leetcode.com/problems/minimum-add-to-make-parentheses-valid/)

給定一個括號字串`s`，一次操作可以在字串的任何位置插入一個括號。請計算使字符串有效的最小操作次數。
有效括號字串的定義如下：
- 它是空字串，
- 它可以寫成AB（A與B連接），其中A和B都是有效字符串，或者
- 它可以寫成（A），其中A是有效字符串。


<!--more-->

# 解題思路
我們可以使用堆疊（*stack*）的方式來解決這個問題。我們遍歷字串，並使用*stack*來記錄未匹配的左括號的位置。當遇到右括號時，我們檢查*stack*是否為空，如果不是，則可以匹配一對括號，*stack* `pop`。如果*stack*為空，則需要`insert`一個括號。

# 實作
```python
class Solution:
    def minAddToMakeValid(self, s: str) -> int:
        stack = 0          # 用於記錄未匹配的左括號數量
        add_left = 0  # 用於記錄需要插入的左括號數量

        for char in s:
            if char == '(':
                stack += 1
            elif char == ')':
                if stack > 0:
                    stack -= 1
                else:
                    add_left += 1

        # 未匹配的左括號數量加上需要插入的右括號數量即為未匹配的括號總數
        return add_left + stack
```

# 時間複雜度
遍歷一次字串`s`，每次操作stack的時間複雜度為$O(1)$。因此，總的時間複雜度為$O(n)$，其中$n$是字串`s`的長度。