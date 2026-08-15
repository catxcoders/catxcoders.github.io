---
layout: article_post
title:  "[Leetcode解題] 2962. Count Subarrays Where Max Element Appears at Least K Times"
description:  "2962. Count Subarrays Where Max Element Appears at Least K Times"
categories: medium
tags: array sliding-window two-pointer
langs: python c++
excerpt_separator: <!--more-->
---

## 題目
[2962. Count Subarrays Where Max Element Appears at Least K Times](https://leetcode.com/problems/count-subarrays-where-max-element-appears-at-least-k-times/)

給定一個整數陣列 `nums` 和一個正整數 `k`。請計算有多少個子陣列，使得 **`nums` 中的最大元素**在該子陣列裡至少出現 `k` 次。

注意，題目所說的最大元素是整個 `nums` 的最大值，而不是每個子陣列各自的最大值。

<!--more-->

### 範例

```text
輸入：nums = [1, 3, 2, 3, 3], k = 2
輸出：6
```

整個陣列的最大值是 `3`。符合條件的子陣列為：

```text
[1, 3, 2, 3]
[1, 3, 2, 3, 3]
[3, 2, 3]
[3, 2, 3, 3]
[2, 3, 3]
[3, 3]
```

## 解題思路：滑動視窗

先找出整個陣列的最大值 `max_num`，接著用左右指標維護一個滑動視窗：

- `right`：逐步向右擴張視窗。
- `left`：視窗的左邊界。
- `count`：目前視窗中 `max_num` 出現的次數。

當加入 `nums[right]` 後，若 `count >= k`，代表目前視窗 `[left, right]` 已符合條件。

這時持續移動 `left`，直到視窗內最大值的數量少於 `k`：

```text
while count >= k:
    移除 nums[left]
    left += 1
```

迴圈結束時：

- `[left, right]` 已經不符合條件。
- 但是所有起點在 `0` 到 `left - 1`、終點為 `right` 的子陣列都符合條件。
- 這樣的起點一共有 `left` 個，因此將 `left` 加入答案。

## 範例推演

以 `nums = [1, 3, 2, 3, 3]`、`k = 2` 為例，最大值為 `3`：

| `right` | 加入元素 | 收縮後的 `left` | 以 `right` 結尾的合法子陣列數 |
| --- | --- | --- | --- |
| 0 | 1 | 0 | 0 |
| 1 | 3 | 0 | 0 |
| 2 | 2 | 0 | 0 |
| 3 | 3 | 2 | 2 |
| 4 | 3 | 4 | 4 |

答案為 `0 + 0 + 0 + 2 + 4 = 6`。

## C++ 實作

```cpp
class Solution {
public:
    long long countSubarrays(vector<int>& nums, int k) {
        int max_num = *max_element(nums.begin(), nums.end());
        int left = 0;
        int count = 0;
        long long answer = 0;

        for (int right = 0; right < nums.size(); ++right) {
            if (nums[right] == max_num) {
                ++count;
            }

            while (count >= k) {
                if (nums[left] == max_num) {
                    --count;
                }
                ++left;
            }

            answer += left;
        }

        return answer;
    }
};
```

## Python 實作

```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        max_num = max(nums)
        left = 0
        count = 0
        answer = 0

        for right in range(len(nums)):
            if nums[right] == max_num:
                count += 1

            while count >= k:
                if nums[left] == max_num:
                    count -= 1
                left += 1

            answer += left

        return answer
```

## 複雜度分析

- 時間複雜度：$O(n)$。先用 $O(n)$ 找出最大值，之後左右指標都最多走訪陣列一次。
- 空間複雜度：$O(1)$。只使用固定數量的變數。
