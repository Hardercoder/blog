[TOC]



# LLVM

## 什么是LLVM

官网: https://llvm.org/

The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.

LLVM项目是模块化、可重用的编译器以及工具链技术的集合

美国计算机协会 (ACM) 将其2012 年软件系统奖项颁给了LLVM，之前曾经获得此奖项的软件和技术包括:Java、Apache、 Mosaic、the World Wide Web、Smalltalk、UNIX、Eclipse等等

## 什么是Clang

 LLVM项目的一个子项目
 基于LLVM架构的C/C++/Objective-C编译器前端  官网:http://clang.llvm.org/

## OC源文件的编译过程

### 命令行查看编译的过程

`clang -ccc-print-phases xxx.m`

### 查看preprocessor(预处理)的结果

`clang -E xxx.m`

### 词法分析，生成Token

`clang -fmodules -E -Xclang -dump-tokens xxx.m`

### 语法分析，生成语法树(AST，Abstract Syntax Tree)

`clang -fmodules -fsyntax-only -Xclang -ast-dump xxx.m`

## LLVM IR

### LLVM IR有3种表示形式

#### 便于阅读的文本格式，类似于汇编语言，拓展名.ll

`clang -S -emit-llvm main.m p memory:`

#### 内存格式

####  二进制格式，拓展名.bc

`clang -c -emit-llvm main.m`

### IR基本语法

- 注释以分号 ; 开头
- 全局标识符以@开头，局部标识符以%开头 
- alloca，在当前函数栈帧中分配内存
- i32，32bit，4个字节的意思
- align，内存对齐
- store，写入数据
- load，读取数据
- 官方语法参考：https://llvm.org/docs/LangRef.html

## 源码下载

### 下载LLVM

`git clone git@github.com:llvm/llvm-project.git`

### 下载clang

`cd llvm/tools`

` git clone https://git.llvm.org/git/clang.git/`

## 源码编译

### 安装cmake和ninja(先安装brew，https://brew.sh/)

`brew install cmake`

`brew install ninja`

