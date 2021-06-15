[TOC]



#### iOS中的读写安全方案

- 上面的场景就是典型的“多读单写”，经常用于文件等数据的读写操作，iOS中的实现方案有
  - pthread_rwlock：读写锁
  - dispatch_barrier_async：异步栅栏调用

##### pthread_rwlock

- 等待锁的线程会进入休眠

  ```objc
  // 初始化锁
  pthread_rwlock_t lock;
  pthread_rwlock_init(&lock, NULL);
  // 读 加锁
  pthread_rwlock_rdlock(&lock);
  // 读 尝试加锁
  pthread_rwlock_tryrdlock(&lock);
  // 写 加锁
  pthread_rwlock_wrlock(&lock);
  // 写 尝试加锁
  pthread_rwlock_trywrlock(&lock);
  // 解锁
  pthread_rwlock_unlock(&lock);
  // 销毁
  pthread_rwlock_destroy(&lock);
  ```

##### dispatch_barrier_async

1、问：怎么用GCD实现多读单写？

多读单写的意思就是：可以多个读者同时读取数据，而在读的时候，不能取写入数据。并且，在写的过程中，不能有其他写者去写。即读者之间是并发的，写者与读者或其他写者是互斥的。

这里的写处理就是通过栅栏的形式去写,就可以用dispatch_barrier_sync(栅栏函数)去实现

2、dispatch_barrier_sync的用法：

- 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的
- 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果

```objectivec
dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);

for (NSInteger i = 0; i < 10; i++) {
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%zd",i);
    });
}

dispatch_barrier_async(concurrentQueue, ^{
    NSLog(@"barrier");
});

for (NSInteger i = 10; i < 20; i++) {
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%zd",i);
    });
}
```

这里的dispatch_barrier_sync上的队列要和需要阻塞的任务在同一队列上，否则是无效的。
 从打印上看，任务0-9和任务任务10-19因为是异步并发的原因，彼此是无序的。而由于栅栏函数的存在，导致顺序必然是先执行任务0-9，再执行栅栏函数，再去执行任务10-19。

- dispatch_barrier_sync: Submits a barrier block object for execution and waits until that block completes.(提交一个栅栏函数在执行中,它会等待栅栏函数执行完)
- dispatch_barrier_async: Submits a barrier block for asynchronous execution and returns immediately.(提交一个栅栏函数在异步执行中,它会立马返回)
- 而dispatch_barrier_sync和dispatch_barrier_async的区别也就在于会不会阻塞当前线程
   比如，上述代码如果在dispatch_barrier_async后随便加一条打印，则会先去执行该打印，再去执行任务0-9和栅栏函数；而如果是dispatch_barrier_sync，则会在任务0-9和栅栏函数后去执行这条打印。

**3、则可以这样设计多读单写：**

```objectivec
- (id)readDataForKey:(NSString *)key
{
    __block id result;
    dispatch_async(_concurrentQueue, ^{
        result = [self valueForKey:key];
    });
    
    return result;
}

- (void)writeData:(id)data forKey:(NSString *)key {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self setValue:data forKey:key];
    });
}
```