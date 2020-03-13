Widget描述了他们的视图在给定其当前配置和状态时应该看起来像什么，他像是一个配置文件



flutter main函数中的runApp函数只需要一个Widget作为参数即可，它会把这个widget作为渲染的根。框架强制根widget覆盖整个屏幕

目前渲染结构基本上都是一颗树，一棵树至少要有一个根，runApp的目的就是使用入参作为树的根。



widget的主要工作是实现一个[`build`](https://docs.flutter.io/flutter/widgets/StatelessWidget/build.html)函数，用以构建自身



**Widget是临时对象，用于构建当前状态下的应用程序，而State对象在多次调用[`build()`](https://docs.flutter.io/flutter/widgets/State/build.html)之间保持不变，允许它们记住信息(状态)**

在Flutter中，事件流是“向上”传递的，而状态流是“向下”传递的（译者语：这类似于React/Vue中父子组件通信的方式：子widget到父widget是通过事件通信，而父到子是通过状态），重定向这一流程的共同父元素是State



在StatefulWidget调用`createState`之后，框架将新的状态对象插入树中，然后调用状态对象的[`initState`](https://docs.flutter.io/flutter/widgets/State-class.html#initState)。 子类化State可以重写[`initState`](https://docs.flutter.io/flutter/widgets/State-class.html#initState)，以完成仅需要执行一次的工作。initState`的实现中需要调用`super.initState

当一个状态对象不再需要时，框架调用状态对象的[`dispose`](https://docs.flutter.io/flutter/widgets/State-class.html#dispose)。 您可以覆盖该[`dispose`](https://docs.flutter.io/flutter/widgets/State-class.html#dispose)方法来执行清理工作。例如，您可以覆盖[`dispose`](https://docs.flutter.io/flutter/widgets/State-class.html#dispose)取消定时器或取消订阅platform services。 `dispose`典型的实现是直接调用[`super.dispose`](https://docs.flutter.io/flutter/widgets/State-class.html#dispose)



可以使用key来控制框架将在widget重建时与哪些其他widget匹配。默认情况下，框架根据它们的[`runtimeType`](https://docs.flutter.io/flutter/widgets/Widget-class.html#runtimeType)和它们的显示顺序来匹配。 使用[`key`](https://docs.flutter.io/flutter/widgets/Widget-class.html#key)时，框架要求两个widget具有相同的[`key`](https://docs.flutter.io/flutter/widgets/Widget-class.html#key)和[`runtimeType`](https://docs.flutter.io/flutter/widgets/Widget-class.html#runtimeType)。

Key在构建相同类型widget的多个实例时很有用。例如，`ShoppingList`构建足够的`ShoppingListItem`实例以填充其可见区域：

- 如果没有key，当前构建中的第一个条目将始终与前一个构建中的第一个条目同步，即使在语义上，列表中的第一个条目如果滚动出屏幕，那么它将不会再在窗口中可见。
- 通过给列表中的每个条目分配为“语义” key，无限列表可以更高效，因为框架将同步条目与匹配的语义key并因此具有相似（或相同）的可视外观。 此外，语义上同步条目意味着在有状态子widget中，保留的状态将附加到相同的语义条目上，而不是附加到相同数字位置上的条目



可以使用全局key来唯一标识子widget。全局key在整个widget层次结构中必须是全局唯一的，这与局部key不同，后者只需要在同级中唯一。由于它们是全局唯一的，因此可以使用全局key来检索与widget关联的状态















