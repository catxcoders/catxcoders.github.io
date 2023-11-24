---
layout: article_post
title: "[Leetcode解題] Best Team With No Conflicts - dp解"
description: "[Leetcode解題] Best Team With No Conflicts - dp解"
categories: medium
tags: dp
langs: python
excerpt_separator: <!--more-->
---

題目網址: [1626. Best Team With No Conflicts](https://leetcode.com/problems/best-team-with-no-conflicts/)
# 題目
給定兩個列表scores和ages，其中scores[i]和ages[i]分別表示第i個球員的得分和年齡。球隊的得分是所有球員得分的總和。但球隊有一個限制：**年齡較小的球員的得分不能嚴格高於年齡較大的球員**。同齡球員之間不會存在衝突。請找出所有可能的籃球隊中的最高總分。

<!--more-->

# 解題思路
這道題目可以使用**動態規劃**（Dynamic Programming）解決。我們需要計算每個子問題的最高總分並利用已知的子問題解答來避免重複計算。

具體來說，我們可以根據球員的年齡對球員列表進行排序，以確保在計算子問題時按照年齡順序進行處理。接著，我們使用動態規劃的思想，遍歷每個球員，計算每個子問題的最高總分。

首先，我們需要根據球員的年齡對球員列表進行排序，當年齡相同，則按照分數排序，以便後續計算中可以按照年齡順序處理。
然後，在排序好的分數尋找**最大總和的遞增子序列**。

# 算法
1. 將球員的得分和年齡列表組合為一個新的列表players，根據年齡和得分對players進行排序，當年齡相同，則按照分數排序。
2. 創建一個長度為n的列表dp，初始化所有元素為0，其中n為球員的數量。
3. 遍歷每個球員i，從0到n-1：
    * 初始化dp[i]為球員i的得分。
    * 遍歷所有年齡較小的球員j，從0到i-1：
        * 如果球員j的得分不高於球員i的得分，則更新dp[i]為dp[j] + players[i].score。
4. 返回dp中的最大值作為答案。

# 實作
```python
class Solution:
    def bestTeamScore(self, scores: List[int], ages: List[int]) -> int:
        players = sorted(zip(scores, ages), key=lambda x: (x[1], x[0]))

        # 創建一個列表來存儲每個子問題的最高總分
        dp = [0] * len(players)

        # 遍歷每個球員，計算每個子問題的最高總分
        for i in range(len(players)):
            # 初始化子問題的最高總分為該球員的得分
            dp[i] = players[i][0]

            # 在前面的球員中尋找年齡較大且得分不低於當前球員的球員
            for j in range(i):
                if players[j][0] <= players[i][0]:
                    dp[i] = max(dp[i], dp[j] + players[i][0])

        # 返回所有子問題中的最高總分
        return max(dp)
```

# 複雜度
* 排序球員列表的時間複雜度為O(nlogn)，其中n為球員的數量。
* 遍歷每個球員並遍歷所有年齡較小的球員的時間複雜度為O(n^2)。
* 因此，總時間複雜度為O(n^2)。
* 使用了額外的列表dp來存儲每個子問題的解答，所以空間複雜度為O(n)。