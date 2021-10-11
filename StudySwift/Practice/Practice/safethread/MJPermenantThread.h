//
//  MJPermenantThread.h
//  Interview03-线程保活
//
//  Created by MJ Lee on 2018/6/5.
//  Copyright © 2018年 MJ Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MJPermenantThreadTask)(void);

@interface MJPermenantThread : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(MJPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end
