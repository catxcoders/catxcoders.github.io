---
layout: article_post
title:  "3. Longest Substring Without Repeating Characters"
categories: leetcode
tags: medium python
excerpt_separator: <!--more-->
---

# 題目

[3. Longest Substring Without Repeating Characters
](https://leetcode.com/problems/longest-substring-without-repeating-characters/)

# 解題思路

這題要找出最長不包含重複字元的字串，我們一樣從不同的角度來想這個題目。首先，可以先想一下最暴力的解法會是怎樣，抑或是所有可能的組合有哪些？

我們如果用起始位置(含)跟結束位置(不含)來表示一個字串，那麼一個長度為n的字串，會有$n^2/2$個組合。可以透過像這樣的兩層迴圈去迭代所有可能。

```python
for i in range(n):
    for j in range(i+1, n):
        print(s[i:j])
```

但是，我們可以想像到，如果我們可以按照某種順序進行，應該可以減少一些不用考慮的組合，例如，如果[0:k]已經有重複字元，那麼[0:k+1], ..., [0:n]應該就不須考慮，也會有重複字元。

根據這種想法，我們可以想到一種可能的dp解，如果我們定義問題為「到結尾最長的不重複字串」，我們的dp矩陣儲存起始的索引，那麼最後我們只需要對這個dp矩陣取最大值即為原本題目的答案。

而從k到k+1，我們只要確認從dp[k] (上一步的起始字元位置)~k(上一步的結尾)中是否有包含k+1的字元：

如果有的話：我們就知道這一步的起始位置dp[k+1]是該字元的下一個位置
如果沒有的話：則跟上一步使用同一個起始位置

以程式碼呈現，則是這樣：

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        if not s:
            return 0
        dp = [0] * len(s)
        for i in range(1, len(s)):
            for j in range(dp[i-1], i):
                if s[i] == s[j]:
                    dp[i] = j+1
                    break
            else:
                dp[i] = dp[i-1]
        for i in range(len(s)):
            dp[i] = i-dp[i]+1
        return max(dp)
                
```

這邊為大家複習一下for-else的語法，else的區塊是迴圈完整進行完才會運行到的區塊，也就是說如果中途有跳出(break)，則不會運行到該區塊。

不過，很可惜這樣的解法，時間複雜度是$O(n^2)$，最壞的情況就是我們有一個完全不重複的字串，那麼每一次k到k+1我們都需要從0掃到k。

這邊我們可以再精進一下這個解法，回想一下這個題目是要找「不重複」的最長字串，而不重複的這個特性讓我們想到Set這樣的資料結構。

如果我們可以用一個Set來表示上一步的字串，那麼我要確認k+1的字元有沒有出現在上一步的字串，只需要判斷k+1有沒有出現在set中即可，如果使用Hash Set的話，所需的時間只要$O(1)$，所以那麼做，可以再把時間降低到$O(n)$。

實作上，我們也可以使用Dict來記錄每個字元的起始位置，去避免我們要反覆去維護一個「表示上一步的字串」的Set，回想一下，我們是要去對說現在的字元有沒有出現在，上一步的字串中，也就是dp[k-1]~k-1，所以我們如果今天發現這個字元有在Dict裡面，我們還需要額外確認，這個字元的起始位置是不是位於dp[k-1]跟k-1之間，如果不在的話，就也代表這個字元沒有出現在上一步的字串中。

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        if not s:
            return 0
        dp = [0] * len(s)
        pos = dict() # position
        pos[s[0]] = 0
        for i in range(1, len(s)):
            if s[i] in pos and dp[i-1] <= pos[s[i]]:
                dp[i] = pos[s[i]] + 1
            else:
                dp[i] = dp[i-1]
            pos[s[i]] = i
        for i in range(len(s)):
            dp[i] = i-dp[i]+1
        return max(dp)
```

## 前後指針解

除了從dp的角度切入外，也可以透過前後指針來解這題，概念也是類似，我們從頭看到尾，同時也維護一個Set來代表「以該位置為結尾」的最長不重複字串，所以其實跟我們上面的解法基本上概念是完全一樣的。

所以我們維護一個前指針，來指到目前的起始位置，所以如果現在看的字元已經出現在Set中，我們就必須透過這個指針來更新Set，也就是不斷往後移，並移出指到位置的字元，直到現在的字元不出現在Set中。

由於這個前指針，最多也是看過n-1個位置(不需要判斷最後一個位置)，而我們的後指針，也就是我們的外層迴圈，走過n個位置，所以時間複雜度為$O(n)$。

```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        l = 0 # left pointer
        hs = set()
        max_len = 0
        for char in s:
            while char in hs:
                hs.remove(s[l])
                l += 1
            hs.add(char)
            max_len = max(max_len, len(hs))
        return max_len
```



