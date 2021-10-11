[TOC]

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



Widget 只是一个配置且无法修改，而 Element 才是真正被使用的对象，并可以修改。

当新的 Widget 到来时将会调用 canUpdate 方法，来确定这个 Element是否需要更新。

canUpdate 对两个（新老） Widget 的 runtimeType 和 key 进行比较，从而判断出当前的 Element 是否需要更新。若 canUpdate 方法返回 true 说明不需要替换 Element，直接更新 Widget 就可以了



###### 使用主题

主题分为全局主题和局部主题，全局主题是MaterialApp创建的主题，局部主题是我们使用ThemeData自定义的主题，我们可以自己创建ThemeData，或者我们也可以继承主题，只修改特定的部分，使用copyWith实现，然后传递给Theme这个Widget。主题使用具有继承性

`Theme.of(context)`将查找Widget树并返回树中最近的`Theme`。如果我们的Widget之上有一个单独的`Theme`定义，则返回该值。如果不是，则返回App主题。

###### 展示图片

Image.network直接拉取网络图片进行展示，不可以放置placeholder

`FadeInImage`适用于任何类型的图片：内存、本地Asset或来自网上的图片

cached_image_network包在加载时还支持占位符和淡入淡出图片

###### 列表创建

列表使用ListView创建，少量的可以使用构造方法，批量的使用builder方法。如果需要创建网格的显示，可以使用GridView处理

###### 处理手势

使用GestureDector这个Widget，它里面封装了N多的手势回调。

InkWell可以实现点击的水波动画

Dismissable可以实现滑动删除的效果

###### 导航栈

使用Navigator实现，它的push方法需要一个route，这个route我们可以自己创建，也可以使用MaterialPageRoute创建。每个页面也都是一个widget

需要传到下一个页面值时，只需要将参数传递到页面widget参数中

需要反向传值时，可以在pop方法的第二个参数里面带回来。但是这样push时就需要await了

###### 从网络获取数据

使用http包获取数据，因为网络都是异步的，所以它的返回值都是Future对象。需要先使用convert转换为map，然后再从map转换为我们自己的model。一般情况下我们还会使用FutureBuilder这个Widget来帮助我们更好的监听网络的状态，它需要一个future（网络返回的对象），一个builder可以根据不同网络状态来渲染ui

可以使用dio提供的网络请求方法

网络授权可以使用简单的header字段，HttpHeaders.authorizationHeader

