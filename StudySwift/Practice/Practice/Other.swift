//
//  Other.swift
//  Practice
//
//  Created by unravel on 2021/5/11.
//

import Foundation
typealias MyFunc = (String) -> Void
typealias MyFunc2 = (String) -> ()

let myFunc: MyFunc = { print($0) }
let myFun2: MyFunc2 = { print($0) }


func isNumber<T: Numeric>(number: T ) {
    print("\(number) is a number")
}

