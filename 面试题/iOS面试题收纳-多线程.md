[TOC]

#### 什么是多线程

- `多线程` 是指实现多个线程并发执行的技术，进而提升整体处理性能

- 同一时间CPU只能处理一条线程，多线程并发执行其实是 CPU 快速的在多条线程之间调度(切换)。如果 CPU 调度线程的时间足够快，就造成了多线程并发执行的假象
  - 主线程的栈区  空间大小为1M，非常非常宝贵
  - 子线程的栈区  空间大小为512K内存空间
  
- 优势
   充分发挥多核处理器的优势，将不同线程任务分配给不同的处理器，真正进入“并行计算”状态
   
- 弊端

   创建线程是有开销的，iOS下主要成本包括：内核数据结构（大约1KB）、栈空间（子线程512KB、主线程1MB） 也可以使用-setStackSize设置，但必须是4K的倍数，而且最小为16K，创建线程大约需要90毫秒的创建时间；开启大量的线程，会降低程序的性能；线程越多，CPU在调度线程上的开销越大，程序设计更加复杂：比如线程之间的通信、多线程的数据共享

#### 什么是信号量，和线程有什么区别

- 就是一种可用来控制访问资源的数量的标识，设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量数量来执行多个线程

#### 信号量和互斥锁的区别

- 信号量与互斥锁的主要不同在于”灯”的概念，灯亮则意味着资源可用，灯灭则意味着不可用

- 信号量除了灯亮/灯灭这种二元灯以外，还采用大于1的灯数，以表示资源数大于1，这时可以称之为多元灯

- 而互斥锁只能是灯亮/灯灭这种二元灯，用于表明资源是可用，还是不可用

  - **互斥量用于线程的互斥，信号量用于线程的同步**
  - 这是互斥量和信号量的根本区别，也就是互斥和同步之间的区别
    - 互斥：是指某一资源同时只允许一个访问者对其进行访问，具有唯一性和排它性。但互斥无法限制访问者对资源的访问顺序，即访问是无序的
    - 同步：是指在互斥的基础上（大多数情况），通过其它机制实现访问者对资源的有序访问。在大多数情况下，同步已经实现了互斥，特别是所有写入资源的情况必定是互斥的。少数情况是指可以允许多个访问者同时访问资源

  - **互斥量值只能为0/1，信号量值可以为非负整数**

    也就是说，一个互斥量只能用于一个资源的互斥访问，它不能实现多个资源的多线程互斥问题。信号量可以实现多个同类资源的多线程互斥和同步。当信号量为单值信号量时，也可以完成一个资源的互斥访问

  - **互斥量的加锁和解锁必须由同一线程分别对应使用，信号量可以由一个线程释放，另一个线程得到**

#### 什么是任务

- 就是执行操作的意思，也就是在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）

- **同步(Sync)**：同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行，即会阻塞线程。只能在当前线程中执行任务(是当前线程，不一定是主线程)，不具备开启新线程的能力。

  **异步(Async)**：线程会立即返回，无需等待就会继续执行下面的任务，不阻塞当前线程。可以在新的线程中执行任务，具备开启新线程的能力(并不一定开启新线程)。如果不是添加到主队列上，异步会在子线程中执行任务

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

#### 多进程与多线程

多进程：打开mac的活动监视器，可以看到很多个进程同时运行

- 进程是程序在计算机上的一次执行活动。当你运行一个程序，你就启动了一个进程。显然，程序是死的(静态的)，进程是活的(动态的)。
- 进程可以分为系统进程和用户进程。凡是用于完成操作系统的各种功能的进程就是系统进程，它们就是处于运行状态下的操作系统本身;所有由用户启动的进程都是用户进程。进程是操作系统进行资源分配的单位。
- 进程又被细化为线程，也就是一个进程下有多个能独立运行的更小的单位。在同一个时间里，同一个计算机系统中如果允许两个或两个以上的进程处于运行状态，这便是多进程。

多线程：

- 1.同一时间，CPU只能处理1条线程，只有1条线程在执行。多线程并发执行，其实是CPU快速地在多条线程之间调度（切换）。如果CPU调度线程的时间足够快，就造成了多线程并发执行的假象
- 2.如果线程非常非常多，CPU会在N多线程之间调度，消耗大量的CPU资源，每条线程被调度执行的频次会降低（线程的执行效率降低）
- 3.多线程的优点:
   能适当提高程序的执行效率
   能适当提高资源利用率（CPU、内存利用率）
