---
layout: post
title:  "68. Text Justification"
date:   2022-02-11 21:27:53 +0800
categories: coder, hard
---

# 題目說明

這是一道文本格式化的題目。給定一個字符串數組 words 和一個寬度 maxWidth，要求將文本格式化為每一行的寬度正好為 maxWidth 且完全（左右）對齊。

題目要求應該採用貪婪策略將您的文字打包，即在每一行中打包盡可能多的文字。必要時填充額外的空格''，使每一行的寬度正好為 maxWidth。

文字之間的額外空格應盡可能均勻分配。如果一行上的空格數不均勻分配在文字之間，左邊的空槽將分配更多的空格，而右邊的空槽分配的空格較少。

最後一行的文本應左對齊，並且在文字之間不插入額外空格。

[68. Text Justification](https://leetcode.com/problems/text-justification/)

# 解題思路

這個題目我們可以按照以下步驟

1. 定義變量：定義一個字符串列表`res`，用於存儲格式化後的文本。
2. 遍歷 words 列表：逐個添加`words`中的單詞到`line`變量中，並檢查`line` 的長度是否大於`maxWidth`。
3. 如果`line`的長度大於`maxWidth`：將`line`變量中的最後一個單詞刪除，並將 `line`變量加入`res`列表。
4. 對於`res`列表中的每一行：如果不是最後一行，就將空格數分配到行中，使其具有 `maxWidth`的長度，如果是最後一行，則以左對齊的形式輸出行。
5. 返回 res 列表。

```python3=
class Solution:
    def fullJustify(self, words: List[str], maxWidth: int) -> List[str]:
        res = []
        i = 0
        while i < len(words):
            j = i
            cur_len = 0
            while j < len(words) and cur_len + len(words[j]) + (j - i) <= maxWidth:
                cur_len += len(words[j])
                j += 1
            spaces = maxWidth - cur_len
            if j - i == 1 or j == len(words):
                res.append(words[i] + ' ' * spaces)
            else:
                space_each = spaces // (j - i - 1)
                space_left = spaces % (j - i - 1)
                line = words[i]
                for k in range(i + 1, j):
                    line += ' ' * (space_each + 1) if space_left > 0 else ' ' * space_each
                    line += words[k]
                    space_left -= 1
                res.append(line)
            i = j
        return res
```

# 時間複雜度

這題的時間複雜度為 $O(n)$，其中$n$為給定字串的數量。因為我們需要對每個字串進行操作，例如統計長度、插入到串列中、對串列進行處理等。此外，每一行需要重複對計算空格數量，對空格進行平均分配，這些操作也會影響時間複雜度。因此，時間複雜度是線性的。
