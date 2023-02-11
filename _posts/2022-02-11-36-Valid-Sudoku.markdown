---
layout: post
title:  "36. Valid Sudoku"
date:   2022-02-11 21:27:53 +0800
categories: coder, medium
---

# 題目

題目網址: [36. Valid Sudoku](https://leetcode.com/problems/valid-sudoku/)

## 解題思路

當你需要判斷一個 9 x 9 的數獨盤是否合法時，你需要遵循以下規則：

每一行必須包含數字 1-9，不能重複。
每一列必須包含數字 1-9，不能重複。
每個 3 x 3 的小盤必須包含數字 1-9，不能重複。

請注意：

一個數獨盤（部分填寫）可能是合法的，但不一定是可解的。
只需要根據上面提到的規則驗證已填寫的格子。

以下是用 Python 的解法範例：

```python3=
class Solution:
    def isValidSudoku(self, board: List[List[str]]) -> bool:
        for i in range(9):
            row_set = set()
            col_set = set()
            box_set = set()
            for j in range(9):
                if board[i][j] != '.':
                    if board[i][j] in row_set:
                        return False
                    row_set.add(board[i][j])
                if board[j][i] != '.':
                    if board[j][i] in col_set:
                        return False
                    col_set.add(board[j][i])
                row_index = 3 * (i // 3) + j // 3
                col_index = 3 * (i % 3) + j % 3
                if board[row_index][col_index] != '.':
                    if board[row_index][col_index] in box_set:
                        return False
                    box_set.add(board[row_index][col_index])
        return True
```