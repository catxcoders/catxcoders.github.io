---
layout: article_post
title:  "[Leetcode解題] Generate Parentheses - Backtrace解"
description:  "[Leetcode解題] Generate Parentheses - Backtrace解"
categories: medium
tags: leetcode medium python coder recursion
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [22. Generate Parentheses](https://leetcode.com/problems/generate-parentheses/)

## 解題思路
給定 n 對括號，寫一個函數來生成所有形成良好括號的組合。

這個問題可以使用回溯的方法解決。我們使用一個列表存儲所有形成良好括號的組合，並使用一個遞歸函數生成所有組合。

遞歸函數需要三個參數：

* s 是當前括號組合；
* left 和 right 分別是當前開啟和關閉括號的數量；
如果 len(s) == 2 * n，則代表我們已經使用了所有的 n 對括號，所以我們將此組合添加到列表中。

如果 left < n，則代表我們可以添加開啟括號。所以，我們調用 backtrack，傳遞參數 s + '('，left + 1 和 right。

如果 right < left，則代表我們可以添加關閉括號。所以，我們調用 backtrack，傳遞參數 s + ')'，left 和 right + 1。

最後，我們不傳任何參數調用 backtrack 以開始生成組合。


## 實作
以下是一個使用回溯法的 Python 解決方案：
```python
def generateParenthesis(n):
    res = []
    def backtrack(s = '', left = 0, right = 0):
        if len(s) == 2 * n:
            res.append(s)
            return
        if left < n:
            backtrack(s + '(', left + 1, right)
        if right < left:
            backtrack(s + ')', left, right + 1)

    backtrack()
    return res
```


## 複雜度
此題目的時間複雜度是 $O(4^n/\sqrt{n})$，其中 $n$ 是括號對數。

這是因為對於每個括號對數，最多有 $2n$ 個括號，因此，最多有 $4^n$ 種組合方案。然而，由於有些組合不合法，因此，真正的組合數比 $4^n$ 小。根據 Catalan Number 的計算，真正的組合數是 $C_{n}^{2n} / (n+1)$，因此，真正的時間複雜度是 $O(4^n/\sqrt{n})$。
