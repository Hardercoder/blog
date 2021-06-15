分析代码基于 objc824

1. 应用启动之后的第一个函数 `_dyld_start`
2. 启动dyld之后，调用了dyldbootstrap的 `dyldbootstrap::start` 方法
3. start方法内部开始执行main函数 `dyld::main`
4. main函数里面开始加载主执行文件 `dyld::initalizeMainExecutable`
5. `在initializeMainExecutable`里面加载镜像并执行初始化 `ImageLoader::runInitializers`
6. `runInitializers`里面开始处理初始化，并递归处理依赖 `ImageLoader::processInitizliers->ImageLoader::recursiveInitialization`
7. 然后走到每一个镜像的实际处理函数里面 `ImageLoaderMachO::doInitialization`
8. 在`doInitialization`里面进行rebase和bind操作, `doModInitFunctions`
9. 随后执行 `libSystem_initializer->libDispatch_init->os_object_init->_objc_init`
10. 至此。进入runtime的过程
11. `_objc_init` 内部执行一系列的初始化
    - `environ_init`：初始化影响runtime的环境变量
    - `tls_init`
    - `static_init`：运行C++的静态构造函数
    - `runtime_init`：初始化unattachedCategories和allocatedClasses容器
    - `exception_init`：初始化libobjc处理系统的异常处理函数。有异常时会被map_images调用
    - `_imp_implementationWithBlock_init`：
    - `dyld_objc_notify_register(&map_images, load_images, unmap_image)`设置镜像map，load和unmap的回调函数
    - 将 `didCallDyldNotifyRegister`设置为true
12. 然后开始加载镜像，并触发镜像加载的回调 `_dyld_objc_notify_register->dyld::registerObjCNotifiers->dyld::notifyBatchPartial`
13. 然后就走到了回调 `map_images`，`随后执行map_images里面的函数map_images_lock`
14. `map_images_lock`
    - 进行只有一次的 `preopt_init`
    - 



参考资料 https://github.com/anyhong/objc4