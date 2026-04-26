---
layout: article_post
title:  "[Leetcode解題] 3464. Maximize the Distance Between Points on a Square"
description:  "3464. Maximize the Distance Between Points on a Square"
categories: medium
tags: binary-search math
langs: python
excerpt_separator: <!--more-->
---

## 題目
[3464. Maximize the Distance Between Points on a Square](https://leetcode.com/problems/maximize-the-distance-between-points-on-a-square/description/)

給定一個邊長為 `side` 的正方形，其四個頂點分別為 `(0, 0)`, `(0, side)`, `(side, 0)` 和 `(side, side)`。
你還會得到一個位於正方形邊緣上的點的列表 `points`，以及一個整數 `k`。
你的目標是從這組點中選擇恰好 `k` 個點，使得這 `k` 個點中任意兩個點之間的最短曼哈頓距離（Manhattan distance）最大化。

請回傳此最大化的最短距離。

<!--more-->

## 解題思路

這是一個典型的「最大化最小值」問題，通常可以使用「對答案進行二分搜尋」來解決。

1. **展開正方形邊界為一維直線**：
   為了方便表示在邊緣上的位置和計算點與點之間的直線距離，我們可以將正方形的周界展平成一條長度為 `4 * side` 的直線區間 `[0, 4 * side)`。
   我們定義一個將二維座標轉換為一維純量值的方法：
   - 下邊界 (`y=0`)：距離起點的值為 `x`
   - 右邊界 (`x=side`)：值為 `side + y`
   - 上邊界 (`y=side`)：值為 `3 * side - x`
   - 左邊界 (`x=0`)：值為 `4 * side - y`
   
2. **對轉換後的點排序**：
   將所有點轉換為一維的所在位置並從小到大排序（時間複雜度為 $O(n \log n)$），以方便後續我們用貪婪法 (Greedy) 和二分搜尋來判定解的可行性。

3. **二分搜尋最短距離 (Binary Search on Answer)**：
   我們在可能的距離範圍 `0` 到 `side` 之間進行二分搜尋。對於每個距離候選值 `mid`，我們使用 `check(d)` 函數檢查是否可以順利挑選出 `k` 個點，且任兩點距離長度最少為 `mid`。

4. **驗證條件 (`check` 函數)**：
   - 由於點分佈在環形的邊緣上，我們嘗試以每個有給出的點 `pos[i]` 作為候選的「第一顆點」，模擬貪婪向後地去挑選剩下的點。
   - 因為其各點的位置等價在一維陣列上且已排序，我們可以使用 `bisect.bisect_left` 以 $O(\log n)$ 的時間快速尋找「與當前點距離大於等於 `d`」的下一個點所在的索引。
   - 當能夠順利挑滿 `k` 個點時，我們還需要確認最後一個選出的點與最開始第一顆點的距離。因為這是一個長度為 `4 * side` 的環，頭尾銜接處同樣必須滿足距離 $\ge d$ 的條件 (`4 * side - (last_pos - start_pos) >= d`)。
   - 若符合則此距離 `d` 是合法的，提早回傳 `True` 即可。

5. 根據每次檢查驗證的結果去調整二分搜尋的上下範圍 `low` 與 `high`，並更新合法的距離記錄，直到二分搜尋結束。

## Python 實作

```python
import bisect
class Solution:
    def maxDistance(self, side: int, points: list[list[int]], k: int) -> int:
        def get_dist(x, y):
            if y == 0: return x
            if x == side: return side + y
            if y == side: return 3 * side - x
            if x == 0: return 4 * side - y
            return 0

        pos = sorted([get_dist(x, y) for x, y in points])
        n = len(pos)
        
        def check(d):
            for i in range(n): # Any optimization?
                count = 1
                last_pos = pos[i]
                start_pos = pos[i]
                
                curr_idx = i
                for _ in range(k - 1):
                    target = last_pos + d
                    idx = bisect.bisect_left(pos, target)
                    if idx == n:
                        count = -1
                        break
                    last_pos = pos[idx]
                    count += 1
                
                if count == k and (4 * side - (last_pos - start_pos)) >= d:
                    return True
                
            return False

        low, high = 0, side
        ans = 0
        while low <= high:
            mid = (low + high) // 2
            if check(mid):
                ans = mid
                low = mid + 1
            else:
                high = mid - 1
        return ans
```

## 時間複雜度

- 將所有的點展開一維化並且按照順序排序，需要時間 $O(n \log n)$。
- 檢查合法條件的 `check` 函數最壞情況下可能進入 $O(n \cdot k \log n)$ 次計算。外部二分搜尋則需執行 $O(\log(\text{side}))$ 次。
- 整體的總時間複雜度大約為 $O(n \log n + \log(\text{side}) \cdot n \cdot k \log n)$。
- **空間複雜度**：需要長度為 $n$ 的 `pos` 陣列來儲存處理過的位置，空間耗費為 $O(n)$。
