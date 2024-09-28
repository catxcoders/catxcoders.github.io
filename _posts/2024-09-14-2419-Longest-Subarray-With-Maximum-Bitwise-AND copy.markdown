---
layout: article_post
title:  "[Leetcode解題]  2419. Longest Subarray With Maximum Bitwise AND"
description:  "Longest consecutive sequence of the maximum value"
categories: medium
tags: subarray bit
langs: python
excerpt_separator: <!--more-->
---

# 題目

[2419. Longest Subarray With Maximum Bitwise AND](https://leetcode.com/problems/longest-subarray-with-maximum-bitwise-and/)

給定一個大小為 n 的整數數組 nums。

考慮 nums 中一個非空的子數組，其按位與（bitwise AND）的值是可能的最大值。

換句話說，設 k 為任意子數組的最大按位與值，然後只考慮按位與等於 k 的子數組。返回這樣的子數組中最長的長度。

數組的按位與是數組中所有數的按位與操作結果。

子數組是數組中連續的元素序列。

# 題目解析

這題雖然看起來很複雜，但實際上和我們判斷與求最大值的連續子字串相同。

因為像是`7`和`12`

'7' = '0111'
'12'= '1100'

做完`AND`之後，變成`0100`，那這樣就會比原本的`1100`小，所以基本上，我們找到一個最大值，就沒有辦法透過AND不同的值而得到一樣的值。

# 程式碼

```python
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        maximum = 0
        cnt = 0
        ans = 0
        for num in nums:
            if num > maximum:
                maximum = num
                ans = cnt = 1
            elif num == maximum:
                cnt += 1
            else:
                cnt = 0
            ans = max(ans, cnt)
        return ans
```

# 時間複雜度

因為跑過整個序列，所以時間複雜度為 $O(n)$