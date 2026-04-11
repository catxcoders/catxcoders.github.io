---
layout: article_post
title:  "[Leetcode解題] 391. Perfect Rectangle"
description:  "391. Perfect Rectangle"
categories: hard
tags: array
langs: python
excerpt_separator: <!--more-->
---

# 題目
[391. Perfect Rectangle](https://leetcode.com/problems/perfect-rectangle/description/)
給定一組 axis-aligned（軸對齊）矩形，每個矩形由 `[x1, y1, x2, y2]` 定義其左下角和右上角座標。請判斷這些矩形是否能完美拼成一個沒有重疊、沒有缺口的矩形區域。

每個矩形都用 `rectangles[i] = [xi, yi, ai, bi]` 表示，底部左側是 `(xi, yi)`，右上角是 `(ai, bi)`。
<!--more-->
# 解題思路

## 解法一 : 判斷兩兩是否重疊 + 面積是否相等
我們可以從兩個層面來驗證：

1. **兩兩矩形不能重疊**
2. **總面積一致**
我們先計算所有小矩形的總面積，然後對比整個 bounding rectangle 的面積是否相同，如果沒有重疊且面積一致，那肯定沒有空洞。

### C++實作
```cpp
class Solution {
public:
    int getArea(const vector<int>& rect) const {
        return (rect[2] - rect[0]) * (rect[3] - rect[1]);
    }

    bool isOverlap(const vector<int>& A, const vector<int>& B) {
        return !(A[2] <= B[0] || B[2] <= A[0] || A[3] <= B[1] || B[3] <= A[1]);
    }

    vector<int> getBoundingRect(const vector<vector<int>>& rectangles) {
        vector<int> bounding = rectangles[0];
        for (const auto& rect : rectangles) {
            bounding[0] = min(bounding[0], rect[0]);
            bounding[1] = min(bounding[1], rect[1]);
            bounding[2] = max(bounding[2], rect[2]);
            bounding[3] = max(bounding[3], rect[3]);
        }
        return bounding;
    }

    bool isRectangleCover(vector<vector<int>>& rectangles) {
        if (rectangles.size() <= 1) return true;
        int n = rectangles.size();
        int totalArea = 0;

        for (int i = 0; i < n; ++i) {
            totalArea += getArea(rectangles[i]);

            for (int j = i + 1; j < n; ++j) {
                if (isOverlap(rectangles[i], rectangles[j]))
                    return false;
            }
        }

        vector<int> bounding = getBoundingRect(rectangles);
        return totalArea == getArea(bounding);
    }
};

```

### python實作
```python
class Solution:
    def isRectangleCover(self, rectangles):
        def get_area(r):
            return (r[2] - r[0]) * (r[3] - r[1])

        def is_overlap(a, b):
            return not (a[2] <= b[0] or b[2] <= a[0] or a[3] <= b[1] or b[3] <= a[1])

        total_area = 0
        min_x, min_y = float('inf'), float('inf')
        max_x, max_y = float('-inf'), float('-inf')

        n = len(rectangles)
        for i in range(n):
            rect = rectangles[i]
            total_area += get_area(rect)
            min_x = min(min_x, rect[0])
            min_y = min(min_y, rect[1])
            max_x = max(max_x, rect[2])
            max_y = max(max_y, rect[3])

            for j in range(i + 1, n):
                if is_overlap(rect, rectangles[j]):
                    return False

        return total_area == (max_x - min_x) * (max_y - min_y)

```

**使用時機**
- 適用於矩形數量少的測資。
- 簡單直接的方式，可幫助理解基本幾何概念。

## 解法二 : Corner Set + 面積

要判斷是否為完美矩形拼接，必須滿足兩個條件：

1. 面積一致

所有小矩形的總面積 **必須等於** 它們所圍成的大矩形面積（即 bounding rectangle）。

2. 角落檢查

在完美拼接的情況下，所有小矩形的角落坐標會互相抵消（出現偶數次），**唯獨最外框的大矩形的四個角落會出現一次**。因此，我們可以使用一個集合來記錄角落：

- 當一個角落出現偶數次 → 被抵消（從集合中移除）
- 當一個角落只出現一次 → 留在集合中

最終，集合裡應該只剩下大矩形的四個角。


### Python 實作

```python
class Solution:
    def isRectangleCover(self, rectangles):
        corner_set = set()
        area_sum = 0

        min_x = min_y = float('inf')
        max_x = max_y = float('-inf')

        def toggle(corner):
            if corner in corner_set:
                corner_set.remove(corner)
            else:
                corner_set.add(corner)

        for x1, y1, x2, y2 in rectangles:
            area_sum += (x2 - x1) * (y2 - y1)

            min_x = min(min_x, x1)
            min_y = min(min_y, y1)
            max_x = max(max_x, x2)
            max_y = max(max_y, y2)

            corners = [(x1, y1), (x1, y2), (x2, y1), (x2, y2)]
            for c in corners:
                toggle(c)

        expected_area = (max_x - min_x) * (max_y - min_y)
        if area_sum != expected_area:
            return False

        expected_corners = {(min_x, min_y), (min_x, max_y), (max_x, min_y), (max_x, max_y)}
        return corner_set == expected_corners
```


### C++ 實作

```cpp
class Solution {
public:
    struct pair_hash {
        size_t operator()(const pair<int, int>& p) const {
            return hash<long long>()(((long long)p.first << 32) | p.second);
        }
    };

    vector<pair<int, int>> generateCorners(const vector<int>& rect) {
        return {
            {rect[0], rect[1]},  // bottom-left
            {rect[0], rect[3]},  // top-left
            {rect[2], rect[1]},  // bottom-right
            {rect[2], rect[3]}   // top-right
        };
    }

    void toggleCorners(const vector<pair<int, int>>& corners, unordered_set<pair<int, int>, pair_hash>& cornerSet) {
        for (const auto& corner : corners) {
            if (cornerSet.count(corner))
                cornerSet.erase(corner);
            else
                cornerSet.insert(corner);
        }
    }

    int getArea(const vector<int>& rect) const {
        return (rect[2] - rect[0]) * (rect[3] - rect[1]);
    }

    vector<int> getBoudingRect(const vector<vector<int>> &rectangles) {
        vector<int> boundingRect = rectangles[0];
        for (const auto& rect : rectangles) {
            boundingRect[0] = min(boundingRect[0], rect[0]);
            boundingRect[1] = min(boundingRect[1], rect[1]);
            boundingRect[2] = max(boundingRect[2], rect[2]);
            boundingRect[3] = max(boundingRect[3], rect[3]);
        }
        return boundingRect;
    }

    bool isRectangleCover(vector<vector<int>>& rectangles) {
        if (rectangles.size() <= 1) return true;

        int totalArea = 0;
        vector<int> boundingRect = getBoudingRect(rectangles);

        for (const auto& rect : rectangles) 
            totalArea += getArea(rect);

        if (getArea(boundingRect) != totalArea) return false;

        unordered_set<pair<int, int>, pair_hash> cornerSet;
        for (const auto& rect : rectangles) {
            toggleCorners(generateCorners(rect), cornerSet);
        }

        toggleCorners(generateCorners(boundingRect), cornerSet);
        return cornerSet.empty();
    }
};
```

## 複雜度分析比較

| 方法 | 時間複雜度 | 空間複雜度 | 特點 |
|------|------------|------------|------|
| 解法一（Corner Set） | O(n) | O(n) | 高效、適合大測資 |
| 解法二（兩兩比對） | O(n²) | O(1) | 簡單直觀、適合小資料量 |
