//
//  DefStructures.swift
//  StudyExercise
//
//  Created by apple on 2020/3/16.
//  Copyright © 2020 unravel. All rights reserved.
//

import Foundation
// MARK: 定义：树节点
public class TreeNode {
    public var val: Int
    public var parent: TreeNode?
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int = 0,
                _ left: TreeNode? = nil,
                _ right: TreeNode? = nil,
                _ parent: TreeNode? = nil) {
        self.val = val
        self.left = left
        self.right = right
        self.parent = parent
    }
}

// MARK: 定义：链表节点
public class ListNode: Hashable {
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(val)
    }
    
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int = 0, _ next: ListNode? = nil) {
        self.val = val
        self.next = next
    }
}
// MARK: 定义：复杂链表
public class RandomListNode: Hashable {
    public static func == (lhs: RandomListNode, rhs: RandomListNode) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(label ^ label)
        if next != nil {
            hasher.combine(next!.label)
        }
        if random != nil {
            hasher.combine(random!.label)
        }
    }
    public var label: Int
    public var next:RandomListNode?
    public var random:RandomListNode?
    public init(_ val: Int) {
        label = val
    }
}

// MARK: 定义：栈结构
// https://github.com/raywenderlich/swift-algorithm-club/blob/master/Stack/Stack.swift
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
    
    @discardableResult
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
    
    public var toArray: [T] {
        return array
    }
}
// MARK: 定义：队列结构
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
        }
        else {
            return array[head]
        }
    }
}
// MARK: 双端队列
public struct Deque<T> {
    // 内部私有容器
    private var array = [T]()
    // 数量
    public var count: Int {
        return array.count
    }
    // 判空
    public var isEmpty: Bool {
        return array.isEmpty
    }
    // 前进队列
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    // 后进队列
    public mutating func enqueueFront(_ element: T) {
        array.insert(element, at: 0)
    }
    // 前出队列
    public mutating func dequeue() -> T? {
        if isEmpty {
            return nil
        }
        return array.removeFirst()
    }
    // 后出队列
    public mutating func dequeueBack() -> T? {
        if isEmpty {
            return nil
        }
        return array.removeLast()
    }
    // 前看
    public var peekFront: T? {
        return array.first
    }
    // 后看
    public var peekBack: T? {
        return array.last
    }
}

// MARK: 扩展Array的下标操作
extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}

//Mark:最大优先队列
class PriorityQueue {
    //用于存储优先队列数据
    var array:[Int]
    //优先队列数据大小
    var size:Int
    
    //初始化优先队列
    init() {
        //数组初始长度32
        self.array = [Int](repeating: 0, count: 32)
        //队列初始大小为0
        self.size = 0
    }
    
    //MARK:队列扩容为原来的2倍
    func resize() {
        self.array += self.array
    }
    
    //Mark:入队
    func  enQueue(_ key:Int) {
        //队列长度超出范围，扩容
        if size >= array.count {
            resize()
        }
        array[size] = key;
        size += 1
        //上浮
        upAdjust()
    }
    
    //Mark:出队
    func deQueue() -> Int {
        //获取堆顶元素
        let head:Int = array[0]
        size -= 1
        //最后一个元素移动到堆顶
        array[0] = array[size]
        downAdjust()
        return head
    }
    
    //Mark:上浮操作
    func upAdjust() {
        var childIndex:Int = size - 1
        var parentIndex:Int = (childIndex - 1)/2
        // temp保存插入的叶子节点值，用于最后的赋值
        let temp:Int = array[childIndex]
        while(childIndex > 0 && temp > array[parentIndex])
        {
            //无需真正交换，单向赋值即可
            array[childIndex] = array[parentIndex]
            childIndex = parentIndex
            parentIndex = parentIndex / 2
        }
        array[childIndex] = temp
    }
    
    //Mark:下沉操作
    func downAdjust() {
        // temp保存父节点值，用于最后的赋值
        var parentIndex:Int = 0
        let temp:Int = array[parentIndex]
        var childIndex:Int = 1
        while (childIndex < size)
        {
            // 如果有右孩子，且右孩子大于左孩子的值，则定位到右孩子
            if childIndex + 1 < size && array[childIndex + 1] > array[childIndex]
            {
                childIndex += 1
            }
            // 如果父节点大于任何一个孩子的值，直接跳出
            if temp >= array[childIndex] {break}
            //无需真正交换，单向赋值即可
            array[parentIndex] = array[childIndex]
            parentIndex = childIndex
            childIndex = 2 * childIndex + 1
        }
        array[parentIndex] = temp
    }
}
