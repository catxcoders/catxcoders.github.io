---
layout: article_post
title:  "[Leetcode解題] 394. Decode String - 用stack解"
description:  "[Leetcode解題] 394. Decode String - 用stack解"
categories: medium 
tags:  stack
langs: python
excerpt_separator: <!--more-->
---

## 題目

[394. Decode String](https://leetcode.com/problems/decode-string/)

給定一個字串，中括號外一定是數字，表示括號內的字串重複幾次。

舉例來說，`3[acf]`，表示`acf`要重複3次`acfacfacf`。

<!--more-->

## 解題思路

我們可以觀察到這題會層層推進，所以第一會想到可以利用`stack`來做，那裡面要存的是什麼，還有什麼時候要進行`stack.pop()`跟`stack.append()`。

我們紀錄字串重複的次數，以及目前記錄到的字串放到stack，這個目前記錄到的字串表示為`prefix`，也就是我們算完重複的字串後要加到前面的部分。

舉例來說，`abc3[c]`，我們在重複完3次c後，要再把abc加到前面得到`abcccc`這樣。

所以，我們stack裡面存的東西為一個`tuple`，分別代表重複次數跟prefix。

在遇到左括號的時候，我們把`tuple`放到stack裡面，然後重新紀錄下一層`tuple`。在遇到右括號的時候，我們進行`pop()`，以element表示pop出來的tuple，然後進行這個操作：

`prefix = element[1] + element[0] * prefix`

這邊就是將目前當層的prefix乘以倍數，然後再把上一層prefix加到前面。

所以如果後面已經沒有元素的，那代表已經再最外層，prefix就是最後答案。

```python
class Solution(object):
    def decodeString(self, s):
        """
        :type s: str
        :rtype: str
        """
        def is_digit(c):
            return ord('0') <= ord(c) <= ord('9')
        
        st = []
        prefix = ''
        num = ''
        for c in s:
            if c == '[':
                st.append((int(num), prefix))
                num = ''
                prefix = ''
            elif c == ']':
                element = st.pop()
                prefix = element[1] + element[0] * prefix
            elif is_digit(c):
                num += c
            else:
                prefix += c
        return prefix
```

## 時間複雜度

我們從頭跑到尾一次，所以是$O(n)$，n表示為字串的長度。
