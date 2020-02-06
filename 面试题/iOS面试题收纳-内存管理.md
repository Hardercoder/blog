[TOC]

#### 什么是内存泄漏

- 内存泄漏指动态分配内存的对象在使用完后没有被系统回收内存，导致对象始终占有着内存，属于内存管理出错。一次内存泄露危害可以忽略，但内存泄漏堆积后果很严重，无论多少内存，迟早会被耗光
- 常见的有ARC下block，delegate，NSTimer等的循环引用造成内存泄漏

#### 什么是内存溢出

- 当程序在申请内存时，没有足够的内存空间供其使用，出现out of memory；比如申请了一个int，但给它存了long才能存下的数，那就是内存溢出

#### 什么是僵尸对象

- 已经被销毁的对象(不能再使用的对象)，内存已经被回收的对象。一个引用计数器为0的对象被释放后就变为了僵尸对象

#### 什么是野指针

- 野指针又叫做'悬挂指针'，野指针出现的原因是因为指针没有赋值，或者指针指向的对象已经释放了，比如指向僵尸对象;野指针可能会指向一块垃圾内存，给野指针发送消息会导致程序崩溃

  ```css
  NSObject *obj = [NSObject new];
  [obj release]; // obj 指向的内存地址已经释放了,
  obj 如果再去访问的话就是野指针错误了.
  野指针错误形式在Xcode中通常表现为：Thread 1：EXC_BAD_ACCESS，因为你访问了一块已经不属于你的内存。
  ```

#### 什么是空指针

- 空指针不同于野指针，它是一个没有指向任何内存的指针，空指针是有效指针，值为`nil,NULL,Nil,0`等，给空指针发送消息不会报错，不会响应消息

#### OC对象的内存管理机制

- 在iOS中，使用引用计数来管理OC对象的内存，主要有`自动内存管理、手动内存管理、自动释放池`三种方式
  - 一个新创建的OC对象引用计数默认是1，当引用计数减为0时OC对象就会被销毁，释放其占用的内存空间
  - MRC下调用`retain`会让OC对象的引用计数+1，调用`release`会让OC对象的引用计数-1

- 内存管理的经验总结
  - 当调用alloc、new、copy、mutableCopy方法获得一个对象，在不需要这个对象时，要调用release或者autorelease来释放它
  - 想拥有某个对象，就让它的引用计数+1；不想再拥有某个对象，就让它的引用计数-1

- 可以通过以下私有函数来查看自动释放池的情况
  - `extern void _objc_autoreleasePoolPrint(void)`

#### ARC 都帮我们做了什么？

- LLVM + Runtime 会为我们代码自动插入retain和release以及 autorelease等代码，不需要我们手动管理

#### weak指针的实现原理

- Runtime维护了一个全局的weak表，用于存储指向某个对象的所有weak指针，weak表其实是一个hash（哈希）表，Key是所指对象的地址，Value是weak指针的地址（这个地址的值是所指对象的地址）数组
  - 初始化时：runtime会调用objc_initWeak函数，初始化一个新的weak指针指向对象的地址
  - 添加引用时：objc_initWeak函数会调用 storeWeak() 函数， storeWeak() 的作用是更新指针指向，创建对应的弱引用表
  - 释放时,调用clearDeallocating函数。clearDeallocating函数首先根据对象地址获取所有weak指针地址的数组，然后遍历这个数组把其中的数据设为nil，最后把这个entry从weak表中删除，最后清理对象的记录

#### 方法里有局部对象， 出了方法后会立即释放吗

- 如果是普通的局部对象，会立即释放
- 如果是放在了 autoreleasePool 自动释放池，则会等runloop 循环,进入休眠前释放

#### OC中有GC垃圾回收机制吗，iPhone上有GC吗

- 垃圾回收(GC)就是程序中用于处理废弃不用的内存对象的机制，防止内存泄露
- OC本身是支持垃圾回收的，不过只支持MAC OSX平台，iOS 平台不支持

#### 在OC中与 Alloc 语义相反的是 release 还是 dealloc

