---
layout: article_post
title:  "[Leetcode解題] 991. Broken Calculator"
description:  "991. Broken Calculator"
categories: medium
tags: greedy
langs: python
excerpt_separator: <!--more-->
---

## 題目描述
[991. Broken Calculator](https://leetcode.com/problems/broken-calculator/)
有一台壞掉的計算機，螢幕上一開始顯示一個整數 `startValue`。
在一次操作中，你可以執行以下其中一個動作：

1. 將螢幕上的數字乘以 2
2. 將螢幕上的數字減去 1

給定兩個整數 `startValue` 與 `target`，請回傳從 `startValue` 轉換到 `target` 所需的最少操作次數。
<!--more-->

## 解題思路
如果我們從 `startValue` 出發往 `target` 走，會有很多分支，很難控制最短路徑。
一個更聰明的方法是**反過來思考**：從 `target` 反推回到 `startValue`。

### 反向思考的原因

* 正向操作有兩種（×2 或 -1），分支數會很大。
* 反向操作則簡單許多：

  * 如果 `target` 是偶數，那麼它有可能是由 `target / 2` 乘 2 得到的。
  * 如果 `target` 是奇數，那麼它一定是由 `target + 1` 減 1 得到的。

因此，我們可以從 `target` 不斷往回推，直到小於或等於 `startValue`。
最後，如果 `target` 比 `startValue` 小，唯一能做的就是一直加 1（反向對應正向的 -1）。

### 演算法步驟
1. 初始化操作次數 `ops = 0`。
2. 當 `target > startValue`：

   * 如果 `target` 是偶數 → `target = target / 2`。
   * 如果 `target` 是奇數 → `target = target + 1`。
   * 每次操作都讓 `ops += 1`。
3. 當 `target <= startValue` 時，說明只剩下差距要補齊 → `ops += (startValue - target)`。
4. 回傳 `ops`。

## Python 實作
```python
class Solution:
    def brokenCalc(self, startValue: int, target: int) -> int:
        ops = 0
        while target > startValue:
            if target % 2 == 0:
                target //= 2
            else:
                target += 1
            ops += 1
        return ops + (startValue - target)
```

## C++ 實作
```cpp
class Solution {
public:
    int brokenCalc(int startValue, int target) {
        int operationNum = 0;

        while(target>startValue){
            if (target%2){
                target +=1;
            }else{
                target /=2;
            }
            operationNum++;
        }
        return operationNum + (startValue - target);
    }
};
```

## 時間複雜度分析
* 每次操作要嘛將 `target` 減少 1，要嘛將它除以 2。
* 在最壞情況下，演算法大約會進行 `O(log(target))` 次除法，以及少量的加 1 操作。
* 因此，**時間複雜度**為 `O(log(target))`，**空間複雜度**為 `O(1)`。