- 4.多线程的缺点:
   开启线程需要占用一定的内存空间（默认情况下，主线程占用1M，子线程占用512KB），如果开启大量的线程，会占用大量的内存空间，降低程序的性能
   线程越多，CPU在调度线程上的开销就越大
   程序设计更加复杂：比如线程之间的通信、多线程的数据共享

#### 多进程间怎么通信

进程间通信（**IPC**，InterProcess Communication）是指在不同进程之间传播或交换信息。

IPC的方式通常有管道（包括无名管道和命名管道）、消息队列、信号量、共享存储、Socket、Streams等。其中 Socket和Streams支持不同主机上的两个进程IPC

1.管道：速度慢，容量有限，只有父子进程能通讯   

2.FIFO：任何进程间都能通讯，但速度慢   

3.消息队列：容量受到系统限制，且要注意第一次读的时候，要考虑上一次没有读完数据的问题   

4.信号量：不能传递复杂消息，只能用来同步   

5.共享内存区：能够很容易控制容量，速度快，但要保持同步，比如一个进程在写的时候，另一个进程要注意读写的问题，相当于线程中的线程安全，当然，共享内存区同样可以用作线程间通讯，不过没这个必要，线程间本来就已经共享了同一进程内的一块内存

#### iOS中进程间通信

iOS系统是相对封闭的系统，App各自在各自的沙盒（sandbox）中运行，每个App都只能读取iPhone上iOS系统为该应用程序程序创建的文件夹AppData下的内容，不能随意跨越自己的沙盒去访问别的App沙盒中的内容,所以iOS 的系统中进行App间通信的方式也比较固定，常见的app间通信方式以及使用场景总结如下

1. **URL Scheme**是 iOS app通信最常用到的通信方式，App1通过openURL的方法跳转到App2，并且在URL中带上想要的参数，有点类似http的get请求那样进行参数传递

2. **Keychain** iOS系统的Keychain是一个安全的存储容器，它本质上就是一个sqllite数据库，它的位置存储在/private/var/Keychains/keychain-2.db，不过它所保存的所有数据都是经过加密的，可以用来为不同的app保存敏感信息

3. **UIPasteboard**是剪切板功能，因为iOS的原生控件UITextView，UITextField 、UIWebView

4. **UIDocumentInteractionController**主要是用来实现同设备上app之间的共享文档，以及文档预览、打印、发邮件和复制等功能。它的使用非常简单.

   首先通过调用它唯一的类方法 interactionControllerWithURL:，并传入一个URL(NSURL)，为你想要共享的文件来初始化一个实例对象。然后UIDocumentInteractionControllerDelegate，然后显示菜单和预览窗口

5. **LocalSocket** 原理很简单，一个App1在本地的端口port1234进行TCP的bind和listen，另外一个App2在同一个端口port1234发起TCP的connect连接，这样就可以建立正常的TCP连接，进行TCP通信了，那么就想传什么数据就可以传什么数据了

6. **AirDrop** 通过AirDrop实现不同设备的App之间文档和数据的分享

7. **UIActivityViewController** iOS SDK中封装好的类在App之间发送数据、分享数据和操作数据

8. **App Group** 用于同一个开发团队开发的App之间，包括App和Extension之间共享同一份读写空间，进行数据共享。同一个团队开发的多个应用之间如果能直接数据共享，大大提高用户体验

#### 多线程间怎么通信

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

**NSThread：轻量级别的多线程技术**

是我们自己手动开辟的子线程，如果使用的是初始化方式就需要我们自己启动，如果使用的是构造器方式它就会自动启动。只要是我们手动开辟的线程，都需要我们自己管理该线程，不只是启动，还有该线程使用完毕后的资源回收

```objectivec
  NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testThread:) object:@"我是参数"];
    // 当使用初始化方法出来的主线程需要start启动
    [thread start];
    // 可以为开辟的子线程起名字
    thread.name = @"NSThread线程";
    // 调整Thread的权限 线程权限的范围值为0 ~ 1 。越大权限越高，先执行的概率就会越高，由于是概率，所以并不能很准确的的实现我们想要的执行顺序，默认值是0.5
    thread.threadPriority = 1;
    // 取消当前已经启动的线程
    [thread cancel];
    // 通过遍历构造器开辟子线程
    [NSThread detachNewThreadSelector:@selector(testThread:) toTarget:self withObject:@"构造器方式"];
```

