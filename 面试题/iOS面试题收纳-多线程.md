[TOC]

#### 什么是多线程

- `多线程` 是指实现多个线程并发执行的技术，进而提升整体处理性能
- 同一时间CPU只能处理一条线程，多线程并发执行其实是 CPU 快速的在多条线程之间调度(切换)。如果 CPU 调度线程的时间足够快，就造成了多线程并发执行的假象
  - 主线程的栈区  空间大小为1M，非常非常宝贵
  - 子线程的栈区  空间大小为512K内存空间
- 优势
   充分发挥多核处理器的优势，将不同线程任务分配给不同的处理器，真正进入“并行计算”状态
- 弊端
   新线程会消耗内存空间和cpu时间，线程太多会降低系统运行性能

#### 同步和异步的区别

- 同步：在当前线程中执行任务，不具备开启新线程能力，会阻塞当前线程
- 异步：在新线程中执行任务，具备开启新线程的能力，不会阻塞当前线程

#### 并行和并发的区别

- 并行是指两个或者多个事件在同一时刻发生

- 并发是指两个或多个事件在同一时间间隔内发生

#### 进程和线程区别

- 进程：计算机中的程序关于某数据集合上的一次运行活动，是系统进行资源分配和调度的基本单位。通俗的讲就是正在运行的程序，负责程序的内存分配，每一个进程都有自己独立的虚拟内存空间
- 线程：线程是进程中一个独立执行的路径（控制单元），一个进程至少包含一条线程，即主线程。可以将耗时的执行路径（如网络请求）放在其他线程中执行
- 进程和线程的比较
  - 线程是 CPU 调度的最小单位
  - 进程是 系统 资源分配和调度的单位
  - 一个程序可以对应多个进程，一个进程中可有多个线程，但至少要有一条线程
  - 同一个进程内的线程共享进程资源

#### 线程间怎么通信

- 一个线程传递数据给另一个线程

  - ***NSThread*** 可以先将自己的当前线程对象注册到某个全局的对象中去，这样相互之间就可以获取对方的线程对象，然后就可以使用下面的方法进行线程间的通信了，由于主线程比较特殊，所以框架直接提供了在主线程执行的方法

    ```objective-c
    - (void)performSelectorOnMainThread:(SEL)aSelector withObject:(nullable id)arg waitUntilDone:(BOOL)wait;
    
    - (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait NS_AVAILABLE(10_5, 2_0);
    ```

- 在一个线程中执行完特定的任务后，转到另一个线程继续执行任务

  ```objc
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
  });
  ```

#### iOS中常见的多线程方案

| 技术方案    | 简介                                                         | 语言 | 线程生命周期 | 使用频率 |
| :---------- | :----------------------------------------------------------- | :--- | :----------- | :------- |
| pthread     | 1. 一套通用的多线程API 2. 适用于Unix/Linux/Windows等系统  3. 跨平台、可移植 4. 使用难度大 | C    | 程序员管理   | 几乎不用 |
| NSThread    | 1. 使用更加面向对象  2. 简单易用，可直接操作线程对象         | OC   | 程序员管理   | 偶尔使用 |
| GCD         | 1. 旨在代替NSThread等线程技术 2. 充分利用设备的多核          | C    | 自动管理     | 经常使用 |
| NSOperation | 1. 基于GCD(底层是GCD) 2. 比GCD多了一些简单使用的功能 3. 使用更加面向对象 | OC   | 自动管理     | 经常使用 |

#### 什么是GCD

`GCD(Grand Central Dispatch)`，又叫做大中央调度，它对线程操作进行了封装，加入了很多新的特性，内部进行了效率优化，提供了简洁的`C语言接口`，使用更加高效，也是苹果推荐的使用方式

#### GCD 的队列类型

GCD的队列可以分为2大类型

- 并发队列（`Concurrent Dispatch Queue`）
  - 可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
  - 并发功能只有在异步（`dispatch_async`）函数下才有效
- 串行队列（`Serial Dispatch Queue`）也包括主队列
  - 让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）,按照FIFO顺序执行.

#### 什么是同步和异步任务派发(synchronous和asynchronous)

GCD多线程经常会使用 `dispatch_sync`和`dispatch_async`函数向指定队列添加任务，分别是`同步和异步`

- 同步指阻塞当前线程，要等待添加的耗时任务块Block完成后，函数才能返回，后面的代码才能继续执行
- 异步指将任务添加到队列后，函数立即返回，后面的代码不用等待添加的任务完成后即可执行，异步提交无法确定任务执行顺序

#### 组合队列执行表

