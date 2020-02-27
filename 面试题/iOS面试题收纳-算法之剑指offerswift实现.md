```swift
//
//  algorithm.swift
//  MyLib_Example
//
//  Created by apple on 2020/2/20.
//  Copyright © 2020 zhoukang. All rights reserved.
//

import Foundation
// 树节点
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public var parent: TreeNode?
    public init(_ val: Int) {
        self.val = val
        left = nil
        right = nil
        parent = nil
    }
}
// 链表节点
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        next = nil
    }
}
// 复杂链表
public class RandomListNode {
    public var label: Int
    public var next:RandomListNode?
    public var random:RandomListNode?
    public init(_ val: Int) {
        label = val
    }
}

// 栈结构  https://github.com/raywenderlich/swift-algorithm-club/blob/master/Stack/Stack.swift
public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
}
// 队列结构
public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard let element = array[guarded: head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}

@objc
class AlgorithmSolutions : NSObject {
    
    @objc public func testAlgorithm() {
        let tupa = [
            [1,   4,  7, 11, 15],
            [2,   5,  8, 12, 19],
            [3,   6,  9, 16, 22],
            [10, 13, 14, 17, 24],
            [18, 21, 23, 26, 30]
        ]
        print(printMatrix(tupa))
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
    // 思想: 将每个数字放到它对应的位置上，比如nums[i] 放到 i的位置上，如果有两个放到了一个地方，就可以校验出来
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
    // 思想: 找规律，从左下角或右上角入手
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
    // 思想: 给str扩容，之后双指针分别从最后往前移动。这样可以防止插入%02造成的内存移动操作
    // 当然这里我们没有写，因为swift中字符串使用的是String.Index，操作比较繁琐。也可以写，只是嫌麻烦
    func replaceSpace(_ str:inout String) -> String {
        return str.replacingOccurrences(of: " ", with: "%02")
    }
    // MARK: 从尾到头打印链表
    // 思想: 递归法
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
    // 思想: 从前序遍历中取出对应子树的根节点，然后找到中序遍历中它的index，分割中序遍历，它之前的是左子树，之后的是右子树。循环往复
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        // 缓存中序遍历数组的value和index对应的map
        var inorderValueIndexMap = [Int:Int]()
        func reBuildTree(_ preorder:[Int],
                         _ preL:Int,
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
            root.left = reBuildTree(preorder,
                                    preL + 1,
                                    preL + leftTreeSize,
                                    inorder)
            root.right = reBuildTree(preorder,
                                     preL + leftTreeSize + 1,
                                     preR,
                                     inorder + leftTreeSize + 1)
            return root
        }
        
        // 缓存中序遍历数组的value和index
        for i in 0..<inorder.count {
            inorderValueIndexMap[inorder[i]] = i
        }
        return reBuildTree(preorder,
                           0,
                           preorder.count-1,
                           0)
    }
    // MARK: 二叉树的下一个结点
    // 思想: 中序遍历下。一个节点的右子树不为空时，它的下一个节点为右子树的最左子节点；右子树为空的情况下，它的下一个节点是父节点的左子节点为它自身的节点
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
    // 思想: 一个用于进栈，进栈时被反转，出栈时进入另一个栈，这个栈再出栈。此时反转了两次之后实现了FIFO
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
    // 思想: 当前数为它之前两个数的和
    var fibs = [0,1]
    func fibonacci(at n:Int) -> Int {
        if n <= fibs.count {
            return fibs[n]
        }
        // 进行扩容
        if n > fibs.count {
            fibs += Array(repeating: 0, count: n - fibs.count)
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
    // 思想: 和斐波那契数列一样，只是起始值不同
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
    // 思想: 使用二分法找到非递增的那个子数组，那个子数组也可以简单的看做一个小的旋转数组
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
    // 思想: 构造一个矩阵后，把矩阵所有的位置先标记为未走过。然后从起点开始，按照定义的方向往各个地方行走，如果后包含了我们定义的路径就返回
    private static let nextDirection = [(0, -1), (0, 1), (-1, 0), (1, 0)]
    func hasPath(_ array:[Character],
                 rows: Int,
                 cols: Int,
                 str: [Character]) -> Bool {
        if rows == 0 || cols == 0 {
            return false
        }
        
        var marked = [[Bool]]()
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
            for n in AlgorithmSolutions.nextDirection  {
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
    // 思想: 和上面的思想一样，只是内部路径不可走的判断条件不一样
    func movingCount(_ threshold: Int, _ rows: Int, _ cols: Int) -> Int {
        var cnt = 0
        
        var marked = [[Bool]]()
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
            for n in AlgorithmSolutions.nextDirection  {
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
    // 动态规划
    func integerBreak(_ n: Int) -> Int {
        var dp = Array(repeating: 0, count: n + 1)
        dp[1] = 1
        for i in 2...n {
            for j in 1..<i {
                dp[i] = max(dp[i], max(j * (i - j),dp[j] * (i - j)))
            }
        }
        return dp[n]
    }
    
    // MARK: 二进制中 1 的个数
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
    // 思想: 通过定义一个数组，递归操作它对应的位数（个位，十位，百位，千位等）
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
    // 思想: 若这个节点有后序节点，就伪装成它的下一个节点，并把它下一个节点删除；若它是最后的节点，就需要遍历链表，找到它的上一个节点，然后把它删除
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
    // 思想: 先算出有多少奇数，然后顺序遍历，按照奇偶的index存储另一个数组中
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
    // 思想: 若相邻两个数，一个是奇数，一个是偶数，就把偶数往后冒泡
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
    // 思想: 使用两个指针，一个从第K个位置，一个从头，当第K个位置的指针到到链表末尾时，第二个指针到达倒数第k个位置
    func FindKthToTail(_ head: ListNode?, _ k: Int) -> ListNode? {
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
    // 思想: 双指针同时遍历两个链表，其中一个遍历完成时，直接挂载另一个即可
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
    // 思想: 递归方法。单子是一个只有两个节点的2层树是否相等
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
    // 思想: 采用递归翻转二叉树。单子是一个二层数的翻转
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
    // 思想: 采用四个边界法，左右->上下->右左->下上 如此循环，期间修改边界
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
    // MARK:包含 min 函数的栈
    // 思想: 双栈，一个存正常数，一个村最小数。
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
    
    // MARK:栈的压入、弹出序列
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
    // MARK:从上往下打印二叉树
    // 思想: 广度优先搜索算法。采用队列，每一层进队列，队列变为空时，第二层又进队列，如此循环往复。
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
    // MARK:把二叉树打印成多行
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
    // MARK:按之字形顺序打印二叉树
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
    // MARK:二叉搜索树的后序遍历序列
    // 思想: 后序遍历序列中最后一个元素为根元素，左子树的左右元素比它小，右子树的左右元素比它大。利用这一规律进行递归操作
    func verifySquenceOfBST(_ sequence: [Int]) -> Bool {
        if sequence.count == 0 {
            return false
        }
        
        // 后序遍历数组中最后一个元素为根，其中左子树元素都小于根，右子树元素都大于根
        func verify(_ sequence: [Int], _ first: Int, _ last: Int) -> Bool {
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
                
            return verify(sequence,
                          first,
                          cutIndex - 1) &&
                verify(sequence,
                       cutIndex,
                       last - 1)
        }

        
        return verify(sequence, 0, sequence.count - 1)
    }

    // MARK:二叉树中和为某一值的路径
    // 思想: 深度优先搜索算法
    func findPath(_ root: TreeNode?, _ target: Int) -> [[Int]] {
        var ret = [[Int]]()
        if root == nil {
            return ret
        }
        func backtracking(_ node: TreeNode?,
                          _ target: Int,
                          _ path:inout [Int]) {
            if node == nil {
                return
            }
            let nodeValue = node!.val
            path.append(nodeValue)
            
            let tt = target - nodeValue
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
        backtracking(root, target, &path)
        return ret
    }

    // MARK:复杂链表的复制
    func cloneComplexList(_ pHead: RandomListNode?) -> RandomListNode? {
        if pHead == nil {
            return nil
        }
        
        // 插入新节点
        var cur = pHead
        while cur != nil {
            let clone = RandomListNode(cur!.label)
            clone.next = cur!.next
            cur!.next = clone
            cur = clone.next
        }
        // 建立 random 链接
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
        return pCloneHead;
    }

    
    
    
    
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
    
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var valueIndexMap = [Int:Int]()
        for i in 0..<nums.count {
            let valueAtI = nums[i]
            let complete = target - valueAtI
            if valueIndexMap.keys.contains(complete) {
                return [(valueIndexMap[complete] ?? 0),i]
            }
            valueIndexMap[valueAtI] = i
            print(valueIndexMap)
        }
        
        return [0, 0]
    }
    
    
    func mergeTrees(_ t1: TreeNode?, _ t2: TreeNode?) -> TreeNode? {
        if t1 != nil && t2 != nil {
            t1?.left = mergeTrees(t1?.left, t2?.left)
            t2?.right = mergeTrees(t1?.right, t2?.right)
            t1?.val += t2?.val ?? 0
            return t1
        }
        return t1 != nil ? t1 : t2
    }
    
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        return nums.sorted()[nums.count-k]
    }
  
}

```

