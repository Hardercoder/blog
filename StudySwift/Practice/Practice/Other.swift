//
//  Other.swift
//  Practice
//
//  Created by unravel on 2021/5/11.
//

import Foundation
typealias MyFunc = (String) -> Void
typealias MyFunc2 = (String) -> ()

let myFunc: MyFunc = { txt in print(txt) }
let myFun2: MyFunc2 = { txt in print(txt) }

func isNumber<T: Numeric>(number: T ) {
    print("\(number) is a number")
}

