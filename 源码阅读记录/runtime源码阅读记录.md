1.  从启动到load方法调用过程， _objc_init->_dyld_objc_notify_register->**load_images**内部调用
    1. preapare_load_methods
       1. prepare_load_methods内部先递归调用schedule_class_load，在每个schedule_class_load内部又调用了add_class_to_loadable_list将load方法添加到loadable_classes中
       2. prepare_load_method内部然后调用add_category_to_loadable_list将分类的方法添加的loadable_categories中
    2. **call_load_methods**
       1. 在objc_autoreleasePoolPush objc_autoreleasePoolPop这两段代码间进行load方法调用
       2. 先循环调用**call_class_loads**，然后再循环调用call_category_loads
       3. **总结:**load方法先调用全部主类的，然后再调用分类的，主类的调用顺序是从上往下的

2.  探究initialized过程
    1. lookUpImpOrForward->initializeAndMaybeRelock->initializeNonMetaClass递归向上->callInitialize(内部走的消息派发)->lockAndFinishInitializing->_finishInitializing内部递归调用-


#### alloc和init探索

- allocWithZone 本质上和 alloc 是没有区别的
- 在 OC 的类的结构中，有一个结构叫 class_rw_t ，有一个结构叫 class_ro_t 。其中 class_rw_t 是可以在运行时去拓展类的，包括属性，方法、协议等等，而 class_ro_t 则存储了成员变量，属性和方法等，不过这些是在编译时就确定了的，不能在运行时去修改

- 内存对齐三原则
  1. 前面的地址必须是后面的地址正数倍,不是就补齐
  2. 结构体里面的嵌套结构体大小要以该嵌套结构体最大元素大小的整数倍
  3. **整个Struct** 的地址必须是最大字节的整数倍

- 对象的属性是进行的 8 字节对齐
- 对象自己进行的是 16 字节对齐
  因为内存是连续的，通过 16 字节对齐规避风险和容错，防止访问溢出
  同时，也提高了寻址访问效率，也就是空间换时间

类和元类创建于编译时，可以通过 `LLDB` 来打印类和元类的指针，或者 `MachOView` 查看二进制可执行文件

万物皆对象：类的本质就是对象

类在 `class_ro_t` 结构中存储了编译时确定的属性、成员变量、方法和协议等内容。

实例方法存放在类中

类方法存放在元类中

#### App的整体启动过程

`_dyld_start->dyldbootstrap::start->dyld::main->dyld::initializeMainExecutable->ImageLoader::runInitializers->ImageLoader::processInitializers->ImageLoader::recursiveInitizlization->...->ImageLoaderMachO::doInitialization->libSystem_initizlier->libdispatch_init->_os_object_init->::_objc_init`

以上是通过在_objc_init出打断点得出，我们可以看一下这个过程

- 首先点击AppIcon之后，类Linux会启动一个exec<xx>系列的引导程序，这个引导程序会fork一个进程，也就是我们程序运行的这个进程
- fork进程之后开始动态链接库加载器(dyld)的初始化和启动工作
- 首先通过`_dyld_start`启动dyld，启动之后执行它的`main`方法，在该方法中初始化我们主App的可执行文件，通过ImageLoader进行初始化及初始化的处理操作，然后递归的添加依赖的动态库并初始化
- 将这些镜像加载进系统内存后，执行了libSystem的初始化，启动了runtime
- 最后走到了oc runtime的_objc_init，下面我们来看下这个方法

```cpp
//objc-os.mm 
/***********************************************************************
* _objc_init
* Bootstrap initialization. Registers our image notifier with dyld.
* 这个是runtime启动初始化的引导程序，在这里会注册镜像加载的通知到dyld
* Called by libSystem BEFORE library initialization time
* 在库初始化之前由libSystem调用
**********************************************************************/
void _objc_init(void)
{
    static bool initialized = false;
    if (initialized) return;
    initialized = true;
    
    // fixme defer initialization until an objc-using image is found?
    environ_init();
    tls_init();
    static_init();
    lock_init();
    exception_init();

  	/*
注意：仅供objc运行时使用
注册objc镜像的映射，未映射和初始化时要调用的处理程序。
Dyld将使用包含objc-image-info分区的图像数组来调用“映射”函数。
那些是dylib的镜像将自动增加引用计数，因此objc不再需要在它们上调用dlopen（）来防止它们被卸载。
在调用_dyld_objc_notify_register（）的过程中，dyld将使用已加载的objc镜像调用“映射”函数。
在以后的任何dlopen（）调用期间，dyld还将调用“映射”函数。 
当在该镜像中将dyld称为初始化器时，Dyld将调用“ init”函数。 这是objc在该镜像中调用任何+ load方法的时候。
  	*/
    _dyld_objc_notify_register(&map_images, load_images, unmap_image);
}
```

##### 其中map_images执行流程

map_images->map_images_nolock->_read_image->realizeAllClasses

##### load_images执行流程

load_images->prepare_load_methods->call_load_methods

其中prepare_load_methods会调用schedule_class_load，然后获取所有的categorylist，将所有分类添加到add_category_to_loadable_list

schedule_class_load内部递归调用自己，将所有类，自上而下添加到add_class_to_loadable_list中。

##### unmap_image执行流程

unmap_image->unmap_image_nolock->_unload_image

#### 底层结构

- 首先看一下**方法，成员变量和属性**的定义

  ```css
  struct method_list_t : entsize_list_tt<method_t, method_list_t, 0x3> 
  struct ivar_list_t : entsize_list_tt<ivar_t, ivar_list_t, 0>
  struct property_list_t : entsize_list_tt<property_t, property_list_t, 0>
  ```

  他们都是entsize_list_t的子类，entsize_list_t是一个模板类，内部有封装一些迭代器操作

#### 方法查找流程

_class_lookupMethodAndLoadCache3->lookUpImpOrForward

lookUpImpOrForward内部逻辑

1. cache_getImp首先去类的缓存list里面查找实现，若没有找到对应实现
2. getMethodNoSuper_nolock查找本类的方法列表里面是否有对应selector的实现，若找到对应的实现，会去调用log_and_fill_cache缓存下来，若没有找到对应实现
3. 递归往上调用1，2步骤
4. 若以上步骤没有找到对应的实现，会调用resolveMethod，resolveMethod内部会自动的判断调用`resolveInstanceMethod/resolveClassMethod`
5. 若没有找到对应的方法，会将imp赋值为_objc_msgForward_impcache，而_objc_msgForward_impcache是一个汇编实现的，内部会走对应的消息转发的流程
6. 消息转发流程分两个阶段
   - 比较简单且快速的阶段为forwardingTargetForSelector，此阶段只需要返回一个其他的实例，就会将消息转发到该实例上，去给该实例进行消息发送。
   - 另一个阶段可做的事情更多。会先调用methodSignatureForSelector返回一个自定义方法签名，然后采用该签名调用forwardInvocation进行调用转发
7. 如果以上转发阶段均未做处理，会调用doesNotRecognizeSelector结束整个消息发送过程

