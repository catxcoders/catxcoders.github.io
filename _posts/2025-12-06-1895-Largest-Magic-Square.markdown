---
layout: article_post
title:  "[Leetcode解題] 1895. Largest Magic Square"
description:  "1895. Largest Magic Square"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

## 題目
[1895. Largest Magic Square](https://leetcode.com/problems/largest-magic-square/)
給定一個大小為 **m × n** 的整數網格 `grid`，請找出其中 **最大邊長 k 的 k × k 魔方陣**。

### 魔方陣（magic square）的定義

一個 k × k 區塊是魔方陣，需滿足：
1. 所有 **k 個 row 的總和相同**
2. 所有 **k 個 column 的總和相同**
3. **主對角線（左上 → 右下）總和**
4. **副對角線（右上 → 左下）總和**

全部都必須等於同一個值。
- **數字可以重複，不必 distinct。**
- 任何 1×1 的 grid 都是魔方陣。

## 解題思路
### 核心想法：Prefix Sum 快速查 row sum / column sum
暴力檢查每個 k×k 子矩陣的所有 row、column、diagonal 會過慢，需要快速算區間和。

因此我們建立：

- 行前綴和 `rowPrefix`: `rowPrefix[i][j] = grid[i][0..j-1]` 的總和
    - 可用來在$O(1)$算 row 的區間和：`rowSum(i, l, r) = rowPrefix[i][r+1] - rowPrefix[i][l]`

- 列前綴和 `colPrefix`: `colPrefix[i][j] = grid[0..i-1][j]` 的總和
    - 可用來在 $O(1)$ 算 column 區間和：`colSum(j, t, b) = colPrefix[b+1][j] - colPrefix[t][j]`

### 檢查一個 k×k 區塊是否為 magic square 的條件
給定左上角 `(x, y)`：
- 主對角線
    ```
    (x + d, y + d) for d in [0..k-1]
    ```

- 副對角線
    ```
    (x + d, y + k - 1 - d)
    ```

- 每一列的和: 利用 rowPrefix，可以 $O(1)$ 得到。
- 每一行的和: 利用 colPrefix，可以 $O(1)$ 得到。
全部都相等 → 才是 magic square。

### 遍歷策略
因為題目要最大邊長 k：
**從最大 k = min(m, n) 開始往下試**
第一次找到就可以直接 return（剪枝）。

## Python 實作
```python
class Solution:
    def largestMagicSquare(self, grid):
        m, n = len(grid), len(grid[0])

        # Build row and column prefix sums (1-based)
        rowPref = [[0] * (n + 1) for _ in range(m + 1)]
        colPref = [[0] * (n + 1) for _ in range(m + 1)]

        for i in range(m):
            for j in range(n):
                rowPref[i + 1][j + 1] = rowPref[i + 1][j] + grid[i][j]
                colPref[i + 1][j + 1] = colPref[i][j + 1] + grid[i][j]

        # Helper functions
        def row_sum(r, c1, c2):
            return rowPref[r + 1][c2 + 1] - rowPref[r + 1][c1]

        def col_sum(c, r1, r2):
            return colPref[r2 + 1][c + 1] - colPref[r1][c + 1]

        def is_magic(x, y, k):
            x2 = x + k - 1
            y2 = y + k - 1

            # main diagonal
            target = sum(grid[x + d][y + d] for d in range(k))

            # anti diagonal
            diag2 = sum(grid[x + d][y2 - d] for d in range(k))
            if diag2 != target:
                return False

            # check rows
            for i in range(k):
                if row_sum(x + i, y, y2) != target:
                    return False

            # check columns
            for j in range(k):
                if col_sum(y + j, x, x2) != target:
                    return False

            return True

        # Try largest k first
        maxK = min(m, n)
        for k in range(maxK, 1, -1):
            for x in range(m - k + 1):
                for y in range(n - k + 1):
                    if is_magic(x, y, k):
                        return k
        return 1
```

## C++ 實作
```cpp
class Solution {
public:
    int largestMagicSquare(vector<vector<int>>& grid) {
        int m = grid.size();
        int n = grid[0].size();

        // rowPrefix[i][j]: sum of row i-1, from col 0..j-1
        // colPrefix[i][j]: sum of col j-1, from row 0..i-1
        vector<vector<int>> rowPrefix(m + 1, vector<int>(n + 1, 0));
        vector<vector<int>> colPrefix(m + 1, vector<int>(n + 1, 0));

        // Build prefix sums (1-based for convenience)
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                rowPrefix[i + 1][j + 1] = rowPrefix[i + 1][j] + grid[i][j];
                colPrefix[i + 1][j + 1] = colPrefix[i][j + 1] + grid[i][j];
            }
        }

        auto rowSum = [&](int r, int c1, int c2) {
            // row r (0-based), from c1..c2 (inclusive)
            return rowPrefix[r + 1][c2 + 1] - rowPrefix[r + 1][c1];
        };

        auto colSum = [&](int c, int r1, int r2) {
            // col c (0-based), from r1..r2 (inclusive)
            return colPrefix[r2 + 1][c + 1] - colPrefix[r1][c + 1];
        };

        auto isMagic = [&](int x, int y, int k) {
            // top-left (x, y), side length k
            int x2 = x + k - 1;
            int y2 = y + k - 1;

            // main diagonal
            int target = 0;
            for (int d = 0; d < k; ++d) {
                target += grid[x + d][y + d];
            }

            // anti-diagonal
            int diag2 = 0;
            for (int d = 0; d < k; ++d) {
                diag2 += grid[x + d][y2 - d];
            }
            if (diag2 != target) return false;

            // rows
            for (int i = 0; i < k; ++i) {
                if (rowSum(x + i, y, y2) != target) return false;
            }

            // columns
            for (int j = 0; j < k; ++j) {
                if (colSum(y + j, x, x2) != target) return false;
            }

            return true;
        };

        int maxK = min(m, n);
        // Try from largest k down to 2
        for (int k = maxK; k >= 2; --k) {
            // x in [0, m-k], y in [0, n-k]
            for (int x = 0; x + k <= m; ++x) {
                for (int y = 0; y + k <= n; ++y) {
                    if (isMagic(x, y, k)) {
                        return k;
                    }
                }
            }
        }
        return 1; // every 1x1 is trivially magic
    }
};
```

## 時間複雜度分析
令：
* m = rows
* n = columns
* K = min(m, n)

- 前綴和建表: $O(mn)$
- 檢查所有 k×k 區塊

對每個 k：
* 有 (m - k + 1)(n - k + 1) 個子矩陣
* 每個檢查需要 $O(k)$（對角線 $O(k)$，row/col 是 $O(1)$）

總和大約：$O( mn * K )$