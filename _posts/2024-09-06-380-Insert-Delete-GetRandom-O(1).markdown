---
layout: article_post
title:  "[Leetcode解題]  380. Insert Delete GetRandom O(1)"
description:  "[Leetcode解題]  380. Insert Delete GetRandom O(1)"
categories: medium
tags: array hashTable
langs: python
excerpt_separator: <!--more-->
---

# 380. Insert Delete GetRandom O(1)

## 題目
[380. Insert Delete GetRandom O(1)](https://leetcode.com/problems/insert-delete-getrandom-o1/)
實作一個 `RandomizedSet` 類別，這個類別需要支援以下操作：

1. `RandomizedSet()`：初始化一個空的 `RandomizedSet` 物件。
2. `bool insert(int val)`：如果 `val` 不存在於集合中，插入 `val` 並回傳 `true`；否則回傳 `false`。
3. `bool remove(int val)`：如果 `val` 存在於集合中，移除 `val` 並回傳 `true`；否則回傳 `false`。
4. `int getRandom()`：隨機回傳集合中的一個元素（保證至少有一個元素存在）。每個元素被選中的機率應該相同。

要求每個操作的平均時間複雜度為 $O(1)$。
<!--more-->
## 解題思路

要實現這個功能，我們需要支援 $O(1)$ 時間複雜度的**插入**、**刪除**以及**隨機取樣**。這裡我們可以使用：
- 列表`nums`：用來存放所有的元素，用來使隨機取樣的時間複雜度為$O(1)$ 。
- 字典`m`：用來記錄每個元素在 `nums` 中的索引位置，方便插入和刪除的時間複雜度為$O(1)$。

### 插入操作 (`insert`)
- 插入時先檢查元素是否存在於 `m` 中，如果存在就回傳 `false`。
- 如果不存在，就把元素加到 `nums` 的尾端，並在 `m` 裡記錄這個元素的位置。

### 刪除操作 (`remove`)
- 刪除時先檢查元素是否存在於 `m` 中，如果不存在就回傳 `false`。
- 如果存在，***將要刪除的元素與 `nums` 尾端的元素交換位置***，然後更新 `m` 裡的位置記錄，最後移除 `nums` 尾端的元素並從 `m` 刪除該元素。

### 隨機取樣 (`getRandom`)
- 利用 Python 的 `random.choice()` 從 `nums` 裡隨機選取一個元素即可。

## Python 實現

```python
class RandomizedSet:
    def __init__(self):
        self.nums = []
        self.m = {}

    def insert(self, val: int) -> bool:
        if val in self.m:
            return False
        self.nums.append(val)
        self.m[val] = len(self.nums) - 1
        return True

    def remove(self, val: int) -> bool:
        if val not in self.m:
            return False
        # 交換要刪除的元素和尾端的元素
        last_element = self.nums[-1]
        index_to_remove = self.m[val]
        self.nums[index_to_remove] = last_element
        self.m[last_element] = index_to_remove
        # 移除元素
        self.nums.pop()
        del self.m[val]
        return True

    def getRandom(self) -> int:
        return random.choice(self.nums)

# Your RandomizedSet object will be instantiated and called as such:
# obj = RandomizedSet()
# param_1 = obj.insert(val)
# param_2 = obj.remove(val)
# param_3 = obj.getRandom()
```

## C++ 實現
```cpp
class RandomizedSet {
public:
    RandomizedSet() {}
    
    bool insert(int val) {
        if (m.find(val)==m.end()){
            nums.push_back(val);
            m[val] = nums.size()-1;
            return true;
        }else{
            return false;
        }
        
    }
    
    bool remove(int val) {
        if (m.find(val)==m.end()){
            return false;
        }else{
            m[nums.back()] = m[val];
            swap(nums.back(), nums[m[val]]);
            m.erase(val);
            nums.pop_back();
            return true;
        }
        
    }
    
    int getRandom() {
        int r = rand()%nums.size();
        return nums[r];
    }

    vector<int> nums;
    unordered_map<int, int> m;
};

/**
 * Your RandomizedSet object will be instantiated and called as such:
 * RandomizedSet* obj = new RandomizedSet();
 * bool param_1 = obj->insert(val);
 * bool param_2 = obj->remove(val);
 * int param_3 = obj->getRandom();
 */
```

## 時間複雜度分析
- 插入 (`insert`)：$O(1)$ 平均時間複雜度。
- 刪除 (`remove`)：$O(1)$ 平均時間複雜度。
- 隨機取樣 (`getRandom`)：$O(1)$ 平均時間複雜度。

這些操作都能在常數時間內完成，因為我們利用了:
- 列表的特性達到快速取隨機元素
- 字典的特性來達到快速插入、刪除的要求。
