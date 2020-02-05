[TOC]

#### 什么是设计模式

- 设计模式（Design Pattern）
  - 是一套被反复使用、代码设计经验的总结
  - 使用设计模式的好处是：可重用代码、让代码更容易被他人理解、保证代码可靠性
  - 一般与编程语言无关，是一套比较成熟的编程思想
- 设计模式可以分为三大类
  - 创建型模式：对象实例化的模式，用于解耦对象的实例化过程
    - 单例模式、工厂方法模式等等
  - 结构型模式：把类或对象结合在一起形成一个更大的结构
    - 代理模式、适配器模式、组合模式、装饰模式，等等
  - 行为型模式：类或对象之间如何交互，及划分责任和算法
    - 观察者模式、命令模式、责任链模式等等

#### iOS有哪些常见的设计模式

- 单例模式：单例保证了应用程序的生命周期内仅有一个该类的实例对象，而且易于外界访问。在iOS SDK中UIApplication、NSBundle、NSNotificationCenter、NSFileManager、NSUserDefault、NSURLCache等都是单例
- 委托模式：委托Delegate是协议的一种，通过@protocol方式实现，常见的有tableView、textField等
- 观察者模式：观察者模式定义了一种一对多的依赖关系，让多个观察者对象同时监听某一个主题对象。在iOS中，观察者模式的具体实现有两种：通知机制(notification)和KVO机制(Key-value Observing)

#### 单例会有什么优缺点

- 主要优点：
  - 提供了对唯一实例的受控访问
  - 由于在系统内存中只存在一个对象，因此可以节约系统资源，对于一些需要频繁创建和销毁的对象。单例模式无疑可以提高系统的性能
  - 允许可变数目的实例
- 主要缺点：
  - 由于单利模式中没有抽象层，因此单例类的扩展有很大的困难
  - 单例类的职责过重，在一定程度上违背了“单一职责原则”
  - 滥用单例将带来一些负面问题，如为了节省资源将数据库连接池对象设计为的单例类，可能会导致共享连接池对象的程序过多而出现连接池溢出；如果实例化的对象长时间不被利用，系统会认为是垃圾而被回收，这将导致对象状态的丢失

#### 编程中的六大设计原则

- 单一职责原则

  - 通俗地讲就是一个类只做一件事

  - CALayer：动画和视图的显示
  - UIView：只负责事件传递、事件响应

- 开闭原则

  - 对修改关闭，对扩展开放。 要考虑到后续的扩展性，而不是在原有的基础上来回修改

- 接口隔离原则

  - 使用多个专门的协议、而不是一个庞大臃肿的协议，如 UITableviewDelegate + UITableViewDataSource

- 依赖倒置原则

  - 抽象不应该依赖于具体实现、具体实现可以依赖于抽象。 调用接口感觉不到内部是如何操作的

- 里氏替换原则

  - 父类可以被子类无缝替换，且原有的功能不受任何影响 如：KVO

- 迪米特法则

  - 一个对象应当对其他对象尽可能少的了解，实现高内聚、低耦合

#### 讲一下MV(X)；V视图(包括vc),M业务数据,X(C,VM,P)业务逻辑的处理者,作为M、V的桥梁

- **MVC**

![](./reviewimgs/objc_mvx_mvc)

- **iOS开发实际应用时的MVC**

![](./reviewimgs/objc_mvx_mvc_oc1)

![](./reviewimgs/objc_mvx_mvc_oc0)

- **MVP**

![](./reviewimgs/objc_mvx_mvp)

跟MVC相比，我们把所有view相关的东西都化作view模块，其余的逻辑放到一个模块，于是就有了MVP

- **MVVM**

![](./reviewimgs/objc_mvx_mvvm)

- **VIPER**

![](./reviewimgs/objc_mvx_viper)VIPER对职责划分了5个模块。

- View(页面) - 展示给用户的界面
- Interactor（交互器） - 包括数据（Entities）或者网络相关的业务逻辑。
- Presenter（展示器） - 包括 UI（but UIKit independent）相关的业务逻辑，可以调用 Interactor 中的方法。
- Entities（实体） - 纯粹的数据对象。不包括数据访问层，因为这是 Interactor 的职责。
- Router（路由） - 负责 VIPER 模块之间的转场

[详情请看这篇文章](https://blog.coding.net/blog/ios-architecture-patterns)

