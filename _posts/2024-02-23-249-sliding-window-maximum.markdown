---
layout: article_post
title:  "[Leetcode解題] 239. Sliding Window Maximum"
description:  "[Leetcode解題] 239. Sliding Window Maximum"
categories: hard 
tags: monotonic-queue deque queue
langs: python
excerpt_separator: <!--more-->
---

# 239. Sliding Window Maximum

# 題目

[239. Sliding Window Maximum](https://leetcode.com/problems/sliding-window-maximum/description/)

給定一個陣列$nums$，以及`sliding window size` $k$，找出每個`sliding window`下的`max`。

<!--more-->

# 解題思路

我們先觀察一下題目，由於我們想要找`max`，所以可能會想到要用`k-size`的`heap`來存放元素，這樣我們每次只要比`root`，就可以知道有沒有比上一輪的sliding window最大的元素大，但要這麼做的前提是我們每移動一格，最左邊的元素要被剔除，而用heap有點難做到這件事情。

所以若要做到這一點，使用單調佇列(monotonic queue)可以做到這一點，我們`queue`裡面存`index`，以便我們可以更方便的剔除`sliding window`外的元素。

實際的作法是，我們讓一個`deque`裡面是遞減的放元素，這樣我們能確保最左邊可以保留最大的元素，而我們不在意在`sliding window`中任何比最右邊元素小的元素，因為它們不會影響到結果，比如說我們有一個window裡面有`[4, 5, 6]`，那4和5其實已經完全沒有用了，因為6是最大且最靠右的值，所以當我們繼續往右slide，可能會影響結果的只有`6`，我們可以從這個角度切入想到使用`monotonic queue`的作法。

另外，使用`deque`，可以讓我們在移除元素時時間複雜度為$O(1)$。

```python=
from collections import deque
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        d = deque()
        res = []
        for i in range(k-1):
            while d and nums[i] > nums[d[-1]]:
                d.pop()
            d.append(i)

        for i in range(k-1, len(nums)):
            if d and i - d[0] >= k:
                d.popleft()

            while d and nums[i] > nums[d[-1]]:
                d.pop()
            d.append(i)
            res.append(nums[d[0]])
        return res
```

```cpp=
class Solution {
public:
    vector<int> maxSlidingWindow(vector<int>& nums, int k) {
        deque<int> deq;
        vector<int> ans;
        for(int i=0; i<nums.size(); i++){
            while(!deq.empty() && nums[deq.back()]<nums[i]) deq.pop_back();
            deq.push_back(i);
            if (i<k-1) continue;
            while(!deq.empty() && deq.front()<=i-k) deq.pop_front();
            ans.push_back(nums[deq.front()]);
        }
        
        return ans;
    }
};
```

# 時間複雜度

因為每個元素最多都只會進出一次`deque`，所以$O(n)$