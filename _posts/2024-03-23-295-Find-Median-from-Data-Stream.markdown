---
layout: article_post
title:  "[Leetcode解題] 295. Find Median from Data Stream - 使用heap解"
description:  "[Leetcode解題] 295. Find Median from Data Stream - 使用heap解"
categories: hard 
tags: heap priority-queue
langs: python
excerpt_separator: <!--more-->
---

## 題目
[295. Find Median from Data Stream](https://leetcode.com/problems/find-median-from-data-stream/)
中位數是排序整數列表中的中間值。如果列表的大小是偶數，則沒有中間值，中位數是兩個中間值的平均值。

例如，對於 arr = [2,3,4]，中位數為 3。
例如，對於 arr = [2,3]，中位數為 (2 + 3) / 2 = 2.5。

實現 class MedianFinder：
**MedianFinder():** 初始化 MedianFinder。
**void addNum(int num):** 將整數 `num` 從資料流添加到資料結構中。
**double findMedian():** 返回到目前為止所有元素的中位數。
<!--more-->

## 解題思路：
我們使用兩個 **proirity queue (優先隊列)** 來維護陣列的左半部分和右半部分。左半部分使用`Max Heap`來存儲，右半部分使用`Min Heap`來存儲。`Max Heap`中的元素都小於或等於`Min Heap`中的元素。

在添加新元素時，我們根據以下步驟維護兩個Heap(堆)的平衡：
- 如果右半部分的元素多於左半部分，則將`Min Heap`的頂部元素移動到`Max Heap`。
- 如果左半部分的元素比右半部分多於一個，則將`Max Heap`的頂部元素移動到`Min Heap`。
- 這樣保證了中位數始終是Max Heap的頂部元素，或是兩個堆頂部元素的平均值（如果列表大小為偶數）。

## 代碼實作：
```python
class MedianFinder:
    def __init__(self):
        self.max_heap = []   # 存放Data Stream前半部分，加負號使min_heap變成max_heap
        self.min_heap = []   # 存放Data Stream後半部分

    def addNum(self, num: int) -> None:
        if not self.max_heap or num <= -self.max_heap[0]:
            heapq.heappush(self.max_heap, -num)
        else:
            heapq.heappush(self.min_heap, num)

        # 調整兩個heap的大小
        if len(self.max_heap) > len(self.min_heap) + 1:
            heapq.heappush(self.min_heap, -heapq.heappop(self.max_heap))
        elif len(self.min_heap) > len(self.max_heap):
            heapq.heappush(self.max_heap, -heapq.heappop(self.min_heap))

    def findMedian(self) -> float:
        if len(self.max_heap) == len(self.min_heap):
            return (-self.max_heap[0] + self.min_heap[0]) / 2
        else:
            return -self.max_heap[0]
        


# Your MedianFinder object will be instantiated and called as such:
# obj = MedianFinder()
# obj.addNum(num)
# param_2 = obj.findMedian()
```

##
```cpp
class MedianFinder {
public:
    MedianFinder() {
        _size=0;
    }

    void balance(){
        auto lSize = maxHeap.size();
        auto rSize = minHeap.size();
        if (rSize>lSize){
            maxHeap.push(minHeap.top());
            minHeap.pop();
        }else if (lSize>rSize+1){
            minHeap.push(maxHeap.top());
            maxHeap.pop();
        }
    }
    
    void addNum(int num) {
        _size++;
        if (maxHeap.empty()) maxHeap.push(num);
        else if (num<maxHeap.top()) maxHeap.push(num);
        else minHeap.push(num);
        balance();
    }
    
    double findMedian() {
        if (_size%2==0){
            return (double(maxHeap.top())+double(minHeap.top()))/2;
        }
        return maxHeap.top();
    }
private: 
    size_t _size;
    priority_queue<int> maxHeap; // for first n/2 elements
    priority_queue<int, vector<int>, greater<int>> minHeap; // for last n/2 elements
};

/**
 * Your MedianFinder object will be instantiated and called as such:
 * MedianFinder* obj = new MedianFinder();
 * obj->addNum(num);
 * double param_2 = obj->findMedian();
 */
```

## 時間複雜度：
- 添加數字（addNum）的時間複雜度為 $O(log n)$，其中 $n$ 是資料流中的元素數量。
- 查找中位數（findMedian）的時間複雜度為 $O(1)$。