- alloc 与 dealloc 语义相反，alloc 是创建变量，dealloc是释放变量
- retain 与 release 语义相反，retain 保留一个对象，引用计数器+1；release 使引用计数器 -1

#### 内存区域分布

在iOS开发过程中，为了合理的分配有限的内存空间，将内存区域分为五个区，由低地址向高地址分类依次是：代码区、常量区、全局静态区、堆区和栈区

- 代码段：也叫程序区，存放程序编译产生的二进制的数据

- 常量区：存储常量数据，通常程序结束后由系统自动释放（编译时分配，APP结束由系统释放）

- 全局静态区：全局区又可分为未初始化全局区(.bss段)和初始化全局区(data段)

  全局变量和静态变量的存储是放在一块的，初始化的全局变量和静态变量在一块区域， 未初始化的全局变量和未初始化的静态变量在相邻的另一块区域，在程序结束后有系统释放（编译时分配，APP结束由系统释放）

- 堆区（heap) ：动态分配内存，需要程序员申请，也需要程序员自己管理(alloc、malloc等)

- 栈区（stack）：由编译器自动分配和释放，一般存放函数的参数值，局部变量等

#### 堆和栈的区别

- `栈区(stack)`由编译器自动分配释放 ，存放方法(函数)的参数值，局部变量的值等，栈是向低地址扩展的数据结构，是一块连续的内存的区域。即栈顶的地址和栈的最大容量是系统预先规定好的
- `堆区(heap)`一般由程序员分配释放，若程序员不释放，程序结束时由OS回收，向高地址扩展的数据结构，是不连续的内存区域，从而堆获得的空间比较灵活
- `碎片问题`：对于堆来讲，频繁的`new/delete`势必会造成内存空间的不连续，从而造成大量的碎片，使程序效率降低。对于栈来讲，则不会存在这个问题，因为栈是先进后出的队列，他们是如此的一一对应，以至于永远都不可能有一个内存块从栈中间弹出
- `分配方式`：堆都是动态分配的，没有静态分配的堆。栈有2种分配方式：静态分配和动态分配。静态分配是编译器完成的，比如局部变量的分配。动态分配由alloc函数进行分配，但是栈的动态分配和堆是不同的，他的动态分配是由编译器进行释放，无需我们手工实现。
- `分配效率`：栈是机器系统提供的数据结构，计算机会在底层对栈提供支持：分配专门的寄存器存放栈的地址，压栈出栈都有专门的指令执行，这就决定了栈的效率比较高。堆则是C/C++函数库提供的，它的机制是很复杂的。
- `全局区(静态区)(static)`,全局变量和静态变量的存储是放在一块 的,初始化的全局变量和静态变量在一块区域, 未初始化的全局变量和未初始化的静态变量在相邻的另一块区域。程序结束后有系统释放。
- `文字常量区`—常量字符串就是放在这里的。程序结束后由系统释放。
- `程序代码区`—存放函数体的二进制代码

#### 怎么保证多人开发进行内存泄露的检查

- 使用Analyze进行代码静态分析
- 为避免不必要的麻烦，多人开发时尽量使用ARC
- 使用leaks 进行内存泄漏检测
- 使用一些三方工具

#### block在ARC中和MRC中的用法有什么区别,需要注意什么

- 对于没有引用外部变量的Block，无论在ARC还是非ARC下，类型都是 **NSGlobalBlock**，这种类型的block可以理解成一种全局的block，不需要考虑作用域问题。同时，对他进行Copy或者Retain操作也是无效的
- 都需要应注意避免循环引用，ARC 下使用__weak 来解决，MRC下使用__Block 来解决

#### 非OC对象如何管理内存

- 非OC对象，需要手动执行释放操作（比如CGImageRelease(ref)），否则会造成大量的内存泄漏导致程序崩溃
- 对于CoreFoundation框架下的某些对象或变量需要手动释放、C语言代码中的malloc等需要对应free

#### CADisplayLink、NSTimer会出现的问题,以及解决办法