- performSelector...只要是NSObject的子类或者对象都可以通过调用方法进入子线程和主线程，其实这些方法所开辟的子线程也是NSThread的另一种体现方式。
   在编译阶段并不会去检查方法是否有效存在，如果不存在只会给出警告

```objectivec
    //在当前线程。延迟1s执行。响应了OC语言的动态性:延迟到运行时才绑定方法
        [self performSelector:@selector(aaa) withObject:nil afterDelay:1];
      // 回到主线程。waitUntilDone:是否将该回调方法执行完在执行后面的代码，如果为YES:就必须等回调方法执行完成之后才能执行后面的代码，说白了就是阻塞当前的线程；如果是NO：就是不等回调方法结束，不会阻塞当前线程
        [self performSelectorOnMainThread:@selector(aaa) withObject:nil waitUntilDone:YES];
      //开辟子线程
        [self performSelectorInBackground:@selector(aaa) withObject:nil];
      //在指定线程执行
        [self performSelector:@selector(aaa) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES]
```

需要注意的是：如果是带afterDelay的延时函数，会在内部创建一个 NSTimer，然后添加到当前线程的Runloop中。也就是如果当前线程没有开启runloop，该方法会失效。在子线程中，需要启动runloop(注意调用顺序)

```objectivec
[self performSelector:@selector(aaa) withObject:nil afterDelay:1];
[[NSRunLoop currentRunLoop] run];
```

而performSelector:withObject:只是一个单纯的消息发送，和时间没有一点关系。所以不需要添加到子线程的Runloop中也能执行

#### 什么是GCD

`GCD(Grand Central Dispatch)`，又叫做大中央调度，它对线程操作进行了封装，加入了很多新的特性，内部进行了效率优化，提供了简洁的`C语言接口`，使用更加高效，也是苹果推荐的使用方式

#### 什么是队列

队列（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务
 在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。

- 串行队列（Serial Dispatch Queue）：
   同一时间内，队列中只能执行一个任务，只有当前的任务执行完成之后，才能执行下一个任务。（只开启一个线程，一个任务执行完毕后，再执行下一个任务）。按照FIFO顺序执行，对于每一个不同的串行队列，系统会为这个队列建立唯一的线程来执行代码。主队列是主线程上的一个串行队列,是系统自动为我们创建的。
- 并发队列（Concurrent Dispatch Queue）：
   同时允许多个任务并发执行。（可以开启多个线程，并且同时执行任务）。并发队列的并发功能只有在异步（dispatch_async）函数下才有效。可以让多个任务按照FIFO的顺序**开始**执行，注意是***开始\***，但是它们的执行结束时间是不确定的，取决于每个任务的耗时。对于n个并发队列，GCD不会创建对应的n个线程而是进行适当的优化

#### GCD中的队列

GCD共有三种队列类型：

- main queue：通过dispatch_get_main_queue()获得，这是一个与主线程相关的串行队列
- global queue：全局队列是并发队列，由整个进程共享。存在着高、中、低三种优先级的全局队列。调用dispath_get_global_queue并传入优先级来访问队列
- 自定义队列：通过函数dispatch_queue_create创建的队列

#### 同步、异步、并发、串行

- 同步和异步主要影响：能不能开启新的线程
  - 同步：在当前线程中执行任务，不具备开启新线程的能力
  - 异步：在新的线程中执行任务，具备开启新线程的能力

- 并发和串行主要影响：任务的执行方式
  - 并发：多个任务并发（同时）执行
  - 串行：一个任务执行完毕后，再执行下一个任务

#### 什么是同步和异步任务派发(synchronous和asynchronous)

GCD多线程经常会使用 `dispatch_sync`和`dispatch_async`函数向指定队列添加任务，分别是`同步和异步`

- 同步指阻塞当前线程，要等待添加的耗时任务块Block完成后，函数才能返回，后面的代码才能继续执行
- 异步指将任务添加到队列后，函数立即返回，后面的代码不用等待添加的任务完成后即可执行，异步提交无法确定任务执行顺序

#### 组合队列执行表

