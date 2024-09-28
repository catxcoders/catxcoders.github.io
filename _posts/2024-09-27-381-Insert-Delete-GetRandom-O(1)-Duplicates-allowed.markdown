---
layout: article_post
title:  "[Leetcode解題]  381. Insert Delete GetRandom O(1) - Duplicates allowed"
description:  "381. Insert Delete GetRandom O(1) - Duplicates allowed"
categories: medium
tags: hashmap array
langs: python
excerpt_separator: <!--more-->
---

# 381. Insert Delete GetRandom O(1) - Duplicates allowed

## 題目描述
[381. Insert Delete GetRandom O(1) - Duplicates allowed](https://leetcode.com/problems/insert-delete-getrandom-o1-duplicates-allowed/)
`RandomizedCollection` 是一個支援重複元素（multiset）的數據結構，需要支援以下三種操作：

1. `bool insert(int val)`：將元素 `val` 插入到集合中，即使該元素已存在。返回值為 `true` 當該元素之前不在集合中，否則返回 `false`。
2. `bool remove(int val)`：從集合中移除一個 `val`，如果 `val` 存在，則返回 `true`，否則返回 `false`。如果有多個相同元素，只移除其中一個。
3. `int getRandom()`：隨機返回集合中的一個元素。每個元素被返回的機率應與它在集合中的出現次數成正比。

要求所有操作在平均 $O(1)$ 的時間複雜度內完成。
 <!--more-->
## 解題思路

這題與[380. Insert Delete GetRandom O(1) ](https://www.catxcoder.com/medium/2024/09/06/380-Insert-Delete-GetRandom-O(1).html)非常類似，只差在能否重複，本題也是藉由與陣列中最後一個交換的思路去做刪除元素的。

為了達到平均 $O(1)$ 的時間複雜度，我們可以使用以下結構來儲存數據：

1. `vector<int> nums`：用來儲存所有的元素。由於 `vector` 支援在尾部插入和刪除操作，這能幫助我們在 $O(1)$ 的時間內進行*隨機取出*、*插入*與*移除*操作。
2. `unordered_map<int, unordered_set<int>> numToIdx`：用來映射每個數字到其在 `nums` 中所有出現的位置。這允許我們在 $O(1)$ 的時間內找到特定值並進行刪除操作。

### 插入操作 (insert)
- 每次插入一個數字時，首先將其插入到 `nums` 的尾部，並將其在 `nums` 中的索引加入到 `numToIdx` 的對應集合中。
- 如果該數字之前不在集合中，返回 `true`；否則返回 `false`。

### 刪除操作 (remove)
- 若 `numToIdx` 中找不到 `val`，直接返回 `false`。
- 若找到，隨便取一個 `val` 在 `nums` 中的索引，然後將 `nums` 尾部的數字與這個索引對應的數字進行交換，並更新 `numToIdx` 中的索引信息，最後將 `nums` 尾部的數字刪除。
- 若該數字的所有出現位置都已被刪除，將其從 `numToIdx` 中刪除。

### 隨機獲取 (getRandom)
- 直接從 `nums` 中隨機返回一個元素。由於 `nums` 儲存了所有的元素，並且每個元素的出現次數和集合中的數據一致，所以可以通過 `rand()` 函數隨機選取一個索引，達到返回隨機元素的效果。

## Python 實作

```python
class RandomizedCollection:
    def __init__(self):
        self.nums = []  # 儲存所有的數字
        self.num_to_idx = {}  # 映射數字到其索引的集合

    def insert(self, val: int) -> bool:
        # 插入數字到nums，並更新索引
        not_present = val not in self.num_to_idx
        if not_present:
            self.num_to_idx[val] = set()
        self.nums.append(val)
        self.num_to_idx[val].add(len(self.nums) - 1)
        return not_present

    def remove(self, val: int) -> bool:
        if val not in self.num_to_idx or len(self.num_to_idx[val]) == 0:
            return False
        # 取出val的其中一個索引
        remove_idx = next(iter(self.num_to_idx[val]))
        self.num_to_idx[val].remove(remove_idx)
        last_val = self.nums[-1]
        
        # 若不是最後一個元素，交換移除位置和最後一個元素
        if remove_idx != len(self.nums) - 1:
            self.nums[remove_idx] = last_val
            self.num_to_idx[last_val].remove(len(self.nums) - 1)
            self.num_to_idx[last_val].add(remove_idx)
        
        self.nums.pop()
        
        if len(self.num_to_idx[val]) == 0:
            del self.num_to_idx[val]
        
        return True

    def getRandom(self) -> int:
        return random.choice(self.nums)
```

## C++ 實作
```cpp
class RandomizedCollection {
public:
    RandomizedCollection() {
        
    }
    
    bool insert(int val) {
        bool nopresent = numToIdx.find(val)==numToIdx.end();
        nums.push_back(val);
        numToIdx[val].insert(nums.size()-1);
        return nopresent;
    }
    
    bool remove(int val) {
        if (numToIdx.find(val)==numToIdx.end()) return false;
        int delIdx = *(numToIdx[val].begin());
        numToIdx[val].erase(delIdx);
        if (delIdx != nums.size()-1){
            numToIdx[nums.back()].erase(nums.size()-1);
            numToIdx[nums.back()].insert(delIdx);
            swap(nums[delIdx], nums.back());
        }
        if (numToIdx[val].size()==0) numToIdx.erase(val);
        nums.pop_back();
        return true;
    }
    
    int getRandom() {
        return nums[rand()%nums.size()];
    }
private:
    vector<int> nums;
    unordered_map<int, unordered_set<int>> numToIdx;
};

/**
 * Your RandomizedCollection object will be instantiated and called as such:
 * RandomizedCollection* obj = new RandomizedCollection();
 * bool param_1 = obj->insert(val);
 * bool param_2 = obj->remove(val);
 * int param_3 = obj->getRandom();
 */
 ```

## 時間複雜度分析

1. **插入操作 `insert`**：
   - 插入元素到 `nums` 尾部的時間為 $O(1)$。
   - 更新 `num_to_idx` 時間為 $O(1)$。
   - **總時間複雜度**：$O(1)$。

2. **刪除操作 `remove`**：
   - 找到 `val` 的索引並移除：$O(1)$。
   - 如果刪除的不是最後一個元素，進行交換操作：$O(1)$。
   - **總時間複雜度**：$O(1)$。

3. **隨機返回 `getRandom`**：
   - 隨機返回 `nums` 中的元素：$O(1)$。
   - **總時間複雜度**：$O(1)$。

## 總結

這個題目的關鍵是利用 `vector` 和 `unordered_map<int, unordered_set<int>>` 結合，確保所有操作都能在平均 $O(1)$ 的時間內完成。`vector` 保證了隨機訪問與插入刪除的效率，`unordered_map<int, unordered_set<int>>` 使我們能夠快速地查找元素的位置並進行更新。