- 问题：CADisplayLink、NSTimer都是基于 runloop 实现的。runloop 会对CADisplayLink、NSTimer进行强引用，CADisplayLink、NSTimer会对target产生强引用，如果target又对它们产生强引用，那么就会引发循环引用

- 解决方案

  - 使用block

    ```objective-c
    // 内部使用 WeakSelf,并在视图消失前,关闭定时器
    __weak __typeof(self)weakSelf = self;
    NSTimer * timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer");
    }];
    self.timer= timer;
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    ```

  - 使用代理对象（NSProxy）

    ```css
    @interface TimerProxy : NSProxy
    + (instancetype)proxyWithTarget:(id)target;
    @end
    
    /*
     - (void)viewDidLoad {
     [super viewDidLoad];
     self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:[MyProxy proxyWithTarget:self] selector:@selector(doSomething) userInfo:nil repeats:YES];
     }
     - (void)dealloc {
     if (_myTimer) {
     [_myTimer invalidate];
     }
     NSLog(@"MyViewController dealloc");
     }
     */
    @interface TimerProxy()
    @property (weak, readonly, nonatomic) id weakTarget;
    @end
    
    @implementation TimerProxy
    + (instancetype)proxyWithTarget:(id)target {
        return [[TimerProxy alloc] initWithTarget:target];
    }
    
    - (instancetype)initWithTarget:(id)target {
        _weakTarget = target;
        return self;
    }
    
    - (void)forwardInvocation:(NSInvocation *)invocation {
        SEL sel = [invocation selector];
        if (_weakTarget && [self.weakTarget respondsToSelector:sel]) {
            [invocation invokeWithTarget:self.weakTarget];
        }
    }
    
    - (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
        return [self.weakTarget methodSignatureForSelector:sel];
    }
    
    - (BOOL)respondsToSelector:(SEL)aSelector {
        return [self.weakTarget respondsToSelector:aSelector];
    }
    @end
    ```

  - 使用工厂方法返回一个timer

    ```css
    @interface TargetTimer : NSObject
    + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         target:(id)target
                                       selector:(SEL)selector
                                       userInfo:(id _Nullable)userInfo
                                        repeats:(BOOL)repeats;
    @end
    
    /*
     self.myTimer = [MyTimerTarget scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething) userInfo:nil repeats:YES];
     */
    
    #import "TargetTimer.h"
    
    @interface TargetTimer()
    @property (assign, nonatomic) SEL outSelector;
    @property (weak, nonatomic) id outTarget;
    @end
    
    @implementation TargetTimer
    + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         target:(id)target
                                       selector:(SEL)selector
                                       userInfo:(id _Nullable)userInfo
                                        repeats:(BOOL)repeats {
        TargetTimer *timerTarget = [[TargetTimer alloc] init];
        timerTarget.outTarget = target;
        timerTarget.outSelector = selector;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                          target:timerTarget
                                                        selector:@selector(timerSelector:)
                                                        userInfo:userInfo
                                                         repeats:repeats];
        return timer;
    }
    
    - (void)timerSelector:(NSTimer *)timer {
        if (self.outTarget && [self.outTarget respondsToSelector:self.outSelector]) {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.outTarget performSelector:self.outSelector
                                 withObject:timer.userInfo];
    #pragma clang diagnostic pop
        }
        else {
            [timer invalidate];
        }
    }
    @end
    ```

#### 什么是Tagged Pointer

- 从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储
- 在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值
- 使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中
- 当指针不够存储数据时，才会使用动态分配内存的方式来存储数据

#### copy和mutableCopy区别

| 数据类型 | copy       | mutableCopy |
| -------- | ---------- | ----------- |
| 不可变   | 浅拷贝     | 单层深拷贝  |
| 可变     | 单层深拷贝 | 单层深拷贝  |

#### 内存泄漏可能会出现的几种原因

第三方框架不当使用，block、delegate、NSTimer的循环引用，非OC对象内存处理，地图类处理，大次数循环内存暴涨
