---
layout: article_post
title:  "[Leetcode解題] Combination Sum - 遞迴/backtrace解"
description:  "[Leetcode解題] Combination Sum - 遞迴/backtrace解"
categories: medium
tags: recursion backtrace
langs: python
excerpt_separator: <!--more-->
---

# 題目
[39. Combination Sum](https://leetcode.com/problems/combination-sum/)

# 題目
給定一個不同整數的候選人陣列和目標整數目標，返回所有選定的數字的總和為目標的候選人的所有唯一組合的列表。您可以以任意順序返回組合。

<!--more-->

# 解題思路
這道題可以使用回溯算法來解決，解題思路如下：

1. 定義一個空列表 combination，用來存储每個組合。
2. 從數組 candidates 中選擇一個數字加入 combination 列表，同時更新剩餘的 target。
3. 如果剩餘的 target 等於 0，則將此 combination 加入結果列表；如果剩餘的 target 小於 0，則退出迴圈。
4. 如果剩餘的 target 大於 0，則繼續從數組 candidates 中選擇數字加入 combination。
5. 回到步驟 2，繼續遍歷整個數組。
6. 如果 combination 不再繼續加入數字，則退出迴圈，並刪除最後一個數字，回到步驟 2 繼續遍歷整個數組。
7. 重複步驟 2 到 6，直到所有數組都被遍歷完畢，得到所有組合。


# 實作
以下是一個使用回溯法的 Python 解決方案：
```python
def combinationSum2(self, candidates: List[int], target: int) -> List[List[int]]:
    def backtrack(start, target, combination, combinations):
        if target == 0:
            combinations.append(list(combination))
            return
        for i in range(start, len(candidates)):
            if i > start and candidates[i] == candidates[i-1]:
                continue
            if target < candidates[i]:
                break
            combination.append(candidates[i])
            backtrack(i, target-candidates[i], combination, combinations)
            combination.pop()

    candidates.sort()
    combinations = []
    backtrack(0, target, [], combinations)
    return combinations
```


# 複雜度
在這個題目中，時間複雜度的計算方式是：$O(2^n)$，其中 $n$ 是數組的長度。因為每個數字都可以選或不選，所以總共有 $2^n$ 種可能的組合，因此需要遍歷整個數組。

但是，在本題的實現中，我們使用了剪枝技巧，可以大大縮短執行時間。因此，實際上的時間複雜度可能比 $O(2^n)$ 更低。
