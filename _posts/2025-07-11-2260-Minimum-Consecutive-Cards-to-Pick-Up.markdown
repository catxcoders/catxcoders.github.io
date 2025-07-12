---
layout: article_post
title:  "[Leetcode解題] 2260. Minimum Consecutive Cards to Pick Up"
description:  "2260. Minimum Consecutive Cards to Pick Up"
categories: medium
tags: hashTable
langs: python
excerpt_separator: <!--more-->
---

## 題目
[2260. Minimum Consecutive Cards to Pick Up](https://leetcode.com/problems/minimum-consecutive-cards-to-pick-up/)
你有一個整數陣列 `cards`，其中 `cards[i]` 表示第 `i` 張卡牌的數值。若兩張卡牌的數值相同，則稱它們是一對匹配的卡牌。

你需要找出**最少需要連續抽出的卡牌數量**，使得其中**至少包含一對匹配的卡牌**。如果不存在這樣的配對，請回傳 `-1`。
<!--more-->

### 範例 1：
```
輸入: cards = [3,4,2,3,4,7]
輸出: 4
解釋: 連續抽取 cards[0..3] = [3,4,2,3]，其中出現了兩張 3。
```

### 範例 2：
```
輸入: cards = [1,0,5,3]
輸出: -1
解釋: 沒有任何兩張卡牌有相同的值。
```

## 解題思路

### 核心概念：

我們希望找出任意兩個**相同數值**的卡牌，使它們之間的距離最短（包含兩端），也就是 `i - j + 1` 最小，其中 `cards[i] == cards[j]` 且 `i > j`。

### 解法步驟：

1. 使用一個hash map `last_seen` 記錄每個卡牌數值**上一次出現的位置**。
2. 每當發現一個已經看過的數字：
   * 計算與上一次出現的距離（即目前的連續子陣列長度）
   * 更新最小值 `min_len`。
3. 若整個陣列掃描完都沒有找到重複值，回傳 -1。

## Python 實作
```python
class Solution:
    def minimumCardPickup(self, cards: List[int]) -> int:
        last_seen = {}
        min_len = float('inf')

        for i, val in enumerate(cards):
            if val in last_seen:
                min_len = min(min_len, i - last_seen[val] + 1)
            last_seen[val] = i
        
        return min_len if min_len != float('inf') else -1
```

## C++ 實作
```cpp
class Solution {
public:
    int minimumCardPickup(vector<int>& cards) {
        int minLen = INT_MAX;
        unordered_map<int, int> lastPos;
        for(int i=0; i<cards.size(); i++){
            if (lastPos.find(cards[i])!=lastPos.end()){
                minLen = min(minLen, i-lastPos[cards[i]] + 1);
            }
            lastPos[cards[i]] = i;
        }
        
        if (minLen == INT_MAX){
            return -1;
        }
        return minLen;
    }
};
```

## 時間與空間複雜度分析
* **時間複雜度**：$O(n)$，其中 $n$ 是 `cards` 的長度。

  * 每個元素最多處理一次，hash map操作為常數時間。
* **空間複雜度**：$O(n)$ 最壞情況是所有數字都不同，`last_seen` 需要記錄所有位置。

