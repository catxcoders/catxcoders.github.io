---
layout: article_post
title:  "[Leetcode解題] 514. Freedom Trail - 用DP結合BFS解"
description:  "[Leetcode解題] 514. Freedom Trail - 用DP結合BFS解"
categories: medium 
tags:  dfs dp
langs: python
excerpt_separator: <!--more-->
---

# 514. Freedom Trail

# 題目

[514. Freedom Trail](https://leetcode.com/problems/freedom-trail/)

給定一個圓形的轉盤，上面有N個英文字母，中間有一個按鈕可以輸入該字母，每往右或往左轉動一個字母，計算為一步，按下按鈕也計算為一步。

當給定一個字串`key`，題目問要經過多少步才能輸入完整個字串。

 <!--more-->
 
# 解題思路

這題我們透過DP來解，用一個二維矩陣來記錄輸入第K個字母時（下稱第k回合），還需要幾步才能須入完，所以`dp[0][0]`為我們的解答，因為起點會在第一個字母，並且輸入第一個字母的時候。

所以建構DP矩陣時，我們會從最後一個row開始，也就是輸入最後一個字母的時候。

我們可以知道，如果今天最後一回合的字目為`A`，而轉盤停留在`A`，那只需要一步就可以得解。

可以由此往左右推，如果停留在`A`的左右邊字母，那只需要再加一步。

所以這個過程有點像是在做`BFS`，只不過針對最後一回合的狀況時，依此思路可以建構完在最後回合轉盤所有狀況所需的步數。

再來，我們可以一步步推回第一個回合建構完整個矩陣。

# 程式碼

```python
class Solution(object):
    def findRotateSteps(self, ring, key):
        """
        :type ring: str
        :type key: str
        :rtype: int
        """
        n = len(key)
        m = len(ring)
        dp = [[0] * m for i in range(n)]
        for i in range(n-1, -1, -1):
            queue = []
            for j in range(m):
                if key[i] == ring[j]:
                    if i == n-1:
                        dp[i][j] = 1
                    else:
                        dp[i][j] = dp[i+1][j] + 1
                    queue.append(j)
            while queue:
                index = queue.pop(0)
                left = (index-1+m) % m
                right = (index+1) % m
                if dp[i][left] == 0 or dp[i][left] > dp[i][index]+1:
                    dp[i][left] = dp[i][index]+1
                    queue.append(left)
                if dp[i][right] == 0 or dp[i][right] > dp[i][index]+1:
                    dp[i][right] = dp[i][index]+1
                    queue.append(right)
        return dp[0][0]
```

# 時間複雜度

每回合需遞迴兩次轉盤為$O(m)$，給定字串長度為$n$的話有$n$回合，總時間複雜度為$O(mn)$