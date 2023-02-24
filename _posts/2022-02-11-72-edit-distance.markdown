---
layout: custom_post
title:  "72. Edit Distance"
date:   2022-02-11 21:27:53 +0800
categories: hard
---

# 題目

[72. Edit Distance](https://leetcode.com/problems/edit-distance)

# 解題思路

假設我們的`word1`為`@@@@@@`，`word2`為`%%%%%%`如果我們從第一個位置開始看，我們可以有三種操作

## insert

如果想讓`word1`更接近`word2`的話，我們可以在開頭的位置插入`word2`的開頭字元

%@@@@@@
%%%%%%

這樣我們可以把問題縮小為找`@@@@@@`到`%%%%%`的最小步數加一，因為我們已經走了一步

%(@@@@@@)
%(%%%%%)

## delete

也有可能我們刪除`word1`的一個字元會更接近`word2`

@@@@@
%%%%%%

問題縮小為找@@@@@到%%%%%%的最小步數加一

舉一個例子

horse
orse

## Replace

也有可能我們替換`word1`的一個字元會更接近`word2`

%@@@@@
%%%%%%

這樣我們可以把問題縮小為找@@@@@到%%%%%的最小步數加一

%(@@@@@)
%(%%%%%)

而這邊有一個前提是，兩個字串的開頭字元如果不同的話，才需要替換，如果開頭字串是相同的，我們就不需要加一

H@@@@@
H%%%%%

H(@@@@@)
H(%%%%%)

# dp

從上面的思路可以發現，我們可以將原來的問題，縮小成更小的問題，所以有機會可以用`dp`來解。

我們先來看`dp`怎麼做

我們用一個二維矩陣，每個位置代表以該位置為起始字元所需的最小步數，例如：

       h o r s e
    r  ? ? ? ? ?
    o  ? ? ? ? ?
    s  ? ? ? ? ?

我們每一步的結果，可以從四種不同的可能性得到

1. insert，為`dp[i+1][j]+1`
2. delete，為`dp[i][j+1]+1`
3. 若字串不同，replace，為`dp[i+1][j+1]+1`
4. 若字串相同，為`dp[i+1][j+1]`

所以我們可以從，最右下的位置，由右至左，由下至上，依序的得到這個矩陣，最後的結果就是`dp[0][0]`

不過，我們還需要注意邊際的狀況，我們可以加入考慮空字串的狀況，如下：

       h o r s e
    r  ? ? ? ? ? 3
    o  ? ? ? ? ? 2
    s  ? ? ? ? ? 1
       5 4 3 2 1 0

所以，時間複雜度就是`O(mn)`，`n, m`分別為`word1, word2`的字串長度

```python
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        n = len(word1)
        m = len(word2)
        dp = [[0 for i in range(n+1)] for j in range(m+1)]

        for i in range(n):
            dp[m][i] = n-i
        for i in range(m):
            dp[i][n] = m-i

        for i in range(m):
            for j in range(n):
                if word1[n-j-1] == word2[m-i-1]:
                    dp[m-i-1][n-j-1] = dp[m-i][n-j]
                else:
                    dp[m-i-1][n-j-1] = min(dp[m-i][n-j]+1, dp[m-i][n-j-1]+1, dp[m-i-1][n-j]+1)

        return dp[0][0]

```

不過，因為從右下到左上的順序有點不太順，我們可以反轉字串，這樣可以變成是從左上到右下，比較正常的順序

         e s r o h 
       0 1 2 3 4 5   
    s  1 ? ? ? ? ?
    o  2 ? ? ? ? ?
    r  3 ? ? ? ? ?
    
```python
class Solution:
    def minDistance(self, word1: str, word2: str) -> int:
        n = len(word1)
        m = len(word2)
        dp = [[0 for i in range(n+1)] for j in range(m+1)]

        for i in range(n):
            dp[0][i+1] = i+1
        for i in range(m):
            dp[i+1][0] = i+1

        word1 = word1[::-1]
        word2 = word2[::-1]

        for i in range(m):
            for j in range(n):
                if word2[i] == word1[j]:
                    dp[i+1][j+1] = dp[i][j]
                else:
                    dp[i+1][j+1] = min(dp[i][j]+1, dp[i+1][j]+1, dp[i][j+1]+1)
        return dp[m][n]
```

