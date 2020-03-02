[TOC]

### 为什么说OC是一门动态语言

**OC作为一门面向对象的语言，具有封装、继承、多态的语言特性，可以在运行时动态改变类的结构：添加新函数、删除旧函数，添加、移除、替换iVar和property等，所以说它是一门动态语言**，它的动态特性主要体现在以下几个方面：

- 动态类型：一个变量所指向的类型会推迟到运行时才具体知道是什么类型，最直接的就是id类型。静态类型是强类型，而动态类型属于弱类型，运行时决定接受者
- 动态绑定：将调用方法的确定也推迟到运行时。OC可以先跳过编译，到运行的时候才动态地添加函数调用，决定要调用什么方法，需要传什么参数进去
- 动态加载：在运行期间加载需要的资源或可执行代码

### Objective-C中可变和不可变类型

- 可变和不可变，就是可动态添加修改和不可动态添加修改
- 比如`NSArray`和`NSMutableArray`，前者在初始化后的内存控件就是固定不可变的，后者可以添加、删除、替换等，可以动态申请新的内存空间

### C和 OC 如何混编

- .m文件,可以编写 OC语言 和 C 语言代码
- .cpp: 只能识别C++ 或者C语言(C++兼容C)
- .mm: 主要用于混编 C++和OC代码,可以同时识别OC,C,C++代码

### Swift 和OC 如何调用

- Swift 调用 OC代码
  需要创建一个 `<Module>-Bridging-Header.h` 的桥接文件，在文件内引入需要调用的OC代码头文件
- OC 调用 Swift代码
  直接引入 `<Module>-Swift.h`文件，Swift如果需要被OC调用，需要使用@objc 对方法或者属性进行修饰

### Foundation 对象与 CoreFoundation 对象 有什么区别

- `Foundation`对象是OC的,在MRC下需要手动管理内存,ARC下不需要手动管理
- `Core Foundation`对象是C对象, MRC和ARC都需要手动管理内存
- 数据类型之间的转换
  - ARC:__bridge_retained, __bridge_transfer(自动内存管理)
  - 非ARC: __bridge

### 怎么理解协议以及协议的默认修饰符

- 协议规定了一系列的行为(方法)和数据(属性)，主要用在代理模式中
- OC中协议默认是`@required`必须实现的，使用`@optional`修饰后变为可选择实现

### Xcode里的-ObjC,-all_load和-force_load的作用

- 链接器：一个程序从简单易读的代码到可执行文件往往要经历以下步骤

  > 源代码 > 预处理器 > 编译器 > 汇编器 > 机器码 > 链接器 > 可执行文件 

  - 源文件经过一系列处理以后，会生成对应的.obj文件，一个项目会有许多.obj文件，并且这些文件之间会有各种各样的联系，例如函数调用。链接器做的事就是把这些目标文件和所用的一些库链接在一起形成一个完整的可执行文件

- Objective-C的链接器并不会为每个方法建立符号表，而是仅仅为类建立符号表。这样，如果静态库中定义了已存在的一个类的分类，链接器就会以为这个类已经存在，不会把分类和核心代码结合起来。这样的话，在最后的可执行文件中，就会缺少分类里的代码，这样函数调用就失败了

- `-ObjC`：加了这个参数后，链接器会把静态库中所有的Objective-C类和分类都加载到最后的可执行文件中，但是当静态库中只有分类而没有主类的时候，-ObjC参数就会失效，这是编译器的一个bug。这时候就需要使用-all_load或者-force_load

- `-all_load`：会让链接器把所有找到的目标文件都加载到可执行文件中，但是千万不要随便使用这个参数！假如你使用了不止一个静态库文件，然后又使用了这个参数，那么你很有可能会遇到ld：duplicate symbol错误，因为不同的库文件里面可能会有相同的目标文件，所以建议在遇到-ObjC失效的情况下使用-force_load参数

- `-force_load`所做的事情跟`-all_load`其实是一样的，但是`-force_load`需要指定要进行全部加载的库文件的路径，这样的话，你就只是完全加载了一个库文件，不影响其余库文件的按需加载

###  cocoa 和 cocoa touch是什么

- Cocoa包含Foundation和AppKit框架，用于开发Mac OS X系统的应用程序
- Cocoa Touch包含Foundation和UIKit框架，用于开发iPhone OS系统的应用程序
- Cocoa Touch底层技术架构主要分为4层

  - 可触摸层Cocoa Touch：UI组件，触摸事件和事件驱动，系统接口
  - 媒体层 Media：音视频播放，动画，2D和3D图形
  - Core Service：核心服务层，底层特性，文件,网络，位置服务区等
  - Core OS：内存管理，底层网络，硬盘管理

### OC类可以多继承么?可以实现多个接口么?Category是什么?重写一个类用继承好还是分类好?为什么?

- Objective-c的类不可以有多继承，OC里面都是单继承，多继承可以用protocol委托代理来模拟实现
  可以实现多个接口，可以通过实现多个接口完成OC的多重继承

- Category是类别；

- 重写一个类的方式用继承好还是分类好：
  - 重写一个类的方式用继承还是分类，取决于具体情况。假如目标类有许多的子类.我们需要拓展这个类又不希望影响到原有的代码；继承后比较好
  - 如果仅仅是拓展方法.分类更好（不需要涉及到原先的代码）
  - 分类中方法的优先级比原来类中的方法高，也就是说，在分类中重写了原来类中的方法，那么分类中的方法会覆盖原来类中的方法

