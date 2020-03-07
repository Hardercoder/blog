//
//  ThreadQueue.m
//  MyLib_Example
//
//  Created by apple on 2020/3/7.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import "ThreadQueue.h"

static dispatch_queue_t globalSerialQueue = nil;
static NSThread         *methodThread = nil;

@implementation ThreadQueue
+ (void)testThreadQueue {
//    [NSThread detachNewThreadSelector:@selector(test) toTarget:self withObject:nil];
    [self test];
}

+ (void)test {
    methodThread = [NSThread currentThread];
    NSLog(@"当前方法的线程 %@",methodThread);
    [self execAsync];
    [self execSync];
    
}

+ (void)execAsync {
    NSLog(@"%@", @"开始 ============= 异步执行");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSThread *curThread = [NSThread currentThread];
        NSLog(@"主队列 异步执行 线程: %@ 当前线程:%@", curThread,curThread == methodThread ? @"是" : @"否");
    });
    
    globalSerialQueue = dispatch_queue_create([@"zk.serialqueue" cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    dispatch_async(globalSerialQueue, ^{
        NSThread *curThread = [NSThread currentThread];
        NSLog(@"自定义串行队列 异步执行 线程: %@ 当前线程:%@", curThread,curThread == methodThread ? @"是" : @"否");
    });
    
    dispatch_queue_global_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        NSThread *curThread = [NSThread currentThread];
        NSLog(@"全局队列 异步执行 线程: %@ 当前线程:%@", curThread,curThread == methodThread ? @"是" : @"否");
    });
}

+ (void)execSync {
    NSLog(@"%@", @"开始 ============= 同步执行");
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSThread *curThread = [NSThread currentThread];
        NSLog(@"主队列 同步执行 线程: %@ 当前线程:%@", curThread,curThread == methodThread ? @"是" : @"否");
    });
    
    globalSerialQueue = dispatch_queue_create([@"zk.serialqueue" cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    dispatch_sync(globalSerialQueue, ^{
        NSThread *curThread = [NSThread currentThread];
        NSLog(@"自定义串行队列 同步执行 线程: %@ 当前线程:%@", curThread,curThread == methodThread ? @"是" : @"否");
    });
    
    dispatch_queue_global_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_sync(globalQueue, ^{
        NSThread *curThread = [NSThread currentThread];
        NSLog(@"全局队列 同步执行 线程: %@ 当前线程:%@", curThread,curThread == methodThread ? @"是" : @"否");
    });
}


+ (void)testPerform {
//    [self performSelector:@selector(pMethod) withObject:nil afterDelay:0.2];
    [NSThread detachNewThreadSelector:@selector(testP) toTarget:self withObject:nil];
}

+ (void)testP {
    NSRunLoop *curRunloop = [NSRunLoop currentRunLoop];
    [self performSelector:@selector(pMethod) withObject:nil afterDelay:0];
    NSDate *runDate = [[[NSDate alloc] init] dateByAddingTimeInterval:3];
    [curRunloop runMode:NSDefaultRunLoopMode beforeDate:runDate];
}

+ (void)pMethod {
    NSLog(@"%s",__FUNCTION__);
}

@end
