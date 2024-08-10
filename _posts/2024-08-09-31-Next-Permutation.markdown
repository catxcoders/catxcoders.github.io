---
layout: article_post
title:  "[Leetcode解題] 31. Next Permutation"
description:  "[Leetcode解題] 31. Next Permutation"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

# 31. Next Permutation

## 題目
[31. Next Permutation](https://leetcode.com/problems/next-permutation/)
題目要求是找到一個整數陣列的下一個字典序排列。如果已經是最大排列，那麼就返回最小排列（即升序排列）。這個功能要求只使用常數額外記憶體。
<!--more-->
## 解題思路

我們先看一個例子: 假設我們有一個陣列 nums = [1, 3, 5, 4, 2]，現在我們要找到它的下一個排列。
```
nums = [1, 3, 5, 4, 2]
           ^
```
我們關注目前是數字3的這個位置，我們的目標是
- 這個位置(由右向左第一個下降的數值)的數值變大一點點，因此可以將3跟4交換
    ```
    nums = [1, 4, 5, 3, 2]
               ^
    ```
- **這個位置之後的字典序是最小**: 由於原本是降序排列，因此最小字典序就直接reverse就可以了
    ```
    nums = [1, 4, 2, 3, 5]
               ^
    ```
> **先交換再reverse** 與 **先reverse再交換**，結果是一樣的，但是如果先reverse就可以使用函式庫中的upper_bound，因此下面的解題流程是先reverse再交換。

因此整個解題的流程是:
1. **尋找第一個下降點**：從後往前看，找到第一個數字`nums[idx]`，使得`nums[idx]`小於`nums[idx+1]`。這個位置之後的數字必定是降序排列。
2. **反轉後段**：因為從`idx+1`到結尾是降序，我們直接反轉這段，讓它變成升序，目的是創造出這部分可以達到的最小排列。
3. **找到交換位置**：我們需要在`idx+1`到結尾中內找到第一個比`nums[idx]`大的數，如果存在，將第一個比`nums[idx]`大的數，與`nums[idx]`進行交換。這樣才能確保整體排列是剛好大於當前排列的下一個排列。進行交換後，從idx位置後的序列仍然保持升序，這樣整體序列就是字典序的下一個排列。

## Python 實作
```python
def nextPermutation(nums):
    # 找到第一個下降點
    idx = len(nums) - 2
    while idx >= 0 and nums[idx] >= nums[idx + 1]:
        idx -= 1

    # 反轉後段
    nums[idx + 1:] = reversed(nums[idx + 1:])

    # 如果有下降點，進行交換
    if idx >= 0:
        # 找到第一個大於nums[idx]的位置進行交換
        swap_idx = bisect.bisect_right(nums, nums[idx], idx + 1)
        nums[idx], nums[swap_idx] = nums[swap_idx], nums[idx]

```

## C++實作
```cpp
class Solution {
public:
    void nextPermutation(vector<int>& nums) {
        // Step 1: Find the first decreasing element from the end
        int idx = nums.size() - 2;
        while (idx >= 0 && nums[idx] >= nums[idx + 1]) {
            idx--;
        }

        // Step 2: Reverse the numbers after the found index to make them in ascending order
        reverse(nums.begin() + idx + 1, nums.end());

        // Step 3: If the decreasing element was found, find the next larger element to swap
        if (idx >= 0) {
            iter_swap(nums.begin() + idx, upper_bound(nums.begin() + idx + 1, nums.end(), nums[idx]));
        }
    }
};
```

## 時間複雜度
整個過程的時間複雜度是$O(N)$。尋找下降點$O(N)$、尋找被交換地點$O(log(N))$、反轉$O(N)$和交換$O(1)$都可以在線性時間內完成。