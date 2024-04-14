---
layout: article_post
title:  "[Leetcode解題] 438. Find All Anagrams in a String"
description:  "[Leetcode解題] 438. Find All Anagrams in a String"
categories: medium
tags: two-pointers hashmap
langs: python
excerpt_separator: <!--more-->
---

## 題目

[438. Find All Anagrams in a String](https://leetcode.com/problems/find-all-anagrams-in-a-string/)

給定兩個字串`s1`與`s2`，判斷`s2`中是否包含`s1`其中一種排列組合的子字串，回傳各個位置的indices

<!--more-->

## 解題思路

跟[567. Permutation in String](https://leetcode.com/problems/permutation-in-string/)很類似，我們也是透過搜尋`set`的概念來解。

這邊我們用兩個指標分別為`head`跟`tail`來代表起始跟結束，兩指標之間的子字串(substring)即為我們正在判斷的`anagram`

我們一開始先將目標字串建立成`hashmap`或`字典`的形式，舉例來說`abc`就會建立成`{a: 1, b: 1, c: 1}`的形式。

接下來，我們開始在字串`s`中搜尋，每當`tail`往前一步，就會減少`hashmap`對應字元的數目，反之，`head`往前一步就會增加，只要`hashmap`中所有字元的數目皆為零即表示我們找到一組解答。

但是，有下列兩種情況需要特別考慮：

1. 如果tail指到的字元不存在於字典中：那麼包含這個位置一定不可能構成跟目標一樣的`set`，所以我們要把`tail`跟`head`都移動到下一個字元的位置
2. 如果字典中該字元的數量已經為0：那麼我們需要移動head來將一些字元加回去讓其有機會繼續往前移動。

最後，我們其實不需要判斷說字典每個值都為零，我們只需要確認`tail`跟`head`之間的字串長度是否跟`p`一樣即可，因為`tail`和`head`的距離就是我們從字典拿走多少數目。

## 實作
```python
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        d = {}
        for c in p:
            d.setdefault(c, 0)
            d[c] += 1
        
        output = []
        head = 0
        tail = 0
        while tail < len(s):
            if s[tail] not in d:
                while head < tail:
                    d[s[head]] += 1
                    head += 1
                head = tail = tail + 1
            elif d[s[tail]] == 0:
                d[s[head]] += 1
                head += 1
            else:
                d[s[tail]] -= 1
                tail += 1
            
            if tail - head == len(p):
                output.append(head)
                d[s[head]] += 1
                head += 1
        return output
```

## 時間複雜度

因為使用兩個指標跑過一次迴圈所以為$O(n)$
