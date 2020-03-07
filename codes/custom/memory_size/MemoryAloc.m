//
//  MemoryAloc.m
//  MyLib_Example
//
//  Created by apple on 2020/3/7.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import "MemoryAloc.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>
@implementation MemoryAloc
+ (void)testMemoryLayout {
    NSObject *obj = [[NSObject alloc] init];
    
    NSLog(@"class_getInstanceSize obj= %ld",class_getInstanceSize([obj class]));
    NSLog(@"malloc_size obj= %ld",malloc_size((__bridge void *)obj));
    NSLog(@"%@",@"\n");
    MemoryAloc *te = [[MemoryAloc alloc] init];
    //    NSLog(@"%ld",sizeof(te->isa));
    NSLog(@"te->shortA %ld",sizeof(te->strA));
    NSLog(@"te->shortA %ld",sizeof(te->shortA));
    NSLog(@"te->intA %ld",sizeof(te->intA));
    NSLog(@"te->charA[2] %ld",sizeof(te->charA));
    
    NSLog(@"class_getInstanceSize te= %ld",class_getInstanceSize([te class]));
    NSLog(@"malloc_size te= %ld",malloc_size((__bridge void *)(te)));
    
}
@end