|      | 并发队列                     | 手动创建串行队列            | 主队列                       |
| :--- | :--------------------------- | :-------------------------- | :--------------------------- |
| 同步 | 没有开启新线程  串行执行任务 | 没有开启新线程 串行执行任务 | 没有开启新线程  串行执行任务 |
| 异步 | 开启新线程  并行执行任务     | 开启新线程  串行执行任务    | 没有开启新线程  串行执行任务 |

#### GCD的线程锁

```objective-c
- (void)interview01 {
    // 会发生死锁
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
  	//输出 任务1 后卡死
  
    //dispatch_sync将任务添加到队列之后，会阻塞当前线程，然后在对应线程执行
    //但是这次添加到的是主队列，而主队列的任务在主线程执行，此时dispatch_sync阻塞了当前线程（主线程）,而又需要在主线程执行block中的任务
		//最终造成了死锁
}

- (void)interview02{
    // 不会发生死锁
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"任务2");
    });
    NSLog(@"任务3");
   //输出任务1 任务3 任务2
  
   // dispatch_asyn将任务添加到队列之后，不会阻塞当前线程
   // 它会等当前线程执行完毕时，再从队列里取出任务，放到对应的队列执行
   // 所以这里会输出任务1 任务3 任务2
}

- (void)interview03{
    // 会产生死锁
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_queue_create("muqueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"任务2");
        dispatch_sync(queue, ^{  //死锁
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
   // 输出 任务1 任务5 任务2 后卡死
  
   //这里和interview01类似
   //任务2添加到队列异步执行，会单独开一条线程执行任务，但是任务3添加进入之后，会阻塞住这条线程
   //而它的任务又需要在这条线程执行，从而造成了死锁
}

- (void)interview04 {
    // 不会产生死锁
    NSLog(@"任务1");
    dispatch_queue_t queue = dispatch_queue_create("muqueue", DISPATCH_QUEUE_SERIAL); 
    dispatch_queue_t queue2 = dispatch_queue_create("muqueue2", DISPATCH_QUEUE_SERIAL); 
    dispatch_async(queue, ^{
        NSLog(@"任务2");
        dispatch_sync(queue2, ^{  //死锁
            NSLog(@"任务3");
        });
        NSLog(@"任务4");
    });
    NSLog(@"任务5");
    // 输出 任务1 任务5 任务2 任务3 任务4
    //不会产生死锁   因为两个任务不在同一个队列之中， 所以不存在互相等待的问题。
}

- (void)interview05 {
    // 不会产生死锁
    NSLog(@"任务1 thread：%@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("muqueue2", DISPATCH_QUEUE_CONCURRENT); // 并发;
    dispatch_async(queue, ^{
        NSLog(@"任务2 thread：%@",[NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"任务3 thread：%@",[NSThread currentThread]);
        });
        NSLog(@"任务4 thread：%@",[NSThread currentThread]);
    });
    NSLog(@"任务5 thread：%@",[NSThread currentThread]);
    /*
    任务1 thread：<NSThread: 0x600000ce5740>{number = 1, name = main}
		任务5 thread：<NSThread: 0x600000ce5740>{number = 1, name = main}
		任务2 thread：<NSThread: 0x600000c864c0>{number = 6, name = (null)}
		任务3 thread：<NSThread: 0x600000c864c0>{number = 6, name = (null)}
		任务4 thread：<NSThread: 0x600000c864c0>{number = 6, name = (null)}
    */
    //不会产生死锁   因为两个任务不在同一个队列之中， 所以不存在互相等待的问题。
}
```

#### dispatch_after使用

通过该函数可以让提交的任务在指定时间后提交

```css
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"10秒后开始执行")
});
```

#### dispatch_group_t (组调度)的使用

组调度可以实现等待一组操都作完成后执行后续任务

```css
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//请求1});
dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//请求2});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //界面刷新
    NSLog(@"任务均完成，刷新界面");
});
```

```css
dispatch_group_t group = dispatch_group_create();
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_enter(group);
dispatch_async(queue, ^{
    //do something
    dispatch_group_leave(group);
});

dispatch_group_enter(group);
dispatch_async(queue, ^{
    //do something
    dispatch_group_leave(group);
});

dispatch_group_notify(group, queue, ^{
    //do something
});
```

#### dispatch_semaphore (信号量)如何使用

- 用于控制最大并发数
- 可以防止资源抢夺

```css
dispatch_semaphore_create  // 创建最大并发数
dispatch_semaphore_wait    // -1 开始执行 (0则等待)
dispatch_semaphore_signal  // +1 
```

