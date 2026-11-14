---
layout: article_post
title: "[Leetcode解題] 3364. Minimum Positive Sum Subarray"
description: "3364. Minimum Positive Sum Subarray - 利用前綴和快速計算長度介於指定區間的子陣列和，尋找大於 0 的最小值"
categories: easy
tags: array prefix-sum sliding-window
langs: python c++
excerpt_separator: <!--more-->
---

## 題目

[3364. Minimum Positive Sum Subarray](https://leetcode.com/problems/minimum-positive-sum-subarray/)

給定一個整數陣列 `nums` 以及兩個整數 `l` 與 `r`。

請找出一個**連續子陣列**，滿足以下條件：
1. 子陣列長度介於 `l` 與 `r` 之間（即 $l \le \text{length} \le r$）。
2. 子陣列所有元素的和**嚴格大於 0**（$\text{sum} > 0$）。

在所有符合條件的子陣列中，回傳其**最小的總和**。如果不存在任何符合條件的子陣列，請回傳 `-1`。

題目限制：
- $1 \le \text{nums.length} \le 100$
- $1 \le l \le r \le \text{nums.length}$
- $-1000 \le \text{nums}[i] \le 1000$

<!--more-->

## 解題思路

### 1. 題目需求與限制分析

題目要求尋找長度落在區間 $[l, r]$ 內，且總和嚴格大於 0 的子陣列之最小總和。

陣列長度限制 $n \le 100$，規模非常小。如果我們枚舉所有合法的起點與終點，總共的區間數大約為：
$$O(n \cdot (r - l + 1)) \le O(n^2)$$
當 $n = 100$ 時，最多僅約 5,000 種子陣列組合，因此使用前綴和（Prefix Sum）進行枚舉即可在極短時間內完成。

### 2. 利用前綴和 $O(1)$ 取得區間和

如果每次計算子陣列和都透過迴圈從頭加到尾，時間複雜度會多出一個維度。為了加速計算，我們先建立長度為 $n + 1$ 的前綴和陣列 `presum`：
- `presum[0] = 0`
- `presum[k] = nums[0] + nums[1] + ... + nums[k - 1]`

對於任意左開右閉或從索引 $i$ 開始、到索引 $j - 1$ 結束的連續子陣列 `nums[i..j-1]`（長度為 $j - i$）：
$$\text{current\_sum} = \text{presum}[j] - \text{presum}[i]$$
只需進行一次減法即可取得區間總和。

### 3. 枚舉所有符合長度限制的子陣列

- 外層迴圈枚舉子陣列的起點 $i \in [0, n - 1]$。
- 內層迴圈枚舉結尾位置 $j$。因為子陣列長度必須介於 $l$ 與 $r$ 之間，所以長度 $len = j - i$ 必須符合 $l \le len \le r$，即：
  $$j \in [i + l, \min(i + r, n)]$$
- 計算當前區間總和 $\text{current\_sum} = \text{presum}[j] - \text{presum}[i]$。
- 若 $\text{current\_sum} > 0$，則更新答案最小值：
  $$\text{min\_val} = \min(\text{min\_val}, \text{current\_sum})$$

走訪完所有可能後，若 `min_val` 仍為初始值（如無窮大），代表沒有任何正數總和的子陣列，回傳 `-1`；否則回傳 `min_val`。

---

## 演算法步驟

1. 計算陣列長度 $n = \text{len}(nums)$，建立長度為 $n + 1$ 的前綴和陣列 `presum`。
2. 走訪 $nums$，依序計算前綴和：`presum[i + 1] = presum[i] + nums[i]`。
3. 初始化答案 `min_val` 為正無窮大（$\infty$）。
4. 雙層迴圈枚舉：
   - 起點 $i$ 從 $0$ 到 $n - 1$。
   - 終點 $j$ 從 $i + l$ 到 $\min(i + r, n)$。
   - 計算區間和 `current_sum = presum[j] - presum[i]`。
   - 若 `current_sum > 0`，則令 `min_val = min(min_val, current_sum)`。
5. 若 `min_val` 仍為無窮大，回傳 `-1`；否則回傳 `min_val`。

---

## C++ 實作

```cpp
#include <vector>
#include <algorithm>
#include <climits>

using namespace std;

class Solution {
public:
    int minimumSumSubarray(vector<int>& nums, int l, int r) {
        int n = nums.size();
        vector<int> presum(n + 1, 0);
        for (int i = 0; i < n; i++) {
            presum[i + 1] = presum[i] + nums[i];
        }

        int min_val = INT_MAX;

        for (int i = 0; i < n; i++) {
            int end = min(i + r, n);
            for (int j = i + l; j <= end; j++) {
                int current_sum = presum[j] - presum[i];
                if (current_sum > 0) {
                    min_val = min(min_val, current_sum);
                }
            }
        }

        return min_val == INT_MAX ? -1 : min_val;
    }
};
```

---

## Python 實作

```python
from typing import List


class Solution:
    def minimumSumSubarray(self, nums: List[int], l: int, r: int) -> int:
        n = len(nums)
        presum = [0] * (n + 1)
        for i in range(n):
            presum[i + 1] = presum[i] + nums[i]
            
        min_val = float('inf')
        
        # O(n * (r - l + 1))
        for i in range(n):
            for j in range(i + l, min(i + r, n) + 1):
                current_sum = presum[j] - presum[i]
                if current_sum > 0:
                    min_val = min(min_val, current_sum)
                    
        return min_val if min_val != float('inf') else -1
```

---

## 複雜度分析

令 $n = \text{nums.length}$，以及長度範圍跨度 $m = r - l + 1$。

- **時間複雜度**：$O(n \cdot m)$。建立前綴和陣列耗費 $O(n)$。枚舉區間起點共 $n$ 個，對於每個起點，終點檢查最多 $r - l + 1$ 個，每次以 $O(1)$ 算出區間和。最壞情況下 $m \le n$，整體時間複雜度為 $O(n^2)$。因 $n \le 100$，運算次數在 $10^4$ 以內，執行非常迅速。
- **空間複雜度**：$O(n)$。需要一個大小為 $n + 1$ 的陣列儲存前綴和。

---

## 常見注意事項

- **正數限制**：題目要求總和必須**嚴格大於 0**（`current_sum > 0`），總和小於或等於 0 的子陣列均不能列入考慮。
- **邊界與長度**：內層迴圈終點上界為 $\min(i + r, n)$，避免陣列索引越界。
- **無解回傳**：若遍歷所有合法區間後均未找到大於 0 的總和，依題意回傳 `-1`。
