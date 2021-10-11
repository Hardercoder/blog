//
//  OtherExercise.swift
//  CommandLine
//
//  Created by unravel on 2021/5/12.
//

import Foundation
func practiceStride() {
    print("a: ",terminator: "")
    for a in stride(from: 1, to: 20, by: 2) {
        print(a, terminator: " ")
    }
    
    print("\nb: ",terminator: "")
    for b in stride(from: 0, through: 20, by: 2) {
        print(b, terminator: " ")
    }
    print("")
}

func practiceForIn() {
    let nums = [1,3,5,15,51,25,2]
    for (index,value) in nums.enumerated() {
        print(index, value)
    }
    
    let ss = "asfasdfsafsfd"
    for (ind,c) in ss.reversed().enumerated() {
        print(ind,c)
    }
}

func practiceFormat() {
    print(String(format: "%3d", 23))
    print(String(format: "%@", "bbbb"))
    print(String(format: "%-.36f", 23.22))
}

func practiceTrans() {
    let a = -101
    print("\(a)")
}

func practiceStrAppend() {
    var s = "asdfsdf"
    s.append("aa")
    print(s)
}

func practiceStrIndx() {
    
    let str = "1234556"
    //    let starInd = str.startIndex
    //    let i = str.index(starInd, offsetBy: 4, limitedBy: str.endIndex)
    let j = str.index(str.startIndex, offsetBy: 7, limitedBy: str.endIndex)
    //    print(i)
    //    print(j)
    if j != nil && j != str.endIndex {
        print("sadasf")
    }
}

func practiceFor() {
    let str = [1,2,3,5,6,7]
    for i in str {
        print("外层 ", i)
        for j in str.dropFirst() {
            print("内层 ", j)
            if j == 5 {
                print("内层 5 break")
                break
            }
        }
        print("内层for循环结束")
    }
}

func practiceMultiParam() {
    func test(a: Int..., b: String, c: String...) {
        print(a,b)
    }
}
