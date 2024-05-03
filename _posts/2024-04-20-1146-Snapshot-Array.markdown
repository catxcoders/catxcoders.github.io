---
layout: article_post
title:  "[Leetcode解題] 1146. Snapshot Array"
description:  "[Leetcode解題] 1146. Snapshot Array"
categories: medium 
tags: array binary-search bs
langs: python
excerpt_separator: <!--more-->
---

# 題目

[1146. Snapshot Array](https://leetcode.com/problems/snapshot-array)
你需要實作一個 SnapshotArray 資料結構，支援以下介面：
1. `SnapshotArray(length)`: 初始化一個長度為指定長度的類似陣列結構。最初，每個元素都是0。
2. `set(index, val)`: 設置給定索引`index`的元素為 `val`。
3. `snap()`: 拍攝陣列的快照並返回`快照 ID`，即我們呼叫 `snap()` 的總次數減去1。
4. `get(index, snap_id)`: 返回在給定`快照 ID` 時給定`index`的值。
<!--more-->
---

### 範例：
```python
# 初始化長度為 3 的 SnapshotArray
snapshotArr = SnapshotArray(3)

# 將index 0 的元素設為 5
snapshotArr.set(0, 5)

# 拍攝快照，返回快照 ID 為 0
snapshot_id = snapshotArr.snap()

# 將index 0 的元素設為 6
snapshotArr.set(0, 6)

# 返回快照 ID 為 0 時index 0 的值，應為 5
value = snapshotArr.get(0, 0)
# Output: 5
```
# 解題思路：
為了實作 SnapshotArray，我們可以使用一個巢狀列表結構。
- **外部列表**: 每個元素代表陣列的一個`index`。
- **內部列表**: 該`index`的`value`的歷史記錄。內部列表中的每個項目都包含`快照 ID` 和 `value`。


```python
class SnapshotArray:
    def __init__(self, length: int):
        self.snapTime = 0
        self.array = [[[0, 0]]  for _ in range(length)]

    def set(self, index: int, val: int) -> None:
        self.array[index].append([self.snapTime, val])

    def snap(self) -> int:
        self.snapTime += 1
        return self.snapTime - 1

    def get(self, index: int, snap_id: int) -> int:
        idx = bisect.bisect_right(self.array[index], [snap_id, 1000000001])
        return self.array[index][idx - 1][1]

```

# 時間複雜度分析：
- `SnapshotArray(length)`: 初始化需要 $O(n)$ 的時間，其中 $n$ 是陣列的長度。
- `set(index, val)`: 設置一個元素只需 $O(1)$ 的時間，因為它只涉及向陣列添加元素。
- `snap()`: 拍攝快照也只需 $O(1)$ 的時間，因為它只是增加一個計數器。
- `get(index, snap_id)`: 按特定快照 $ID$ 檢索值需要 $O(logn)$ 的時間，因為使用 `bisect_right` 進行二分查找。
