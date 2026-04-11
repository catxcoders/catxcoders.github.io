---
layout: article_post
title:  "[Leetcode解題] 150. Evaluate Reverse Polish Notation"
description:  "150. Evaluate Reverse Polish Notation"
categories: medium
tags: stack 
langs: python
excerpt_separator: <!--more-->
---

# 150. Evaluate Reverse Polish Notation
## 題目
[150. Evaluate Reverse Polish Notation](https://leetcode.com/problems/evaluate-reverse-polish-notation/)
給你一個以 **逆波蘭表示法（Reverse Polish Notation, RPN）** 表示的算術運算式，`tokens` 是一個字串陣列，代表這個算術表達式。請你計算並回傳該運算式的結果，保證結果和中間運算過程中的所有數字都可以用 32 位元整數表示。
<!--more-->

## 解題思路：
1. **理解逆波蘭表示法**：
   - 它是一種後序表示法，操作數先出現，接著是操作符。
   - 舉例：表達式 `(3 + 4) * 5` 在 RPN 表示為 `["3", "4", "+", "5", "*"]`。

2. **計算方式**：
   - 使用一個**堆疊**（`stack`）來儲存數字：
     - 如果是數字，就放進`sack`。
     - 如果是運算符號，就從`stack`中取出兩個數字進行計算，並將結果放回`stack`。
   - 繼續以上步驟，直到處理完整個陣列，最後`stack`的唯一值即為結果。

3. **處理運算符**：
   - 支援四種運算：`+`、`-`、`*`、`/`。
   - 特別注意：
     - 整數除法向 0 截斷（例如：`-7 / 3 = -2`）。


## Python 實作：

```python
class Solution:
    def evalRPN(self, tokens: list[str]) -> int:
        stack = []

        for token in tokens:
            if token in "+-*/":  # 檢查是否為運算符
                b = stack.pop()  # 先彈出的是第二個操作數
                a = stack.pop()  # 再彈出的是第一個操作數
                if token == "+":
                    stack.append(a + b)
                elif token == "-":
                    stack.append(a - b)
                elif token == "*":
                    stack.append(a * b)
                elif token == "/":
                    # 注意 Python 的整數除法向零截斷需要用 int()
                    # //（整數除法運算operator），計算結果是向下取整（floor division）
                    stack.append(int(a / b))
            else:
                # 將數字轉型並推入堆疊
                stack.append(int(token))
        
        # 堆疊的最後一個值即為結果
        return stack[0]
```

## C++實作
```cpp
class Solution {
public:
    int evalRPN(vector<string>& tokens) {
        vector<int> nums;

        auto isOps = [](const string &s) {
            return (s == "+" ||s == "-"||s == "*"||s == "/");
        };

        auto cal = [](int &a , const int &b, const string &op) {
            if (op=="+") a+=b;
            if (op=="-") a-=b;
            if (op=="*") a*=b;
            if (op=="/") a/=b;
        };

        for(const auto &token: tokens){
            if (isOps(token)){
                int a = nums.back();
                nums.pop_back();
                cal(nums.back(), a, token);
            }else{
                nums.emplace_back(stoi(token));
            }
        }
        return nums[0];
    }
};
```

## 時間與空間複雜度：
   - 時間複雜度：$O(n)$，其中 $n$ 是 `tokens` 的長度，每個元素最多操作一次。
   - 空間複雜度：$O(n)$，因為`stack`最多存儲 $n$ 個數字。