|      | 并发队列                     | 手动创建串行队列            | 主队列                       |
| :--- | :--------------------------- | :-------------------------- | :--------------------------- |
| 同步 | 没有开启新线程  串行执行任务 | 没有开启新线程 串行执行任务 | 没有开启新线程  串行执行任务 |
| 异步 | 开启新线程  并行执行任务     | 开启新线程  串行执行任务    | 没有开启新线程  串行执行任务 |

只要是同步函数或者是主队列，就不会开启线程，并且串行执行

**使用sync函数往当前串行队列中添加任务，会卡住当前的串行队列（产生死锁）**

#### 如何去理解GCD执行原理？

- GCD有一个底层线程池，这个池中存放的是一个个的线程。之所以称为“池”，很容易理解出这个“池”中的线程是可以重用的，当一段时间后这个线程没有被调用胡话，这个线程就会被销毁。注意：开多少条线程是由底层线程池决定的（线程建议控制再3~5条），池是系统自动来维护，不需要我们程序员来维护（看到这句话是不是很开心？） 而我们程序员需要关心的是什么呢？我们只关心的是向队列中添加任务，队列调度即可。
- 如果队列中存放的是同步任务，则任务出队后，底层线程池中会提供一条线程供这个任务执行，任务执行完毕后这条线程再回到线程池。这样队列中的任务反复调度，因为是同步的，所以当我们用currentThread打印的时候，就是同一条线程。
- 如果队列中存放的是异步的任务，（注意异步可以开线程），当任务出队后，底层线程池会提供一个线程供任务执行，因为是异步执行，队列中的任务不需等待当前任务执行完毕就可以调度下一个任务，这时底层线程池中会再次提供一个线程供第二个任务执行，执行完毕后再回到底层线程池中。
- 这样就对线程完成一个复用，而不需要每一个任务执行都开启新的线程，也就从而节约的系统的开销，提高了效率。在iOS7.0的时候，使用GCD系统通常只能开58条线程，iOS8.0以后，系统可以开启很多条线程，但是实在开发应用中，建议开启线程条数：3~5条最为合理

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

dispatch_after能让我们添加进队列的任务延时执行，该函数并不是在指定时间后执行处理，而只是在指定时间追加处理到dispatch_queue

```css
//第一个参数是time，第二个参数是dispatch_queue，第三个参数是要执行的block
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSLog(@"dispatch_after");
});
```

由于其内部使用的是dispatch_time_t管理时间，而不是NSTimer。
 所以如果在子线程中调用，相比performSelector:afterDelay,不用关心runloop是否开启

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
- 保持线程同步，将异步执行任务转换为同步执行任务
- 保证线程安全，为线程加锁

```css
dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量**
dispatch_semaphore_signal：发送一个信号，让信号总量加1**
dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行
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

保持线程同步：

```objectivec
dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
__block NSInteger number = 0;
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    number = 100;
    dispatch_semaphore_signal(semaphore);
});

dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
NSLog(@"semaphore---end,number = %zd",number);
```

dispatch_semaphore_wait加锁阻塞了当前线程，dispatch_semaphore_signal解锁后当前线程继续执行

保证线程安全，为线程加锁

在线程安全中可以将dispatch_semaphore_wait看作加锁，而dispatch_semaphore_signal看作解锁
 首先创建全局变量

```undefined
 _semaphore = dispatch_semaphore_create(1);
