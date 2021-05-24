//
//  MyExpriceObj.m
//  studyobjc4
//
//  Created by apple on 2020/3/10.
//

#import "MyExpriceObj.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

#define COUNT_PARMS2(_a1, _a2, _a3, _a4, _a5, RESULT, ...) RESULT
#define COUNT_PARMS(...) COUNT_PARMS2(__VA_ARGS__, 5, 4, 3, 2, 1)

typedef NS_ENUM(NSInteger, XXType){
    XXType1,
    XXType2
};
const NSString *XXTypeNameMapping[] = {
    [XXType1] = @"Type1",
    [XXType2] = @"Type2"
};

@implementation MyExpriceObj
+ (void)studyObjSize {
    NSObject *myObj = [[NSObject alloc] init];
    NSLog(@"instanceSize %ld  mallocSize %ld",class_getInstanceSize([myObj class]), malloc_size((__bridge void *)myObj));
}
//int sum(a,b)
//int a; int b;
//{
//    return a + b;
//}
// http://blog.sunnyxx.com/2014/08/02/objc-weird-code/
+ (void)saocaozuo {
    int count = COUNT_PARMS(1,2,3); // 预处理时count==3
    NSLog(@"%d",count);
    
//    CGRect rect1 = {1, 2, 3, 4};
//    CGRect rect2 = {.origin.x=5, .size={10, 10}}; // {5, 0, 10, 10}
//    CGRect rect3 = {1, 2}; // {1, 2, 0, 0}
    
//    NSString *string = inputString ?: @"default";
    
//    const int numbers[] = {
//        [1] = 3,
//        [2] = 2,
//        [3] = 1,
//        [5] = 12306
//    };
    
}




@end