ninja如果安装失败，可以直接从[github](https://github.com/ninja-build/ninja/releases)获取release版放入【/usr/local/bin】中

### 在LLVM源码同级目录下新建一个【llvm_build】目录(最终会在【llvm_build】目录下生成【build.ninja】)

`cd llvm_build`

`cmake -G Ninja ../llvm -DCMAKE_INSTALL_PREFIX=LLVM的安装路径`

更多cmake相关选项，可以参考: https://llvm.org/docs/CMake.html

### 依次执行编译、安装指令

`ninja`

`ninja install`

### 也可以生成Xcode项目再进行编译，但是速度很慢

1. 在llvm同级目录下新建一个【llvm_xcode】目录
2. `cd llvm_xcode`
3. `cmake -G Xcode ../llvm`

## 应用与实践

### libclang、libTooling

#### 官方参考

#### https://clang.llvm.org/docs/Tooling.html

 应用: 语法树分析、语言转换等

### Clang插件开发

#### 官方参考

- https://clang.llvm.org/docs/ClangPlugins.html
- https://clang.llvm.org/docs/ExternalClangExamples.html
- https://clang.llvm.org/docs/RAVFrontendAction.html

应用: 代码检查(命名规范、代码规范)等

#### 步骤

##### 创建插件目录

1. 在【clang/tools】源码目录下新建一个插件目录，假设叫做【m-plugin】
2. 在【clang/tools/CMakeLists.txt】最后加入内容: add_clang_subdirectory(m-plugin)，小括号里是插件目录名

#### 创建必要文件

1. 在【m-plugin】目录下新建一个【CMakeLists.txt】，文件内容是:add_llvm_loadable_module(MPlugin MPlugin.cpp) 
   - MPlugin是插件名，MJPlugin.cpp是源代码文件

#### 编写插件源码

1. 编写MPlugin.cpp代码
2. 创建一个命名空间
3. clang扫描完AST的时候，会回调插件的一个ASTAction（继承自PluginASTAction），继而执行这个Action的CreateASTConsumer。这个Consumer继承自ASTConsumer，需要实现它的HandleTranslationUnit方法

#### 编译插件

利用cmake生成的Xcode项目来编译插件(第一次编写完插件，需要利用cmake重新生成一下Xcode项目)

- 插件源代码在【Sources/Loadable modules】目录下可以找到，这样就可以直接在Xcode里编写插件代码
- 选择MPlugin这个target进行编译，编译完会生成一个动态库文件

#### 加载插件

在Xcode项目中指定加载插件动态库:BuildSettings > OTHER_CFLAGS

`-Xclang -load -Xclang 动态库路径 -Xclang -add-plugin -Xclang 插件名称`

#### Hack Xcode

1. 首先要对Xcode进行Hack，才能修改默认的编译器

   - 下载【XcodeHacking.zip】，解压，修改【HackedClang.xcplugin/Contents/Resources/HackedClang.xcspec】的内容，设置一下自己编译好的clang的路径

2. 然后在XcodeHacking目录下进行命令行，将XcodeHacking的内容剪切到Xcode内部

   - `sudo mv HackedClang.xcplugin `xcode-select-print-

     path`/../PlugIns/Xcode3Core.ideplugin/Contents/SharedSupport/Developer/Library/Xcode/Plug-ins`

     `sudo mv HackedBuildSystem.xcspec `xcode-select-print- path`/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Specifications`

### Pass开发

#### 官方参考

https://llvm.org/docs/WritingAnLLVMPass.html

应用:代码优化、代码混淆等

### 开发新的编程语言

#### 参考资料

https://llvm-tutorial-cn.readthedocs.io/en/latest/index.html
https://kaleidoscope-llvm-tutorial-zh-cn.readthedocs.io/zh_CN/latest/

## 推荐书籍

- 编译原理
- LLVM cookbook 中文版



## 总结

- 从结果可以看到，一共分为 7 大阶段。

  - input: **输入阶段**，表示将 main.m 文件输入，文件格式是 OC
  - preprocessor: **预处理阶段**，这个过程包括宏的替换，头文件的导入
  - compiler：**编译阶段**，进行词法分析、语法分析、语义分析，最终生成 IR
  - backend: **后端**，LLVM 会通过一个一个的 Pass 去优化，最终生成汇编代码。
  - assembler: **汇编**，生成目标文件
  - linker: **链接**，链接需要的动态库和静态库，生成可执行文件
  - bind-arch: **架构绑定**，通过不同的架构，生成对应的可执行文件

  

 `clang -ccc-print-phases MyObj.m`  可以打印出源码的编译过程

`clang -E MyObj.m -o MyObj2.m` 可以只对源码执行预处理阶段，-o选项一般都是用来执行输出文件路径和名称

`clang -fmodules -fsyntax-only -Xclang -dump-tokens 文件名` 可对代码进行词法分析

`clang -fmodules -fsyntax-only -Xclang -ast-dump 文件名` 可对代码进行语法分析



LLVM IR有三种表现形式

// 生成 text 格式的 IR 

`clang -S -fobjc-arc -emit-llvm 文件名`

// 内存形式

// bitcode形式，二进制形式，拓展名为.bc

// 生成 bitcode 格式的 IR
`clang -c -fobjc-arc -emit-llvm 文件名`



// ll 生成汇编
`clang -S -fobjc-arc main.ll -o main.s`

// bc 生成汇编
`clang -S -fobjc-arc main.bc -o main.s`



// 生成目标文件

`clang -fmodules -c 汇编源文件 -o 目标文件`

// 生成可执行文件

`clang 目标文件名 -o 可执行文件名`



IR 基本语法:

> @ 全局标识 % 局部标识 alloca 开辟空间 align 内存对齐 i32 32 bit, 即 4 个字节 store 写入内存 load 读取数据 call 调用函数 ret 返回



#### 参考资料

[深入剖析 iOS 编译 Clang / LLVM](https://ming1016.github.io/2017/03/01/deeply-analyse-llvm/)