```

注意到这里的初始化信号量是1

```objectivec
- (void)asyncTask {
  dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
  count++;
  sleep(1);
  NSLog(@"执行任务:%zd",count);
  dispatch_semaphore_signal(_semaphore);
}
```

异步并发调用asyncTask

```objectivec
for (NSInteger i = 0; i < 100; i++) {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self asyncTask];
    });
}
```

然后发现打印是从任务1顺序执行到100，没有发生两个任务同时执行的情况。

原因如下:
 在子线程中并发执行asyncTask，那么第一个添加到并发队列里的，会将信号量减1，此时信号量等于0，可以执行接下来的任务。而并发队列中其他任务，由于此时信号量不等于0，必须等当前正在执行的任务执行完毕后调用dispatch_semaphore_signal将信号量加1，才可以继续执行接下来的任务，以此类推，从而达到线程加锁的目的

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

#### 使用dispatch_once实现单例

```objectivec
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
```

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

-  GCD是面向底层的C语言的API，NSOpertaionQueue用GCD构建封装的，是GCD的高级抽象
- GCD执行效率更高，而且由于队列中执行的是由block构成的任务，这是一个轻量级的数据结构，写起来更方便
- GCD只支持FIFO的队列，而NSOperationQueue可以通过设置最大并发数，设置优先级，添加依赖关系等调整执行顺序
- NSOperationQueue甚至可以跨队列设置依赖关系，但是GCD只能通过设置串行队列，或者在队列内添加barrier(dispatch_barrier_async)任务，才能控制执行顺序,较为复杂
- NSOperationQueue因为面向对象，所以支持KVO，可以监测operation是否正在执行（isExecuted）、是否结束（isFinished）、是否取消（isCanceld）
  - 实际项目开发中，很多时候只是会用到异步操作，不会有特别复杂的线程关系管理，所以苹果推崇的且优化完善、运行快速的GCD是首选
  - 如果考虑异步操作之间的事务性，顺序行，依赖关系，比如多线程并发下载，GCD需要自己写更多的代码来实现，而NSOperationQueue已经内建了这些支持
  - 不论是GCD还是NSOperationQueue，我们接触的都是任务和队列，都没有直接接触到线程，事实上线程管理也的确不需要我们操心，系统对于线程的创建，调度管理和释放都做得很好。而NSThread需要我们自己去管理线程的生命周期，还要考虑线程同步、加锁问题，造成一些性能上的开销

#### NSOperation和NSOperationQueue

- **操作（Operation）：**

  执行操作的意思，换句话说就是你在线程中执行的那段代码。
   在 GCD 中是放在 block 中的。在 NSOperation 中，使用 NSOperation 子类 NSInvocationOperation、NSBlockOperation，或者自定义子类来封装操作。

- **操作队列（Operation Queues）：**

  这里的队列指操作队列，即用来存放操作的队列。不同于 GCD 中的调度队列 FIFO（先进先出）的原则。NSOperationQueue 对于添加到队列中的操作，首先进入准备就绪的状态（就绪状态取决于操作之间的依赖关系），然后进入就绪状态的操作的开始执行顺序（非结束执行顺序）由操作之间相对的优先级决定（优先级是操作对象自身的属性）。

  操作队列通过设置最大并发操作数（maxConcurrentOperationCount）来控制并发、串行。

  NSOperationQueue 为我们提供了两种不同类型的队列：主队列和自定义队列。主队列运行在主线程之上，而自定义队列在后台执行

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
- 在并发执行的环境中，对于共享数据通过同步机制保证各个线程都可以正确的执行，不会出现数据污染的情况，或者对于某个资源，在被多个线程访问时，不管运行时执行这些线程有什么样的顺序或者交错，不会出现错误的行为，就认为这个资源是线程安全的，一般来说，对于某个资源如果只有读操作，则这个资源无需同步就是线程安全的，若有多个线程进行读写操作，则需要线程同步来保证线程安全

**一个比较常见的死锁例子:主队列同步**

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
       
        NSLog(@"deallock");
    });
    // Do any additional setup after loading the view, typically from a nib.
}
```

在主线程中运用主队列同步，也就是把任务放到了主线程的队列中。
 同步对于任务是立刻执行的，那么当把任务放进主队列时，它就会立马执行,只有执行完这个任务，viewDidLoad才会继续向下执行。
 而viewDidLoad和任务都是在主队列上的，由于队列的先进先出原则，任务又需等待viewDidLoad执行完毕后才能继续执行，viewDidLoad和这个任务就形成了相互循环等待，就造成了死锁。
 想避免这种死锁，可以将同步改成异步dispatch_async,或者将dispatch_get_main_queue换成其他串行或并行队列，都可以解决。

**同样，下边的代码也会造成死锁：**

```objectivec
dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);

dispatch_async(serialQueue, ^{
       
        dispatch_sync(serialQueue, ^{
            
            NSLog(@"deadlock");
        });
    });
```

外面的函数无论是同步还是异步都会造成死锁。
 这是因为里面的任务和外面的任务都在同一个serialQueue队列内，又是同步，这就和上边主队列同步的例子一样造成了死锁
 解决方法也和上边一样，将里面的同步改成异步dispatch_async,或者将serialQueue换成其他串行或并行队列，都可以解决

