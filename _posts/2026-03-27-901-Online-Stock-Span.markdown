---
layout: article_post
title:  "[Leetcode解題] 901. Online Stock Span"
description:  "901. Online Stock Span"
categories: medium
tags: monotonic-stack
langs: python
excerpt_separator: <!--more-->
---

## 題目
[901. Online Stock Span](https://leetcode.com/problems/online-stock-span/)
設計一個資料結構 `StockSpanner`，用來處理股票每日價格，並回傳當天的 **span（跨度）**。

<!--more-->

### Span 定義
某一天的 span 是：
> 從今天往前數，**連續幾天的股價 ≤ 今天價格**
### 範例

```
輸入: [7, 2, 1, 2]
今天 price = 2
→ span = 4
```

```
輸入: [7, 34, 1, 2]
今天 price = 8
→ span = 3
```

### 需要實作的類別

```cpp
StockSpanner()

int next(int price)
```

## 解題思路（Monotonic Stack）

### 暴力解法（不建議）

每次往回掃描：

```
while (前一天價格 <= 今天價格)
```

最壞情況 O(n²)（例如單調遞增）

### 最佳解：單調遞減棧（Monotonic Decreasing Stack）

- 核心觀察: 當今天價格 `price` 出現時： 所有「比它小或等於的歷史價格」都可以被合併，因為它們 **不會再影響未來答案**
- Stack 存什麼？
我們不只存價格，而是：`(pair: price, span)`
表示：這個價格往前已經 cover 多少天

# 範例推演

輸入：

```
[100, 80, 60, 70, 60, 75, 85]
```

stack 變化：

```
100 → [(100,1)]
80  → [(100,1),(80,1)]
60  → [(100,1),(80,1),(60,1)]
70  → pop 60 → [(100,1),(80,1),(70,2)]
60  → [(100,1),(80,1),(70,2),(60,1)]
75  → pop 60,70 → [(100,1),(80,1),(75,4)]
85  → pop 75,80 → [(100,1),(80,6)]
```

## C++ 實作

```cpp
class StockSpanner {
public:
    stack<pair<int, int>> st;

    StockSpanner() {
        
    }
    
    int next(int price) {
        int cnt = 1;
        
        while (!st.empty() && st.top().first <= price) {
            cnt += st.top().second;
            st.pop();
        }
        
        st.push({price, cnt});
        return cnt;
    }
};
```

## Python 實作

```python
class StockSpanner:

    def __init__(self):
        self.st = []  # [(price, span)]

    def next(self, price: int) -> int:
        cnt = 1
        
        while self.st and self.st[-1][0] <= price:
            cnt += self.st[-1][1]
            self.st.pop()
        
        self.st.append((price, cnt))
        return cnt
```


## 複雜度分析
- 時間複雜度

| 操作        | 複雜度      |
| --------- | -------- |
| next() 單次 | 平均 $O(1)$  |
| 總體（n 次）   | **$O(n)$** |

因為每個元素只會 `push` 跟 `pop` 一次

- 空間複雜度
最壞情況完全遞減
$O(n)$
