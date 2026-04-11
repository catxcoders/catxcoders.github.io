---
layout: article_post
title:  "[Leetcode解題] 2034. Stock Price Fluctuation"
description:  "[Leetcode解題] 2034. Stock Price Fluctuation"
categories: medium 
tags: hashTable heap
langs: python
excerpt_separator: <!--more-->
---

# 題目：
[2034. Stock Price Fluctuation](https://leetcode.com/problems/stock-price-fluctuation/)
你會拿到一堆股票價格的記錄，每個記錄包含一個時間戳記和對應的股價。不幸的是，這些記錄不是按照順序來的。更糟糕的是，有些記錄可能是錯誤的。之後可能會有一條相同時間戳記的記錄出現在流中，用來更正之前錯誤的記錄價格。

### 你需要設計一個算法：
1. 更新特定時間的股票價格，從之前的任何記錄中更正該時間的價格。
2. 基於當前記錄找到股票的最新價格。最新價格是記錄的最新時間的價格。
3. 找到股票在當前記錄中的最高價格。
4. 找到股票在當前記錄中的最低價格。

### 實現 StockPrice 類：

- `StockPrice()`: 初始化沒有價格記錄的對象。
- `void update(int timestamp, int price)`: 更新給定時間戳的股票價格。
- `int current()`: 返回股票的最新價格。
- `int maximum()`: 返回股票的最高價格。
- `int minimum()`: 返回股票的最低價格。
<!--more-->

# 解題思路：

- 我們使用一個*hash table*來存儲每個時間戳對應的股票價格。
- 我們還需要使用*max heap*和*min heap*來實時維護最高價格和最低價格
- 當更新價格時，我們同時更新*hash table*和兩個*heap*。
- 獲取最新價格只需查找*hash table*中最後一個時間戳記對應的價格。
- 獲取**最高價格**和**最低價格**時，我們從*max heap*和*min heap*中彈出過期的價格，直到找到還在有效期內的價格。

# Python 實作：

```python
class StockPrice:
    def __init__(self):
        self.time_to_price = {}
        self.max_heap = []
        self.min_heap = []
        self.timestamp = 0
    
    def update(self, timestamp, price):
        self.time_to_price[timestamp] = price
        heapq.heappush(self.max_heap, (-price, timestamp))
        heapq.heappush(self.min_heap, (price, timestamp))
        self.timestamp = max(self.timestamp, timestamp)
    
    def current(self):
        return self.time_to_price[self.timestamp]
    
    def maximum(self):
        while self.max_heap[0][1] not in self.time_to_price or self.time_to_price[self.max_heap[0][1]] != -self.max_heap[0][0]:
            heapq.heappop(self.max_heap)
        return -self.max_heap[0][0]
    
    def minimum(self):
        while self.min_heap[0][1] not in self.time_to_price or self.time_to_price[self.min_heap[0][1]] != self.min_heap[0][0]:
            heapq.heappop(self.min_heap)
        return self.min_heap[0][0]
```
# C++實作
```cpp
class StockPrice {
public:
    StockPrice():t(0) {
        
    }
    
    void update(int timestamp, int price) {
        timeToPrice[timestamp] = price;
        maxHeap.push({price, timestamp});
        minHeap.push({price, timestamp});
        t = max(t, timestamp);
    }
    
    int current() {
        return timeToPrice[t];
    }
    
    int maximum() {
        while(expired(maxHeap.top())) maxHeap.pop();
        return maxHeap.top().first;
    }
    
    int minimum() {
        while(expired(minHeap.top())) minHeap.pop();
        return minHeap.top().first;
    }
private:
    int t;
    unordered_map<int, int> timeToPrice;
    priority_queue<pair<int, int>> maxHeap;
    priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> minHeap;
    bool expired(const pair<int, int> &priceTime){
        auto &price = priceTime.first;
        auto &time = priceTime.second;
        return (timeToPrice[time]!=price);
    }
};

/**
 * Your StockPrice object will be instantiated and called as such:
 * StockPrice* obj = new StockPrice();
 * obj->update(timestamp,price);
 * int param_2 = obj->current();
 * int param_3 = obj->maximum();
 * int param_4 = obj->minimum();
 */
```
# 時間複雜度分析：
- `update` 方法的時間複雜度為 $O(logN)$，其中 $N$ 為記錄的數量。這是由於在*heap*中插入元素的時間複雜度為 $O(logN)$。
- `current` 方法的時間複雜度為 $O(1)$，因為它只需返回*hash table*中最後一個時間戳對應的價格。
- `maximum` 和 `minimum` 方法的時間複雜度為 $O(NlogN)$，其中 $N$ 為記錄的數量。這是由於在*heap*中查找最大和最小元素的時間複雜度為 $O(1)$，但移除無效的元素的時間複雜度為 $O(logN)$，總共最多會移除$N$個元素，因此時間複雜度為$O(NlogN)$。