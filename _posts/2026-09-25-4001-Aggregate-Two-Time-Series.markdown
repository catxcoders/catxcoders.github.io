---
layout: article_post
title: "[Leetcode解題] 4001. Aggregate Two Time Series"
description: "4001. Aggregate Two Time Series - 用雙指針合併時間序列，理解缺失時間點取下一筆值的規則"
categories: medium
tags: array two-pointers
langs: python c++
excerpt_separator: <!--more-->
---

## 題目

[4001. Aggregate Two Time Series](https://leetcode.com/problems/aggregate-two-time-series/description/)。

給定兩個時間序列 `series1` 與 `series2`，每筆資料為 `[timestamp, value]`，各自依時間嚴格遞增排列。

對於兩個序列中出現過的每個時間 `t`，將兩邊在該時間的值相加，並依時間遞增回傳結果。若某個序列沒有時間 `t`，就使用該序列中**下一個時間點的值**；若後面已無資料，則視為 `0`。

兩個序列的長度各介於 `1` 到 `10^5`，時間與值皆介於 `1` 到 `10^9`。
<!--more-->

## 先理解「下一個時間點」

假設其中一個序列是：

```text
series1 = [[2, 8], [6, 3]]
```

它在不同時間的取值如下：

| 查詢時間 `t` | 取值 | 原因 |
| --- | --- | --- |
| 1 | 8 | 下一筆是時間 2 |
| 2 | 8 | 恰好存在時間 2 |
| 4 | 3 | 下一筆是時間 6 |
| 6 | 3 | 恰好存在時間 6 |
| 7 | 0 | 後面已經沒有資料 |

因此，查詢時間 `4` 時，不能沿用時間 `2` 的值 `8`。本題也沒有做線性插值，而是直接取下一筆的值 `3`。

換句話說：**找到第一筆時間大於或等於 `t` 的資料，取它的值；找不到就取 `0`。**

上表只是示範查詢規則，實際輸出只包含兩個輸入序列中出現過的時間，不必填滿中間所有整數時間。

## 解題思路

### 1. 從逐一查詢想到雙指針

直覺上，可以先收集所有時間、去重並排序，再對每個時間分別查詢兩個序列。若每次從頭尋找下一筆資料，最壞會花費 $O((m+n)^2)$ 時間，其中 $m$、$n$ 為兩個序列的長度。

利用已排序的特性，每次查詢可以改成二分搜尋。不過，所有查詢時間也是由小到大，因此兩邊的查詢位置都只會向右移動。我們可以直接使用**雙指針（Two Pointers）**，同時完成時間合併與取值。

令 `i`、`j` 分別指向兩個序列尚未處理的第一筆資料。當兩邊都有資料時：

```text
series1[i] = [t1, v1]
series2[j] = [t2, v2]
```

下一個要輸出的時間一定是 `min(t1, t2)`。

### 2. 三種情況，都是將目前兩個值相加

| 時間關係 | 輸出 | 指針移動 |
| --- | --- | --- |
| `t1 < t2` | `[t1, v1 + v2]` | 只移動 `i` |
| `t1 > t2` | `[t2, v1 + v2]` | 只移動 `j` |
| `t1 == t2` | `[t1, v1 + v2]` | 同時移動 `i`、`j` |

以 `t1 < t2` 為例：`series1` 恰好有時間 `t1`，使用 `v1`；`series2` 尚未處理的第一筆是 `t2`，它就是時間 `t1` 的下一筆資料，因此使用 `v2`。

此時只能移動 `i`。時間 `t2` 還沒被輸出，而且在到達 `t2` 前，`v2` 可能還會被用來補其他時間點。

如果兩個時間相等，該時間只輸出一次，但兩邊都必須前進。

### 3. 一邊走完，就直接輸出另一邊剩餘的資料

某個序列耗盡時，它在後續所有時間的值都是 `0`。因此，另一邊剩下的每筆 `[timestamp, value]`，加總後仍然是 `[timestamp, value]`。

這也說明為什麼不需要額外保存「上一筆值」：每次需要的都是目前指針指向的值，耗盡後則使用 `0`。

## 範例推演

使用以下自訂範例，涵蓋時間交錯、相同時間與一邊耗盡的情況：

```text
series1 = [[2, 8], [6, 3]]
series2 = [[1, 4], [6, 5], [9, 2]]
```

| 步驟 | `series1` 目前資料 | `series2` 目前資料 | 本次輸出 | 更新 |
| --- | --- | --- | --- | --- |
| 1 | `[2, 8]` | `[1, 4]` | `[1, 12]` | `j` 前進 |
| 2 | `[2, 8]` | `[6, 5]` | `[2, 13]` | `i` 前進 |
| 3 | `[6, 3]` | `[6, 5]` | `[6, 8]` | `i`、`j` 都前進 |
| 4 | 已耗盡，取 0 | `[9, 2]` | `[9, 2]` | `j` 前進 |

最後得到：

```text
[[1, 12], [2, 13], [6, 8], [9, 2]]
```

第一步在時間 `1` 使用 `series1` 下一筆的值 `8`，但保留該筆資料，等到第二步處理時間 `2` 時還要再用一次。

## Python 實作

```python
class Solution:
    def aggregateTimeSeries(
        self, series1: List[List[int]], series2: List[List[int]]
    ) -> List[List[int]]:
        m, n = len(series1), len(series2)
        i = j = 0
        ans = []

        while i < m and j < n:
            t1, v1 = series1[i]
            t2, v2 = series2[j]
            ans.append([min(t1, t2), v1 + v2])

            if t1 <= t2:
                i += 1
            if t2 <= t1:
                j += 1

        while i < m:
            timestamp, value = series1[i]
            ans.append([timestamp, value])
            i += 1

        while j < n:
            timestamp, value = series2[j]
            ans.append([timestamp, value])
            j += 1

        return ans
```

這裡刻意使用兩個獨立的 `if`：當 `t1 == t2` 時，兩個條件都成立，兩個指針都會前進。如果改成 `if ... elif ...`，相等時就只會移動其中一邊，造成同一時間被重複輸出。

比較時使用本輪一開始保存的 `t1`、`t2`，因此即使 `i` 已經更新，也不會影響第二個判斷。

## C++ 實作

使用相同的雙指針邏輯，透過 `push_back` 加入結果。每次加總最多為 `2 * 10^9`，在 LeetCode 的 32 位元有號 `int` 範圍內，因此可以直接使用 `int`。

```cpp
class Solution {
public:
    vector<vector<int>> aggregateTimeSeries(vector<vector<int>>& series1, vector<vector<int>>& series2) {
        int m = series1.size();
        int n = series2.size();
        int i = 0, j = 0;
        vector<vector<int>> ans;

        while (i < m && j < n) {
            int t1 = series1[i][0], v1 = series1[i][1];
            int t2 = series2[j][0], v2 = series2[j][1];
            ans.push_back({min(t1, t2), v1 + v2});

            if (t1 <= t2)
                ++i;
            if (t2 <= t1)
                ++j;
        }

        while (i < m) {
            ans.push_back(series1[i]);
            ++i;
        }
        while (j < n) {
            ans.push_back(series2[j]);
            ++j;
        }

        return ans;
    }
};
```

`push_back(series1[i])` 與 `push_back(series2[j])` 會複製該筆資料到結果中，不會修改輸入。時間與空間複雜度皆與 Python 版本相同。


## 複雜度分析

令 $m$、$n$ 分別為兩個輸入序列的長度，$k$ 為不同時間點的總數。
- **時間複雜度：$O(m+n)$**。每輪至少有一個指針前進，且兩個指針分別最多前進 $m$、$n$ 次。
- **額外空間複雜度：$O(1)$**，不計回傳結果，只使用固定數量的變數。
- **包含輸出的空間複雜度：$O(k)$**，最壞為 $O(m+n)$。
