---
layout: article_post
title:  "[Leetcode解題]  1106. Parsing A Boolean Expression"
description:  "1106. Parsing A Boolean Expression - 用指針解"
categories: hard
tags: pointer array
langs: python
excerpt_separator: <!--more-->
---

# 1106. Parsing A Boolean Expression

# 題目

[1106. Parsing A Boolean Expression
](https://leetcode.com/problems/parsing-a-boolean-expression/)

這題我們給一個`boolean expression`，然後要判斷最後的結果，有可能的`operation`有`!`, `&`, `|`，這邊題目給的字串一定符合規則。

<!--more-->

# 解題思路

這題我一開始想可以用遞迴解，因為每個`subexpression`，其實就可以直接跑過一次，然後再繼續算上一層的`expression`。

但這麼做的話，我們會必須先切出`subexpresion`的位置，那可想而知我們會有很多重複計算。例如：

`!(!(!(!(!(!(!(!(!(!(!(f)))))))))))`

這是一個極端的例子，我們一開始要先切出一個subexpression，然後到下一層，又要再切，這樣時間是$O(n^2)$

所以，我們其實可以直接透過指針加上判斷式來解就好，這樣可以確保時間複雜度在 $O(n)$ 並且沒有重複計算的部分。

我們可以用一個stack來存目前的operation，並用另一個stack存相對應operation目前算到的值，這樣可以讓我們把每一層operation目前計算的值分開來，直到算完，再update回上一層。

# 程式碼

```python
operation_stack = []
        bool_stack = []
        
        expression= list(expression)
        ptr = 0
        while ptr < len(expression):
            # print(ptr, expression[ptr], operation_stack, bool_stack)
            if expression[ptr] in ["&", "|", "!"]:
                operation_stack.append(expression[ptr])
                bool_stack.append(None)
                ptr += 2
            elif expression[ptr] == "t":
                if not operation_stack:
                    return True
                if operation_stack[-1] == "&":
                    bool_stack[-1] = True if bool_stack[-1] is None else bool_stack[-1]
                elif operation_stack[-1] == "|":
                    bool_stack[-1] = True
                else:
                    bool_stack[-1] = False
                ptr += 1
            elif expression[ptr] == "f":
                if not operation_stack:
                    return False
                if operation_stack[-1] == "&":
                    bool_stack[-1] = False
                elif operation_stack[-1] == "|":
                    bool_stack[-1] = False if bool_stack[-1] is None else bool_stack[-1]
                else:
                    bool_stack[-1] = True
                ptr += 1
            elif expression[ptr] == ",":
                ptr += 1
            elif expression[ptr] == ")":
                if bool_stack[-1]:
                    expression[ptr] = "t"
                else:
                    expression[ptr] = "f"
                operation_stack.pop()
                bool_stack.pop()
        return False
```

# 時間複雜度

$O(n)$