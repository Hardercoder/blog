[TOC]

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

#### 写一个算法获取十进制数进行二进制表示后1的个数

```objective-c
- (NSUInteger)countOfBinary1In:(NSInteger)num {
    //（最优）采用位运算（x&（x-1），每次将给定的数的最右边的1变位0）
    // 采用给定的数与给定的数-1逻辑与操作，把给定的数的最后边的1变成0，操作一次，count自增一次，知道给定的数的1全部变为0，退出循环
    NSUInteger count = 0;
    
    NSInteger mNum = num;
    while (mNum != 0) {
        mNum = mNum & (mNum - 1);
        count++;
    }
#if DEBUG
    NSString *tmp = [NSString stringWithFormat:@"%ld",num];
    NSString *binaryStr = [self convertBinarySystemFromDecimalSystem:tmp];
    NSLog(@"%@ 二进制%@ 有%ld个1", tmp, binaryStr, count);
#endif
    return count;
}

#pragma mark 二进制转十进制
- (NSString *)convertDecimalSystemFromBinarySystem:(NSString *)binary {
    NSInteger  ll = 0 ;
    NSInteger  temp = 0 ;
    for (NSInteger i = 0; i < binary.length; i ++){
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    return [NSString stringWithFormat:@"%ld",ll];
}

#pragma mark 十进制转二进制
- (NSString *)convertBinarySystemFromDecimalSystem:(NSString *)decimal {
    NSInteger num = [decimal intValue];
    if (num < 0) {
        num = num + NSIntegerMax;
    }
    
    NSInteger remainder = 0;      //余数
    NSInteger divisor = 0;        //除数
    
    NSMutableString * prepare = [NSMutableString string];
    
    while (true){
        remainder = num % 2;
        divisor = num / 2;
        num = divisor;
        [prepare appendFormat:@"%ld",remainder];
        
        if (divisor == 0) {
            break;
        }
    }
    
    NSMutableString * result = [NSMutableString string];
    for (NSInteger i = prepare.length - 1; i >= 0; i --) {
        [result appendFormat:@"%@", [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;
}
```

#### 寻找一个字符串中不包含重复字符的最长子串的长度

```objective-c
// 滑动窗口方法
- (void)maxNoRepeatStrLengthFor:(NSString*)str {
    NSMutableSet * set = [[NSMutableSet alloc] init];
    int ans = 0;// 两个临近的相同字符的间距
    int i = 0; //前序走的index
    int j = 0; // 后序走的index
    
    NSUInteger length = str.length;
    while (j < length) {
        NSString *subStrAtJ = [str substringWithRange:NSMakeRange(j,1)];
        if (![set containsObject:subStrAtJ]) {
            [set addObject:subStrAtJ];
            j += 1;
            
            // 判断两个相同字符的差距是不是和之前的更大
            if (j - i > ans) {
                ans = j - i;
            }
        }
        else {
            [set removeObject:[str substringWithRange:NSMakeRange(i, 1)]];
            i += 1;
        }
        
        NSLog(@"111111111=== i %d j %d",i,j);
    }
    NSLog(@"%d", ans);
}
// 优化的滑动窗口
- (void)maxNoRepeatStrLengthFor1:(NSString*)str {
    NSUInteger length = str.length;
    // str : index
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:length];
    
    int ans = 0;// 两个临近的相同字符的间距
    int i = 0; //前序走的index
    int j = 0; // 后序走的index
    
    while (j < length) {
        NSString *subStrAtJ = [str substringWithRange:NSMakeRange(j,1)];
        if ([dict.allKeys containsObject:subStrAtJ]) {
            //应该保证滑动窗口的起始位置依次向前，不能倒退
            i = MAX(i, [dict[subStrAtJ] intValue] + 1);//max的作用 ：考虑字符串abba这个例子
        }
        NSLog(@"2222222=== i %d j %d",i,j);
        
        dict[subStrAtJ] = @(j);
        j += 1;
        ans = MAX(ans, j - i);
    }
    NSLog(@"%d", ans);
}

// 优化的滑动窗口
- (void)maxNoRepeatStrLengthFor2:(NSString*)str {
    if (str == nil || str.length == 1) {
        return;
    }
    
    NSUInteger length = str.length;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:length];
    int ans = 0;// 两个临近的相同字符的间距
    
    int i = 0; //前序走的index
    int j = 0; // 后序走的index
    for (j = 0; j < length; j++) {
        NSString *subStrAtJ = [str substringWithRange:NSMakeRange(j,1)];
        if ([dict.allKeys containsObject:subStrAtJ]) {
            i = MAX(i,[dict[subStrAtJ] intValue] + 1);
        }
        dict[subStrAtJ] = @(j);
        if (j - i > ans) {
            ans = j - i;
        }
        NSLog(@"33333=== i %d j %d",i,j);
    }
    NSLog(@"%d", ans > 0 ? ans + 1 : 0);
}
```

#### 交换两个NSInteger的值你能想到几种方法

```objective-c
// 交换A和B的值
// 1.使用中间变量
- (void)swap0a:(NSInteger)a b:(NSInteger)b {
    NSInteger temp = a;
    a = b;
    b = temp;
    NSLog(@"%ld %ld",a,b);
}

// 2.加法
- (void)swap1a:(NSInteger)a b:(NSInteger)b {
    a = a + b;
    b = a - b;
    a = a - b;
    NSLog(@"%ld %ld",a,b);
}

// 3.异或（相同为0，不同为1. 可以理解为不进位加法）
- (void)swap2a:(NSInteger)a b:(NSInteger)b {
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
    NSLog(@"%ld %ld",a,b);
}
```

#### 求两个NSInteger的最大公约数，这里假定a>b