关于web_socket,[web_socket_channel](https://pub.dartlang.org/packages/web_socket_channel) package 提供了我们需要连接到WebSocket服务器的工具



###### flutter中的布局

对其widget可以使用Row/Column的mainAxisAlignment和crossAxisAlignment

调整填充的话可以使用Expanded，可以设置flex来分配布局空间

如果需要聚集子Widgets可以使用mainAsixSize为MainAxisSize.min

一些常用的widget

**标准 widgets**

- - [Container](https://flutterchina.club/tutorials/layout/#container)

    添加 padding, margins, borders, background color, 或将其他装饰添加到widget.

- - [GridView](https://flutterchina.club/tutorials/layout/#gridview)

    将 widgets 排列为可滚动的网格.

- - [ListView](https://flutterchina.club/tutorials/layout/#listview)

    将widget排列为可滚动列表

- - [Stack](https://flutterchina.club/tutorials/layout/#stack)

    将widget重叠在另一个widget之上.

**Material Components**

- - [Card](https://flutterchina.club/tutorials/layout/#card)

    将相关内容放到带圆角和投影的盒子中。

- - [ListTile](https://flutterchina.club/tutorials/layout/#listtile)

    将最多3行文字，以及可选的行前和和行尾的图标排成一行

###### flutter添加交互

管理状态的原则

- 如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父widget管理
- 如果所讨论的状态是有关界面外观效果的，例如动画，那么状态最好由widget本身来管理.

可交互的Widgets列表

**标准 widgets:**

- [Form](https://docs.flutter.io/flutter/widgets/Form-class.html)
- [FormField](https://docs.flutter.io/flutter/widgets/FormField-class.html)

**Material Components:**

- [Checkbox](https://docs.flutter.io/flutter/material/Checkbox-class.html)
- [DropdownButton](https://docs.flutter.io/flutter/material/DropdownButton-class.html)
- [FlatButton](https://docs.flutter.io/flutter/material/FlatButton-class.html)
- [FloatingActionButton](https://docs.flutter.io/flutter/material/FloatingActionButton-class.html)
- [IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html)
- [Radio](https://docs.flutter.io/flutter/material/Radio-class.html)
- [RaisedButton](https://docs.flutter.io/flutter/material/RaisedButton-class.html)
- [Slider](https://docs.flutter.io/flutter/material/Slider-class.html)
- [Switch](https://docs.flutter.io/flutter/material/Switch-class.html)
- [TextField](https://docs.flutter.io/flutter/material/TextField-class.html)

###### flutter for iOS tips

1. widgets 拥有不同的生存时间：它们一直存在且保持不变，直到当它们需要被改变。当 widgets 和它们的状态被改变时，Flutter 会构建一颗新的 widgets 树。作为对比，iOS 中的 views 在改变时并不会被重新创建。但是与其说 views 是可变的实例，不如说它们被绘制了一次，并且直到使用 `setNeedsDisplay()` 之后才会被重新绘制

2. 如果一个 widget 在它的 `build` 方法之外改变（例如，在运行时由于用户的操作而改变），它就是有状态的。如果一个 widget 在一次 build 之后永远不变，那它就是无状态的

3. 在 Flutter 中，使用动画库来包裹 widgets，而不是创建一个动画 widget。在 Flutter 中，使用 `AnimationController`，它需要一个 `Ticker` 当 vsync 发生时来发送信号，并且在每帧运行时创建一个介于 0 和 1 之间的线性插值（interpolation

4. Flutter 有一套基于 `Canvas` 类的不同的 API，还有 `CustomPaint` 和 `CustomPainter` 这两个类来帮助你绘图

5. Dart 是单线程执行模型，但是它支持 `Isolate`（一种让 Dart 代码运行在其他线程的方式）、事件循环和异步编程。除非你自己创建一个 `Isolate` ，否则你的 Dart 代码永远运行在 UI 线程，并由 event loop 驱动。Flutter 的 event loop 和 iOS 中的 main loop 相似——`Looper` 是附加在主线程上的

6. 由于 Flutter 是单线程并且跑着一个 event loop 的（就像 Node.js 那样），你不必为线程管理或是开启后台线程而操心。如果你正在做 I/O 操作，如访问磁盘或网络请求，安全地使用 `async` / `await` 就完事了。如果，在另外的情况下，你需要做让 CPU 执行繁忙的计算密集型任务，你需要使用 `Isolate` 来避免阻塞 event loop

7. Isolates 是分离的运行线程，并且不和主线程的内存堆共享内存。这意味着你不能访问主线程中的变量，或者使用 `setState()` 来更新 UI。正如它们的名字一样，Isolates 不能共享内存

8. 被放到 iOS 中 `Images.xcasset` 文件夹下的资源在 Flutter 中被放到了 assets 文件夹中。assets 可以是任意类型的文件，而不仅仅是图片。在代码中使用 [`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html) 来访问它

9. 对于图片，Flutter 像 iOS 一样，遵循了一个简单的基于像素密度的格式。Image assets 可能是 `1.0x` `2.0x` `3.0x` 或是其他的任何倍数。这些所谓的 [`devicePixelRatio`](https://docs.flutter.io/flutter/dart-ui/Window/devicePixelRatio.html) 传达了物理像素到单个逻辑像素的比率

10. 不像 iOS 拥有一个 `Localizable.strings` 文件，Flutter 目前并没有一个用于处理字符串的系统。目前，最佳实践是把你的文本拷贝到静态区，并在这里访问。默认情况下，Flutter 只支持美式英语字符串。如果你要支持其他语言，请引入 `flutter_localizations` 包。你可能也要引入  [`intl`](https://pub.dartlang.org/packages/intl) 包来支持其他的 i10n 机制。要使用 `flutter_localizations` 包，还需要在 app widget 中指定 `localizationsDelegates` 和 `supportedLocales`。当初始化时，`WidgetsApp` 或 `MaterialApp` 会使用你指定的代理为你创建一个  [`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html) widget。`Localizations` widget 可以随时从当前上下文中访问设备的地点，或者使用 [`Window.locale`](https://docs.flutter.io/flutter/dart-ui/Window/locale.html)。要访问本地化文件，使用 `Localizations.of()` 方法来访问提供代理的特定本地化类。如需翻译，使用  [`intl_translation`](https://pub.dartlang.org/packages/intl_translation) 包来取出翻译副本到 [arb](https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification) 文件中。把它们引入 App 中，并用 `intl` 来使用它们

11. 可以通过 hook `WidgetsBinding` 观察者来监听生命周期事件，并监听 `didChangeAppLifecycleState()` 的变化事件。

    可观察的生命周期事件有：

    - `inactive` - 应用处于不活跃的状态，并且不会接受用户的输入。这个事件仅工作在 iOS 平台，在 Android 上没有等价的事件。
    - `paused` - 应用暂时对用户不可见，虽然不接受用户输入，但是是在后台运行的。
    - `resumed` - 应用可见，也响应用户的输入。
    - `suspending` - 应用暂时被挂起，在 iOS 上没有这一事件

12. 在 Flutter 中，如果你想通过 `setState()` 方法来更新 widget 列表，你会很快发现你的数据展示并没有变化。这是因为当 `setState()` 被调用时，Flutter 渲染引擎会去检查 widget 树来查看是否有什么地方被改变了。当它得到你的 `ListView` 时，它会使用一个 `==` 判断，并且发现两个 `ListView` 是相同的。没有什么东西是变了的，因此更新不是必须的

13. 在 Flutter 中，有两种方法来添加点击监听者：

    1. 如果 widget 本身支持事件监测，直接传递给它一个函数，并在这个函数里实现响应方法
    2. 如果 widget 本身不支持事件监测，则在外面包裹一个 GestureDetector，并给它的 onTap 属性传递一个函数

14. 在 iOS 中，你在项目中引入任意的 `ttf` 文件，并在 `info.plist` 中设置引用。在 Flutter 中，在文件夹中放置字体文件，并在 `pubspec.yaml` 中引用它，就像添加图片那样

15. 如果你有一个 `TextField` 或是 `TextFormField`，你可以通过 [`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html) 来获得用户输入。可以轻易地通过向 Text widget 的装饰构造器参数重传递 `InputDecoration` 来展示“小提示”，或是占位符文字

16. 平台管道本质上是一个异步通信机制，桥接了 Dart 代码和宿主 ViewController，以及它运行于的 iOS 框架。除了直接使用平台管道之外，你还可以使用一系列预先制作好的 [plugins](https://flutter.io/using-packages/)



###### flutter中的手势

1. Flutter中的手势系统有两个独立的层。第一层有原始指针(pointer)事件，它描述了屏幕上指针（例如，触摸，鼠标和触控笔）的位置和移动。 第二层有手势，描述由一个或多个指针移动组成的语义动作

2. **Pointers**，需要使用Listener Widget包裹

   指针(Pointer)代表用户与设备屏幕交互的原始数据。有四种类型的指针事

   - [`PointerDownEvent`](https://docs.flutter.io/flutter/gestures/PointerDownEvent-class.html) 指针接触到屏幕的特定位置
   - [`PointerMoveEvent`](https://docs.flutter.io/flutter/gestures/PointerMoveEvent-class.html) 指针从屏幕上的一个位置移动到另一个位置
   - [`PointerUpEvent`](https://docs.flutter.io/flutter/gestures/PointerUpEvent-class.html) 指针停止接触屏幕
   - [`PointerCancelEvent`](https://docs.flutter.io/flutter/gestures/PointerCancelEvent-class.html) 指针的输入事件不再针对此应用（事件取消）

   在指针按下时，框架对您的应用程序执行_命中测试_，以确定指针与屏幕相接的位置存在哪些widget。 指针按下事件（以及该指针的后续事件）然后被分发到由_命中测试_发现的最内部的widget。 从那里开始，这些事件会冒泡在widget树中向上冒泡，这些事件会从最内部的widget被分发到到widget根的路径上的所有小部件（译者语：这和web中事件冒泡机制相似）， 没有机制取消或停止冒泡过程(译者语：这和web不同，web中的时间冒泡是可以停止的)。

   要直接从widget层监听指针事件，可以使用[`Listener`](https://docs.flutter.io/flutter/widgets/Listener-class.html)widget。 但是，通常，请考虑使用手势

   **手势**

   手势表示可以从多个单独的指针事件（甚至可能是多个单独的指针）识别的语义动作（例如，轻敲，拖动和缩放）。 完整的一个手势可以分派多个事件，对应于手势的生命周期（例如，拖动开始，拖动更新和拖动结束）：

   - Tap
     - `onTapDown` 指针已经在特定位置与屏幕接触
     - `onTapUp` 指针停止在特定位置与屏幕接触
     - `onTap` tap事件触发
     - `onTapCancel` 先前指针触发的`onTapDown`不会在触发tap事件
   - 双击
     - `onDoubleTap` 用户快速连续两次在同一位置轻敲屏幕.
   - 长按
     - `onLongPress` 指针在相同位置长时间保持与屏幕接触
   - 垂直拖动
     - `onVerticalDragStart` 指针已经与屏幕接触并可能开始垂直移动
     - `onVerticalDragUpdate` 指针与屏幕接触并已沿垂直方向移动.
     - `onVerticalDragEnd` 先前与屏幕接触并垂直移动的指针不再与屏幕接触，并且在停止接触屏幕时以特定速度移动
   - 水平拖动
     - `onHorizontalDragStart` 指针已经接触到屏幕并可能开始水平移动
     - `onHorizontalDragUpdate` 指针与屏幕接触并已沿水平方向移动
     - `onHorizontalDragEnd` 先前与屏幕接触并水平移动的指针不再与屏幕接触，并在停止接触屏幕时以特定速度移动

   要从widget层监听手势，请使用 [`GestureDetector`](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html).

   如果您使用的是Material Components，那么大多数widget已经对tap或手势做出了响应。 例如 [IconButton](https://docs.flutter.io/flutter/material/IconButton-class.html)和 [FlatButton](https://docs.flutter.io/flutter/material/FlatButton-class.html) 响应presses（taps），[`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html)响应滑动事件触发滚动。 如果您不使用这些widget，但想要在点击时上出现“墨水飞溅”效果，可以使用[`InkWell`](https://docs.flutter.io/flutter/material/InkWell-class.html)。

   **手势消歧**

   在屏幕上的指定位置，可能会有多个手势检测器。所有这些手势检测器在指针事件流经过并尝试识别特定手势时监听指针事件流。 [`GestureDetector`](https://docs.flutter.io/flutter/widgets/GestureDetector-class.html)widget决定是哪种手势。

   当屏幕上给定指针有多个手势识别器时，框架通过让每个识别器加入一个“手势竞争场”来确定用户想要的手势。“手势竞争场”使用以下规则确定哪个手势胜出

   - 在任何时候，识别者都可以宣布失败并离开“手势竞争场”。如果在“竞争场”中只剩下一个识别器，那么该识别器就是赢家
   - 在任何时候，识别者都可以宣布胜利，这会导致胜利，并且所有剩下的识别器都会失败

###### flutter动画

Flutter中的动画系统基于[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html)对象的，widget可以在`build`函数中读取[`Animation`](https://docs.flutter.io/flutter/animation/Animation-class.html)对象的当前值， 并且可以监听动画的状态改变，使用Listeners或者StatusListeners

Flutter中的**Animation**对象是一个在一段时间内依次生成一个区间之间值的类。Animation对象的输出可以是线性的、曲线的、一个步进函数或者任何其他可以设计的映射。 根据Animation对象的控制方式，动画可以反向运行，甚至可以在中间切换方向。

Animation还可以生成除double之外的其他类型值，如：Animation<Color> 或 Animation<Size>。

Animation对象有状态。可以通过访问其`value`属性获取动画的当前值。

Animation对象本身和UI渲染没有任何关系



**CurvedAnimation**和AnimationController都是Animation<double>类型。CurvedAnimation包装它正在修改
的对象 - 您不需要子类AnimationController来实现曲线



**AnimationController**是一个特殊的Animation对象，在屏幕刷新的每一帧，就会生成一个新的值。默认情况下，AnimationController在给定的时间段内会线性的生成从0.0到1.0的数字

AnimationController派生自Animation<double>，因此可以在需要Animation对象的任何地方使用。 但是，AnimationController具有控制动画的其他方法,数字的产生与屏幕刷新有关，因此每秒钟通常会产生60个数字，在**生成每个数字后，每个Animation对象调用添加的Listener对象**

当创建一个AnimationController时，需要传递一个`vsync`参数，存在`vsync`时会防止屏幕外动画（译者语：动画的UI不在当前屏幕时）消耗不必要的资源。 通过将SingleTickerProviderStateMixin添加到类定义中，可以将stateful对象作为`vsync`的值

译者语：`vsync`对象会绑定动画的定时器到一个可视的widget，所以当widget不显示时，动画定时器将会暂停，当widget再次显示时，动画定时器重新恢复执行，这样就可以避免动画相关UI不在当前屏幕时消耗资源。 如果要使用自定义的State对象作为`vsync`时，请包含`TickerProviderStateMixin`



默认情况下，AnimationController对象的范围从0.0到1.0。如果您需要不同的范围或不同的数据类型，则可以使用**Tween**来配置动画以生成不同的范围或数据类型的值

**Tween是一个无状态(stateless)对象，需要`begin`和`end`值**。Tween的唯一职责就是定义从输入范围到输出范围的映射。输入范围通常为0.0到1.0，但这不是必须的。

**Tween继承自Animatable<T>，而不是继承自Animation<T>**。Animatable与Animation相似，不是必须输出double值

Tween对象不存储任何状态。相反，它提供了`evaluate(Animation animation)`方法将映射函数应用于动画当前值。 Animation对象的当前值可以通过`value()`方法取到



一个Animation对象可以拥有Listeners和StatusListeners监听器，可以用`addListener()`和`addStatusListener()`来添加。 只要动画的值发生变化，就会调用监听器。一个Listener最常见的行为是调用setState()来触发UI重建。动画开始、结束、向前移动或向后移动（如AnimationStatus所定义）时会调用StatusListener

Flutter API提供的关于**AnimatedWidget**的示例包括：AnimatedBuilder、AnimatedModalBarrier、DecoratedBoxTransition、FadeTransition、PositionedTransition、RelativePositionedTransition、RotationTransition、ScaleTransition、SizeTransition、SlideTransition

Flutter API中**AnimatedBuilder**的示例包括: BottomSheet、ExpansionTile、 PopupMenu、ProgressIndicator、RefreshIndicator、Scaffold、SnackBar、TabBar、TextField

###### 盒约束

在Flutter中，widget由其底层的[`RenderBox`](https://docs.flutter.io/flutter/rendering/RenderBox-class.html)对象渲染。 渲染框由它们的父级给出约束，并且在这些约束下调整自身大小。约束由最小宽度、最大宽度和高度组成; 尺寸由特定的宽度和高度组成

通常，按照widget如何处理他们的约束来看，有三种类型的盒子：

- 尽可能大。 例如 [`Center`](https://docs.flutter.io/flutter/widgets/Center-class.html) 和 [`ListView`](https://docs.flutter.io/flutter/widgets/ListView-class.html) 的渲染盒
- 跟随子widget大小。 例如, [`Transform`](https://docs.flutter.io/flutter/widgets/Transform-class.html) 和 [`Opacity`](https://docs.flutter.io/flutter/widgets/Opacity-class.html) 的渲染盒。
- 指定尺寸。 例如, [`Image`](https://docs.flutter.io/flutter/dart-ui/Image-class.html) 和 [`Text`](https://docs.flutter.io/flutter/widgets/Text-class.html)的渲染盒



###### 加载asset

您的应用可以通过[`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html)对象访问其asset 。

有两种主要方法允许从Asset bundle中加载字符串/text（`loadString`）或图片/二进制（load）。

**加载文本assets**

每个Flutter应用程序都有一个[`rootBundle`](https://docs.flutter.io/flutter/services/rootBundle.html)对象， 可以轻松访问主资源包。可以直接使用`package:flutter/services.dart`中全局静态的`rootBundle`对象来加载asset。

但是，建议使用[`DefaultAssetBundle`](https://docs.flutter.io/flutter/widgets/DefaultAssetBundle-class.html)来获取当前BuildContext的AssetBundle。 这种方法不是使用应用程序构建的默认asset bundle，而是使父级widget在运行时替换的不同的AssetBundle，这对于本地化或测试场景很有用。

通常，可以使用`DefaultAssetBundle.of()`从应用运行时间接加载asset



一个route是一个屏幕或页面的抽象，Navigator是管理route的Widget。Navigator可以通过route入栈和出栈来实现页面之间的跳转



### 布局规则

首先，上层 widget 向下层 widget 传递约束条件；
然后，下层 widget 向上层 widget 传递大小信息。
最后，上层 widget 决定下层 widget 的位置。







































