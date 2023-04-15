---
layout: article_post
title:  "[Leetcode解題] Bulls and Cows - 暴力解"
description:  "[Leetcode解題] Bulls and Cows - 暴力解"
categories: medium
tags: leetcode medium python coder
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [299. Bulls and Cows
](https://leetcode.com/problems/bulls-and-cows/)

這是一個"Bulls and Cows"遊戲，你和你的朋友玩。你先寫下一個秘密數字，然後讓你的朋友猜數字。當你的朋友猜時，你會提供一個提示，內容包括：

猜對的數字數量，這些數字在猜測中的位置正確。

猜錯的數字數量，這些數字在秘密數字中，但位置不正確。特別的是，猜測中的非公牛數(B)字可以重新排列，以使它們成為公牛(A)。

給定秘密數字secret和朋友的猜測guess，返回朋友的猜測的提示。提示應格式化為"xAyB"，其中x是公牛的數量，y是牛的數量。

特別要注意的是，secret和guess都可能包含重複的數字。

# 解題思路

這題我們直覺去遍歷secret和guess的每一位，如果他們相同且位置也相同，就增加"bulls"的數量；如果他們相同但位置不同，就增加"cows"的数量。最後，根據統計的"bulls"和"cows"的數量，按照題目的要求格式化輸出即可。

```python
class Solution:
    def getHint(self, secret: str, guess: str) -> str:
        bull, cow = 0, 0
        s = [0] * 10
        g = [0] * 10
        for i in range(len(secret)):
            if secret[i] == guess[i]:
                bull += 1
            else:
                s[int(secret[i])] += 1
                g[int(guess[i])] += 1
        for i in range(10):
            cow += min(s[i], g[i])
        return f'{bull}A{cow}B'
```

在這段程式碼中，我們首先定義了一個Solution類別，裡面有一個名為getHint的方法，用來獲得提示字串。我們用兩個變數bull和cow來計算有多少數字是在正確的位置，以及有多少數字是不在正確的位置但是存在於密碼中。

我們使用兩個陣列s和g來記錄密碼和猜測數字中每一個數字出現的次數。如果猜測的數字和密碼中的數字在同一個位置上，則把bull加1。如果不是，則把s和g中對應的位置加1，表示這個數字在密碼和猜測數字中出現了一次。

最後，我們在一個循環中計算cow的值，即把s和g中對應位置的最小值相加。

# 時間複雜度

這題的時間複雜度是 $O(n)$，其中 $n$ 是 guess 和 secret 的總字元數。因為對於每個字元，我們都需要檢查是否是 "bull" 或 "cow"，所以總時間複雜度是線性的。



