---
layout: article_post
title:  "[Leetcode解題] 739. Daily Temperatures - 單調佇列(monotonic stack)解"
description: "單調佇列經典題，搞懂Leetcode"
categories: medium
tags: graph stack monotonicstack
langs: python
excerpt_separator: <!--more-->
---

# 題目

[739. Daily Temperatures](https://leetcode.com/problems/daily-temperatures/)

這題給定一個一維矩陣表示溫度，題目要求，**最少**要過幾天後會有更高的溫度，如果沒有的話，就填0

 <!--more-->

# 解題思路

這題如果直接用暴力解去想的話，就是對每個值，我都往後去找第一個比他大的值，然後求其差，但這樣的話複雜度為$O(n^2)$。

而因為對於這種要由前往後看的類型，我會想到用`stack`, `queue`, `monotonic stack`等等的資料結構，這題就可以使用`monotonic stack`來解。

我們從左往右進行迴圈，如果當前的值，比`stack`頂端的值來的小的話，代表都還沒找到比前面大的值，就直接放進`stack`，如果比較大的話，我們就找到了對於`stack`頂端值來說，第一個比他大的值，所以將其從`stack`移除，並且可以計算兩值索引差，進行直到比`stack`頂端值來的小，或者`stack`為空。

上面的敘述有點繞口，我們用一個例子來看，星號表示當前值

[73,74,75,71,69,72,76,73]
stack: []

[*73,74,75,71,69,72,76,73]
stack: [] -> [73]
因為stack為空所以直接放進去

[73,*74,75,71,69,72,76,73]
stack: [73] -> [] -> [74]
因為74比73大，所以將其移除，並且計算索引差為1，然後stack為空，所以直接放進去

[73,74,*75,71,69,72,76,73]
stack: [74] -> [] -> [75]
同上

[73,74,75,*71,69,72,76,73]
stack: [75] -> [75, 71]
因為71比75還要小，所以放進stack

[73,74,75,71,*69,72,76,73]
stack: [75, 71] -> [75, 71, 69]
同上

[73,74,75,71,69,*72,76,73]
stack: [75, 71, 69] -> [75, 71] -> [75] -> [75, 72]

因為72比69大，所以`pop()`，72也比71大，所以再`pop()`，72比75小，所以放進`stack`，這步驟我們就可以看出，我們放進`stack`的元素，在第一次遇到比他大的值的時候，就會將其移除並計算索引差，stack會維持一個單調的狀態，後面的步驟我們就跳過。

# monotonic stack

一種特殊的`stack`，須保證裡面的各個元素為遞增或遞減，舉例來說，如果像這題是遞減，我們遇到比`top`大的元素，就必須不斷對`stack`進行`pop()`，直到比`top`小，才能加進去。

通常這樣的資料結構會拿來處理，找「第一個比較大」或是「第一個比較小」的這種問題。

# 實作
```python
class Solution:
    def dailyTemperatures(self, temperatures: List[int]) -> List[int]:
        stack = []
        ans = [0] * len(temperatures)
        for i, t in enumerate(temperatures):
            while stack and t > temperatures[stack[-1]]:
                day = stack.pop()
                ans[day] = i - day
            stack.append(i)
        return ans
```

# 時間複雜度

因為每個元素都會被放進`stack`一次，也最多會從`stack`移除一次，所以時間複雜度為$O(n)$