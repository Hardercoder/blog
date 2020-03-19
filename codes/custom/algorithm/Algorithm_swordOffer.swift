//
//  algorithm.swift
//  MyLib_Example
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 zhoukang. All rights reserved.
//

import Foundation

class Algorithm_swordOffer {
    public func testAlgorithm() {
        //        _ = [
        //            [1,   4,  7, 11, 15],
        //            [2,   5,  8, 12, 19],
        //            [3,   6,  9, 16, 22],
        //            [10, 13, 14, 17, 24],
        //            [18, 21, 23, 26, 30]
        //        ]
        //        reverse("  I  am   a   student  ")
        //        print(sum_Solution(7))
        //        print(printMatrix(tupa))
        //        print("超过一半次数的数为 \(moreThanHalfNum_Solution([3,3,3,3,2,2,1]))")
        //        print("前K个最大的数\(getLeastNumbers_Solution([4,5,1,6,2,7,3,8], 4))")
        //        print("仅出现一次的数字\(firstAppearingOnce(in: [1,2,3,4,5,4,2,1]))")
        //        print("1 到 n 中1出现的次数\(numberOf1Between1AndN_Solution(12))")
        //        print("数字序列中第16位 \(getDigitAtIndex(17))")
        //        print("把数组排成最小的数 \(printMinNumber([3,32,321]))")
        //        print("滑动窗口最大值\(maxSlidingWindow([2, 3, 4, 2, 6, 2, 5, 1], 3))")
        //        let a = [[1,    10 ,  3,    8],
        //                 [12  , 2,    9    ,6],
        //                 [5    ,7   , 4    ,11],
        //                 [3    ,7    ,16   ,5]]
        //        print("最大礼物 \(getMost(a))")
        //        print("数组中最长不重复子数组\(longestSubStringWithoutDuplication([1,2,3,5,8,3,9,2]))")
        //        print("第15个丑数\(getUglyNumber_Solution(15))")
        //        print("最大利润 \(maxProfit([5,4,3,2,8]))")
        
        //        var nums = [1,2,3,4,5]
        //        reOrderArray1(&nums)
        //        print(nums)
        
        //        print(movingCount(18, 38, 42))
        
        //        let b = hasPath(["a","b","t","g","c","f","c","s","j","d","e","h"], rows: 3, cols: 4, str: ["b","f","c","e"])
        //        print(b)
        //        print1ToMaxOfNDigits(3)
        //        print(hasAnyDuplicateIn(intArr: [2, 3, 1, 0, 5, 5]))
        //        let a = isNumIn(tupa, target: 25)
        //        print(twoSum([0,1,2,3,4,5], 3))
        //
        //        print(findKthLargest([3,2,1,5,6,4], 2))
    }
    // MARK: 剑指offer题解之Swift实现 https://cyc2018.github.io/CS-Notes/#/README
    // MARK: 数组中重复的数字
    // 思想:  将每个数字放到它对应的位置上，比如nums[i] 放到 i的位置上，如果有两个放到了一个地方，就可以校验出来
    func hasAnyDuplicateIn(intArr nums: [Int]) -> (Bool, Int) {
        if nums.count == 0 {
            return (false, 0)
        }
        var compareNums = nums
        
        for i in 0..<compareNums.count {
            while compareNums[i] != i {
                // 得出它该放的位置
                let j = compareNums[i]
                // 如果它本来的位置上已经有数据，就重复了
                if j == compareNums[j] {
                    return (true, j)
                }
                // 交换i 和  nums[i] 位置处的数字
                (compareNums[i], compareNums[j]) = (compareNums[j], compareNums[i])
            }
        }
        return (false, 0)
    }
    // MARK: 二维数组中的查找
    // 思想:  找规律，从左下角或右上角入手
    func isNumIn(_ nums:[[Int]], target: Int) -> Bool {
        if nums.count == 0 || nums[0].count == 0 {
            return false
        }
        let rows = nums.count, cols = nums[0].count
        var row = 0
        var col = cols - 1
        while row < rows && col >= 0 {
            let valueAtRowCol = nums[row][col]
            if target == valueAtRowCol {
                return true
            }
            else if (target > valueAtRowCol) {
                row += 1
            }
            else {
                col -= 1
            }
        }
        return false
    }
    // MARK: 替换空格
    // 思想:  给str扩容，之后双指针分别从最后往前移动。这样可以防止插入%02造成的内存移动操作
    // 当然这里我们没有写，因为swift中字符串使用的是String.Index，操作比较繁琐。也可以写，只是嫌麻烦
    func replaceSpace(_ str:inout String) -> String {
        return str.replacingOccurrences(of: " ", with: "%02")
    }
    // MARK: 从尾到头打印链表
    // 思想:  递归法
    func printListFromTailToHead1(_ listNode:ListNode?) -> [Int] {
        var ret = [Int]()
        if listNode != nil {
            ret.append(contentsOf: printListFromTailToHead1(listNode!.next))
            ret.append(listNode!.val)
        }
        return ret
    }
    // 思想: 先翻转链表，然后遍历链表输出
    func printListFromTailToHead2(_ listNode:ListNode?) -> [Int] {
        var mListNode = listNode
        var head:ListNode? = ListNode(-1)
        while mListNode != nil {
            let memo = mListNode!.next
            mListNode?.next = head!.next
            head!.next = mListNode
            mListNode = memo
        }
        
        var ret = [Int]()
        head = head!.next
        if head != nil {
            ret.append(head!.val)
            head = head!.next
        }
        return ret
    }
    // MARK: 重建二叉树
    // 思想:  从前序遍历中取出对应子树的根节点，然后找到中序遍历中它的index，分割中序遍历，它之前的是左子树，之后的是右子树。循环往复
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        // 缓存中序遍历数组的value和index对应的map
        var inorderValueIndexMap = [Int:Int]()
        func reBuildTree(_ preL:Int,
                         _ preR:Int,
                         _ inorder:Int) -> TreeNode? {
            if preL > preR {
                return nil
            }
            // 从前序遍历数组中获取对应的值，然后去中序遍历数组获取它所对应的下标
            let rootValue = preorder[preL]
            
            let root = TreeNode(rootValue)
            
            let inOrderIndex = inorderValueIndexMap[rootValue]!
            let leftTreeSize = inOrderIndex - inorder
            root.left = reBuildTree(preL + 1,
                                    preL + leftTreeSize,
                                    inorder)
            root.right = reBuildTree(preL + leftTreeSize + 1,
                                     preR,
                                     inorder + leftTreeSize + 1)
            return root
        }
        
