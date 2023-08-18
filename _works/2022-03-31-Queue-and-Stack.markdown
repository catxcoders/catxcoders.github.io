---
layout: article_work
title:  "隊列(Queue)和堆疊(Stack)"
tags: Queue Stack
excerpt_separator: <!--more-->
---

# 隊列(Queue)和堆疊(Stack)


序列是一種線性數據結構，就是元素會按照一定的順序排列。今天我們要介紹兩種基本的序列，就是隊列(Queue)和堆疊(Stack)。

<!--more-->

# 什麼是隊列（Queue）？

隊列是一種先進先出（FIFO）的數據結構，其中添加到隊列的元素位於隊列的末尾，而從隊列中刪除的元素位於隊列的前端。換句話說，隊列是一個按照先進先出原則排列元素的容器。

以下是隊列的一些基本操作：

- `enqueue(item)`：將一個元素添加到隊列的末尾
- `dequeue()`：從隊列的前端刪除一個元素
- `isEmpty()`：檢查隊列是否為空
- `size()`：返回隊列中元素的數量

{% graphviz %}
digraph G {
    node [shape=record, style=filled, fillcolor=grey93]
    front[style=invis]
    front -> node1:f1 [headlabel="front", color=white, style=dotted, arrowhead=none, labelangle=0]
    back[style=invis]
    back -> node1:f5 [headlabel="back", color=white, style=dotted, arrowhead=none, labelangle=0]
    node1 [label="<f1> 1 |<f2> 2 |<f3> 3 | <f4> 4 | <f5> 5 "]
    6 [width=0.2, fillcolor=slategray1]
    6:s -> node1:e [label="  enqueue()", style=dashed]
    0 [width=0.2, fillcolor=slategray1]
    node1:w -> 0:n [label="  dequeue()", style=dashed]
}
{% endgraphviz %}

## Python中的隊列(Queue)

以下是 Python 中 Queue 常用的函數和方法：

- `queue.Queue(maxsize=0)`：創建一個新的隊列。maxsize 可以用來限制隊列的大小，如果 maxsize < 0 或者為 0，則隊列大小沒有限制。
- `qsize()`：返回隊列的大小。
- `empty()`：如果隊列為空，則返回 True，否則返回 False。
- `full()`：如果隊列已滿，則返回 True，否則返回 False。
- `put(item, block=True, timeout=None)`：將一個元素添加到隊列的末尾。如果隊列已滿且 block 為 True，則會等待 timeout 秒，如果還是沒有空位則會報錯。如果 block 為 False，則會立即報錯。
- `get(block=True, timeout=None)`：從隊列的前端刪除一個元素。如果隊列為空且 block 為 True，則會等待 timeout 秒，如果還是沒有元素則會報錯。如果 block 為 False，則會立即報錯。

以下是 Python 的範例：

```python
from queue import Queue

# 創建一個隊列
q = Queue()

# 添加元素
q.put('a')
q.put('b')
q.put('c')

# 刪除元素
q.get()  # 'a'

# 查看隊列大小
q.qsize()  # 2

# 檢查隊列是否為空
q.empty()  # False
```

# 什麼是堆疊（Stack）？

堆疊是一種後進先出（LIFO）的數據結構，其中添加到堆疊的元素位於堆疊的頂部，而從堆疊中刪除的元素也位於堆疊的頂部。換句話說，堆疊是一個按照後進先出原則排列元素的容器。

以下是堆疊的一些基本操作：

- `push(item)`：將一個元素添加到堆疊的頂部
- `pop()`：從堆疊的頂部刪除一個元素
- `isEmpty()`：檢查堆疊是否為空
- `size()`：返回堆疊中元素的數量

{% graphviz %}
digraph G {
    node [shape=record, style=filled, fillcolor=grey93]
    front[style=invis]
    front -> node1:f1 [headlabel="front", color=white, style=dotted, arrowhead=none, labelangle=0]
    back[style=invis]
    back -> node1:f5 [headlabel="back", color=white, style=dotted, arrowhead=none, labelangle=0]
    node1 [label="<f1> 1 |<f2> 2 |<f3> 3 | <f4> 4 | <f5> 5 "]
    6 [width=0.2, fillcolor=slategray1]
    6:s -> node1:ne [label="  push()", style=dashed]
    0 [width=0.2, fillcolor=slategray1]
    node1:e -> 0:n [label="  pop()", style=dashed]
}
{% endgraphviz %}

## Python中的堆疊（Stack）

- `list.append(item)`：將一個元素添加到列表的末尾，相當於 push(item)
- `list.pop()`：從列表的末尾刪除一個元素，相當於 pop()
- `len(list)`：返回列表的大小，相當於 size()
- `not list`：如果列表為空，則返回 True，否則返回 False，相當於 isEmpty()

以下是 Python 的範例：

```python
# 創建一個堆疊
stack = []

# 添加元素
stack.append('a')
stack.append('b')
stack.append('c')

# 刪除元素
stack.pop()  # 'c'

# 查看堆疊大小
len(stack)  # 2

# 檢查堆疊是否為空
not stack  # False
```

# 隊列(Queue)和堆疊(Stack)的運用

隊列(Queue)和堆疊(Stack)是計算機科學中最基本的資料結構之一。它們廣泛用於算法設計和程式開發中。

其中一個常見的例子是瀏覽器的歷史記錄。當您在瀏覽器中打開一個新的網頁時，該網頁的 URL 將被添加到瀏覽器的歷史記錄中。如果您想返回上一頁，則瀏覽器將從歷史記錄的末尾（即最後一個訪問的 URL）開始向後瀏覽。

另一個例子是遞迴函數。當一個函數被調用時，它的局部變量和參數被存儲在堆疊中。當函數返回時，這些變量和參數將被從堆疊中刪除。

# 練習

以下是隊列和堆疊的一些練習：

- [20-Valid-Parentheses](https://www.catxcoder.com/easy/2022/02/11/20-Valid-Parentheses.html)
- [32-Longest-Valid-Parentheses](https://www.catxcoder.com/medium/2023/05/26/32-Longest-Valid-Parentheses.html)