//
//  NSRunLoop+Hook.m
//  MyLib_Example
//
//  Created by apple on 2020/2/27.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import "NSRunLoop+Hook.h"
#import <objc/runtime.h>

NSString * const kDef_ThreadName = @"com.test.thread";

@implementation NSRunLoop (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _swizzleImpWithOrigin:@selector(runMode:beforeDate:)
                            swizzle:@selector(xd_runMode:beforeDate:)];
    });
}

+ (void)_swizzleImpWithOrigin:(SEL)originSelector
                      swizzle:(SEL)swizzleSelector {

    Class _class = [self class];
    Method originMethod = class_getInstanceMethod(_class, originSelector);
    Method swizzleMethod = class_getInstanceMethod(_class, swizzleSelector);

    IMP originIMP = method_getImplementation(originMethod);
    IMP swizzleIMP = method_getImplementation(swizzleMethod);

    BOOL add = class_addMethod(_class, originSelector, swizzleIMP, method_getTypeEncoding(swizzleMethod));

    if (add) {
        class_addMethod(_class, swizzleSelector, originIMP, method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

- (BOOL)xd_runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate {
    NSThread *thread = [NSThread currentThread];

    // 这里我们只对自己创建的线程runloop的`runMode:beforeDate:`方法进行修改.
    if ([thread.name isEqualToString:kDef_ThreadName]) {
        NSLog(@"runloop+hook: %@线程",kDef_ThreadName);
        return YES; //如果这里返回`NO`, runloop会立刻退出, 故要返回`YES`进行验证.
    }

    NSLog(@"runloop+hook: 其他可能未知的线程%@ ", thread.name);
    return [self xd_runMode:mode beforeDate:limitDate];
}

@end
