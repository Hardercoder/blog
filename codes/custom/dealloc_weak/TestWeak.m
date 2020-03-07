//
//  TestWeak.m
//  objc-debug
//
//  Created by apple on 2020/3/7.
//

#import "TestWeak.h"

@implementation TestWeak
- (void)dealloc {
    // 这里会直接崩溃
    __weak __typeof(self) weakSelf = self;
    NSLog(@"weakSelf %@", weakSelf);
}
@end
