#### 几个名词解释

##### dSYM

编译器在 编译过程 中，会生成一份对应的Debug符号表。它是一个映射表，把 机器指令映射到对应的源代码 中。

这个表在 DEBUG 模式下会存储到 编译好的二进制 中，RELEASE 模式下存储在 单独的dSYM文件 中以节省二进制体积

该符号表通过构建时的UUID和二进制关联，只有UUID一致时解析才有意义，这个UUID每次构建都会生成

##### DWARF

Debug With Arbitrary Record Format，是一个 标准调试信息 格式。单独保存下来就是dSYM文件(Debug Symbol File)。

##### Symbol

类、函数和变量的统称；类名、函数名或变量名称为符号名(Symbol Name)；

按类型分，符号可以分三类：

**全局符号**：目标文件外可见的符号，可以被其他目标文件引用，或者需要其他目标文件定义

**局部符号**：只在目标文件内可见的符号，指只在目标文件内可见的函数和变量

**调试符号**：包括**行号**信息的调试符号信息，行号信息中记录了函数和变量所对应的**文件和文件行号**

##### Symbol Table

符号表是**内存地址与函数名、文件名、行号**的映射表；每个定义的符号有一个对应的值，叫做**符号值**(Symbol Value)，对于变量和函数来说，符号值就是他们的地址；符号表元素如下所示：

<起始地址> <结束地址> <函数> [<文件名:行号>]

符号表存储了 符号信息，ld和dyld都会在link的时候读取符号表

##### String Table

存储 二进制中 硬编码的 所有的字符串

使用 strings 命令可以 查看二进制中的 可以打印出来的 字符串

##### Dynamic Symbol Table

动态符号表，**仅存储了符号位于Symbol Table中的下标**，而非符号数据结构，符号的结构仅存储在Symbol Table中

使用 ***otool*** 命令可以查看动态符号表中的符号位于符号表中的下标。因此动态符号也叫做 ***Indirect symbols***

##### __la_symbol_ptr

***__la_symbol_ptr*** 是懒加载的符号指针，即第一次使用到的时候才加载。

section_64的结构中有个 reserved1 字段，若该section是 ***__DATA,__la_symbol_ptr*** ，则该reserved1字段存储的就是该 ***__la_symbol_ptr*** 在Dynamic Symbol Table中的偏移量，也可以理解为下标

###### 查找 ***__la_symbol_ptr*** 的符号流程如下：

1. 如果LC是 ***__DATA,__la_symbol_ptr*** ，则读取其中的 ***reserved1*** 字段，即得到了该 ***__la_symbol_ptr*** 在 ***Dynamic Symbol Table*** 中的起始地址
2. 对 ***__la_symbol_ptr*** 进行遍历，就得到其中每个symbol对应于 ***Dynamic Symbol Table*** 中的下标。即当前遍历下标  ***idx + reserverd1*** 。
3. 通过 ***Dynamic Symbol Table*** ，找到符号对应于 ***Symbol Table*** 中的下标。
4. 通过 ***Symbol Table*** ，找到符号名对应于 ***String Table*** 中的下标（即 ***nlist_64*** 中的 ***n_strx*** 字段），即得到符号名了。
5. 最终，都是需要到 ***String Table*** 中，通过符号对应的下标，才能查找到符号名的

##### __non_la_symbol_ptr

二进制加载的时候，对于使用到的符号，先通过一系列的关系查找到 ***lazy symbol*** 和 ***non lazy symbol*** ，将函数符号定位到其函数实现，二者绑定起来的过程就是符号绑定

#### 符号命名规则

- C语言的符号，直接在函数名前加下划线即可
- C++支持命名空间、函数重载等，为了避免冲突，所以对符号做了Symbol Mangling操作。
- 如 ***__ZN11MyNameSpace7MyClass6myFuncEd*** 中，**_ZN** 是开头部分，后边紧接着 ***命名空间的长度及命名空间，类名的长度及类名，函数名的长度及函数名*** ，以 ***E*** 结尾，最后则是参数类型，如i为int，d为double
- Objective-C的符号类似于：**_OBJC_CLASS_$_MyViewController** **，_OBJC_CLASS_$_MyObject** 等。
- Swift的命名见 欧阳大哥 的文章，忘记了具体是什么规则了

