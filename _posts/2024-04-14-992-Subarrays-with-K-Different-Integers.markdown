---
layout: article_post
title:  "[Leetcode解題] 992. Subarrays with K Different Integers"
description:  "[Leetcode解題] 992. Subarrays with K Different Integers"
categories: hard 
tags: two-pointers
langs: python
excerpt_separator: <!--more-->
---

## 題目
[992. Subarrays with K Different Integers](https://leetcode.com/problems/subarrays-with-k-different-integers)
給定一個整數陣列nums和一個整數k，返回nums中好的子陣列的數量。

好的陣列是一個陣列，其中不同整數的數量正好是k。

例如，[1,2,3,1,2]有3個不同的整數：1、2和3。
子陣列是陣列的連續部分。
<!--more-->

## 解題思路

這個問題可以使用**滑動窗口**來解決。我們需要維護兩個窗口
* **以目前`index`為結尾**包含$k$個不同元素的最**長**子陣列，
* **以目前`index`為結尾**包含$k$個不同元素的最**短**子陣列，

**兩個窗口的長度差**即為包含$k$個不同元素的**子陣列的數量**。

具體步驟如下：

1. 初始化`count`和兩個空的`unordered_map`分別用於記錄**元素的頻率**和**最後一次出現的索引**。
2. 使用兩個指針`l`和`mid`來維護兩個窗口的範圍。
3. 遍歷整個陣列`nums`：
    - 對於每個元素，更新頻率和**最後一次出現的索引**。
    - 當頻率超過`k`時，移動左指針`l`，直到頻率恢復到小於等於`k`。
    - 更新`mid`指針，保證`mid`指向的元素是包含`k`個不同元素的最短子陣列的結尾。
    - 如果當前窗口內的不同元素數量等於`k`，則計算以`mid`為結尾的包含`k`個不同元素的子數組數量並更新`count`。
4. 返回`count`。

## Python實作

```python
class Solution:
    def subarraysWithKDistinct(self, nums: List[int], k: int) -> int:
        frequency = {}
        last_idx = {}
        n = len(nums)
        l = mid = count = 0

        for i in range(n):
            frequency[nums[i]] = frequency.get(nums[i], 0) + 1
            while len(frequency) > k:
                frequency[nums[l]] -= 1
                if frequency[nums[l]] == 0:
                    del frequency[nums[l]]
                l += 1

            last_idx[nums[i]] = i
            mid = max(mid, l)
            while mid != last_idx.get(nums[mid], -1):
                mid += 1

            if len(frequency) == k:
                count += max(mid - l + 1, 1)

        return count

```

## C++實作

```cpp
class Solution {
public:
    int subarraysWithKDistinct(vector<int>& nums, int k) {
        unordered_map<int, int> frequency;
        unordered_map<int, int> lastIdx;
        int n = nums.size();
        int l = 0;
        int mid = 0;
        int count  = 0;

        for(int i = 0; i < n; i++) {
            frequency[nums[i]]++;
            while (frequency.size() > k) {
                frequency[nums[l]]--;
                if (frequency[nums[l]] == 0)
                    frequency.erase(nums[l]);
                l++;
            }

            lastIdx[nums[i]] = i;
            mid = max(mid, l);
            while (mid != lastIdx[nums[mid]])
                mid++;

            if (frequency.size() == k)
                count += max(mid - l + 1, 1);
        }
        return count;
    }
};

```

## 複雜度分析

- **時間複雜度**：遍歷一次陣列需要$O(n)$的時間，其中$n$是陣列的長度。在每次遍歷中，我們進行$O(1)$的操作，因此總的時間複雜度為$O(n)$。
- **空間複雜度**：我們使用了兩個`unordered_map`來存儲頻率和最後一次出現的索引，以及一些變量。因此，空間複雜度為$O(n)$。