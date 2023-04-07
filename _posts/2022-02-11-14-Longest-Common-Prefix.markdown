---
layout: article_post
title:  "[Leetcode解題] Longest Common Prefix - 暴力解"
description: "[Leetcode解題] Longest Common Prefix - 暴力解"
categories: medium
tags: leetcode medium python coder string
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [14. Longest Common Prefix](https://leetcode.com/problems/longest-common-prefix/)

# 解題思路

給定一個字符串數組`strs`，求出它們的最長公共前綴字符串。

如果沒有公共前缀，返回空字符串 ""。

算法思路：

1. 如果字符串數組的長度等於`0`，直接返回空字符串
2. 求出字符串數組中的最小字符串的長度`minLen`
3. 使用一個外層循環，遍歷每一位字符
4. 使用一個內層循環，比較每一個字符串的當前位是否相同
5. 如果有不同，直接返回當前結果
6. 如果所有字符都相同，繼續遍歷下一位字符

```python
class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        if len(strs) == 0:
            return ""
        minLen = min([len(s) for s in strs])
        result = ""
        for i in range(minLen):
            for j in range(1, len(strs)):
                if strs[j][i] != strs[0][i]:
                    return result
            result += strs[0][i]
        return result
```

# 時間複雜度

因為使用了兩個循環，所以時間複雜度是$O(n^2)$，$n$為字符串數組的長度。