##### 符号可见性

默认是可见的。通过使用 **fvisibility=hidden** 或者 **__attribute__((visibility("default")) void mytest(void);**

##### LLDB查看符号

可以使用image lookup 查看符号  -t 查看定义  -s 查看位置

##### __la_symbol_ptr的执行过程

- ***__la_symbol_ptr*** 中的指针，会指向 ***__stub_helper*** 
- 第一次调用该函数的时候，使用 ***dyld_stub_binder*** 把指针绑定到函数的实现
- 而汇编代码调用函数的时候，直接调用 ***__DATA, __la_symbol_ptr*** 指针指向的地址

#### 链接

##### 链接过程

将 编译生成的各个.o目标文件链接成最终二进制文件的过程。这个过程需要读取符号表

##### 静态链接器ld

ld是静态链接器，将很多源文件编译生成的.o文件，进行链接

##### 动态加载器dyld

***dlopen和dlsym*** 是iOS系统提供的一组API，可以在运行时加载动态库和动态得获取符号，不过线上App不允许使用

##### 静态库和动态库

静态库 ***.a** 文件不会被链接，而是直接使用 ***ar*** 。类似于 ***tar*** 命令。

- ld 链接静态库（.a文件）的时候，**只有符号被引用到才会写入到二进制文件中，否则会被丢弃**
- 使用静态库的时候，二进制直接将静态库中相应的符号和代码数据拷贝到二进制中，使得体积增大。且静态库更新时需要重新编译二进制。而二进制是可以单独运行。
- 使用动态库的时候，二进制在编译时仅确定动态库中有其使用到的符号实现即可，而不会拷贝任何动态库中的符号相关代码数据。二进制运行的时候，还需要动态库，即运行时调用到某个函数时，还需要去动态库中查找函数相应的实现。动态库更新时，不需要重新编译二进制

#### 符号化工具及命令

关于堆栈符号化，只要注意App、UUID、dSYM对应起来即可。

- uuid是二进制的唯一标识，通过它找到对应的dSYM和DWARF文件

- dSYM包含了符号信息，其中就有 DWARF
  - crash记录着原始的调用堆栈信息

符号化的过程，即在指定的二进制对应的dSYM中，根据crash中堆栈的地址信息，查找出符号信息，即调用函数即可

##### dwarfdump

dwarfdump命令**获取dSYM文件的uuid**，也可以进行简单的查询。

dwarfdump --uuid dSYM文件路径

dwarfdump --lookup [address] -arch arm64 dSYM文件路径

##### mfind

使用mfind用于在Mac系统中定位dSYM文件

mdfind "com_apple_xcode_dsym_uuids == E30FC309-DF7B-3C9F-8AC5-7F0F6047D65F"

##### symbolicatecrash

使用symbolicatecrash命令，可以将crash文件进行符号化

首先通过命令找到symbolicatecrash，之后把symbolicatecrash单独拷贝出来即可使用（或者创建一个软连接也可以）

find /Applications/Xcode.app -name symbolicatecrash -type f

使用方式如下：

./symbolicatecrash my.crash myDSYM > symbolized.crash

若出现下边错误，则将 ***export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer*** 加到bashrc中即可

Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash line 69

如果有出现 ***No symbolic information found***，可能跟是否开启Bitcode有关。开启bitcode，则Xcode会生成多个dSYM文件；若关闭bitcode，则只会产生一个

具体内容可以查看博客 [ios bitcode 机制对 dsym 调试文件的影响](https://www.cnblogs.com/breezemist/p/5151938.html)。

##### atos

使用atos命令，可以对单个地址进行符号化。运行shell命令 ***xcrun atos -o [dwarf文件地址] -arch arm64 -l [loadAddress] [instructionAddress]*** 。



#### 文章参考

[https://juejin.im/post/5ec51a7951882542eb3ed0f4](https://juejin.im/post/5ec51a7951882542eb3ed0f4?utm_source=gold_browser_extension)

https://blog.csdn.net/Hello_Hwc/article/details/103330564

https://juejin.im/post/6844904133321818126