//
//  main.m
//  objc-debug
//
//  Created by Cooci on 2019/10/9.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSObject *myObj = [[NSObject alloc] init];
        __weak NSObject *a = myObj;
        
    }
    return 0;
}
