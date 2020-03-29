//
//  algorithm.swift
//  MyLib_Example
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 zhoukang. All rights reserved.
//

import Foundation

class Algorithm_leetcode {
    func testAlgorithm() {
        //        print("双指针-最长子串\(Think_DoublePointer().findLongestWord("abpcplea", ["ale","apple","monkey","plea"]))")
        //        print(Algorithm_leetcode.Think_Greed().reconstructQueue([(1, 2),(2, 4),(1, 2)]))
        //        print(Algorithm_leetcode.Think_Greed().reconstructQueue([(7,0), (4,4), (7,1), (5,0), (6,1), (5,2)]))
        //        print(Algorithm_leetcode.Think_Greed().maxProfit([]))
        //                print(Algorithm_leetcode.Think_Greed().isSubsequence("acb", "ahbgdc"))
        //        print(Algorithm_leetcode.Think_Greed().checkPossibility([2,3,3,2,2,4]))
        //        print(Algorithm_leetcode.Think_Greed().maxSubArray([-2,1,-3,4,-1,2,1,-5,4]))
        print(Algorithm_leetcode.Think_Greed().partitionLabels("ababcbacadefegdehijhklij"))
        //
        
    }
    // MARK: LeetCode题解之Swift实现 https://cyc2018.github.io/CS-Notes/#/README
    // 思想之双指针
    class Think_DoublePointer {
        // MARK: 在有序数组中找出两个数，使它们的和为 target
        func twoSum(_ numbers: [Int], _ target: Int) -> (Bool, Int, Int) {
            if numbers.count == 0 {
                return (false, 0, 0)
            }
            
            var i = 0, j = numbers.count - 1
            while i < j {
                let sum = numbers[i] + numbers[j]
                if (sum == target) {
                    return (true, i, j)
                }
                else if (sum < target) {
                    i += 1
                }
                else {
                    j -= 1
                }
            }
            return (false, 0, 0)
        }
        
        // MARK: 判断一个非负整数是否为两个整数的平方和
        func judgeSquareSum(_ target: Int) -> Bool {
            if target < 0 {
                return false
            }
            
            var i = 0, j = Int(sqrtf(Float(target)))
            while i <= j {
                let powSum = i * i + j * j
                if powSum == target {
                    return true
                }
                else if powSum > target {
                    j -= 1
                }
                else {
                    i += 1
                }
            }
            return false
        }
        // MARK: 反转字符串中的元音字符
        func reverseVowels(_ s: String) -> String {
            if s.count == 0 {
                return s
            }
            let vowels: Set<Character> = ["a", "e", "i", "i", "o", "u", "A", "E", "I", "O", "U"]
            var result = Array<Character>()
            for c in s {
                result.append(c)
            }
            var i = 0, j = result.count - 1
            while i <= j {
                let containci = vowels.contains(result[i])
                let containcj = vowels.contains(result[j])
                if !containci {
                    i += 1
                    continue
                }
                if !containcj {
                    j -= 1
                    continue
                }
                (result[i], result[j]) = (result[j], result[i])
                i += 1
                j -= 1
            }
            return String(result)
        }
        
        // MARK: 可以删除一个字符，判断是否能构成回文字符串
        func validPalindrome(_ s: String) -> Bool {
            var chars = Array<Character>()
            for c in s {
                chars.append(c)
            }
            
            func isPalindrome(_ i: Int, _ j: Int) -> Bool {
                var ii = i
                var jj = j
                while ii < jj {
                    if (chars[ii] != chars[jj]) {
                        return false
                    }
                    ii += 1
                    jj -= 1
                }
                return true
            }
            
            var i = 0, j = chars.count - 1
            while i < j {
                if (chars[i] != chars[j]) {
                    return isPalindrome(i, j - 1) || isPalindrome(i + 1, j)
                }
                i += 1
                j -= 1
            }
            return true
        }
        
