---
layout: article_post
title:  "[Leetcode解題] Palindrome Number - 前後指針解"
description:  "[Leetcode解題] Palindrome Number - 前後指針解"
categories: easy
tags: two-pointers
langs: python
excerpt_separator: <!--more-->
---

題目網址: [9. Palindrome Number](https://leetcode.com/problems/palindrome-number/)

<!--more-->

# 解題思路

這題要判斷一個整數(integer)是否可以是對稱的，我們首先可以先考慮三種情況：

1. 正整數
2. 零
3. 負整數

很明顯，負整數一定不可能，因為範例直接指數負號也要一起考慮對稱，所以我們可以直接用一個判斷式解掉

而零的情況也很明顯是對稱，所以也可以直接解掉，我們所需考慮的只有正整數的狀況。

這題有一個偷吃步的方法，因為在Python中可以直接將數字轉成字串(string)，所以我們可以直接轉換再將字串做倒序(reverse)，然後判斷兩個字串若相等，即為對稱。

但若撇開這個方法，我們可以用一個序列(list)來存整數的每個位數(digit)，作法跟轉換二進位的過程很像，轉換後，我們只需要用兩個指標，一個從前面看，一個從後面看，每次如果有不一樣的狀況即非對稱，這邊我們可以想一些在奇數個位數跟偶數個位數分別會是什麼狀況。

若是偶數個位數，等到從尾巴開始的指標(後稱tail)超過從頭開始的指標(後稱head)的時候，即結束，所以都沒有Return False的話即為True。

若是奇數個位數，當兩個指標指向同個位置的時候，即結束，也不用多判斷這次，因為同個位置一定相等。

所以我們在`while迴圈`的條件可以設定成：`tail > head`。

```python
class Solution:
    def isPalindrome(self, x: int) -> bool:
        if x == 0:
            return True
        if x < 0:
            return False
        
        # Convert it to a list
        digits = []
        while x != 0:
            digit = x % 10
            digits.append(digit)
            x = x // 10
        i = 0
        while len(digits)-1-i > i:
            if digits[i] != digits[len(digits)-1-i]:
                return False
            i += 1
        return True
```

# 時間複雜度

接下來我們可以來思考一下時間複雜度

在零跟負數的情況直接用判斷式解掉，所以是`O(1)`

在拆解數字的步驟，我們要遍歷每個位數，所以是`O(n)`，令`n = 位數`，所以`n < 32`

而最後做指標判斷，最多跑`n/2`次，所以也是`O(n)`

所以整體時間複雜度為`O(n)`
