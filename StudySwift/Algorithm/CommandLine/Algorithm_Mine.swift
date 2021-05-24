//
//  Algorithm_Mine.swift
//  Practice
//
//  Created by unravel on 2021/5/11.
//

import Foundation

class AlgorithmMine {
    // 一个乱序数组，求 一个 比它前面的数都大，比它后面的数都小的数 组成的数组
    private func printMinMaxArray() {
        let array = [1,2,3,7,10,9,11,1,5,38,12,25,56,100]
        var stack = Stack<Int>()
        if array.count > 0 {
            let firstValue = array[0]
            print("首次入栈 \(firstValue)")
            stack.push(firstValue)
            var maxValue = firstValue
            
            for value in array.dropFirst() {
                if value > maxValue {
                    let sufTxt = stack.top == nil ? "首次入栈" : "入栈"
                    print("\(value)比遍历过的最大值\(maxValue)大，\(sufTxt)")
                    maxValue = value
                    stack.push(value)
                }
                else {
                    print("\(value)遍历过的最大值\(maxValue)小")
                    while let topValue = stack.top, topValue >= value {
                        stack.pop()
                        let sufTxt = stack.top != nil ? "出栈" : "栈已清空"
                        print("\(value)比栈顶\(topValue)小 \(sufTxt)")
                    }
                }
            }
        }
        print("获取到结果 \(stack.toArray)")
    }
    
    // 构建并打印倒三角形
    func printInvertedtriangle(_ numLines: Int) {
        let count = numLines + 1
        
        var ret = [[Int]](repeating: [Int](repeating: 0, count: count),
                          count: count)
        ret[0][0] = 1
        for i in 0..<numLines {
            let rowdet = i + 1
            // 竖着的，每一行比上一行 大row+1
            ret[i + 1][0] = ret[i][0] + rowdet
            print("\(ret[i][0]) ", separator: "", terminator: "")
            
            // 横着的，每一列比上一列
            let colNum = numLines - i - 1
            for j in 0..<colNum {
                let coldet = j + 1
                ret[i][j + 1] = ret[i][j] + rowdet + coldet
                print("\(ret[i][j + 1]) ", separator: "", terminator: "")
            }
            print("\n")
        }
    }
}
