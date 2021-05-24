//
//  ZKViewController+TestWeakPro.h
//  MyLib_Example
//
//  Created by apple on 2020/2/10.
//  Copyright © 2020 zhoukang. All rights reserved.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (TestWeakPro)
@property (nonatomic, weak) NSString *myWeakPro;
@end

NS_ASSUME_NONNULL_END
