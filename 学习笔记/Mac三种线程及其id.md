目录

[Mac 上有三种类型的线程](https://km.sankuai.com/page/375038648#id-Mac上有三种类型的线程)

[task_threads获取性能遇到的坑](https://km.sankuai.com/page/375038648#id-task_threads获取性能遇到的坑)

[thread setname的坑](https://km.sankuai.com/page/375038648#id-threadsetname的坑)

[区分pid，tid， 以及 真实pid的关系](https://km.sankuai.com/page/375038648#id-区分pid，tid，以及真实pid的关系)

[同一个线程为什么有两个ID呢？(内核级线程ID和POSIX级线程id)](https://km.sankuai.com/page/375038648#id-同一个线程为什么有两个ID呢？(内核级线程ID和POSIX级线程id))

[终止线程的3种方法](https://km.sankuai.com/page/375038648#id-终止线程的3种方法)

[3中获取主线程machid的方法](https://km.sankuai.com/page/375038648#id-3中获取主线程machid的方法)

[参考资料](https://km.sankuai.com/page/375038648#id-参考资料)

#### Mac 上有三种类型的线程

- pthread_self()

**glibc**库的线程id。实际上是**线程控制块tcb首地址**

- gettid

**内核级线程id，系统唯一**

该函数为系统调用函数，glibc可能没有该函数声明，需要使用 syscall(SYS_gettid)

- mach_port_t

mac os特有的id。实际上不能说是thread id，而应该当做是端口

#### task_threads获取性能遇到的坑

- 首先通过task_threads获取所有的线程，然后遍历，通过thread_info获取该线程的信息
- 其中thread_Info()接口可以获取threadId。而获取到的threadId 类型是mach_port_t
- 我们有个需求，需要获取线程的名称，使用pthread_getname_np()接口，而该接口参数是pthread_self()的threadId，所以我们要把mach_port_t转化为pthread_t

代码块

CSS

```
pthread_from_mach_thread_np() // mach_port_t --> pthread_t
pthread_mach_thread_np() // pthread_t --> mach_port_t 
```

#### thread setname的坑

线程调用pthread_setname_np函数，一定要在新的线程中调用。因为此函数是对当前线程设置名字

#### 区分pid，tid， 以及 真实pid的关系

**进程pid**: getpid()

- 当前进程的PID(Process ID)

**线程tid**: pthread_self()

- POSIX描述的线程ID，当前线程的ID

- 类型pthread_t，该ID由线程库维护，进程内唯一，但是在不同进程则不唯一
- 作用是可以用来区分同一进程中不同的线程

**线程pid**: syscall(SYS_gettid) 

- 获取内核中真实的线程ID
- 系统内是唯一的

#### **同一个线程为什么有两个ID呢？(内核级线程ID和POSIX级线程id)**

- 线程库实际上由两部分组成：内核的线程支持+用户态的库支持(glibc)
- pthread线程实现就是在内核支持的基础上以POSIX thread的方式对外封装了接口，所以才会有两个ID的问题

#### 终止线程的3种方法

只终止线程而不终止进程的方法有三种

- 从线程函数return。主线程return相当于调用了exit
- 一个线程可以调用pthread_cancel终止同一进程中的另一线程。用pthread_cancel终止一个线程分同步和异步两种情况，比较复杂
- 线程可以调用pthread_exit终止自己



代码块

CSS

```
include <pthread.h>
void pthread_exit(void *value_ptr);
```

value_ptr是void *类型，和线程函数返回值的用法一样，其他线程可以调用pthread_join获得这个指针。

pthread_exit或者return返回的指针所指向的内存单元必须是全局的或者是用malloc分配的，不能在线程函数的栈上分配，因为当其他线程得到这个返回指针时线程函数已经退出了

代码块

CSS

```
#include <pthread.h>
int pthread_join(pthread_t thread, void **value_ptr);
```

 返回值:成功返回0，失败返回错误号

调用该函数的线程将挂起等待，直到id为thread的线程终止。thread线程以不同的方法终止，通过pthread_join得到的终止状态是不同的，总结如下:

- 如果thread线程通过return返回，value_ptr所指向的单元里存放的是thread线程函数的返回值。
- 如果thread线程被别的线程调用pthread_cancel异常终止掉，value_ptr所指向的单元里存放的是常数PTHREAD_CANCELED。
- 如果thread线程是自己调用pthread_exit终止的，value_ptr所指向的单元存放的是传给pthread_exit的参数



一般情况下，**流程终止**后，其终止状态**一直保留到其它线程调用pthread_join获取它的状态为止**。但是线程也可以被置为**detach状态**，这样**的线程一旦终止就立刻回收它所占用的所有资源，而不保留终止状态**。

不能对一个已经处于detach状态的线程调用pthread_join,这样的调用将返回EINVAL。

'对一个尚未detach的线程调用pthread_join或pthread_detach都可以把该线程置为detach状态，也就是说不能对同一线程调用两次pthread_join,或者如果已经对一个线程调用pthread_detach就不能再调用pthread_join了。

代码块

CSS

```
#include <pthread.h>
int pthread_detach(pthread_t tid);
```

#### 3中获取主线程machid的方法

代码块

CSS

```

- (thread_t)getMainPThread {
    // 获取所有线程
    kern_return_t kr;
    const task_t task = mach_task_self();
    thread_act_array_t threads;
    mach_msg_type_number_t threadNum;
    kr = task_threads(task, &threads, &threadNum);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    
    // 第一个线程就是主线程
    thread_t mainThread = threads[0];
    // 释放资源
    for (mach_msg_type_number_t i = 0; i < threadNum; ++i) {
        mach_port_deallocate(task, threads[i]);
    }
    vm_deallocate(task, (vm_address_t)threads, sizeof(thread_t) * threadNum);
    return mainThread;
}

- (void)startTracing
{
    if (self.isTracing) {
        return;
    }
    
    if (pthread_main_np()) {
        g_Main_MachThreadId =  mach_thread_self();
        mach_port_t mach2 = pthread_mach_thread_np(pthread_self());
        mach_port_t mach3 = [self getMainPThread];
        g_Main_MachThreadId = mach2;
        printf("%d %d %d", mach1, mach2, mach3);
    }
```

#### 参考资料

https://blog.csdn.net/yxccc_914/article/details/79854603

https://blog.csdn.net/u012398613/article/details/52183708

https://www.cnblogs.com/luntai/p/6184156.html

https://www.cnblogs.com/orlion/p/5350823.html