---
layout: article_post
title:  "17. Letter Combinations of a Phone Number"
categories: medium
tags: leetcode medium python coder recursion
excerpt_separator: <!--more-->
---

<!--more-->

# 題目

[17. Letter Combinations of a Phone Number
](https://leetcode.com/problems/letter-combinations-of-a-phone-number/)

# 解題思路

這個題目要求我們給定一個由數字組成的字串，並且根據手機鍵盤上的字母對應關係，找出所有可能的字母組合。

我們使用一個遞迴的方法來實現這個需求。我們會建立一個空的列表存放所有可能的字母組合，和一個空字串作為中間過程的暫存變量。我們會遞迴處理每個數字，每個數字都有3~4種可能的對應字母，我們會枚舉這幾種可能性，並且把當前的字母組合加入到暫存變量中。當我們枚舉完所有數字時，我們就能得到所有可能的字母組合。

我們的程式會檢查我們是否已經枚舉完了所有數字，如果是，則把當前字母組合加入到結果列表中。如果還有剩餘數字，則繼續遞迴處理下一個數字，直到所有可能的組合都被處理完。

最後，函數會回傳包含所有可能字母組合的列表。

```python
def letterCombinations(self, digits: str) -> List[str]:

        digit_to_letter = {
            "2":'abc',
            "3":'def',
            "4":'ghi',
            "5":'jkl',
            "6":'mno',
            "7":'pqrs',
            "8":'tuv',
            "9":'wxyz'
        }

        def letterComs(letters, digits, tmpstr, tlen):
            if len(digits)==0:
                return
            
            if len(tmpstr)+1 == len(digits):
                for letter in digit_to_letter[digits[tlen]]:
                    letters.append(tmpstr+letter)
            else:
                for letter in digit_to_letter[digits[tlen]]:
                    letterComs(letters, digits, tmpstr+letter, tlen+1)
        
        letters = []
        letterComs(letters, digits, "", 0)
        return letters
```
# 時間複雜度
這個題目的時間複雜度為O(4^n)，其中n是輸入字串的長度。

簡單來說，我們需要對於每個數字都花費3~4次的時間來找出所有的字母組合，而我們有n個數字，所以時間複雜度就是4^n。