```objectivec
   dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t serialQueue2 = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
       
        dispatch_sync(serialQueue2, ^{
            
            NSLog(@"deadlock");
        });
    });
```

这样是不会死锁的,并且serialQueue和serialQueue2是在同一个线程中的

#### 如何理解GCD死锁

- 所谓死锁，通常指有两个线程T1和T2都卡住了，并等待对方完成某些操作。T1不能完成是因为它在等待T2完成。但T2也不能完成，因为它在等待T1完成。于是大家都完不成，就导致了死锁（DeadLock）

- 产生死锁的四个必要条件
	- 互斥条件：一个资源每次只能被一个进程使用
  - 请求保持条件：一个进程因请求资源而阻塞时，对已获得的资源保持不放
  - 不剥夺条件：进程已获得的资源，在未使用完之前，不能强行剥夺
  - 循环等待条件：若干进程之间形成一种头尾相接的循环等待资源关系

#### 自旋锁和互斥锁的区别是什么

- 自旋锁会忙等：所谓忙等，即在访问被锁资源时，调用者线程不会休眠，而是不停循环在那里，直到被锁资源释放锁。
  - atomic、OSSpinLock、dispatch_semaphore_t
- 互斥锁会休眠：所谓休眠，即在访问被锁资源时，调用者线程会休眠，此时cpu可以调度其他线程工作。直到被锁资源释放锁，此时会唤醒休眠线程
  - pthread_mutex、@ synchronized、NSLock、NSConditionLock 、NSCondition、NSRecursiveLock
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

#### 多线程安全隐患的解决方案

官方源码：https://github.com/apple/swift-corelibs-libdispatch

GNUStep：http://www.gnustep.org/resources/downloads.php

- 隐患造成原因：多个线程同时访问一个数据然后对数据进行操作

- 解决方案：使用线程同步技术

- 常见线程同步技术： 加锁

