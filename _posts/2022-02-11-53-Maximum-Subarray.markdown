---
layout: article_post
title:  "[Leetcode解題] Maximum Subarray - presum解"
description:  "[Leetcode解題] Maximum Subarray - presum解"
categories: medium
tags: dp presum apple
langs: python
excerpt_separator: <!--more-->
---

<!--more-->

題目網址: [53. Maximum Subarray](https://leetcode.com/problems/maximum-subarray/)

# 題目
給定一個整數陣列`nums`，找到**子陣列**其總和最大並返回其總和。


# 使用preSum

`preSum(i)`代表陣列`nums[0:i]`(包含i)的總合，子陣列`nums[i:j]`的總和: `preSum(j)-preSum(i-1)`
當前指標位置cr，到cr前最小的preSum `min_sum  = min(preSum(0),...,preSum(cr-1))`，那麼假設**最大總和的子陣列**的最後一個元素為cr，該子陣列的總合為`preSum(cr)-min_sum`。

以下圖為例子，指標cr = 0，到cr前最小的preSum: minSum = 0，結尾為cr的最大總和的子陣列`ans_0 = preSum(0)-minSum = -2 - 0 = -2`。

{% graphviz %}
digraph hierarchy {
  //rankdir=LR;
  node [ shape=record ];
  arr [label="
      <0> -2 |
      <1> 1 |
      <2> -3 |
      <3> 4 |
      <4> -1 |
        <5> 2 "];
node [shape=box style="rounded,filled" height=0.3]
cr -> arr:<0>
node [label=0 fillcolor=lightgray] 1
node [label="\N" shape=box style="rounded,filled" height=0.3]
minSum -> 1
preSum -> 0
}
{% endgraphviz %}


cr依序遍歷nums的每個元素...

指標cr = 4，到cr前最小的preSum: minSum = -2+1+(-3) = -4，結尾為cr的最大總和的子陣列`ans_4 = preSum(cr)-minSum = -1-(-4) = 3`。

{% graphviz %}
digraph hierarchy {
  //rankdir=LR;
  node [ shape=record ];
  arr [label="
      <0> -2 |
      <1> 1 |
      <2> -3 |
      <3> 4 |
      <4> -1 |
        <5> 2 "];
node [shape=box style="rounded,filled" height=0.3]
cr -> arr:<4>

minSum -> -4
preSum -> -1
}
{% endgraphviz %}
指標cr = 5，minSum = -2+1+(-3) = -4，結尾為cr的最大總和的子陣列`ans_5 = preSum(cr)-minSum = 1-(-4) = 5`。
{% graphviz %}
digraph hierarchy {
  //rankdir=LR;
  node [ shape=record ];
  arr [label="
      <0> -2 |
      <1> 1 |
      <2> -3 |
      <3> 4 |
      <4> -1 |
        <5> 2 "];
node [shape=box style="rounded,filled" height=0.3]
cr -> arr:<5>

minSum -> -4
preSum -> 1
}
{% endgraphviz %}
`cr`每前進一步，就會計算出一個結尾為`cr`的最大子陣列總和`ans_cr`，回傳最大的`ans_cr`就是最大子陣列總和。

## 時間複雜度
由於每次指標cr向前走一步，都需要更新一次`preSum`, `min_sum`, 和最大的`ans`，因此時間複雜度為$O(N)$。


## 實作
```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        sum = 0
        min_sum = 0
        ans = -inf
        for num in nums:
            sum += num
            ans = max(ans, sum-min_sum)
            min_sum = min(sum, min_sum)
        return ans
```




# 動態規劃

先思考一下，如果子陣列的結尾位置為`i`，那麼最大總和的子陣列總和可以怎麼計算呢?

以`cr[i]`代表`nums[i]`為結尾的總和最大nums子陣列，在已知cr[i-1]的前提下，cr[i]有兩種可能:
1. 加上以前一個位置結尾的子陣列最大總和: cr[i-1]+nums[i]
    ```
    nums = [-2,1,-3,4,-1,2,1,-5,4]
                           ^
                           i
    ```
    當我們要計算結尾為index i = 6的子陣列最大總和, 以`cr[i-1]`為結尾的最大子陣列總和為`cr[5]=1`，nums[i]=1加上以前一個位置結尾的子陣列最大總和 **大於** 從當前i這個位置算起，因此`cr[i]` = `cr[i-1]+nums[i]` = `cr[5]+nums[6]` = 2

2. 不包含前一個位置的最大總和: nums[i]
    ```
    nums = [-2,1,-3,4,-1,2,1,-5,4]
               ^
               i
    ```
    當我們要計算結尾為index i =1的子陣列最大總和, 以`cr[i-1]`為結尾的最大子陣列總和為`cr[0]=-2`，加上以前一個位置結尾的子陣列最大總和 **不如** 從當前i這個位置算起，因此cr[i] = nums[i]

回到這個題目，我們可以使用迴圈，去計算每個結尾位置為`i`，最大總和的子陣列總和，只保留最大的總和，就是整個陣列的最大子陣列總和啦~

## 時間複雜度
每次藉由前一個`cr[i-1]`來計算以當前index為結尾的子陣列最大總和`cr[i]`，時間複雜度是$O(1)$，針對每個`nums[i]`為結尾都需要一次計算，因此時間複雜度為$O(N)$。


```python
class Solution:
    def maxSubArray(self, nums: List[int]) -> int:
        cr = 0
        ans = -inf
        for num in nums:
            cr = max(cr+num, num)
            ans = max(ans, cr)
        return ans
```