```css
//crate的value表示，最多几个资源可访问
dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);   
dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

//任务1
dispatch_async(quene, ^{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"run task 1");
    sleep(1);
    NSLog(@"complete task 1");
    dispatch_semaphore_signal(semaphore);       
});
//任务2
dispatch_async(quene, ^{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"run task 2");
    sleep(1);
    NSLog(@"complete task 2");
    dispatch_semaphore_signal(semaphore);       
});
//任务3
dispatch_async(quene, ^{
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"run task 3");
    sleep(1);
    NSLog(@"complete task 3");
    dispatch_semaphore_signal(semaphore);       
});   
```



#### dispatch_barrier_(a)sync使用

- 一个dispatch barrier 允许在一个并发队列中创建一个同步点。当在并发队列中遇到一个barrier，它会延迟执行barrier的block，等待所有在barrier之前提交的blocks执行结束。这时barrier block自己开始执行。 之后， 队列继续正常的执行操作

  ```css
  dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
  dispatch_async(queue, ^{
      // dosth1;
  });
  dispatch_async(queue, ^{
      // dosth2;
  });
  dispatch_barrier_async(queue, ^{
      // doBarrier;
  });
  dispatch_async(queue, ^{
      // dosth4;
  });
  dispatch_async(queue, ^{
      // dosth5;
  });
  ```

#### dispatch_set_target_queue 使用

`dispatch_set_target_queue(dispatch_object_t object, dispatch_queue_t queue);`

dispatch_set_target_queue 函数有两个作用：第一，变更队列的执行优先级；第二，目标队列可以成为原队列的执行阶层

- 第一个参数是要执行变更的队列（不能指定主队列和全局队列）
- 第二个参数是目标队列（指定全局队列）

#### GCD如何取消线程

GCD目前有两种方式可以取消线程:

- `dispatch_block_cancel`可以取消还未执行的线程。但是没办法取消一个正在执行的线程

```css
dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
dispatch_block_t block1 = dispatch_block_create(0, ^{
    NSLog(@"block1");
});
dispatch_block_t block2 = dispatch_block_create(0, ^{
    NSLog(@"block2");
});
dispatch_block_t block3 = dispatch_block_create(0, ^{
    NSLog(@"block3");
});
    
dispatch_async(queue, block1);
dispatch_async(queue, block2);
dispatch_async(queue, block3);
dispatch_block_cancel(block3); // 取消 block3
```

- 使用`临时变量+return` 方式取消 正在执行的Block

```css
__block BOOL gcdFlag= NO; // 临时变量
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    for (long i=0; i<1000; i++) {
        NSLog(@"正在执行第i次:%ld",i);
        sleep(1);
        if (gcdFlag==YES) { // 判断并终止
            NSLog(@"终止");
            return ;
        }
    };
});
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{NSLog(@"我要停止啦");gcdFlag = YES;});
```

#### 说一下 OperationQueue 和 GCD 的区别，以及各自的优势

- GCD是纯C语⾔言的API，NSOperationQueue是基于GCD的OC版本封装
- GCD只支持FIFO的队列，NSOperationQueue可以很⽅便地调整执⾏顺序、设置最⼤大并发数量
- NSOperationQueue可以在轻松在Operation间设置依赖关系，而GCD 需要写很多的代码才能实现
- NSOperationQueue支持KVO，可以监测operation是否正在执⾏ (isExecuted)、 是否结束(isFinished)，是否取消(isCanceld)
- GCD的执行速度比NSOperationQueue快
- 任务之间不太互相依赖使用GCD，任务之间有依赖或者要监听任务的执⾏情况使用NSOperationQueue

#### NSOperation如何实现操作依赖

通过任务间添加依赖，可以为任务设置执行的先后顺序

```css
NSOperationQueue *queue=[[NSOperationQueue alloc] init];
//创建操作
NSBlockOperation *operation1=[NSBlockOperation blockOperationWithBlock:^(){
    NSLog(@"执行第1次操作，线程：%@",[NSThread currentThread]);
}];
NSBlockOperation *operation2=[NSBlockOperation blockOperationWithBlock:^(){
    NSLog(@"执行第2次操作，线程：%@",[NSThread currentThread]);
}];
NSBlockOperation *operation3=[NSBlockOperation blockOperationWithBlock:^(){
    NSLog(@"执行第3次操作，线程：%@",[NSThread currentThread]);
}];
//添加依赖
[operation1 addDependency:operation2];
[operation2 addDependency:operation3];
//将操作添加到队列中去
[queue addOperation:operation1];
[queue addOperation:operation2];
[queue addOperation:operation3];
```

#### 是否可以把比较耗时的操作放在 NSNotification中

