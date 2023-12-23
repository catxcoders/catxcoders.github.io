---
layout: article_post
title:  "[Leetcode解題] 567. Premutation in String"
description:  "[Leetcode解題] 567. Premutation in String"
categories: medium
tags: two-pointers hashmap
langs: python
excerpt_separator: <!--more-->
---
# 題目
[567. Premutation in String](https://leetcode.com/problems/permutation-in-string/)

給定兩個字串`s1`與`s2`，判斷`s2`中是否包含`s1`其中一種排列組合的子字串

<!--more-->

# 解題思路

假設`s1`的長度為 $n$ ，`s2`的長度為 $m$，直覺從暴力法想起，我們可以直接窮舉所有`s1`的排列組合，並判斷每種組合是否出現在`s2`中

判斷一個字串A是否出現在字串B可以透過`kmp-algorithm`達到達到時間複雜度 $O(n+m)$ ，所以暴力法求解的複雜為 $O(n^3+n^2m)$ ，非常高

我們可以想像，暴力法的過程會有許多重複的判斷發生，並不是我們樂見的，舉例來說

考慮此兩種組合，只在前兩個字元交換，後面字串都是一樣的，但卻會進行許多重複的匹配判斷
AB(xxxxxxxxxxx)
BA(xxxxxxxxxxx)

因此，我們想到可以透過`hashmap`來表達一個字串的所有排列組合，因為如果是考慮任一排列組合的話，表達字串內的字元可以任意排列，不具順序性

舉例來說，字串`abcd`，可以表達成`{'a': 1, 'b': 1, 'c': 1, 'd': 1}`

再透過雙指針來解，我們定義前指針為`head`，後指針為`tail`，只要兩指針之間的字元可以得到相同的`hashmap`即表達`s2`包含`s1`的其中一種排列組合

雙指針的進行為，一開始`head`和`tail`皆指在0，依據下列各種狀況運行

1. 只要`tail`所指字元出現在`hashmap`，且數量不為0，則`tail`指針可繼續往前指
2. 若`tail`所指字元出現在`hashmap`，但數量為0，我們開始移動`head`，直到該字元的數目不為0方得以繼續移動`tail`(最壞的情形是`head`移動到`tail`的位置)
3. 若`tail`所指字元不出現在`hashmap`，表示我們要從該字元後面開始比對，因此直接移動`head`到`tail`的位置，並且從下一個位置進行比對

這邊我們注意，移動`tail`會消耗`hashmap`字元的數目，移動`head`則會加回`hashmap`字元的數目

另外補充第二點，為什麼最壞的情況是`head`移動到`tail`的位置呢? 因為若所指字元出現在`hashmap`中表達其原始數目至少大於0，當`head`移動到`tail`時，`hashmap`會還原成原始的狀態，所以一定不為零

# 實作
```python
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        if len(s1) > len(s2):
            return False
        
        d = {}
        for c in s1:
            d.setdefault(c, 0)
            d[c] += 1

        head = 0
        tail = 0
        val = len(s1)
        while tail < len(s2):
            if s2[tail] not in d:
                # Reset, starting from the next position
                while head < tail:
                    d[s2[head]] += 1
                    head += 1
                    val += 1
                tail += 1
                head += 1
            else:
                if d[s2[tail]] == 0:
                    while head < tail and d[s2[tail]] == 0:
                        d[s2[head]] += 1
                        head += 1
                        val += 1
                else:
                    d[s2[tail]] -= 1
                    tail += 1
                    val -= 1
                    if not val:
                        return True
        return False
```

# 時間複雜度

一開始建立`hashmap`會遍歷`s1`，時間複雜度為 $O(n)$ ，之後雙指針的移動，會分別移動`head`跟`tail`從頭到尾，故最多為$O(2m)$，查詢`hashmap`的時間為 $O(1)$ ，總時間複雜度為 $O(m)$ ，因為 $m>=n$  

