---
layout: article_post
title:  "[Leetcode解題] 2751. Robot Collisions - 使用stack解"
description:  "Robot Collisions"
categories: hard
tags: array stack
langs: python
excerpt_separator: <!--more-->
---

## 題目

[2751. Robot Collisions](https://leetcode.com/problems/robot-collisions/)

有n個機器人，每個機器人都有其位置、健康值和移動方向。

給定三個0索引的整數數組：positions（位置）、healths（健康值），以及一個字符串directions（directions[i] 可能是 'L' 表示向左，或是 'R' 表示向右）。所有positions中的整數是唯一的。

所有機器人會同時開始以相同的速度沿著他們給定的方向移動。如果兩個機器人在移動過程中碰撞到同一個位置，他們就會發生碰撞。

如果兩個機器人發生碰撞，健康值較低的機器人會被移除，而另一個機器人的健康值會減少1。存活的機器人繼續沿著它原本的方向移動。如果兩個機器人的健康值相同，那麼它們都會被移除。

求存活下來的機器人的健康值（按照原本給定的順序）


## 解題思路

1. 初始化與排序：

我們需要對機器人的位置做排序以便移動機器人，並且需要存下索引來拿到健康值跟移動方向。

首先，將每個機器人的索引和位置結合成元組，並將這些元組放入一個列表 `pos_w_idx`中。

根據機器人的位置對`pos_w_idx`進行排序，以便按位置模擬機器人的移動。

2. 模擬移動與碰撞：

使用一個`stack`來處理碰撞情況，棧中存放的是向右移動（'R'）的機器人索引。

遍歷排序後的機器人列表 pos_w_idx，根據機器人的方向進行處理：
如果機器人向右移動（'R'），將其索引推入`stack`中。

如果機器人向左移動（'L'），需要檢查棧頂`stack.top()`的機器人是否會發生碰撞。

3. 處理碰撞邏輯：

我們發現，只有當一個左邊的機器人向右，另一個右邊的機器人向左的時候才會發生碰撞。

如果棧頂機器人的健康值大於當前機器人的健康值，則當前機器人被移除，棧頂機器人的健康值減少1。

如果棧頂機器人的健康值小於當前機器人的健康值，則棧頂機器人被移除，當前機器人的健康值減少1並繼續進行碰撞檢查。

如果棧頂機器人的健康值等於當前機器人的健康值，則兩者都被移除。

4. 收集結果：

在處理完所有機器人後，檢查健康值數組 healths，將健康值不為零的機器人健康值加入結果列表`ans`中。

返回結果列表`ans`，即最終存活的機器人的健康值。

## 程式碼

```python
class Solution(object):
    def survivedRobotsHealths(self, positions, healths, directions):
        """
        :type positions: List[int]
        :type healths: List[int]
        :type directions: str
        :rtype: List[int]
        """
        pos_w_idx = []
        for idx, position in enumerate(positions):
            pos_w_idx.append((idx, position))
        
        pos_w_idx = sorted(pos_w_idx, key=lambda x: x[1])
        
        stack = []
        for idx, pos in pos_w_idx:
            if directions[idx] == 'R':
                stack.append(idx)
                continue
            if directions[idx] == 'L':
                while stack:
                    if healths[stack[-1]] > healths[idx]:
                        # Collision, R wins
                        healths[idx] = 0
                        healths[stack[-1]] -= 1
                        break
                    elif healths[stack[-1]] < healths[idx]:
                        # Collision, L wins
                        healths[idx] -= 1
                        healths[stack[-1]] = 0
                        stack.pop()
                    else:
                        # Collision, tie
                        healths[idx] = 0
                        healths[stack[-1]] = 0
                        stack.pop()
                        break
        
        ans = []
        for health in healths:
            if health:
                ans.append(health)
        return ans

```

## 時間複雜度

Bottleneck在於做排序的部分，所以時間複雜度為$O(nlogn)$