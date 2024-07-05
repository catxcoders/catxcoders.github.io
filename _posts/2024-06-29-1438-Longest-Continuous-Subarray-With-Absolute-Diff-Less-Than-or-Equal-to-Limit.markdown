---
layout: article_post
title:  "[Leetcode解題] 1438. Longest Continuous Subarray With Absolute Diff Less Than or Equal to Limit - 使用deque+ two pointer解"
description:  "[Leetcode解題] 1438. Longest Continuous Subarray With Absolute Diff Less Than or Equal to Limit - 使用deque+ two pointer解"
categories: medium 
tags: array deque sliding-window
langs: python
excerpt_separator: <!--more-->
---

## 題目

[1438. Longest Continuous Subarray With Absolute Diff Less Than or Equal to Limit](https://leetcode.com/problems/longest-continuous-subarray-with-absolute-diff-less-than-or-equal-to-limit/)
給定一個整數數組 `nums` 和一個整數 `limit`，請返回**長度最大的非空子陣列**的長度，使得該子陣列中任何兩個元素之間的絕對差不超過 `limit`。
<!--more-->

## 解題思路

這道題目要求我們找出一個連續子陣列，使得該子陣列中的最大值與最小值之間的差不超過 `limit`。我們可以用**雙指針**和兩個單調遞增及單調遞減的**雙端隊列**(deque)來解決這個問題。

具體思路如下：

1. **雙端隊列(deque)**：
   - 使用 `increaseDeque` 來維護一個單調遞增的隊列，隊列中的元素在index與數值上都是遞增的，對應的是當前子陣列中的最小值。
   - 使用 `decreaseDeque` 來維護一個單調遞減的隊列，隊列中的元素在index上是遞增的，在數值上是遞減的，隊列中的元素對應的是當前子陣列中的最大值。
    > 我們在實作的時候是存index在雙端隊列(deque)中，方便計算長度。

2. **遍歷陣列**：
   - 對於陣列中的每個元素，將其加入 `increaseDeque` 和 `decreaseDeque` 中，並保持兩個隊列的單調性。
   - 在每次加入新元素後，檢查當前子陣列的最大值與最小值之間的差是否超過了 `limit`。
   - 如果超過了 `limit`，我們需要調整左邊界 `l`，直到子陣列再次符合條件。
     如果現在加入的元素會導致最大值與最小值之間的差是否超過了 limit，那只有兩種情況: 
       1. 加入的值為區間的最大值，我們要調整左邊界`l`使得最小值變大到符合 *最大值與最小值之間的差 <= limit* ，由於`increaseDeque` 隊列中的元素在index與數值上都是遞增的，因此我們可以透過`increaseDeque`找最小符合限制的左界。
       2. 加入的值為區間的最小值，與加入為最大值類似，只是換成透過`decreaseDeque`找最小的index符合限制的左界。

3. **更新結果**：
   - 在調整左邊界後，計算當前子陣列的長度，並更新最大子陣列長度。

這樣，我們就可以在線性時間內找到符合條件的最大子陣列的長度。

## Python 實作

```python
class Solution:
    def longestSubarray(self, nums: List[int], limit: int) -> int:
        increaseDeque = deque()  # 單調遞增隊列
        decreaseDeque = deque()  # 單調遞減隊列
        l = 0  # 左邊界
        max_length = 0  # 最長的子陣列長度
        
        for r in range(len(nums)):
            # 維護單調遞增隊列
            while increaseDeque and nums[r] < nums[increaseDeque[-1]]:
                increaseDeque.pop()
            increaseDeque.append(r)
            
            # 維護單調遞減隊列
            while decreaseDeque and nums[r] > nums[decreaseDeque[-1]]:
                decreaseDeque.pop()
            decreaseDeque.append(r)
            
            # 當前子陣列不符合條件時，移動左邊界
            while nums[decreaseDeque[0]] - nums[increaseDeque[0]] > limit:
                l += 1
                if increaseDeque[0] < l:
                    increaseDeque.popleft()
                if decreaseDeque[0] < l:
                    decreaseDeque.popleft()
            
            # 更新最大子陣列長度
            max_length = max(max_length, r - l + 1)
        
        return max_length
```
## C++ 實作

```cpp
class Solution {
public:
    int longestSubarray(vector<int>& nums, int limit) {
        // maintain two monotonic stacks
        deque<int> increaseSt; // Holds indices in increasing order, front is the minimum of the interval.
        deque<int> decreaseSt; // Holds indices in decreasing order, front is the maximum of the interval.
        int l = -1; // left bound of the interval, (exclusive)
        int r; // right bound of the interval, (inclusive)
        int sizeOfSubArr = 1;

        // traverse each number in nums, treating it as the right end of interval
        for (r = 0; r<nums.size(); r++){
            // add number in increaseSt and decreaseSt, and maintain two monotonic stacks
            while(!increaseSt.empty() && nums[r] < nums[increaseSt.back()]) increaseSt.pop_back();
            while(!decreaseSt.empty() && nums[r] > nums[decreaseSt.back()]) decreaseSt.pop_back();
            increaseSt.push_back(r);
            decreaseSt.push_back(r);
            
            // check the current interval is valid
            if (nums[decreaseSt.front()]-nums[increaseSt.front()]>limit){
                sizeOfSubArr = max(sizeOfSubArr, r-l-1);
                
                // move the left of interval to make the interval valid
                while(nums[decreaseSt.front()]-nums[increaseSt.front()]>limit){
                    if (decreaseSt.front() == r){
                        l = increaseSt.front();
                        increaseSt.pop_front();
                    }else{
                        l = decreaseSt.front();
                        decreaseSt.pop_front();
                    }
                }
            }
        }
        sizeOfSubArr = max(sizeOfSubArr, r-l-1);
        return sizeOfSubArr;
    }
};
```

## 時間複雜度

這個解法的時間複雜度是 $O(n)$，其中 `n` 是陣列 `nums` 的長度。因為每個元素最多只會被加入和移除兩個雙端隊列(deque)各一次，所以整個過程的時間複雜度是線性的。

## 空間複雜度

空間複雜度是 $O(n)$，因為我們使用了兩個雙端隊列(deque)來維護當前子陣列的最小值和最大值。在最壞情況下，這些隊列可以包含 `n` 個元素。
