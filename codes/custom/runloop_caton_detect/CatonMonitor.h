//
//  CatonMonitor.h
//  MyLib_Example
//
//  Created by apple on 2020/3/7.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatonMonitor : NSObject
+ (instancetype)shareInstance;

- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视卡顿
@end

NS_ASSUME_NONNULL_END
