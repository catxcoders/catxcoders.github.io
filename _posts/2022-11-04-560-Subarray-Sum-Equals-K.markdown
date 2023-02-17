---
layout: custom_post
title:  "560. Subarray Sum Equals K"
date:   2022-11-04 21:27:53 +0800
categories: medium
---

題目網址: [560. Subarray Sum Equals K](https://leetcode.com/problems/subarray-sum-equals-k/)

# 題目 
給定一個整數陣列 `nums` 和一個整數 `k`，返回總和等於 `k` 的子陣列的總數。 子陣列是陣列中元素的連續非空序列。

# 解題思路
## 子陣列由i到j總和計算: 
計算子陣列`nums[i:j]`(包含`i`、不包含`j`)的總和`sum(nums, i, j)`可以有兩種方式
1. 由index`i` 加到 `j` (包含i、不包含j)
```python=
def sum(nums, i, j):
    s = 0
    for idx in range(i,j):
        s += nums[idx]
    return s
```
2. 使用preSum的概念
preSum(i) 代表陣列nums[0:i]的總合
preSum(j) 代表陣列nums[0:j]的總合
preSum(j)減去 preSum(i)就是 nums[i:j]的總合
```python=
def preSum(m):
    sum(nums, 0, m)
preSum(j) - preSum(i)
```

如果使用第一種方法，時間複雜度會比較差，會有許多重複的`＋`的計算。這邊我們採用第二種`子陣列由i到j總和`的技巧，當子陣列總和`sum(nums[i:j])==k` 表示 `preSum(j) - preSum(i) = k`。由於`preSum(i)  = preSum(j) - k`，我們可以使用字典儲存在當前index `j` 前，每個總和出現過多少次，對於index `j`只需要查找`dict[preSum(j)-k]`就是符合`sum(nums[i:j])==k` `i`可能的個數。


# 實作
```python=
class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        ans = 0
        preSum = 0
        dic = {0:1}
        for num in nums:
            preSum += num
            ans += dic.get(preSum-k, 0)
            dic[preSum] = dic.get(preSum, 0) + 1
        return ans
```

## 字典(Dictionary) `get()`函數
這裡使用Python 字典(Dictionary) `get()`函數返回特定`key`的值，如果指定`key`的值不存在時，返回默認值`value`。

```python
dict.get(key[, value]) 
```

# 時間複雜度
查找key是否在dict中的時間複雜度為O(1)
增加key在dict中的時間複雜度為O(1)
對於每個`nums[i]`只會做兩次查找，一次增加key
因此時間複雜度為O(n)