---
layout: article_post
title:  "[Leetcode解題] 911. Online Election"
description:  "911. Online Election - 使用Binary Search解"
categories: medium
tags: binary_search, bs
langs: python
excerpt_separator: <!--more-->
---

# 911. Online Election

## 題目
[911. Online Election](https://leetcode.com/problems/online-election/)
給定兩個等長整數陣列 `persons` 與 `times`：

* 第 `i` 票投給 `persons[i]`
* 投票發生在時間 `times[i]`
* `times` 嚴格遞增（每次投票時間愈來愈晚）

對於每次查詢時間 `t`，請回傳「在時間 `t`（包含恰好在 `t` 投出的票）時，得票數領先的人」。

規則補充：

* 若有平手（得票數相同），**以最近一次投票者**（在平手者之中，最後拿到票的人）為領先者。

要實作 `TopVotedCandidate`：

* `TopVotedCandidate(persons, times)`：初始化
* `q(t)`：回傳時間 `t` 時的領先者

<!--more-->

## 解題思路

這題的關鍵在於：查詢會很多次，而投票序列是固定的。因此適合 **預處理 + 二分搜尋**。

### 1) 預處理每個投票時間點的領先者

我們從左到右掃描每一票，維護：

* `count[p]`：候選人 `p` 目前得票數
* `leader`：目前領先者
* `leaderVotes`：領先者得票數

當第 `i` 票投給 `p = persons[i]` 時：

1. `count[p] += 1`
2. 若 `count[p] >= leaderVotes`，則令 `leader = p`、`leaderVotes = count[p]`

注意這裡用 `>=`（不是 `>`）：

* 這正是「平手時以最近投票者勝出」的規則：當 `p` 追平領先者票數時，因為 `p` 是最新拿到票的人，所以應該成為新的 leader。

把每個時間點的 `leader` 存到陣列 `leaders[i]`，代表在 `times[i]` 這一刻（包含這一票）結束後的領先者。

### 2) 查詢用二分搜尋定位最後一個 `times[i] <= t`

`q(t)` 要找「時間不超過 t 的最後一票」的位置：

* 用二分搜尋找 `idx = upper_bound(times, t) - 1`
* 回傳 `leaders[idx]`

因為 `leaders[idx]` 就是投到 `times[idx]` 後的領先者，而 `times[idx]` 是所有 `<= t` 的投票中最新的那個(投票在 t 時間點也算)。

## C++ 實作
```cpp
class TopVotedCandidate {
public:
    TopVotedCandidate(vector<int>& persons, vector<int>& times) :times(times){
        unordered_map<int, int> count;
        int leader = -1;
        int leaderVotes = 0;

        for (auto p : persons){
            count[p] += 1;
            if (count[p] >= leaderVotes){
                leader = p;
                leaderVotes = count[p];
            }   
            leaders.push_back(leader);
        }
    }
    
    int q(int t) {
        // max time[idx] <= t
        auto idx = upper_bound(times.begin(), times.end(), t)-times.begin()-1;
        return leaders[idx];
    }
private:
    vector<int> leaders;
    vector<int> times;
};

/**
 * Your TopVotedCandidate object will be instantiated and called as such:
 * TopVotedCandidate* obj = new TopVotedCandidate(persons, times);
 * int param_1 = obj->q(t);
 */
```

## Python 實作

```python
class TopVotedCandidate:
    def __init__(self, persons: List[int], times: List[int]):
        self.times = times
        self.leaders = []

        count = defaultdict(int)
        leader = -1
        leader_votes = 0

        for p in persons:
            count[p] += 1

            # >= 用來處理平手時，最新投票者勝出
            if count[p] >= leader_votes:
                leader = p
                leader_votes = count[p]

            self.leaders.append(leader)

    def q(self, t: int) -> int:
        # 找到最後一個 times[i] <= t 的位置
        idx = bisect_right(self.times, t) - 1
        return self.leaders[idx]
```



## 時間與空間複雜度
* `n = len(persons)`（投票數）
* `m` = 查詢次數

### 初始化（建構子）
* 時間：`O(n)`（單次掃描計票與建立 leaders）
* 空間：`O(n)`，leaders與建立的dict count最多是$n$，因此時間複雜度為$O(n)$

### 每次查詢 `q(t)`
* 時間：`O(log n)`（對 `times` 二分搜尋）
* 空間：`O(1)`（不計輸入/儲存結構）
