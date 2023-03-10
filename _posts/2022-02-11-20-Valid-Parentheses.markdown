---
layout: article_post
title:  "20. Valid Parentheses"
categories: easy
tags: leetcode easy python coder stack
excerpt_separator: <!--more-->
---

# 題目

[20. Valid Parentheses
](https://leetcode.com/problems/valid-parentheses/)

# 解題思路

這題算是一題非常經典的堆疊(stack)問題，我們必須利用stack先進後出(FILO)的特性來解題。題目簡單來說，就是要判斷括號是不是合法的括號，題目僅限有三種可能的括號'{}', '()', '[]'，所以我們不需要考慮其他符號出現的可能。

如果我們從左看到右，我們只要看到左括號，就把它放進Stack中，而當我們看到右括號，我們就看跟Stack最上方(stack.top())的左括號有沒有匹配，如果有的話，就代表目前還是合法的括號，繼續往下看，而如果不匹配，代表現在的括號已經不合法，可以直接回傳False了。當然也有一種可能是，我們看到右括號但Stack是空的，那這樣也是不合法的，例如"](())"。

如果我們順利看完所有的括號都合法，我們還要特別確認Stack是否為空，因為如果不為空，代表還有一些左括號並沒有匹配到右括號，這樣也不是一個合法的情況，例如"(()"，如果為空的話，那就能確定是正確的情況。


```python
class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        for c in s:
            if c in ['(', '[', '{']:
                stack.append(c)
            else:
                if not stack:
                    return False
                target = stack.pop()
                if target == '(' and c != ')':
                    return False
                if target == "[" and c != ']':
                    return False
                if target == '{' and c != '}':
                    return False
        if not stack:
            return True
        return False

```

# 時間複雜度

基本上我們要看過整個字串為$O(n)$，而加入元素到Stack，跟從Stack上方移除元素(也就是stack.pop())都是$O(1)$，所以時間複雜度為$O(n)$