```objective-c
/** 1.直接遍历法 */
- (NSInteger)maxCommonDivisorFor0A:(NSInteger)a b:(NSInteger)b {
    NSInteger max = 0;
    for (NSInteger i = 1; i <= b; i++) {
        if (a % i == 0 && b % i == 0) {
            max = i;
        }
    }
    NSLog(@"%ld",max);
    return max;
}

/** 2.辗转相除法 其中a为大数，b为小数 */
- (NSInteger)maxCommonDivisorFor1A:(NSInteger)a b:(NSInteger)b {
    NSInteger r = a % b;
    while(r > 0) {
        a = b;
        b = r;
        r = a % b;
    }
    NSLog(@"%ld",b);
    return b;
}
```

#### 判断一个数是否为质数(只能被1和自身整除的叫质数)

```objective-c
- (BOOL)isPrime:(NSInteger)n {
    for(int i = 2; i <= sqrt(n); i++) {
        if(n % i == 0) {
            return NO;
        }
    }
    return YES;
}
```

#### 给定一个字符串,输出本字符串中只出现一次并且最靠前的那个字符的位置

```
- (NSInteger)indexForFirstDisguistCharIn:(NSString*)str {
    if (str == nil || str.length == 0) {
        return -1;
    }
    if (str.length == 1) {
        return 0;
    }
    // str : str's count 存储字符->字符出现的数量
    NSMutableDictionary *charCountDict = [NSMutableDictionary dictionaryWithCapacity:str.length];
    // 只出现1次的字符
    NSMutableSet *difficultSet = [NSMutableSet setWithCapacity:str.length];
    
    for (int i = 0; i < str.length; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
        if ([charCountDict.allKeys containsObject:subStr]) {
            int count = [charCountDict[subStr] intValue];
            charCountDict[subStr] = @(count + 1);
        }
        else {
            charCountDict[subStr] = @(1);
        }
        
        if ([charCountDict[subStr] intValue] == 1) {
            if (![difficultSet containsObject:subStr]) {
                [difficultSet addObject:subStr];
            }
        }
        else {
            if ([difficultSet containsObject:subStr]) {
                [difficultSet removeObject:subStr];
            }
        }
    }
    
    for (int i = 0; i < str.length; i++) {
        NSString *subStr = [str substringWithRange:NSMakeRange(i, 1)];
        if ([difficultSet containsObject:subStr]) {
            return i;
        }
    }
    return -1;
}
```

#### 返回正整数N的二进制周期，如果没有周期就返回-1

```swift
func getBinaryPeriodForInt(_ n: Int) -> Int {
    var nn = n
    var d = [Int]()
    var l = 0, res = -1
    while l > 0 {
        d[l] = nn % 2
        nn /= 2
        l += 1
    }
    for p in 1..<l {
        if p < l / 2 {
            var ok = true
            for i in 0..<l-p {
                if d[i] != d[i+p] {
                    ok = false
                    break
                }
            }
            if ok {
                res = p
            }
        }
    }
    return res
}
```

**排序算法**

选择排序、冒泡排序、插入排序三种排序算法可以总结为如下：

- 都将数组分为已排序部分和未排序部分
- 选择排序将已排序部分定义在左端，然后选择未排序部分的最小元素和未排序部分的第一个元素交换
- 冒泡排序将已排序部分定义在右端，在遍历未排序部分的过程执行交换，将最大元素交换到最右端
- 插入排序将已排序部分定义在左端，将未排序部分元的第一个元素插入到已排序部分合适的位置

**选择排序**

- 【选择排序】：最值出现在起始端
- 第1趟：在n个数中找到最小(大)数与第一个数交换位置
- 第2趟：在剩下n-1个数中找到最小(大)数与第二个数交换位置
- 重复这样的操作...依次与第三个、第四个...数交换位置
- 第n-1趟，最终可实现数据的升序（降序）排列

```cpp
void selectSort(int *arr, int length) {
    for (int i = 0; i < length - 1; i++) { //趟数
        for (int j = i + 1; j < length; j++) { //比较次数
            if (arr[i] > arr[j]) {
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
    }
}
```

**冒泡排序**

- 【冒泡排序】：相邻元素两两比较，比较完一趟，最值出现在末尾
- 第1趟：依次比较相邻的两个数，不断交换（小数放前，大数放后）逐个推进，最值最后出现在第n个元素位置
- 第2趟：依次比较相邻的两个数，不断交换（小数放前，大数放后）逐个推进，最值最后出现在第n-1个元素位置
- ……   ……
- 第n-1趟：依次比较相邻的两个数，不断交换（小数放前，大数放后）逐个推进，最值最后出现在第2个元素位置

```cpp
void bublleSort(int *arr, int length) {
    for(int i = 0; i < length - 1; i++) { //趟数
        for(int j = 0; j < length - i - 1; j++) { //比较次数
            if(arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        } 
    }
}
```

#### 二分查找

折半查找：优化查找时间（不用遍历全部数据）
 折半查找的原理：

- 1> 数组必须是有序的
- 2> 必须已知min和max（知道范围）
- 3> 动态计算mid的值，取出mid对应的值进行比较
- 4> 如果mid对应的值大于要查找的值，那么max要变小为mid-1
- 5> 如果mid对应的值小于要查找的值，那么min要变大为mid+1

// 已知一个有序数组, 和一个key, 要求从数组中找到key对应的索引位置

```swift
int findKey(int *arr, int length, int key) {
    int min = 0, max = length - 1, mid;
    while (min <= max) {
        mid = (min + max) / 2; //计算中间值
        if (key > arr[mid]) {
            min = mid + 1;
        } else if (key < arr[mid]) {
            max = mid - 1;
        } else {
            return mid;
        }
    }
    return -1;
}
```