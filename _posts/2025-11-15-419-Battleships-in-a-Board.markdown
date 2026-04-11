---
layout: article_post
title:  "[Leetcode解題] 419. Battleships in a Board"
description:  "419. Battleships in a Board"
categories: medium
tags: array dfs
langs: python
excerpt_separator: <!--more-->
---

## 題目
[419. Battleships in a Board](https://leetcode.com/problems/battleships-in-a-board/)
給定一個 `m x n` 的矩陣 `board`，其中：

* `'X'` 表示戰艦的一部分
* `'.'` 表示空白

戰艦具有以下規則：

1. 僅能水平放置（形狀：`1 x k`）或垂直放置（形狀：`k x 1`）
2. 任意兩艘戰艦之間至少要隔一格（不能相鄰）

請你回傳棋盤上**戰艦的數量**。

## 解題思路

觀察題目的放置規則能發現：

* 一艘戰艦可能長這樣：

  * 水平：`X X X`
  * 垂直：

    ```
    X
    X
    X
    ```
* 兩艘戰艦不能接觸，因此只要看到 `'X'`，且它不是某艘戰艦的「延續」，那它就是一艘*新*戰艦的頭（起始點）。
* 因此我們可以藉由計算有幾艘*新*戰艦的起始點就是有幾艘戰艦。

### 如何判斷某格 `'X'` 是戰艦起點？

若 `(i, j)` 是 `'X'`，我們檢查：
* **上方是否也是 `'X'`：**
  * 若是，則它是垂直戰艦的中間或尾部，不算新戰艦
* **左方是否也是 `'X'`：**
  * 若是，則它是水平戰艦的中間或尾部，不算新戰艦

**只有當左、上都不是 `'X'` 時，它才是一艘新戰艦的起點。**

## C++ 實作
```cpp
class Solution {
public:
    int countBattleships(vector<vector<char>>& board) {
        int cnt = 0;
        for(int i=0; i<board.size(); i++){
            for(int j=0; j<board[0].size(); j++){
                if (board[i][j]=='.') continue;
                if (i>0 && board[i][j] == board[i-1][j]) continue;
                if (j>0 && board[i][j] == board[i][j-1]) continue;
                cnt++;
            }
        }
        return cnt;
    }
};
```

## Python 實作

```python
class Solution:
    def countBattleships(self, board: List[List[str]]) -> int:
        m, n = len(board), len(board[0])
        count = 0
        
        for i in range(m):
            for j in range(n):
                if board[i][j] == '.':
                    continue
                
                # 若上方是 X，代表同一艘船
                if i > 0 and board[i][j] == board[i - 1][j]:
                    continue
                
                # 若左方是 X，代表同一艘船
                if j > 0 and board[i][j] == board[i][j - 1]:
                    continue
                
                # 以上都不是 → 新戰艦
                count += 1
        return count
```

## 複雜度分析
* 時間複雜度：$O(m × n)$，只遍歷棋盤一次，每格做 $O(1)$ 判斷
* 空間複雜度：$O(1)$，只使用常數變數，不使用額外空間

