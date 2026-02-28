---
layout: article_post
title:  "[Leetcode解題] 2771. Longest Non-decreasing Subarray From Two Arrays"
description:  "2771. Longest Non-decreasing Subarray From Two Arrays - 使用dp解"
categories: medium
tags: dp
langs: python
excerpt_separator: <!--more-->
---

## 題目說明

給定兩個長度為 `n` 的 **0-indexed** 整數陣列 `nums1` 與 `nums2`。

我們要構造另一個陣列 `nums3`（長度同為 `n`）：

* 對每個 index `i`，可以 **選擇**
  `nums3[i] = nums1[i]` **或** `nums2[i]`

### 目標

請你 **最佳化選擇方式**，使得 `nums3` 中
**最長「非遞減（non-decreasing）」子陣列的長度最大**

回傳這個最大長度。

> **非遞減**：`a[i] <= a[i+1]`
> **子陣列**：必須是連續、且非空
<!--more-->

## 解題思路（Dynamic Programming）

這題的關鍵在於：

> 在每個位置 `i`，我們有 **兩種選擇**，但選擇會影響能否「延續」前一段非遞減子陣列。

### 狀態定義

在每個 index `i`，我們維護兩個狀態：

* `dp1[i]`：
  **若 `nums3[i] = nums1[i]`**，以 `i` 結尾的最長非遞減子陣列長度
* `dp2[i]`：
  **若 `nums3[i] = nums2[i]`**，以 `i` 結尾的最長非遞減子陣列長度

### 狀態轉移

考慮從 `i-1` 延續到 `i`：

#### 更新 `dp1[i]`（選 nums1[i]）

* 若 `nums1[i] >= nums1[i-1]` → 可從 `dp1[i-1]` 延續
* 若 `nums1[i] >= nums2[i-1]` → 可從 `dp2[i-1]` 延續
* 否則只能重新開始（長度 = 1）

#### 更新 `dp2[i]`（選 nums2[i]）

* 若 `nums2[i] >= nums1[i-1]`
* 若 `nums2[i] >= nums2[i-1]`

取上述可行來源的最大值 + 1。

### 初始化

* `dp1[0] = dp2[0] = 1`
  （第一個元素本身就是長度 1 的子陣列）

### 答案

整個過程中，答案是：

```text
max(dp1[i], dp2[i]) 的最大值
```

## Python 實作（空間最佳化版）

```python
class Solution:
    def maxNonDecreasingLength(self, nums1, nums2):
        n = len(nums1)
        
        # dp1, dp2 分別代表上一個位置選 nums1 / nums2 的最佳長度
        dp1 = dp2 = 1
        ans = 1
        
        for i in range(1, n):
            new_dp1 = new_dp2 = 1
            
            # 選 nums1[i]
            if nums1[i] >= nums1[i - 1]:
                new_dp1 = max(new_dp1, dp1 + 1)
            if nums1[i] >= nums2[i - 1]:
                new_dp1 = max(new_dp1, dp2 + 1)
            
            # 選 nums2[i]
            if nums2[i] >= nums1[i - 1]:
                new_dp2 = max(new_dp2, dp1 + 1)
            if nums2[i] >= nums2[i - 1]:
                new_dp2 = max(new_dp2, dp2 + 1)
            
            dp1, dp2 = new_dp1, new_dp2
            ans = max(ans, dp1, dp2)
        
        return ans
```


## C++ 實作

```cpp
class Solution {
public:
    int maxNonDecreasingLength(vector<int>& nums1, vector<int>& nums2) {
        int n = nums1.size();
        
        int dp1 = 1, dp2 = 1;  // 上一個位置的狀態
        int ans = 1;
        
        for (int i = 1; i < n; i++) {
            int new_dp1 = 1, new_dp2 = 1;
            
            // 選 nums1[i]
            if (nums1[i] >= nums1[i - 1])
                new_dp1 = max(new_dp1, dp1 + 1);
            if (nums1[i] >= nums2[i - 1])
                new_dp1 = max(new_dp1, dp2 + 1);
            
            // 選 nums2[i]
            if (nums2[i] >= nums1[i - 1])
                new_dp2 = max(new_dp2, dp1 + 1);
            if (nums2[i] >= nums2[i - 1])
                new_dp2 = max(new_dp2, dp2 + 1);
            
            dp1 = new_dp1;
            dp2 = new_dp2;
            ans = max(ans, max(dp1, dp2));
        }
        
        return ans;
    }
};
```

## 時間與空間複雜度
* **時間複雜度**：`O(n)`
  每個 index 僅做常數次比較
* **空間複雜度**：`O(1)`
  只使用常數個變數（已做 DP 空間壓縮）
