---
layout: article_post
title:  "[Leetcode解題] 402. Remove K Digits"
description:  "[Leetcode解題] 402. Remove K Digits"
categories: medium 
tags: monotonic-queue deque
langs: python
excerpt_separator: <!--more-->
---

## 題目
[402. Remove K Digits](https://leetcode.com/problems/remove-k-digits/)
給定一個表示非負整數的字符串 `num` 和一個整數 `k`，從 `num` 中移除 `k` 個數字後，返回可能的最小整數。
<!--more-->
#### Example 1:
Input: num = "1432219", k = 3
Output: "1219"
Explanation: 移除數字 4、3 和 2 後，形成新數字 1219，這是最小的數字。

#### Example 2:
Input: num = "10200", k = 1
Output: "200"
Explanation: 移除開頭的 1 後，數字變為 200。請注意，輸出不能包含最前面的零。

#### Example 3:
Input: num = "10", k = 2
Output: "0"
Explanation: 移除所有數字後，剩下的是空的，即為 0。

## 解題思路
這道題的關鍵在於如何找到一個**最小的數字串**，目標就是**讓高位數字(靠前面的數字)盡可能小**，因此如果`num[i]`比num`[i+1]`大，那應該移除`num[i]`。
我們可以使用一個 `deque` 來模擬這個過程，對於每一個數字，我們將其與 `deque` 的最後一個元素進行比較，如果小於最後一個元素，就將最後一個元素移除，直到移除 `k` 個數字為止。

## Python 實作
```python
class Solution:
    def removeKdigits(self, num: str, k: int) -> str:
        buffer = deque()

        # Remove leading digits greater than the following one
        for c in num:
            while k > 0 and buffer and buffer[-1] > c:
                buffer.pop()
                k -= 1
            buffer.append(c)

        # Remove remaining digits from the end if k is still greater than 0
        while k > 0 and buffer:
            buffer.pop()
            k -= 1

        # Skip leading zeros
        while buffer and buffer[0] == '0':
            buffer.popleft()

        # If result is empty, return "0"
        return ''.join(buffer) if buffer else "0"
```

## C++實作
```cpp
class Solution {
public:
    string removeKdigits(string num, int k) {
        deque<char> buffer;

        // Remove leading digits greater than the following one
        for (char c : num) {
            while (k > 0 && !buffer.empty() && buffer.back() > c) {
                buffer.pop_back();
                k--;
            }
            buffer.push_back(c);
        }

        // Remove remaining digits from the end if k is still greater than 0
        while (k > 0 && !buffer.empty()) {
            buffer.pop_back();
            k--;
        }

        // Skip leading zeros
        while(!buffer.empty() && buffer.front() == '0') buffer.pop_front();

        // If result is empty, return "0"
        return buffer.empty() ? "0" : string(buffer.begin(), buffer.end());
    }
};
```

## 時間複雜度
- 整個過程僅需遍歷一次 `num`，所以時間複雜度為 $O(n)$，其中 $n$是 `num` 的長度。