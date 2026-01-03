---
layout: article_post
title:  "[Leetcode解題] 1869. Longer Contiguous Segments of Ones than Zeros"
description:  "1869. Longer Contiguous Segments of Ones than Zeros"
categories: easy
tags: array String
langs: python
excerpt_separator: <!--more-->
---

## 題目
給定一個二元字串 `s`（只包含 `'0'` 與 `'1'`），請判斷：
* `s` 中 **最長的連續 1 區段長度** 是否 **嚴格大於** **最長的連續 0 區段長度**。
若是，回傳 `true`；否則回傳 `false`。
<!--more-->

### 範例

`s = "110100010"`

* 最長連續 `1` 區段長度為 `2`（"11"）
* 最長連續 `0` 區段長度為 `3`（"000"）
* 因為 `2` 不大於 `3`，所以回傳 `false`


## 解題思路

這題本質是「線性掃描 + 連續段（run-length）統計」。

### 觀察
我們只需要在走訪字串時維護兩件事：

1. **目前正在延伸的連續段長度**

   * `cur0`：目前連續 `0` 的長度
   * `cur1`：目前連續 `1` 的長度

2. **歷史最大值**

   * `best0`：所有連續 `0` 段的最大長度
   * `best1`：所有連續 `1` 段的最大長度

### 掃描規則

對每個字元 `c`：

* 若 `c == '0'`：

  * `cur0++`
  * `cur1 = 0`（因為連續 1 被中斷）
  * `best0 = max(best0, cur0)`

* 若 `c == '1'`：

  * `cur1++`
  * `cur0 = 0`（因為連續 0 被中斷）
  * `best1 = max(best1, cur1)`

掃描完成後比較 `best1 > best0`。

## C++ 實作

```cpp
class Solution {
public:
    bool checkZeroOnes(string s) {
        int best0 = 0, best1 = 0;
        int cur0 = 0, cur1 = 0;

        for (const char &c : s) {
            if (c == '0') {
                cur0++;
                cur1 = 0;
                best0 = max(best0, cur0);
            } else { // c == '1'
                cur1++;
                cur0 = 0;
                best1 = max(best1, cur1);
            }
        }
        return best1 > best0;
    }
};
```


## Python 實作

```python
class Solution:
    def checkZeroOnes(self, s: str) -> bool:
        best0 = best1 = 0
        cur0 = cur1 = 0

        for c in s:
            if c == '0':
                cur0 += 1
                cur1 = 0
                best0 = max(best0, cur0)
            else:  # c == '1'
                cur1 += 1
                cur0 = 0
                best1 = max(best1, cur1)

        return best1 > best0
```


## 時間與空間複雜度

* **時間複雜度**：`O(n)`
  只需掃描字串一次，`n` 為字串長度。

* **空間複雜度**：`O(1)`
  只使用固定數量的變數，不隨輸入成長。
