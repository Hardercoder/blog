#### 采用递归算法获取UIView及其子View下所有的UIImageView的实例

```objective-c
- (NSArray*)imageViewsInView:(UIView*)view {
    NSMutableArray *images = [NSMutableArray array];
    if ([view isKindOfClass:[UIImageView class]]) {
        [images addObject:view];
    }
    for (UIView *v in view.subviews) {
        [images addObjectsFromArray:[self imageViewsInView:v]];
    }
    return [images copy];
}
```

#### 获取两个View最近的共同父View和所有的共同父View

```objective-c
// 获取一个view的所有父view
- (NSSet*)parentViewsForView:(UIView*)view {
    NSMutableSet *parentViewsSet = [NSMutableSet set];
    UIView *parentView = view;
    while (parentView != nil) {
        [parentViewsSet addObject:parentView];
        parentView = parentView.superview;
    }
    return [NSSet setWithSet:parentViewsSet];
}
// 最近的共同父View
- (UIView*)nearestParentViewForView1:(UIView*)view1 view2:(UIView*)view2 {
    NSSet *view1ParentsSet = [self parentViewsForView:view1];
    
    UIView *parentView = view2;
    while (parentView != nil) {
        if ([view1ParentsSet containsObject:parentView]) {
            return parentView;
        }
        else {
            parentView = parentView.superview;
        }
    }
    
    return nil;
}
// 所有的共同父View
- (NSSet*)commonParentsViewForView1:(UIView*)view1 view2:(UIView*)view2 {
    NSMutableSet *view1ParentsSet = [NSMutableSet setWithSet:[self parentViewsForView:view1]];
    [view1ParentsSet intersectSet:[self parentViewsForView:view2]];
    return [NSSet setWithSet:view1ParentsSet];
}
```

#### 合并两个已排好序的数组

```objective-c
// 时间复杂度为O(m+n),这个算法的思想就是采用中间数组+两个指针，同时遍历那两个数组，遍历的过程中比较大小存储到中间数组中，其中较短的先被遍历完，之后就是挨个的把另一个数组元素添加到中间数组中
- (NSArray*)mergeSortedArray1:(NSMutableArray*)sortedArray1
             sortedArray2:(NSMutableArray*)sortedArray2 {
    int i = 0;
    int j = 0;
    NSMutableArray *mergedArray = [NSMutableArray arrayWithCapacity:sortedArray1.count+sortedArray2.count];
    while (i < sortedArray1.count && j < sortedArray2.count) {
        if ([sortedArray1[i] integerValue] < [sortedArray2[j] integerValue]) {
            mergedArray[i+j] = sortedArray1[i];
            i += 1;
        }
        else {
            mergedArray[i+j] = sortedArray2[j];
            j += 1;
        }
    }
    
    while (i < sortedArray1.count) {
        mergedArray[i+j]= sortedArray1[i];
        i += 1;
    }
    
    while (j < sortedArray2.count) {
        mergedArray[i+j]= sortedArray2[j];
        j += 1;
    }
    
    return [NSArray arrayWithArray:mergedArray];
}

/// 合并后，array1为最终array，这个的思想其实和上面的一样，只是被面试官误导了，以为不用重点变量去实现呢
// 这个的复杂度就大了
- (void)mergeArray1:(NSMutableArray*)array1
      array1Capcity:(NSUInteger)array1acap
             array2:(NSMutableArray*)array2
      array2Capcity:(NSUInteger)array2acap {
    NSNumber *arra1ele = nil;
    NSNumber *arra2ele = nil;
    
    NSUInteger i = 0;//第一个元素对应的index
    NSUInteger j = 0;//第二个数组对应的index
    
    while (i < array1acap+array2acap) {
        // 取第一个数组的元素
        if (i < array1.count) {
            arra1ele = (NSNumber*)[array1 objectAtIndex:i];
        }
        else {
            arra1ele = nil;
        }
        
        // 取第2个数组的元素
        if (j < array2.count) {
            arra2ele = (NSNumber*)[array2 objectAtIndex:j];
        }
        else {
            arra2ele = nil;
        }
        
        NSLog(@"%ld %@ %ld %@",i,arra1ele,j,arra2ele);
        if (arra2ele != nil) {
            if ([arra1ele integerValue] >= [arra2ele integerValue]) {
                // 当前1>=2,继续走2数组，并且把值插入进去
                j += 1;
                
                [array1 insertObject:arra2ele atIndex:i];
                i += 1;
            }
            else {
                // 当前1<2,继续走1数组,找到1大于2时，把它插入
                i += 1;
            }
        }
        else {
            // 结束循环
            i = NSUIntegerMax;
        }
    }
}
```

