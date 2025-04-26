---
layout: article_post
title:  "[Leetcode解題] 2261. K Divisible Elements Subarrays"
description:  "2261. K Divisible Elements Subarrays"
categories: medium
tags: array rolling-hash hash trie
langs: python
excerpt_separator: <!--more-->
---

# 題目
[2261. K Divisible Elements Subarrays](https://leetcode.com/problems/k-divisible-elements-subarrays/description/)

給定一個矩陣，跟兩個數字`k`跟`p`，求不相等的`subarray`並且矩陣內可被`p`整除的數量不超過`k`個的數目。

<!--more-->

# 雙層迴圈+hash

這題我們題目主要的重點在於如何判斷兩個`subarray`是否相等，而整除的部分，我們只需要設定一個判定式`prune`就可以

最直接的做法是，我們用兩層迴圈，去判斷所有`subarray`，如果超過整除個數就continue，然後透過一個set來存放矩陣

這邊牽扯到要如何`hash`一個`subarray`

在python中，list是mutable，所以是inhashable，不能直接被放進set裡面，我們必須將它轉成immutable的類別

但你會發現，這麼做時間複雜度可能會來到$O(n^3)$


```python
class Solution:
    def countDistinct(self, nums: List[int], k: int, p: int) -> int:
        ans = set()
        for i in range(len(nums)):
            cnt = 0
            for j in range(i, len(nums)):
                if nums[j] % p == 0:
                    cnt += 1
                if cnt > k:
                    break
                ans.add(tuple(nums[i:j+1]))
        return len(ans)
```

# Rolling hash

我們可以用更好的hash function，透過設定一個BASE跟大質數MOD，由於題目給定每個數字小於等於200

所以BASE可以設定為200，然後MOD設定一個大的質數，像是`10**9+7`

但是這樣可能會發生collision，要找到適合不會發生碰撞的BASE跟MOD有點難


# Trie

我們也可以透過Trie來判斷有沒有發生重複的`subarray`，如果發生重複的狀況就跳過

```python
class TrieNode:
    def __init__(self):
        self.children = {}

class Solution:
    def countDistinct(self, nums: List[int], k: int, p: int) -> int:
        root = TrieNode()
        count = 0
        n = len(nums)

        for i in range(n):
            node = root
            div_count = 0
            for j in range(i, n):
                if nums[j] % p == 0:
                    div_count += 1
                if div_count > k:
                    break
                if nums[j] not in node.children:
                    node.children[nums[j]] = TrieNode()
                    count += 1
                node = node.children[nums[j]]
        
        return count

```