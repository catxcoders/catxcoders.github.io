---
layout: article_post
title:  "[Leetcode解題] 1894. Find the Student that Will Replace the Chalk"
description:  "1894. Find the Student that Will Replace the Chalk"
categories: medium
tags: array
langs: python
excerpt_separator: <!--more-->
---

## 題目
老師有一盒粉筆，一開始有 $k$ 支，會依照順序讓編號 $0$ 到 $n-1$ 的學生輪流解題，每個學生解一題會消耗不同數量的粉筆（由 `chalk` 陣列提供）。當某個學生發現粉筆數量不足，這個學生就要去補充粉筆，我們要找出這位學生的索引。
<!--more-->

## 解題思路
### Step 1: 計算總粉筆消耗
假設 `chalk = [5,1,3]`，表示：
- 學生 0 需要 5 支
- 學生 1 需要 1 支
- 學生 2 需要 3 支

如果總共有 22 支粉筆，消耗循環如下：
```
[5, 1, 3] → [5, 1, 3] → [5, 1, 3] → ...
```
總共消耗 `5 + 1 + 3 = 9` 支粉筆一輪，那我們就可以先讓 `k` 取餘數，找到最終剩下的粉筆數：
```
k = k % 總消耗量
```
這樣可以快速排除完整輪次，節省時間。

### Step 2: 找出第一個粉筆不足的學生
現在我們剩下的 `k`，直接從頭開始扣除學生所需的粉筆，直到遇到 **粉筆不夠** 的學生，就直接回傳他的索引。

## Python 實作
```python
class Solution:
    def chalkReplacer(self, chalk: List[int], k: int) -> int:
        total = sum(chalk)  # 計算總粉筆消耗
        k %= total  # 取餘數，跳過完整循環

        for i, c in enumerate(chalk):
            if k < c:  # 粉筆不夠了，這個學生要補充
                return i
            k -= c  # 扣除目前學生的粉筆數
```
### 時間複雜度
- 計算總消耗量 `sum(chalk)`：$O(n)$
- 取餘數 `k % total`：$O(1)$
- 找到需要補充粉筆的學生：$O(n)$
- 總共：$O(n)$


## C++ 實作
```cpp
class Solution {
public:
    int chalkReplacer(vector<int>& chalk, int k) {
        long long total = accumulate(chalk.begin(), chalk.end(), 0LL); // 計算總粉筆消耗
        k %= total; // 取餘數，跳過完整循環

        for (int i = 0; i < chalk.size(); i++) {
            if (k < chalk[i]) return i; // 粉筆不夠了，這個學生要補充
            k -= chalk[i]; // 扣除目前學生的粉筆數
        }
        return -1; // 不會執行到這裡
    }
};
```
### 時間複雜度
- `accumulate` 計算總和：$O(n)$
- `k % total`：$O(1)$
- 遍歷找出補充者：$O(n)$
- 總共：$O(n)$


## 優化：前綴和 + 二分搜尋
如果 `n` 很大，想要更快找到補充粉筆的學生，可以先計算**前綴和**，用 `upper_bound` 二分搜尋。

### C++ 優化版
```cpp
class Solution {
public:
    int chalkReplacer(vector<int>& chalk, int k) {
        int n = chalk.size();

        vector<long> prefixSum(n);
        prefixSum[0] = chalk[0];
        for(int i=1; i<n; i++){
            prefixSum [i] = prefixSum[i-1] + chalk[i];
        }

        k = k%prefixSum[n-1];
        return upper_bound(prefixSum.begin(), prefixSum.end(), k)-prefixSum.begin();
    }
};
```

### **Python 優化版**
```python
class Solution:
    def chalkReplacer(self, chalk: List[int], k: int) -> int:
        # 計算前綴和
        prefix_sum = list(itertools.accumulate(chalk))  
        
        # 取餘數，去掉完整循環
        k %= prefix_sum[-1]
        
        # 使用 bisect 進行二分搜尋，找第一個 > k 的索引
        return bisect.bisect_right(prefix_sum, k)
```

### **時間複雜度**
- **前綴和計算：** $O(n)$
- **取餘數：** $O(1)$
- **二分搜尋：** $O(\log n)$
- **總共：** $O(n + \log n)$

當 `n` 很大時，這個方法比原本的 $O(n)$ 遍歷快！


## 總結
如果 `n` 不大，用 Python 的方法即可；如果 `n` 很大，C++ 版的前綴和 + 二分搜尋會更快！