- 为什么不要在category中重写一个类原有的方法：
  - category没有办法去代替子类，它不能像子类一样通过super去调用父类的方法实现。如果category中重写覆盖了当前类中的某个方法，那么这个当前类中的原始方法实现，将永远不会被执行，这在某些方法里是致命的
  - 同时，一个category也不能可靠的覆盖另一个category中相同的类的相同的方法。例如UIViewController+A与UIViewController+B，都重写了viewDidLoad，我们就无法控制谁覆盖了谁
  - 通过观察头文件我们可以发现，Cocoa框架中的许多类都是通过category来实现功能的，可能不经意间你就覆盖了这些方法中的其一，有时候就会产生一些无法排查的异常原因
  - category的诞生只是为了让开发者更加方便的去拓展一个类，它的初衷并不是让你去改变一个类。
    结论：
  - 要重写方法，当然我们首推通过子类重写父类的方法，在一些不方便重写的情况下，我们也可以在category中用runtime进行method swizzling(方法的偷梁换柱)来实现。

### 对于语句`NSString * obj = [[NSData alloc] init]`obj在编译时和运行时分别是什么类型? 

编译时是NSString的类型；运行时是NSData类型的对象

### id 声明的对象有什么特性? 

Id 声明的对象具有运行时的特性，即可以指向任意类型的oc对象

### 懒加载

懒加载——也称为延迟加载，只在用到的时候才去初始化，比如控制器的view，在第一次用到view时才会调用loadView方法进行创建，所谓懒加载，写的是其get方法。我觉得最好也最简单的一个列子就是tableView中图片的加载显示了。一个延时载，避免内存过高，一个异步加载，避免线程堵塞。
注意：如果是懒加载的话则一定要注意先判断是否已经有了，如果没有那么再去进行实例化

- 懒加载的好处：
  1. 不必将创建对象的代码全部写在viewDidLoad方法中，代码的可读性更强
  2. 每个控件的 getter 方法中分别负责各自的实例化处理，代码彼此之间的独立性强，松耦合

### 代理的作用

- 代理又叫委托，是一种设计模式，代理是对象与对象之间的通信交互，代理解除了对象之间的耦合性
- 改变或传递控制链。允许一个类在某些特定时刻通知到其他类，而不需要获取到那些类的指针。可以减少框架复杂度

### 为什么代理要用weak？代理的delegate和dataSource有什么区别？block和代理的区别

- 避免循环引用。如果使用`strong`修饰且代理是self的话，会出现循环引用，从而造成内存泄漏
- 所谓代理就是当一个对象接收到某个事件或者通知的时候，将该事件或通知让它的代理对象去实现。代理的`delegate`和`dataSource`是为了职责分离。`delegate`负责事件处理，`datasource负责数据源处理
- `delegate`和`block`都可以实现回调传值
  - `block`写法简练，可以直接访问上下文，代码阅读性好，适合与状态无关的操作，更加面向结果，使用过程中需要注意避免造成循环引用。
  - `delegate`更像一个生产流水线，每个回调方法是生产线上的一个处理步骤，一个回调的变动可能会引起另一个回调的变动，其更加面向过程
- 一般情况下，简单功能的回调用block，系列函数的回调选择delegate

### NSNotification、Block、Delegate和KVO的区别

- Block和Delegate属于代理模式，是一对一的关系，Notification和KVO是观察者，是一对多的关系
- 代理模式相对观察者模式效率比较高
- notification通过维护一个array，实现一对多消息的转发
- delegate需要两者之间必须建立联系，不然没法调用代理的方法；notification不需要两者之间有联系
- Delegate需要定义协议方法，代理对象实现协议方法，并且需要建立代理关系才可以实现通信
- Block更加简洁，不需要定义繁琐的协议方法，但通信事件比较多的话，建议使用Delegate

### 什么是Block以及怎么使用block反向传值

- 闭包（block）：闭包就是获取其它函数局部变量的匿名函数，本质是一个OC对象

- ```objectivec
  // 在控制器间传值可以使用代理或者block，使用block相对来说简洁。
  //在前一个控制器的touchesBegan:方法内实现如下代码。 
  // OneViewController.m 
  TwoViewController *twoVC = [[TwoViewController alloc] init];
  twoVC.valueBlcok = ^(NSString *str) { NSLog(@"OneViewController拿到值：%@", str); }
  [self presentViewController:twoVC animated:YES completion:nil]; 
  // TwoViewController.h   （在.h文件中声明一个block属性） 
  @property (nonatomic ,strong) void(^valueBlcok)(NSString *str); 
  // TwoViewController.m   （在.m文件中实现方法） 
  - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
    // 传值:调用block 
    if (_valueBlcok) {_valueBlcok(@"123456");}
  }
  ```

- 使用block的注意点
  - 在block内部使用外部指针且会造成循环引用情况下，需要用__week修饰外部指针：
     __weak typeof(self) weakSelf = self;
  - 在block内部如果调用了延时函数还使用弱指针会取不到该指针，因为已经被销毁了，需要在block内部再将弱指针重新强引用一下。
     __strong typeof(self) strongSelf = weakSelf;__
  - __如果需要在block内部改变外部栈区变量的话，需要在用__block修饰外部变量

### Notification 和KVO区别

- KVO提供一种机制：当指定的被观察的对像的属性被修改后，KVO会自动通知响应的观察者。KVC(键值编码)是KVO的基础
- 通知：是一种广播机制，在事件发生的时候通过通知中心对象，一个对象能够为所有关心这个事件发生的对象发送消息
- 两者都是观察者模式，不同在于KVO是被观察者直接发送消息给观察者，是对象间的直接交互，通知则是两者都和通知中心对象交互，对象之间不知道彼此
- 本质区别：底层原理不一样，kvo 基于 runtime,，通知则是有个通知中心来进行通知

### 讲讲你对`atomic` & `nonatomic`的理解

- 原子操作对线程安全并无任何安全保证。被 `atomic` 修饰的属性(不重载设置器和访问器)只保证了对数据读写的完整性，也就是原子性，但是与对象的线程安全无关。它只保证了调用`getter/setter`时是安全的
- 线程安全有保障、对性能有要求的情况下可使用 `nonatomic`替代`atomic`，当然也可以一直使用`atomic`

[参考文章](https://www.jianshu.com/p/270239034d65)

### `objc` 中类方法和实例方法有什么本质区别和联

- 类方法：
  - 类方法是属于类对象的
  - 类方法只能通过类对象调用
  - 类方法中的self是类对象
  - 类方法可以调用其他的类方法
  - 类方法中不能访问成员变量
  - 类方法中不能直接调用对象方法

- 实例方法：
  - 实例方法是属于实例对象的
  - 实例方法只能通过实例对象调用
  - 实例方法中的self是实例对象
  - 实例方法中可以访问成员变量
  - 实例方法中直接调用实例方法
  - 实例方法中也可以调用类方法(通过类名)

### nil、Nil、NULL、NSNull的区别

- nil  是一个实例对象值，常用于清空一个对象和作为arrayWithObjects的结束符
- Nil  是一个类对象值，常用于清空一个类对象
- NULL 指向基本数据类型的空指针
- NSNull 是一个对象，常用于需要占位的场合

### static、self、super关键字的作用

- 函数体内`static`变量的作用范围为该函数体，不同于`auto`变量，该变量的内存只被分配一次，因此其值在下次调用时仍维持上次的值
- 在模块内的 `static` 全局变量可以被模块内所用函数访问，但不能被模块外其它函数访问
- 在模块内的`static`函数只可被这一模块内的其它函数调用
- 在类中的`static`成员变量属于整个类所拥有，对类的所有对象只有一份拷贝
- self：当前消息的接收者
- super：一个编译器关键字，使用super发送消息时底部被转换为objc_superMsgSend，但是接受者依然是self

### self. 跟 self-> 区别？

- self. 是调用 get 方法或者 set 方法，self 是当前本身，是一个指向当前对象的指针
-  self-> 是直接访问成员变量

### #include、#import、@class、#import<>、 #import“”的区别

- 在C语言中，使用 `#include` 来引入头文件，防止重复导入需要用`#ifndef...#define...#endif`宏分割
- 在OC语言中，使用`#import`来引入头文件，不会引起交叉编译，可以防止重复引入和避免头文件递归引入
- `@class`用来告诉编译器有这样一个类，编译代码时不报错，也不会拷贝头文件，可以解决头文件的相互引用。仅在需要使用该类时使用 `#import`引入。
- \#import<> 用于引用系统头文件，会在系统头文件内寻找
- #import“” 用于引用本工程的头文件，它会先在工程中找，找不到再去引用系统同名头文件