- iOS线程同步方案：
  - OSSpinLock			 ios10 废弃

    -  OSSpinLock叫做”自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源
    - 目前已经不再安全，可能会出现优先级反转问题

    - 如果等待锁的线程优先级较高，它会一直占用着CPU资源，优先级低的线程就无法释放锁
    - 需要导入头文件#import <libkern/OSAtomic.h>

    ```objc
    #import <libkern/OSAtomic.h>
    // 初始化
    OSSpinLock lock = OS_SPINLOCK_INIT;
    // 尝试加锁（如果需要等待就不加锁，直接返回false，如果不需要等待就加锁，返回true）
    bool result = OSSpinLockTry(&lock);
    // 加锁
    OSSpinLockLock(&lock);
    // 解锁
    OSSpinLockUnlock(&lock);
    ```

  - os_unfair_lock        ios10 开始

    - os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持

    - 从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等

    - 需要导入头文件#import <os/lock.h>

      ```objc
      #import <os/lock.h>
      // 初始化
      os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
      // 尝试加锁
      os_unfair_lock_trylock(&lock);
      // 加锁
      os_unfair_lock_lock(&lock);
      // 解锁
      os_unfair_lock_unlock(&lock);
      ```

  - pthread_mutex     跨平台的锁，使用步骤复杂，不建议

    - mutex叫做”互斥锁”，等待锁的线程会处于休眠状态

    - 需要导入头文件#import <pthread.h>

      ```objc
      #import <pthread.h>
      // 初始化锁的属性
      pthread_mutexattr_t attr;
      pthread_mutexattr_init(&attr);
      pthread_mutextattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
      //初始化锁
      pthread_mutex_t mutex;
      pthread_mutex_init(&mutex, &attr);
      // 尝试加锁
      pthread_mutex_trylock(&mutex);
      // 加锁
      pthread_mutex_lock(&mutext);
      //解锁
      pthread_mutext_unlock(&mutex);
      //销毁锁资源
      pthread_mutexattr_destroy(&attr);
      pthread_mutex_destroy(&mutext);
      ```

    - pthread_mutex 递归锁

      ```c
      // 递归锁：允许同一个线程对一把锁进行重复加锁
      // 初始化属性
      pthread_mutexattr_t attr;
      pthread_mutexattr_init(&attr);
      pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
      // 初始化锁
      pthread_mutex_init(mutex, &attr);
      // 销毁属性
      pthread_mutexattr_destroy(&attr);
      ```

    - pthread_mutex条件
  
      ```objc
      //初始化锁
      pthread_mutex_t mutex;
      // NULL 代表使用默认属性
      pthread_mutex_init(&mutex, NULL);
      // 初始化条件
      pthread_cond_t condition;
      pthread_cond_init(&condition, NULL);
      // 等待条件(进入休眠，放开mutex锁，被唤醒后，会再次对mutext加锁)
      pthread_cond_wait(&condition, &mutex);
      // 激活一个等待条件的线程
      pthread_cond_signal(&condition);
      // 激活所有等待条件的线程
      pthread_cond_boradcast(&conditioin);
      // 销毁资源
      pthread_mutex_destroy(&mutex);
      pthread_cond_destroy(&condition);
      ```

  - dispatch_semaphore    建议使用,性能也比较好

    - semaphore叫做”信号量”

    - 信号量的初始值，可以用来控制线程并发访问的最大数量

    - 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步
  
      ```
      // 信号量的初始值
      int value = 1;
      // 初始化信号量
      dispatch_semaphore_t semaphore = dispatch_semaphore_create(value);
      // 如果信号量<=0,当前线程就会进入休眠等待（直到信号量>0）
      // 如果信号量>0,就-1，然后往下执行后面的代码
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      // 让信号量的值+1
      dispatch_semaphore_signal(semaphore);
      ```

  - dispatch_queue(DISPATCH_QUEUE_SERIAL)   串行队列

    - 直接使用GCD的串行队列，也是可以实现线程同步的
  
      ```
      dispatch_queue_t queue = dispatch_queue_create("lock_queue", DISPATCH_QUEUE_SERIAL);
      dispatch_sync(queue, ^{});
      ```

  - NSLock                           对 mutex 封装

    - NSLock是对mutex普通锁的封装

  - NSRecursiveLock         递归锁，用于多层嵌套的锁

    - NSRecursiveLock也是对mutex递归锁的封装，API跟NSLock基本一致

  - NSCondition

    - NSCondition是对mutex和cond的封装

  - NSConditionLock

    - NSConditionLock是对NSCondition的进一步封装，可以设置具体的条件值

  - @synchronized          性能最差
  
    - @synchronized是对mutex递归锁的封装
    - 源码查看：objc4中的`objc-sync.mm`文件
    - @synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁、解锁操作
  
- 性能高低

  ```
  性能从高到低排序
  os_unfair_lock
  OSSpinLock
  dispatch_semaphore
  pthread_mutex
  dispatch_queue(DISPATCH_QUEUE_SERIAL)
  NSLock
  NSCondition
  pthread_mutex(recursive)
  NSRecursiveLock
  NSConditionLock
  @synchronized
  ```

#### 有哪几种锁？各自的原理？它们之间的区别是什么？最好可以结合使用场景来说

1. 自旋锁：自旋锁在无法进行加锁时，会不断的进行尝试，处于忙等状态，一直占用CPU资源，一般用于临界区的执行时间较短的场景，不过iOS的自旋锁OSSpinLock不再安全，主要原因发生在低优先级线程拿到锁时，高优先级线程进入忙等(busy-wait)状态，消耗大量 CPU 时间，从而导致低优先级线程拿不到 CPU 时间，也就无法完成任务并释放锁。这种问题被称为优先级反转。
2. 互斥锁：对于某一资源同时只允许有一个访问，无论读写，平常使用的NSLock就属于互斥锁
3. 读写锁：对于某一资源同时只允许有一个写访问或者多个读访问，iOS中pthread_rwlock就是读写锁
4. 条件锁：在满足某个条件的时候进行加锁或者解锁，iOS中可使用NSConditionLock来实现
5. 递归锁：可以被一个线程多次获得，而不会引起死锁。它记录了成功获得锁的次数，每一次成功的获得锁，必须有一个配套的释放锁和其对应，这样才不会引起死锁。只有当所有的锁被释放之后，其他线程才可以获得锁，iOS可使用NSRecursiveLock来实现

#### atomic

- atomic用于保证属性`setter、getter的原子性`操作，相当于在getter和setter内部加了线程同步的锁
- 可以参考源码objc4的objc-accessors.mm
- 它并不能保证使用属性的过程是线程安全的

