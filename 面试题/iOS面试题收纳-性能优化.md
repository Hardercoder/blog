在性能优化中一个最具参考价值的属性是FPS:Frames Per Second,其实就是屏幕刷新率，苹果的iphone推荐的刷新率是60Hz，也就是说GPU每秒钟刷新屏幕60次，这每刷新一次就是一帧frame，FPS也就是每秒钟刷新多少帧画面。静止不变的页面FPS值是0，这个值是没有参考意义的，只有当页面在执行动画或者滑动的时候，FPS值才具有参考价值，FPS值的大小体现了页面的流畅程度高低，当低于45的时候卡顿会比较明显。

**图层混合：**

每一个layer是一个纹理，所有的纹理都以某种方式堆叠在彼此的顶部。对于屏幕上的每一个像素，GPU需要算出怎么混合这些纹理来得到像素RGB的值。

当Sa = 0.5时，RGB值为(0.5, 0, 0)，可以看出，当两个不是完全不透明的CALayer覆盖在一起时,GPU大量做这种复合操作，随着这中操作的越多，GPU越忙碌，性能肯定会受到影响。

**公式：**

R = S + D * ( 1 – Sa )

结果的颜色是源色彩(顶端纹理)+目标颜色(低一层的纹理)*(1-源颜色的透明度)。

当Sa = 1时，R = S,GPU将不会做任何合成，而是简单从这个层拷贝，不需要考虑它下方的任何东西(因为都被它遮挡住了)，这节省了GPU相当大的工作量。

#### 一、入门级

1、用ARC管理内存
 2、在正确的地方使用 reuseIdentifier
 3、尽量把views设置为透明
 4、避免过于庞大的XIB
 5、不要阻塞主线程

6、在ImageViews中调整图片大小。如果要在UIImageView中显示一个来自bundle的图片，你应保证图片的大小和UIImageView的大小相同。在运行中缩放图片是很耗费资源的，特别是UIImageView嵌套在UIScrollView中的情况下。如果图片是从远端服务加载的你不能控制图片大小，比如在下载前调整到合适大小的话，你可以在下载完成后，最好是用background
 thread，缩放一次，然后在UIImageView中使用缩放后的图片。

7、选择正确的Collection。

- Arrays: 有序的一组值。使用index来lookup很快，使用value lookup很慢， 插入/删除很慢。
- Dictionaries: 存储键值对。 用键来查找比较快。
- Sets: 无序的一组值。用值来查找很快，插入/删除很快。

8、打开gzip压缩。app可能大量依赖于服务器资源，问题是我们的目标是移动设备，因此你就不能指望网络状况有多好。减小文档的一个方式就是在服务端和你的app中打开gzip。这对于文字这种能有更高压缩率的数据来说会有更显著的效用。
 iOS已经在NSURLConnection中默认支持了gzip压缩，当然AFNetworking这些基于它的框架亦然。

#### 二、中级

1、重用和延迟加载(lazy load) Views

- 更多的view意味着更多的渲染，也就是更多的CPU和内存消耗，对于那种嵌套了很多view在UIScrollView里边的app更是如此。
- 这里我们用到的技巧就是模仿UITableView和UICollectionView的操作: 不要一次创建所有的subview，而是当需要时才创建，当它们完成了使命，把他们放进一个可重用的队列中。这样的话你就只需要在滚动发生时创建你的views，避免了不划算的内存分配。

2、Cache, Cache, 还是Cache!

- 一个极好的原则就是，缓存所需要的，也就是那些不大可能改变但是需要经常读取的东西。
- 我们能缓存些什么呢？一些选项是，远端服务器的响应，图片，甚至计算结果，比如UITableView的行高。
- NSCache和NSDictionary类似，不同的是系统回收内存的时候它会自动删掉它的内容。

3、权衡渲染方法.性能能还是要bundle保持合适的大小。

4、处理内存警告.移除对缓存，图片object和其他一些可以重创建的objects的strong references.

5、重用大开销对象

6、一些objects的初始化很慢，比如NSDateFormatter和NSCalendar。然而，你又不可避免地需要使用它们，比如从JSON或者XML中解析数据。想要避免使用这个对象的瓶颈你就需要重用他们，可以通过添加属性到你的class里或者创建静态变量来实现。

7、避免反复处理数据.在服务器端和客户端使用相同的数据结构很重要。

