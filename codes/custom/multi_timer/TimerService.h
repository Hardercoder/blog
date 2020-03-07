//
//  TimerService.h
//  MyLib_Example
//
//  Created by apple on 2020/2/27.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TimerService;
//监听者需要实现的协议
@protocol TimerListener <NSObject>
@required
- (void)didOnTimer:(TimerService *)timer;
@end

@interface TimerService : NSObject
//对接提供的主要接口
+ (instancetype)sharedInstance;

- (void)startTimer;
- (void)stopTimer;

- (void)addListener:(id<TimerListener>)listener;
- (void)removeListener:(id<TimerListener>)listener;
@end

NS_ASSUME_NONNULL_END
