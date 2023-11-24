---
layout: article_post
title:  "[Leetcode解題] 227. Basic Calculator II"
description: "[Leetcode解題] 經典Leetcode必刷題目"
categories: medium
tags: stack meta
langs: python
excerpt_separator: <!--more-->
---

# 題目:
[227. Basic Calculator II](https://leetcode.com/problems/basic-calculator-ii/)

給定一個字符串s，表示一個表達式，請求解這個表達式的值。

- 整數除法應該向零而不是向無限小截斷。
- 你可以假設給定的表達式始終是有效的。所有中間結果都將在範圍$[-2^{31}, 2^{31}-1]$內。
- 注意：不允許使用任何內置函數來評估字符串作為數學表達式，如eval()。
<!--more-->


# 解題思路:

> 這個問題的核心思想是使用**堆疊**（*stack*）來處理表達式的求值。

使用**堆疊**（*stack*）的原因在於它能夠有效地處理表達式中的**嵌套**(類似俄羅斯娃娃)和**優先級**。每次遇到運算符，我們可以將當前數字和運算符放入(*push*)堆疊，並繼續處理後面的部分。這樣，在遇到優先級較高的運算符時，我們可以先處理stack中的運算，確保遵循正確的計算順序。最終，stack中的元素就是按照運算順序排列的中間結果，將它們相加即可得到最終的計算結果。

- 使用遍歷字符串的方式，逐個字符處理表達式。
- 使用變數來保存當前數字和運算符。
- 遇到數字字符時，更新當前數字。
- 遇到運算符或字符串結尾時，根據當前運算符對前一個數字進行運算，然後更新運算符和當前數字。
- 使用陣列（或列表）保存中間結果，最終將中間結果相加得到最終結果。

# 實作:
```python
class Solution:
    def calculate(self, s: str) -> int:
        stack = []
        op = '+'
        num = 0
        
        for c in s+'+': 
            if c.isdigit():
                # Build the number by updating the current value
                num = num * 10 + int(c)

            # If at the end of the string or encountering an operator, means we get the num
            if c in ['+', '-', '*', '/']:
                if op == '*':
                    stack[-1] *= num
                elif op == '/':
                    stack[-1] = int(stack[-1]/num) # round towards zero rather than negative infinity
                else:
                    stack.append(num if op == '+' else -num)
                # Initialize num and update op
                num = 0
                op = c

        return sum(stack)
```
- **使用 for c in s+`+`**: 遍歷表達式中的每個字符，並在字符串的末尾添加一個 `+`，確保最後一個數字能被正確處理。
- **if `c.isdigit()`**: 判斷字符是否為數字，如果是，則更新當前數字 `num`，以構建完整的數字。
- 如果遇到運算符或字符串結尾，表示我們得到了一個完整的數字，需要根據當前運算符對其進行運算。

> 注意: 在此Python實作中的整數除法使用`int()`運算而不是`//`，以達到截斷向零的效果。

# 時間複雜度:
- 時間複雜度為$O(n)$，其中$n$是字符串的長度。我們需要遍歷整個字符串一次。




