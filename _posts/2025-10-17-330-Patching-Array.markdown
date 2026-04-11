---
layout: article_post
title:  "[Leetcode解題] 330. Patching Array"
description:  "330. Patching Array"
categories: hard
tags: greedy
langs: python
excerpt_separator: <!--more-->
---

## 題目
[330. Patching Array](https://leetcode.com/problems/patching-array)
給定一個已排序的整數陣列 nums 與一個整數 n。你可以在陣列中新增（patch）一些正整數，使得區間 [1, n] 內的每個數都能被陣列中某些元素的和表示。
請回傳最少需要新增的元素個數。
<!--more-->

## 解題思路（Greedy 貪心）

核心概念：維護目前我們**已能覆蓋的連續區間** `[1, miss)`，其中 `miss` 表示**最小還無法被表示**的正整數。

* 初始 `miss = 1`，表示我們還無法表示數字 1。
* 走訪 `nums`：

  * 若當前元素 `x = nums[i]` 滿足 `x <= miss`，代表用上 `x` 後，原本可覆蓋到 `< miss` 的區間，現在可擴張到 `< miss + x`。
    → 更新 `miss += x`，指標 `i++`。
  * 否則（`x > miss` 或已無元素），表示**缺口在 `miss`**：
    若我們補上一個數 **`miss`**，即可把覆蓋區間從 `< miss` 擴張到 `< miss + miss = 2*miss`。
    → **新增一個 patch**，並更新 `miss += miss`。
* 持續上述過程直到 `miss > n`（表示 `[1, n]` 全數可表示）。

* 為何補 `miss` 是最佳？
    * 因為在無法覆蓋 `miss` 時，能把覆蓋區間擴張得最廣的、且**剛好填補缺口**的最小選擇就是 `miss` 本身。
    * 補其它比 `miss` 大的數，無法先填上 `miss`，覆蓋區間也擴不出去；
    * 補比 `miss` 小的數則不如直接補 `miss` 擴張得快。

## 範例
`nums = [1, 5, 10], n = 20`
* 初始 `miss=1`；`nums[0]=1 <= 1` → `miss = 2`
* `nums[1]=5 > miss=2` → 補 `2`：`miss = 4`（patch=1）
* 仍 `5 > 4` → 補 `4`：`miss = 8`（patch=2）
* 現在 `5 <= 8` → `miss = 13`
* `10 <= 13` → `miss = 23`
  當 `miss=23 > n=20`，完成。最少 patch = 2。

## Python 實作

```python
class Solution:
    def minPatches(self, nums: List[int], n: int) -> int:
        patches = 0
        miss = 1          # 目前還不能覆蓋到的最小數
        i = 0

        while miss <= n:
            if i < len(nums) and nums[i] <= miss:
                miss += nums[i]
                i += 1
            else:
                # 補上 miss，自然擴張覆蓋到 [1, 2*miss)
                patches += 1
                miss += miss
        return patches
```

## C++實作

```cpp
class Solution {
public:
    int minPatches(vector<int>& nums, int n) {
        long long miss = 1;   // 當前尚無法覆蓋的最小數
        int patches = 0;
        size_t i = 0;

        while (miss <= n) {
            if (i < nums.size() && nums[i] <= miss) {
                // 用現有數字擴張可覆蓋區間
                miss += nums[i];
                ++i;
            } else {
                // 補上 miss，將覆蓋從 [1, miss) 擴到 [1, 2*miss)
                ++patches;
                miss += miss;
            }
        }
        return patches;
    }
};
```

## 時間與空間複雜度

* **時間複雜度**：$O(m + k)$，其中 $m = len(nums)$，`k` 是實際補的次數。由於每次不是消耗一個 `nums` 元素就是將 `miss` 倍增，`k` 最多約為 $O(log n)$。時間複雜度為$O(m+log(n))$
* **空間複雜度**：$O(1)$

