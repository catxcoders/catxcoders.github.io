---
layout: article_post
title:  "[Leetcode解題] 1807. Evaluate the Bracket Pairs of a String"
description:  "1807. Evaluate the Bracket Pairs of a String - 哈希表與字串解析雙指針，將括號內鍵值快速替換"
categories: medium
tags: string hashTable
langs: python
excerpt_separator: <!--more-->
---

# 1807. Evaluate the Bracket Pairs of a String

## 題目

[1807. Evaluate the Bracket Pairs of a String](https://leetcode.com/problems/evaluate-the-bracket-pairs-of-a-string/)

給定一個字串 `s`，其中包含若干個以括號括起來的鍵名 `(key)`，以及一個二維字串陣列 `knowledge`，其中 `knowledge[i] = [key_i, value_i]` 代表 `key_i` 對應的值為 `value_i`。

請將字串 `s` 中所有括號 `(key)` 替換為 `knowledge` 中對應的 `value`。如果該 `key` 不存在於 `knowledge` 中，則將 `(key)` 替換為問號 `'?'`。最終回傳替換完成後的字串。

<!--more-->

## 解題思路

本題要求解析字串中的括號配對 `(key)` 並將其替換為哈希對照表中的值，屬於**哈希表（Hash Table）**結合**雙指針 / 字串掃描**的經典應用。

### 1. 哈希表預處理

若每次搜尋 `key` 都對 `knowledge` 陣列進行線性搜尋，會導致整體時間複雜度居高不下。因此，我們在開始掃描字串前，先將 `knowledge` 轉換為字典（Hash Table / Map）：

```python
knowledge_mappings = dict(knowledge)
```

這樣每個 `key` 的查找與比對平均僅需 $O(1)$ 時間。

### 2. 雙指針 / 字串掃描

使用指針 `start` 遍歷字串 `s`：

- **一般字元**：若 `s[start] != '('`，表示當前字元為普通字元，直接將 `s[start]` 放入答案列表 `ans` 中，並將 `start` 往後移動 1 格。
- **括號開頭**：若 `s[start] == '('`，則使用另一個指針 `end` 從 `start + 1` 開始尋找對應的右括號 `')'`：
  - 擷取括號內的鍵名：`target = s[start+1:end]`
  - 查詢 `knowledge_mappings`：
    - 若 `target` 存在，將 `knowledge_mappings[target]` 加入 `ans`。
    - 若 `target` 不存在，將 `'?'` 加入 `ans`。
  - 將 `start` 移動至 `end + 1`，繼續處理後續字元。

### 3. 組合結果

最後使用 `''.join(ans)` 將列表組合成最終字串並回傳。

---

## Python 實作

```python
class Solution:
    def evaluate(self, s: str, knowledge: list[list[str]]) -> str:
        knowledge_mappings = dict(knowledge)
        start = 0
        ans = []
        while start < len(s):
            if s[start] != '(':
                ans.append(s[start])
                start += 1
                continue
            end = start + 1
            while s[end] != ')':
                end += 1
            target = s[start+1:end]
            if target in knowledge_mappings:
                ans.append(knowledge_mappings[target])
            else:
                ans.append('?')
            start = end + 1
        return ''.join(ans)
```

---

## 複雜度分析

- **時間複雜度**：$O(N + M \cdot L)$
  其中 $N = \text{len}(s)$，$M = \text{len}(knowledge)$，$L$ 為鍵值的平均長度。
  - 將 `knowledge` 轉為字典需要 $O(M \cdot L)$ 時間。
  - 遍歷字串 `s` 時，每個字元最多被 `start` 與 `end` 各訪問一次，屬於線性掃描 $O(N)$；哈希表查找與切片平均需 $O(L)$ 時間。
  - 因此整體時間複雜度為 $O(N + M \cdot L)$。
- **空間複雜度**：$O(N + M \cdot L)$
  `knowledge_mappings` 字典佔用 $O(M \cdot L)$ 空間，`ans` 列表儲存結果字元佔用 $O(N)$ 空間。