#### AF中常驻线程的实现

- 使用单例创建线程，添加到runloop中，且加了一个NSMachPort来防止这个新建的线程由于没有活动直接退出【 使用MachPort配合RunLoop进行线程保活】
- AF3.x为什么不再需要常驻线程？
  - NSURLConnection的一大痛点就是：发起请求后，这条线程并不能随风而去，而需要一直处于等待回调的状态
  - NSURLSession发起的请求，不再需要在当前线程进行代理方法的回调。可以指定回调的delegateQueue，这样我们就不用为了等待代理回调方法而苦苦保活线程了
  - 同时还要注意一下，指定的用于接收回调的Queue的maxConcurrentOperationCount设为了1，这里目的是想要让并发的请求串行的进行回调

- 为什么AF3.0中需要设置self.operationQueue.maxConcurrentOperationCount = 1;而AF2.0却不需要？
  - AF3.0的operationQueue是用来接收NSURLSessionDelegate回调的，鉴于一些多线程数据访问的安全性考虑，设置了maxConcurrentOperationCount = 1来达到串行回调的效果
  -  AF2.0的operationQueue是用来添加operation并进行并发请求的，所以不要设置为1

#### NSThread+runloop实现常驻线程

NSThread在实际开发中比较常用到的场景就是去实现常驻线程。

- 由于每次开辟子线程都会消耗cpu，在需要频繁使用子线程的情况下，频繁开辟子线程会消耗大量的cpu，而且创建线程都是任务执行完成之后也就释放了，不能再次利用，那么如何创建一个线程可以让它可以再次工作呢？也就是创建一个常驻线程。

首先常驻线程既然是常驻，那么我们可以用GCD实现一个单例来保存NSThread

```objectivec
+ (NSThread *)shareThread {
    static NSThread *shareThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shareThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTest) object:nil];
        [shareThread setName:@"threadTest"];
        [shareThread start];
    });
    return shareThread;
}
```

这样创建的thread就不会销毁了吗？

```objectivec
[self performSelector:@selector(test) onThread:[ViewController shareThread] withObject:nil waitUntilDone:NO];

- (void)test {
    NSLog(@"test:%@", [NSThread currentThread]);
}
```

并没有打印，说明test方法没有被调用。
 那么可以用runloop来让线程常驻

```objectivec
+ (NSThread *)shareThread {
    static NSThread *shareThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        shareThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTest2) object:nil];
        [shareThread setName:@"threadTest"];
        [shareThread start];
    });
    return shareThread;
}

+ (void)threadTest {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}
```

这时候再去调用performSelector就有打印了

#### pthread、NSThread、GCD、NSOperationQueue(一图展示)

![](./reviewimgs/objc_multithread.png)

#### GCD任务执行顺序

1、串行队列先异步后同步

```objectivec
dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
NSLog(@"1");
dispatch_async(serialQueue, ^{
     NSLog(@"2");
});

NSLog(@"3");
dispatch_sync(serialQueue, ^{
    NSLog(@"4");
});

NSLog(@"5");
```

打印顺序是13245
 原因是:
 首先先打印1
 接下来将任务2其添加至串行队列上，由于任务2是异步，不会阻塞线程，继续向下执行，打印3
 然后是任务4,将任务4添加至串行队列上，因为任务4和任务2在同一串行队列，根据队列先进先出原则，任务4必须等任务2执行后才能执行，又因为任务4是同步任务，会阻塞线程，只有执行完任务4才能继续向下执行打印5
 所以最终顺序就是13245。
 这里的任务4在主线程中执行，而任务2在子线程中执行。
 如果任务4是添加到另一个串行队列或者并行队列，则任务2和任务4无序执行(可以添加多个任务看效果)

2、performSelector

```objectivec
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self performSelector:@selector(test:) withObject:nil afterDelay:0];
});
```

这里的test方法是不会去执行的，原因在于

```objectivec
- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
```

这个方法要创建提交任务到runloop上的，而gcd底层创建的线程是默认没有开启对应runloop的，所有这个方法就会失效。
 而如果将dispatch_get_global_queue改成主队列，由于主队列所在的主线程是默认开启了runloop的，就会去执行(将dispatch_async改成同步，因为同步是在当前线程执行，那么如果当前线程是主线程，test方法也是会去执行的)