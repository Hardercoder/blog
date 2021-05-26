//
//  Leetcode.swift
//  CommandLine
//
//  Created by unravel on 2021/5/12.
//

import Foundation
class Leetcode {
    private let swordOffer = Algorithm_swordOffer()
    private let leetCode = Algorithm_leetcode()
    
    func lc1734() {
        // 1734. 解码异或后的排列
        // https://leetcode-cn.com/problems/decode-xored-permutation/
        func decode(_ encoded: [Int]) -> [Int] {
            let decodeCount = encoded.count
            let ansCount = decodeCount + 1
            // 求 a0,a1..an-1 异或的值
            var total = 0
            for i in 1...ansCount {
                total ^= i
            }
            // a0*a1,a1*a2,a2*a3
            // 求 a1,a2,an-1 异或的值
            var odd = 0
            for i in stride(from: 1, to: decodeCount, by:2) {
                odd ^= encoded[i]
            }
            
            var perm = [Int](repeating:0, count:ansCount)
            perm[0] = total ^ odd
            for i in 0..<decodeCount {
                perm[i + 1] = perm[i] ^ encoded[i]
            }
            return perm;
        }
        print(decode([3,1]))
    }
    func lc1310() {
        // 1310. 子数组异或查询
        // https://leetcode-cn.com/problems/xor-queries-of-a-subarray/
        func xorQueries(_ arr: [Int],
                        _ queries: [[Int]]) -> [Int] {
            var xors = [Int](repeating: 0, count: arr.count + 1)
            for ind in arr.indices {
                xors[ind + 1] = xors[ind] ^ arr[ind]
            }
            var res = [Int](repeating: 0, count: queries.count)
            for ind in queries.indices {
                let range = queries[ind]
                res[ind] = xors[range.first!] ^ xors[range.last! + 1]
            }
            return res
        }
        func mine(_ arr: [Int],
                  _ queries: [[Int]]) -> [Int] {
            var res = [Int]()
            for innerArr in queries {
                var tmpRes = 0
                for ind in innerArr[0]...innerArr[1]  {
                    tmpRes ^= arr[ind]
                }
                res.append(tmpRes)
            }
            return res;
        }
        print(xorQueries([4,8,2,10], [[2,3],[1,3],[0,0],[0,3]]))
    }
    
    func 剑指Offer03() {
        // 剑指 Offer 03. 数组中重复的数字
        //https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/
        // 这个是专门针对题目的算法
        func findRepeatNumber(_ nums: [Int]) -> Int {
            var mulNums = nums
            var i = 0
            while i < mulNums.count {
                let targetIndex = mulNums[i]
                if targetIndex == i {
                    i += 1
                    continue
                }
                if targetIndex == mulNums[targetIndex] {
                    return mulNums[i]
                }
                (mulNums[i], mulNums[targetIndex]) = (mulNums[targetIndex], targetIndex)
            }
            return -1
        }
        // 这个较为通用
        func mine(_ nums: [Int]) -> Int {
            var set:Set<Int> = []
            for v in nums {
                if set.contains(v) {
                    return v
                }
                set.insert(v)
            }
            return -1
        }
        let arr = [2, 3, 1, 0, 2, 5, 3]
        print(findRepeatNumber(arr))
        print(swordOffer.hasAnyDuplicateIn(intArr: arr))
    }
    
    func lc1() {
        // https://leetcode-cn.com/problems/two-sum/
        func twoSum(_ nums: [Int], _ target: Int) -> (Int,Int) {
            var map = [Int: Int]()
            for (index,value) in nums.enumerated() {
                let remind = target - value
                if map.keys.contains(remind) {
                    return (index, map[remind]!)
                }
                map[value] = index
            }
            return (-1,-1)
        }
        print(twoSum([2,7,11,15], 9))
    }
    func lc169() {
        // 169. 多数元素
        // https://leetcode-cn.com/problems/majority-element/
        func majorityElement(_ nums: [Int]) -> Int {
            var cand = nums[0]
            var cand_num = 1
            for ind in 1..<nums.count {
                let value = nums[ind]
                cand_num = cand == value ? cand_num + 1 : cand_num - 1
                if cand_num == 0 {
                    cand = value
                    cand_num = 1
                }
            }
            return cand
        }
        func mine(_ nums: [Int]) -> Int {
            var numCount = [Int:Int]()
            for value in nums {
                if numCount.keys.contains(value) {
                    numCount[value]! += 1
                }
                else {
                    numCount[value] = 1
                }
            }
            
            var  maxEntry: (Int, Int)? = nil
            for (value,count) in numCount {
                if maxEntry == nil || count > maxEntry!.1 {
                    maxEntry = (value, count)
                }
            }
            return maxEntry!.0
            
        }
        print(majorityElement([2,2,1,1,1,2,2]))
    }
    func lc229() {
        // 229. 求众数 II
        // https://leetcode-cn.com/problems/majority-element-ii/
        func majorityElement(_ nums: [Int]) -> [Int] {
            // 创建返回值
            var res = [Int]()
            if nums.count == 0 { return res }
            // 初始化两个候选人candidate和他们的计票
            var cand1 = nums[0], count1 = 0
            var cand2 = nums[0], count2 = 0
            // 摩尔投票法，分为两个阶段：配对阶段和计数阶段
            // 配对阶段
            for num in nums {
                // 投票
                if cand1 == num {
                    count1 += 1
                    continue
                }
                if cand2 == num {
                    count2 += 1
                    continue
                }
                // 第一个候选人配对
                if count1 == 0 {
                    count1 = 1
                    cand1 = num
                    continue
                }
                // 第二个候选人配对
                if count2 == 0 {
                    count2 = 1
                    cand2 = num
                    continue
                }
                count1 -= 1
                count2 -= 1
            }
            // 计数阶段
            // 找到连个候选人之后，需要确定票数是否满足大于 N/3
            count1 = 0
            count2 = 0
            for num in nums {
                if cand1 == num {
                    count1 += 1
                }
                else if cand2 == num {
                    count2 += 1
                }
            }
            let threshold = nums.count / 3
            if count1 > threshold {
                res.append(cand1)
            }
            if count2 > threshold {
                res.append(cand2)
            }
            return res
        }
        
        func mine(_ nums: [Int]) -> [Int] {
            var numCount = [Int:Int]()
            for value in nums {
                if numCount.keys.contains(value) {
                    numCount[value]! += 1
                }
                else {
                    numCount[value] = 1
                }
            }
            
            let threshold = nums.count / 3
            var res = [Int]()
            for (value,count) in numCount {
                if count > threshold {
                    res.append(value)
                }
            }
            return res
        }
        print(mine([1,1,1,3,3,2,2,2]))
    }
    
    func lc1486() {
        // 1486. 数组异或操作
        // https://leetcode-cn.com/problems/xor-operation-in-an-array/
        /**
         总结一下，假设我们最终的答案为 ans。整个处理过程其实就是把原式中的每个 itemitem 右移一位（除以 22），计算 ans 中除了最低一位以外的结果；然后再将 ans 进行一位左移（重新乘以 22），将原本丢失的最后一位结果重新补上。补上则是利用了 n 和 start 的「奇偶性」的讨论
         */
        func xorOperation(_ n: Int, _ start: Int) -> Int {
            func calc(x: Int) -> Int {
                switch x % 4 {
                case 0:
                    return x
                case 1:
                    return 1
                case 2:
                    return x + 1
                default:
                    return 0
                }
            }
            // 整体除以 2，利用 %4 结论计算 ans 中除 最低一位 的结果
            let  s = start >> 1
            let prefix = calc(x: s - 1) ^ calc(x: s + n - 1)
            // 利用奇偶性 计算ans中的 最低一位的结果
            let last = n & start & 1
            let ans = prefix << 1 | last
            return ans
        }
        func mine(_ n: Int, _ start: Int) -> Int {
            var res = 0
            for i in stride(from: start, to: start + 2 * n, by: 2) {
                res ^= i
            }
            return res
        }
        print(mine(4,3))
    }
    func lc1720() {
        // 1720. 解码异或后的数组
        // https://leetcode-cn.com/problems/decode-xored-array/
        func decode(_ encoded: [Int], _ first: Int) -> [Int] {
            let ansCount = encoded.count + 1
            var ans = [Int](repeating: 0, count: ansCount)
            ans[0] = first
            for i in 1..<ansCount {
                ans[i] = ans[i - 1] ^ encoded[i - 1]
            }
            return ans
        }
        
        func mine(_ encoded: [Int], _ first: Int) -> [Int] {
            let ansCount = encoded.count + 1
            var ans = [Int](repeating: 0, count: ansCount)
            ans[0] = first
            for i in 1..<ansCount {
                ans[i] = ans[i - 1] ^ encoded[i - 1]
            }
            return ans
        }
        print(mine([6,2,7,3],4))
    }
    
