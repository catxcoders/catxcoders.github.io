---
layout: article_post
title:  "[Leetcode解題] 2918. Minimum Equal Sum of Two Arrays After Replacing Zeros"
description:  "2918. Minimum Equal Sum of Two Arrays After Replacing Zeros"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

## 題目

[2918. Minimum Equal Sum of Two Arrays After Replacing Zeros](https://leetcode.com/problems/minimum-equal-sum-of-two-arrays-after-replacing-zeros/description/?envType=daily-question&envId=2025-05-10)

給定兩個整數陣列`nums1`和`nums2`，兩者都只包含正整數和 0。

你必須將這兩個陣列中所有的`0`替換成嚴格大於`0`的正整數，使得兩個陣列的元素總和相等。

請你回傳可以達成的最小相等總和，如果無法做到，請回傳`-1`。

<!--more-->

## 解題思路

1. 初始化變數：

分別計算`nums1`與 `nums2` 中的 0 的個數（`num_zeros1` 和 `num_zeros2`），以及目前各自的總和（`sum_nums1` 和 `sum_nums2`）。

2. 同時含有 0 的情況：

如果兩個陣列都包含 0，則我們可以自由選擇替換的值來讓兩邊相等。此時，為了使總和最小，我們將所有的 0 替換成最小可能值（1），並取兩邊這樣操作後的總和中的最大值作為答案：
max(sum_nums1 + num_zeros1, sum_nums2 + num_zeros2)

3. 兩邊都沒有 0 的情況：

此時無法對陣列內容做出任何改動。若兩邊總和相等，直接回傳該總和；否則回傳 -1。

4. 只有一邊含有 0 的情況：

若 `nums1` 沒有 0，僅能調整 `nums2`，那就要看能否讓 `sum_nums2 + num_zeros2 * 1`（最小可能補值）達到 `sum_nums1`，若可以就回傳 `sum_nums1`，否則回傳 -1。

同理，若 `nums2` 沒有 0，只能調整 `nums1`，檢查 `sum_nums1 + num_zeros1 <= sum_nums2` 是否成立，成立則回傳 `sum_nums2`，否則回傳 -1。

## 程式碼

```python
class Solution(object):
    def survivedRobotsHealths(self, positions, healths, directions):
        """
        :type positions: List[int]
        :type healths: List[int]
        :type directions: str
        :rtype: List[int]
        """
        pos_w_idx = []
        for idx, position in enumerate(positions):
            pos_w_idx.append((idx, position))
        
        pos_w_idx = sorted(pos_w_idx, key=lambda x: x[1])
        
        stack = []
        for idx, pos in pos_w_idx:
            if directions[idx] == 'R':
                stack.append(idx)
                continue
            if directions[idx] == 'L':
                while stack:
                    if healths[stack[-1]] > healths[idx]:
                        # Collision, R wins
                        healths[idx] = 0
                        healths[stack[-1]] -= 1
                        break
                    elif healths[stack[-1]] < healths[idx]:
                        # Collision, L wins
                        healths[idx] -= 1
                        healths[stack[-1]] = 0
                        stack.pop()
                    else:
                        # Collision, tie
                        healths[idx] = 0
                        healths[stack[-1]] = 0
                        stack.pop()
                        break
        
        ans = []
        for health in healths:
            if health:
                ans.append(health)
        return ans

```

## 時間複雜度

$O(N)$，要計算零的數量跟算總和