        // MARK: 归并两个有序数组，把归并结果存到第一个数组上
        func merge(_ nums1: inout [Int], _ nums2: [Int]) {
            if nums1.count == 0 && nums2.count > 0 {
                nums1 += nums2
                return
            }
            if nums1.count > 0 && nums2.count == 0 {
                return
            }
            // 使用两个index
            var index1 = nums1.count - 1, index2 = nums2.count - 1
            // 先扩展nums1的存储空间，原文是假设它有很大的空间，但是我们这里需要扩展一下
            nums1 += nums2
            
            var indexMerge = nums1.count - 1
            
            while index1 >= 0 || index2 >= 0 {
                if index1 < 0 {
                    nums1[indexMerge] = nums2[index2]
                    index2 -= 1
                }
                else if index2 < 0 {
                    nums1[indexMerge] = nums2[index1]
                    index1 -= 1
                }
                else if nums1[index1] > nums2[index2] {
                    nums1[indexMerge] = nums2[index1]
                    index1 -= 1
                }
                else {
                    nums1[indexMerge] = nums2[index2]
                    index2 -= 1
                }
                indexMerge -= 1
            }
        }
        // MARK: 判断链表是否存在环
        func hasCycle(_ head: ListNode?) -> Bool {
            if head == nil {
                return false
            }
            var l1 = head, l2 = head!.next
            while l1 != nil && l2 != nil && l2!.next != nil {
                if l1 === l2 {
                    return true
                }
                l1 = l1?.next
                l2 = l2?.next?.next
            }
            return false
        }
        
        // MARK: 最长子序列，删除 s 中的一些字符，使得它构成字符串列表 d 中的一个字符串，找出能构成的最长字符串。如果有多个相同长度的结果，返回字典序的最小字符串
        func findLongestWord(_ s: String, _ d: [String]) -> String {
            // 判断 target是否是s的子字符串
            func isSubstr(_ target: String, _ s: String) -> Bool {
                var targetChars = [Character]()
                for c in target {
                    targetChars.append(c)
                }
                
                var sChars = [Character]()
                for c in s {
                    sChars.append(c)
                }
                
                var i = 0, j = 0
                while i < sChars.count && j < targetChars.count {
                    if targetChars[j] == sChars[i] {
                        j += 1
                    }
                    i += 1
                }
                return j == targetChars.count
            }
            
            var longestWord = ""
            for target in d {
                let l1 = longestWord.count, l2 = target.count
                if (l1 > l2 || (l1 == l2 && longestWord.compare(target) == .orderedAscending)) {
                    continue
                }
                if isSubstr(target, s) {
                    longestWord = target
                }
            }
            return longestWord
        }
        
    }
    // 思想之排序
    class Think_Sort {
        // 快排的partition 可以用于解决第K个元素的问题
        // 堆排序用于解决 TopK的问题
        
        // MARK: 找到倒数第 k 个的元素
        // 排序 ：时间复杂度 O(NlogN)，空间复杂度 O(1)。不清楚Swift中sort的排序算法是哪个，所以不好定性这里的说法
        func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
            return nums.sorted()[nums.count-k]
        }
        // 堆
        // 快速选择 ：时间复杂度 O(N)，空间复杂度 O(1)
        func findKthLargestQuickSort(_ nums: [Int], _ k: Int) -> Int {
            if k > nums.count || k <= 0 {
                return -1
            }
            let kk = nums.count - k
            // 因为会进行排序，就用mNums接收
            var mNums = nums
            func partition(_ l: Int , _ h: Int ) -> Int {
                func swap(_ i: Int , _ j: Int) {
                    (mNums[i],mNums[j]) = (mNums[j],mNums[i])
                }
                
                /* 切分元素 */
                var i = l, j = h + 1
                while true {
                    i += 1
                    while mNums[i] < mNums[l] && i < h {
                        i += 1
                    }
                    j -= 1
                    while mNums[j] > mNums[l] && j > l {
                        j -= 1
                    }
                    if i >= j {
                        break
                    }
                    swap(i, j)
                }
                
                swap(l, j)
                return j
            }
            
            func findKthSmallest(_ k: Int) {
                var l = 0, h = mNums.count - 1
                while l < h {
                    let j = partition(l, h)
                    if j == k {
                        break
                    }
                    else if j > k {
                        h = j - 1
                    }
                    else {
                        l = j + 1
                    }
                }
            }
            
            findKthSmallest(kk)
            return mNums[kk]
        }
        // 桶排序
        // MARK: 出现频率最多的 k 个元素
        func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
            //设置若干个桶，每个桶存储出现频率相同的数。桶的下标表示数出现的频率，即第 i 个桶中存储的数出现的频率为 i
            var frequencyForNum = Dictionary<Int, Int>.init(minimumCapacity: nums.count)
            for num in nums {
                if let n = frequencyForNum[num] {
                    frequencyForNum[num] = n + 1
                }
                else {
                    frequencyForNum[num] = 1
                }
            }
            
