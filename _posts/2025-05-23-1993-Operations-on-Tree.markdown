---
layout: article_post
title:  "[Leetcode解題] 1993. Operations on Trees"
description:  "1993. Operations on Tree"
categories: medium
tags: tree dfs bfs
langs: python
excerpt_separator: <!--more-->
---

## 題目
[Operations on Tree](https://leetcode.com/problems/operations-on-tree/)

這題給你一棵以「parent 陣列」形式表示的樹，節點編號從 `0` 到 `n-1`。其中 `parent[i]` 代表節點 `i` 的父節點，而根節點是 `0`，所以 `parent[0] = -1`。

我們要設計一個資料結構 `LockingTree`，可以支援三個操作：
1. `lock(num, user)`：如果節點 `num` 沒有被鎖，讓使用者 `user` 將它鎖住。
2. `unlock(num, user)`：如果節點 `num` 是被使用者 `user` 鎖住的，才可以解鎖。
3. `upgrade(num, user)`：將節點 `num` 鎖住，同時解鎖它的所有子孫(descendants)節點，但必須滿足三個條件：
   * `num` 目前是沒有被鎖的
   * 它的子孫(descendants)中至少有一個節點是被鎖的（不管是誰鎖的）
   * 它的祖先(ancestors)中沒有任何節點被鎖住
<!--more-->

## 解題思路
### 初始化
* `parent`：用來記錄每個節點的父節點。
* `children`：建立一個鄰接表，記錄每個節點有哪些子節點，方便後續遞迴查詢子孫(descendants)。
* `locked`：用來記錄哪個節點被哪個 user 鎖住。值為 0 表示沒被鎖。

### 三個操作：
* `lock(num, user)`：如果目前節點沒有被鎖（`locked[num] == 0`），就鎖住它。
* `unlock(num, user)`：只有當 `locked[num] == user` 才能解鎖。
* `upgrade(num, user)`：
  1. 檢查自己沒被鎖。
  2. 檢查祖先沒人被鎖。
  3. 檢查子孫有至少一個人被鎖，並順便解鎖它們。
  4. 最後將 `num` 鎖住。

## Python 實作
```python
class LockingTree:

    def __init__(self, parent: List[int]):
        self.parent = parent
        self.children = [[] for _ in range(len(parent))]
        for i in range(1, len(parent)):
            self.children[parent[i]].append(i)
        self.locked = [0] * len(parent)  # 0 代表未鎖，否則為 user ID

    def lock(self, num: int, user: int) -> bool:
        if self.locked[num] != 0:
            return False
        self.locked[num] = user
        return True

    def unlock(self, num: int, user: int) -> bool:
        if self.locked[num] != user:
            return False
        self.locked[num] = 0
        return True

    def upgrade(self, num: int, user: int) -> bool:
        if self.locked[num] != 0:
            return False
        if self._has_locked_ancestor(num):
            return False
        if not self._unlock_descendants(num):
            return False
        self.locked[num] = user
        return True

    def _has_locked_ancestor(self, num: int) -> bool:
        while num != -1:
            if self.locked[num] != 0:
                return True
            num = self.parent[num]
        return False

    def _unlock_descendants(self, num: int) -> bool:
        found_locked = False
        for child in self.children[num]:
            found_locked |= self._unlock_descendants(child)
        if self.locked[num] != 0:
            self.locked[num] = 0
            return True
        return found_locked
        
# Your LockingTree object will be instantiated and called as such:
# obj = LockingTree(parent)
# param_1 = obj.lock(num,user)
# param_2 = obj.unlock(num,user)
# param_3 = obj.upgrade(num,user)
```

## C++實作

```cpp
class LockingTree {
public:
    LockingTree(vector<int>& parent):parent(parent) {
        nodeStatus.assign(parent.size(), 0);
        child.resize(parent.size());
        for(auto node=0; node<parent.size(); node++){
            if(parent[node]>=0)
                child[parent[node]].push_back(node);
        }
    }
    
    bool lock(int num, int user) {
        if (nodeStatus[num]!=0) return false;
        nodeStatus[num] = user;
        return true;
    }
    
    bool unlock(int num, int user) {
        if (nodeStatus[num]!=user) return false;
        nodeStatus[num] = 0;
        return true;
    }
    
    bool upgrade(int num, int user) {
        if (isLocked(num)) return false;
        if (hasLockedAncestors(num)) return false;
        if (!unlockDescendants(num)) return false;
        nodeStatus[num] = user;
        return true;
    }

    

private:
    vector<int> nodeStatus; // unlock = 0, or user
    vector<int> parent;
    vector<vector<int>> child;

    bool hasLockedAncestors(int num){
        if (num==-1) return false;
        if (isLocked(num)) return true;
        return hasLockedAncestors(parent[num]);
    }

    bool unlockDescendants(int num){
        bool unlock = false;
        if (nodeStatus[num]) unlock=true;
        nodeStatus[num] = 0;
        for(auto c: child[num]){
            unlock |= unlockDescendants(c);
        }
        return unlock;
    }

    bool isLocked(int num){
        return nodeStatus[num]!=0;
    }

};

/**
 * Your LockingTree object will be instantiated and called as such:
 * LockingTree* obj = new LockingTree(parent);
 * bool param_1 = obj->lock(num,user);
 * bool param_2 = obj->unlock(num,user);
 * bool param_3 = obj->upgrade(num,user);
 */
```

## 時間複雜度分析
* `lock()` 和 `unlock()`：都是 **O(1)**，直接查詢和設定陣列。
* `upgrade()`：
  * `has_locked_ancestor()`：最壞情況會一路查到 root，時間複雜度是 **O(h)**，其中 `h` 是樹的高度。
  * `_unlock_descendants()`：可能會遍歷整個子樹，最壞是 **O(n)**。
  * 所以整體 `upgrade()` 最壞為 **O(n)**。

