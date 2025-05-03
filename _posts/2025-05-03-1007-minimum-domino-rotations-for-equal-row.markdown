---
layout: article_post
title:  "[Leetcode解題] 1007. Minimum Domino Rotations For Equal Row"
description:  "1007. Minimum Domino Rotations For Equal Row"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

# 題目

[1007. Minimum Domino Rotations For Equal Row](https://leetcode.com/problems/minimum-domino-rotations-for-equal-row/description)

題目給定兩個矩陣`tops`跟`bottoms`，長度相同，每次翻轉可以將`tops[i]`跟`bottoms[i]`的值對調，問有沒有解能以最少次的翻轉使得tops的值全部相同，或bottoms的值全部相同

<!--more-->

# 解題思路

我們可以先來思考一下值域，我們看`i=0`位置有兩個值為`tops[0]`跟`bottoms[0]`

如果題目要有解，那麼`(0, n]`位置的值都應該會有值等於`tops[0]`或者`bottoms[0]`其一

如果不是的話，則無法透過翻轉得到值

在有解的情況，我們可以列舉出共有四種可能的答案解

1. 解用的是`tops[0]`的值，並翻轉至上
2. 解用的是`tops[0]`的值，並翻轉至下
3. 解用的是`bottoms[0]`的值，並翻轉至上
4. 解用的是`bottoms[0]`的值，並翻轉至下

不會有非這四種狀況但為解的情況，所以我們只要跑四次迴圈，並取`min`即可得解

# 程式碼

```python
class Solution:
    def minDominoRotations(self, tops: List[int], bottoms: List[int]) -> int:
        n = len(tops)
        answer = n + 1
        for target in [tops[0], bottoms[0]]:
            num_flips = 0
            for i in range(n):
                if tops[i] == target:
                    continue
                elif bottoms[i] == target:
                    num_flips += 1
                else:
                    break
            else:
                answer = min(answer, num_flips)
        
        for target in [tops[0], bottoms[0]]:
            num_flips = 0
            for i in range(n):
                if bottoms[i] == target:
                    continue
                elif tops[i] == target:
                    num_flips += 1
                else:
                    break
            else:
                answer = min(answer, num_flips)
        
        if answer == n + 1:
            return -1
        return answer
```

# 時間複雜度

$O(n)$