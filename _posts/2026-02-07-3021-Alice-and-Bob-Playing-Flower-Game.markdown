---
layout: article_post
title:  "[Leetcode解題] 3021. Alice and Bob Playing Flower Game"
description:  "3021. Alice and Bob Playing Flower Game - 使用數學解"
categories: eamediumsy
tags: math
langs: python
excerpt_separator: <!--more-->
---

# 3021. Alice and Bob Playing Flower Game

## 題目
[3021. Alice and Bob Playing Flower Game](https://leetcode.com/problems/alice-and-bob-playing-flower-game/)
Alice 和 Bob 在玩一個回合制遊戲。

在他們之間有兩條花道：

* 第一條有 `x` 朵花
* 第二條有 `y` 朵花

給定兩個整數 `n` 和 `m`：

* `1 ≤ x ≤ n`
* `1 ≤ y ≤ m`

請你計算：
在所有可能的 `(x, y)` 組合中，有多少組會讓 **Alice 獲勝**？

遊戲流程如下：
- Alice先走。
- 每一輪，玩家必須選擇其中一條通道，並從該通道的一側摘取一朵花。
- 回合結束時，如果兩條賽道上都沒有花，則當前玩家捕獲對手並贏得比賽。
<!--more-->

## 解題思路
經過分析可得：**Alice 會贏 ⟺ `x + y` 是奇數**

### 什麼時候和是奇數？

| x | y | x+y |
| - | - | --- |
| 奇 | 偶 | 奇   |
| 偶 | 奇 | 奇   |

**也就是：一奇一偶 才會贏**

### 問題轉換

我們現在只需要計算：

```
(第一條是奇數 且 第二條是偶數)
+
(第一條是偶數 且 第二條是奇數)
```

- 對於 1 ~ n：
    * 偶數個數 = `n // 2`
    * 奇數個數 = `(n + 1) // 2`

對於 1 ~ m 同理。

組合計算:

```
nEven * mOdd
+
nOdd * mEven
```

# Python 實作

```python
class Solution:
    def flowerGame(self, n: int, m: int) -> int:
        n_even = n // 2
        n_odd = (n + 1) // 2
        
        m_even = m // 2
        m_odd = (m + 1) // 2
        
        return n_even * m_odd + n_odd * m_even
```

---

# C++ 實作

```cpp
class Solution {
public:
    long long flowerGame(int n, int m) {
        long long nEven = n / 2;
        long long nOdd = (n + 1) / 2;
        long long mEven = m / 2;
        long long mOdd = (m + 1) / 2;

        return nEven * mOdd + nOdd * mEven;
    }
};
```

## 複雜度分析
- Time Complexity: $O(1)$, 只有常數次運算。
- Space Complexity: $O(1)$, 沒有使用額外資料結構。
