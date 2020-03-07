//
//  ZKViewController+TestWeakPro.m
//  MyLib_Example
//
//  Created by apple on 2020/2/10.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import "ZKViewController+TestWeakPro.h"
#import <objc/runtime.h>
// 方案一
// 定义一个包装类，将weak属性包装起来。这样有一个问题就是weak指向的对象释放后，其实这个wrapper还是存在的
@interface WeakProWrapper : NSObject
@property (nonatomic, weak) id proWeak;
@end
@implementation WeakProWrapper
@end

// 方案二
typedef id WeakId;
typedef WeakId(^WeakReference)(void);

WeakReference PackWeakReference(id ref) {
    __weak __typeof(WeakId) weakRef = ref;
    return ^{
        return weakRef;
    };
}

WeakId UnPackWeakReference(WeakReference closure) {
    return closure ? closure() : nil;
}

@implementation ZKViewController (TestWeakPro)

- (NSString *)myWeakPro {
    return UnPackWeakReference(objc_getAssociatedObject(self, @selector(myWeakPro)));
}

- (void)setMyWeakPro:(NSString *)myWeakPro {
    objc_setAssociatedObject(self, @selector(myWeakPro), PackWeakReference(myWeakPro), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
