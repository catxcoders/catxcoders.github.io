---
layout: article_post
title:  "[Leetcode解題] Simplify Path - stack解"
description:  "[Leetcode解題] Simplify Path - stack解"
categories: medium
tags: stack
langs: python
excerpt_separator: <!--more-->
---
# 題目
[71. Simplify Path](https://leetcode.com/problems/simplify-path/)

這是一個處理 Unix-style 文件系統中給定絕對路徑的問題。我們需要將給定的路徑轉換為簡化的規範路徑。在 Unix-style 文件系統中，`.` 代表當前目錄，`..` 代表上一級目錄，連續的多個斜線 `/` 被視為單一的斜線 `/`。這個問題的目標是返回簡化的規範路徑，滿足一些特定的格式要求。

<!--more-->

# 解題思路
我們可以使用*stack*來處理這個問題。首先，我們將路徑按照斜線 `/` 分割成各個部分。然後，我們遍歷這些部分，處理 `.`、`..` 以及正常目錄的情況。最終，將處理後的結果組合成簡化的規範路徑。

# 實作
```python
class Solution:
    def simplifyPath(self, path: str) -> str:
        # 將路徑按斜線分割成部分
        parts = path.split('/')
        stack = []

        # 遍歷每個部分
        for part in parts:
            # 處理 '.'，略過當前目錄
            if part == '.':
                continue
            # 處理 '..'，返回上一級目錄 (pop)
            elif part == '..':
                if stack:
                    stack.pop()
            # 處理正常目錄，加入stack
            elif part is not "":
                stack.append(part)

        # 將stack中的元素組合成規範路徑
        result = '/' + '/'.join(stack)
        return result
```

# 時間複雜度
假設路徑的長度為 $n$，則遍歷路徑的時間複雜度為 $O(n)$。由於只使用了一個*stack*，*stack*的操作時間複雜度也是 $O(n)$。總體來說，這個算法的時間複雜度是 $O(n)$。