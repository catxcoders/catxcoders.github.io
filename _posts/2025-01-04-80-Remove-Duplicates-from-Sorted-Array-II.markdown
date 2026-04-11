---
layout: article_post
title:  "[Leetcode解題] 80. Remove Duplicates from Sorted Array II"
description:  "80. Remove Duplicates from Sorted Array II"
categories: medium
tags: two-pointers
langs: python
excerpt_separator: <!--more-->
---

## 題目

[80. Remove Duplicates from Sorted Array II](https://leetcode.com/problems/remove-duplicates-from-sorted-array-ii/)
給定一個按非遞減順序排序的整數陣列 `nums`，請移除部分重複的元素，使得每個元素最多出現兩次，且元素的相對順序保持不變。
如果移除重複後剩下 `k` 個元素，則 `nums` 的前 `k` 個位置應該包含最終的結果。在 `k` 之後的部分內容則不重要。
不可以使用額外的陣列空間，必須以 $O(1)$ 的額外記憶體inplace修改輸入陣列。
<!--more-->

## 解題思路

1. **問題分析**:
   - 陣列是有序的，所以相同的數字必定是連續出現。
   - 我們最多保留兩個相同的數字，因此可以通過比較當前數字與「距離它兩步之前的數字」來判斷是否需要保留。

2. **雙指針法**:
   - 使用兩個指標：
     - `l` 表示已處理好的陣列末端位置。
     - `r` 表示當前掃描到的元素。
   - 初始時，`l` 指向陣列的第一個位置，`r` 從第二個位置開始遍歷。
   - 當 `nums[r]` 與 `nums[l-1]` 不同時，將 `nums[r]` 放到 `l+1` 位置，並將 `l` 向右移動。
   - 重複以上過程直到掃描完整個陣列。

## Python 實作

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        if len(nums) <= 2:
            return len(nums)

        l = 1  # 已處理好的部分的最後一個位置
        for r in range(2, len(nums)):
            if nums[r] != nums[l - 1]:
                l += 1
                nums[l] = nums[r]

        return l + 1
```

## C++ 實作

```cpp
class Solution {
public:
    int removeDuplicates(vector<int>& nums) {
        int l=1;
        if (nums.size()<=2) return nums.size();
        for(auto r=2; r<nums.size(); r++){
            if (nums[r]!=nums[l-1]) nums[++l] = nums[r];
        }
        return l+1;
    }
};

```

## 複雜度分析
   - 時間複雜度: $O(n)$，其中 `n` 是陣列的長度，因為每個元素只被遍歷一次。
   - 空間複雜度: $O(1)$，不使用額外的空間。

