---
layout: article_post
title:  "[Leetcode解題] 845. Longest Mountain in Array"
description:  "845. Longest Mountain in Array"
categories: medium
tags: two-pointer
langs: python
excerpt_separator: <!--more-->
---
## 題目
[845. Longest Mountain in Array](https://leetcode.com/problems/longest-mountain-in-array)
一個數列如果滿足 **山脈數列 (mountain array)**的條件，需要滿足下列條件：

1. 數列長度至少是 3： `arr.length >= 3`
2. 存在一個索引 `i` (以 0 為基準，`0 < i < arr.length - 1`)，使得：
   - `arr[0] < arr[1] < ... < arr[i - 1] < arr[i]`
   - `arr[i] > arr[i + 1] > ... > arr[arr.length - 1]`

現在，給你一個數列 `arr`，請返回最長山脈子數列的長度。如果沒有山脈子數列，則返回 `0`。
<!--more-->

## 解題思路
1. **定義山脈條件**
   要構成一個合法的「山脈」，需要先遞增，然後在達到高峰後遞減。因此我們需要在陣列中找到符合此模式的子區間。
   
2. **雙指針遍歷法**
   使用左右指針進行遍歷，其中：
   - `l` 指向目前正在考察的山脈的左邊界。
   - `dir` 記錄方向，0 代表正在遞增，1 代表正在遞減。
   - 當前的區間長度則是右指針 `r` 與左指針 `l` 的差值。

3. **重置條件
   在以下情況下需要重新重置左邊界指針 `l`：
   - 當兩個相鄰元素相等時，無法構成山脈，直接重置。
   - 當遞增段沒有接上遞減段時，則需要將左邊界移動到當前位置，繼續搜索。

4. **更新最長山脈長度**
   在找到合法山脈區間後，更新最大長度。

## **Python 實作**

```python
class Solution:
    def longestMountain(self, arr: list[int]) -> int:
        l = 0  # 左邊界指針
        dir = 0  # 方向 0: 遞增中, 1: 遞減中
        max_len = 0  # 紀錄最長山脈長度

        def reset(idx):
            nonlocal l, dir
            l = idx
            dir = 0  # 重置方向為遞增

        # 開始遍歷陣列
        for r in range(1, len(arr)):
            if arr[r] == arr[r - 1]:  # 相鄰元素相等，無法構成山脈
                reset(r)
            elif l == r - 1 and arr[r] < arr[r - 1]:  # 一開始就遞減，不算山脈
                reset(r)
            elif dir == 0 and arr[r] < arr[r - 1]:  # 進入遞減段
                dir = 1
            elif dir == 1 and arr[r] > arr[r - 1]:  # 遞減後又遞增，無法構成山脈
                reset(r - 1)
            
            if dir == 1:  # 如果正在遞減段，計算山脈長度
                max_len = max(max_len, r - l + 1)

        return max_len
```

## C++實作
```cpp
class Solution {
public:
    int longestMountain(vector<int>& arr) {
        int l = 0;
        int dir = 0;  // 0 表示上升階段，1 表示下降階段
        auto reset = [&](int idx) {
            dir = 0;  // 重置為上升階段
            l = idx;  // 更新左邊界
        };

        int len = 0;
        for (int r = 1; r < arr.size(); r++) {
            if (arr[r] == arr[r - 1])  // 平坦區域，重置起點
                reset(r);
            else if (l == r - 1 && arr[r] < arr[r - 1])  // 一開始就下降，重置
                reset(r);
            else if (dir == 0 && arr[r] < arr[r - 1])  // 開始下降
                dir = 1;
            else if (dir == 1 && arr[r] > arr[r - 1])  // 在下降後又上升，重置
                reset(r - 1);

            if (dir == 1)  // 如果處於下降階段，計算山型長度
                len = max(len, r - l + 1);
        }

        return len;
    }
};
```

## **時間複雜度分析**
- **時間複雜度：$O(n)$**
  - 每個元素僅被遍歷一次，因此時間複雜度為 $O(n)$，其中 $n$ 是陣列的長度。
  
- **空間複雜度：$O(1)$**
  - 只使用常數倍外空間來儲存變數，因此空間複雜度為$O(1)$。