    func lc1556() {
        // 1556. 千位分隔数
        // https://leetcode-cn.com/problems/thousand-separator/
        func thousandSeparator(_ n: Int) -> String {
            var sb = ""
            let revertedS = "\(n)".reversed()
            let lastInd = revertedS.count - 1
            var cnt = 0
            for (ind,c) in revertedS.enumerated() {
                sb.append(c)
                cnt += 1
                if cnt % 3 == 0 && ind != lastInd {
                    sb.append(".")
                }
            }
            return String(sb.reversed())
        }
        func mine(_ n: Int) -> String {
            if n == 0 {
                return "0"
            }
            var res = ""
            var x = n
            while x != 0 {
                // 每3位分隔
                if x > 1000 {
                    res = String(format: ".%03d", x % 1000) + res
                }
                else {
                    res = "\(x)" + res
                }
                x /= 1000
            }
            return res
        }
        print(mine(12034056789))
    }
    
    func lc2() {
        // 2. 两数相加
        // https://leetcode-cn.com/problems/add-two-numbers/
        func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
            let h3: ListNode? = ListNode()
            var h1 = l1, h2 = l2, l3 = h3
            var carrier = false
            while h1 != nil || h2 != nil {
                var sum = 0
                if h1 != nil {
                    sum += h1!.val
                    h1 = h1!.next
                }
                if h2 != nil {
                    sum += h2!.val
                    h2 = h2!.next
                }
                sum += carrier ? 1 : 0
                carrier = sum >= 10
                
                l3?.next = ListNode(sum % 10)
                l3 = l3?.next
            }
            if carrier {
                l3?.next = ListNode(1)
            }
            return h3?.next
        }
        
    }
    
    func lc7() {
        // 7. 整数反转
        // https://leetcode-cn.com/problems/reverse-integer/
        func reverse(_ x: Int) -> Int {
            var res: Int = 0
            var n = x
            while n != 0 {
                let remaind = n % 10
                
                let maxDiv = Int.max / 10
                if res > maxDiv || (res == maxDiv && remaind > Int.max % 10) {
                    return 0
                }
                let minDiv = Int.min / 10
                if res < minDiv || (res == minDiv && remaind < Int.min % 10) {
                    return 0
                }
                res = res * 10 + remaind
                n /= 10
            }
            return res
        }
        print(reverse(Int.max))
    }
    
    func lc3() {
        // 3. 无重复字符的最长子串
        // https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/
        func lengthOfLongestSubstring(_ s: String) -> Int {
            if s.count == 0 {
                return 0
            }
            var left = 0
            var maxLength = 0
            var map = [Character:Int]()
            for (ind, c) in s.enumerated() {
                if map.keys.contains(c) {
                    left = max(left, map[c]! + 1)
                }
                map[c] = ind
                maxLength = max(maxLength, ind - left + 1)
            }
            return maxLength
        }
        print(lengthOfLongestSubstring("abcabcbb"))
    }
    
    func lc9() {
        // 9. 回文数
        // https://leetcode-cn.com/problems/palindrome-number/
        func isPalindrome(_ x: Int) -> Bool {
            // 特殊情况：
            // 如上所述，当 x < 0 时，x 不是回文数。
            // 同样地，如果数字的最后一位是 0，为了使该数字为回文，
            // 则其第一位数字也应该是 0
            // 只有 0 满足这一属性
            if (x < 0 || (x % 10 == 0 && x != 0)) {
                return false;
            }
            var leftHalf = x
            var rightHalf = 0;
            while leftHalf > rightHalf {
                rightHalf = rightHalf * 10 + leftHalf % 10;
                leftHalf /= 10;
            }
            
            // 当数字长度为奇数时，我们可以通过 revertedNumber/10 去除处于中位的数字。
            // 例如，当输入为 12321 时，在 while 循环的末尾我们可以得到 x = 12，revertedNumber = 123，
            // 由于处于中位的数字不影响回文（它总是与自己相等），所以我们可以简单地将其去除。
            return leftHalf == rightHalf || leftHalf == rightHalf / 10;
        }
        func mine(_ x: Int) -> Bool {
            let xStr = "\(x)"
            let xReversedStr = String(xStr.reversed())
            return xStr == xReversedStr
        }
        func mine2(_ x: Int) -> Bool {
            if x < 0 {
                return false
            }
            var n = x
            var div = 1
            while n / div >= 10 {
                div *= 10
            }
            while n > 0 {
                let left = n / div
                let right = n % 10
                if left != right {
                    return false
                }
                n = (n % div) / 10
                div /= 100
            }
            return true
        }
        print(mine2(121))
    }
    
    func 剑指Offer04() {
        // 剑指 Offer 04. 二维数组中的查找， 从两个角上开始遍历和查找
        // https://leetcode-cn.com/problems/er-wei-shu-zu-zhong-de-cha-zhao-lcof/
        func findNumberIn2DArray(_ matrix: [[Int]], _ target: Int) -> Bool {
            let rows = matrix.count
            let columns = matrix[0].count
            if rows == 0 && columns == 0 {
                return false
            }
            var x = rows - 1
            var y = 0
            while x >= 0 && y < columns {
                let value = matrix[x][y]
                if value > target {
                    x -= 1
                }
                else if value == target {
                    return true
                }
                else {
                    y += 1
                }
            }
            return false
        }
        
        func mine(_ matrix: [[Int]],
                  _ target: Int) -> Bool {
            for row in matrix {
                for value in row {
                    if value == target {
                        return true
                    }
                }
            }
            
            return false
        }
        
        let arr = [
            [1,   4,  7, 11, 15],
            [2,   5,  8, 12, 19],
            [3,   6,  9, 16, 22],
            [10, 13, 14, 17, 24],
            [18, 21, 23, 26, 30]
        ]
        print(findNumberIn2DArray(arr,20))
        print(swordOffer.isNumIn(arr, target: 20))
    }
    
    func 剑指Offer05() {
        // 剑指 Offer 05. 替换空格
        // https://leetcode-cn.com/problems/ti-huan-kong-ge-lcof/
        func replaceSpace(_ s: String) -> String {
            var str = ""
            for c in s {
                if c == " " {
                    str.append("%20")
                }
                else {
                    str.append(c)
                }
            }
            return str
        }
        func mine(_ s: String) -> String {
            
            return s.replacingOccurrences(of: " ", with: "%20")
        }
        let s = "We are happy."
        print(mine(s))
        print(swordOffer.replaceSpace(s))
    }
    
    func 剑指Offer29() {
        // 剑指 Offer 29. 顺时针打印矩阵
        // https://leetcode-cn.com/problems/shun-shi-zhen-da-yin-ju-zhen-lcof/
        func spiralOrder(_ matrix: [[Int]]) -> [Int] {
            var res = [Int]()
            if matrix.count == 0 {
                return res
            }
            var l = 0, r = matrix[0].count - 1,t = 0,b = matrix.count - 1
            while true {
                // 从左向右
                for i in l...r {
                    res.append(matrix[t][i])
                }
                // 往下移一行
                t += 1
                // 上下边界重合就退出
                if t > b {
                    break
                }
                // 从上到下
                for j in t...b {
                    res.append(matrix[j][r])
                }
                // 往左移一行
                r -= 1
                // 左右边界重合就退出
                if r < l {
                    break
                }
                // 从右向左
                for i in stride(from: r,
                                through: l,
                                by: -1) {
                    res.append(matrix[b][i])
                }
                // 往上移一行
                b -= 1
                // 上下边界重合就退出
                if t > b {
                    break
                }
                // 从下往上
                for j in stride(from: b,
                                through: t,
                                by: -1) {
                    res.append(matrix[j][l])
                }
                // 往右移一行
                l += 1
                if l > r {
                    break
                }
            }
            return res
        }
        let matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
        print(swordOffer.printMatrix(matrix))
        print(spiralOrder(matrix))
    }
    
    func 剑指Offer50() {
        // 剑指 Offer 50. 第一个只出现一次的字符
        // https://leetcode-cn.com/problems/di-yi-ge-zhi-chu-xian-yi-ci-de-zi-fu-lcof/
        func firstUniqChar(_ s: String) -> Character {
            return s.first!
        }
        func mine(_ s: String) -> Character {
            var mapCount = [Character:Int]()
            for c in s {
                if mapCount.keys.contains(c) {
                    mapCount[c] = mapCount[c]! + 1
                }
                else {
                    mapCount[c] = 1
                }
            }
            for c in s {
                if mapCount[c]! == 1 {
                    return c
                }
            }
            return Character(" ")
        }
        let s = ""//abaccdeff
        print(mine(s))
        print(swordOffer.firstAppearingOnce(s.map {Int($0.asciiValue!)}))
    }
    
    func 剑指Offer09() {
        // 剑指 Offer 09. 用两个栈实现队列
        // https://leetcode-cn.com/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof/
        class CQueue {
            var inStack = Stack<Int>()
            var outStack = Stack<Int>()
            init() {
                
            }
            
            func appendTail(_ value: Int) {
                inStack.push(value)
            }
            
            func deleteHead() -> Int {
                if outStack.isEmpty {
                    while !inStack.isEmpty {
                        outStack.push(inStack.pop()!)
                    }
                }
                if outStack.isEmpty {
                    return -1
                }
                else {
                    return outStack.pop()!
                }
            }
        }
        //["CQueue","appendTail","deleteHead","deleteHead"]
        let ss = [1,3,5,7,9,8]
        let queue = CQueue()
        _ = ss.map{
            queue.appendTail($0)
        }
        for _ in 0..<8 {
            print(queue.deleteHead(), terminator: " ")
        }
        print("")
        let a = Algorithm_swordOffer.twoStackForQueue()
        _ = ss.map{
            a.push($0)
        }
        for _ in 0..<8 {
            print(a.pop() ?? -1, terminator: " ")
        }
        print("")
    }
    
    func 剑指Offer30() {
        // 剑指 Offer 30. 包含min函数的栈
        // https://leetcode-cn.com/problems/bao-han-minhan-shu-de-zhan-lcof/
        class MinStack {
            private var dataStack = Array<Int>()
            private var minStack = Array<Int>()
            
            /** initialize your data structure here. */
            init() {
                
            }
            
            func push(_ x: Int) {
                dataStack.append(x)
                minStack.append(minStack.isEmpty ? x : Swift.min(minStack.last!, x))
            }
            
            func pop() {
                _ = dataStack.popLast()
                _ = minStack.popLast()
            }
            
            func top() -> Int {
                return dataStack.last ?? -1
            }
            
            func min() -> Int {
                return minStack.last ?? -1
            }
        }
    }
    
    func 剑指Offer31() {
        // 剑指 Offer 31. 栈的压入、弹出序列
        // https://leetcode-cn.com/problems/zhan-de-ya-ru-dan-chu-xu-lie-lcof/
        func validateStackSequences(_ pushed: [Int], _ popped: [Int]) -> Bool {
            // 使用辅助栈模拟一个入栈出栈操作
            if pushed.count != popped.count {
                return false
            }
            var auxStack = Stack<Int>()
            let popedIndexTotal = popped.count
            var popedIndex = 0
            for v in pushed {
                auxStack.push(v)
                while let topValue = auxStack.top,
                      popedIndex < popedIndexTotal,
                      topValue == popped[popedIndex] {
                    _ = auxStack.pop()
                    popedIndex += 1
                }
            }
            return auxStack.isEmpty
        }
        
        let pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
        
        print(validateStackSequences(pushed,popped))
        print(swordOffer.isPopOrder(pushed, popped))
    }
    
    func 剑指Offer40() {
        // 剑指 Offer 40. 最小的k个数 https://leetcode-cn.com/problems/zui-xiao-de-kge-shu-lcof/
        func mine(_ arr: [Int], _ k: Int) -> [Int] {
            let arr2 = arr.sorted()
            return Array(arr2.prefix(k))
        }
        // 使用快排
        func quickSort(_ arr: [Int],
                       _ k: Int) -> [Int] {
            if k <= 0 ||
                arr.count == 0 ||
                k > arr.count {
                return []
            }
            
            func quickSearch(_ nums: inout [Int],
                             _ lo: Int,
                             _ hi: Int,
                             _ k: Int) -> [Int] {
                // 快排切分，返回下标j，使得比nums[j] 小的数都在j的左边，比nums[j]大的数都在j的右边
                func partition(_ l: Int,
                               _ h: Int) -> Int {
                    
                    func swap(_ swi: Int , _ swj: Int) {
                        (nums[swi],nums[swj]) = (nums[swj],nums[swi])
                    }
                    let v = nums[l]
                    /* 切分元素 */
                    var i = l, j = h + 1
                    while true {
                        while i < h {
                            i += 1
                            if nums[i] >= v {
                                break
                            }
                        }
                        while j > l {
                            j -= 1
                            if nums[j] <= v {
                                break
                            }
                        }
                        if i >= j {
                            break
                        }
                        swap(i, j)
                    }
                    swap(l, j)
                    return j
                }
                
                //每快排切分1次，找到排序后下标为j的元素，如果j恰好是k就返回j以及j左边所有的数
                let j = partition(lo, hi)
                if j == k {
                    return Array(nums.prefix(j+1))
                }
                // 否则根据下标j与k的大小关系来决定继续切分左段还是右段
                return j > k ?
                    quickSearch(&nums, lo, j - 1, k) :
                    quickSearch(&nums, j + 1, hi, k)
            }
            
            var mArr = arr
            // 最后一个参数标识我们要找的是下标为k-1的数
            return quickSearch(&mArr,
                               0,
                               mArr.count - 1,
                               k - 1)
        }
        
        let arr = [3,2,1], k = 2
        print(quickSort(arr,k))
        print(swordOffer.getLeastNumbers_Solution(arr, k))
    }
    
    func 剑指Offer41() {
        // FIXME: 需要堆排序及PriorityQueu
        // 剑指 Offer 41. 数据流中的中位数
        // https://leetcode-cn.com/problems/shu-ju-liu-zhong-de-zhong-wei-shu-lcof/
        class MedianFinder {
            let a = PriorityQueue()
            init() {
                
            }
            
            func addNum(_ num: Int) {
                
            }
            
            func findMedian() -> Double {
                return 0.0
            }
        }
    }
    
    func lc13() {
        // 13. 罗马数字转整数
        // https://leetcode-cn.com/problems/roman-to-integer/
        func romanToInt(_ s: String) -> Int {
            func getValueFor(_ ch: Character) -> Int {
                switch(ch) {
                case "I": return 1
                case "V": return 5
                case "X": return 10
                case "L": return 50
                case "C": return 100
                case "D": return 500
                case "M": return 1000
                default: return 0
                }
            }
            
            var total = 0
            let firstChar = s.first!
            var preValue = getValueFor(firstChar)
            for c in s.dropFirst() {
                let value = getValueFor(c)
                if preValue < value {
                    total -= preValue
                }
                else {
                    total += preValue
                }
                preValue = value
            }
            total += preValue
            return total
        }
        func mine(_ s: String) -> Int {
            let romanIntValue:[Character:Int] = [
                "I":1,
                "V":5,
                "X":10,
                "L":50,
                "C":100,
                "D":500,
                "M":1000
            ]
            
            var total = 0
            let firstChar = s.first!
            var preValue = romanIntValue[firstChar]!
            for c in s.dropFirst() {
                let value = romanIntValue[c]!
                if preValue < value {
                    total -= preValue
                }
                else {
                    total += preValue
                }
                preValue = value
            }
            
            return total + preValue
        }
        
        print(mine("MCMXCIV"))
    }
    
    func lc6() {
        // 6. Z 字形变换
        // https://leetcode-cn.com/problems/zigzag-conversion/
        func convert(_ s: String, _ numRows: Int) -> String {
            if s.count < 2 {
                return s
            }
            var ret = [String](repeating: "", count: numRows)
            var reverse = false
            var curRow = 0
            for c in s {
                ret[curRow].append(String(c))
                
                if curRow == numRows - 1 || curRow == 0 {
                    reverse.toggle()
                }
                curRow += reverse ? 1 : -1
            }
            
            var rets = ""
            for str in ret {
                rets.append(str)
            }
            return rets
        }
        func mine(_ s: String, _ numRows: Int) -> String {
            if numRows == 1 {
                return s
            }
            let sCount = s.count
            let startIndex = s.startIndex
            let cycle = 2 * numRows - 2
            var res = ""
            for row in 0..<numRows {
                for startInd in stride(from: 0,
                                       to: sCount,
                                       by: cycle) {
                    let right = startInd + row
                    if right < sCount {
                        res.append(s[s.index(startIndex, offsetBy: right)])
                    }
                    
                    let left = startInd + cycle - row
                    if row > 0 &&
                        row < numRows - 1 &&
                        left < sCount {
                        res.append(s[s.index(startIndex, offsetBy: left)])
                    }
                }
            }
            return res
        }
        let s = "PAYPALISHIRING", numRows = 4
        // PINALSIGYAHRPI
        print(convert(s, numRows))
    }
    
    func lc21() {
        // 21. 合并两个有序链表
        // https://leetcode-cn.com/problems/merge-two-sorted-lists/
        func mergeTwoLists(_ l1: ListNode?,
                           _ l2: ListNode?) -> ListNode? {
            return swordOffer.merge(l1, l2)
        }
    }
    func lc26() {
        // 26. 删除有序数组中的重复项
        // https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array/
        func removeDuplicates(_ nums: inout [Int]) -> Int {
            return 0
        }
        
        func mine(_ nums: inout [Int]) -> Int {
            let count = nums.count
            if count == 0 {
                return count
            }
            var leftInd = 0
            var rightInd = 1
            while rightInd < count {
                let leftValue = nums[leftInd]
                let rightValue = nums[rightInd]
                if leftValue != rightValue {
                    if rightInd > leftInd + 1 {
                        nums[leftInd + 1] = rightValue
                    }
                    leftInd += 1
                }
                rightInd += 1
            }
            return leftInd + 1
        }
        var nums = [0,0,1,1,1,2,2,3,3,4]
        print(mine(&nums))
    }
    
    func lc14() {
        // 14. 最长公共前缀
        // https://leetcode-cn.com/problems/longest-common-prefix/
        func longestCommonPrefix(_ strs: [String]) -> String {
            return strs[0]
        }
        
        func mine(_ strs: [String]) -> String {
            if strs.count == 0 {
                return ""
            }
            if strs.count == 1 {
                return strs[0]
            }
            let firstStr = strs.first!
            var prefixInd = -1
            for i in 0..<firstStr.count {
                print("外层for循环  ", i)
                let char = firstStr[firstStr.index(firstStr.startIndex, offsetBy: i)]
                var hasCommonPrefix = true
                for str in strs.dropFirst() {
                    let ind = str.index(str.startIndex, offsetBy: i, limitedBy: str.endIndex)
                    if ind != nil && ind != str.endIndex {
                        print("juedge 合法",i,char,str[ind!])
                        if str[ind!] != char {
                            hasCommonPrefix = false
                            break
                        }
                    }
                    else {
                        print("judge ind 不合法")
                        hasCommonPrefix = false
                        break
                    }
                }
                if(hasCommonPrefix) {
                    prefixInd += 1
                    print("内层for循环 结束",prefixInd)
                }
                else {
                    break
                }
            }
            print(prefixInd)
            if prefixInd >= 0 {
                return String(firstStr[firstStr.startIndex...firstStr.index(firstStr.startIndex, offsetBy: prefixInd)])
            }
            else {
                return ""
            }
        }
        let strs = ["cir","car"]
        // ["flower","flow","flight"]
        print(mine(strs))
    }
    
    func 剑指Offer59I() {
        // 剑指 Offer 59 - I. 滑动窗口的最大值
        // https://leetcode-cn.com/problems/hua-dong-chuang-kou-de-zui-da-zhi-lcof/
        func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
            if nums.count == 0 || k == 0 {
                return []
            }
            if nums.count < k   {
                return []
            }
            
            var slideWindowMaxQueue = [Int]()
            var res = [Int](repeating: 0, count: nums.count - k + 1)
            // 未形成窗口
            for i in 0..<k {
                while  !slideWindowMaxQueue.isEmpty && slideWindowMaxQueue.last! < nums[i] {
                    slideWindowMaxQueue.removeLast()
                }
                slideWindowMaxQueue.append(nums[i])
            }
            res[0] = slideWindowMaxQueue.first!
            // 形成窗口后
            for i in k..<nums.count {
                if slideWindowMaxQueue.first! == nums[i - k] {
                    slideWindowMaxQueue.removeFirst()
                }
                while !slideWindowMaxQueue.isEmpty && slideWindowMaxQueue.last! < nums[i] {
                    slideWindowMaxQueue.removeLast()
                }
                slideWindowMaxQueue.append(nums[i])
                res[i - k + 1] = slideWindowMaxQueue.first!
            }
            
            return res
        }
        func mine(_ nums: [Int], _ k: Int) -> [Int] {
            return swordOffer.maxSlidingWindow(nums, k)
        }
        let nums = [1,3,-1,-3,5,3,6,7], k = 3
        print(mine(nums, k))
        print(swordOffer.maxSlidingWindow(nums, k))
    }
    func 剑指Offer57() {
        // 剑指 Offer 57. 和为s的两个数字
        // https://leetcode-cn.com/problems/he-wei-sde-liang-ge-shu-zi-lcof/
        func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
            return mine(nums,target)
        }
        
        func mine(_ nums: [Int], _ target: Int) -> [Int] {
            if nums.count < 2 {
                return []
            }
            var i = 0
            var j = nums.count - 1
            while i < j {
                let iValue = nums[i]
                let jValue = nums[j]
                let sumValue = iValue + jValue
                if sumValue == target {
                    return [iValue, jValue]
                }
                else if sumValue > target {
                    j -= 1
                }
                else {
                    i += 1
                }
            }
            return []
        }
        
        let nums = [10,26,30,31,47,60], target = 40
        print(mine(nums, target))
        print(swordOffer.findNumbersWithSum(nums, target))
    }
    
    func 剑指Offer57II() {
        // 剑指 Offer 57 - II. 和为s的连续正数序列
        // https://leetcode-cn.com/problems/he-wei-sde-lian-xu-zheng-shu-xu-lie-lcof/
        func findContinuousSequence(_ target: Int) -> [[Int]] {
            // 滑动窗口的左边界
            var i = 1
            // 滑动窗口的右边界
            var j = 1
            // 滑动窗口中数字之和
            var sum = 0
            var res = [[Int]]()
            while i <= target / 2 {
                if sum < target {
                    sum += j
                    j += 1
                }
                else if sum > target {
                    sum -= i
                    i += 1
                }
                else {
                    // 记录结果
                    var arr = [Int](repeating: 0, count: j-i)
                    for k in i..<j {
                        arr[k - i] = k
                    }
                    res.append(arr)
                    sum -= i
                    i += 1
                }
            }
            return res
        }
        let target = 15
        print(findContinuousSequence(target))
        print(swordOffer.findContinuousSequence(UInt(target)))
    }
    
    func 剑指Offer58I() {
        // 剑指 Offer 58 - I. 翻转单词顺序
        // https://leetcode-cn.com/problems/fan-zhuan-dan-ci-shun-xu-lcof/
        func reverseWords(_ s: String) -> String {
            var res = [String]()
            let mulS = s.trimmingCharacters(in: CharacterSet.whitespaces)
            var word = ""
            for c in mulS {
                if c == " " {
                    if word.count != 0 {
                        res.append(String(word))
                    }
                    word = ""
                    continue
                }
                else {
                    word.append(c)
                }
            }
            // 最后一个单词
            if word.count != 0 {
                res.append(String(word))
            }
            
            return res.reversed().joined(separator: " ")
        }
        
        func mine(_ s: String) -> String {
            var reswords = [String]()
            for word in s.trimmingCharacters(in: CharacterSet.whitespaces).split(separator: " ").reversed() {
                if word != "" {
                    reswords.append(String(word))
                }
            }
            return reswords.joined(separator: " ")
        }
        let s = "a good   example"
        print(mine(s))
        // 下面的实现没有考虑单词之间的多个空格
        print(swordOffer.reverseSentence(s))
    }
    func 剑指Offer58II() {
        // 剑指 Offer 58 - II. 左旋转字符串
        // https://leetcode-cn.com/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/
        func reverseLeftWords(_ s: String, _ n: Int) -> String {
            return swordOffer.leftRotateString(s, n)
        }
        func mine(_ s: String, _ n: Int) -> String {
            return String(s.suffix(s.count - n)) + s.prefix(n)
        }
        let s = "lrloseumgh", k = 6
        print(mine(s, k))
    }
    func 剑指Offer06() {
        // 剑指 Offer 06. 从尾到头打印链表
        // https://leetcode-cn.com/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/
        func reversePrint(_ head: ListNode?) -> [Int] {
            return swordOffer.printListFromTailToHead1(head)
        }
        func mine(_ head: ListNode?) -> [Int] {
            
            var stack = Stack<Int>()
            var l = head
            while l != nil {
                stack.push(l!.val)
                l = l?.next
            }
            var res = [Int]()
            while stack.top != nil {
                res.append(stack.top!)
            }
            return res
        }
        //            return swordOffer.printListFromTailToHead2(head)
        //            }
    }
    
    func lc380() {
        // 380. O(1) 时间插入、删除和获取随机元素
        // https://leetcode-cn.com/problems/insert-delete-getrandom-o1/
        class RandomizedSet {
            
            /** Initialize your data structure here. */
            init() {
                
            }
            
            /** Inserts a value to the set. Returns true if the set did not already contain the specified element. */
            func insert(_ val: Int) -> Bool {
                return false
            }
            
            /** Removes a value from the set. Returns true if the set contained the specified element. */
            func remove(_ val: Int) -> Bool {
                return true
            }
            
            /** Get a random element from the set. */
            func getRandom() -> Int {
                return 1
            }
        }
    }
    
    func lc5() {
        // 5. 最长回文子串 https://leetcode-cn.com/problems/longest-palindromic-substring/
        func longestPalindrome(_ s: String) -> String {
            func preprocess(_ s: String) -> String {
                let n = s.count
                if n == 0 {
                    return "^$"
                }
                var ret = "^"
                for c in s {
                    ret += "#" + String(c)
                }
                ret += "#$"
                return ret
            }
            let T = preprocess(s)
            let tStartIndex = T.startIndex
            let n = T.count
            var P = [Int](repeating: 0, count: n)
            var C = 0, R = 0
            for i in 1..<n-1 {
                let i_mirror = 2 * C - i
                if R > i {
                    P[i] = Swift.min(R - i, P[i_mirror])
                }
                else {
                    P[i] = 0
                }
                
                while T[T.index(tStartIndex, offsetBy: i + 1 + P[i])] == T[T.index(tStartIndex, offsetBy: i - 1 - P[i])] {
                    P[i] += 1
                }
                
                if i + P[i] > R {
                    C = i
                    R = i + P[i]
                }
            }
            
            var maxLen = 0
            var centerIndex = 0
            for i in 1..<n {
                if P[i] > maxLen {
                    maxLen = P[i]
                    centerIndex = i
                }
            }
            let start = (centerIndex - maxLen) / 2
            let sStartIndex = s.startIndex
            return String(s[s.index(sStartIndex, offsetBy: start)..<s.index(sStartIndex, offsetBy: start + maxLen)])
        }
        
        func mine(_ s: String) -> String {
            if s.count < 1 {
                return ""
            }
            let sStartIndex = s.startIndex
            let sCount = s.count
            var start = 0, end = 0
            // 从该位置扩展
            func isPalindrome(_ i: Int,
                              _ j: Int) -> Int {
                var l = i, r = j
                while l >= 0 &&
                        r < sCount &&
                        s[s.index(sStartIndex, offsetBy: l)] == s[s.index(sStartIndex, offsetBy: r)] {
                    l -= 1
                    r += 1
                }
                return r - l - 1
            }
            for (i, _) in s.enumerated() {
                let le1 = isPalindrome(i, i)
                let le2 = isPalindrome(i, i + 1)
                let len = Swift.max(le1, le2)
                if len > end - start {
                    start = i - (len - 1) / 2
                    end = i + len / 2
                }
            }
            let sIndex = s.index(sStartIndex, offsetBy: start)
            let eInde = s.index(sStartIndex, offsetBy: end + 1)
            return String(s[sIndex..<eInde])
        }
        let s = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
        print(mine(s))
    }
    
    func 剑指Offer18() {
        // 剑指 Offer 18. 删除链表的节点
        // https://leetcode-cn.com/problems/shan-chu-lian-biao-de-jie-dian-lcof/
        func deleteNode(_ head: ListNode?,
                        _ val: Int) -> ListNode? {
            if head == nil {
                return head
            }
            if head!.val == val {
                return head!.next
            }
            var pre = head
            var cur = pre?.next
            while cur != nil {
                let curValue = cur!.val
                if val == curValue {
                    if cur !== nil {
                        pre!.next = cur!.next
                    }
                    break
                }
                pre = cur
                cur = cur?.next
            }
            return head
        }
    }
    
    func lc83() {
        // 83. 删除排序链表中的重复元素
        // 删除链表中重复的结点
        // https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/
        func deleteDuplicates(_ head: ListNode?) -> ListNode? {
            var cur = head
            while cur != nil && cur!.next != nil {
                if cur!.val == cur!.next!.val {
                    cur!.next = cur!.next!.next
                }
                else {
                    cur = cur!.next
                }
            }
            return head
        }
        _ = swordOffer.deleteDuplication(nil)
    }
    
    func lc141() {
        // 141. 环形链表
        // https://leetcode-cn.com/problems/linked-list-cycle/
        func hasCycle(_ head: ListNode?) -> Bool {
            if head == nil || head!.next == nil {
                return false
            }
            var slow = head
            var fast = head!.next
            while slow !== fast {
                if fast == nil || fast?.next == nil {
                    return false
                }
                fast = fast?.next?.next
                slow = slow?.next
            }
            return true
        }
        
        func mine(_ head: ListNode?) -> Bool {
            var seen = Set<ListNode>()
            var l = head
            while l != nil {
                if seen.contains(l!) {
                    return true
                }
                seen.insert(l!)
                l = l!.next
            }
            return false
        }
    }
    
    func 剑指Offer22() {
        // 剑指 Offer 22. 链表中倒数第k个节点
        // https://leetcode-cn.com/problems/lian-biao-zhong-dao-shu-di-kge-jie-dian-lcof/
        
        func getKthFromEnd(_ head: ListNode?, _ k: Int) -> ListNode? {
            var former = head, later = head
            for _ in 0..<k {
                former = former?.next
            }
            while former != nil {
                former = former?.next
                later = later?.next
            }
            return later
            //            return swordOffer.findKthToTail(head, k)
        }
        func mine(_ head: ListNode?, _ k: Int) -> ListNode? {
            var former = head, later = head
            var steper = 0
            while former != nil && steper < k {
                former = former!.next
                steper += 1
            }
            
            while former != nil {
                former = former?.next
                later = later?.next
            }
            return later
        }
    }
    
    func 剑指Offer24() {
        // 剑指 Offer 24. 反转链表
        // https://leetcode-cn.com/problems/fan-zhuan-lian-biao-lcof/
        func reverseList(_ head: ListNode?) -> ListNode? {
            func recurise(_ h: ListNode?) -> ListNode? {
                if h == nil || h!.next == nil {
                    return h
                }
                let ret = recurise(h!.next)
                h?.next?.next = h
                h?.next = nil
                return ret
            }
            return recurise(head)
        }
    }
    
    func 剑指Offer25() {
        // 剑指 Offer 25. 合并两个排序的链表
        // https://leetcode-cn.com/problems/he-bing-liang-ge-pai-xu-de-lian-biao-lcof/
        func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
            return swordOffer.merge(l1, l2)
        }
    }
    
    func lc138() {
        // 138. 复制带随机指针的链表，复杂链表的复制
        // https://leetcode-cn.com/problems/copy-list-with-random-pointer/
        class Solution {
            func copyRandomList(_ head: RandomListNode?) -> RandomListNode? {
                if head == nil {
                    return nil
                }
                var cur = head
                var map = [RandomListNode: RandomListNode]()
                // 复制各节点，并建立“原节点 -> 新节点"的映射
                while cur != nil {
                    map[cur!] = RandomListNode(cur!.label)
                    cur = cur!.next
                }
                cur = head
                // 构建新链表的next和random指向
                while cur != nil {
                    let curNode = map[cur!]!
                    if cur!.next != nil {
                        curNode.next = map[cur!.next!]
                    }
                    else {
                        curNode.next = nil
                    }
                    if cur!.random != nil {
                        curNode.random = map[cur!.random!]
                    }
                    else {
                        curNode.random = nil
                    }
                    cur = cur?.next
                }
                return map[head!]
            }
        }
    }
    func lc160() {
        // 160. 相交链表,两个链表的第一个公共结点
        // https://leetcode-cn.com/problems/intersection-of-two-linked-lists/
        func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
            return swordOffer.findFirstCommonNode(headA, headB)
        }
    }
    func lc105() {
        // 105. 从前序与中序遍历序列构造二叉树
        // 重建二叉树
        // https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/
        func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
            return swordOffer.buildTree(preorder, inorder)
        }
    }
    
    func lc692() {
        // 692. 前K个高频单词
        // https://leetcode-cn.com/problems/top-k-frequent-words/
        func topKFrequent(_ words: [String], _ k: Int) -> [String] {
            
            func buildHeap(_ tree: inout [(String, Int)], _ length: Int) {
                let parent = (length - 1) / 2
                for idx in stride(from: parent, to: -1, by: -1) {
                    heapfy(&tree, length, idx)
                }
            }
            
            func heapfy(_ tree: inout [(String, Int)], _ length: Int, _ index: Int) {
                if index >= length {
                    return
                }
                
                let c1 = index * 2 + 1
                let c2 = index * 2 + 2
                
                var maxLoc = index
                if c1 < length && compareMax(tree[c1], tree[maxLoc]) {
                    maxLoc = c1
                }
                
                if c2 < length && compareMax(tree[c2], tree[maxLoc]) {
                    maxLoc = c2
                }
                
                if maxLoc != index {
                    swap(&tree, maxLoc, index)
                    heapfy(&tree, length, maxLoc)
                }
            }
            
            func compareMax(_ item1: (String, Int), _ item2: (String, Int)) -> Bool {
                
                if item1.1 > item2.1 {
                    return false
                } else if item1.1 < item2.1 {
                    return true
                } else {
                    return item1.0 > item2.0
                }
            }
            
            func swap(_ tree: inout [(String, Int)], _ idx1: Int, _ idx2: Int) {
                (tree[idx1], tree[idx2]) = (tree[idx2], tree[idx1])
            }
            
            func sortHeap(_ tree: inout [(String, Int)], _ length: Int) {
                
                buildHeap(&tree, length)
                
                for idx in stride(from: length - 1, to: -1, by: -1) {
                    swap(&tree, idx, 0)
                    heapfy(&tree, idx, 0)
                }
            }
            
            var mapDict = [String: Int]()
            
            for word in words {
                if var wordCnt = mapDict[word] {
                    wordCnt += 1
                    mapDict[word] = wordCnt
                } else {
                    mapDict[word] = 1
                }
            }
            
            var frequents = [(String, Int)]()
            
            for key in mapDict.keys {
                frequents.append((key, mapDict[key]!))
            }
            
            sortHeap(&frequents, frequents.count)
            
            var results = [String]()
            
            for idx in 0..<k {
                let str = frequents[idx].0
                results.append(str)
            }
            return results
        }
        
        func mine(_ words: [String], _ k: Int) -> [String] {
            // 统计每个单词的次数
            var wordsCount = [String: Int]()
            for word in words {
                if wordsCount.keys.contains(word) {
                    wordsCount[word]! += 1
                }
                else {
                    wordsCount[word] = 1
                }
            }
            let rest = wordsCount.sorted { pair1, pair2 in
                if pair1.value == pair2.value {
                    return pair1.key < pair2.key
                }
                else {
                    return pair1.value > pair2.value
                }
            }
            return rest.prefix(k).map { $0.key}
        }
        //        let words = ["the", "day", "is", "sunny", "the", "the", "the", "sunny", "is", "is"], k = 4
        let words = ["i", "love", "leetcode", "i", "love", "coding"], k = 2
        print(mine(words,k))
    }
    
    func lc1738() {
        // 1738. 找出第 K 大的异或坐标值
        // https://leetcode-cn.com/problems/find-kth-largest-xor-coordinate-value/
        func kthLargestValue(_ matrix: [[Int]], _ k: Int) -> Int {
            let m = matrix.count, n = matrix[0].count
            var pre = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)
            var results = [Int]()
            for i in 1...m {
                for j in 1...n {
                    let preIJ = pre[i - 1][j] ^ pre[i][j - 1] ^ pre[i - 1][j - 1] ^ matrix[i - 1][j - 1]
                    pre[i][j] = preIJ
                    //                    print(i,j,preIJ,matrix[i-1][j-1],separator: " ")
                    results.append(preIJ)
                }
            }
            
            func nthElement(_ left: Int,_ kth: Int, _ right: Int) {
                if left >= right {
                    return
                }
                func swap(_ index1: Int, _ index2: Int) {
                    (results[index1], results[index2]) = (results[index2], results[index1])
                }
                
                let pivot = left + Int(arc4random_uniform(UInt32(right - left + 1)))
                swap(pivot, right)
                // 三路划分
                var sepl = left - 1, sepr = left - 1
                let rightValue = results[right]
                for i in left...right {
                    let curValue = results[i]
                    if curValue > rightValue {
                        sepr += 1
                        swap(sepr, i)
                        sepl += 1
                        swap(sepl, sepr)
                    }
                    else if curValue == rightValue {
                        sepr += 1
                        swap(sepr, i)
                    }
                }
                let kthInd = left + kth
                if sepl < kthInd && kthInd <= sepr {
                    return
                }
                else if kth <= sepl {
                    nthElement(left, kth, sepl)
                }
                else {
                    nthElement(sepr + 1, kth - (sepr - left + 1), right)
                }
            }
            nthElement(0, k - 1, results.count - 1)
            //            results.sort { v1, v2 in
            //                return v1 > v2
            //            }
            return results[k - 1]
        }
        let matrix = [[3,10,9,5,5,7],[0,1,7,3,8,1],[9,3,0,6,1,6],[10,2,9,10,10,7]], k = 18
        print(kthLargestValue(matrix,k))
    }
    
    func lc36() {
        // 36. 有效的数独
        // https://leetcode-cn.com/problems/valid-sudoku/
        func isValidSudoku(_ board: [[Character]]) -> Bool {
            let bools = [[Bool]](repeating: [Bool](repeating: false, count: 9), count: 9)
            var row = bools, col = bools, area = bools
            let oneAsciiValue = Character("1").asciiValue!
            for i in 0..<9 {
                for j in 0..<9 {
                    if board[i][j] == "." {
                        continue
                    }
                    
                    let c = Int(board[i][j].asciiValue! - oneAsciiValue)
                    let idx = i / 3 * 3 + j / 3
                    if !row[i][c] && !col[j][c] && !area[idx][c] {
                        row[i][c] = true
                        col[j][c] = true
                        area[idx][c] = true
                    }
                    else {
                        return false
                    }
                }
            }
            return true
        }
    }
    
    func lc993() {
        // 993. 二叉树的堂兄弟节点
        // https://leetcode-cn.com/problems/cousins-in-binary-tree/
        func isCousins(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
            func dfs(_ rt: TreeNode?, _ fa: TreeNode?, _ depth: Int, _ t: Int) -> (Bool,Int, Int) {
                if rt == nil {
                    // 使用 -1 代表未搜索到
                    return (false, -1, -1)
                }
                if rt!.val == t {
                    // 使用1代表搜索值t 为root
                    return (true,fa == nil ? 1 : fa!.val, depth)
                }
                let l = dfs(rt!.left, rt, depth + 1, t)
                if l.0 {
                    return l
                }
                return dfs(rt!.right, rt, depth + 1, t)
            }
            
            func bfs(_ rt: TreeNode?, _ fa: TreeNode?, _ depth: Int, _ t: Int) -> (Bool,Int, Int) {
                var d = Array<(TreeNode, TreeNode?, Int)>()
                d.append((rt!, nil, 0))
                while !d.isEmpty {
                    var size = d.count
                    while size > 0 {
                        size -= 1
                        let ele = d.removeFirst()
                        let cur = ele.0, fa = ele.1, depth = ele.2
                        if cur.val == t {
                            return (true, fa == nil ? 0 : fa!.val, depth)
                        }
                        if cur.left != nil {
                            d.append((cur.left!, cur, depth + 1))
                        }
                        if cur.right != nil {
                            d.append((cur.right!, cur, depth + 1))
                        }
                    }
                }
                return (false, -1, -1)
            }
            
            let xi = dfs(root, nil, 0, x)
            let yi = dfs(root, nil, 0, y)
            print(xi,yi)
            return xi.0 == yi.0 && xi.1 != yi.1 && xi.2 == yi.2
        }
        
        func mine(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
            if root == nil {
                return false
            }
            // 元素数组记录当前节点及其父节点
            var queue = Array<(TreeNode,TreeNode?)>()
            queue.append((root!,nil))
            while !queue.isEmpty {
                let size = queue.count
                var conxy = [TreeNode?]()
                for _ in 0..<size {
                    let (cur, parent) = queue.removeFirst()
                    let val = cur.val
                    if val == x || val == y {
                        conxy.append(parent)
                    }
                    
                    if cur.left != nil {
                        queue.append((cur.left!, cur))
                    }
                    if cur.right != nil {
                        queue.append((cur.right!, cur))
                    }
                }
                let conxyCount = conxy.count
                // xy都未出现
                if conxyCount == 0 {
                    continue
                }
                // x,y 只出现一个
                else if conxyCount == 1 {
                    return false
                }
                else if conxyCount == 2 {
                    // xy都出现，然后判断父节点是否一样
                    return conxy.first! !== conxy.last!
                }
            }
            return false
        }
        
        let t1 = TreeNode(1)
        let t2 = TreeNode(2)
        let t3 = TreeNode(3)
        let t4 = TreeNode(4)
        let t5 = TreeNode(5)
        
        t1.left = t2
        t1.right = t3
        
        t2.parent = t1
        t3.parent = t1
        
        t2.right = t4
        t4.parent = t2
        
        t3.right = t5
        t5.parent = t3
        print(isCousins(t1 ,5 ,4))
    }
    
    func lc27() {
        // 27. 移除元素
        // https://leetcode-cn.com/problems/remove-element/
        func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
            var ans = 0
            for num in nums {
                if num != val {
                    nums[ans] = num
                    ans += 1
                }
            }
            return ans
        }
        func mine(_ nums: inout [Int], _ val: Int) -> Int {
            var i = 0, j = nums.count - 1
            while i >= 0 && i <= j {
                if nums[i] == val {
                    (nums[i], nums[j]) = (nums[j], nums[i])
                    j -= 1
                }
                else {
                    i += 1
                }
            }
            return j + 1
        }
        var nums = [3,2,2,3], val = 3
        let lett = mine(&nums, val)
        print(nums[..<lett])
    }
    func lc150() {
        // 150. 逆波兰表达式求值
        // https://leetcode-cn.com/problems/evaluate-reverse-polish-notation/
        func evalRPN(_ tokens: [String]) -> Int {
            func calc(_ a: Int, _ b: Int, _ op: String) -> Int {
                switch op {
                case "+":
                    return a + b
                case "-":
                    return a - b
                case "*":
                    return a * b
                case "/":
                    return a / b
                default:
                    return -1
                }
            }
            
            var optArray = [Int]()
            for opt in tokens {
                if "+-*/".contains(opt) {
                    if let right = optArray.popLast(),
                       let left = optArray.popLast() {
                        optArray.append(calc(left, right, opt))
                    }
                }
                else {
                    optArray.append(Int(opt)!)
                }
            }
            return optArray.popLast()!
        }
    }
    
    func lc1035() {
        // 1035. 不相交的线
        // https://leetcode-cn.com/problems/uncrossed-lines/
        func maxUncrossedLines(_ nums1: [Int], _ nums2: [Int]) -> Int {
            let n = nums1.count, m = nums2.count
            var f = [[Int]](repeating: [Int](repeating: 0, count: m + 1), count: n + 1)
            for i in 1...n {
                for j in 1...m {
                    f[i][j] = Swift.max(f[i - 1][j], f[i][j - 1])
                    if nums1[i - 1] == nums2[j - 1] {
                        f[i][j] = Swift.max(f[i][j], f[i - 1][j - 1] + 1)
                    }
                }
            }
            return f[n][m]
        }
        let nums1 = [2,5,1,2,5], nums2 = [10,5,2,1,5,2]
        print(maxUncrossedLines(nums1, nums2))
    }
    func 剑指Offer26() {
        // 剑指 Offer 26. 树的子结构
        // https://leetcode-cn.com/problems/shu-de-zi-jie-gou-lcof/
        func isSubStructure(_ A: TreeNode?, _ B: TreeNode?) -> Bool {
            return swordOffer.hasSubtree(A, B)
        }
    }
    func lc226() {
        // 226. 翻转二叉树
        // https://leetcode-cn.com/problems/invert-binary-tree/
        // 二叉树的镜像
        //  https://leetcode-cn.com/problems/er-cha-shu-de-jing-xiang-lcof/
        func invertTree(_ root: TreeNode?) -> TreeNode? {
            if root == nil {
                return root
            }
            let tmp = root!.left
            root!.left = invertTree(root!.right)
            root!.right = invertTree(tmp)
            return root
        }
    }
    
    func lc101() {
        // 对称的二叉树
        // https://leetcode-cn.com/problems/dui-cheng-de-er-cha-shu-lcof/
        // 101. 对称二叉树
        // https://leetcode-cn.com/problems/symmetric-tree/
        func isSymmetric(_ root: TreeNode?) -> Bool {
            return swordOffer.isSymmetrical(root)
        }
    }
    
    func 剑指Offer32I() {
        // 剑指 Offer 32 - I. 从上到下打印二叉树
        // https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-lcof/
        func levelOrder(_ root: TreeNode?) -> [Int] {
            var queue = Array<TreeNode>()
            var ret = [Int]()
            if root == nil {
                return ret
            }
            queue.append(root!)
            
            while !queue.isEmpty {
                let tNode = queue.removeFirst()
                ret.append(tNode.val)
                if tNode.left != nil {
                    queue.append(tNode.left!)
                }
                if tNode.right != nil {
                    queue.append(tNode.right!)
                }
            }
            return ret
            //            return swordOffer.printFromTopToBottom(root)
        }
    }
    func 剑指Offer32II() {
        // 剑指 Offer 32 - II. 从上到下打印二叉树 II
        // https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-ii-lcof/
        func levelOrder(_ root: TreeNode?) -> [[Int]] {
            var queue = Array<TreeNode>()
            var ret = [[Int]]()
            if root == nil {
                return ret
            }
            queue.append(root!)
            
            while !queue.isEmpty {
                var list = [Int]()
                var cnt = queue.count
                while cnt > 0 {
                    cnt -= 1
                    let tNode = queue.removeFirst()
                    list.append(tNode.val)
                    if tNode.left != nil {
                        queue.append(tNode.left!)
                    }
                    if tNode.right != nil {
                        queue.append(tNode.right!)
                    }
                }
                
                if list.count > 0 {
                    ret.append(list)
                }
            }
            return ret
            //            return swordOffer.printFromTopToBottomPerLine(root)
        }
    }
    func 剑指Offer32III() {
        // 剑指 Offer 32 - III. 从上到下打印二叉树 III
        // https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-iii-lcof/
        func levelOrder(_ root: TreeNode?) -> [[Int]] {
            var queue = Array<TreeNode>()
            var ret = [[Int]]()
            if root == nil {
                return ret
            }
            queue.append(root!)
            var reverse = false
            while !queue.isEmpty {
                var list = [Int]()
                var cnt = queue.count
                while cnt > 0 {
                    cnt -= 1
                    let tNode = queue.removeFirst()
                    list.append(tNode.val)
                    if tNode.left != nil {
                        queue.append(tNode.left!)
                    }
                    if tNode.right != nil {
                        queue.append(tNode.right!)
                    }
                }
                
                if list.count > 0 {
                    ret.append(reverse ? list.reversed() : list)
                }
                reverse.toggle()
            }
            return ret
            //            return swordOffer.printFromTopToBottomPerLine(root)
        }
    }
    
    func 剑指Offer33() {
        // 剑指 Offer 33. 二叉搜索树的后序遍历序列
        // https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-hou-xu-bian-li-xu-lie-lcof/
        func verifyPostorder(_ postorder: [Int]) -> Bool {
            var stack = Stack<Int>()
            var root = Int.max
            for val in postorder.reversed() {
                if val > root {
                    return false
                }
                while !stack.isEmpty && stack.top! > val {
                    root = stack.pop()!
                }
                stack.push(val)
            }
            return true
        }
    }
    
    func lc104() {
        // 剑指 Offer 55 - I. 二叉树的深度
        // https://leetcode-cn.com/problems/er-cha-shu-de-shen-du-lcof/
        // 104. 二叉树的最大深度
        // https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/
        func maxDepth(_ root: TreeNode?) -> Int {
            if root == nil {
                return 0
            }
            else {
                let left = maxDepth(root!.left)
                let right = maxDepth(root!.right)
                return Swift.max(left, right) + 1
            }
        }
        
        func maxDepth1(_ root: TreeNode?) -> Int {
            if root == nil {
                return 0
            }
            var queue = Queue<TreeNode>()
            queue.enqueue(root!)
            var res = 0
            while !queue.isEmpty {
                let size = queue.count
                for _ in 0..<size {
                    let node = queue.dequeue()!
                    if node.left != nil {
                        queue.enqueue(node.left!)
                    }
                    if node.right != nil {
                        queue.enqueue(node.right!)
                    }
                }
                res += 1
            }
            return res
        }
    }
    
    func lc810() {
        // 810. 黑板异或游戏
        // https://leetcode-cn.com/problems/chalkboard-xor-game/
        func xorGame(_ nums: [Int]) -> Bool {
            if nums.count % 2 == 0 {
                return true
            }
            var xor = 0
            for num in nums {
                xor ^= num
            }
            return xor == 0
        }
    }
    func lc113() {
        // 剑指 Offer 34. 二叉树中和为某一值的路径
        // https://leetcode-cn.com/problems/er-cha-shu-zhong-he-wei-mou-yi-zhi-de-lu-jing-lcof/
        // 113. 路径总和 II
        // https://leetcode-cn.com/problems/path-sum-ii/
        func pathSum(_ root: TreeNode?, _ targetSum: Int) -> [[Int]] {
            var ret = [[Int]]()
            var path = [Int]()
            func dfs(_ rt: TreeNode?, _ sum: Int) {
                if rt == nil {
                    return
                }
                path.append(rt!.val)
                let remaind = sum - rt!.val
                if rt!.left == nil &&
                    rt!.right == nil &&
                    remaind == 0 {
                    let p = path
                    ret.append(p)
                }
                dfs(rt!.left, remaind)
                dfs(rt!.right, remaind)
                _ = path.popLast()
            }
            dfs(root, targetSum)
            return ret
        }
    }
    func lc426() {
        // 二叉搜索树与双向链表
        // https://leetcode-cn.com/problems/er-cha-sou-suo-shu-yu-shuang-xiang-lian-biao-lcof/
        //
        //
        var pre: TreeNode?, head: TreeNode?
        func treeToDoublyList(_ root: TreeNode?) -> TreeNode? {
            
            func dfs(_ cur: TreeNode?) {
                if cur == nil {
                    return
                }
                dfs(cur!.left)
                // pre用于记录双向链表中位于cur左侧的节点，即上一次迭代中的cur,当pre==null时，cur左侧没有节点,即此时cur为双向链表中的头节点
                if pre == nil {
                    head = cur
                }
                else {
                    // 反之，pre!=null时，cur左侧存在节点pre，需要进行pre.right=cur的操作
                    pre!.right = cur
                }
                // pre是否为null对这句没有影响,且这句放在上面两句if else之前也是可以的
                cur!.left = pre
                
                pre = cur!
                
                dfs(cur!.right)
            }
            
            if root == nil {
                return nil
            }
            dfs(root)
            // 进行头结点和为节点的相互指向
            pre?.right = head
            head?.left = pre
            return head
        }
    }
    
    func lc297() {
        // 剑指 Offer 37. 序列化二叉树
        // https://leetcode-cn.com/problems/xu-lie-hua-er-cha-shu-lcof/
        // 297. 二叉树的序列化与反序列化
        // https://leetcode-cn.com/problems/serialize-and-deserialize-binary-tree/
        class Codec {
            func serialize(_ root: TreeNode?) -> String {
                if root == nil {
                    return "#"
                }
                return "\(root!.val),\(serialize(root!.left)),\(serialize(root!.right))"
            }
            
            func deserialize(_ data: String) -> TreeNode? {
                var start = -1
                let strArr = data.split(separator: ",")
                func deserialize() -> TreeNode? {
                    start += 1
                    if start < strArr.count &&
                        strArr[start] != "#" {
                        let node = String(strArr[start])
                        let val = Int(node) ?? 0
                        let t = TreeNode(val)
                        t.left = deserialize()
                        t.right = deserialize()
                        return t
                    }
                    return nil
                }
                return deserialize()
            }
        }
    }
    
    func 剑指Offer54() {
        // 剑指 Offer 54. 二叉搜索树的第k大节点
        // https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-di-kda-jie-dian-lcof/
        func kthLargest(_ root: TreeNode?, _ k: Int) -> Int {
            var count = 0
            var res = 0
            func dfs(_ rt: TreeNode?) {
                if rt == nil || count == k {
                    return
                }
                dfs(rt!.right)
                count += 1
                if count == k {
                    res = rt!.val
                    return
                }
                dfs(rt!.left)
            }
            dfs(root)
            return res
        }
    }
    
    func lc110() {
        // 平衡二叉树
        // https://leetcode-cn.com/problems/ping-heng-er-cha-shu-lcof/
        // 110. 平衡二叉树
        // https://leetcode-cn.com/problems/balanced-binary-tree/
        func isBalanced(_ root: TreeNode?) -> Bool {
            func recur(_ rt: TreeNode?) -> Int {
                if rt == nil {
                    return 0
                }
                let left = recur(rt!.left)
                if left == -1 {
                    return -1
                }
                let right = recur(rt!.right)
                if right == -1 {
                    return -1
                }
                return Swift.abs(left - right) < 2 ? Swift.max(left, right) + 1 :  -1
            }
            
            return recur(root) != -1
        }
    }
    func lc235() {
        // 剑指 Offer 68 - I. 二叉搜索树的最近公共祖先
        // 235. 二叉搜索树的最近公共祖先 https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-zui-jin-gong-gong-zu-xian-lcof/
        //
        // https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/
        func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
            return swordOffer.lowestCommonAncestor(root, p, q)
        }
    }
    
    func lc236() {
        // 剑指 Offer 68 - II. 二叉树的最近公共祖先
        // https://leetcode-cn.com/problems/er-cha-shu-de-zui-jin-gong-gong-zu-xian-lcof/
        // 236. 二叉树的最近公共祖先
        // https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/
        func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
            return swordOffer.lowestCommonAncestor2(root, p, q)
        }
    }
    
    func lc8() {
        //  把字符串转换成整数
        // https://leetcode-cn.com/problems/ba-zi-fu-chuan-zhuan-huan-cheng-zheng-shu-lcof/
        // 8. 字符串转换整数 (atoi)
        // https://leetcode-cn.com/problems/string-to-integer-atoi/
        func myAtoi(_ s: String) -> Int {
            let str = s.trimmingCharacters(in: CharacterSet.whitespaces)
            if str.count == 0 {
                return 0
            }
            var res = 0
            var hasJudgeSign = false
            let isNegatvive = str.first! == "-" ? -1 : 1
            let zeroAsciiValue = Character("0").asciiValue!
            for c in str {
                if !hasJudgeSign {
                    hasJudgeSign = true
                    if isNegatvive == -1 {
                        continue
                    }
                }
                if c < "0" || c > "9" {
                    return 0
                }
                let val = Int(c.asciiValue! - zeroAsciiValue) * isNegatvive
                
                let maxDiv = Int.max / 10
                if res > maxDiv || (res == maxDiv &&  val > Int.max % 10) {
                    return 0
                }
                let minDiv = Int.min / 10
                if res < minDiv || (res == minDiv &&  val < Int.min % 10) {
                    return 0
                }
                res = res * 10 +  val
            }
            return res
        }
    }
}
