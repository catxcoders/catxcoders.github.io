---
layout: article_post
title:  "[Leetcode解題] 2818. Apply Operations to Maximize Score"
description:  "2818. Apply Operations to Maximize Score"
categories: hard
tags: monotonic-stack
langs: python
excerpt_separator: <!--more-->
---

# 題目
[2818. Apply Operations to Maximize Score](https://leetcode.com/problems/apply-operations-to-maximize-score)
你有一個長度為 `n` 的正整數陣列 `nums`，以及一個整數 `k`。
你初始分數為 `1`，可以最多進行 `k` 次以下操作來最大化你的分數：

1. **選擇一段未被選過的子陣列 `nums[l, ..., r]`。**
2. **在這段子陣列中，選擇一個具有**「最高質因數個數 (prime score)」**的元素 `x`：**
   - 若有多個數有同樣的質因數個數，選擇**最左邊的那一個**。
3. **將當前分數乘上 `x`。**

質因數個數的定義：一個整數有多少**不同的質因數**。
例如：300 = 2² × 3 × 5²，因此它的質因數個數是 3（分別為 2, 3, 5）。

請回傳最大可能的分數，結果請對 `10^9 + 7` 取模。
<!--more-->

# 解題思路

## Step 1: 計算每個數字的質因數個數（prime score）
### 解法一：暴力質因數分解 - Trial Division（較慢 ❗）
對每個數字 x：
- 從 2 開始除，直到 √x
- 每找到一個可以整除的質因數，就重複除到不能除
### 解法二：線性篩法 （推薦 ✅）
利用 **線性篩法（Sieve of Eratosthenes）**，我們可以計算每個數字對應的質因數個數，並記錄在一個陣列中。
- 從小到大找質數，像在篩選質數那樣掃過去
- 每當找到一個質數，就把它標記到所有倍數上（因為那些倍數都含這個質因數）
- 每個數被幾個質數標記過，就表示它有幾個不同的質因數

## Step 2: 對每個 `nums[i]`，計算它作為「主角」可擴張的子陣列數量
我們要知道這個元素能被用來多少次，這其實就是：

- 向左找到第一個 **prime score 大於等於它** 的元素。
- 向右找到第一個 **prime score 大於它** 的元素。

透過這些資訊，我們可以算出以它為最大 prime score 元素的子陣列個數（也就是它能被使用的次數）。


### 方法一：雙指針解法（較慢 ❗）

對每個 `nums[i]` 向左右延伸，直到遇到不滿足條件的為止：
- 往左走到第一個 Prime Score ≥ `ps[i]`
- 往右走到第一個 Prime Score > `ps[i]`

然後計算：
```text
count[i] = (i - left) * (right - i)
```

**程式碼（Python）：**
```python
for i in range(n):
    l = i - 1
    while l >= 0 and prime_scores[l] <= prime_scores[i]:
        l -= 1
    r = i + 1
    while r < n and prime_scores[r] < prime_scores[i]:
        r += 1
    count[i] = (i - l) * (r - i)
```
### 方法二：Monotonic stack解法（推薦 ✅）
> 不熟悉Monotonic stack的，可以先學習一下，並練習一下這題 [739. Daily Temperatures](https://www.catxcoder.com/medium/2023/11/24/739-daily-temperatures.html)

使用兩個Monotonic stack找出：
- `left[i]`：**左邊第一個 Prime Score ≥ `ps[i]` 的位置**
- `right[i]`：**右邊第一個 Prime Score > `ps[i]` 的位置**

可用次數為：

```text
count[i] = (i - left[i]) * (right[i] - i)
```

**為何這樣設計？**
- 左邊用「大於等於」，右邊用「大於」，可以保證分割出的範圍唯一、互不重疊。
- 這樣每個主角的有效範圍不會與別人重複，符合「每段子陣列只能用一次」的條件。

## Step 3: 貪心選擇
接著，我們將所有的候選 `(num, prime_score, 可用次數)` 按照 `num` 值 **由大到小排序**，因為我們希望乘上的數越大越好。

然後，我們從大到小一個一個乘上去，直到總共用了 `k` 次為止。


# Python 實作

```python
class Solution:
    MOD = 10**9 + 7

    def maximumScore(self, nums: List[int], k: int) -> int:
        def get_prime_score_table(limit: int) -> List[int]:
            """
            回傳一個陣列，其中 index 對應的值表示該整數的不同質因數個數（prime score）。
            """
            prime_scores = [0] * (limit + 1)
            for i in range(2, limit + 1):
                if prime_scores[i] > 0:
                    continue
                for j in range(i, limit + 1, i):
                    prime_scores[j] += 1
            return prime_scores

        def get_num_prime_scores(nums: List[int]) -> List[int]:
            """
            回傳每個 nums[i] 對應的 prime score。
            """
            max_val = max(nums)
            table = get_prime_score_table(max_val)
            return [table[num] for num in nums]

        def find_left_boundaries(scores: List[int]) -> List[int]:
            """找出每個位置左側第一個 prime score >= 自己的位置"""
            left = [-1] * len(scores)
            stack = []
            for i in range(len(scores)):
                while stack and scores[stack[-1]] < scores[i]:
                    stack.pop()
                left[i] = stack[-1] if stack else -1
                stack.append(i)
            return left

        def find_right_boundaries(scores: List[int]) -> List[int]:
            """找出每個位置右側第一個 prime score > 自己的位置"""
            right = [len(scores)] * len(scores)
            stack = []
            for i in reversed(range(len(scores))):
                while stack and scores[stack[-1]] <= scores[i]:
                    stack.pop()
                right[i] = stack[-1] if stack else len(scores)
                stack.append(i)
            return right

        n = len(nums)
        max_val = max(nums)
        prime_scores = get_num_prime_scores(nums)

        left = find_left_boundaries(prime_scores)
        right = find_right_boundaries(prime_scores)

        # 建立候選清單，格式：(value, 可用次數)
        candidates = []
        for i in range(n):
            max_count = (i - left[i]) * (right[i] - i)
            candidates.append((nums[i], min(max_count, k)))

        # 按照數值遞減排序以利貪心選取
        candidates.sort(reverse=True)

        # 執行貪心乘法操作
        score = 1
        for val, cnt in candidates:
            if k == 0:
                break
            use = min(cnt, k)
            score = (score * pow(val, use, self.MOD)) % self.MOD
            k -= use

        return score

```

# C++ 實作

```cpp
class Solution {
public:
    static constexpr int mod = 1e9 + 7; 
    struct Candidate{
        int num;
        int count;
    };

    int fastPow(long long base, int exp) {
        long long res = 1;
        base %= mod;
        while(exp > 0) {
            if(exp & 1) res = (res * base) % mod;
            base = (base * base) % mod;
            exp >>= 1;
        }
        return res;
    }

    vector<int> getPrimeScoreTable(int maxNum) {
        vector<int> primeScores(maxNum + 1, 0);
        for (int i = 2; i <= maxNum; i++) {
            if (primeScores[i] > 0) continue;
            for (int j = i; j <= maxNum; j += i) {
                primeScores[j]++;
            }
        }
        return primeScores;
    }

    vector<int> getNumPrimScore(vector<int>& nums) {
        int maxNum = *max_element(nums.begin(), nums.end());
        vector<int> table = getPrimeScoreTable(maxNum);
        vector<int> result;
        for (int num : nums) result.push_back(table[num]);
        return result;
    }

    vector<Candidate> getCandidates(vector<int>& nums, int k){
        vector<int> primeScores = getNumPrimScore(nums);
        int n = nums.size();
        vector<int> left(n), right(n);
        stack<int> st;

        for(int i = 0; i < n; i++){
            while(!st.empty() && primeScores[st.top()] < primeScores[i]){
                st.pop();
            }
            left[i] = st.empty() ? -1 : st.top();
            st.push(i);
        }

        while(!st.empty()) st.pop();

        for(int i = n - 1; i >= 0; i--){
            while(!st.empty() && primeScores[st.top()] <= primeScores[i]){
                st.pop();
            }
            right[i] = st.empty() ? n : st.top();
            st.push(i);
        }

        vector<Candidate> candidates;
        for(int i = 0; i < n; i++){
            int count = min((long long) (i - left[i]) * (right[i] - i), (long long )k); 
            candidates.push_back({nums[i], count});
        }
        sort(candidates.begin(), candidates.end(), [](const Candidate& a, const Candidate& b){
            return a.num > b.num;
        });
        return candidates;
    }

    int maximumScore(vector<int>& nums, int k) {
        vector<Candidate> candidates = getCandidates(nums, k);
        long long score = 1;
        for(auto info: candidates){
            if (k==0) break;
            int time = min(k, info.count);
            score = (score * fastPow(info.num, time)) % mod;
            k -= time;
        }
        return score;
    }
};
```

---

# 複雜度分析

- **時間複雜度**：
  - 計算 prime scores：`O(N log log N)`（$N$ 為 `max(nums)`）
      - 我們在計算一個整數 $x$ 的 **prime score**：也就是 $x$ 擁有多少個**不同的質因數**。 
這段程式碼就是我們用來計算 $0$ ~ $N$ 每個數字的 prime score：
        ```cpp
        for (int i = 2; i <= N; ++i) {
            if (primeScores[i] > 0) continue;   // 不是質數就跳過
            for (int j = i; j <= N; j += i) {
                primeScores[j] += 1;  // j 被質因數 i 整除，記錄進去
            }
        }
        ```
        這裡的關鍵在於**內層迴圈執行的總次數**：

        - 對每個質數 `i`，它會影響所有 `j = i, 2i, 3i, ..., N`，共約 `N/i` 次
        - 所以整體工作量是：$\sum_{i=2}^{N} \frac{N}{i} \cdot \mathbf{1}_{\text{i 是質數}}$
        - 這可以近似為：$N \cdot \sum_{p \leq N, p\ 是質數} \frac{1}{p}$
        - 而根據數論的結果，這個質數倒數和的近似是：$\sum_{p \leq N} \frac{1}{p} \approx \log \log N$
  - 對每個元素計算擴展區間：`O(n)`（兩次monotonic stack）
  - 排序 candidates：`O(n log n)`
  - 所以總體為 `O(n log n + N log log N)`

- **空間複雜度**：
  - `O(n + N)`，其中 $N$ 為最大數值、$n$ 為陣列長度