        // 缓存中序遍历数组的value和index
        for i in 0..<inorder.count {
            inorderValueIndexMap[inorder[i]] = i
        }
        return reBuildTree(0,
                           preorder.count-1,
                           0)
    }
    // MARK: 二叉树的下一个结点
    // 思想:  中序遍历下。一个节点的右子树不为空时，它的下一个节点为右子树的最左子节点；右子树为空的情况下，它的下一个节点是父节点的左子节点为它自身的节点
    func nextTree(_ pNode: TreeNode?) -> TreeNode? {
        var curNode = pNode
        if curNode?.right != nil {
            var node = curNode?.right
            while node?.left != nil {
                node = node?.left
            }
            return node
        }
        else {
            while curNode?.parent != nil {
                let parent = curNode?.parent
                if parent?.left === curNode {
                    return parent
                }
                curNode = curNode?.parent
            }
        }
        return nil
    }
    
    // MARK: 用两个栈实现队列
    // 思想:  一个用于进栈，进栈时被反转，出栈时进入另一个栈，这个栈再出栈。此时反转了两次之后实现了FIFO
    var inStack = Stack<Int>()
    var outStack = Stack<Int>()
    func push(_ node:Int) {
        inStack.push(node)
    }
    func pop() -> Int? {
        if outStack.isEmpty {
            while !inStack.isEmpty {
                outStack.push(inStack.pop()!)
            }
        }
        
        if outStack.isEmpty {
            return nil
        }
        
        return outStack.pop()
    }
    // MARK: 斐波那契数列
    // 思想:  当前数为它之前两个数的和
    var fibs = [0,1]
    func fibonacci(at n:Int) -> Int {
        if n < fibs.count {
            return fibs[n]
        }
        else {
            // 进行扩容
            fibs += Array(repeating: 0, count: n + 1 - fibs.count)
        }
        
        var pre2 = 0, pre1 = 1
        var fib = 0
        for i in 2..<n {
            fib = pre2 + pre1
            pre2 = pre1
            pre1 = fib
            
            fibs[i] = fib
        }
        return fib
    }
    
    // MARK: 矩形覆盖
    // 思想:  和斐波那契数列一样，只是起始值不同
    func rectCover(_ n: Int) -> Int {
        if n <= 2 {
            return n
        }
        var pre2 = 1, pre1 = 2
        var result = 0
        for _ in 3...n {
            result = pre2 + pre1
            pre2 = pre1
            pre1 = result
            
        }
        return result
    }
    // MARK: 跳台阶
    func jumpFloor(_ n: Int) -> Int {
        if n <= 2 {
            return n
        }
        var pre2 = 1, pre1 = 2
        var result = 0
        for _ in 3...n {
            result = pre2 + pre1
            pre2 = pre1
            pre1 = result
            
        }
        return result
    }
    // MARK: 变态跳台阶
    func jumpFloor2(_ n: Int) -> Int {
        var dp = Array(repeating: 1, count: n)
        for i in 1..<n {
            for j in 0..<i {
                dp[i] += dp[j]
            }
        }
        return dp[n - 1]
    }
    func jumpFloor22(_ n: Int) -> Int {
        return Int(powf(2, Float(n - 1)))
    }
    // MARK: 旋转数组的最小数字
    // 思想:  使用二分法找到非递增的那个子数组，那个子数组也可以简单的看做一个小的旋转数组
    func minNumberInRotateArray(nums: [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        //切换到顺序查找
        func minNumber(l: Int, h:Int) -> Int {
            for i in l..<h {
                if nums[i] > nums[i + 1] {
                    return nums[i + 1]
                }
            }
            return nums[l]
        }
        
        var l = 0, h = nums.count - 1
        while (l < h) {
            let m = l + (h - l) / 2
            if nums[l] == nums[m] && nums[m] == nums[h] {
                return minNumber(l: l, h: h)
            }
            else if nums[m] <= nums[h] {
                h = m
            }
            else {
                l = m + 1
            }
        }
        return nums[l]
    }
    
    // MARK: 矩阵中的路径
    // 思想:  构造一个矩阵后，把矩阵所有的位置先标记为未走过。然后从起点开始，按照定义的方向往各个地方行走，如果后包含了我们定义的路径就返回
    private static let nextDirection = [(0, -1), (0, 1), (-1, 0), (1, 0)]
    func hasPath(_ array:[Character],
                 rows: Int,
                 cols: Int,
                 str: [Character]) -> Bool {
        if rows == 0 || cols == 0 {
            return false
        }
        // 标记是否走过，默认为false，路径不可达时对应的位置设置为false
        var marked = [[Bool]]()
        // 矩阵，存放数据
        var matrix = [[Character]]()
        // 构建矩阵
        func buildMatrixAndMarked(_ array: [Character]) {
            for r in 0..<rows {
                var matrixRow = [Character]()
                var markedRow = [Bool]()
                for c in 0..<cols {
                    let idx = r * cols + c
                    matrixRow.append(array[idx])
                    markedRow.append(false)
                }
                matrix.append(matrixRow)
                marked.append(markedRow)
            }
        }
        
        // 回溯
        func backtracking(_ pathLen: Int,
                          _ r: Int,
                          _ c: Int) -> Bool {
            if pathLen == str.count {
                return true
            }
            
            if r < 0 ||
                r >= rows ||
                c < 0 ||
                c >= cols ||
                matrix[r][c] != str[pathLen] ||
                marked[r][c] {
                return false
            }
            marked[r][c] = true
            for n in Algorithm_swordOffer.nextDirection  {
                if backtracking(pathLen + 1,
                                r + n.0,
                                c + n.1) {
                    return true
                }
            }
            marked[r][c] = false
            return false
        }
        
        buildMatrixAndMarked(array)
        for i in 0..<rows {
            for j in 0..<cols {
                if backtracking(0,
                                i,
                                j) {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: 机器人的运动范围
    // 思想:  和上面的思想一样，只是内部路径不可走的判断条件不一样
    func movingCount(_ threshold: Int, _ rows: Int, _ cols: Int) -> Int {
        var cnt = 0
        // 标记对应的格子是否走过
        var marked = [[Bool]]()
        // 矩阵
        var digitSum = [[Int]]()
        // 初始化坐标系 和 标记位
        func initDigitSum() {
            // 存储对应数字 各个位上的和
            var digitSumOne = Array(repeating: 0, count: max(rows, cols))
            for i in 0..<digitSumOne.count {
                var n = i
                while n > 0 {
                    digitSumOne[i] += n % 10
                    n /= 10
                }
            }
            for r in 0..<rows {
                var digitRow = [Int]()
                var markedRow = [Bool]()
                for c in 0..<cols {
                    let val = digitSumOne[r] + digitSumOne[c]
                    digitRow.append(val)
                    markedRow.append(false)
                }
                digitSum.append(digitRow)
                marked.append(markedRow)
            }
        }
        // 深度优先搜索
        func dfs(_ r: Int,
                 _ c: Int) {
            if r < 0 ||
                r >= rows ||
                c < 0 ||
                c >= cols ||
                marked[r][c] {
                return
            }
            marked[r][c] = true
            
            if (digitSum[r][c] > threshold) {
                return
            }
            cnt += 1
            for n in Algorithm_swordOffer.nextDirection  {
                dfs(r + n.0,
                    c + n.1)
            }
        }
        
        // 初始化数据
        initDigitSum()
        dfs(0,
            0)
        return cnt
    }
    // MARK: 剪绳子
    // 思想:  动态规划
    func integerBreak(_ n: Int) -> Int {
        var dp = Array(repeating: 0, count: n + 1)
        dp[1] = 1
        for i in 2...n {
            for j in 1..<i {
                dp[i] = max(dp[i], max(j * (i - j), dp[j] * (i - j)))
            }
        }
        return dp[n]
    }
    
    // MARK: 二进制中 1 的个数
    // 思想:  n & (n - 1) 会将二进制中最右侧的1变为0
    func numberOf1In(n: Int) -> Int {
        var cnt = 0
        var mN = n
        while mN != 0 {
            mN &= (mN - 1)
            cnt += 1
        }
        return cnt
    }
    
    // MARK: 数值的整数次方
    // 思想:  exponent为奇数是 base^exponent = (base * base)^(expoent/2) * base
    // exponent为偶数时 base^expoent = (base * base)^(exponent/2)
    // 当expoent为负数时，最终的结果为正数时的倒数
    func cusPower(base:Double, exponent: Int) -> Double {
        if exponent == 0 {
            return 1
        }
        if exponent == 1 {
            return base
        }
        var isNegative = false
        var mExponent = exponent
        if mExponent < 0 {
            mExponent = -mExponent
            isNegative = true
        }
        var pow = cusPower(base: base * base, exponent: mExponent/2)
        if mExponent % 2 != 0 {
            pow *= base
        }
        return isNegative ? 1 / pow : pow
    }
    // MARK: 打印从 1 到最大的 n 位数
    // 思想:  通过定义一个数组，递归操作它对应的位数（个位，十位，百位，千位等）
    func print1ToMaxOfNDigits(_ n:Int) {
        if n <= 0 {
            return
        }
        // 打印数字数组
        func printNumber(_ number:[Int]) {
            var index = 0
            while index < number.count && number[index] == 0 {
                index += 1
            }
            while index < number.count {
                print(number[index], separator: "", terminator: "")
                index += 1
            }
            print("", separator: "", terminator: "\n")
        }
        // 递归方法
        func print1ToMaxOfNDigits(_ number:inout [Int], _ digit: Int) {
            if digit == number.count {
                printNumber(number)
                return
            }
            for i in 0..<10 {
                number[digit] = i
                print1ToMaxOfNDigits(&number, digit + 1)
            }
        }
        
        // 申请N个长度的数组
        var number:[Int] = Array(repeating: 0, count: n)
        print1ToMaxOfNDigits(&number, 0)
    }
    // MARK: 在 O(1) 时间内删除链表节点
    // 思想:  若这个节点有后序节点，就伪装成它的下一个节点，并把它下一个节点删除；若它是最后的节点，就需要遍历链表，找到它的上一个节点，然后把它删除
    func deleteNode(_ head:ListNode?, tobeDelete: ListNode?) -> ListNode? {
        if head == nil || tobeDelete == nil {
            return head
        }
        var nHead = head
        if tobeDelete?.next != nil {
            // 要删除的节点不是尾节点
            let next = tobeDelete!.next
            tobeDelete!.val = next?.val ?? 0
            tobeDelete!.next = next?.next
        }
        else {
            if nHead === tobeDelete {
                nHead = nil
            }
            else {
                var cur = nHead
                while !(cur?.next === tobeDelete) {
                    cur = cur?.next
                }
                cur?.next = nil
            }
        }
        
        return nHead
    }
    // MARK: 删除链表中重复的结点
    // 思想:  递归法
    func deleteDuplication(_ pHead: ListNode?) -> ListNode? {
        if pHead == nil || pHead?.next == nil {
            return pHead
        }
        var next = pHead?.next
        if pHead?.val == next?.val {
            while next != nil && pHead?.val == next?.val {
                next = next?.next
            }
            return deleteDuplication(next)
        }
        else {
            pHead?.next = deleteDuplication(pHead?.next)
            return pHead
        }
    }
    // MARK: 调整数组顺序使奇数位于偶数前面
    // 思想:  先算出有多少奇数，然后顺序遍历，按照奇偶的index存储另一个数组中
    func reOrderArray(_ nums:inout [Int]) {
        func isEven(_ x: Int) -> Bool {
            return x % 2 == 0
        }
        // 奇数的数量
        var oddCnt = 0
        for num in nums {
            if !isEven(num) {
                oddCnt += 1
            }
        }
        
        let orgNums = nums
        var i = 0, j = oddCnt
        for num in orgNums {
            if isEven(num) {
                // 偶数
                nums[j] = num
                j += 1
            }
            else {
                // 奇数
                nums[i] = num
                i += 1
            }
        }
    }
    // 冒泡 思想
    // 思想:  若相邻两个数，一个是奇数，一个是偶数，就把偶数往后冒泡
    func reOrderArray1(_ nums:inout [Int]) {
        func isEven(_ x: Int) -> Bool {
            return x % 2 == 0
        }
        
        for i in (0..<nums.count).reversed() {
            for j in 0..<i {
                if isEven(nums[j]) && !isEven(nums[j + 1]) {
                    (nums[j], nums[j + 1]) = (nums[j + 1], nums[j])
                }
            }
        }
    }
    // MARK: 链表中倒数第 K 个结点
    // 思想:  使用两个指针，一个从第K个位置，一个从头，当第K个位置的指针到到链表末尾时，第二个指针到达倒数第k个位置
    func findKthToTail(_ head: ListNode?, _ k: Int) -> ListNode? {
        if head == nil {
            return nil
        }
        var numK = k
        // 往后数k个，若最后k>0，证明链表元素数量小于k
        var p1 = head
        while p1 != nil && numK > 0 {
            numK -= 1
            p1 = p1?.next
        }
        if numK > 0 {
            return nil
        }
        
        var p2 = head
        while p1 != nil {
            p1 = p1?.next
            p2 = p2?.next
        }
        return p2
    }
    // MARK: 链表中环的入口结点
    func entryNodeOfLoop(_ pHead: ListNode?) -> ListNode? {
        if pHead == nil || pHead?.next == nil {
            return nil
        }
        
        var slow = pHead, fast = pHead
        repeat {
            fast = fast?.next?.next
            slow = slow?.next
        } while !(slow === fast)
        
        fast = pHead
        while !(slow === fast) {
            slow = slow?.next
            fast = fast?.next
        }
        return slow
    }
    // MARK: 反转链表
    // 思想:  递归
    func reverseList(_ head: ListNode?) -> ListNode? {
        if head == nil || head?.next == nil {
            return head
        }
        let next = head?.next
        head?.next = nil
        let newHead = reverseList(next)
        next?.next = head
        return newHead
    }
    // 思想:  头插法
    func reverseList2(_ head: ListNode?) -> ListNode? {
        var nHead: ListNode? = nil
        var curNode = head
        while curNode != nil {
            let next = curNode?.next
            curNode?.next = nHead
            nHead = curNode
            
            curNode = next
        }
        return nHead
    }
    // MARK: 合并两个排序的链表
    // 思想:  双指针同时遍历两个链表，其中一个遍历完成时，直接挂载另一个即可
    func merge(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
        let nHead: ListNode? = ListNode(1)
        var cur = nHead
        var curList1Node = list1
        var curList2Node = list2
        while curList1Node != nil && curList2Node != nil {
            if curList1Node!.val <= curList2Node!.val {
                cur?.next = curList1Node
                curList1Node = curList1Node?.next
            }
            else {
                cur?.next = curList2Node
                curList2Node = curList2Node?.next
            }
            cur = cur?.next
        }
        if curList1Node != nil {
            cur?.next = curList1Node
        }
        
        if curList2Node != nil {
            cur?.next = curList2Node
        }
        return nHead?.next
    }
    
    // MARK: 树的子结构
    // 思想:  递归方法。单子是一个只有两个节点的2层树是否相等
    func hasSubtree(_ root1: TreeNode?, _ root2: TreeNode?) -> Bool {
        if root1 == nil || root2 == nil {
            return false
        }
        func isSubtreeWithRoot(_ root1: TreeNode?, _ root2: TreeNode?) -> Bool {
            if root2 == nil {
                return true
            }
            if root1 == nil {
                return false
            }
            
            if root1!.val != root2!.val {
                return false
            }
            return isSubtreeWithRoot(root1?.left, root2?.left) && isSubtreeWithRoot(root1?.right, root2?.right)
        }
        
        return isSubtreeWithRoot(root1, root2) || hasSubtree(root1?.left, root2) || hasSubtree(root1?.right, root2)
    }
    // MARK: 二叉树的镜像
    // 思想:  采用递归翻转二叉树。单子是一个二层数的翻转
    func mirror(_ root: TreeNode?) {
        if root == nil {
            return
        }
        // 反转
        func swap(_ root: TreeNode?) {
            let left = root?.left
            root?.left = root?.right
            root?.right = left
        }
        swap(root)
        mirror(root?.left)
        mirror(root?.right)
    }
    // MARK: 对称的二叉树
    func isSymmetrical(_ pRoot: TreeNode?) -> Bool {
        if pRoot == nil {
            return true
        }
        func isSymmetrical(_ t1: TreeNode?, _ t2: TreeNode?) -> Bool {
            if t1 == nil && t2 == nil {
                return true
            }
            if t1 == nil || t2 == nil {
                return false
            }
            
            if t1!.val != t2!.val {
                return false
            }
            
            return isSymmetrical(t1?.left, t2?.right) && isSymmetrical(t1?.right, t2?.left)
        }
        
        return isSymmetrical(pRoot?.left, pRoot?.right)
    }
    // MARK: 顺时针打印矩阵
    // 思想:  采用四个边界法，左右->上下->右左->下上 如此循环，期间修改边界
    func printMatrix(_ matrix: [[Int]]) -> [Int] {
        var ret = [Int]()
        if matrix.count == 0 || matrix[0].count == 0 {
            return ret
        }
        
        // 左边界， 右边界，上边界，下边界
        var left = 0, right = matrix[0].count - 1, up = 0, down = matrix.count - 1
        while true {
            // 最上面一行
            for col in left...right {
                ret.append(matrix[up][col])
            }
            // 向下逼近
            up += 1
            // 判断是否越界
            if up > down {
                break
            }
            // 最右边一行
            for row in up...down {
                ret.append(matrix[row][right])
            }
            // 向左逼近
            right -= 1
            // 判断是否越界
            if left > right {
                break
            }
            // 最下面一行
            //(left...right).reversed()
            for col in stride(from: right, through: left, by: -1) {
                ret.append(matrix[down][col])
            }
            // 向上逼近
            down -= 1
            // 判断是否越界
            if up > down {
                break
            }
            // 最左边一行
            // (up...down).reversed()
            for row in stride(from: down, through: up, by: -1) {
                ret.append(matrix[row][left])
            }
            // 向右逼近
            left += 1
            // 判断是否越界
            if left > right {
                break
            }
        }
        return ret
    }
    // MARK: 包含 min 函数的栈
    // 思想:  双栈，一个存正常数，一个存最小数
    private var dataStack = Stack<Int>()
    private var minStack = Stack<Int>()
    func minStackOperation() {
        func push(_ node: Int) {
            dataStack.push(node)
            
            if minStack.isEmpty {
                minStack.push(node)
            }
            else {
                let topValue: Int = minStack.top!
                minStack.push(topValue <= node ? topValue : node)
            }
        }
        
        func pop() -> Int? {
            let value = dataStack.pop()
            _ = minStack.pop()
            return value
        }
        
        func top() -> Int? {
            return dataStack.top
        }
        
        func min() -> Int? {
            return minStack.top
        }
    }
    
    // MARK: 栈的压入、弹出序列
    // 思想:  使用pushSequence模拟入栈，出栈时进行匹配popSequence，若最后都弹出来了，说明是它的弹出序列
    func isPopOrder(_ pushSequence: [Int], _ popSequence: [Int]) -> Bool {
        if pushSequence.count == 0 ||
            popSequence.count == 0 ||
            pushSequence.count != popSequence.count {
            return false
        }
        
        var stack = Stack<Int>()
        let n = pushSequence.count
        var popIndex = 0
        for pushIndex in 0..<n {
            stack.push(pushSequence[pushIndex])
            while popIndex < n && !stack.isEmpty && stack.top == popSequence[popIndex] {
                _ = stack.pop()
                popIndex += 1
            }
        }
        return stack.isEmpty
    }
    // MARK: 从上往下打印二叉树
    // 思想:  广度优先搜索算法。采用队列，每一层进队列，队列变为空时，第二层又进队列，如此循环往复。
    func printFromTopToBottom(_ root: TreeNode?) -> [Int] {
        var queue = Queue<TreeNode?>()
        var ret = [Int]()
        if root == nil {
            return ret
        }
        queue.enqueue(root)
        
        while !queue.isEmpty {
            var cnt = queue.count
            while cnt > 0 {
                cnt -= 1
                if let tNode = queue.dequeue(), tNode != nil {
                    ret.append(tNode!.val)
                    queue.enqueue(tNode!.left)
                    queue.enqueue(tNode!.left)
                }
            }
        }
        return ret
    }
    // MARK: 把二叉树打印成多行
    func printFromTopToBottomPerLine(_ root: TreeNode?) -> [[Int]] {
        var queue = Queue<TreeNode?>()
        var ret = [[Int]]()
        if root == nil {
            return ret
        }
        queue.enqueue(root)
        
        while !queue.isEmpty {
            var list = [Int]()
            var cnt = queue.count
            while cnt > 0 {
                cnt -= 1
                if let tNode = queue.dequeue(), tNode != nil {
                    list.append(tNode!.val)
                    queue.enqueue(tNode!.left)
                    queue.enqueue(tNode!.left)
                }
            }
            if list.count > 0 {
                ret.append(list)
            }
        }
        return ret
    }
    // MARK: 按之字形顺序打印二叉树
    func printFromTopToBottomZhi(_ root: TreeNode?) -> [[Int]] {
        var queue = Queue<TreeNode?>()
        var ret = [[Int]]()
        if root == nil {
            return ret
        }
        queue.enqueue(root)
        var reverse = false
        while !queue.isEmpty {
            var list = [Int]()
            var cnt = queue.count
            while cnt > 0 {
                cnt -= 1
                if let tNode = queue.dequeue(), tNode != nil {
                    list.append(tNode!.val)
                    queue.enqueue(tNode!.left)
                    queue.enqueue(tNode!.left)
                }
            }
            if reverse {
                // 翻转
                list.reverse()
            }
            
            reverse.toggle()
            if list.count > 0 {
                ret.append(list)
            }
        }
        return ret
    }
    // MARK: 二叉搜索树的后序遍历序列
    // 思想:  后序遍历序列中最后一个元素为根元素，左子树的左右元素比它小，右子树的左右元素比它大。利用这一规律进行递归操作
    func verifySquenceOfBST(_ sequence: [Int]) -> Bool {
        if sequence.count == 0 {
            return false
        }
        
        // 后序遍历数组中最后一个元素为根，其中左子树元素都小于根，右子树元素都大于根
        func verifySequence(_ first: Int,
                            _ last: Int) -> Bool {
            if last - first <= 1 {
                return true
            }
            let rootVal = sequence[last]
            var cutIndex = first
            // 获取该序列中左子树对应的index
            while cutIndex < last && sequence[cutIndex] <= rootVal {
                cutIndex += 1
            }
            
            for i in cutIndex..<last {
                if sequence[i] < rootVal {
                    return false
                }
            }
            
            return verifySequence(first,
                                  cutIndex - 1) &&
                verifySequence(cutIndex,
                               last - 1)
        }
        
        
        return verifySequence(0, sequence.count - 1)
    }
    
    // MARK: 二叉树中和为某一值的路径
    // 思想:  深度优先搜索算法
    func findPath(_ root: TreeNode?, _ target: Int) -> [[Int]] {
        var ret = [[Int]]()
        if root == nil {
            return ret
        }
        func backtracking(_ node: TreeNode?,
                          _ target1: Int,
                          _ path:inout [Int]) {
            if node == nil {
                return
            }
            let nodeValue = node!.val
            path.append(nodeValue)
            
            let tt = target1 - nodeValue
            if tt == 0 &&
                node?.left == nil
                && node?.right == nil {
                let p = path
                ret.append(p)
            }
            else {
                backtracking(node?.left,
                             tt,
                             &path)
                backtracking(node?.right,
                             tt,
                             &path)
            }
            path.removeLast()
        }
        
        var path = [Int]()
        backtracking(root,
                     target,
                     &path)
        return ret
    }
    
    // MARK:复杂链表的复制
    func cloneComplexList(_ pHead: RandomListNode?) -> RandomListNode? {
        if pHead == nil {
            return nil
        }
        
        // 插入新节点 在每个节点的后面插入复制的节点
        var cur = pHead
        while cur != nil {
            let clone = RandomListNode(cur!.label)
            clone.next = cur!.next
            cur!.next = clone
            cur = clone.next
        }
        // 建立 random 链接 对复制节点的 random 链接进行赋值
        cur = pHead
        while cur != nil {
            let clone = cur!.next
            if cur!.random != nil {
                clone?.random = cur!.random?.next
            }
            cur = clone?.next
        }
        // 拆分
        cur = pHead
        let pCloneHead = pHead?.next
        while cur?.next != nil {
            let next = cur?.next
            cur?.next = next?.next
            cur = next
        }
        return pCloneHead
    }
    
    // MARK: 二叉搜索树与双向链表
    // 思想:  中序遍历算法，重点在于处理节点的时候
    func convert(_ root: TreeNode?) -> TreeNode? {
        var cur: TreeNode? = nil
        var head: TreeNode? = nil
        func inOrder(_ node: TreeNode?) {
            if node == nil {
                return
            }
            // 处理左子树
            inOrder(node!.left)
            // 处理节点
            node!.left = cur
            if cur != nil {
                cur?.right = node
            }
            cur = node
            // 保证head只有一次赋值
            if head == nil {
                head = node
            }
            // 处理右子树
            inOrder(node?.right)
        }
        
        inOrder(root)
        return head
    }
    
    // MARK: 序列化二叉树
    // 思想:  前序遍历
    func serializeTree(_ root: TreeNode?) -> String {
        if root == nil {
            return "#"
        }
        // 空节点使用#，节点之间使用" "分割
        return "\(root!.val)" + " " + serializeTree(root!.left) + " " + serializeTree(root!.right)
    }
    func deserializeTree(fromstr str: String) -> TreeNode? {
        // 先重建根节点，如果是NULL节点，返回。如果是数字节点，递归重建左子树。之后，再重建右子树
        var start = -1
        var strArr:[Substring] = str.split(separator: " ")
        
        func deserialize(_ strArr:[Substring]) -> TreeNode? {
            start += 1
            if start < strArr.count && strArr[start] != "#" {
                let node = String(strArr[start])
                let val = Int(node) ?? 0
                let t = TreeNode(val)
                t.left = deserialize(strArr)
                t.right = deserialize(strArr)
                return t
            }
            return nil
        }
        
        return deserialize(strArr)
    }
    // MARK: 字符串的排列
    // 思想:  回溯法
    func permutation(_ str: String?) -> [String] {
        var ret = [String]()
        if str == nil {
            return ret
        }
        let chars = str!.sorted()
        var hasUsed = Array(repeating: false, count: chars.count)
        var s = ""
        
        func backtracking(_ chars: [Character]) {
            if s.count == chars.count {
                ret.append(s)
                return
            }
            for i in 0..<chars.count {
                if hasUsed[i] {
                    continue
                }
                
                if i != 0 && chars[i] == chars[i - 1] && !hasUsed[i - 1] {
                    /* 保证不重复 */
                    continue
                }
                
                hasUsed[i] = true
                s.append(chars[i])
                backtracking(chars)
                _ = s.removeLast()
                hasUsed[i] = false
            }
        }
        
        backtracking(chars)
        return ret
    }
    
    // MARK: 数组中出现次数超过一半的数字
    // 思想:  计数一个数最大的出现次数，相同加1不同减1，为0时就换数字
    func moreThanHalfNum_Solution(_ nums: [Int]) -> (Bool, Int) {
        let notFindNum = -1
        if nums.count == 0 {
            return (false, notFindNum)
        }
        // 用来记录出现次数最多的那个数
        var majority = nums[0]
        var cnt = 1
        for i in 1..<nums.count {
            cnt = nums[i] == majority ? cnt + 1 : cnt - 1
            if cnt == 0 {
                majority = nums[i]
                cnt = 1
            }
        }
        cnt = 0
        for i in 0..<nums.count {
            if nums[i] == majority {
                cnt += 1
            }
        }
        
        return cnt > nums.count / 2 ? (true, majority) : (false, notFindNum)
    }
    // MARK: 最小的 K 个数
    // 思想:  快速选择
    func getLeastNumbers_Solution(_ nums: [Int] , _ k: Int) -> (Bool, [Int]) {
        var ret = [Int]()
        if k > nums.count || k <= 0 {
            return (false, ret)
        }
        // 因为会进行排序，就用mNums接收
        var mNums = nums
        func partition(_ l: Int , _ h: Int ) -> Int {
            func swap(_ i: Int , _ j: Int) {
                (mNums[i],mNums[j]) = (mNums[j],mNums[i])
            }
            
            let p = mNums[l]     /* 切分元素 */
            var i = l, j = h + 1
            while true {
                while i != h {
                    i += 1
                    if mNums[i] >= p {
                        break
                    }
                }
                while j != l {
                    j -= 1
                    if mNums[j] <= p {
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
        
        findKthSmallest(k - 1)
        /* findKthSmallest 会改变数组，使得前 k 个数都是最小的 k 个数 */
        for i in 0..<k {
            ret.append(mNums[i])
        }
        return (true, ret)
    }
    // MARK: 获取数组的第K个最大的数
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        return nums.sorted()[nums.count-k]
    }
    
    // MARK: 数据流中的中位数
    // 思想:  采用堆排序
    // 原作者采用的java语言编写，因为swift没有PriorityQueue，所以暂时搁置
    
    // MARK: 字符流中第一个不重复的字符
    
    // MARK: 连续子数组的最大和
    // 思想:  和之前那个出现一半次数的是一个问题
    func findGreatestSumOfSubArray(_ nums: [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        var greatestSum = Int.min
        var sum = 0
        for i in 0..<nums.count {
            let val = nums[i]
            sum = sum <= 0 ? val : sum + val
            greatestSum = max(greatestSum, sum)
        }
        return greatestSum
    }
    
    // MARK: 从 1 到 n 整数中 1 出现的次数
    // 思想:
    func numberOf1Between1AndN_Solution(_ n: Int) -> Int {
        var cnt = 0
        var m = 1
        while m <= n {
            let divider = n / m, reminder = n % m
            cnt += (divider + 8) / 10 * m + (divider % 10 == 1 ? reminder + 1 : 0)
            m *= 10
        }
        return cnt
    }
    
    // MARK: 数字序列中的某一位数字
    // 思想:  循环处理1位数字，2位数字。。。最终把index转到第n位数字上。之后取到n位数字的起始数字，然后用index/n就相当于起始数字加几之后的数字，
    // 然后index%n 去取这个数字的第几位
    func getDigitAtIndex(_ index: Int) -> Int {
        if index < 0 {
            return -1
        }
        /**
         * place 位数的数字组成的字符串长度
         * 10, 90, 900, ...
         */
        func getAmountOfPlace(_ place: Int) -> Int {
            if place == 1 {
                return 10
            }
            
            return Int(powf(10, Float(place - 1)) * 9)
        }
        
        /**
         * place 位数的起始数字
         * 0, 10, 100, ...
         */
        func getBeginNumberOfPlace(_ place: Int) -> Int {
            if place == 1 {
                return 0
            }
            return Int(powf(10, Float(place - 1)))
        }
        
        /**
         * 在 place 位数组成的字符串中，第 index 个数
         */
        func getDigitAtIndex(_ index: Int, _ place: Int) -> Int {
            let beginNumber = getBeginNumberOfPlace(place)
            let shiftNumber = index / place
            let number = "\(beginNumber + shiftNumber)"
            let count = index % place
            let char = String(number[number.index(number.startIndex, offsetBy: count)])
            return Int(char)!
        }
        
        var place = 1 // 1 表示个位，2 表示 十位...
        var nIndex = index
        
        while (true) {
            let amount = getAmountOfPlace(place)
            let totalAmount = amount * place
            if nIndex < totalAmount {
                return getDigitAtIndex(nIndex, place)
            }
            nIndex -= totalAmount
            place += 1
        }
    }
    
    // MARK: 把数组排成最小的数
    // 思想:  可以看成是一个排序问题，在比较两个字符串 S1 和 S2 的大小时，应该比较的是 S1+S2 和 S2+S1 的大小
    // 如果 S1+S2 < S2+S1，那么应该把 S1 排在前面，否则应该把 S2 排在前面
    func printMinNumber(_ numbers: [Int]) -> String {
        if numbers.count == 0 {
            return ""
        }
        
        let n = numbers.count
        var nums = Array<String>.init(repeating: "", count: n)
        for i in 0..<n {
            nums[i] = "\(numbers[i])"
        }
        nums.sort { (s1, s2) -> Bool in
            (s1 + s2) < (s2 + s1)
        }
        
        return nums.joined()
    }
    
    // MARK: 把数字翻译成字符串
    // 思想:  动态规划算法，说实在的动态规划我感觉我理解不太了，这是纯翻译的大神代码。以后有机会还得多研读
    func numDecodings(_ s: String) -> Int {
        if s.count == 0 {
            return 0
        }
        if s.first! == "0" {
            return 0
        }
        
        var pre = 1, curr = 1 //dp[-1] = dp[0] = 1
        for i in 1..<s.count {
            let tmp = curr
            let iStr = s[s.index(s.startIndex, offsetBy: i)]
            let i_1Str = s[s.index(s.startIndex, offsetBy: i - 1)]
            if iStr == "0" {
                if i_1Str == "1" || i_1Str == "2" {
                    curr = pre
                }
                else {
                    return 0
                }
            }
            else if i_1Str == "1" || (i_1Str == "2" && iStr >= "1" && iStr <= "6") {
                curr = curr + pre
            }
            pre = tmp
        }
        return curr
    }
    // MARK: 礼物的最大价值
    // 思想:  动态规划算法，说实在的动态规划我感觉我理解不太了，这是纯翻译的大神代码。以后有机会还得多研读
    // 经过验证，大神这个方法貌似不对
    //    func getMost(_ values: [[Int]]) -> Int {
    //        if values.count == 0 || values[0].count == 0 {
    //            return 0
    //        }
    //        let n = values[0].count
    //        var dp = Array<Int>(repeating: 0, count: n)
    //        for i in 0..<values.count {
    //            let rowValue = values[i]
    //            dp[0] += rowValue[0]
    //            for j in 1..<n {
    //                dp[j] = max(dp[j], dp[j - 1] + rowValue[j])
    //            }
    //            print(dp)
    //        }
    //        return dp[n - 1]
    //    }
    // 这是leetcoder上棒棒的解法
    func getMost(_ grid: [[Int]]) -> Int {
        var mGrid = grid
        let row = mGrid.count, col = mGrid[0].count
        for i in 1..<row {
            mGrid[i][0] += mGrid[i - 1][0]
        }
        for i in 1..<col {
            mGrid[0][i] = mGrid[0][i - 1]
        }
        for i in 1..<row {
            for j in 1..<col {
                mGrid[i][j] += max(mGrid[i - 1][j], mGrid[i][j - 1])
            }
        }
        return mGrid[row - 1][col - 1]
    }
    
    
    // MARK: 最长不含重复字符的子字符串长度
    // 因为swift中处理字符串比较麻烦，我们可以演变为一个整数数组中，最长的不包含相同数字的最长子数组长度
    func longestSubStringWithoutDuplication(_ nums: [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        var valueIndexDict = Dictionary<Int, Int>.init(minimumCapacity: nums.count)
        var res = 0
        var start = 0
        for i in 0..<nums.count {
            let value = nums[i]
            if let idx = valueIndexDict[value] {
                start = max(i, idx + 1)
            }
            valueIndexDict[value] = i
            res = max(res, i - start + 1)
        }
        
        return res
    }
    // MARK: 按从小到大的顺序的第 N 个丑数
    func getUglyNumber_Solution(_ n: Int) -> Int {
        if n <= 6 {
            return n
        }
        
        var i2 = 0, i3 = 0, i5 = 0
        var dp = Array<Int>(repeating: 0, count: n)
        dp[0] = 1
        for i in 1..<n {
            let next2 = dp[i2] * 2, next3 = dp[i3] * 3, next5 = dp[i5] * 5
            dp[i] = min(next2, next3, next5)
            
            if dp[i] == next2 {
                i2 += 1
            }
            if dp[i] == next3 {
                i3 += 1
            }
            if dp[i] == next5 {
                i5 += 1
            }
        }
        print(dp)
        return dp[n - 1]
    }
    // MARK: 第一个只出现一次的字符位置
    func firstAppearingOnce(in nums: [Int]) -> (Bool, Int) {
        if nums.count == 0 {
            return (false, 0)
        }
        // 保存对应数字出现的次数
        var numCountMap = [Int:Int]()
        var onceNums = Set<Int>()
        for i in 0..<nums.count {
            let value = nums[i]
            if let count = numCountMap[value] {
                numCountMap[value] = count + 1
            }
            else {
                numCountMap[value] = 1
            }
            
            if numCountMap[value] == 1 {
                if !onceNums.contains(value) {
                    onceNums.insert(value)
                }
            }
            else {
                if onceNums.contains(value) {
                    onceNums.remove(value)
                }
            }
        }
        
        for i in 0..<nums.count {
            let value = nums[i]
            if onceNums.contains(value) {
                return (true, value)
            }
        }
        
        return (false, 0)
    }
    // MARK:  数组中的逆序对
    // 思想:  归并排序过程中统计次数
    func inversePairs(_ nums: [Int]) -> Int {
        var tmp = Array<Int>(repeating: 0, count: nums.count)
        var mNums = nums
        var cnt = 0
        
        func merge(_ l: Int,
                   _ m: Int,
                   _ h: Int) {
            var i = l, j = m + 1, k = l
            while i <= m || j <= h {
                if i > m {
                    tmp[k] = mNums[j]
                    j += 1
                }
                else if j > h {
                    tmp[k] = mNums[i]
                    i += 1
                }
                else if mNums[i] <= mNums[j] {
                    tmp[k] = mNums[i]
                    i += 1
                }
                else {
                    tmp[k] = mNums[j]
                    j += 1
                    cnt += m - i + 1  // nums[i] > nums[j]，说明 nums[i...mid] 都大于 nums[j]
                }
                k += 1
            }
            for k in l...h {
                mNums[k] = tmp[k]
            }
        }
        
        func mergeSort(_ l: Int,
                       _ h: Int) {
            if h - l < 1 {
                return
            }
            let m = l + (h - l) / 2
            mergeSort(l, m)
            mergeSort(m + 1, h)
            merge(l, m, h)
        }
        
        mergeSort(0,
                  nums.count - 1)
        return (cnt % 1000000007)
    }
    
    // MARK:  两个链表的第一个公共结点
    // 思想：  使用两个指针分别跑两个链表，跑完一个之后切过去跑另一个，这样他们就会在交点相遇a + c + b = b + c + a
    func findFirstCommonNode(_ pHead1: ListNode?, _ pHead2: ListNode?) -> ListNode? {
        var l1 = pHead1, l2 = pHead2
        while !(l1 === l2) {
            l1 = (l1 == nil) ? pHead2 : l1?.next
            l2 = (l2 == nil) ? pHead1 : l2?.next
        }
        return l1
    }
    // MARK:  数字在排序数组中出现的次数
    // 思想：  使用二分查找，查找到它出现的第一个位置和最后一个位置
    func getNumberOfK(_ nums: [Int], _ k: Int) -> Int {
        func binarySearch(_ k: Int) -> Int {
            var l = 0, h = nums.count
            while l < h {
                let m = l + (h - l) / 2
                if nums[m] >= k {
                    h = m
                }
                else {
                    l = m + 1
                }
            }
            return l
        }
        
        let first = binarySearch(k)
        let last = binarySearch(k + 1)
        return (first == nums.count || nums[first] != k) ? 0 : last - first
    }
    // MARK:  二叉查找树的第 K 个结点
    // 思想：  利用二叉查找树中序遍历有序的特点
    func kthNode(_ pRoot: TreeNode? , _ k: Int) -> TreeNode? {
        var ret: TreeNode?
        var cnt = 0
        
        func inOrder(_ root: TreeNode?, _ k: Int) {
            if root == nil || cnt >= k {
                return
            }
            inOrder(root?.left, k)
            cnt += 1
            if cnt == k {
                ret = root
            }
            inOrder(root?.right, k)
        }
        inOrder(pRoot, k)
        return ret
    }
    // MARK:  二叉树的深度
    // 思想：  最长的路径
    func treeDepth(_ root: TreeNode?) -> Int {
        return root == nil ? 0 : 1 + max(treeDepth(root?.left), treeDepth(root?.right))
    }
    // MARK:  输入一棵二叉树，判断该二叉树是否是平衡二叉树
    // 思想：  平衡二叉树左右子树高度差不超过 1
    func issBalanced_Solution(_ root: TreeNode?) -> Bool {
        var isBalanced = true
        @discardableResult
        func height(_ root: TreeNode?) -> Int {
            if root == nil || !isBalanced {
                return 0
            }
            let left = height(root?.left)
            let right = height(root?.right)
            if abs(left - right) > 1 {
                isBalanced = false
            }
            return 1 + max(left, right)
        }
        
        height(root)
        return isBalanced
    }
    
    // MARK:  数组中只出现一次的数字
    // 思想：
    func findNumsAppearOnce(_ nums: [Int]) -> (Int, Int) {
        var bitmask = 0
        for i in 0..<nums.count {
            bitmask ^= nums[i]
        }
        let diff = bitmask & (-bitmask)
        var x = 0
        for i in 0..<nums.count {
            if nums[i] & diff != 0 {
                x ^= nums[i]
            }
        }
        return (x, bitmask^x)
    }
    
    // MARK:  和为 S 的两个数字
    // 思想：
    func findNumbersWithSum(_ array: [Int], _ sum: Int) -> (Int, Int) {
        var minMut:(i: Int,j: Int,ij: Int)?
        var i = 0, j = array.count - 1
        while i < j {
            let cur = array[i] + array[j]
            if cur == sum {
                let value = i + j
                
                if minMut != nil {
                    if minMut!.ij > value {
                        minMut = (i, j ,value)
                    }
                }
                else {
                    minMut = (i, j ,value)
                }
            }
            else if cur < sum {
                i += 1
            }
            else {
                j -= 1
            }
        }
        return minMut == nil ? (0, 0) : (minMut!.i, minMut!.j)
    }
    
    // MARK: 输出所有和为S的连续正数序列。序列内按照从小至大的顺序，序列间按照开始数字从小到大的顺序
    // 思想： 双指针分别指向连续序列的开头和结尾
    func findContinuousSequence(_ target: UInt) -> [[UInt]] {
        var ret = [[UInt]]()
        var start: UInt = 1, end: UInt = 2
        var curSum = start + end
        while end < target {
            if curSum > target {
                curSum -= start
                start += 1
            }
            else if curSum < target {
                end += 1
                curSum += end
            }
            else {
                var list = [UInt]()
                for i in start...end {
                    list.append(i)
                }
                ret.append(list)
                
                curSum -= start
                start += 1
                end += 1
                curSum += end
            }
        }
        return ret
    }
    // MARK: 翻转单词顺序列
    func reverseSentence(_ str: String) -> String {
        var chars = [Character]()
        for c in str {
            chars.append(c)
        }
        
        func reverse(_ i: Int, _ j: Int) {
            var mulI = i, mulJ = j
            while mulI < mulJ {
                (chars[mulI], chars[mulJ]) = (chars[mulJ], chars[mulI])
                mulI += 1
                mulI -= 1
            }
        }
        
        let n = chars.count
        var i = 0, j = 0
        while j <= n {
            if j == n || chars[j] == " " {
                reverse(i, j - 1)
                i = j + 1
            }
            j += 1
        }
        reverse(0, n - 1)
        return String(chars)
    }
    
    // MARK: 左旋转字符串
    func leftRotateString(_ str: String, _ n: Int) -> String {
        if n < 0 || n >= str.count {
            return str
        }
        
        var chars = [Character]()
        for c in str {
            chars.append(c)
        }
        
        func reverse(_ i: Int, _ j: Int) {
            var mulI = i, mulJ = j
            while mulI < mulJ {
                (chars[mulI], chars[mulJ]) = (chars[mulJ], chars[mulI])
                mulI += 1
                mulI -= 1
            }
        }
        
        let n = chars.count
        var i = 0, j = 0
        while j <= n {
            if j == n || chars[j] == " " {
                reverse(i, j - 1)
                i = j + 1
            }
            j += 1
        }
        
        reverse(0, n - 1)
        reverse(n, chars.count - 1)
        reverse(0, chars.count - 1)
        return String(chars)
    }
    
    // MARK: 滑动窗口的最大值
    func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
        let len = nums.count
        if len == 0 {
            return []
        }
        if k < 1 || k > len {
            return []
        }
        //定义结果数组
        let compareCount = len - k + 1
        var res = Array<Int>(repeating: 0, count: compareCount)
        //maxInd记录每次最大值的下标，max记录最大值
        var maxInd = -1, max = Int.min
        for i in 0..<compareCount {
            //判断最大值下标是否在滑动窗口的范围内
            if maxInd >= i && maxInd < i + k {
                //存在就只需要比较最后面的值是否大于上一个窗口最大值
                if nums[i + k - 1] > max {
                    max = nums[i + k - 1]
                    //更新最大值下标
                    maxInd = i + k - 1
                }
            }
                //如果不在就重新寻找当前窗口最大值
            else {
                max = nums[i]
                for j in i..<(i+k) {
                    if max < nums[j] {
                        max = nums[j]
                        maxInd = j
                    }
                }
            }
            res[i] = max
        }
        return res
    }
    
    // MARK: n 个骰子的点数
    // 思想： 其实这里没有看懂，只是照搬过来了
    func dicesSum(_ n: Int) -> [[Int:Double]] {
        let face = 6
        let pointNum = face * n
        var dp = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: pointNum + 1), count: n + 1)
        for i in 1...face {
            dp[1][i] = 1
        }
        for i in 2...n {
            for j in i...pointNum { ///* 使用 i 个骰子最小点数为 i */
                for k in 1...min(face, j) {
                    dp[i][j] += dp[i-1][j-k]
                }
            }
        }
        
        let totalNum = Double(powf(6, Float(n)))
        var ret = [[Int:Double]]()
        for i in n...pointNum {
            ret.append([i:Double(dp[n][i])/totalNum])
        }
        return ret
    }
    
    func dicesSum2(_ n: Int) -> [[Int:Double]] {
        let face = 6
        let pointNum = face * n
        var dp = Array<[Int]>(repeating: Array<Int>(repeating: 0, count: pointNum + 1), count: n + 1)
        for i in 1...face {
            dp[1][i] = 1
        }
        
        var flag = 1                                     /* 旋转标记 */
        for i in 2...n {
            for j in 0...pointNum {
                dp[flag][j] = 0
            }
            for j in i...pointNum {
                for k in 1...(min(j, face)) {
                    dp[flag][j] += dp[1 - flag][j - k]
                }
            }
            
            flag = 1 - flag
        }
        let totalNum = Double(powf(6, Float(n)))
        var ret = [[Int:Double]]()
        for i in n...pointNum {
            ret.append([i:Double(dp[1-flag][i])/totalNum])
        }
        return ret
    }
    // MARK: 扑克牌顺子
    func isContinuous(_ nums: [Int]) -> Bool {
        if nums.count < 5 {
            return false
        }
        let sortedNums = nums.sorted()
        // 统计癞子数量
        var cnt = 0
        for i in 0..<4 {
            if sortedNums[i] == 0 {
                cnt += 1
                continue
            }
            if sortedNums[i + 1] == sortedNums[i] {
                return false
            }
            cnt -= sortedNums[i + 1] - sortedNums[i] - 1
        }
        return cnt >= 0
    }
    
    // MARK: 圆圈中最后剩下的数
    // 思想:  约瑟夫环问题
    func lastRemaining(_ n: Int, _ m: Int) -> Int {
        if n < 1 || m < 1 {
            return -1
        }
        if n == 1 {
            return 0
        }
        return (lastRemaining(n-1, m) + m) % n
    }
    
    func lastRemaining2(_ n: Int, _ m: Int) -> Int {
        var last = 0   //存活的最后一个人的位置
        for i in 2...n {
            last = (last + m) % i
        }
        return last
    }
    
    // MARK: 股票的最大利润
    func maxProfit(_ prices: [Int]) -> Int {
        if prices.count == 0 {
            return 0
        }
        var soFarMin = prices[0]
        var maxProfit = 0
        for i in 1..<prices.count {
            // 至今为止最小的波谷
            soFarMin = min(soFarMin, prices[i])
            // 至今为止最大的波峰
            maxProfit = max(maxProfit, prices[i] - soFarMin)
        }
        return maxProfit
    }
    
    // MARK: 求 1+2+3+...+n
    // 麻烦 swift中必须得是强制的类型转换，没有隐式转换
    func sum_Solution(_ n: Int) -> Int {
        var sum = n
        let val = n > 0 ? sum_Solution(n - 1) : 0
        sum += val
        return sum
    }
    
    // MARK: 不用加减乘除做加法
    func add(_ a: Int, _ b: Int) -> Int {
        return b == 0 ? a : add(a ^ b, (a & b) << 1)
    }
    
    // MARK: 构建乘积数组
    func multiply(_ a: [Int]) -> [Int] {
        let n = a.count
        var b = Array<Int>(repeating: 0, count: n)
        
        var left = 1 // b[i] = a[i]左侧乘积  * a[i]右侧乘积
        // a[i]左侧乘积
        for i in 0..<n {
            b[i] = left
            left *= a[i]
        }
        
        var right = 1
        //a[i]右侧乘积
        for i in stride(from: n - 1, through: 0, by: -1) {
            b[i] *= right
            right *= a[i]
        }
        return b
    }
    
    // MARK: 把字符串转换成整数
    func strToInt(_ str: String) -> Int {
        if str.count == 0 {
            return 0
        }
        var chars = [Character]()
        for c in str {
            chars.append(c)
        }
        
        let isNegative = chars[0] == "-"
        var ret = 0
        for i in 0..<chars.count {
            let c = chars[i]
            
            if i == 0 && (c == "+" || c == "+") {  /* 符号判定 */
                continue
            }
            if c < "0" || c > "9" {                /* 非法输入 */
                return 0
            }
            ret = ret * 10 + Int(c.asciiValue!)
        }
        return isNegative ? -ret : ret
    }
    // MARK: 树中两个节点的最低公共祖先
    // 1. 二叉查找树
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        if root == nil {
            return root
        }
        
        if root!.val > p!.val && root!.val > q!.val {
            return lowestCommonAncestor(root!.left, p, q)
        }
        else if root!.val < p!.val && root!.val < q!.val {
            return lowestCommonAncestor(root!.right, p, q)
        }
        return root
    }
    // 2. 普通二叉树
    func lowestCommonAncestor2(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        if root == nil || root === p || root === q {
            return root
        }
        let left = lowestCommonAncestor2(root!.left, p, q)
        let right = lowestCommonAncestor2(root!.right, p, q)
        return left == nil ? right : right == nil ? left : root
    }
    
    // MARK: 获取一个整数的二进制周期
    func getBinaryPeriodForInt(_ n: Int) -> Int {
        var nn = n
        var d = [Int]()
        var l = 0, res = -1
        while l > 0 {
            d[l] = nn % 2
            nn /= 2
            l += 1
        }
        for p in 1..<l {
            if p < l / 2 {
                var ok = true
                for i in 0..<l-p {
                    if d[i] != d[i+p] {
                        ok = false
                        break
                    }
                }
                if ok {
                    res = p
                }
            }
        }
        return res
    }
    
    // MARK: 判断一个数组中是否有两个数的和为target，如果存在返回他们的下标
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var valueIndexMap = [Int:Int]()
        for i in 0..<nums.count {
            let valueAtI = nums[i]
            let complete = target - valueAtI
            if valueIndexMap.keys.contains(complete) {
                return [valueIndexMap[complete]!, i]
            }
            valueIndexMap[valueAtI] = i
        }
        return [0, 0]
    }
    
    // MARK: 合并两棵树
    func mergeTrees(_ t1: TreeNode?, _ t2: TreeNode?) -> TreeNode? {
        if t1 != nil && t2 != nil {
            t1?.left = mergeTrees(t1?.left, t2?.left)
            t2?.right = mergeTrees(t1?.right, t2?.right)
            t1?.val += t2?.val ?? 0
            return t1
        }
        return t1 != nil ? t1 : t2
    }
    
    // MARK: 翻转一个字符串中的单词
    func reverse(_ str: String) {
        // 将整句分割整二维数组，内层的每个数组代表一个单词
        var words = [[Character]]()
        // 构建出来的单词
        var tmpWord = [Character]()
        for c in str {
            if c != " " {
                tmpWord.append(c)
            }
            else {
                if tmpWord.count > 0 {
                    words.append(tmpWord)
                    tmpWord = [Character]()
                }
            }
        }
        if tmpWord.count > 0 {
            words.append(tmpWord)
        }
        
        var i = 0, j = words.count - 1
        while i < j {
            (words[i], words[j]) = (words[j], words[i])
            i += 1
            j -= 1
        }
        
        var str = ""
        for i in 0..<words.count {
            let word = words[i]
            for j in 0..<word.count {
                str.append(word[j])
            }
        }
        print(str)
    }
}