### id、instancetype的区别

- `id`可以作为方法的返回以及参数类型，也可以用来定义变量，**编译器不检查id类型**
- `instancetype` 只能作为函数或者方法的返回值
- instancetype对比id的好处就是：**能精确的限制返回值的具体类型**

### id 声明的对象有什么特性

id 声明的对象具有运行时的特性，即可以指向任意类型的Objcetive-C的对象

### NSObject、id的区别

- NSObject和id都可以指向任何对象
- NSObject对象会在编译时进行检查，需要强制类型转换
- id类型不需要编译时检查，不需要强制类型转换

### 对象方法和类方法的区别

- 对象方法：以减号开头，只可以被对象调用，可以访问成员变量
- 类方法：以加号开头只能用类名调用，对象不可以调用，类方法不能访问成员变量

### OC中的NSInteger 和int 有什么区别

- NSInteger实际上一个typedef

  ```objective-c
  #if __LP64__ || 0 || NS_BUILD_32_LIKE_64
  typedef long NSInteger;
  typedef unsigned long NSUInteger;
  #else
  typedef int NSInteger;
  typedef unsigned int NSUInteger;
  #endif
  ```

- 在32位操作系统上，NSInteger 等价于 int，即32位

- 在64位操作系统上，NSInteger 等价于 long，即64位

### **switch **语句 **if **语句区别与联系

- 均表示条件的判断，switch语句表达式只能处理整型、字符型和枚举类型，而选择流程语句则没有这样的限制。switch语句比选择流程控制语句效率更高

### OC中集合的注意事项和相互之间的区别

- **NSArray**
  - **NSArray** 初始化后元素就不可再增删
  - **NSMuatbleArray** 初始化后可以随时添加或删除元素对象
  - **NSPointerArray**  与 `NSMuatbleArray` 相似，区别是可以指定对元素的强/弱引用。也就是说 `NSPointArray` 内部元素为对象 或 `nil`
  - `indexOfObject` 与 `indexOfObjectIdenticalTo` 的区别
    - 两个方法都是来判断某一对象是否是 `Array` 集合内元素，如果是则返回该对象在集合内的索引
    - 两个方法的区别就在于两个 API 判定的依据：**`indexOfObject` 会使用 `isEqualTo` 方法将 `Object` 与集合元素进行比较。而 `indexOfObjectIdenticalTo` 则会比较 `Object` 与集合元素的指针是否相同**
- **NSDictionary**
  - **NSDictionary**  初始化后就不可再增删键值对
  - **NSMutableDictionary** 初始化后可以随时添加或删除键值对
  - **NSMapTable** 类似 `NSMutableDictionary` 可以指定对 `value` 的强/弱引用。也就是说 `NSMapTable` 内部元素的 `value` 值可以为 `nil`
  - 当某个键值对添加到 `Dictionary` 时，`Dictionary` 会对 `key` 进行深拷贝，而对 `value` 进行浅拷贝，已经添加到集合内部的键值对，key 值将不可更改
  - 作为 `key` 的对象都需要满足哪些条件呢
    - `key` 必须遵循 `NSCopying` 协议，因为当元素渐入字典后，会对 `key` 进行深拷贝
    - `key` 必须实现 `hash` 与 `isEqual` 方法。（便于快速获取元素并保证 `key` 的唯一性）
- **NSSet**
  - **NSSet** 初始化后就不可再增删元素
  - **NSMuatbleSet** 初始化后可随时增删元素
  - **NSCountedSet** 每个元素都带有一个计数，添加元素，计数为一。重复添加某个元素则计数加一；移除元素计数减一，计数为零则移除
  - **NSHashTable** 和 **NSMutableSet** 类似，区别是可指定对元素的强/弱引用，内部元素可以为 `nil`
  - **NSIndexSet**`IndexSet` 保存的 `Array` 子集，存储元素为 `Array` 的 `index` 索引，存储形式为索引范围
