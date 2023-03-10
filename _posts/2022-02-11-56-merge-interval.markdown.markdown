---
layout: article_post
title:  "56. Merge Intervals"
categories: medium
tags: leetcode medium python greedy
excerpt_separator: <!--more-->
---

題目網址: [56. Merge Intervals](https://leetcode.com/problems/merge-intervals/)

## 題目
給定一個區間陣列`intervals(List[List[int]])`，其中 `intervals[i] = [start_i, end_i]`，合併所有重疊區間，並返回覆蓋輸入中所有區間的非重疊區間陣列。

### 例子 1:
區間陣列: intervals = [[1,3],[2,6],[8,10],[15,18]]

由於區間 [1,3] 與 [2,6] 重疊, 將這兩個區間合併，區間為 [1,6]。
其餘區間都沒有重疊，就直接保留。

合併重疊區間後的陣列為: [[1,6],[8,10],[15,18]]

## 解題思路
要把**所有**重疊的區間合併起來，合併成一個新的區間，最後返回一個不重疊的區間陣列`ans`。

1. 先把輸入的區間按照開始時間排序，這樣才能保證我們遍歷到的區間是按照時間順序來的。
2. 定義一個新的答案陣列`ans`，將第一個區間加入答案陣列`ans`裡。
3. 然後從第二個區間開始遍歷輸入的區間陣列`intervals`。
    3.1 如果遍歷到的這個區間`[start_i, end_i]`和答案陣列`ans`中最後一個區間`[start_last, end_last]`有重疊，那就合併這兩個區間。
**判斷是否重疊**(判斷區間`[start_i, end_i]`與答案陣列`ans`中最後一個區間`[start_last, end_last]`是否重疊): 由於輸入的區間是按照時間序被排序過的，因此答案陣列中的每個區間的開始時間都不晚於現在遍歷到的區間，(`start_i>=start_last`)，而且每個區間的`end`都比`start`晚，因此如果`start_i<end_last`，則代表兩個區間重疊。
**合併區間**: 把答案陣列`ans`中最後一個區間的結束時間`end_last`更新為兩個區間結束時間的最大值(`max(end_last, end_i)`)。
    3.2 如果沒有重疊，就把這個區間加入答案陣列`ans`。
4. 遍歷結束後，返回答案陣列`ans`。

## 實作
```python
class Solution:
    def merge(self, intervals: List[List[int]]) -> List[List[int]]:
        intervals.sort()
        ans = []

        for interval in intervals:
            if not ans or interval[0] > ans[-1][1]:
                ans.append(interval)
            else:
                ans[-1][1] = max(ans[-1][1], interval[1])
                
        return ans
```
## 時間複雜度

這個做法的時間複雜度是$O(nlogn)$，其中n是區間的數量。

主要的時間複雜度來自於第一步：對輸入區間進行排序。 這個排序過程使用了 sort() 函數，它的時間複雜度是$O(nlogn)$。
接下來的遍歷和合併區間的過程，時間複雜度是$O(n)$。

因此，總時間複雜度為$O(nlogn)$。
