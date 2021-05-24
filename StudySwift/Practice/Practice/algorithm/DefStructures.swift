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
// MARK: 定义：链表节点
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        next = nil
    }
}
// MARK: 定义：复杂链表
public class RandomListNode {
    public var label: Int
    public var next:RandomListNode?
    public var random:RandomListNode?
    public init(_ val: Int) {
        label = val
    }
}

// MARK: 定义：栈结构  https://github.com/raywenderlich/swift-algorithm-club/blob/master/Stack/Stack.swift
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

// MARK: 扩展Array的下标操作
extension Array {
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}