- NSMutableDictionary 中使用setValueForKey 和 setObjectForKey有什么区别
  - 根据官方文档说明：一般情况下，如果给NSMutableDictionary 发送`setValue` 仍然是调用了 `setObject`方法，如果参数 value 为 nil，则会调用`removeObject` 移除这个键值对
  - `setObjectForKey` 是 NSMutableDictionary特有的，value 不能为nil，否则会崩溃
  - `setValueForKey` 是KVC的方法，key 必须是字符串类型，setObject 的 key 可以是任意类型

- NSCache 和NSDictionary 区别
  - NSCache可以提供自动删减缓存功能，而且保证线程安全，与字典不同，不会拷贝键
  - NSCache采用LRU规则，可以设置缓存上限，限制对象个数和总缓存开销。定义了删除缓存对象的时机。这个机制只对NSCache起到指导作用，不会一定执行
  - NSPurgeableData搭配NSCache使用，可以自动清除数据
  - 只有耗时计算的数据才值得放入缓存

- NSArray 和 NSSet区别
  - NSSet和NSArray功能性质一样，用于存储对象，属于集合。
  - NSSet属于 “无序集合”，采用hash算法计算存储位置，造就了它查询速度比较快，保证了元素的唯一性，在内存中存储方式是不连续的
  - NSArray是 “有序集合” 它内存中存储位置是连续的
  - NSSet，NSArray都是类，只能添加对象，如果需要加入基本数据类型（int，float，BOOL，double等），需要将数据封装成NSNumber类型

### isEqual、isEqualToString、==区别

- == 比较两个对象的内存地址，若一样就返回TRUE，若不一样就返回FALSE
- isEqual:首先检查指针的等同性，然后是类的等同性，最后对对象的属性和变量检查，比较成功返回true，两个对象如果isEqual比较成功会有相同的hash值，但是如果两个两个对象的hash值相等，不一定比较成功
- isEqualToString：字符串比较，只比较字符串本身的内容是否一致，不比较内存地址

### isKindOfClass、isMemberOfClass、selector作用分别是什么

- isKindOfClass：作用是某个对象属于某个类型或者继承自某类型
- isMemberOfClass：某个对象确切属于某个类型
- selector：通过方法名，获取在内存中的函数的入口地址

### isMemberOfClass 和 isKindOfClass 联系与区别

- 联系：两者都能检测一个对象是否是某个类的成员
- 区别：`isKindOfClass` 不仅用来确定一个对象是否是一个类的成员，也可以用来确定一个对象是否派生自该类的类的成员 ，而`isMemberOfClass` 只能做到第一点
- 举例：如 `ClassA`派 生 自`NSObject` 类 , `ClassA *a = [ClassA alloc] init]`;,`[a isKindOfClass:[NSObject class]]` 可以检查出 a 是否是 `NSObject`派生类 的成员,但 `isMemberOfClass` 做不到

### 方法和选择器有何不同

selector是一个方法的名字，method是一个组合体，包含了名字和实现。通过一个selector可以找到方法地址，进而调用一个方法

### isa指针问题

- isa是一个Class 类型的指针。每个实例对象有个isa的指针，他指向对象的类，而Class里也有个isa的指针,，指向meteClass(元类)
- 元类保存了类方法的列表。当类方法被调用时，先会从isa指向查找类方法的实现，如果没有，元类会向他父类查找该方法。同时注意的是:元类(meteClass)也是类，它也是对象
- 元类也有isa指针，它的isa指针最终指向的是一个根元类(root meteClass)。根元类的isa指针指向NSObject，这样形成了一个封闭的内循环

### 如何访问并修改一个类的私有属性

- 一种是通过KVC访问并修改

- 通过runtime访问并修改

### 下面的代码输出什么

```objectivec
@implementation Son : Father
- (id)init {
if (self = [super init]) {
NSLog(@"%@", NSStringFromClass([self class])); // Son
NSLog(@"%@", NSStringFromClass([super class])); // Son
}
return self;
}
@end
/*解析：
self 是类的隐藏参数，指向当前调用方法的这个类的实例
super是一个Magic Keyword，它本质是一个编译器标示符，和self是指向的同一个消息接收者
不同的是：super会告诉编译器，调用class这个方法时，要去父类的方法，而不是本类里的
上面的例子不管调用[self class]还是[super class]，接受消息的对象都是当前 Son *obj 这个对象
*/
```

### new关键字作用是什么

- 向计算机(堆区)申请内存空间

- 初始化实例变量

- 返回所申请空间的首地址

### alloc init和new的区别

- alloc的作用如其英文含义一样，分配内存给对象，使对象不被释放，将地址返回给指针
- init就是为分配好的内存进行初始化
- new和alloc/init在功能上几乎是一致的，分配内存并完成初始化。差别在于，采用new的方式只能采用默认的init方法完成初始化，采用alloc的方式可以用其他定制的初始化方法
- **[Class new]**就相当于调用**[[Class alloc] init]**，一个为隐式调用，一个为显示调用而已

### iOS 方法内局部变量 (对象) 的内存释放

在 `ARC` 环境下, 方法在将要执行结束的时候, 局部变量的指针都会被置为 `nil`, 此时在 `objc_storeStrong` 函数内部, 被局部变量强引用的对象会被执行 `release` 操作. 最终对象是否会被释放还是要取决于是否依旧有其他指针强引用 (比如: 全局变量/属性 等)

### 常见的 Objective-C 的数据类型有那些，和C的基本数据类型有什么区别？

- Objective-C的数据类型有NSString，NSNumber，NSArray，NSMutableArray，NSData等等，这些都是class，创建后便是对象，而C语言的基本数据类型int，只是一定字节的内存空间，用于存放数值
- NSInteger是基本数据类型，并不是NSNumber的子类，当然也不是NSObject的子类。NSInteger是基本数据类型Int或者Long的别名(NSInteger的定义typedef long NSInteger)，它的区别在于，NSInteger会根据系统是32位还是64位来决定是本身是int还是long。

