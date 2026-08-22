---
layout: article_post
title:  "[Leetcode解題] 1169. Invalid Transactions"
description:  "1169. Invalid Transactions"
categories: medium
tags: array string simulation
langs: python c++
excerpt_separator: <!--more-->
---

## 題目

[1169. Invalid Transactions](https://leetcode.com/problems/invalid-transactions/description/)

給定一個字串陣列 `transactions`，每筆交易的格式為：

```text
name,time,amount,city
```

一筆交易只要符合以下任一條件，就可能是無效交易：

1. 交易金額 `amount` 大於 `1000`。
2. 存在另一筆交易，兩者的 `name` 相同、`city` 不同，而且交易時間相差不超過 `60` 分鐘。

請回傳所有可能無效的交易，順序不限。

<!--more-->

### 範例

```text
輸入：transactions = ["alice,20,800,mtv", "alice,50,100,beijing"]
輸出：["alice,20,800,mtv", "alice,50,100,beijing"]
```

兩筆交易都是 `alice`，時間相差 `30` 分鐘，且城市不同，因此兩筆都要標記為無效。

## 解題思路：分組、排序與滑動視窗

每筆交易包含四項資訊，若每次比較時都重新切割字串，程式會變得冗長。因此先將所有字串解析成方便使用的資料：

- `name`：交易者名稱。
- `time`：交易時間，轉成整數。
- `amount`：交易金額，轉成整數。
- `city`：交易城市。

接著建立 boolean array `invalid`，其中 `invalid[i]` 表示第 `i` 筆交易是否無效，並使用原始索引保存交易順序。

### 條件一：金額超過 1000

解析每筆交易時，若 `amount > 1000`，直接將該筆交易標記為無效。

注意題目使用的是「超過」1000，因此金額剛好等於 `1000` 仍然有效。

### 條件二：同名、不同城市、相差不超過 60 分鐘

直覺做法是枚舉任意兩筆交易，時間複雜度為 $O(n^2)$。我們可以進一步最佳化：

1. 先依照 `name` 將交易分組，因為不同名稱之間不可能互相影響。
2. 將同一組內的交易依 `time` 排序。
3. 使用滑動視窗維護目前交易之前 `60` 分鐘內的所有交易。
4. 使用雜湊表 `city_count` 記錄視窗內各城市的交易數量。

假設視窗內共有 `window_size` 筆交易，而其中與目前交易同城市的有 `same_city_count` 筆，那麼不同城市的交易數量就是：

```text
different_city_count = window_size - same_city_count
```

只要 `different_city_count > 0`，就代表視窗中至少存在一筆不同城市的交易，目前交易應被標記為無效。換句話說，當 `window_size == same_city_count` 時，視窗中的交易全部來自相同城市，不會觸發這項無效條件。

### 為什麼要掃描兩次？

按照時間由小到大掃描時，視窗只包含目前交易之前的交易，因此只能判斷「過去 `60` 分鐘」是否有衝突。

但一筆交易也可能只和未來的交易衝突。為了不漏掉這種情況，再將順序反轉，從時間由大到小掃描一次。第二次就能判斷「未來 `60` 分鐘」是否有衝突。

兩次掃描合起來，便涵蓋目前交易前後 `60` 分鐘內的所有交易。

這裡還有兩個容易忽略的細節：

- 「within 60 minutes」包含剛好相差 `60` 分鐘，所以只有時間差 `> 60` 時才移出視窗。
- 交易可能重複出現，因此要以原始索引標記，而不能只用交易字串作為 key。

## 範例推演

假設輸入為：

```text
["alice,20,800,mtv",
 "alice,50,1200,beijing",
 "bob,80,900,mtv"]
```

首先檢查金額：

- 第 0 筆金額為 `800`，尚未被標記。
- 第 1 筆金額為 `1200`，標記為無效。
- 第 2 筆金額為 `900`，尚未被標記。

接著將 `alice` 的交易依時間排序並掃描：

- 掃描第 1 筆時，視窗內包含第 0 筆。兩者城市不同，時間相差 `30` 分鐘，因此第 1 筆無效。
- 反向掃描第 0 筆時，視窗內包含第 1 筆，因此第 0 筆也無效。
- `bob` 會被放在另一組，不會與 `alice` 的交易比較。

最後回傳前兩筆交易。

## C++ 實作

```cpp
class Solution {
private:
    struct Transaction {
        string name;
        int time;
        int amount;
        string city;
    };

    Transaction parse(const string& s) {
        stringstream ss(s);
        string name, time, amount, city;

        getline(ss, name, ',');
        getline(ss, time, ',');
        getline(ss, amount, ',');
        getline(ss, city, ',');

        return {name, stoi(time), stoi(amount), city};
    }

public:
    vector<string> invalidTransactions(vector<string>& transactions) {
        int n = transactions.size();
        vector<Transaction> records;
        vector<bool> invalid(n, false);
        unordered_map<string, vector<int>> indices_by_name;

        for (int i = 0; i < n; ++i) {
            records.push_back(parse(transactions[i]));
            indices_by_name[records[i].name].push_back(i);

            if (records[i].amount > 1000) {
                invalid[i] = true;
            }
        }

        auto scan = [&](const vector<int>& order) {
            int left = 0;
            unordered_map<string, int> city_count;

            for (int right = 0; right < order.size(); ++right) {
                int current = order[right];

                while (left < right &&
                       abs(records[current].time - records[order[left]].time) > 60) {
                    --city_count[records[order[left]].city];
                    ++left;
                }

                int window_size = right - left;
                int same_city_count = city_count[records[current].city];
                int different_city_count = window_size - same_city_count;

                if (different_city_count > 0) {
                    invalid[current] = true;
                }

                ++city_count[records[current].city];
            }
        };

        for (auto& [name, indices] : indices_by_name) {
            sort(indices.begin(), indices.end(), [&](int a, int b) {
                return records[a].time < records[b].time;
            });

            scan(indices);
            reverse(indices.begin(), indices.end());
            scan(indices);
        }

        vector<string> answer;
        for (int i = 0; i < n; ++i) {
            if (invalid[i]) {
                answer.push_back(transactions[i]);
            }
        }

        return answer;
    }
};
```

## Python 實作

```python
from collections import defaultdict


class Solution:
    def invalidTransactions(self, transactions: List[str]) -> List[str]:
        records = []
        invalid = [False] * len(transactions)
        indices_by_name = defaultdict(list)

        for i, transaction in enumerate(transactions):
            name, time, amount, city = transaction.split(',')
            records.append((name, int(time), int(amount), city))
            indices_by_name[name].append(i)

            if int(amount) > 1000:
                invalid[i] = True

        def scan(order):
            left = 0
            city_count = defaultdict(int)

            for right, current in enumerate(order):
                current_time = records[current][1]

                while (left < right and
                       abs(current_time - records[order[left]][1]) > 60):
                    city_count[records[order[left]][3]] -= 1
                    left += 1

                current_city = records[current][3]
                window_size = right - left
                same_city_count = city_count[current_city]
                different_city_count = window_size - same_city_count

                if different_city_count > 0:
                    invalid[current] = True

                city_count[current_city] += 1

        for indices in indices_by_name.values():
            indices.sort(key=lambda i: records[i][1])
            scan(indices)
            scan(indices[::-1])

        return [
            transactions[i]
            for i in range(len(transactions))
            if invalid[i]
        ]
```

## 正確性說明

對於每筆交易，演算法會檢查所有可能使它無效的情況：

- 若金額大於 `1000`，演算法會在解析時將它標記。
- 若它與另一筆同名交易的時間相差不超過 `60` 分鐘，另一筆交易必定位於正向或反向掃描的視窗中。若兩者城市不同，視窗總數減去同城市數量必定大於零，因此這筆交易會被標記。

因此，所有符合至少一項無效條件的交易都會被加入答案；不符合任何條件的交易則不會被標記，所以回傳結果正好是所有可能無效的交易。

## 複雜度分析

- 時間複雜度：$O(n \log n)$。分組內排序的總成本不超過 $O(n \log n)$，兩次滑動視窗掃描共為 $O(n)$。
- 空間複雜度：$O(n)$。需要儲存解析後的交易、分組、城市計數與標記陣列。
