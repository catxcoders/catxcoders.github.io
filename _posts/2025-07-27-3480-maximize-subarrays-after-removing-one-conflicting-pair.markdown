---
layout: article_post
title:  "[Leetcode解題] 3480. Maximize Subarrays After Removing One Conflicting Pair"
description:  "3480 超詳細解說，附解題思路"
categories: hard
tags: enumeration two-pointer array subarray
langs: python
excerpt_separator: <!--more-->
---

## 題目
[3480. Maximize Subarrays After Removing One Conflicting Pair](https://leetcode.com/problems/maximize-subarrays-after-removing-one-conflicting-pair/description/?envType=daily-question&envId=2025-07-26)

給定一個正整數n，表示一個從1到n的數列，另給一個conflictingPairs，裡面每個元素包含兩個數字a_i跟b_i，題目所求的subarray不能同時包含a_i跟b_i對於任意的i

另外，題目所求的是，今天若刪除conflictingPairs中的某一個pair，能得到的最多的subarray為何？

<!--more-->

## 解題思路

這題相當困難，也很不直覺

### 用兩個指針表示subarray

首先，對於`subarray`的題目（注意subarray跟subset的差別），我們可以使用兩個指針來表示

### 只有一個conflictingPair的狀況

今天，我可以看某一個conflictingPair，比如說(u, v)=(3, 5)，這邊我們假設u<v這樣比較好解釋，另給定n為10

1,2,3,4,5,6,7,8,9,10

我們先思考，怎麼去得到所有可能的subarray，如上述說的，可以用兩個指針來表示

對於後指針指到某個位置j的時候，可能的子矩陣有0到j-1個

後指針j有幾種可能

1. 小於3：那麼i不管是什麼，都不可能同時包含3跟5
2. 大於等於3且小於5：同上，i不管是什麼，都不可能同時包含3跟5
3. 大於等於5：i只要小於等於3，就會同時包含3跟5

對於第三種狀況，我們可以很快速的求得，以j為結尾時，有效的子矩陣為j-3個，比如j=7，有效的子矩陣為4個，分別為：

[4,5,6,7], [5,6,7], [6, 7], [7]


現在，我們來看有兩個相同結尾的conflictingPairs會怎樣，假設(3, 5)跟(4, 5)

我們發現，u越大，有效的子矩陣會越少，也就表示它的限制會更大

所以我們只需考慮(4,5)就好

因此，對於任意結尾j，我們都只需要考慮其最大的i的狀況，只會有一種


### 不同的conflictingPairs如何互相影響

再來，我們還要再考慮一個狀況，不同的conflictingPairs之間如何互相影響

假設我們有(3, 5)跟(2, 6)

我們用剛剛的想法來看(2, 9)，對於以j為結尾來說，有效的子矩陣為j-2，假設j=6，有效的子矩陣為4個，分別為：

[3,4,5,6], [4,5,6], [5, 6], [6]

但此時，我們發現[3,4,5,6]包含了另一個conflictingPair，所以也不合法，會發生這種狀況是因為

(3, 5)的3比(2, 6)的2大，如同上述提到的，它是更大的限制，因此我們應該要記錄下最大的u

### 不移除的情況如何計算

到此，我們可以計算出不移除任何conflictingPairs的情況，所有有效的子矩陣數目為何

我們紀錄每個v對應的所有可能u（或者只需要紀錄最大的u），然後從後指針1到n計算有效的子矩陣，並且維護一個最大的u_max

```python

right = [0] * (n+1)

for _u, _v in conflictingPairs:
    u = min(_u, _v)
    v = max(_u, _v)
    right[v] = max(right[v], u)

u_max = 0
score = 0
for r in range(1, n+1):
    u_max = max(right[r], u_max)
    score += r - u_max
    
```

### 移除的狀況如何計算

現在我們要考慮，若可以移除任意一個pair會怎樣

如果可以移除一個的話，我們剛剛上面只記錄max的做法就會遇到困難，因為如果剛好移除max的那個Pair

就會讓後面的假設失敗，所以我們要多計算並記錄第二大的值

並且我們在看每一個conflicting pairs的時候，要考慮如果該pair被移除會影響到u_max時，那就要替換成第二大的值

而替換後，會多出一些原先不合法但現在合法的subarray，多出來的數量就是`u_max1-u_max2`

這邊有個重點，我們要紀錄在`u_max1`的index下，bonus這個矩陣表示，當u_max1的這個pair被移除時，會產生多少新的subarray

所以bonus這個矩陣，只會紀錄到所有可能的u_max1，因為它們被移除才會產生新的有效矩陣


```python
class Solution:
    def maxSubarrays(self, n: int, conflictingPairs: List[List[int]]) -> int:
        right1 = [0] * (n+1)
        right2 = [0] * (n+1)

        for _u, _v in conflictingPairs:
            u = min(_u, _v)
            v = max(_u, _v)
            if u > right1[v]:
                right2[v] = right1[v]
                right1[v] = u
            elif u > right2[v]:
                right2[v] = u
                
        u_max1 = 0
        u_max2 = 0
        score = 0
        bonus = [0] * (n+1)
        for r in range(1, n+1):
            if right1[r] > u_max1:
                u_max2 = max(u_max1, right2[r])
                u_max1 = right1[r]
            elif right1[r] > u_max2:
                u_max2 = right1[r]

            score += r - u_max1
            bonus[u_max1] += u_max1 - u_max2
        return score + max(bonus)
```

## 時間複雜度

$O(m+n)$，m為conflictingPairs的數量