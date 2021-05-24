//
//  CatonMonitor.m
//  MyLib_Example
//
//  Created by apple on 2020/3/7.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import "CatonMonitor.h"

@interface CatonMonitor() {
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
@public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}
//@property (nonatomic, strong) NSTimer *cpuMonitorTimer;
@end

@implementation CatonMonitor

#pragma mark - Interface
+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)beginMonitor {
    //监测 CPU 消耗
    //    self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3
    //                                                            target:self
    //                                                          selector:@selector(updateCPUInfo)
    //                                                          userInfo:nil
    //                                                           repeats:YES];
    //监测卡顿
    if (runLoopObserver) {
        return;
    }
    dispatchSemaphore = dispatch_semaphore_create(0); //Dispatch Semaphore保证同步
    //创建一个观察者
    CFRunLoopObserverContext context = {0, (__bridge void*)self, NULL, NULL};
    
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &runLoopObserverCallBack,
                                              &context);
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的loop用来进行监控
        while (YES) {
            // 假定连续3次超时20ms认为卡顿(当然也包含了单次超时60ms)
            // Returns zero on success, or non-zero if the timeout occurred.
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                // RunLoop会一直循环检测，从线程start到线程end，检测到事件源（CFRunLoopSourceRef）执行处理函数，首先会产生通知，
                // corefunction向线程添加runloopObservers来监听事件，并控制NSRunLoop里面线程的执行和休眠，
                // 在有事情做的时候使当前NSRunLoop控制的线程工作，没有事情做让当前NSRunLoop的控制的线程休眠
                
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (self->runLoopActivity == kCFRunLoopBeforeSources ||
                    self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    // 将堆栈信息上报服务器的代码放到这里
                    // [NSThread callStackSymbols];
                    
                    //出现三次出结果
                    if (++self->timeoutCount < 3) {
                        continue;
                    }
                    NSLog(@"monitor trigger");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                    });
                } //end activity
            }// end semaphore wait
            self->timeoutCount = 0;
        }// end while
    });
    
}

- (void)endMonitor {
    //    [self.cpuMonitorTimer invalidate];
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

#pragma mark - Private

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    CatonMonitor *lagMonitor = (__bridge CatonMonitor*)info;
    lagMonitor->runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}


//- (void)updateCPUInfo {
//    thread_act_array_t threads;
//    mach_msg_type_number_t threadCount = 0;
//    const task_t thisTask = mach_task_self();
//    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
//    if (kr != KERN_SUCCESS) {
//        return;
//    }
//    for (int i = 0; i < threadCount; i++) {
//        thread_info_data_t threadInfo;
//        thread_basic_info_t threadBaseInfo;
//        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
//        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
//            threadBaseInfo = (thread_basic_info_t)threadInfo;
//            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
//                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
//                if (cpuUsage > 70) {
//                    //cup 消耗大于 70 时打印和记录堆栈
//                    NSString *reStr = smStackOfThread(threads[i]);
//                    //记录数据库中
//                    //                    [[[SMLagDB shareInstance] increaseWithStackString:reStr] subscribeNext:^(id x) {}];
//                    NSLog(@"CPU useage overload thread stack：\n%@",reStr);
//                }
//            }
//        }
//    }
//}

@end
