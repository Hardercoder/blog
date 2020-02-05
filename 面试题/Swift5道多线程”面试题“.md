[TOC]

#### 	主线程与主队列

- 以下代码的执行结果是什么?

  ```swift
  @objc static func myFunc1() {
      let key = DispatchSpecificKey<String>()
      DispatchQueue.main.setSpecific(key: key, value: "main")
  
      func log() {
          debugPrint("main thread: \(Thread.isMainThread)")
          let value = DispatchQueue.getSpecific(key: key)
          debugPrint("main queue: \(value != nil) value:\(String(describing: value))")
      }
  
      DispatchQueue.global().sync(execute: log)
      debugPrint("main queue execute")
      RunLoop.current.run()
    	/*
    	"main thread: true"
  		"main queue: false value:nil"
  		"main queue execute"
  	  */
  }
  ```

  |      | 并发队列                     | 手动创建串行队列            | 主队列                       |
  | :--- | :--------------------------- | :-------------------------- | :--------------------------- |
  | 同步 | 没有开启新线程  串行执行任务 | 没有开启新线程 串行执行任务 | 没有开启新线程  串行执行任务 |
  | 异步 | 开启新线程  并行执行任务     | 开启新线程  串行执行任务    | 没有开启新线程  串行执行任务 |

  1. 我们把log任务添加到并发队列里面同步执行，由于同步执行没有开启新线程的能力，所以执行这个任务的线程依然是主线程。

  2. 其次DispatchQueue.getSpecific(key: key)返回的是当前执行上下文中key关联的值，而它的上下文就是它所在的执行队列。在这里也就是并发队列，而并发队列没有key关联的值，所以value为nil

  3. 结论:队列和线程并不存在对应的关系，只有当队列和同步、异步执行搭配起来的时候才能决定任务在哪个线程上执行。

     这里引用一下作者的结论😄：看到主线程上也可以运行其他队列

- 什么情况下输出的结果并不是两个 `true` 呢？

  ```swift
  @objc static func myFunc1() {
      let key = DispatchSpecificKey<String>()
      DispatchQueue.main.setSpecific(key: key, value: "main")
  
      func log() {
          debugPrint("main thread: \(Thread.isMainThread)")
          let value = DispatchQueue.getSpecific(key: key)
          debugPrint("main queue: \(value != nil) value:\(String(describing: value))")
      }
      DispatchQueue.global().async {
          DispatchQueue.main.async(execute: log)
      }
    	dispatchMain()
    /*
    "main thread: false"
  	"main queue: true value:Optional(\"main\")"
  
    注释掉最后一行dispatchMain()后的输出
    "main thread: true"
  	"main queue: true value:Optional(\"main\")"
    */
  }
  ```

  1. 和第一题的原理一样，最终我们log任务是提交到了主队列并且在主线程执行。很容易得出两次都是true的结论。但是加上dispatchMain()调用之后输出就变化了。

  2. 问题就出在dispatchMain()这个函数上。我们点进去看到注释

     ```swift
     /**
      * @function dispatch_main
      *
      * @abstract
      * Execute blocks submitted to the main queue.
      *
      * @discussion
      * This function "parks" the main thread and waits for blocks to be submitted
      * to the main queue. This function never returns.
      *
      * Applications that call NSApplicationMain() or CFRunLoopRun() on the
      * main thread do not need to call dispatch_main().
      */
     @available(iOS 4.0, *)
     public func dispatchMain() -> Never
     /*
     	执行提交给主队列的任务
     	这个函数“暂停”主线程并等待提交任务到主队列。这个函数永远不会返回。
     */
     ```

  3. 我们可以看到这个函数的返回值是**Never**，这里我们需要明确一点：我们的函数myFunc1不是没有返回值，它的返回值实际上是Void。Never是一个极其特殊的类型，一般只有编译器会用到，它表示不会返回到函数调用栈顶。
  
     所以这里加了dispatchMain()函数调用后，这个函数会在当前线程执行提交到主队列的任务。最终我们log的执行线程为一条新开辟的线程，而任务队列为主队列。这条新开辟的线程是DispatchQueue.global().async把任务提交到并发队列异步执行的结果。
  
     另外我们**即使在dispatchMain再写其它的代码也不会执行**

#### GCD 与 OperationQueue

