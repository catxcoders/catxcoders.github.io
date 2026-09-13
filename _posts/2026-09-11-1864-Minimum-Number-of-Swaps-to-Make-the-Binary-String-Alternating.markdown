---
layout: article_post
title:  "[Leetcode解題] 1864. Minimum Number of Swaps to Make the Binary String Alternating"
description:  "1864. Minimum Number of Swaps to Make the Binary String Alternating - 計數與貪婪"
categories: medium
tags: string greedy counting
langs: python c++
excerpt_separator: <!--more-->
---

# 1864. Minimum Number of Swaps to Make the Binary String Alternating

## 題目

[1864. Minimum Number of Swaps to Make the Binary String Alternating](https://leetcode.com/problems/minimum-number-of-swaps-to-make-the-binary-string-alternating/description/)

給定一個二進位字串 `s`，每次可以交換任意兩個位置的字元。請回傳將 `s` 變成交錯字串所需的最少交換次數；如果無法做到，回傳 `-1`。

交錯字串中任意兩個相鄰字元都不相同，例如 `010`、`1010`；而 `0100` 不是交錯字串。

<!--more-->

## 解題思路

這題可以分成兩個部分：

1. 判斷字串是否有可能變成交錯字串。
2. 計算變成合法交錯排列所需的最少交換次數。

### 1. 判斷是否有解

交換只會改變字元的位置，不會改變 `0` 和 `1` 的數量。

在交錯字串中，`0` 與 `1` 的數量差不可能超過 `1`，因此若：

$$|count(0) - count(1)| > 1$$

就一定無法形成交錯字串，直接回傳 `-1`。

反過來說，只要兩者數量差不超過 `1`，就一定能排成交錯字串。

### 2. 決定可能的目標字串

交錯字串只有兩種形式：

- 以 `0` 開頭：`010101...`
- 以 `1` 開頭：`101010...`

不過，實際可選的形式會受到字元數量限制：

- 若 `0` 的數量較多，只能以 `0` 開頭。
- 若 `1` 的數量較多，只能以 `1` 開頭。
- 若兩者數量相同，兩種形式都可以，取交換次數較小者。

### 3. 為什麼錯位數要除以 2？

假設目標是 `010101`，逐一比較原字串與目標字串，計算不同的位置數量 `mismatch`。

每一個錯放的 `0`，必定會對應到另一個錯放的 `1`。交換這兩個位置後，可以一次修正兩個錯位，因此：

$$swaps = \frac{mismatch}{2}$$

例如：

```text
原字串：111000
目標值：101010
          ^  ^
```

共有兩個位置不相同，交換這兩個位置後即可完成，所以需要 $2 / 2 = 1$ 次交換。

## 演算法步驟

1. 統計 `0` 和 `1` 的數量。
2. 若數量差大於 `1`，回傳 `-1`。
3. 定義函式，計算字串與指定開頭的交錯字串之間有幾個位置不同，並回傳錯位數除以 `2`。
4. 根據 `0`、`1` 的數量決定唯一合法的開頭；若數量相同，則比較兩種開頭並取最小值。

## C++ 實作

```cpp
class Solution {
private:
    int countSwaps(const string& s, char first) {
        int mismatch = 0;

        for (int i = 0; i < s.size(); ++i) {
            char expected;

            if (i % 2 == 0) {
                expected = first;
            } else {
                expected = (first == '0' ? '1' : '0');
            }

            if (s[i] != expected) {
                ++mismatch;
            }
        }

        return mismatch / 2;
    }

public:
    int minSwaps(string s) {
        int zeros = count(s.begin(), s.end(), '0');
        int ones = s.size() - zeros;

        if (abs(zeros - ones) > 1) {
            return -1;
        }

        if (zeros > ones) {
            return countSwaps(s, '0');
        }

        if (ones > zeros) {
            return countSwaps(s, '1');
        }

        return min(countSwaps(s, '0'), countSwaps(s, '1'));
    }
};
```

## Python 實作

```python
class Solution:
    def minSwaps(self, s: str) -> int:
        zeros = s.count('0')
        ones = len(s) - zeros

        if abs(zeros - ones) > 1:
            return -1

        def count_swaps(first):
            mismatch = 0

            for i, char in enumerate(s):
                if i % 2 == 0:
                    expected = first
                else:
                    expected = '1' if first == '0' else '0'

                if char != expected:
                    mismatch += 1

            return mismatch // 2

        if zeros > ones:
            return count_swaps('0')

        if ones > zeros:
            return count_swaps('1')

        return min(count_swaps('0'), count_swaps('1'))
```

## 複雜度分析

- **時間複雜度**：$O(n)$  
  統計字元數量與比較目標排列都只需要線性掃描字串。即使數量相同時掃描兩種排列，仍然是 $O(n)$。

- **空間複雜度**：$O(1)$  
  只使用固定數量的變數，沒有建立與字串長度相關的額外資料結構。
