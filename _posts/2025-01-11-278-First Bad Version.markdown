---
layout: article_post
title:  "[Leetcode解題] 278. First Bad Version"
description:  "278. First Bad Version"
categories: easy
tags: binary-search
langs: python
excerpt_separator: <!--more-->
---

## 題目
[278. First Bad Version](https://leetcode.com/problems/first-bad-version/)
你是一名產品經理，正在帶領一個團隊開發新產品。不幸的是，最新版本的產品在質量檢查中失敗了。由於每一個版本都是基於上一個版本開發的，因此所有之後的版本也都是壞的。

提供一個統一的 API `bool isBadVersion(version)`，該函數會判斷指定版本是否是壞的。

請寫一個函數，用來找出第一個壞的版本，以保證呼叫 API 的次數最少。
<!--more-->

## 解題思路
這題其實就是個經典的 **二分搜尋** 問題。因為題目已經告訴我們壞版本有個「一旦壞了後面都壞」的特性，所以我們可以用二分搜尋的方式快速解決。

1. 初始化範圍：

    - 我們用 `l` 表示最小的版本，`r` 表示最大的版本。

2. 二分搜尋邏輯：

    - 計算中間值 `mid = l + (r - l) / 2`。

    - 用 `isBadVersion(mid)` 判斷是不是壞版本：

        - 如果是壞的，那說明壞版本可能在更左邊，所以把右邊界調整到 mid。

        - 如果不是壞的，那就去右邊找，把左邊界調整到 `mid + 1`。

3. **結束條件**:
   - 當 `l == r` 時，就是第一個壞版本。

## Python 實作
```python
# The API isBadVersion is defined for you.
# def isBadVersion(version: int) -> bool

class Solution:
    def firstBadVersion(self, n: int) -> int:
        l, r = 1, n
        while l < r:
            mid = l + (r - l) // 2
            if isBadVersion(mid):
                r = mid  # 壞版本在左半部分
            else:
                l = mid + 1  # 壞版本在右半部分
        return l
```

## C++ 實作
```cpp
// The API isBadVersion is defined for you.
// bool isBadVersion(int version);

class Solution {
public:
    int firstBadVersion(int n) {
        int l = 0;
        int len = n;

        //lower_bound
        while(len>0){
            int step = len/2;
            int mid = l+ step;
            if(isBadVersion(mid)) len = step;
            else { l = mid+1; len -= step+1;}
        }
        return l;
    }
};
```

## 計算複雜度
- **時間複雜度**: $O(log(n))$
  - 每次搜尋都把範圍縮小一半，所以是對數級別的。

- **空間複雜度**: $O(1)$
  - 我們只用了幾個變數來記錄範圍，沒有額外開什麼資料結構。

