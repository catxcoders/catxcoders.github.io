---
layout: article_post
title:  "[Leetcode解題]  1004. Max Consecutive Ones III"
description:  "[Leetcode解題]  1004. Max Consecutive Ones III"
categories: medium
tags: two-pointer
langs: python
excerpt_separator: <!--more-->
---

## 題目描述
[1004. Max Consecutive Ones III](https://leetcode.com/problems/max-consecutive-ones-iii/) 假設有一個由0和1組成的二進位陣列`nums`，還有一個整數`k`。你可以把陣列中的最多`k`個`0`翻轉成`1`。請問這樣做之後，陣列中可以得到的連續`1`的最大長度是多少？

<!--more-->

## 解題思路
這題我們可以換成***找一個最大的區間，裡面包含不超過k個0***。
這道題我們可以用「左右指針」的方式來解決。具體步驟如下：
1. **定義左右指針**：我們有兩個指針，左指針`left`和右指針`right`。這兩個指針會一起在陣列上移動，並且我們會保持左指針總是在右指針的左邊或重合。
2. **移動右指針**：我們從陣列的左邊開始，右指針`right`逐漸向右移動，並且在這個過程中，統計目前區間內$0$的數量。
3. **調整左指針**：當區間內0的數量超過了$k$，這時候我們需要移動左指針`left`來縮小區間，直到區間內的$0$數量回到$k$以內。
4. **記錄最大結果**：每次當區間內$0$的數量符合要求時（不超過$k$），我們就計算一下當前區間的長度，並且記錄最大值。
5. **最終結果**：當右指針遍歷完整個陣列後，記錄下來的最大區間長度就是我們要的答案。

## Python 代碼實現

```python
class Solution:
    def longestOnes(self, nums, k):
        zeros = 0
        max_len = 0
        left = 0

        for right in range(len(nums)):
            if nums[right] == 0:
                zeros += 1
            
            while zeros > k:
                if nums[left] == 0:
                    zeros -= 1
                left += 1
            
            max_len = max(max_len, right - left + 1)
        
        return max_len
```

## C++ 代碼實現
```cpp
class Solution {
public:
    int longestOnes(vector<int>& nums, int k) {
        int zeros = 0;
        int maxLen = 0;
        for(int r = 0, l=0; r<nums.size(); r++){
            if (nums[r]==0) zeros++;
            while(zeros > k){
                if (nums[l++]==0) --zeros;
            }
            maxLen = max(maxLen, r-l+1);
        }
        return maxLen;
    }
};
```

## 時間複雜度分析

這個解法的時間複雜度是`O(n)`，其中`n`是陣列`nums`的長度。因為每個元素最多只會被操作兩次（一次是右指針擴大窗口，一次是左指針縮小窗口），所以時間複雜度是線性的。