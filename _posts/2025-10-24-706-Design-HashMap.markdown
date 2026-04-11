---
layout: article_post
title:  "[Leetcode解題] 706. Design HashMap"
description:  "706. Design HashMap"
categories: easy
tags: hashmap
langs: python
excerpt_separator: <!--more-->
---

## 題目
[706. Design HashMap](https://leetcode.com/problems/design-hashmap)

實作一個 `MyHashMap` 類別，**不能**用內建的雜湊表（像 Python 的 `dict`、C++ 的 `unordered_map`）：
* `MyHashMap()`：初始化為空表
* `void put(int key, int value)`：插入 (key, value)，若 key 已存在則更新 value
* `int get(int key)`：回傳 key 對應的 value；若不存在回傳 `-1`
* `void remove(int key)`：刪除 key 與其對應的 value（若存在）
<!--more-->

## 解題思路
HashMap 的核心概念是「**雜湊函式 (hash)** 把 key 映射到一個**桶 (bucket)**」，再在該桶裡處理碰撞（collision）。

這題用 **Chaining** 碰撞處理：

* 準備一個固定大小的桶陣列 `buckets`（大小取一個質數較佳，例如 10007），
* `index = key % bucket_size` 找到桶位，
* 在 `buckets[index]` 的串列中線性搜尋該 key：
  * `put`：找到就更新，找不到就 append
  * `get`：找到回傳 value，否則 -1
  * `remove`：找到就刪掉該節點

> 為什麼選質數做桶數？
> 一般經驗：質數大小能降低某些特定 key 分布造成的碰撞機率，平均分布更好。


## Python 實作（不用 `dict`）

```python
class MyHashMap:
    def __init__(self, bucket_size: int = 10007):
        # 使用質數作為桶數
        self.M = bucket_size
        # 每個桶是一個list，放 (key, value) pair
        self.buckets = [[] for _ in range(self.M)]

    def _idx(self, key: int) -> int:
        # 針對 int key 的簡單雜湊
        return key % self.M

    def put(self, key: int, value: int) -> None:
        i = self._idx(key)
        bucket = self.buckets[i]
        for j, (k, v) in enumerate(bucket):
            if k == key:
                bucket[j] = (key, value)  # 更新
                return
        bucket.append((key, value))       # 新增

    def get(self, key: int) -> int:
        i = self._idx(key)
        bucket = self.buckets[i]
        for k, v in bucket:
            if k == key:
                return v
        return -1

    def remove(self, key: int) -> None:
        i = self._idx(key)
        bucket = self.buckets[i]
        # 線性掃描刪除第一個匹配 key
        for j, (k, v) in enumerate(bucket):
            if k == key:
                # 將最後一個元素換到 j，O(1) 刪除；直接 pop(j) 也行（O(n)）
                bucket[j] = bucket[-1]
                bucket.pop()
                return
```


## C++ 參考實作（不用 `unordered_map`）

```cpp
class MyHashMap {
public:
    MyHashMap(int bucket_size = 10007) : size(bucket_size), buckets(bucket_size) {}

    void put(int key, int value) {
        int i = idx(key);
        for (auto &p : buckets[i]) {
            if (p.first == key) {
                p.second = value; // 更新
                return;
            }
        }
        buckets[i].push_back({key, value}); // 新增
    }

    int get(int key) {
        int i = idx(key);
        for (auto &p : buckets[i]) {
            if (p.first == key) return p.second;
        }
        return -1;
    }

    void remove(int key) {
        int i = idx(key);
        for (auto it = buckets[i].begin(); it != buckets[i].end(); ++it) {
            if (it->first == key) {
                buckets[i].erase(it); // list erase 是 O(1)
                return;
            }
        }
    }

private:
    int size;
    vector<list<pair<int,int>>> buckets;

    int idx(int key) const {
        return key%size;
    }
};

/**
 * Your MyHashMap object will be instantiated and called as such:
 * MyHashMap* obj = new MyHashMap();
 * obj->put(key,value);
 * int param_2 = obj->get(key);
 * obj->remove(key);
 */
```

## 時間與空間複雜度

* 設總元素數為 `n`，桶數為 `M`。
* **平均情況（假設雜湊夠均勻）**：
  * `put / get / remove` ≈ **O(1)**
* **最壞情況（全部擠到同一桶）**：
  * `put / get / remove` = **O(n)**
* **空間複雜度**：**O(n + M)**（元素 + 桶的基礎開銷）