8、选择正确的数据格式.解析JSON会比XML更快一些，JSON也通常更小更便于传输。从iOS5起有了官方内建的JSON deserialization 就更加方便使用了。但是XML也有XML的好处，比如使用SAX 来解析XML就像解析本地文件一样，你不需像解析json一样等到整个文档下载完成才开始解析。当你处理很大的数据的时候就会极大地减低内存消耗和增加性能。

9、正确设定背景图片

- 全屏背景图，在view中添加一个UIImageView作为一个子View
- 只是某个小的view的背景图，你就需要用UIColor的colorWithPatternImage来做了，它会更快地渲染也不会花费很多内存：

10、减少使用Web特性。想要更高的性能你就要调整下你的HTML了。第一件要做的事就是尽可能移除不必要的javascript，避免使用过大的框架。能只用原生js就更好了。尽可能异步加载例如用户行为统计script这种不影响页面表达的javascript。注意你使用的图片，保证图片的符合你使用的大小。

11、Shadow Path 。CoreAnimation不得不先在后台得出你的图形并加好阴影然后才渲染，这开销是很大的。使用shadowPath的话就避免了这个问题。使用shadow path的话iOS就不必每次都计算如何渲染，它使用一个预先计算好的路径。但问题是自己计算path的话可能在某些View中比较困难，且每当view的frame变化的时候你都需要去update shadow path.

12、优化Table View

- 正确使用reuseIdentifier来重用cells
- 尽量使所有的view opaque，包括cell自身
- 避免渐变，图片缩放，后台选人
- 缓存行高
- 如果cell内现实的内容来自web，使用异步加载，缓存请求结果
- 使用shadowPath来画阴影
- 减少subviews的数量
- 尽量不适用cellForRowAtIndexPath:，如果你需要用到它，只用-一次然后缓存结果
- 使用正确的数据结构来存储数据
- 使用rowHeight, sectionFooterHeight 和 sectionHeaderHeight来设定固定的高，不要请求delegate

13、选择正确的数据存储选项

- NSUserDefaults的问题是什么？虽然它很nice也很便捷，但是它只适用于小数据，比如一些简单的布尔型的设置选项，再大点你就要考虑其它方式了
- XML这种结构化档案呢？总体来说，你需要读取整个文件到内存里去解析，这样是很不经济的。使用SAX又是一个很麻烦的事情。
- NSCoding？不幸的是，它也需要读写文件，所以也有以上问题。
- 在这种应用场景下，使用SQLite 或者 Core Data比较好。使用这些技术你用特定的查询语句就能只加载你需要的对象。
- 在性能层面来讲，SQLite和Core Data是很相似的。他们的不同在于具体使用方法。
- Core Data代表一个对象的graph model，但SQLite就是一个DBMS。
- Apple在一般情况下建议使用Core Data，但是如果你有理由不使用它，那么就去使用更加底层的SQLite吧。
- 如果你使用SQLite，你可以用FMDB这个库来简化SQLite的操作，这样你就不用花很多经历了解SQLite的C API了。

#### 三、高级

1、加速启动时间。快速打开app是很重要的，特别是用户第一次打开它时，对app来讲，第一印象太太太重要了。你能做的就是使它尽可能做更多的异步任务，比如加载远端或者数据库数据，解析数据。避免过于庞大的XIB，因为他们是在主线程上加载的。所以尽量使用没有这个问题的Storyboards吧！一定要把设备从Xcode断开来测试启动速度

