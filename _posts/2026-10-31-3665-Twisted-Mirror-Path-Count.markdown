---
layout: article_post
title: "[Leetcode解題] 3665. Twisted Mirror Path Count"
description: "3665. Twisted Mirror Path Count - 利用方向性狀態與動態規劃統計含鏡面反射的有效路徑數"
categories: medium
tags: array dynamic-programming matrix
langs: python c++
excerpt_separator: <!--more-->
---

## 題目

[3665. Twisted Mirror Path Count](https://leetcode.com/problems/twisted-mirror-path-count/)

給定一個大小為 $n \times m$ 的二元網格 `grid`，其中：
- `grid[i][j] == 0` 表示該格為空格。
- `grid[i][j] == 1` 表示該格設有鏡面（Mirror）。

機器人從左上角 `(0, 0)` 出發，目標是移動到右下角 `(n - 1, m - 1)`。一般情況下，機器人只能往**右（Right）**或往**下（Down）**移動一格。

然而，當機器人進入鏡面格時，移動方向會被改變（反射）：
1. 若機器人往**右**進入鏡面格，方向會被轉為往**下**，並落在該鏡面格的正下方 `(i + 1, j)`。
2. 若機器人往**下**進入鏡面格，方向會被轉為往**右**，並落在該鏡面格的正右方 `(i, j + 1)`。

若移動或反射導致機器人超出網格邊界，則該路徑視為無效。

請計算從 `(0, 0)` 到 `(n - 1, m - 1)` 的不同有效路徑總數。由於答案可能很大，請將結果對 $10^9 + 7$ 取模。

題目限制：
- $n == \text{grid.length}$
- $m == \text{grid}[i]\text{.length}$
- $1 \le n, m \le 500$
- `grid[i][j]` 為 `0` 或 `1`

<!--more-->

## 解題思路

### 1. 狀態拆分：區分進入格子的方向

這題是經典問題 [62. Unique Paths](https://leetcode.com/problems/unique-paths/) 的延伸。在標準的網格路徑計數中，抵達每個格子後下一步可以自由選擇向右或向下。然而在本題中，若是踩到鏡面：
- 從上方**向下**進入鏡面的路徑，只能轉向**向右**繼續前進。
- 從左方**向右**進入鏡面的路徑，只能轉向**向下**繼續前進。

因此，我們必須維護到達每個位置時的「進入方向」狀態：
- `right[i][j]`：代表以**向右**移動方式到達 `(i, j)` 的路徑數。
- `down[i][j]`：代表以**向下**移動方式到達 `(i, j)` 的路徑數。

### 2. 動態規劃轉移

我們依據雙重迴圈，按照拓撲順序從上到下、從左到右依次拜訪網格中每個格子 `(i, j)`。

#### 起點初始化
在起點 `(0, 0)`：
```python
right[0][0] = down[0][0] = 1
```
因為在 `(0, 0)` 出發時，可以選擇第一步向右走（相當於以向右方向出發）或向下走（以向下方向出發），各算 1 種可能。

#### 當前格子的總路徑數 `ways`
- 對於起點 `(0, 0)`，我們將其計數視為 1（代表向兩個方向各嘗試邁出 1 種選擇）。
- 對於其他格子 `(i, j)`，無論是向右抵達還是向下抵達，都可以匯總為到達此格的總路徑數：
  $$\text{ways} = (right[i][j] + down[i][j]) \pmod{10^9 + 7}$$

#### 依據格子類型進行轉移
1. **當 `grid[i][j] == 0`（空格）：**
   機器人可以在此格自由選擇往右或往下前進：
   - 往右移動到 `(i, j + 1)`：以向右方向抵達，因此將總路徑數 `ways` 累加進 `right[i][j + 1]`。
   - 往下移動到 `(i + 1, j)`：以向下方向抵達，因此將總路徑數 `ways` 累加進 `down[i + 1][j]`。

2. **當 `grid[i][j] == 1`（鏡面）：**
   鏡面會扭轉原本的方向，且不允許自由轉向：
   - 原本**向右**進入鏡面的路徑（數量為 `right[i][j]`），被強制轉向**往下**，因此會轉移至 `(i + 1, j)`，累加到 `down[i + 1][j]`。
   - 原本**向下**進入鏡面的路徑（數量為 `down[i][j]`），被強制轉向**往右**，因此會轉移至 `(i, j + 1)`，累加到 `right[i][j + 1]`。

### 3. 目標與邊界判斷
每次轉移時，先判斷下一步座標 `j + 1 < m` 或 `i + 1 < n` 是否仍在網格內，越界則自然捨棄（不進行累加）。

最後抵達終點 `(n - 1, m - 1)` 的路徑總數即為：
$$(right[n - 1][m - 1] + down[n - 1][m - 1]) \pmod{10^9 + 7}$$

---

## 演算法步驟

1. 建立兩個大小為 $n \times m$ 的二維陣列 `right` 與 `down`，並將所有元素初始化為 `0`。
2. 初始化起點：令 `right[0][0] = 1`，`down[0][0] = 1`。
3. 依序雙層走訪 $i \in [0, n-1]$ 與 $j \in [0, m-1]$：
   - 若 $i = 0$ 且 $j = 0$，令 $\text{ways} = 1$；否則 $\text{ways} = (right[i][j] + down[i][j]) \pmod{10^9 + 7}$。
   - 若 `grid[i][j] == 0`：
     - 若 $j + 1 < m$，更新 $right[i][j + 1] = (right[i][j + 1] + \text{ways}) \pmod{10^9 + 7}$。
     - 若 $i + 1 < n$，更新 $down[i + 1][j] = (down[i + 1][j] + \text{ways}) \pmod{10^9 + 7}$。
   - 若 `grid[i][j] == 1`：
     - 若 $i + 1 < n$，更新 $down[i + 1][j] = (down[i + 1][j] + right[i][j]) \pmod{10^9 + 7}$。
     - 若 $j + 1 < m$，更新 $right[i][j + 1] = (right[i][j + 1] + down[i][j]) \pmod{10^9 + 7}$。
4. 返回 $(right[n - 1][m - 1] + down[n - 1][m - 1]) \pmod{10^9 + 7}$。

---

## C++ 實作

```cpp
#include <vector>

using namespace std;

class Solution {
public:
    int uniquePaths(vector<vector<int>>& grid) {
        int MOD = 1000000007;
        int n = grid.size();
        int m = grid[0].size();

        vector<vector<int>> right(n, vector<int>(m, 0));
        vector<vector<int>> down(n, vector<int>(m, 0));

        right[0][0] = down[0][0] = 1;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                int ways = 0;
                if (i == 0 && j == 0) {
                    ways = 1;
                } else {
                    ways = (right[i][j] + down[i][j]) % MOD;
                }

                if (grid[i][j] == 0) {
                    if (j + 1 < m) {
                        right[i][j + 1] = (right[i][j + 1] + ways) % MOD;
                    }
                    if (i + 1 < n) {
                        down[i + 1][j] = (down[i + 1][j] + ways) % MOD;
                    }
                } else {
                    if (i + 1 < n) {
                        down[i + 1][j] = (down[i + 1][j] + right[i][j]) % MOD;
                    }
                    if (j + 1 < m) {
                        right[i][j + 1] = (right[i][j + 1] + down[i][j]) % MOD;
                    }
                }
            }
        }

        return (right[n - 1][m - 1] + down[n - 1][m - 1]) % MOD;
    }
};
```

---

## Python 實作

```python
from typing import List


class Solution:
    def uniquePaths(self, grid: List[List[int]]) -> int:
        MOD = 10**9 + 7
        n, m = len(grid), len(grid[0])

        right = [[0] * m for _ in range(n)]
        down = [[0] * m for _ in range(n)]

        right[0][0] = down[0][0] = 1

        for i in range(n):
            for j in range(m):
                if i == 0 and j == 0:
                    ways = 1
                else:
                    ways = (right[i][j] + down[i][j]) % MOD

                if grid[i][j] == 0:
                    if j + 1 < m:
                        right[i][j + 1] = (
                            right[i][j + 1] + ways
                        ) % MOD

                    if i + 1 < n:
                        down[i + 1][j] = (
                            down[i + 1][j] + ways
                        ) % MOD
                else:
                    if i + 1 < n:
                        down[i + 1][j] = (
                            down[i + 1][j] + right[i][j]
                        ) % MOD                    
                    if j + 1 < m:
                        right[i][j + 1] = (
                            right[i][j + 1] + down[i][j]
                        ) % MOD

        return (right[n - 1][m - 1] + down[n - 1][m - 1]) % MOD
```

---

## 複雜度分析

令網格大小為 $n \times m$。

- **時間複雜度**：$O(n \times m)$。每個格子進行常數次判斷與加法轉移，走訪一次即可求得答案。
- **空間複雜度**：$O(n \times m)$。使用兩個大小為 $n \times m$ 的二維陣列 `right` 與 `down` 來記錄每個位置與方向的路徑數。

---

## 常見注意事項

- **取模運算**：每一步更新以及最終相加時，均須進行 `% MOD` 防止大數溢位。
- **邊界檢查**：向右轉移時必須確保 $j + 1 < m$；向下轉移時必須確保 $i + 1 < n$。越界的路徑視為無效，直接捨棄。
- **起點處理**：起點 `(0, 0)` 的 `ways` 需特殊判定為 1，避免被原本 `right[0][0] + down[0][0] = 2` 干擾初始步數。
