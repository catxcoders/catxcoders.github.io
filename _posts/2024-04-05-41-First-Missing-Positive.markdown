---
layout: article_post
title:  "[Leetcode解題] 41. First Missing Positive"
description:  "[Leetcode解題] 41. First Missing Positive"
categories: hard 
tags: HashTable
langs: python
excerpt_separator: <!--more-->
---

## 題目：
[41. First Missing Positive](https://leetcode.com/problems/first-missing-positive/)
給定一個未排序的整數陣列 nums。返回未出現在 nums 中的最小正整數。

*你必須實現一個時間複雜度為 $O(n)$，額外空間複雜度為 $O(1)$ 的算法。*
<!--more-->
## 解題思路：
我們可以利用陣列本身的索引和值的關係來解決這個問題。我們將 nums 當作一個hash表，將每個正整數放到其對應的索引位置上。接著遍歷這個hash表，找出第一個未出現的正整數即可。

### Example 1:
**Input**: nums = [1,4,5,2]
經過一些交換，nums會變成[1,2,5,4]
**Output**: 3
- 把正整數放到對應的索引位置上，陣列狀態為 [1, 2, 5, 4]。
- 檢查缺失的數字
    - 索引 0 的位置應該是 1，因此正確。
    - 索引 1 的位置應該是 2，因此正確。
    - 索引 2 的位置應該是 3，但是是 5，表示 3 是第一個未出現在陣列中的正整數。

## Python 實作：
```python
class Solution:
    def firstMissingPositive(self, nums: List[int]) -> int:
        n = len(nums)
        for i in range(n):
            while 1 <= nums[i] <= n and nums[nums[i] - 1] != nums[i]:
                nums[nums[i] - 1], nums[i] = nums[i], nums[nums[i] - 1]

        for i in range(n):
            if nums[i] != i + 1:
                return i + 1

        return n + 1
```

## C++ 實作：
```cpp
class Solution {
public:
    int firstMissingPositive(vector<int>& nums) {
        const int n = nums.size();
        for (int i = 0; i < n; ++i) {
            while (nums[i] > 0 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
                swap(nums[nums[i] - 1], nums[i]);
            }
        }
        for (int i = 0; i < n; ++i) {
            if (nums[i] != i + 1) {
                return i + 1;
            }
        }
        return n + 1;
    }
};
```

## 複雜度分析：
- 時間複雜度：
    - **遍歷一次陣列(交換元素)**: 每個元素最多只會被交換一次，並且被交換到正確的位置，因此每個元素只會被訪問常數次。因此**把正整數放到對應的索引位置上**需要 $O(n)$ 的時間，其中 $n$ 為陣列的長度。
    - **第二次遍歷(找出第一個未出現的正整數)**： 這也需要花費 $O(n)$ 的時間。

- 空間複雜度：
我們只使用了常數額外空間，因此空間複雜度為 $O(1)$。