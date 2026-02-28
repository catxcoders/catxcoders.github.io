---
layout: article_post
title:  "[Leetcode解題] 1680. Concatenation of Consecutive Binary Numbers"
description:  "同餘定理"
categories: medium
tags: bit, bit_operations
langs: python
excerpt_separator: <!--more-->
---

# 911. Online Election

## 題目
[1680. Concatenation of Consecutive Binary Numbers](https://leetcode.com/problems/concatenation-of-consecutive-binary-numbers/description/)

給定一個整數n，要回傳從1到n以二進位相連接起來的數（以十進位表示）

舉例來說，n=3

1 + 10 + 11 = 11011，回傳27

回傳的數字要對$10^9+7$取餘數

<!--more-->

## 解題思路

這題我們可以從餘數定理推出來，我們每次相加，都把當前的數字往左移x位，然後再加上新的值

因為左移是一個乘法運算，加上新值是個加法運算，都能適用於餘數定理，所以我們可以每次再直接取餘數

## bit_length

我們在這題會使用的bit_length這個函式來得知要左移幾位，這底層實作是直接去調用CPU的operation像LZCNT(Leading Zero Count)或CLZ(Counting Leading Zeros)

如果透過`math.ceiling(math.log2(x))+1`就會比較慢

## 同餘定理

同餘定理就是「在除以 $M$ 的世界裡，先運算再取餘數，等於先取餘數再運算」。這能讓你在數字變得巨大之前，先把縮小它們。

比如加法

$$ (a+b) (mod M) = [(a (mod M)) + (b (mod M))]$$

乘法

$$ (a \times b) (mod M) = [(a (mod M)) \times (b (mod M))]$$

指數的情況，可以先對底數取餘數再進行指數運算（可由乘法推導）

$$ (a^b) (mod M) = [(a (mod M))^b]$$


## Python 實作

```python
class Solution:
    def concatenatedBinary(self, n: int) -> int:
        MOD = pow(10, 9) + 7
        ans = 0
        for i in range(1, n+1):
            num_shifts = i.bit_length()
            ans = ans << num_shifts | i
            ans = ans % MOD
        return ans
 ```

## 時間複雜度

$O(n)$