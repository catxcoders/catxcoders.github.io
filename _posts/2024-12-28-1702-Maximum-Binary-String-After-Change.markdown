---
layout: article_post
title:  "[Leetcode解題] 1702. Maximum Binary String After Change"
description:  "1702. Maximum Binary String After Change"
categories: medium
tags: string greedy
langs: python
excerpt_separator: <!--more-->
---

# 題目

[1702. Maximum Binary String After Change](https://leetcode.com/problems/maximum-binary-string-after-change/description/)

這題給一個binary字串，並有兩種操作可以進行：

1. 將`00`轉成`10`
2. 將`10`轉成`01`

操作次數不限，問我們可以得到的最大字串為何

<!--more-->

# 解題思路

我們可以先想一下在以0為開頭的任意字串

`0000101110101`

如果要將此字串變更大，我們可以通過數次操作，把所有1往右邊推

`0000101110101`
`0000011110011`
`0000011111011`
`0000011110111`
`0000011101111`
`0000011011111`
`0000010111111`
`0000001111111`

然後再開頭的00轉成10，獲得最多的1

`0000001111111`
`1111101111111`

這樣一來我們其實只要數有幾個0，然後就可以建構出最後的答案了，假設0的數量為k，最終字串為

```
s = '1' * (k-1) + '0' + '1' * (n-k)
```

但是我們仍須考慮開頭為1的狀況

`1100`

如果按照我們上面的作法把1都推到右邊再進行轉換，會得到：

`1011`

但這甚至比原本的字串小，而正確的作法應該是要直接轉後面的00

`1110`

所以我們如果遇到開頭是1的情況，就要跳過，直接從0開頭的地方開始，因為開頭是1已經是最優，沒有可能再透過任何轉換變得更大。

# 程式碼

```python
class Solution:
    def maximumBinaryString(self, binary: str) -> str:
        p = binary.find("0")
        if p == -1:
            return binary
        k = binary.count("0")
        return "1" * (p + k - 1) + "0" + "1" * (len(binary) - k  - p)
```

# 時間複雜度

理論上只要看過一次字串即可，複雜度為$O(n)$