            var buckets = Array<[Int]>(repeating: [], count: nums.count + 1)
            for key in frequencyForNum.keys {
                let frequency = frequencyForNum[key]!
                buckets[frequency].append(key)
            }
            
            var topK = Array<Int>()
            for i in stride(from: buckets.count - 1, through: 0, by: -1) {
                if topK.count >= k {
                    break
                }
                if buckets[i].isEmpty {
                    continue
                }
                if buckets[i].count <= k - topK.count {
                    topK.append(contentsOf: buckets[i])
                }
                else {
                    topK.append(contentsOf: buckets[i][0..<k-topK.count])
                }
            }
            return topK
        }
        // MARK: 按照字符出现次数对字符串排序
        func frequencySort(_ str: String) -> String {
            //设置若干个桶，每个桶存储出现频率相同的数。桶的下标表示数出现的频率，即第 i 个桶中存储的数出现的频率为 i
            var frequencyForNum = Dictionary<Character, Int>.init(minimumCapacity: str.count)
            for c in str {
                if let n = frequencyForNum[c] {
                    frequencyForNum[c] = n + 1
                }
                else {
                    frequencyForNum[c] = 1
                }
            }
            
            var buckets = Array<[Character]>(repeating: [], count: str.count + 1)
            for key in frequencyForNum.keys {
                let frequency = frequencyForNum[key]!
                buckets[frequency].append(key)
            }
            
            var frequencyStr = Array<Character>()
            for i in stride(from: buckets.count - 1, through: 0, by: -1) {
                if buckets[i].isEmpty {
                    continue
                }
                for c in buckets[i] {
                    for _ in 0..<i {
                        frequencyStr.append(c)
                    }
                }
            }
            return String(frequencyStr)
        }
        // MARK: 荷兰国旗问题
        func sortColors(_ nums: [Int]) -> [Int] {
            var mNums = nums
            func swap(_ i: Int , _ j: Int) {
                (mNums[i],mNums[j]) = (mNums[j],mNums[i])
            }
            
            var zero = -1, one = 0, two = nums.count
            while (one < two) {
                if mNums[one] == 0 {
                    zero += 1
                    swap(zero, one)
                    one += 1
                }
                else if nums[one] == 2 {
                    two -= 1
                    swap(two, one)
                }
                else {
                    one += 1
                }
            }
            return mNums
        }
    }
    // 思想之贪心思想
    class Think_Greed {
        // MARK: 分配饼干
        func findContentChildren(_ grid: [Int], _ size: [Int]) -> Int {
            if grid.count == 0 || size.count == 0 {
                return 0
            }
            let mGrid = grid.sorted()
            let mSize = size.sorted()
            var gi = 0, si = 0
            while gi < mGrid.count && si < mSize.count {
                if mGrid[gi] <= mSize[si] {
                    gi += 1
                }
                si += 1
            }
            return gi
        }
        // MARK: 不重叠的区间个数
        func eraseOverlapIntervals(_ intervals: [(start: Int, end: Int)]) -> Int {
            if intervals.count == 0 {
                return 0
            }
            let mIntervals = intervals.sorted { (firstTuple, secondTuple) -> Bool in
                return firstTuple.end < secondTuple.end
            }
            
            var cnt = 1
            var end = mIntervals.first!.end
            for i in 1..<mIntervals.count {
                if mIntervals[i].start < end {
                    continue
                }
                end = mIntervals[i].end
                cnt += 1
            }
            return mIntervals.count - cnt
        }
        // MARK: 投飞镖刺破气球
        func findMinArrowShots(_ intervals: [(start: Int, end: Int)]) -> Int {
            if intervals.count == 0 {
                return 0
            }
            let mIntervals = intervals.sorted { (firstTuple, secondTuple) -> Bool in
                return firstTuple.end < secondTuple.end
            }
            
            var cnt = 1
            var end = mIntervals.first!.end
            for i in 1..<mIntervals.count {
                if mIntervals[i].start <= end {
                    continue
                }
                end = mIntervals[i].end
                cnt += 1
            }
            return cnt
        }
        // MARK: 根据身高和序号重组队列
        typealias People = (height: Int, kNum: Int)
        func reconstructQueue(_ people: [People]) -> [People] {
            if people.count == 0 {
                return [(0, 0)]
            }
            // 身高 h 降序、个数 k 值升序，然后将某个学生插入队列的第 k 个位置中
            let mSortedPeople = people.sorted { (firstP, secondP) -> Bool in
                if firstP.height == secondP.height {
                    return firstP.kNum < secondP.kNum
                }
                else {
                    return firstP.height > secondP.height
                }
            }
            
            // 没办法，没有java里面的linkList，只能自己实现了
            var linkListQueue = Array<Array<People>>.init(repeating: [], count: mSortedPeople.count)
            for p in mSortedPeople {
                let index = p.kNum
                linkListQueue[index].insert(p, at: 0)
            }
            
            var queue = Array<People>()
            for list in linkListQueue {
                for p in list {
                    queue.append(p)
                }
            }
            
            return queue
        }
        // MARK: 买卖股票最大的收益
        func maxProfit(_ prices: [Int]) -> Int {
            if prices.count == 0 {
                return 0
            }
            var soFarMin = prices[0]
            var maxProfit = 0
            for i in 1..<prices.count {
                if soFarMin > prices[i] {
                    // 至今为止最小的波谷
                    soFarMin = prices[i]
                }
                else {
                    // 至今为止最大的波峰
                    maxProfit = max(maxProfit, prices[i] - soFarMin)
                }
            }
            return maxProfit
        }
        // MARK: 买卖股票的最大收益 II
        func maxProfit2(_ prices: [Int]) -> Int {
            var profit = 0
            for i in 1..<prices.count {
                let mProfit = prices[i] - prices[i - 1]
                if mProfit > 0 {
                    profit += mProfit
                }
            }
            return profit
        }
        // MARK: 种植花朵
        func canPlaceFlowers(_ flowerbed: [Int], _ n: Int) -> Bool {
            var mFlowerbed = flowerbed
            let len = mFlowerbed.count
            var cnt = 0
            for i in 0..<len {
                if cnt >= n {
                    break
                }
                if flowerbed[i] == 1 {
                    continue
                }
                let pre = i == 0 ? 0 : mFlowerbed[i - 1]
                let next = i == len - 1 ? 0 : mFlowerbed[i + 1]
                if pre == 0 && next == 0 {
                    cnt += 1
                    mFlowerbed[i] = 1
                }
            }
            return cnt >= n
        }
        // MARK: 判断是否为子序列
        func isSubsequence(_ s: String, _ t: String) -> Bool {
            if t.count == 0 {
                return false
            }
            
            var index = t.startIndex
            for c in s {
                if let tmpIndex = t.suffix(from: index).firstIndex(of: c) {
                    index = t.index(after: tmpIndex)
                }
                else {
                    return false
                }
            }
            return true
        }
        // MARK: 修改一个数成为非递减数组
        func checkPossibility(_ nums: [Int]) -> Bool {
            var cnt = 1
            var mNums = nums
            for i in 1..<mNums.count {
                if mNums[i] < mNums[i - 1] {
                    if cnt == 0 {
                        return false
                    }
                    cnt -= 1
                    if i >= 2 && mNums[i - 2] > mNums[i] {
                        mNums[i] = mNums[i - 1]
                    }
                    else {
                        mNums[i - 1] = mNums[i]
                    }
                }
            }
            return true
        }
        // MARK: 子数组最大的和
        func maxSubArray(_ nums: [Int]) -> Int {
            if nums.count == 0 {
                return 0
            }
            var preSum = nums[0]
            var maxSum = preSum
            for i in 1..<nums.count {
                preSum = preSum > 0 ? preSum + nums[i] : nums[i]
                maxSum = max(maxSum, preSum)
            }
            return maxSum
        }
        // MARK: 分隔字符串使同种字符出现在一起
        func partitionLabels(_ s: String) -> [Int] {
            var lastIndexsOfChar = [Character: Int]()
            var ind = 0
            for c in s {
                lastIndexsOfChar[c] = ind
                ind += 1
            }
            var partitions = [Int]()
            var firstIndex = 0
            while firstIndex < s.count {
                var lastIndex = firstIndex
                for i in firstIndex..<s.count {
                    if i > lastIndex {
                        break
                    }
                    
                    let index = lastIndexsOfChar[s[s.index(s.startIndex, offsetBy: i)]]!
                    if index > lastIndex {
                        lastIndex = index
                    }
                }
                partitions.append(lastIndex - firstIndex + 1)
                firstIndex = lastIndex + 1
            }
            return partitions
        }
    }
    // 思想之二分查找
    class Think_BinarySearch {
        // MARK: 二分查找key
        func binarySearch(_ nums: [Int], _ key: Int) -> (Bool, Int) {
            var l = 0, h = nums.count - 1
            while l <= h {
                let m = l + (h - l) / 2
                if nums[m] == key {
                    return (true, m)
                }
                else if nums[m] > key {
                    h = m - 1
                }
                else {
                    l = m + 1
                }
            }
            return (false, -1)
        }
        // MARK: 在一个有重复元素的数组中查找 key 的最左位置
        func binarySearch2(_ nums: [Int], _ key: Int) -> Int {
            var l = 0, h = nums.count - 1
            while l < h {
                let m = l + (h - l) / 2
                if nums[m] >= key {
                    h = m
                }
                else {
                    l = m + 1
                }
            }
            return l
        }
        // MARK: 求开方
        func mySqrt(_ x: Int) -> Int {
            if x <= 1 {
                return x
            }
            var l = 1, h = x
            while l <= h {
                let mid = l + (h - l) / 2
                let sqrt = x / mid
                if sqrt == mid {
                    return mid
                }
                else if mid > sqrt {
                    h = mid - 1
                }
                else {
                    l = mid + 1
                }
            }
            return h
        }
        // MARK: 大于给定元素的最小元素
        func nextGreatestLetter(_ letters: [Character], _ target: Character) -> Character {
            let n = letters.count
            var l = 0, h = n - 1
            while l <= h {
                let m = l + (h - l) / 2
                if letters[m] <= target {
                    l = m + 1
                }
                else {
                    h = m - 1
                }
            }
            return l < n ? letters[l] : letters[0]
        }

        
    }
    
    // 构建并打印倒三角形
    func printInvertedtriangle(_ num: Int) {
        let count = num + 1
        var ret = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: count), count: count)
        ret[0][0] = 1
        for i in 0..<num {
            let rowdet = i + 1
            ret[i + 1][0] = ret[i][0] + rowdet
            print("\(ret[i][0]) ", separator: "", terminator: "")
            
            let colNum = num - i - 1
            for j in 0..<colNum {
                let coldet = j + 1
                ret[i][j + 1] = ret[i][j] + rowdet + coldet
                print("\(ret[i][j + 1]) ", separator: "", terminator: "")
            }
            print("\n")
        }
    }
}
