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

