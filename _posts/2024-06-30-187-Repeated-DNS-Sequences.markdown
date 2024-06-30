---
layout: article_post
title:  "[Leetcode解題] 187. Repeated DNA Sequences - 使用hashtable解+4進位"
description:  "Repeated DNA Sequences"
categories: medium 
tags: array hash hashtable bit
langs: python
excerpt_separator: <!--more-->
---

# 題目

[187. Repeated DNA Sequences](https://leetcode.com/problems/repeated-dna-sequences/)

給定一個字串，回傳重複出現一次以上並且長度為十的子字串。

 <!--more-->

# 解題思路

這題我們其實可以透過hashmap就能簡單解，只要造一個hashmap，然後紀錄每個長度為10字串出現的次數，再回傳超過兩次的key即可。但這麼做會有幾個步驟會造成浪費，像是hashmap會存很多字串，以及每次都需要做一個字串的slice。

```python
class Solution(object):
    def findRepeatedDnaSequences(self, s):
        """
        :type s: str
        :rtype: List[str]
        """
        if len(s) < 10:
            return []
        hm = defaultdict(int)
        for i in range(len(s)-9):
            hm[s[i:i+10]] += 1
        ans = []
        for k, v in hm.items():
            if v > 1:
                ans.append(k)
        return ans
```

我們可以發現，其實只有4種可能的字元，所以其實每個字串，可以用4進位來表示。所以我們每次要判斷下一個子字串，要去掉第一個位數，並加下一個位數，可以透過以下三個步驟：

1. 對`pow(4, 9)`取餘數
2. 乘以4
3. 加上下一個位數

[AAAAACCCCC]T
[0000011111]3
[]
1*4^4+1*4^3+...

得到的數值會對應到獨一無二長度為十的子字串。

# 程式碼

```python
class Solution(object):
    def findRepeatedDnaSequences(self, s):
        """
        :type s: str
        :rtype: List[str]
        """
        def encode(c):
            if c == 'A':
                return 0
            if c == 'C':
                return 1
            if c == 'G':
                return 2
            if c == 'T':
                return 3
        
        def decode(v):
            if v == 0:
                return 'A'
            if v == 1:
                return 'C'
            if v == 2:
                return 'G'
            if v == 3:
                return 'T'
        
        if len(s) < 10:
            return []
        
        val = 0
        for i in range(10):
            val += pow(4, 9-i) * encode(s[i])
        
        encoded = {val}
        repeated_encoded_dns = set()
        e = 10
        POW_49 = pow(4, 9)
        while e < len(s):
            val = val % POW_49 * 4 + encode(s[e])
            e += 1
            if val in encoded:
                repeated_encoded_dns.add(val)
            encoded.add(val)
        
        decoded = []
        for num in repeated_encoded_dns:
            chars = []
            for i in range(10):
                bit = num % 4
                num = num // 4
                chars.append(decode(bit))
            chars.reverse()
            decoded.append(''.join(chars))
        return decoded
                    
```

# 時間複雜度

要跑過整個初始字串，所以時間複雜度為$O(n)$，$n$為字串長度。