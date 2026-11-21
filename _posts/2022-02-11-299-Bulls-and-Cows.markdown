---
layout: article_post
title: "[Leetcode解題] 299. Bulls and Cows"
description: "299. Bulls and Cows - 先比對位置，再用數字出現次數計算錯位的配對"
categories: medium
tags: string counting
langs: python c++
excerpt_separator: <!--more-->
---

## 題目

[299. Bulls and Cows](https://leetcode.com/problems/bulls-and-cows/)

給定兩個等長的數字字串 `secret`（答案）和 `guess`（猜測），回傳格式為 `"xAyB"` 的提示。

- **Bull（A）**：數字和位置都正確，計入 `x`。
- **Cow（B）**：先排除所有 bulls，再將剩下的相同數字一對一配對，配對數計入 `y`。

例如 `secret = "1807"`、`guess = "7810"`。`8` 的位置正確，剩下的 `1`、`0`、`7` 都能配對，因此回傳 `"1A3B"`。

兩個字串的長度相同，介於 `1` 到 `1000`，且只包含 `0` 到 `9`。數字可以重複，字串也可以 `0` 開頭，例如 `"0111"`。

<!--more-->

## 解題思路

### 1. 先確定位置正確的數字

逐位比較 `secret[i]` 和 `guess[i]`。如果兩者相同，就把 `bulls` 加一，並跳過這一位的次數統計。這樣已經配對成功的數字就只會計入一次。

如果兩者不同，就把這兩個數字分別記在 `secret_count` 和 `guess_count`。例如答案這一位是 `2`、猜測是 `1`，就把 `secret_count[2]` 和 `guess_count[1]` 各加一。

### 2. 取兩邊出現次數的較小值

假設扣除 bulls 後，數字 `1` 在答案中剩下 `1` 次，在猜測中剩下 `2` 次。每次配對都會各用掉一個 `1`，所以只能配出 `1` 個 cow。

對任一數字 `d`，它貢獻的 cows 就是 `min(secret_count[d], guess_count[d])`。把 `0` 到 `9` 的結果加總，就得到 `cows`。

## 範例推演

以 `secret = "1123"`、`guess = "0111"` 為例，逐位比較並統計。

| 索引 | `secret[i]` | `guess[i]` | 處理方式 |
| --- | --- | --- | --- |
| 0 | `1` | `0` | 答案記一個 `1`，猜測記一個 `0` |
| 1 | `1` | `1` | 計入一個 bull |
| 2 | `2` | `1` | 答案記一個 `2`，猜測記一個 `1` |
| 3 | `3` | `1` | 答案記一個 `3`，猜測記一個 `1` |

統計後，只有 `1` 同時出現在兩邊。答案剩下一個 `1`，猜測剩下兩個 `1`，所以 `cows = min(1, 2) = 1`。加上索引 `1` 的 bull，回傳 `"1A1B"`。

## 演算法步驟

1. 初始化 `bulls = 0`，並建立兩個長度為 `10` 的計數陣列，初始值都為 `0`。
2. 逐位比較兩個字串。相同時累加 `bulls`，相異時更新兩邊的數字次數。
3. 對 `0` 到 `9` 的每個數字，取兩個計數的較小值並累加至 `cows`。
4. 將兩個計數組成 `"xAyB"` 並回傳。

## C++ 實作

```cpp
#include <algorithm>
#include <cstddef>
#include <sstream>
#include <string>
#include <vector>

class Solution {
public:
    std::string getHint(const std::string& secret, const std::string& guess) {
        constexpr std::size_t digitCount = 10;
        int bulls = 0;
        std::vector<int> secretCount(digitCount, 0);
        std::vector<int> guessCount(digitCount, 0);

        for (std::size_t i = 0; i < secret.size(); ++i) {
            if (secret[i] == guess[i]) {
                ++bulls;
            } else {
                ++secretCount[secret[i] - '0'];
                ++guessCount[guess[i] - '0'];
            }
        }

        int cows = 0;
        for (std::size_t digit = 0; digit < digitCount; ++digit) {
            cows += std::min(secretCount[digit], guessCount[digit]);
        }

        std::stringstream hint;
        hint << bulls << 'A' << cows << 'B';
        return hint.str();
    }
};
```

`std::vector<int>(digitCount, 0)` 建立 `10` 格，並將每格初始化為 `0`。數字字元減去 `'0'` 就是對應的索引，例如 `'7' - '0'` 等於 `7`。

`std::stringstream` 定義於 `<sstream>`。用 `<<` 依序寫入兩個計數及字元 `A`、`B`，再用 `.str()` 取出提示字串。

## Python 實作

```python
class Solution:
    def getHint(self, secret: str, guess: str) -> str:
        bulls = 0
        secret_count = [0] * 10
        guess_count = [0] * 10

        for secret_digit, guess_digit in zip(secret, guess):
            if secret_digit == guess_digit:
                bulls += 1
            else:
                secret_count[int(secret_digit)] += 1
                guess_count[int(guess_digit)] += 1

        cows = sum(min(secret_count[digit], guess_count[digit]) for digit in range(10))
        return f"{bulls}A{cows}B"
```

`zip(secret, guess)` 會依序產生同一位置的兩個字元，再用 `int()` 將單一數字字元轉成索引。

## 正確性說明

每個位置都比較一次。演算法恰好在兩個字元相等時增加 `bulls`，因此 `bulls` 正好是數字與位置都正確的數量。

對於剩下的任一數字 `d`，每個 cow 都需要答案和猜測各提供一個 `d`。能配成的對數最多是兩邊出現次數的較小值。由於每一個剩下的 `d` 都可以和另一邊的任一個 `d` 配對，所以可以配到其中一邊用完，達到這個上限。不同數字的配對彼此獨立，加總各數字的配對數就得到正確的 `cows`。

## 複雜度分析

令 `n` 為任一輸入字串的長度。

- **時間複雜度** $O(n)$。比較 `n` 個位置後，再掃描 `10` 種數字。
- **額外空間複雜度** $O(1)$。兩個計數陣列都固定為 `10` 格，此處計算函式內的輔助空間。

## 常見錯誤

- **把 bulls 也放進次數統計**。如果接著直接把每個數字的較小次數加到 `cows`，就會把已配對的位置算兩次。
- **只檢查數字有沒有出現**。例如 `secret = "12"`、`guess = "11"`，答案中的 `1` 已經用於 bull，提示是 `"1A0B"`。配對時需要保留每個數字的剩餘次數。
- **先把整個字串轉成整數**。例如 `"01"` 轉換後會失去開頭的 `0`。逐位比對時應保留字串，只在更新計數時轉換單一字元。
