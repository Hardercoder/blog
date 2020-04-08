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

