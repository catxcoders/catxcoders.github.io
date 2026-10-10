---
layout: article_post
title: "[Leetcode解題] 1574. Shortest Subarray to be Removed to Make Array Sorted"
description: "1574. Shortest Subarray to be Removed to Make Array Sorted - 利用非遞減前綴與後綴，以雙指針找出最短刪除區間"
categories: medium
tags: array two-pointers
langs: python c++
excerpt_separator: <!--more-->
---

## 題目

[1574. Shortest Subarray to be Removed to Make Array Sorted](https://leetcode.com/problems/shortest-subarray-to-be-removed-to-make-array-sorted/description/)

給定整數陣列 `arr`，請移除一段**連續子陣列**，使剩下的元素按照原本順序形成**非遞減**陣列，並回傳最短的移除長度。

非遞減表示相鄰元素符合 `arr[k] <= arr[k + 1]`，允許相等。移除區間可以是空的，所以原本就排好序時，答案為 `0`。

題目限制：`1 <= arr.length <= 10^5`，`0 <= arr[i] <= 10^9`。

<!--more-->

## 解題思路

### 1. 刪除中間一段，等於保留前綴與後綴

如果保留前綴 `arr[0..i]` 與後綴 `arr[j..n-1]`，被刪掉的就是兩者之間的 `arr[i+1..j-1]`：

```text
[ 保留的前綴 ][ 刪除區間 ][ 保留的後綴 ]
           i             j
```

刪除長度為：

```text
j - i - 1
```

剩下的陣列要非遞減，必須滿足三個條件：

1. 保留的前綴本身非遞減。
2. 保留的後綴本身非遞減。
3. 若兩段都非空，交界必須符合 `arr[i] <= arr[j]`。

另外也可以只保留前綴，或只保留後綴，這兩種情況要一起考慮。

### 2. 找出最長的非遞減前綴與後綴

從左往右找出最長非遞減前綴的終點 `left`：

```python
left = 0
while left + 1 < n and arr[left] <= arr[left + 1]:
    left += 1
```

若 `left == n - 1`，代表整個陣列已經非遞減，直接回傳 `0`。

接著從右往左找出最長非遞減後綴的起點 `right`：

```python
right = n - 1
while right > 0 and arr[right - 1] <= arr[right]:
    right -= 1
```

任何合法的非空前綴都必須結束於 `left` 或更左邊；任何合法的非空後綴都必須開始於 `right` 或更右邊。超出這些邊界，就會保留一組原本逆序的相鄰元素。

### 3. 先考慮只保留其中一段

只保留最長非遞減前綴時，刪除 `arr[left+1..n-1]`，長度為 `n - left - 1`。

只保留最長非遞減後綴時，刪除 `arr[0..right-1]`，長度為 `right`。

因此可以先設定：

```python
answer = min(n - left - 1, right)
```

這也涵蓋保留的前綴或後綴為空的情況。

### 4. 用雙指針尋找可以接起來的兩段

令 `i = 0`、`j = right`，分別指向前綴終點與後綴起點。

如果 `arr[i] <= arr[j]`，代表兩段可以接起來，更新答案：

```python
answer = min(answer, j - i - 1)
i += 1
```

固定 `i` 時，越小的合法 `j` 會得到越短的刪除區間。既然目前已經找到最早可接上的 `j`，就改試更長的前綴，讓 `i` 向右移動。

如果 `arr[i] > arr[j]`，交界不合法，就讓 `j` 向右移動：

```python
j += 1
```

後綴非遞減，往右才有機會遇到足夠大的值。

### 5. 為什麼 j 不需要回到 right？

前綴也是非遞減，所以 `i` 往右移動後，新的 `arr[i]` 只會更大或相等。

先前因為太小而被跳過的後綴元素，對新的 `arr[i]` 仍然太小。因此 `j` 可以繼續往右找，不必每次重新搜尋。

兩個指針都只往右移動，即使看起來在搜尋配對，總時間仍然是 $O(n)$。

## 範例追蹤

以題目第一個範例為例：

```text
索引：  0  1  2   3  4  5  6  7
arr = [1, 2, 3, 10, 4, 2, 3, 5]
```

- 最長非遞減前綴是 `[1, 2, 3, 10]`，所以 `left = 3`。
- 最長非遞減後綴是 `[2, 3, 5]`，所以 `right = 5`。
- 只保留前綴要刪除 `4` 個元素，只保留後綴要刪除 `5` 個元素，因此 `answer = 4`。

從 `i = 0`、`j = 5` 開始：

| i | j | 比較 | 動作 | answer |
| --- | --- | --- | --- | --- |
| 0 | 5 | `1 <= 2` | 可接合，刪除長度為 `4`；`i` 前進 | 4 |
| 1 | 5 | `2 <= 2` | 可接合，刪除長度為 `3`；`i` 前進 | 3 |
| 2 | 5 | `3 > 2` | 無法接合，`j` 前進 | 3 |
| 2 | 6 | `3 <= 3` | 可接合，刪除長度為 `3`；`i` 前進 | 3 |
| 3 | 6 | `10 > 3` | 無法接合，`j` 前進 | 3 |
| 3 | 7 | `10 > 5` | 無法接合，`j` 前進至陣列外 | 3 |

答案為 `3`。例如保留 `arr[0..2]` 與 `arr[6..7]`，刪除中間的 `[10, 4, 2]`，剩下 `[1, 2, 3, 3, 5]`。

## 演算法步驟

1. 找出最長非遞減前綴的終點 `left`。若整個陣列已排序，回傳 `0`。
2. 找出最長非遞減後綴的起點 `right`。
3. 用只保留前綴或只保留後綴的刪除長度初始化答案。
4. 設定 `i = 0`、`j = right`，在 `i <= left` 且 `j < n` 時搜尋。
5. 若 `arr[i] <= arr[j]`，更新答案並移動 `i`；否則移動 `j`。
6. 回傳答案。

## C++ 實作

```cpp
class Solution {
public:
    int findLengthOfShortestSubarray(vector<int>& arr) {
        int n = arr.size();

        int left = 0;
        int right = n - 1;
        while (left + 1 < n && arr[left] <= arr[left + 1]) {
            ++left;
        }

        if (left == n - 1) return 0;
        while (right > 0 && arr[right - 1] <= arr[right]) {
            --right;
        }

        int answer = min(n - left - 1, right);
        int j = right;
        for (int i = 0; i <= left; ++i) {
            while (j < n && arr[i] > arr[j]) {
                ++j;
            }

            if (j == n) break;
            answer = min(answer, j - i - 1);
        }

        return answer;
    }
};
```

## Python 實作

```python
class Solution:
    def findLengthOfShortestSubarray(self, arr: List[int]) -> int:
        n = len(arr)
        left = 0
        right = n - 1
        while left + 1 < n and arr[left] <= arr[left + 1]:
            left += 1

        if left == n - 1:
            return 0

        while right > 0 and arr[right - 1] <= arr[right]:
            right -= 1

        answer = min(n - left - 1, right)
        j = right
        for i in range(left + 1):
            while j < n and arr[i] > arr[j]:
                j += 1

            if j == n:
                break
            answer = min(answer, j - i - 1)

        return answer
```

## 正確性說明

任何刪除連續區間的方案，留下的都可以表示為一段前綴與一段後綴。

若只保留其中一段，保留最長的非遞減前綴或後綴，就能讓刪除長度最小；這些方案已包含在初始答案中。

若兩段都非空，合法方案一定滿足 `0 <= i <= left`、`right <= j < n`，以及 `arr[i] <= arr[j]`。在尚未排序的陣列中，`left < right`，因此兩段不會重疊。

對每個 `i`，演算法會向右尋找最小的合法 `j`，得到這個前綴終點對應的最短刪除長度 `j - i - 1`。移動 `i` 後，先前被略過的 `j` 仍然不合法，因為前綴的值不會下降，所以不需要回頭搜尋。

若 `j` 到達 `n`，代表沒有後綴元素能接上目前的 `arr[i]`；後面的前綴終點值更大或相等，也不可能接上任何後綴，因此可以結束。

演算法取所有上述候選方案的最小值，故回傳的就是最短刪除長度。

## 複雜度分析

令 `n = arr.length`。

- **時間複雜度**：$O(n)$。前綴、後綴各掃描一次，接合時兩個指針也各自最多移動 `n` 次。
- **額外空間複雜度**：$O(1)$。只使用索引與答案等固定數量的變數，不建立新陣列。

## 常見錯誤

- **只考慮刪除頭或尾**：最佳解可能需要刪除中間區間，必須檢查前綴與後綴的接合。
- **把非遞減當成嚴格遞增**：相等的值也合法，判斷要使用 `<=`。
- **把刪除長度寫成 `j - i`**：索引 `i` 與 `j` 的元素都保留，因此中間只有 `j - i - 1` 個元素。
- **只計算逆序相鄰元素的數量**：刪除後會產生新的相鄰關係，仍需檢查交界。
- **改成找最長非遞減子序列**：子序列可以跳過多段元素，但本題只能刪除一段連續區間。例如 `[1, 2, 0, 3, 4, 0, 5, 6]` 可以跳過兩個 `0`，保留長度為 `6` 的非遞減子序列，卻至少要刪除 `4` 個連續元素才能符合本題要求。

## 邊界情況

| arr | 答案 | 原因 |
| --- | --- | --- |
| `[7]` | 0 | 單一元素已經非遞減 |
| `[2, 2, 5, 5]` | 0 | 重複元素不影響非遞減 |
| `[9, 7, 4, 1]` | 3 | 嚴格遞減，最多保留一個元素 |
| `[1, 4, 2, 3, 5]` | 1 | 刪除 `[4]` 後可接合前綴與後綴 |
| `[8, 1, 2, 3]` | 1 | 刪除開頭的 `[8]` |
| `[1, 2, 3, 0]` | 1 | 刪除結尾的 `[0]` |
