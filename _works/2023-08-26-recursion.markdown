---
layout: article_work
title:  "Python遞迴從基礎到應用"
tags: recursion
excerpt_separator: <!--more-->
---

# Python遞迴從基礎到應用

歡迎來到Python遞迴教學！在這篇文章中，我們將從頭開始學習遞迴的概念，並且逐步深入，探討如何在Python中使用遞迴。

## **目錄**

1. 什麼是遞迴？
2. 遞迴的基本原則
3. 簡單的遞迴函式
4. 遞迴 vs. 迴圈
5. 遞迴的應用
6. 遞迴的注意事項
7. 總結

## **1. 什麼是遞迴？**

遞迴是一種在函式內部調用自身的技術。它常常用於解決**可以分解成更小的、相似的子問題**。遞迴的實現可以讓python實作更簡潔、易讀，但需要注意遞迴深度以避免無限循環。

## **2. 遞迴的基本原則**

遞迴的基本原則包括：

- **基本情況**：每個遞迴函式都需要一個基本情況，即不需要再次遞迴的情況。
- **自我調用**：函式內部要調用自己，以處理更小的子問題。
- **問題分解**：問題應該能夠分解成相似但規模較小的子問題。

## **3. 簡單的遞迴函式**

以下是一個簡單的遞迴函式，用於計算一個正整數的階乘：

```python
def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)
```

在這個例子中，函式 **`factorial`** 計算了 n 的階乘。當 n 等於 0 時，基本情況被觸發，返回 1。否則，函式遞迴地調用自己來計算 **`n * factorial(n - 1)`**。

## **4. 遞迴 vs. 迴圈**

遞迴和迴圈都可以用於重複執行代碼，但適用於不同的情境。遞迴通常在解決問題時更為優雅，而迴圈則更適合處理有固定次數迭代的情況。
* **遞迴示例：計算階乘**

```python
def factorial_recursive(n):
    if n == 0:
        return 1
    else:
        return n * factorial_recursive(n - 1)

n = 5
result = factorial_recursive(n)
print(f"{n}的階乘是{result}")
```

在這個例子中，我們使用遞迴來計算 $n!$。我們將問題分解為更小的子問題：$n!$ 等於 $n * (n-1)!$ ，而 $(n-1)!$ 又可以分解為更小的子問題。這種方式更能展示出問題的本質，但在處理大數值時可能效率較低。

* **迴圈示例：計算階乘**

```python
def factorial_with_loop(n):
    if n == 0:
        return 1
    
    factorial = 1
    for i in range(1, n + 1):
        factorial *= i
    
    return factorial

n = 5
result = factorial_with_loop(n)
print(f"{n}的階乘是{result}")
```

在這個例子中，我們使用迴圈來計算$n!$。我們初始化 $factorial$ 為 1，然後從 $1$ 迭代到 $n$，將每個數字乘以 $factorial$，最終得到階乘的結果。使用迴圈計算階乘更加簡潔且有效率，而且對於大數值的處理也更可靠。

## **5. 遞迴的應用**

遞迴在許多算法和數學問題中都有應用，例如：

- **計算斐波那契數列**
斐波那契數列是一個遞迴的經典例子，每個數字都是前兩個數字的和。
    
    ```python
    def fibonacci(n):
        if n <= 0:
            return 0
        elif n == 1:
            return 1
        else:
            return fibonacci(n - 1) + fibonacci(n - 2)

    # 計算前 10 個斐波那契數
    for i in range(1,11):
        print(f"Fibonacci({i}) = {fibonacci(i)}")
    ```
    
- **圖形搜索算法（如深度優先搜索）**
深度優先搜索（DFS）是一種用於圖形搜索的遞迴算法，用於探索可能的路徑，直到到達目標節點或無法繼續搜索為止。
    
    ```python
    graph = {
        'A': ['B', 'C'],
        'B': ['D', 'E'],
        'C': ['F'],
        'D': [],
        'E': ['F'],
        'F': []
    }
    
    visited = set()
    
    def dfs(node):
        if node not in visited:
            print(node, end=' ')
            visited.add(node)
            for neighbor in graph[node]:
                dfs(neighbor)
    
    # 從節點 'A' 開始進行深度優先搜索
    print("DFS結果:")
    dfs('A')
    ```
    

## **6. 遞迴的注意事項**

- **效率問題**：遞迴可能在處理大規模問題時效率較低，因為每次遞迴調用都需要額外的記憶體和操作。
- **遞迴深度限制**：Python對遞迴的深度有限制，超過限制可能引發遞迴過深的錯誤。
- **記憶化遞迴**：有時可以使用記憶化技術來優化遞迴，避免重複計算相同的子問題。

## **7. 總結**

遞迴是一種強大的編程技巧，可以幫助我們解決複雜的問題。通過遵循基本原則，我們可以創建出優雅且高效的遞迴函式。請確保在使用遞迴時考慮效率和遞迴深度，並根據情況考慮使用遞迴或迴圈。希望本文對你理解和運用遞迴有所幫助！

## **8. 練習**
以下是一些練習，可以幫助你鞏固本文所介紹的遞迴概念：
1. [Permutations](https://www.catxcoder.com/medium/2022/02/11/46-Permutations.html)
2. [Combination Sum](https://www.catxcoder.com/medium/2022/02/11/39-Combination-Sum.html)
3. [Validate Binary Search Tree](https://www.catxcoder.com/medium/2023/05/20/98-Validate-Binary-Search-Tree.html)
4. [Generate Parentheses](https://www.catxcoder.com/medium/2022/02/11/22-Generate-Parentheses.html)
5. [Letter Combinations of a Phone Number](https://www.catxcoder.com/medium/2022/02/11/17-Letter-Combinations-of-a-Phone-Number.html)

希望這些練習能幫助你更好地理解遞迴的概念和應用！