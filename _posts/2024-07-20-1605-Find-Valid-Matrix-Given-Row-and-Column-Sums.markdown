---
layout: article_post
title:  "[Leetcode解題] 1605. Find Valid Matrix Given Row and Column Sums - 使用Greedy+雙指針解"
description:  "[Leetcode解題] 1605. Find Valid Matrix Given Row and Column Sums - 使用Greedy+雙指針解"
categories: medium
tags: array two-pointers
langs: python
excerpt_separator: <!--more-->
---

# 題目

[1605. Find Valid Matrix Given Row and Column Sums](https://leetcode.com/problems/find-valid-matrix-given-row-and-column-sums

給定兩個非負整數數組`rowSum`和`colSum`。`rowSum[i]`表示第 i 行所有元素的和，而 `colSum[j]` 表示第 j 列所有元素的和。求任意一個滿足`rowSum`和`colSum`要求的非負整數矩陣，其大小為 `rowSum.length` x `colSum.length`。

 <!--more-->
 
# 解題思路

1. **初始化矩陣**：
   - 創建一個初始值為0的矩陣`mat`，其大小為 `len(rowSum)` 行和 `len(colSum)` 列。

2. **初始化指標**：
   - 使用兩個指標 `i` 和 `j`，分別指向當前正在處理的行和列，初始值均為 0。

3. **填充矩陣**：
   - 使用 `while` 迴圈，同時遍歷 `rowSum` 和 `colSum`，直到處理完所有行和列。
   - 在迴圈內：
     - 如果 `rowSum[i]` 小於 `colSum[j]`：
       - 將 `mat[i][j]` 設為 `rowSum[i]` 的值。
       - 從 `colSum[j]` 中減去 `rowSum[i]` 的值，將 `rowSum[i]` 設為0。
       - 行指標 `i` 加 1，處理下一行。
     - 如果 `rowSum[i]` 等於 `colSum[j]`：
       - 將 `mat[i][j]` 設為 `rowSum[i]`（或 `colSum[j]`）的值。
       - 將 `rowSum[i]` 和 `colSum[j]` 都設為0。
       - 行指標 `i` 和 列指標 `j` 都加 1，處理下一行和下一列。
     - 如果 `rowSum[i]` 大於 `colSum[j]`：
       - 將 `mat[i][j]` 設為 `colSum[j]` 的值。
       - 從 `rowSum[i]` 中減去 `colSum[j]` 的值，將 `colSum[j]` 設為0。
       - 列指標 `j` 加 1，處理下一列。

4. **返回結果矩陣**：
   - 當所有的行和列都處理完後，返回已填充的矩陣 `mat`。

這題主要是使用兩個指針，分別記錄行列的索引，`greedy`的從左到右填充矩陣。

```python
class Solution(object):
    def restoreMatrix(self, rowSum, colSum):
        """
        :type rowSum: List[int]
        :type colSum: List[int]
        :rtype: List[List[int]]
        """
        mat = [[0 for i in range(len(colSum))] for j in range(len(rowSum))]
        
        i = 0
        j = 0
        
        while i < len(rowSum) and j < len(colSum):
            if rowSum[i] < colSum[j]:
                mat[i][j] = rowSum[i]
                colSum[j] -= rowSum[i]
                rowSum[i] = 0
                i += 1
            elif rowSum[i] == colSum[j]:
                mat[i][j] = rowSum[i]
                rowSum[i] = colSum[j] = 0
                i += 1
                j += 1
            else:
                mat[i][j] = colSum[j]
                rowSum[i] -= colSum[j]
                colSum[j] = 0
                j += 1
        return mat
```

# 時間複雜度

填充矩陣的部分$O(n+m)$，但初始化矩陣的部分為$O(nm)$