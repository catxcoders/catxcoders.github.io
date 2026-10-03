---
layout: article_post
title:  "[Leetcode解題] 32. Longest Valid Parentheses"
description:  "32. Longest Valid Parentheses - 三種極致解法：Stack計數、動態規劃 (DP) 與雙向正反掃描 (Parentheses Balance)"
categories: hard
tags: stack dp string greedy
langs: python
excerpt_separator: <!--more-->
---

# 32. Longest Valid Parentheses

## 題目

[32. Longest Valid Parentheses](https://leetcode.com/problems/longest-valid-parentheses/)

給定一個僅包含 `'('` 和 `')'` 的字串 `s`，請找出最長有效（格式正確且連續）括號子字串的長度。

<!--more-->

## 解題思路

本題是括號配對問題中的經典 Hard 題目。我們可以使用 **三種不同的思維與切入點** 來解決：

1. **Stack 堆疊法（維護各層合法對數）**
2. **Dynamic Programming 動態規劃法**
3. **Parentheses Balance 雙向計數掃描法（空間 $O(1)$ 最優解）**

---

### 解法一：Stack 堆疊法（記錄層級合法對數）

一般 Stack 解法通常記錄未匹配括號的索引值。這個解法採用更具巧思的方式：在 Stack 中維護當前未關閉左括號**內部已經配對成功的括號對數**。

#### 演算法邏輯：
- `st` 為一個列表（Stack），代表各層括號內部的配對對數。
- `outer` 記錄在最外層（沒有被任何 `'('` 包覆時）連續累積的合法對數。
- 遍歷字串：
  - 遇到 `'('`：入棧 `0`（`st.append(0)`），開啟一層新的括號作用域。
  - 遇到 `')'`：
    - 若 `len(st) > 1`：彈出頂層配對數 `counts`，代表當前括號閉合成功。將其與自身配對（+1）合併回上一層：`st[-1] += counts + 1`，並更新最大值 `max_valids`。
    - 若 `len(st) == 1`：代表最外層括號閉合成功，彈出 `counts` 並加總到 `outer += counts + 1`，更新 `max_valids`。
    - 若 `len(st) == 0`：代表遇到多餘無效的 `')'`，連續合法區域中斷，將最外層連擊數重置 `outer = 0`。
- 最後回傳 `max_valids * 2` 即為最長合法字串長度。

---

### 解法二：動態規劃法 (Dynamic Programming)

定義 `dp[i]` 為**以索引 `i` 結尾的最長合法括號子字串長度**。
顯然，若 `s[i] == '('`，以其結尾不可能構成合法括號，故 `dp[i] = 0`。僅當 `s[i] == ')'` 時進行狀態轉移：

#### 狀態轉移方程：
1. **Case 1: 形如 `...()`**（`s[i-1] == '('` 且 `s[i] == ')'`）
   - 前一個字元與當前字元直接組成配對，長度為 `2`。
   - 若前方還有合法子字串（即 `i >= 2`），則拼接前方的長度：
     $$dp[i] = dp[i-2] + 2$$

2. **Case 2: 形如 `...))`**（`s[i-1] == ')'` 且 `s[i] == ')'`）
   - 若 `s[i-1]` 結尾的合法子字串長度為 `dp[i-1]`，則跨過這個合法區段前方的字元位置為 `i - dp[i-1] - 1`。
   - 若 `s[i - dp[i-1] - 1] == '('`，說明與當前的 `s[i]` 恰好匹配成功！
   - 長度包含：內部長度 `dp[i-1]` + 當前配對 `2` + 匹配左括號再之前的合法長度 `dp[i - dp[i-1] - 2]`：
     $$dp[i] = dp[i - dp[i-1] - 2] + dp[i-1] + 2$$

---

### 解法三：Parentheses Balance 雙向計數掃描法（$O(1)$ 空間）

我們可以使用兩個計數器：`opening`（左括號數）與 `closing`（右括號數），進行**正向**與**反向**兩次掃描。

#### 演算法邏輯：
1. **從左至右正向掃描**：
   - 遇到 `'('` 增加 `opening`，遇到 `')'` 增加 `closing`。
   - 若 `opening == closing`：表示左右括號數量相等且完全匹配，長度為 `2 * closing`，更新最大長度。
   - 若 `closing > opening`：表示右括號過多，後續無法與之前的左括號匹配，重置 `opening = closing = 0`。
2. **從右至左反向掃描**：
   - 解決左括號一直多於右括號（例如 `((()`）在正向掃描時無法觸發 `opening == closing` 的問題。
   - 遇 `'('` 增加 `opening`，遇 `')'` 增加 `closing`。
   - 若 `opening == closing`：更新最大長度 `2 * opening`。
   - 若 `opening > closing`：左括號過多無效，重置 `opening = closing = 0`。

---

## Python 實作

### 1. Stack 堆疊法
```python
class Solution:
    def longestValidParentheses(self, s: str) -> int:
        max_valids = 0
        outer = 0
        st = []
        for i in range(len(s)):
            if s[i] == '(':
                st.append(0)
            if s[i] == ')':
                if len(st) > 1:
                    counts = st.pop()
                    st[-1] += counts + 1
                    max_valids = max(max_valids, st[-1])
                elif len(st) == 1:
                    counts = st.pop()
                    outer += counts + 1
                    max_valids = max(max_valids, outer)
                else:
                    outer = 0
        return max_valids * 2
```

### 2. 動態規劃法 (DP)
```python
class Solution(object):
    def longestValidParentheses(self, s):
        """
        :type s: str
        :rtype: int
        """
        if not s:
            return 0
        dp = [0] * len(s)
        for i in range(1, len(s)):
            if s[i-1] == '(' and s[i] == ')':
                if i > 1:
                    dp[i] = dp[i-2] + 2
                else:
                    dp[i] = 2
            elif s[i-1] == ')' and s[i] == ')':
                if i - dp[i-1] - 1 >= 0 and s[i - dp[i-1] - 1] == '(':
                    if i - dp[i-1] - 2 < 0:
                        dp[i] = dp[i-1] + 2
                    else:
                        dp[i] = dp[i - dp[i-1] - 2] + dp[i-1] + 2
                else:
                    dp[i] = 0
            else:
                dp[i] = 0

        return max(dp)
```

### 3. Parentheses Balance 雙向掃描法
```python
class Solution:
    def longestValidParentheses(self, s: str) -> int:
        answer = 0
        opening = closing = 0

        for ch in s:
            if ch == "(":
                opening += 1
            else:
                closing += 1

            if opening == closing:
                answer = max(answer, 2 * closing)
            elif closing > opening:
                opening = closing = 0

        opening = closing = 0
        for ch in reversed(s):
            if ch == "(":
                opening += 1
            else:
                closing += 1

            if opening == closing:
                answer = max(answer, 2 * opening)
            elif opening > closing:
                opening = closing = 0

        return answer
```

---

## 複雜度分析

| 解法 | 時間複雜度 | 空間複雜度 | 備註 |
| :--- | :--- | :--- | :--- |
| **1. Stack 堆疊法** | $O(n)$ | $O(n)$ | 僅需單次遍歷，Stack 紀錄各層狀態 |
| **2. 動態規劃 (DP)** | $O(n)$ | $O(n)$ | 需長度為 $n$ 的一維 `dp` 陣列 |
| **3. 雙向計數掃描** | $O(n)$ | $O(1)$ | 正反雙向掃描，空間最優 |

- **時間複雜度**：三種方法皆只需遍歷字串 1 至 2 次，故時間複雜度均為 $O(n)$。
- **空間複雜度**：前兩種方法需額外 $O(n)$ 空間儲存 Stack 或 DP 陣列；第三種方法僅需常數個計數變數，達到 $O(1)$ 空間複雜度。
