---
layout: article_post
title:  "[Leetcode解題] 2817. Minimum Absolute Difference Between Elements With Constraint"
description:  "2817. Minimum Absolute Difference Between Elements With Constraint - 使用Binary Search解"
categories: medium
tags: binary_search, bs
langs: python
excerpt_separator: <!--more-->
---
## 題目：
[2817. Minimum Absolute Difference Between Elements With Constraint](https://leetcode.com/problems/minimum-absolute-difference-between-elements-with-constraint/description/)

給定一個 0-indexed 整數陣列 `nums` 與整數 `x`。

請找出兩個索引 `i, j`，使得：

* `abs(i - j) >= x`
* `abs(nums[i] - nums[j])` 盡可能小

回傳滿足條件下的最小絕對差。

## 解題思路
### 把「距離至少 x」轉成「左側可選集合」
我們從左到右掃描索引 `i`：

* 當我們在處理 `i` 時，只允許配對的 `j` 必須滿足 `j <= i - x`（這樣 `i - j >= x` 自然成立）。
* 因此，我們可以維護一個資料結構 `elements`，存放所有 `nums[0..i-x]` 的值（即「離 i 至少 x 的左側候選值」）。

每到一個新的 `i`：

1. 先把 `nums[i-x]` 加進 `elements`（讓它成為之後索引的候選）。
2. 針對 `nums[i]`，在 `elements` 中找出「最接近它」的值，更新答案。

### 在有序集合裡找最接近的值：只要看前一個與後一個
若 `elements` 是**有序**的：

* 用二分（或 `upper_bound` / `bisect`）找到第一個 `> nums[i]` 的位置。
* 那它的前一個元素就是 `<= nums[i]` 的最大值。

最小差只可能出現在：

* `nums[i] - predecessor`
* `successor - nums[i]`

因此每次查詢只需 O(log n)。

## C++ 實作
```cpp
class Solution {
public:
    int minAbsoluteDifference(vector<int>& nums, int x) {
        set<int> elements;
        int minAbs = INT_MAX;

        for(size_t i=x; i<nums.size(); i++){
            elements.insert(nums[i-x]);
            auto it = elements.upper_bound(nums[i]);
            if (it != elements.begin())
                minAbs = min(minAbs, nums[i]-*prev(it));
            if (it != elements.end())
                minAbs = min(minAbs, *it-nums[i]);
        }
        return minAbs;
    }
};
```


## Python 實作
```python
class Solution:
    def minAbsoluteDifference(self, nums: List[int], x: int) -> int:
        sl = SortedList()
        ans = float("inf")

        for i in range(x, len(nums)):
            sl.add(nums[i - x])
            v = nums[i]

            pos = sl.bisect_left(v)  # 第一個 >= v 的位置
            if pos < len(sl):
                ans = min(ans, sl[pos] - v)
            if pos > 0:
                ans = min(ans, v - sl[pos - 1])

        return ans
```

## 時間與空間複雜度
* 每步插入 O(log n)，查詢前一個/後一個 O(log n)
* **時間複雜度：O(n log n)**
* **空間複雜度：O(n)**（最差存進約 n 個元素）
