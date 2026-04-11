---
layout: article_post
title:  "[Leetcode解題]  3169. Count Days Without Meetings"
description:  "[Leetcode解題]  3169. Count Days Without Meetings"
categories: medium
tags: two-pointer greedy
langs: python
excerpt_separator: <!--more-->
---

## 題目

[3169. Count Days Without Meetings](https://leetcode.com/problems/count-days-without-meetings/)

給你一個正整數 days，表示員工可以工作的總天數（從第 1 天開始）。你還得到一個大小為 n 的二維數組 meetings，其中 meetings[i] = [start_i, end_i] 表示第 i 次會議的開始和結束天數（包括起止天）。

返回員工可以工作但沒有安排會議的天數。

注意：會議可能會重疊。
<!--more-->

## 解題思路

這題我們想到需要做`merge interval`，所以先將每個區間作排列，然後再進行merge。

merge的方法就是透過greedy的方式，如果現在這個區間的結束位置大於下個區間的起始位置，那就吃掉下個區間，並更新新的結束區間`cur_end = max(cur_end, next_end)`，注意這邊我們一定要取max而不能直接更新為下個區間的結束區間。

這題我們甚至可以不用每個merge好的區間，我們只要確定不能繼續merge，就計算該區間的會議日數量，最後再以總日數扣掉會議日即為答案

## 程式碼

```python
class Solution(object):
    def countDays(self, days, meetings):
        """
        :type days: int
        :type meetings: List[List[int]]
        :rtype: int
        """
        meetings = sorted(meetings, key=lambda x: x[0])
        meeting_days = 0
        s = meetings[0][0]
        e = meetings[0][1]
        for meeting in meetings[1:]:
            if e >= meeting[0]-1:
                e = max(e, meeting[1])
                # [1, 5], [2, 100], [3, 10]
            else:
                meeting_days += e-s+1
                s = meeting[0]
                e = meeting[1]
        meeting_days += e-s+1
        return days-meeting_days
```

## 時間複雜度

因為進行區間排序需耗時$O(lnogn)$，而進行greedy的merge只需耗時$O(n)$，所以時間複雜度為$O(nlogn)$，$n$為區間數量。

