---
layout: article_post
title:  "[Leetcode解題] 1493. Longest Subarray of 1's After Deleting One Element"
description:  "1493. Longest Subarray of 1's After Deleting One Element"
categories: medium
tags: array sliding-window
langs: python c++
excerpt_separator: <!--more-->
---

## 題目
[1493. Longest Subarray of 1's After Deleting One Element](https://leetcode.com/problems/longest-subarray-of-1s-after-deleting-one-element/description/)

給定一個僅包含 `0` 和 `1` 的二進位陣列 `nums`，你必須從中刪除**恰好一個**元素。
請回傳刪除一個元素後，陣列中含有連續 `1` 的最長子陣列長度。如果刪除後沒有任何 `1`（例如整個陣列皆為 `0` 的情況），請回傳 `0`。

<!--more-->

## 解題思路

這是一道標準的滑動視窗（Sliding Window）問題。題目要求我們必須刪除「恰好一個」元素，這相當於我們要在陣列中尋找一個最長的連續區間，且這個區間內「最多只能包含一個 `0`」。

我們可以使用雙指標法（維護左指標 `left` 和右指標 `right`）來實作：
1. 視窗的右指標 `right` 隨著迴圈不斷向右擴張，並記錄視窗內遇到的 `0` 的數量。
2. 當視窗內的 `0` 的數量超過一個（即出現第二個 `0`）時，這個視窗就不再符合條件。此時我們必須收縮左指標 `left`，直到視窗內 `0` 的數量再次回到一個為止。
3. 每次當視窗狀態合法時，我們計算當前視窗刪除一個元素後，所能貢獻的連續 `1` 的長度。
   - 一般來說視窗長度是 `right - left + 1`，但因為我們一定得刪除一個元素（不論是唯一的那個 `0`，還是全為 `1` 的狀況下隨便刪去一個 `1`），故實際合法貢獻長度即為 `right - left`。
   - 將其與過往最大長度比較：`max_len = max(max_len, right - left)`。
4. 最終當右指標走遍整個陣列，我們就能得到最大的連續 `1` 的長度。

## Python 實作

```python
class Solution:
    def longestSubarray(self, nums: List[int]) -> int:
        left = 0
        zero_count = 0
        max_len = 0
        
        for right in range(len(nums)):
            if nums[right] == 0:
                zero_count += 1
                
            # 當視窗內 0 的數量超過 1 時，移動左指標直到 0 的數量為 1
            while zero_count > 1:
                if nums[left] == 0:
                    zero_count -= 1
                left += 1
                
            # 計算當前合法視窗長度並更新最大值
            # 視窗長度為 right - left + 1，必定刪除一個元素後長度為 right - left
            max_len = max(max_len, right - left)
            
        return max_len
```

## C++ 實作

```cpp
class Solution {
public:
    int longestSubarray(vector<int>& nums) {
        int left = 0;
        int zero_count = 0;
        int max_len = 0;
        
        for (int right = 0; right < nums.size(); ++right) {
            if (nums[right] == 0) {
                zero_count++;
            }
            
            // 當視窗內 0 的數量超過 1 時，移動左指標直到 0 的數量為 1
            while (zero_count > 1) {
                if (nums[left] == 0) {
                    zero_count--;
                }
                left++;
            }
            
            // 必定要刪除一個元素，當前視窗實際貢獻長度為 right - left
            max_len = max(max_len, right - left);
        }
        
        return max_len;
    }
};
```

## 時間複雜度

左右兩指標 `left` 與 `right` 在整個過程中最多只會各自將陣列走訪一次。
因此總體時間複雜度為 $O(n)$，其中 $n$ 為陣列的長度。

空間複雜度部分，由於只使用了常數個變數進行狀態維護，故空間複雜度為 $O(1)$。