2、使用Autorelease Pool。NSAutoreleasePool`负责释放block中的autoreleased objects。一般情况下它会自动被UIKit调用。但是有些状况下你也需要手动去创建它。假如你创建很多临时对象，你会发现内存一直在减少直到这些对象被release的时候。这是因为只有当UIKit用光了autorelease pool的时候memory才会被释放。消息是你可以在你自己的@autoreleasepool里创建临时的对象来避免这个行为。

3、选择是否缓存图片。常见的从bundle中加载图片的方式有两种，一个是用imageNamed，二是用imageWithContentsOfFile，第一种比较常见一点。

4、避免日期格式转换。如果你要用NSDateFormatter来处理很多日期格式，应该小心以待。就像先前提到的，任何时候重用NSDateFormatters都是一个好的实践。如果你可以控制你所处理的日期格式，尽量选择Unix时间戳。你可以方便地从时间戳转换到NSDate:



```objectivec
    - (NSDate*)dateFromUnixTimestamp:(NSTimeInterval)timestamp {
    return[NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
```

这样会比用C来解析日期字符串还快！需要注意的是，许多web API会以微秒的形式返回时间戳，因为这种格式在javascript中更方便使用。记住用dateFromUnixTimestamp之前除以1000就好了。

**平时你是如何对代码进行性能优化的？**

- 利用性能分析工具检测，包括静态 Analyze 工具，以及运行时 Profile 工具，通过Xcode工具栏中Product->Profile可以启动,
- 比如测试程序启动运行时间，当点击Time Profiler应用程序开始运行后.就能获取到整个应用程序运行消耗时间分布和百分比.为了保证数据分析在统一使用场景真实需要注意一定要使用真机,因为此时模拟器是运行在Mac上，而Mac上的CPU往往比iOS设备要快。
- 为了防止一个应用占用过多的系统资源，开发iOS的苹果工程师门设计了一个“看门狗”的机制。在不同的场景下，“看门狗”会监测应用的性能。如果超出了该场景所规定的运行时间，“看门狗”就会强制终结这个应用的进程。开发者们在crashlog里面，会看到诸如0x8badf00d这样的错误代码。

**优化Table View**

- 正确使用reuseIdentifier来重用cells
- 尽量使所有的view opaque，包括cell自身
- 如果cell内现实的内容来自web，使用异步加载，缓存请求结果
   减少subviews的数量
- 尽量不适用cellForRowAtIndexPath:，如果你需要用到它，只用一次然后缓存结果
- 使用rowHeight, sectionFooterHeight和sectionHeaderHeight来设定固定的高，不要请求delegate

**UIImage加载图片性能问题**

- imagedNamed初始化
- imageWithContentsOfFile初始化
- imageNamed默认加载图片成功后会内存中缓存图片,这个方法用一个指定的名字在系统缓存中查找并返回一个图片对象.如果缓存中没有找到相应的图片对象,则从指定地方加载图片然后缓存对象，并返回这个图片对象.
- imageWithContentsOfFile则仅只加载图片,不缓存.
- 加载一张大图并且使用一次，用imageWithContentsOfFile是最好,这样CPU不需要做缓存节约时间.
- 使用场景需要编程时，应该根据实际应用场景加以区分，UIimage虽小，但使用元素较多问题会有所凸显.
  - 不要在viewWillAppear 中做费时的操作：viewWillAppear: 在view显示之前被调用，出于效率考虑，方法中不要处理复杂费时操作；在该方法设置 view 的显示属性之类的简单事情，比如背景色，字体等。否则，会明显感觉到 view 有卡顿或者延迟。
  - 在正确的地方使用reuseIdentifier：table view用 tableView:cellForRowAtIndexPath:为rows分配cells的时候，它的数据应该重用自UITableViewCell。
  - 尽量把views设置为透明：如果你有透明的Views你应该设置它们的opaque属性为YES。系统用一个最优的方式渲染这些views。这个简单的属性在IB或者代码里都可以设定。
  - 避免过于庞大的XIB：尽量简单的为每个Controller配置一个单独的XIB，尽可能把一个View Controller的view层次结构分散到单独的XIB中去, 当你加载一个引用了图片或者声音资源的nib时，nib加载代码会把图片和声音文件写进内存。
  - 不要阻塞主线程：永远不要使主线程承担过多。因为UIKit在主线程上做所有工作，渲染，管理触摸反应，回应输入等都需要在它上面完成,大部分阻碍主进程的情形是你的app在做一些牵涉到读写外部资源的I/O操作，比如存储或者网络。
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,   0), ^{
     // 选择一个子线程来执行耗时操作
     dispatch_async(dispatch_get_main_queue(), ^{
     // 返回主线程更新UI
     });
     });
  - 在Image Views中调整图片大小
     如果要在UIImageView中显示一个来自bundle的图片，你应保证图片的大小和UIImageView的大小相同。在运行中缩放图片是很耗费资源的.

**讲讲你用Instrument优化动画性能的经历吧（别问我什么是Instrument）**



```cpp
Apple的instrument为开发者提供了各种template去优化app性能和定位问题。很多公司都在赶feature，并没有充足的时间来做优化，导致不少开发者对instrument不怎么熟悉。但这里面其实涵盖了非常完整的计算机基础理论知识体系，memory，disk，network，thread，cpu，gpu等等，顺藤摸瓜去学习，是一笔巨大的知识财富。动画性能只是其中一个template，重点还是理解上面问题当中CPU GPU如何配合工作的知识。
```

**facebook启动时间优化**

1.瘦身请求依赖
 2.UDP启动请求先行缓存
 3.队列串行化处理启动响应