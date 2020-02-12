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

#### 已知单向链表，其中每个节点有一个int类型的data字段(0~9)和一个next指针，按照如下的方式连接3->5->2表示352，请写出两个链表做加法

```objective-c
// 定义链表节点
@interface Node : NSObject
@property (nonatomic, assign) int data;
@property (nonatomic, strong) Node *next;
@end
@implementation Node
- (NSString *)description {
    NSMutableString *str = [NSMutableString string];
    Node *node = self;
    while (node) {
        [str appendFormat:@"%d",node.data];
        node = node.next;
    }
    return [str copy];
}
@end

- (void)viewDidLoad {
    [super viewDidLoad];
    // 构建链表1
    Node *node1 = [[Node alloc] init];
    node1.data = 3;
    
    Node *tmp = node1;
    NSArray *nums = @[@(7),@(8),@(2)];
    for (NSNumber *num in nums) {
        Node *nextNode = [[Node alloc] init];
        nextNode.data = [num intValue];
        tmp.next = nextNode;
        
        tmp = nextNode;
    }
    // 构建链表2
    Node *node2 = [[Node alloc] init];
    node2.data = 0;
    
    tmp = node2;
    nums = @[@(6),@(1),@(5),@(8),@(0)];
    for (NSNumber *num in nums) {
        Node *nextNode = [[Node alloc] init];
        nextNode.data = [num intValue];
        tmp.next = nextNode;
        
        tmp = nextNode;
    }
    // 调用链表加法算法
    [self nodeAdd:node1 node2:node2];
}

- (Node*)nodeAdd:(Node*)node1 node2:(Node*)node2 {
    // 3->5->1 要算加法，肯定要倒序链表
    NSMutableArray *rNode1 = [NSMutableArray arrayWithCapacity:20];
    Node *tmp = node1;
    // 反转node1
    while (tmp != nil) {
        [rNode1 addObject:tmp];
        tmp = tmp.next;
    }
    // 反转node2
    NSMutableArray *rNode2 = [NSMutableArray arrayWithCapacity:20];
    tmp = node2;
    while (tmp != nil) {
        [rNode2 addObject:tmp];
        tmp = tmp.next;
    }
    
    NSEnumerator *rNode1E = [rNode1 reverseObjectEnumerator];
    NSEnumerator *rNode2E = [rNode2 reverseObjectEnumerator];
    // 进行计算
    NSMutableArray *calculateNodes = [NSMutableArray arrayWithCapacity:MAX(rNode1.count, rNode2.count)];
    Node *calculate1 = rNode1E.nextObject;
    Node *calculate2 = rNode2E.nextObject;
    
    // 进位标识
    int flag = 0;
    while (calculate1 != nil && calculate2 != nil) {
        int num = calculate1.data + calculate2.data + flag;
        if (num >= 10) {
            flag = 1;
            num -= 10;
        }
        else {
            flag = 0;
        }
        
        Node *tmp = [[Node alloc] init];
        tmp.data = num;
        [calculateNodes addObject:tmp];
        
        calculate1 = rNode1E.nextObject;
        calculate2 = rNode2E.nextObject;
    }
    
    while (calculate1 != nil) {
        int num = calculate1.data + flag;
        if (num >= 10) {
            flag = 1;
            num -= 10;
        }
        else {
            flag = 0;
        }
        
        Node *tmp = [[Node alloc] init];
        tmp.data = num;
        [calculateNodes addObject:tmp];
        
        calculate1 = rNode1E.nextObject;
    }
    
    while (calculate2 != nil) {
        int num = calculate2.data + flag;
        if (num >= 10) {
            flag = 1;
            num -= 10;
        }
        else {
            flag = 0;
        }
        
        Node *tmp = [[Node alloc] init];
        tmp.data = num;
        [calculateNodes addObject:tmp];
        
        calculate2 = rNode2E.nextObject;
    }
    
    //反转所得结果
    NSEnumerator *node3E = [calculateNodes reverseObjectEnumerator];
    tmp = node3E.nextObject;
    Node *node3 = nil;
    
    while (tmp != nil) {
        if (node3 == nil && tmp.data > 0) {
            node3 = tmp;
        }
        Node *m = node3E.nextObject;
        tmp.next = m;
        tmp = m;
    }
#if DEBUG
    NSLog(@"\n%@\n+\n%@\n=\n%@",node1,node2,node3);
#endif
    return node3;
}
```

