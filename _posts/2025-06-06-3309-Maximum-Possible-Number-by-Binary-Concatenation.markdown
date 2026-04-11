---
layout: article_post
title:  "[Leetcode解題] 3309. Maximum Possible Number by Binary Concatenation"
description:  "3309. Maximum Possible Number by Binary Concatenation"
categories: medium
tags: bit-manipulation
langs: python
excerpt_separator: <!--more-->
---
## 題目
[3309. Maximum Possible Number by Binary Concatenation](https://leetcode.com/problems/maximum-possible-number-by-binary-concatenation/)
給定一個大小為 `3` 的整數陣列 `nums`，我們希望將其中每個整數轉換成 **二進位字串**，然後以某種順序**串接**這三個二進位字串，使其組合成一個最大的整體值（解讀為一個二進位數值）。

例如：

```text
nums = [3, 2, 1]
=> binary: ["11", "10", "1"]
=> 可組合為："11110" (等於十進位 30)
```
請回傳這個最大可能值（轉成十進位整數）。
<!--more-->

## 解題思路

1. **轉換為二進位字串**：

   * 將每個數字轉為二進位字串（不含前導 0）。

2. **決定串接順序**：

   * 題目要求「最大整數」，這其實就是**字串拼接大小的比較**。
   * 我們可以用類似「最大數字」的排序方式：對任意兩個字串 `a`, `b`，若 `a + b > b + a`，代表 `a` 應排在 `b` 前面。

3. **拼接並轉回十進位整數**：

   * 拼接排序後的所有字串，整體視為一個二進位數，轉成十進位整數即為答案。

## C++ 實作

```cpp
class Solution {
public:
    std::string intToBinary(int num) {
        if (num == 0) return "0";
        std::string result;
        while (num > 0) {
            result += (num & 1) + '0';
            num /= 2;
        }
        std::reverse(result.begin(), result.end());
        return result;
    }

    int maxGoodNumber(vector<int>& nums) {
        vector<string> bins;
        for(auto num:nums){
            bins.push_back(intToBinary(num));
        }

        sort(bins.begin(), bins.end(), [](const string& a, const string& b) {
            return a + b > b + a;
        });

        string result;
        for(auto bin: bins){
            result += bin;
        }
        
        return stoi(result, nullptr, 2);
    }
};
```


## Python 實作

```python
class Solution:
    def int_to_binary(self, num):
        return bin(num)[2:]

    def compare(self, a, b):
        if a + b > b + a:
            return -1  # a should come before b
        elif a + b < b + a:
            return 1   # b should come before a
        else:
            return 0

    def maxGoodNumber(self, nums):
        bins = [self.int_to_binary(num) for num in nums]
        bins.sort(key=cmp_to_key(self.compare))
        result_bin = ''.join(bins)
        return int(result_bin, 2)
        
```


## 時間複雜度分析

* 假設 `n = 3`，且每個數字最大為 10⁹，其二進位長度最多 30。
* **轉換為 binary**：`O(n * log(max_num))`，這裡是 O(3 \* 30)
* **排序**：`O(n log n)`，排序字串依據 `a + b` vs `b + a` 比較
* **拼接結果 + 轉換回整數**：O(n \* L)，L 為二進位字串長度總和

總體時間複雜度為：

```
O(n log n + nL) ≈ 常數級別，因為 n 固定為 3
```