### OC实例变量的修饰符及作用范围

- `@private`，本类可以访问，子类和其他类不可以访问
- `@protected（默认修饰符）`，本类和子类可以访问，其他类不可以访问
- `@package`，对于framework内部相当于`@protected`，对于framework外部相当于`@private`
- `@public` ，本类、子类、其他类都可以访问

### @proprety的本质和作用

- `@property = ivar + getter + setter`
  - 在.h文件自动生成`getter/setter`方法声明
  - 在.m文件生成实例变量和`getter/setter`方法的实现

- 可以手动实现`getter/setter`方法，也可以使用`@synthesize myName = myString`自己指定实例变量

### @proprety修饰符说明

- 原子性：`atomic/nonatomic` 
  - 默认为 `atomic`，系统会自动加上同步锁，影响性能
  
  - 建议使用 `nonatomic`，可以提高访问的性能
- 读写权限`readonly`,`readwrite`
- 指定读写方法`getter`,`setter`
- 内存管理语义`strong`,`assign`,`weak`,`copy`,`unsafe_unretained`
- 是否可以为空`nullable`,`nonnull`,`null_resettable`,`null_unspecified`
- 类属性`class`

### @synthesize 和 @dynamic 分别有什么作用

- @property 有两个对应的词，一个是`@synthesize`，一个是`@dynamic`
- 如果 `@synthesize 和@dynamic`都没写，那么默认的就是`@syntheszie var = _var`
- `@synthesize` 如果你没有手动实现 `getter/setter` 方法，那么编译器会自动为你加上这两个方法
- `@dynamic` 告诉编译器属性的 `getter/setter`方法由用户自己实现，不自动生成(当然对于 readonly 的属性只需提供 getter 即可)

### @synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么

- 如果指定了成员变量的名称,会生成一个指定的名称的成员变量
- 如果这个成员已经存在了就不再生成了
- 如果是 `@synthesize foo;`还会生成一个名称为foo的成员变量，也就是说：`如果没有指定成员变量的名称会自动生成一个属性同名的成员变量`

### 在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景

回答这个问题前，我们要搞清楚一个问题，什么情况下不会autosynthesis（自动合成）？

- 同时重写了 setter 和 getter 时
- 重写了只读属性的 getter 时
- 使用了 @dynamic 时
- 在 @protocol 中定义的所有属性
- 在 category 中定义的所有属性
- 重载的属性

### 实现description方法能取到什么效果

- 当使用log打印该对象或断点po对象时，可以详细的知道该对象的信息，方便代码调试

### ARC下，不显式指定任何属性关键字时，默认的关键字都有哪些

- 基本数据类型: `atomic,readwrite,assign`
- 普通的OC 对象: `atomic,readwrite,strong`

### atomic、nonatomic区别以及作用

- `atomic`与`nonatomic`的主要区别就是系统自动生成的`getter/setter`方法不一样
  - `atomic` 系统自动生成的`getter/setter`方法会进行加锁操作
  - `nonatomic` 系统自动生成的`getter/setter`方法不会进行加锁操作

- **`atomic`不是线程安全的**

  - 系统生成的`getter/setter`方法会进行加锁操作，**注意：**这个锁仅仅保证了`getter/setter`存取方法的线程安全
  - 因为`getter/setter`方法有加锁的缘故，故在别的线程来读写这个属性之前，会先执行完当前操作

  - `atomic` 可以保证多线程访问时候，对象是未被其他线程销毁的(比如:如果当一个线程正在get或set时，又有另一个线程同时在进行release操作，可能会直接crash)

### 什么情况使用 weak 关键字，相比 assign 有什么不同

- 在 ARC 中，在有可能出现循环引用的时候，往往要通过让其中一端使用 `weak` 来解决
- 自身已经对它进行过一次强引用，没有必要再强引用一次，此时也会使用 weak
- **weak 和 assign 的不同点**
  - `weak` 策略在属性所指的对象遭到销毁时，系统会将 `weak` 修饰的属性指向 `nil`，在 `OC` 给 `nil` 发消息是不会有什么问题的
  -  `assign` 策略在属性所指的对象遭到销毁时，`assign`属性还指向原来的对象，由于对象已经被销毁，这时候就产生了野指针，如果这时候再给此对象发送消息，很容造成程序崩溃
  -  `assign` 可以用于修饰非 `OC` 对象，而 `weak` 必须用于 `OC` 对象

### 代理使用 weak 还是 assign

- 建议使用 `weak`，它指明该对象并不负责保持delegate这个对象，delegate这个对象的销毁由外部控制
- 可以使用 `assign`，也有weak的效果，对于使用 assign修饰的delegate，在对象释放前需要将 delegate 指针设置为 nil，不然会产生野指针

### weak 属性需要在 dealloc 中置 nil 么

- 在 ARC 环境无论是强指针还是弱指针都无需在 dealloc 设置为 nil ，ARC 会自动帮我们处理
- 即便是编译器不帮我们做这些，weak 也不需要在 dealloc 中置 nil，在属性所指的对象遭到摧毁时，属性值也会清空

### 怎么用 copy 关键字/用@property声明的NSString（或NSArray，NSDictionary）经常使用copy关键字，为什么？如果改用strong关键字，可能造成什么问题

- `NSString、NSArray、NSDictionary 等等经常使用 copy` 关键字，是因为他们有对应的可变类型：`NSMutableString、NSMutableArray、NSMutableDictionary`，他们之间可能进行赋值操作（就是把可变的赋值给不可变的），为确保对象中的属性值不会无意间变动，应该在设置新属性值时拷贝一份，保护其封装性
  - 因为父类指针可以指向子类对象，使用 copy 的目的是为了让本对象的属性不受外界影响，使用 copy 无论给我传入是一个可变对象还是不可对象，我本身持有的就是一个不可变的副本
  - 如果我们使用是 strong ,那么这个属性就有可能指向一个可变对象,如果这个可变对象在外部被修改了,那么会影响该属性
  - 总之使用copy的目的是，防止把可变类型的对象赋值给不可变类型的对象时，可变类型对象的值发送变化会无意间篡改不可变类型对象原来的值
