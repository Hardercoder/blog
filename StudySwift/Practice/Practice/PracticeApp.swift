//
//  PracticeApp.swift
//  Practice
//
//  Created by unravel on 2021/5/11.
//

import SwiftUI

@main
struct PracticeApp: App {
    func testEqualFunc() {
        myFun2("myFunc2")
        myFunc("myFunc")
        
//        print("判断函数类型是否相同 \(myFun2.Type == myFunc.Type)")
    }
    
    var body: some Scene {
        testEqualFunc()
        return WindowGroup {
            ContentView()
        }
    }
}
