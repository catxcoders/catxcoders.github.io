---
layout: article_work
title:  "Python動態規劃(Dynamic Programing)"
tags: dp
excerpt_separator: <!--more-->
---

## 1. **什麼是動態規劃？**

動態規劃（Dynamic Programming）是一種解決問題的算法技術，通常用於優化問題，其中**問題可以被分解成子問題**，並且每個**子問題的解決方案可以被重複**使用以解決原始問題。動態規劃在許多領域中都有廣泛的應用，如最短路徑、背包問題、字符串比對等。

## 2. **基本概念**

動態規劃的核心思想是利用之前計算的結果來加速當前計算，以減少不必要的計算時間。主要包含以下幾個步驟：

1. **定義子問題**：將原始問題分解成若干個子問題。
2. **建立狀態轉移方程**：確定每個子問題的解決方案如何與其他子問題關聯，通常使用遞迴方程表示。
3. **初始化**：初始化子問題的初始狀態，通常是基本情況的解。
4. **轉移方程計算**：使用狀態轉移方程來計算每個子問題的解。
5. **儲存中間結果**：通常使用數組或字典等數據結構來儲存中間結果，以避免重複計算。
6. **返回原始問題的解**：根據子問題的結果計算原始問題的解。

動態規劃和遞迴都可以用於解決問題，但它們之間存在重要的區別：

- **遞迴**：遞迴是一種自我調用的過程，它將問題分解成子問題，但通常不會儲存中間結果。這可能導致重複計算，效率較低。
- **動態規劃**：動態規劃儲存中間結果，以減少重複計算，並且通常用迭代而非遞迴的方式求解。它更適用於需要計算相同子問題多次的情況。

## 3. **範例：計算斐波那契數列**

讓我們使用動態規劃來計算斐波那契數列的第n項。

```python
def fibonacci(n):
    if n <= 1:
        return n

    # 初始化儲存斐波那契數的List
    fib = [0] * (n + 1)
    fib[1] = 1

    for i in range(2, n + 1):
        fib[i] = fib[i - 1] + fib[i - 2]

    return fib[n]
```

在這個範例中，我們使用一個數組 **`fib`** 來儲存計算的中間結果，以避免重複計算，從而提高效率。

## 4. **動態規劃與遞迴的差異**

遞迴版本的斐波那契數列計算：

```python
def fibonacci_recursive(n):
    if n <= 1:
        return n
    else:
        return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)
```

斐波那契數列中**遞迴方法**和**動態規劃**方法的比較:

| 特性 | 遞迴方法 | 動態規劃方法 |
| --- | --- | --- |
| 實作方式 | 純粹的遞迴，每次計算n-1和n-2的斐波那契數 | 使用迭代計算，儲存中間結果 |
| 效率 | 低效率，指數級時間複雜度 | 高效率，線性時間複雜度 |
| 空間複雜度 | 遞迴深度隨n增加而增加，可能stack overflow | 線性空間複雜度，使用數組 |
| 適用於大數據 | 不適合，計算效率太低 | 適合，計算效率高 |
| 可讀性 | 簡單，直接遞迴求解 | 複雜一些，需要使用循環和數組 |
| 常見的應用場景 | 教育和簡單示例，小型輸入 | 實際應用中，大型輸入的計算 |

## 5. **應用場景**

動態規劃廣泛應用於以下場景：

1. **背包問題（Knapsack Problem）**：
    - 場景：在有限的背包容量下，選擇物品以最大化總價值，如0/1背包和分數背包問題。
        
        ```python
        def knapsack(weights, values, capacity):
            n = len(weights)
            dp = [[0] * (capacity + 1) for _ in range(n + 1)]
        
            for i in range(1, n + 1):
                for w in range(capacity + 1):
                    if weights[i - 1] <= w:
                        dp[i][w] = max(dp[i - 1][w], dp[i - 1][w - weights[i - 1]] + values[i - 1])
                    else:
                        dp[i][w] = dp[i - 1][w]
        
            return dp[n][capacity]
        ```
        
2. **最長共同子序列問題（Longest Common Subsequence）**：
    - 場景：找到兩個序列中的最長共同子序列，如文本比對和基因序列比對。
        
        ```python
        def longest_common_subsequence(s1, s2):
            m, n = len(s1), len(s2)
            dp = [[0] * (n + 1) for _ in range(m + 1)]
        
            for i in range(1, m + 1):
                for j in range(1, n + 1):
                    if s1[i - 1] == s2[j - 1]:
                        dp[i][j] = dp[i - 1][j - 1] + 1
                    else:
                        dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
        
            return dp[m][n]
        ```
        
3. **字符串編輯距離（Edit Distance）**：
    - 場景：計算將一個字符串轉換為另一個字符串所需的最小編輯操作次數，如Levenshtein距離。
        
        ```python
        def edit_distance(s1, s2):
            m, n = len(s1), len(s2)
            dp = [[0] * (n + 1) for _ in range(m + 1)]
        
            for i in range(m + 1):
                for j in range(n + 1):
                    if i == 0:
                        dp[i][j] = j
                    elif j == 0:
                        dp[i][j] = i
                    elif s1[i - 1] == s2[j - 1]:
                        dp[i][j] = dp[i - 1][j - 1]
                    else:
                        dp[i][j] = 1 + min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1])
        
            return dp[m][n]
        ```
        

## 6. **總結**

動態規劃是一個強大的算法技術，用於解決優化問題，通過將問題分解成子問題並儲存中間結果，可以有效提高計算效率。希望這份教學文件能幫助你理解動態規劃的基本概念和應用。

## 7. **練習**

以下是一些練習，可以幫助你鞏固本文所介紹的動態規劃概念：

1. [1035. Uncrossed Lines](https://www.catxcoder.com/medium/2023/06/03/1035.-Uncrossed-Lines.html)
2. [3. Longest Substring Without Repeating Characters](https://www.catxcoder.com/medium/2022/02/11/3-Longest-Substring-Without-Repeating-Characters.html)
3. [1626. Best Team With No Conflicts](https://www.catxcoder.com/medium/2023/05/20/1626Best-Team-With-No-Conflicts.html)
4. [300. Longest Increasing Subsequence](https://www.catxcoder.com/medium/2022/02/11/300-Longest-Increasing-Subsequence.html)
5. [53. Maximum Subarray](https://www.catxcoder.com/medium/2022/02/11/53-Maximum-Subarray.html)
6. [72. Edit Distance](https://www.catxcoder.com/hard/2022/02/11/72-edit-distance.html)