- `block` 也经常使用 `copy` 关键字，方法内部的 `block` 默认是在栈区的，使用 `copy` 可以把它放到堆区
- 在ARC下对于 `block` 使用 `copy` 还是 `strong` 效果是一样的，但是在MRC下，block不会被编译器`copy`到堆区，综合建议写上 `copy`，因为这样显示告知调用者“编译器会自动对 `block` 进行 `copy` 操作

### 如何让自定义类可以用 copy 修饰符，如何重写带 copy 关键字的 setter

- 若想令自己所写的对象具有拷贝功能，需实现 `NSCopying` 协议。如果自定义的对象分为可变版本与不可变版本，那么就要同时实现 `NSCopyiog 与 NSMutableCopying 协议`

  ```objc
  // 实现不可变版本拷贝
  - (id)copyWithZone:(NSZone *)zone; 
  // 实现可变版本拷贝
  - (id)mutableCopyWithZone:(NSZone *)zone;
  // 重写带 copy 关键字的 setter
  - (void)setName:(NSString *)name {
      _name = [name copy];
  }
  ```

### 这个写法会出什么问题：`@property (nonatomic, copy) NSMutableArray *arr`；

- 问题：添加、删除、修改数组内的元素的时候，程序会因为找不到对应的方法而崩溃
- 原因：是因为 copy 就是复制一个不可变 NSArray 的对象，不能对 NSArray 对象进行添加、修改

### 在某个方法中 self.name = _name，name = _name 它 们有区别吗,为什么?

- 前者是存在内存管理的setter方法赋值，它会对_name对象进行保留或者拷贝操作
- 后者是普通的变量赋值

### 解释self = [super init]方法

- 容错处理。当父类初始化失败，会返回一个nil，表示初始化失败。由于继承的关系，子类是需要拥有父类的实例和行为，因此我们必须先初始化父类，然后再初始化子类

### OC中如何定义一个枚举

- 在 OC 中定义一个枚举有三种做法：
  - 因为 OC 是兼容 C 的，所以可以使用 C 语言风格的 enum 进行定义。
  - 使用`NS_ENUM`宏进行定义；
  - 使用`NS_OPTIONS`宏进行定义；
- `NS_ENUM`为定义通用性枚举，只能单选，`NS_OPTIONS`为定义位移枚举，可多选。 // 枚举为啥要这么分？因为涉及到是否使用 C++ 模式进行编译有关

### 说一下OC的反射机制

- OC的反射机制主要是基于OC的Runtime机制，我们主要从三个层面使用反射
- NSObject类集成的一些反射API
- 系统Foundation框架提供了一些方法反射的API
- 使用objc/runtime提供的一些API

### KVC中的集合运算符

- **简单集合操作符** 作用于 array 或者 set 中相对于集合操作符右侧的属性
  - @avg 操作符将集合中属性键路径所指对象转换为 double, 计算其平均值，返回该平均值的 NSNumber 对象。当均值为 nil 的时候，返回 0.

  - @count 操作符返回集合中对象总数的 NSNumber 对象。操作符右边没有键路径。

  - @max 操作符比较由操作符右边的键路径指定的属性值，并返回比较结果的最大值。最大值由指定的键路径所指对象的 compare: 方法决定，因此参加比较的对象必须支持和另一个对象的比较。如果右侧键路径所指对象值为 nil， 则忽略，不影响比较结果。

  - @min 和 @max 一样，但是返回的是集合中的最小值。
  - @sum 返回右侧键路径指定的属性值的总和。每一个比较值都转换为 double，然后计算值的总和，最后返回总和值的 NSNumber 对象。如果右侧键路径所指对象值为 nil，则忽略。

- **对象操作符**
  - @distinctUnionOfObjects 和 @unionOfObjects, 返回一个由操作符右边的 key path 所指定的对象属性组成的数组。其中 @distinctUnionOfObjects 会对数组去重，而 @unionOfObjects 不会。

- **数组和集合操作符** 作用对象是嵌套的集合，也就是说，是一个集合且其内部每个元素是一个集合
  - `@distinctUnionOfArrays / @unionOfArrays` 返回一个数组，其中包含这个集合中每个数组对于这个操作符右面指定的 key path 进行操作之后的值。 distinct 版本会移除重复的值。
  - `@distinctUnionOfSets` 和 @distinctUnionOfArrays 差不多, 但是它期望的是一个包含着 NSSet 对象的 NSSet ，并且会返回一个 NSSet 对象。因为集合不能包含重复的值，所以它只有 distinct 操作。

### 在 **Objective-C **中如何实现 **KVO**

- 注册观察者(`注意：观察者和被观察者不会被保留也不会被释放`)

  ```objectivec
  - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath 
  options:(NSKeyValueObservingOptions)options 
  context:(void *)context; 
  ```

- 接收变更通知
   \- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change   context:(void *)context;

- 移除对象的观察者身份
   \- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

- KVO中`谁要监听谁注册`，然后对响应进行处理，使得观察者与被观察者完全解耦。KVO只检测类中的属性，并且属性名都是通过NSString来查找，编译器不会检错和补全，全部取决于自己

### 给出一个单例的代码实现

