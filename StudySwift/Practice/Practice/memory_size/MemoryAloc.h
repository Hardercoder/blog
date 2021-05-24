//
//  MemoryAloc.h
//  MyLib_Example
//
//  Created by apple on 2020/3/7.
//  Copyright © 2020 zhoukang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryAloc : NSObject {
@public NSString *strA;
@public short shortA;
@public int   intA;
@public char charA[8];
}

+ (void)testMemoryLayout;
@end

NS_ASSUME_NONNULL_END
