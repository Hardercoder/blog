Flutter支持JIT和AOT两种编译模式，开发阶段使用JIT模式，方便亚秒级热重载，release阶段使用AOT提高性能

Flutter的热重载基于State，修改state后，会执行build方法



Flutter中所有的视图都是Widget，包括显示的、操作的、布局的

设计界面时，组合大于继承

Widget分为StatelessWidget和StatefulWidget两种，StatefulWidget本质上也是无状态的，只不过通过State处理Widget的状态，当数据发生变化时由State去处理视图的改变。



#### Flutter开发

**启动函数**：main方法是Flutter程序执行的入口，runApp会将传入的Widget作为根进行全屏展示

**生命周期**：向Binding添加一个Observer，实现didChangeAppLifeCycle方法，监听原生的App生命周期

- `WidgetsBinding.instance.addObserver(this)`

**矩阵变换**：使用Transform Widget包裹Widget即可

**页面导航**：使用Navigator和Routers来实现导航栈管理。Routers被Navigator管理着

- 直接跳转到某个Widget页面
- 注册一个map，根据key跳转对应的Widget页面

Flutter的依赖包放在pubspec.yaml文件中



#### 常用的开源项目

https://juejin.cn/post/6844904008830681101



#### FlutterUI绘制原理

https://juejin.cn/post/6844903794627575822

Flutter UI有三大元素：**Widget、Element、RenderObject**。对应这三者也有三个owner负责管理他们，分别是**WidgetOwner、BuildOwner、PipelineOwner**

WidgetOwner会给BuildOwner发送一个WidgetTree，首次的计划表（WidgetTree）会生成一个与之对应的ElementTree，并生成对应的RenderObjectTree



#### Widget、Element、RenderObject之间的关系

所有的Widget子类都有三个关键的能力：

1. 保证自身唯一以及定位的 `Key`
2.  创建Element的 `createElement`
3. 指示是否需要更新的 `canUpdate`

有一个极其特殊的，可以有渲染能力的`RenderObjectWidget`，它有一个创建RenderObject的`createRenderObject`方法

**Element和RenderObject都是Widget创建出来的，也并不是每一个Widget都有与之对应的RenderObjectWidget**



**Flutter 是 UI 框架，Flutter 内一切皆 `Widget` ，每个 `Widget` 状态都代表了一帧，`Widget` 是不可变的**

- `Widget` 是配置文件。
- `Element` 是桥梁和仓库。
- `RenderObject` 是解析后的绘制和布局

**我们写的 `Widget`，需要转化为相应的 `RenderObject` 去工作；**

`Element` 持有 `Widget` 和  `RenderObject` ，作为两者的桥梁，并保存着一些状态参数，**我们在 Flutter 框架中常见到的 `BuildContext` ，其实就是 `Element` 的抽象** ；

最后框架会将 `Widget` 的配置信息，转化到 `RenderObject` 内，告诉 `Canvas` 应该在哪个 `Rect` 内，绘制多大 `Size` 的数据

总结个面试点：

- 同一个 `Widget` 可以同时描述多个渲染树中的节点，**作为配置文件是可以复用的。 `Widget` 和 `RenderObject` 一般情况是一对多的关系。** （ 前提是在 `Widget` 存在 `RenderObject` 的情况。）
- `Element` 是 `Widget` 的某个固定实例，与 `RenderObject` 一一对应。（前提是在 `Element` 存在 `RenderObject` 的情况。）
- `RenderObject` 内 `isRepaintBoundary` 标示使得它们组成了一个个 `Layer` 区域









#### Widget、Element、RenderObject 的第一次创建与关联

1. `attachRootWidget(app)` 方法创建了Root[Widget]（也就是 RenderObjectToWidgetAdapter）
2. 紧接着调用`attachToRenderTree`方法创建了 Root[Element]
3. Root[Element]尝试调用`mount`方法将自己挂载到父Element上，因为自己就是root了，所以没有父Element，挂空了
4. mount的过程中会调用Widget的`createRenderObject`,创建了 Root[RenderObject]

它的child，也就是我们传入的app是怎么挂载父控件上的呢？

5. 我们将app作为参数传给了Root[Widget]（也就是 RenderObjectToWidgetAdapter），app[Widget]也就成了为root[Widget]的child[Widget]
6. 调用`owner.buildScope`，开始执行子Tree的创建以及挂载！这中间的流程和WidgetTree的刷新流程是一模一样的
7. 调用`createElement`方法创建出Child[Element]
8. 调用Element的`mount`方法,将自己挂载到Root[Element]上，形成一棵树
9. 挂载的同时，调用`widget.createRenderObject`,创建Child[RenderObject]
10. 创建完成后，调用`attachRenderObject`,完成和Root[RenderObject]的链接



#### Flutter刷新

##### Element的复用

1. #### Element标记自身为dirty，并调用owner.scheduleBuildFor(this)通知buildOwner处理

2. #### buildOwner将element添加到集合_dirtyElements中，并通知ui.window安排新的一帧，调用ui.window.scheduleFrame()

3. #### 底层引擎最终回调到Dart层，并执行buildOwner的buildScope方法

   1. ##### 按照Element的深度从小到大，对_dirtyElements进行排序

   2. ##### 遍历执行_dirtyElements当中element的rebuild方法，element的rebuild方法最终会调用`performRebuild()`

   3. ##### 遍历结束之后，清空dirtyElements集合

4. #### 执行performRebuild()

##### PipelineOwner对RenderObject的管理



