- 这里给出一个优雅的实现单例的宏定义

  ```objective-c
  //.h 宏
  #define SINGLETON_DEF(_type_)\
  + (_type_ * _Nullable)sharedInstance;\
  +(instancetype _Nullable) alloc __attribute__((unavailable("call sharedInstance instead")));\
  +(instancetype _Nullable) new __attribute__((unavailable("call sharedInstance instead")));\
  -(instancetype _Nullable) copy __attribute__((unavailable("call sharedInstance instead")));\
  -(instancetype _Nullable) mutableCopy __attribute__((unavailable("call sharedInstance instead")));\
  
  //.m 实现宏
  #define SINGLETON_IMP(_type_)\
  + (_type_ * _Nullable)sharedInstance{\
  static _type_ *theSharedInstance = nil;\
  static dispatch_once_t onceToken;\
  dispatch_once(&onceToken, ^{\
  theSharedInstance = [[super alloc] init];\
  });\
  return theSharedInstance;\
  }
  ```

### 写一个完整的代理，包括声明、实现

```objectivec
// 创建 
@protocol MyDelagate 
@required -(void)eat:(NSString *)foodName; 
@optional -(void)run;
@end 
  
//  声明 .h
@interface person: NSObject<MyDelagate>
@end 
//  实现 .m 
@implementation person 
- (void)eat:(NSString *)foodName { NSLog(@"吃:%@!", foodName);} 
- (void)run { NSLog(@"run!");
}
@end
```

### 浅复制和深复制的区别

- 浅复制：只复制指向对象的指针，而不复制引用对象本身 
- 深复制：复制引用对象本身，会在堆区重新开辟新的内存块
- 通俗的讲：浅复制好比你和你的影子，你完蛋，你的影子也完蛋；深复制好比你和你的克隆人，你完蛋，你的克隆人还活着

### 集合类型的深浅拷贝

|  数据类型  |    copy    | multableCopy |
| :--------: | :--------: | :----------: |
| 不可变类型 |   浅拷贝   |  单层深拷贝  |
|  可变类型  | 单层深拷贝 |  单层深拷贝  |

### 列举出延迟调用的几种方法

- performSelector方法

  `[self performSelector:@selector(Delay) withObject:nil afterDelay:3.0f];`

- NSTimer定时器

  `[NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(Delay) userInfo:nil repeats:NO];`

- sleepForTimeInterval

  `[NSThread sleepForTimeInterval:3.0f];`

- GCD方式

  ```objective-c
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){NSLog(@"delay execute");});
  ```

### 声明一个函数,传入值是一个输入输出参数都是 int的 block 函数

- `- (void)test_Function:(int(^)(int num)) block{}`

### Objective-C 中创建线程的方法是什么？如果在主线程中执行代码，方法是什么？如果想延时执行代码、方法又是什么

线程创建有三种方法：使用NSThread创建、使用GCD的dispatch、使用子类化的NSOperation,然后将其加入NSOperationQueue;在主线程执行代码，方法是performSelectorOnMainThread，如果想延时执行代码可以用performSelector:onThread:withObject:waitUntilDone:

### 类别的作用，继承和类别在实现中有何区别?

- category 可以在不获悉，不改变原来代码的情况下往里面添加新的方法，只能添加，不能删除修改，并且如果类别和原来类中的方法产生名称冲突，则类别将覆盖原来的方法，因为类别具有更高的优先级。类别不能添加实例变量

  类别主要有3个作用：

  - 将类的实现分散到多个不同文件或多个不同框架中

  - 创建对私有方法的前向引用

  - 向对象添加非正式协议

- 继承可以增加，修改或者删除方法，并且可以增加属性

### 如何捕获异常

```objective-c
1. 在app启动时(didFinishLaunchingWithOptions)，添加一个异常捕获的监听
NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
2. 实现捕获异常日志并保存到本地的方法
void UncaughtExceptionHandler(NSException *exception){
    //异常日志获取
    NSArray  *excpArr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *excpCnt = [NSString stringWithFormat:@"exceptionType: %@ \n reason: %@ \n stackSymbols: %@",name,reason,excpArr];
    //日常日志保存（可以将此功能单独提炼到一个方法中）
    NSArray  *dirArr  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dirPath = dirArr[0];
    NSString *logDir = [dirPath stringByAppendingString:@"/CrashLog"];

    BOOL isExistLogDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDir]) {
        isExistLogDir = [fileManager createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (isExistLogDir) {
        //此处可扩展
        NSString *logPath = [logDir stringByAppendingString:@"/crashLog.txt"];
        [excpCnt writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}
```

### BAD_ACCESS在什么情况下出现

这种问题在开发时经常遇到。原因是访问了野指针，比如访问已经释放对象的成员变量或者发消息、死循环等

### 什么是 Method Swizzle（黑魔法），什么情况下会使用

- 在没有一个类的实现源码的情况下，想改变其中一个方法的实现，除了继承它重写、和借助类别重名方法暴力抢先之外，还有更加灵活的方法 Method Swizzle
- Method Swizzle 指的是改变一个已存在的选择器对应的实现的过程。OC中方法的调用能够在运行时通过改变，通过改变类的调度表中选择器到最终函数间的映射关系
- 在OC中调用一个方法，其实是向一个对象发送消息，查找消息的唯一依据是selector的名字。利用OC的动态特性，可以实现在运行时偷换selector对应的方法实现
- 每个类都有一个方法列表，存放着selector的名字和方法实现的映射关系。IMP有点类似函数指针，指向具体的方法实现
- 我们可以利用 method_exchangeImplementations 来交换2个方法中的IMP
- 我们可以利用 class_replaceMethod 来修改类
- 我们可以利用 method_setImplementation 来直接设置某个方法的IMP
- 归根结底，都是偷换了selector的IMP

### 编译过程做了哪些事情

```undefined
* Objective,Swift都是编译语言。编译语言在执行的时候，必须先通过编译器生成机器码，机器码可以直接在CPU上执行，所以执行效率较高。Objective,Swift二者的编译都是依赖于Clang + LLVM. OC和Swift因为原理上大同小异，知道一个即可！
* iOS编译 不管是OC还是Swift，都是采用Clang作为编译器前端,LLVM(Low level vritual machine)作为编译器后端。
* 编译器前端：进行语法分析、语义分析、生成中间代码(intermediate representation )。在这个过程中，会进行类型检查，如果发现错误或者警告会标注出来在哪一行
* 编译器后端：进行机器无关的代码优化，生成机器语言，并且进行机器相关的代码优化。LVVM优化器会进行BitCode的生成，链接期优化等等,LLVM机器码生成器会针对不同的架构，比如arm64等生成不同的机器码。
```