- 上面 GCD 的写法，和被注释掉的 OperationQueue 的写法，print 出来会有什么不同呢？

  ```swift
  @objc static func myFunc1() {
    let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0) { _, activity in
        if activity.contains(.entry) {
            debugPrint("entry")
        } else if activity.contains(.beforeTimers) {
            debugPrint("beforeTimers")
        } else if activity.contains(.beforeSources) {
            debugPrint("beforeSources")
        } else if activity.contains(.beforeWaiting) {
            debugPrint("beforeWaiting")
        } else if activity.contains(.afterWaiting) {
            debugPrint("afterWaiting")
        } else if activity.contains(.exit) {
            debugPrint("exit")
        }
    }
  
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
  
    // case 1
    DispatchQueue.global().async {
        (0...9).forEach { idx in
            DispatchQueue.main.async {
                debugPrint(idx)
            }
        }
    }
    /*
    "beforeTimers"
  	"beforeSources"
  	0
  	1
  	2
  	3
  	4
  	5
  	6
  	7
  	8
  	9
  	"beforeTimers"
  	"beforeSources"
  	"beforeTimers"
    .
    .
    .
    */
  
    // case 2
    DispatchQueue.global().async {
      let operations = (0...999).map { idx in BlockOperation { debugPrint(idx) } }
      OperationQueue.main.addOperations(operations, waitUntilFinished: false)
    }
    /*
    "beforeTimers"
  	"beforeSources"
  	0
  	"beforeTimers"
  	"beforeSources"
  	1
  	"beforeTimers"
  	"beforeSources"
  	"beforeTimers"
  	"beforeSources"
  	2
  	"beforeTimers"
  	"beforeSources"
  	3
  	"beforeTimers"
  	"beforeSources"
  	4
  	"beforeTimers"
  	"beforeSources"
  	"beforeWaiting"
  	"afterWaiting"
  	"beforeTimers"
  	"beforeSources"
    5
  	"beforeTimers"
  	"beforeSources"
  	6
  	"beforeTimers"
  	"beforeSources"
  	"beforeWaiting"
  	"afterWaiting"
  	7
  	"beforeTimers"
  	"beforeSources"
  	"beforeWaiting"
  	"afterWaiting"
  	8
  	"beforeTimers"
  	"beforeSources"
  	"beforeWaiting"
  	"afterWaiting"
  	9
  	"beforeTimers"
  	"beforeSources"
  	"beforeWaiting"
  	"afterWaiting"
  	"beforeTimers"
    .
    .
    .
    */
  
    RunLoop.current.run()
  }
  ```

  这里偷懒😅引用下作者的结论：这个例子可以看出有大量任务派发时用 OperationQueue 比 GCD 要略微不容易造成卡顿一些

  其实这里我是有个疑问的，case1的写法是循环的添加任务到主队列去异步执行，是否会由于线程切换有一些性能上的消耗。case2是通过map先构建了N多BlockOperation，之后是一次性添加到主队列中，这种明显的少了很多次线程切换。这里先存个疑问，有知道DispatchQueue怎么把添加队列和执行分开的同学可以验证下是否有区别。

#### 线程安全

- 使用 case 1 的代码会 crash 吗？case 2 呢？case 3 呢？

  ```swift
  @objc class func myFun2() {
      let queue1 = DispatchQueue(label: "queue1")
      let queue2 = DispatchQueue(label: "queue2")
  
      var list: [Int] = []
  
      queue1.async {
          while true {
              if list.count < 10 {
                  list.append(list.count)
              } else {
                  list.removeAll()
              }
          }
      }
  
      queue2.async {
          while true {
              // case 1
              list.forEach { debugPrint($0) }
  
              // case 2
              //    let value = list
              //    value.forEach { debugPrint($0) }
  
              // case 3
              //    var value = list
              //    value.append(100)
          }
      }
  
      RunLoop.current.run()
  }
  ```

  结论为以上的三个case都会崩溃

  原因为:两个串行队列异步执行，原则上会开辟两个独立的线程运行任务，而两个线程在while循环中操作同一个list势必会崩溃

#### RunLoop

- 以下代码会输出什么呢

```swift
class Object: NSObject {
  @objc
  func fun() {
    debugPrint("\(self) fun")
  }
}
@objc class func myFunc3() {
    var runloop: CFRunLoop!

    let sem = DispatchSemaphore(value: 0)
    //Thread(block: T##() -> Void)
    let thread = Thread {
        debugPrint("thread run")
        RunLoop.current.add(NSMachPort(), forMode: .common)
        runloop = CFRunLoopGetCurrent()
        sem.signal()

        CFRunLoopRun()
    }

    thread.start()
    sem.wait()

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        CFRunLoopPerformBlock(runloop, CFRunLoopMode.commonModes.rawValue) {
            debugPrint("2")
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            debugPrint("1")
            let object = Object()
            object.fun()
//              object.perform(#selector(object.fun), on: thread, with: nil, waitUntilDone: false)
//              CFRunLoopWakeUp(runloop)
        })
    }
}
```

1. 这样直接运行出来的结果为

   ```
   "thread run"
   "1"
   "<testsingle.Object: 0x600000d28d00> fun"
   ```

   - 可以看到Thread中的block在thread.start()就已经运行完毕了
   - 然后延迟两秒后主线程异步执行，打印出了1
   - 调用object.run方法，run方法立即执行了

2. 若注释object.run，打开object.perform(**#selector**(object.fun), on: thread, with: **nil**, waitUntilDone: **false**)

   ```
   "thread run"
   "1"
   "2"
   "<testsingle.Object: 0x600001b44460> fun"
   ```

   - Thread中的block在thread.start()就已经运行完毕
   - 然后延迟两秒后主线程异步执行，打印出了1
   - 查看func perform(_ aSelector: Selector, on thr: Thread, with arg: Any?, waitUntilDone wait: Bool)发现，它会唤醒runloop，我们之前已经将debugPrint("2")塞入了队列，而后才执行的perform将run方法塞入队列。所以这里会输出2，fun

3. 若注释object.perform(**#selector**(object.fun), on: thread, with: **nil**, waitUntilDone: **false**)，打开CFRunLoopWakeUp

   ```
   "thread run"
   "1"
   "<testsingle.Object: 0x600000b50400> fun"
   "2"
   ```

   - Thread中的block在thread.start()就已经运行完毕
   
   - 然后延迟两秒后主线程异步执行，打印出了1
   
   - 调用object.run方法，run方法立即执行了
   
   - 使用CFRunLoopWakeUp唤醒RunLoop后，与commondMode关联的Block也都执行了
   
#### 资料引用

>  [我的同事金司机出的 5 道 iOS 多线程“面试题”](https://juejin.im/post/5a9aa633518825556a71d9f3)

