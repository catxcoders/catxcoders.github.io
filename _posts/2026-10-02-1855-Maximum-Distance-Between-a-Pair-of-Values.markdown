---
layout: article_post
title: "[Leetcode解題] 1855. Maximum Distance Between a Pair of Values"
description: "1855. Maximum Distance Between a Pair of Values - 利用非遞增陣列的性質，以雙指針求最大距離"
categories: medium
tags: array two-pointers
langs: python c++
excerpt_separator: <!--more-->
---

# 1855. Maximum Distance Between a Pair of Values

## 題目

[1855. Maximum Distance Between a Pair of Values](https://leetcode.com/problems/maximum-distance-between-a-pair-of-values/description/)

給定兩個**非遞增**陣列 `nums1` 與 `nums2`，也就是元素由大到小排列，允許相鄰元素相等。

從 `nums1` 選擇索引 `i`、從 `nums2` 選擇索引 `j`，合法配對必須同時滿足：

- `i <= j`。
- `nums1[i] <= nums2[j]`。

請回傳所有合法配對中最大的距離 `j - i`。若沒有合法配對，回傳 `0`。索引從 `0` 開始，兩個陣列的長度不一定相同。

題目限制：兩個陣列的長度各介於 `1` 到 `10^5`，元素值介於 `1` 到 `10^5`。

<!--more-->

## 解題思路

### 1. 暴力枚舉為什麼不夠快？

令兩個陣列的長度分別為 `m` 與 `n`。最直接的做法是枚舉所有 `(i, j)`，檢查是否符合條件，再更新最大距離。

時間複雜度為 $O(mn)$。當兩個陣列的長度都接近 `10^5` 時，最多需要檢查約 `10^10` 組配對，因此需要利用已排序的性質減少搜尋。

### 2. 值不符合時，移動 i

假設目前 `nums1[i] > nums2[j]`，這組配對不合法。

由於 `nums2` 非遞增，往右移動 `j` 只會取得更小或相同的值，因此固定目前的 `i`，後面的 `j` 也都無法配對。

此時應該讓 `i` 向右移動，尋找更小或相同的 `nums1[i]`：

```text
i += 1
```

移動後若 `i > j`，必須把 `j` 推進到 `i`，維持索引條件：

```text
j = max(j, i)
```

被跳過的位置都滿足 `j < i`，不可能與目前或更右邊的 `i` 組成合法配對。

### 3. 值符合時，移動 j

如果 `nums1[i] <= nums2[j]`，由於我們一直維持 `i <= j`，目前就是合法配對，可以更新答案：

```text
answer = max(answer, j - i)
```

接著讓 `j` 向右移動，嘗試拉大距離。

為什麼不移動 `i`？因為固定 `j` 時，`i` 越大，距離 `j - i` 反而越小。目前這個 `j` 已經得到足以保留的候選答案，不需要再搭配更右邊的 `i`。

### 4. 兩個指針都不必回頭

每次迴圈至少有一個指針向右移動，而且只會捨棄不合法、或無法改善答案的配對。

因此可從 `i = 0`、`j = 0` 開始，一路往右掃描，直到其中一個指針超出對應陣列的範圍。

## 範例追蹤

以下使用自訂範例：

```text
nums1 = [9, 5, 3]
nums2 = [10, 8, 6, 5, 3]
```

初始 `i = 0`、`j = 0`、`answer = 0`。

| i | j | 比較 | 動作 | answer |
| --- | --- | --- | --- | --- |
| 0 | 0 | `9 <= 10` | 合法，距離為 0，`j` 前進 | 0 |
| 0 | 1 | `9 > 8` | `i` 前進到 1 | 0 |
| 1 | 1 | `5 <= 8` | 合法，距離為 0，`j` 前進 | 0 |
| 1 | 2 | `5 <= 6` | 合法，距離為 1，`j` 前進 | 1 |
| 1 | 3 | `5 <= 5` | 合法，距離為 2，`j` 前進 | 2 |
| 1 | 4 | `5 > 3` | `i` 前進到 2 | 2 |
| 2 | 4 | `3 <= 3` | 合法，距離為 2，`j` 前進 | 2 |

最後 `j = 5` 超出 `nums2` 範圍，回傳 `2`。例如配對 `(1, 3)` 的值為 `5 <= 5`，距離為 `3 - 1 = 2`。

再看需要調整 `j` 的情況：

```text
nums1 = [8, 4]
nums2 = [6, 5]
```

一開始 `8 > 6`，所以 `i` 從 `0` 前進到 `1`。此時 `j = 0 < i`，應將 `j` 一起推進到 `1`，再檢查 `(1, 1)`。這組配對合法，但距離為 `0`，因此答案是 `0`。

## 演算法步驟

1. 設定 `i = 0`、`j = 0`、`answer = 0`。
2. 當兩個指針都還在各自陣列範圍內時，比較 `nums1[i]` 與 `nums2[j]`。
3. 若 `nums1[i] <= nums2[j]`，以 `j - i` 更新答案，並將 `j` 加一。
4. 否則將 `i` 加一，再令 `j = max(j, i)`，保持 `i <= j`。
5. 迴圈結束後回傳 `answer`。

## C++ 實作

```cpp
#include <algorithm>
#include <vector>
using namespace std;

class Solution {
public:
    int maxDistance(vector<int>& nums1, vector<int>& nums2) {
        int m = static_cast<int>(nums1.size());
        int n = static_cast<int>(nums2.size());
        int i = 0, j = 0;
        int answer = 0;

        while (i < m && j < n) {
            if (nums1[i] <= nums2[j]) {
                answer = max(answer, j - i);
                ++j;
            } else {
                ++i;
                j = max(j, i);  // 維持 i <= j
            }
        }

        return answer;
    }
};
```

## Python 實作

```python
from typing import List


class Solution:
    def maxDistance(self, nums1: List[int], nums2: List[int]) -> int:
        m, n = len(nums1), len(nums2)
        i = j = 0
        answer = 0

        while i < m and j < n:
            if nums1[i] <= nums2[j]:
                answer = max(answer, j - i)
                j += 1
            else:
                i += 1
                j = max(j, i)  # 維持 i <= j

        return answer
```

## 正確性說明

在每次迴圈開始時，維持 `i <= j`，且所有已捨棄的配對都不可能改善目前答案。

初始時 `i = j = 0`，尚未捨棄任何配對，條件成立。接下來分成兩種情況：

- **`nums1[i] > nums2[j]`**：對任何 `k >= j`，非遞增性保證 `nums2[k] <= nums2[j] < nums1[i]`，所以目前的 `i` 無法與任何尚未處理的右側位置配對，可以安全捨棄。若前進後 `j < i`，跳過的索引也都違反 `i <= j`。
- **`nums1[i] <= nums2[j]`**：目前配對合法，先記錄距離 `j - i`。對於任何更大的左側索引 `k > i`，與同一個 `j` 的距離 `j - k` 都更小，不可能改善剛記錄的答案，因此可以安全捨棄目前的 `j`。

每一步都保留已找到的最大合法距離，且不會漏掉更好的配對。當任一指針到達陣列尾端，就沒有尚待考慮的配對，因此回傳值就是最大距離。若始終沒有合法配對，答案保留初始值 `0`，也符合題意。

## 複雜度分析

令 `m = nums1.length`、`n = nums2.length`。

- **時間複雜度**：$O(m + n)$。兩個指針只向右移動，每次迴圈至少推進其中一個，不會重複掃描。
- **額外空間複雜度**：$O(1)$。只使用指針、長度與答案等固定數量的變數。

## 常見錯誤

- **將非遞增誤認成嚴格遞減**：重複元素是允許的，而且值相等時也能配對，判斷應使用 `<=`。
- **只比較值，忘記索引條件**：即使 `nums1[i] <= nums2[j]`，若 `i > j` 仍不是合法配對。本實作以 `j = max(j, i)` 維持條件。
- **值不符合時仍移動 j**：當 `nums1[i] > nums2[j]`，右側更小的 `nums2` 元素無法解決問題，應移動 `i`。
- **把距離寫成 `j - i + 1`**：題目要的是索引差，不是包含兩端的區間長度。
- **假設兩個陣列等長**：存取元素前，必須分別確認 `i < m` 與 `j < n`。
- **答案為 0 就代表沒有合法配對**：合法配對也可能只有 `i == j`，此時最大距離同樣是 `0`。