### 应用瘦身(Thinning)

- App Thinning“应用瘦身”,iOS9之后发布的新特性。它能对App store 和操作系统在安装iOS app 的时候通过一些列的优化，尽可能减少安装包的大小，使得 app 以最小的合适的大小被安装到你的设备上。而这个过程包括了三个过程：

```undefined
* slicing
appStore 会根据用户的设备型号创建相应的应用变体,这些变体只包含可执行的结构和资源必要部分,不需要用户下载完整的安装包

* bitcode
bitcode系统会对编译后的二进制文件进行二次优化, 使用最新的编译器自动编译app并且针对特定架构进行优化。不会下载应用针对不同架构的优化，而仅下载与特定设备相关的优化，使得下载量更小，

* On Demand Resources
按需加载资源是在 app 第一次安装后可下载的文件。举例说明，当玩家解锁游戏的特定关卡后可以下载新关卡（和这个关卡相关的特定内容）。此外，玩家已经通过的关卡可以被移除以便节约设备上的存储空间。
```

### **iOS **开发中数据持久性有哪几种?

数据存储的核心都是写文件。

- 属性列表：只有NSString、NSArray、NSDictionary、NSData可writeToFile；存储依旧是plist文件。plist文件可以存储的7中数据类型：array、dictionary、string、bool、data、date、number
- 对象序列化（对象归档）：对象序列化通过序列化的形式，键值关系存储到本地，转化成二进制流。实现NSCoding协议必须实现的两个方法：
   1.编码（对象序列化）：把不能直接存储到plist文件中得到数据，转化为二进制数据，NSData，可以存储到本地；
   2.解码（对象反序列化）：把二进制数据转化为本来的类型。
- SQLite 数据库：大量有规律的数据使用数据库
- CoreData ：通过管理对象进行增、删、查、改操作的。它不是一个数据库，不仅可以使用SQLite数据库来保持数据，也可以使用其他的方式来存储数据。如：XML

### XML数据解析方式各有什么不同，JSON解析有哪些框架？

- XML数据解析的两种解析方式：DOM解析和SAX解析；
- DOM解析必须完成DOM树的构造，在处理规模较大的XML文档时就很耗内存，占用资源较多，读入整个XML文档并构建一个驻留内存的树结构（节点树），通过遍历树结构可以检索任意XML节点，读取它的属性和值，通常情况下，可以借助XPath查询XML节点；
- SAX与DOM不同，它是事件驱动模型，解析XML文档时每遇到一个开始或者结束标签、属性或者一条指令时，程序就产生一个事件进行相应的处理，一边读取XML文档一边处理，不必等整个文档加载完才采取措施，当在读取解析过程中遇到需要处理的对象，会发出通知进行处理。因此，SAX相对于DOM来说更适合操作大的XML文档。
   -JSON解析：性能比较好的主要是第三方的JSONKIT和iOS自带的JSON解析类，其中自带的JSON解析性能最高，但只能用于iOS5之后

### 说一下iOS 中的APNS,远程推送原理

- `Apple push Notification Service`,简称 `APNS`,是苹果的远程消息推送,原理如下:
  - iOS 系统向苹果的APNS服务器请求手机端的`deviceToken`
  - App接收到手机端的deviceToken，然后通过接口传递给服务器
  - App服务器需要发送推送消息时，构建消息体完成后，将消息体、需要接收推送的用户的devicetokens传递给APNS 服务器
  - APNS 服务器根据对应的 deviceToken 发送到用户的手机上

### 如何进行真机调试

- 1.首先需要用`钥匙串`创建一个钥匙（key）；
- 2.将钥匙串上传到官网，获取iOS Development证书；
- 3.创建App ID即我们应用程序中的Boundle ID；
- 4.添加Device ID即UDID；
- 5.通过勾选前面所创建的证书：App ID、Device ID；
- 6.生成mobileprovision文件；
- 7.先决条件：申请开发者账号  99美刀

### APP发布的上架流程

- 1.登录[应用发布网站](https://itunesconnect.apple.com)添加应用信息；
- 2.下载安装发布证书；
- 3.选择发布证书，使用Archive编译发布包，用Xcode将代码（发布包）上传到服务器；
- 4.等待审核通过;
- 5.生成IPA：菜单栏->Product->Archive.

### 对沙盒的理解

- 每个iOS应用都被限制在“沙盒”中，沙盒相当于一个加了仅主人可见权限的文件夹，及时在应用程序安装过程中，系统为每个单独的应用程序生成它的主目录和一些关键的子目录。苹果对沙盒有几条限制:

  - 应用程序在自己的沙盒中运作，但是不能访问任何其他应用程序的沙盒；

  - 应用之间不能共享数据，沙盒里的文件不能被复制到其他应用程序的文件夹中，也不能把其他应用文件夹复制到沙盒中；

  - 苹果禁止任何读写沙盒以外的文件，禁止应用程序将内容写到沙盒以外的文件夹中；

  - 沙盒目录里有三个文件夹：
    - Documents：存储应用程序的数据文件，存储用户数据或其他定期备份的信息；会被ITunes备份
    - Library下有两个文件夹，
      - Caches用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息
      - Preferences包含应用程序的偏好设置文件，不可在这更改偏好设置；NSUserDefault就是操作的这部分
    - Library下可创建子文件夹。可以用来放置您希望被备份但不希望被用户看到的数据。该路径下的文件夹，除Caches以外，都会被iTunes备份
    - tmp存放临时文件即应用程序再次启动不需要的文件，不会被ITunes备份

- 获取沙盒根目录的方法，有几种方法：用NSHomeDirectory获取

- 获取Document路径：
   `NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)`.