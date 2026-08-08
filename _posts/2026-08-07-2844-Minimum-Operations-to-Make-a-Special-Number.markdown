---
layout: article_post
title:  "[Leetcode解題] 2844. Minimum Operations to Make a Special Number"
description:  "2844. Minimum Operations to Make a Special Number"
categories: medium
tags: math greedy string
langs: cpp python
excerpt_separator: <!--more-->
---

## 題目
[2844. Minimum Operations to Make a Special Number](https://leetcode.com/problems/minimum-operations-to-make-a-special-number/description/)

給定一個字串 `num`，每次操作可以**刪除任意一個字元**。

求**最少幾次操作**，能讓剩下的數字（不考慮前導零）能被 **25 整除**（稱為 Special Number）。

<!--more-->

### 範例

```
輸入: num = "2245047"
輸出: 2
說明: 刪除 index 5 和 6，剩下 "22450" → 22450 ÷ 25 = 898 ✓
```

```
輸入: num = "2908305"
輸出: 3
說明: 刪除三個字元後可得到 "2300" → 2300 ÷ 25 = 92 ✓
```

```
輸入: num = "10"
輸出: 1
說明: 刪除 "1"，剩下 "0" → 0 ÷ 25 = 0 ✓
```

## 解題思路

### 關鍵觀察：能被 25 整除的數字末兩位只有四種

一個整數能被 25 整除，**末兩位**必定是以下之一：

| 末兩位 | 範例 |
| ----- | ---- |
| `00`  | 100, 2500 |
| `25`  | 25, 325 |
| `50`  | 50, 150 |
| `75`  | 75, 275 |

因此，我們只需要找到字串中**從右往左**能拼出這四種結尾的最近位置，刪掉其右側多餘的字元即可。

### 轉化成尋找問題

對每種末兩位，定義「需要保留的最後兩個字元的位置」，則：

- **刪除次數** = 這兩個字元之間空格數 + 右側字元數
- 即：`num.size() - i - 2`（`i` 為第一個匹配字元的 index）

### 從右往左掃描

我們用兩個 boolean flag：
- `zero`：是否已經從右側找到 `'0'`
- `five`：是否已經從右側找到 `'5'`

每次向左掃描字元 `num[i]`，判斷能否與已找到的後綴組成四種結尾：

| 已找到後綴 | 當前字元 | 拼出結尾 |
| -------- | ------- | ------- |
| `zero = true` | `'0'` | `...00` |
| `five = true` | `'2'` | `...25` |
| `zero = true` | `'5'` | `...50` |
| `five = true` | `'7'` | `...75` |

一旦匹配成功，刪除次數就是 `num.size() - i - 2`（index `i` 右側共有 `num.size()-i-1` 個字元，扣掉保留的 1 個後綴字元）。

### 邊界情況：0

若掃完整個字串都沒找到合法的末兩位組合：
- 若存在 `'0'`：可以只保留一個 `'0'`，其餘全刪，得到數字 `0`（`0 ÷ 25 = 0` ✓），操作數為 `num.size() - 1`
- 若連 `'0'` 也沒有：只能把所有字元刪光，剩空字串視為 `0`，操作數為 `num.size()`

## 範例推演

以 `num = "2245047"` 為例：

```
從右往左掃描：
i=6, '7' → five = true
i=5, '4' → 無匹配
i=4, '0' → zero = true
i=3, '5' → zero=true, num[3]='5' → 匹配 "50"！
  → 刪除次數 = 7 - 3 - 2 = 2
```

結果：刪除 2 個字元（index 4,5 後方），保留 `"2245_"` 中的 `"22450"` ✓

## C++ 實作

```cpp
class Solution {
public:
    int minimumOperations(string num) {
        bool zero = false;
        bool five = false;

        for (int i = num.size() - 1; i >= 0; i--) {
            if ((zero && num[i] == '0')
             || (five && num[i] == '2')
             || (zero && num[i] == '5')
             || (five && num[i] == '7')
            ) return num.size() - i - 2;
            if (num[i] == '0') zero = true;
            if (num[i] == '5') five = true;
        }
        if (zero) return num.size() - 1;
        return num.size();
    }
};
```

## Python 實作

```python
class Solution:
    def minimumOperations(self, num: str) -> int:
        zero = False
        five = False

        for i in range(len(num) - 1, -1, -1):
            if (zero and num[i] == '0') \
            or (five and num[i] == '2') \
            or (zero and num[i] == '5') \
            or (five and num[i] == '7'):
                return len(num) - i - 2
            if num[i] == '0':
                zero = True
            if num[i] == '5':
                five = True

        if zero:
            return len(num) - 1
        return len(num)
```

## 複雜度分析

- **時間複雜度**：$O(n)$，只需從右往左掃描一次字串
- **空間複雜度**：$O(1)$，只用兩個 boolean flag