- 如果在异步线程发的通知，那么可以执行比较耗时的操作
- 如果在主线程发的通知，那么就不可以执行比较耗时的操作

#### NSOperation取消线程方式

- 通过 cancel 取消未执行的单个操作

```objectivec
NSOperationQueue *queue1 = [[NSOperationQueue alloc]init];
NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"block11");
}];
NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"block22");
}];
NSBlockOperation *block3 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"block33");
}];
[block3 cancel];
[queue1 addOperations:@[block1,block2,block3] waitUntilFinished:YES];
```

- 移除队列里面所有的操作，但正在执行的操作无法移除

```csharp
[queue1 cancelAllOperations];
```

- 挂起队列，使队列任务不再执行，但正在执行的操作无法挂起

```objectivec
queue1.suspended = YES;
```

- 我们可以自定义NSOperation，实现取消正在执行的操作。其实就是拦截main方法。

```css
 main方法：
 1、任何操作在执行时，首先会调用start方法，start方法会更新操作的状态（过滤操作,如过滤掉处于“取消”状态的操作）。
 2、经start方法过滤后，只有正常可执行的操作，就会调用main方法。
 3、重写操作的入口方法(main)，就可以在这个方法里面指定操作执行的任务。
 4、main方法默认是在子线程异步执行的。
```

#### 什么是线程安全

- 一块资源可能会被多个线程共享，也就是多个线程可能会访问同一块资源
- 比如多个线程访问同一个对象、同一个变量、同一个文件
- 当多个线程访问同一块资源时，很容易引发数据错乱和数据安全问题

#### 如何理解GCD死锁

- 所谓死锁.通常是指2个操作相互等待对方完成，造成死循环，于是2个操作都无法进行，就产生了死锁

#### 自旋锁和互斥锁的是什么

- 自旋锁会忙等：所谓忙等，即在访问被锁资源时，调用者线程不会休眠，而是不停循环在那里，直到被锁资源释放锁
- 互斥锁会休眠：所谓休眠，即在访问被锁资源时，调用者线程会休眠，此时cpu可以调度其他线程工作。直到被锁资源释放锁，此时会唤醒休眠线程

#### 多线程安全隐患的解决方案

- 隐患造成原因：多个线程同时访问一个数据然后对数据进行操作
- 解决方案：使用线程同步技术
- 常见线程同步技术： 加锁
- iOS线程同步方案：
  - OSSpinLock			 ios10 废弃
  - os_unfair_lock        ios10 开始
  - pthread_mutex     跨平台的锁，使用步骤复杂，不建议
  - dispatch_semaphore    建议使用,性能也比较好
  - dispatch_queue(DISPATCH_QUEUE_SERIAL)   串行队列
  - NSLock                           对 mutex 封装
  - NSRecursiveLock         递归锁，用于多层嵌套的锁
  - NSCondition
  - NSConditionLock
  - @synchronized          性能最差

#### 自旋锁和互斥锁对比

- 什么情况使用自旋锁比较划算？
  - 预计线程等待锁的时间很短
  - 加锁的代码（临界区）经常被调用，但竞争情况很少发生
  - CPU资源不紧张
  - 多核处理器

- 什么情况使用互斥锁比较划算？
  - 预计线程等待锁的时间较长
  - 单核处理器
  - 临界区有IO操作
  - 临界区代码复杂或者循环量大
  - 临界区竞争非常激烈   

#### AF中常驻线程的实现

- 使用单例创建线程，添加到runloop中，且加了一个NSMachPort来防止这个新建的线程由于没有活动直接退出【 使用MachPort配合RunLoop进行线程保活】
- AF3.x为什么不再需要常驻线程？
  - NSURLConnection的一大痛点就是：发起请求后，这条线程并不能随风而去，而需要一直处于等待回调的状态
  - NSURLSession发起的请求，不再需要在当前线程进行代理方法的回调。可以指定回调的delegateQueue，这样我们就不用为了等待代理回调方法而苦苦保活线程了
  - 同时还要注意一下，指定的用于接收回调的Queue的maxConcurrentOperationCount设为了1，这里目的是想要让并发的请求串行的进行回调

- 为什么AF3.0中需要设置self.operationQueue.maxConcurrentOperationCount = 1;而AF2.0却不需要？
  - AF3.0的operationQueue是用来接收NSURLSessionDelegate回调的，鉴于一些多线程数据访问的安全性考虑，设置了maxConcurrentOperationCount = 1来达到串行回调的效果
  -  AF2.0的operationQueue是用来添加operation并进行并发请求的，所以不要设置为1
