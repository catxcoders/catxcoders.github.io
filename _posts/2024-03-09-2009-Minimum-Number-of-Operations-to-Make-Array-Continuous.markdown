---
layout: article_post
title:  "[Leetcode解題] 2009. Minimum Number of Operations to Make Array Continuous - 使用 Binary Search 算法 "
description:  "[Leetcode解題] 2009. Minimum Number of Operations to Make Array Continuous - 使用 Binary Search 算法 "
categories: hard 
tags: binary-search bs
langs: python
excerpt_separator: <!--more-->
---

# 題目
[2009. Minimum Number of Operations to Make Array Continuous](https://leetcode.com/problems/minimum-number-of-operations-to-make-array-continuous/)
給定一個整數陣列 nums。在一次操作中，你可以將 nums 中的任何元素替換為任何整數。
如果滿足以下兩個條件，則 nums 被認為是連續的：

nums 中的所有元素都是唯一的。
nums 中的最大元素與最小元素之間的差等於 nums.length - 1。
例如，nums = [4, 2, 5, 3] 是連續的，但 nums = [1, 22, 22, 24, 24] 不是連續的。

返回使 nums 變得連續所需的最小操作次數。
<!--more-->

# 解題思路
我們的目標是使得陣列連續，也就是要求最大元素與最小元素之間的差為 nums.length - 1，同時保持所有元素唯一。因此，我們可以通過以下步驟來解決這個問題：

1. 將 nums 進行排序，這樣最大元素與最小元素就位於陣列的兩端了。
2. 對於每個可能的連續子陣列，找到最大元素的索引。這可以通過Binary Search來實現。
3. 子陣列中需要替換的重複元素的數量。這可以通過一個輔助陣列(PreSum的概念)來計算重複元素的個數。
4. 對於每個連續子陣列，計算需要替換的操作次數，並保留最小值。

# Python 實作
```python
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        n = len(nums)
        nums.sort()
        minOps = float('inf')
        duplicate = [0] * n

        d = 0
        for i in range(1, n):
            if nums[i] == nums[i - 1]:
                d += 1
            duplicate[i] = d

        for i in range(n):
            interval_max = nums[i] + n - 1
            interval_max_idx = bisect_right(nums, interval_max) - 1
            duplicate_num = duplicate[interval_max_idx] - duplicate[i]
            minOps = min(minOps, duplicate_num + n - (interval_max_idx - i + 1))

        return minOps
```

# C++ 實作
```cpp
class Solution {
public:
    int minOperations(vector<int>& nums) {
        int n = nums.size();
        vector<int> duplicate(n, 0);
        int minOps = INT_MAX;

        sort(nums.begin(), nums.end());
        int d = 0;
        for(int i=1; i<n; i++){
            if(nums[i] == nums[i-1]) ++d;
            duplicate[i] = d;
        }

        for(int i=0; i<n; i++){
            int interval_max = nums[i]+n-1;
            int interval_max_idx = upper_bound(nums.begin(), nums.end(), interval_max) - nums.begin() -1;
            int duplicate_num = duplicate[interval_max_idx]- duplicate[i];
            minOps = min(minOps, duplicate_num + n - (interval_max_idx-i+1));
        }
        return minOps;
    }
};
```

# 時間複雜度
排序的時間複雜度為 $O(n log n)$，其中 $n$ 是陣列的長度，對於每個連續子陣列，進行Binary Search的時間複雜度為 $O(log n)$。總體時間複雜度為 $O(n log n)$。