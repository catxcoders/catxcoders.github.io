---
layout: article_post
title:  "[Leetcode解題] 1423. Maximum Points You Can Obtain from Cards"
description:  "[Leetcode解題] 1423. Maximum Points You Can Obtain from Cards"
categories: medium 
tags: array presum sliding-window
langs: python
excerpt_separator: <!--more-->
---

## 題目
[1423. Maximum Points You Can Obtain from Cards](https://leetcode.com/problems/maximum-points-you-can-obtain-from-cards)

有幾張卡片排成一列，每張卡片都有一個對應的點數。這些點數存放在 `cardPoints` 中。每一步，你可以從這列卡片的開頭或結尾拿走一張卡片，必須恰好拿走 `k` 張卡片。你的得分是你拿走的卡片點數的總和。

給定 `cardPoints` 和整數 `k`，返回你可以獲得的最大得分。

## 解題思路
這題的關鍵在於如何在拿走 $k$ 張卡片的情況下，最大化總得分。我們可以轉換問題為**找出剩下卡片中點數最小的連續子陣列**，這樣我們就可以保留總和最大的部分。

具體步驟：
1. 計算陣列中所有卡片的總和。
2. 計算陣列中長度為 $n - k$ 的最小子陣列的總和（$n$ 為卡片數）。
3. 用總和減去這個**最小子陣列**的總和，得到最大的得分。

## Python實現

```python
class Solution:
    def maxScore(self, cardPoints: List[int], k: int) -> int:
        n = len(cardPoints)
        intervalLen = n - k
        total = sum(cardPoints)
        score = sum(cardPoints[:intervalLen])
        minInterval = score

        for i in range(k):
            score = score - cardPoints[i] + cardPoints[i + intervalLen]
            minInterval = min(minInterval, score)

        return total - minInterval
```

## C++實現

```cpp
class Solution {
public:
    int maxScore(vector<int>& cardPoints, int k) {
        const auto &n = cardPoints.size();
        int intervalLen = n-k;
        int total = accumulate(cardPoints.begin(), cardPoints.end(), 0);
        int score = accumulate(cardPoints.begin(), cardPoints.begin()+intervalLen, 0);
        int minInterval = score;

        for(auto i=0; i<k; i++){
            score = score-cardPoints[i]+cardPoints[i+intervalLen];
            minInterval = min(minInterval, score);
        }
        return total-minInterval;
    }
};
```

## 時間複雜度
1. 計算所有卡片總和的時間複雜度是 $O(n)$。
2. 計算長度為 $n - k$ 的**最小子陣列**的初始總和的時間複雜度是 $O(n - k)$。
3. 更新並找到**最小子陣列**總和的時間複雜度是 $O(k)$，因為我們只需要遍歷 $k$ 次進行更新。

綜合上述步驟，整體時間複雜度是 $O(n)$，因為主要操作都是線性的。