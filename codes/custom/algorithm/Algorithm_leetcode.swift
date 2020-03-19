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
    }
    // MARK: 剑指offer题解之Swift实现 https://cyc2018.github.io/CS-Notes/#/README
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
    func Think_Sort() {
        // 快排的partition 可以用于解决第K个元素的问题
        // 堆排序用于解决 TopK的问题
        
        // MARK: 找到倒数第 k 个的元素
        // 排序 ：时间复杂度 O(NlogN)，空间复杂度 O(1)。不清楚Swift中sort的排序算法是哪个，所以不好定性这里的说法
        func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
            return nums.sorted()[nums.count-k]
        }
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
                
                let p = mNums[l]     /* 切分元素 */
                var i = l, j = h + 1
                while true {
                    i += 1
                    while mNums[i] < p && i < h {
                    }
                    j -= 1
                    while mNums[j] > p && j > l {
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
                    if j > k {
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
        
    }
    // 思想之数学
    func math() {
        
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
