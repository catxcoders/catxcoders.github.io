---
layout: article_post
title:  "[Leetcode解題] 2302. Count Subarrays With Score Less Than K"
description:  "2302. Count Subarrays With Score Less Than K"
categories: hard
tags: two-pointer
langs: python
excerpt_separator: <!--more-->
---

## 題目說明：
[2302. Count Subarrays With Score Less Than K](https://leetcode.com/problems/count-subarrays-with-score-less-than-k)
給你一個正整數陣列 `nums`，還有一個整數 `k`。
**一個子陣列的「分數」定義為：其總和 `sum` × 長度 `length`**。

舉個例子：

```
nums = [1, 2, 3]
子陣列 [2,3] 的 sum = 5，length = 2，所以 score = 5×2 = 10  
```

請你回傳：**有多少個「非空的子陣列」其 score 小於 `k`**
<!--more-->

## 解題思路：滑動窗口技巧 Sliding Window

這題可以用 **滑動視窗** (two pointers) 來做，原因是：

1. 子陣列是連續的，所以我們可以用左右兩個指標 `l` 和 `r` 來代表一段子陣列。
2. 當右邊往右擴時，把 `nums[r]` 累加到總和 `sum`。
3. 如果目前這段 `[l, r]` 的分數 `sum * (r - l + 1)` 超過或等於 `k`，就要把左邊往右縮，直到滿足條件。
4. 當這段 `[l, r]` 是合法的，代表從 `l` 到 `r` 之間的所有結尾於 `r` 的子陣列都是合法的，所以可以加上 `(r - l + 1)`。

這樣就可以一邊走陣列、一邊快速計算了～

## Python 實作：

```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        total = 0
        l = 0
        sum_ = 0
        for r in range(len(nums)):
            sum_ += nums[r]
            while l <= r and sum_ * (r - l + 1) >= k:
                sum_ -= nums[l]
                l += 1
            total += (r - l + 1)
        return total
```

## C++ 實作：

```cpp
class Solution {
public:
    long long countSubarrays(vector<int>& nums, long long k) {
        long long count = 0;
        long long sum = 0;
        for(int l = 0, r = 0; r < nums.size(); r++) {
            sum += nums[r];
            while(l <= r && sum * (r - l + 1) >= k) {
                sum -= nums[l++];
            }
            count += (r - l + 1);
        }
        return count;
    }
};
```

## 時間與空間複雜度分析：
* **時間複雜度：O(n)**
  雖然裡面有 while，但整體 `l` 和 `r` 各只會走過一次，所以是線性時間。

* **空間複雜度：O(1)**
  只用了幾個變數記錄狀態，沒有額外的資料結構。