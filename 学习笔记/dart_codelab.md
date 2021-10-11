**字符串插值**	${表达式}  或者 $变量

**避空运算符**	?? 、??=  	 和Swift中的空合运算符很相似，只是swift中空合不能赋值

**条件属性访问**	?.  			和Swift中的可选链一样

**集合字面量**  数组[]，set{}，字典{:}分别对应类名Array,Map,Set 这点和Swift中不太一样。Swift中更加统一，都是[]/[:]，Swift中Array和Set需要我们自己指明

**箭头语法**   也就是单行表达式，可以省略return。和Swift中的单行表达式一样

**级联** ..  			类似于Swift中的链式调用

**getters和setters** 这个和Swift中不一样。感觉Swift中更好，起码知道控制的是同一个属性的读写。dart中分开写，阅读起来很吃力。如果分散在一个类的上下几百行，简直就是恶梦

**可选位置参数** 将参数包裹在**中括号**中变成可选位置参数，这个参数只能作为最后一个参数

**可选命名参数 **使用**大括号**语法定义可选命名参数，一个方法不能同时使用可选位置参数和可选命名参数

**异常** Dart 代码可以抛出和捕获异常。与 Java 相比，Dart 的所有异常都是 unchecked exception。方法不会声明它们可能抛出的异常，你也不需要捕获任何异常

使用 `try`、`on` 以及 `catch` 关键字来处理异常

`try` 关键字作用与其他大多数语言一样。使用 `on` 关键字按类型过滤特定异常，而 `catch` 关键字则能够获取捕捉到的异常对象的引用

要执行一段无论是否抛出异常都会执行的代码，请使用 `finally`

**构造方法中使用this** Dart 提供了一个方便的快捷方式，用于为构造方法中的属性赋值：在声明构造方法时使用 `this.propertyName`

**初始化列表** 有时，当你在实现构造函数时，您需要在构造函数体执行之前进行一些初始化。例如，final 修饰的字段必须在构造函数体执行之前赋值。在初始化列表中执行此操作，该列表位于构造函数的签名与其函数体之间,**使用冒号分割**

**命名构造方法** 为了允许一个类具有多个构造方法，Dart 支持命名构造方法。具体用法为**类名.构造方法名**

**工厂构造方法**	Dart 支持工厂构造方法。它能够返回其子类甚至 null 对象。要创建一个工厂构造方法，请使用 `factory` 关键字

**重定向构造方法**	有时一个构造方法仅仅用来重定向到该类的另一个构造方法。重定向方法没有主体，它在冒号（`:`）之后调用另一个构造方法。貌似这个重定向只能使用this

**const构造方法**	如果你的类生成的对象永远都不会更改，则可以让这些对象成为编译时常量。为此，请定义 `const` 构造方法并确保所有实例变量都是 final 的

#### 当你在学习 Dart 语言时, 应该牢记以下几点：

- 所有变量引用的都是 *对象*，每个对象都是一个 *类* 的实例。数字、函数以及 `null` 都是对象。所有的类都继承于 [Object](https://api.dart.dev/stable/dart-core/Object-class.html) 类。
- 尽管 Dart 是强类型语言，但是在声明变量时指定类型是可选的，因为 Dart 可以进行类型推断。在上述代码中，变量 `number` 的类型被推断为 `int` 类型。如果想显式地声明一个不确定的类型，可以[使用特殊类型 `dynamic`](https://dart.cn/guides/language/effective-dart/design#do-annotate-with-object-instead-of-dynamic-to-indicate-any-object-is-allowed)。
- Dart 支持泛型，比如 `List`（表示一组由 int 对象组成的列表）或 `List`（表示一组由任何类型对象组成的列表）。
- Dart 支持顶级函数（例如 `main` 方法），同时还支持定义属于类或对象的函数（即 *静态* 和 *实例方法*）。你还可以在函数中定义函数（*嵌套* 或 *局部函数*）。
- Dart 支持顶级 *变量*，以及定义属于类或对象的变量（静态和实例变量）。实例变量有时称之为域或属性。
- Dart 没有类似于 Java 那样的 `public`、`protected` 和 `private` 成员访问限定符。如果一个标识符以下划线 (_) 开头则表示该标识符在库内是私有的。可以查阅 [库和可见性](https://dart.cn/guides/language/language-tour#libraries-and-visibility) 获取更多相关信息。
- *标识符* 可以以字母或者下划线 (_) 开头，其后可跟字符和数字的组合。
- Dart 中 *表达式* 和 *语句* 是有区别的，表达式有值而语句没有。比如[条件表达式](https://dart.cn/guides/language/language-tour#conditional-expressions) `expression condition ? expr1 : expr2` 中含有值 `expr1` 或 `expr2`。与 [if-else 分支语句](https://dart.cn/guides/language/language-tour#if-and-else)相比，`if-else` 分支语句则没有值。一个语句通常包含一个或多个表达式，但是一个表达式不能只包含一个语句。
- Dart 工具可以显示 *警告* 和 *错误* 两种类型的问题。警告表明代码可能有问题但不会阻止其运行。错误分为编译时错误和运行时错误；编译时错误代码无法运行；运行时错误会在代码运行时导致[异常](https://dart.cn/guides/language/language-tour#exceptions)。



变量仅存储对象的引用，如果一个对象的引用不局限于单一的类型，可以根据[设计指南](https://dart.cn/guides/language/effective-dart/design#do-annotate-with-object-instead-of-dynamic-to-indicate-any-object-is-allowed)将其指定为 `Object` 或 `dynamic` 类型

在 Dart 中，未初始化的变量拥有一个默认的初始化值：`null`。即便数字也是如此，因为在 Dart 中一切皆为对象，数字也不例外

如果你不想更改一个变量，可以使用关键字 `final` 或者 `const` 修饰变量，这两个关键字可以替代 `var` 关键字或者加在一个具体的类型前。一个 final 变量只可以被赋值一次；一个 const 变量是一个编译时常量（const 变量同时也是 final 的）。顶层的 final 变量或者类的 final 变量在其第一次使用的时候被初始化

使用关键字 `const` 修饰变量表示该变量为 **编译时常量**。如果使用 const 修饰类中的变量，则必须加上 static 关键字，即 `static const`（注意：顺序不能颠倒（译者注））。在声明 const 变量时可以直接为其赋值，也可以使用其它的 const 变量为其赋值

**Symbol 表示 Dart 中声明的操作符或者标识符，该类型的对象几乎不会被使用到，但是如果需要按名称引用它们的 API 时就非常有用**,Symbol 字面量是编译时常量

在 => 与 ; 之间的只能是 *表达式* 而非 *语句*。比如你不能将一个 [if语句](https://dart.cn/guides/language/language-tour#if-and-else) 放在其中，但是可以放置 [条件表达式](https://dart.cn/guides/language/language-tour#conditional-expressions)

可以使用 **[@required](https://pub.flutter-io.cn/documentation/meta/latest/meta/required-constant.html)** 注解来标识一个命名参数是必须的参数，此时调用者则必须为该参数提供一个值

可以用 `=` 为函数的命名和位置参数定义默认值，默认值必须为编译时常量，没有指定默认值的情况下默认值为 `null`

每个 Dart 程序都必须有一个 `main()` 顶级函数作为程序的入口，`main()` 函数返回值为 `void` 并且有一个 `List` 类型的可选参数

Dart 是词法有作用域语言，变量的作用域在写代码的时候就确定了，大括号内定义的变量只能在大括号内访问，与 Java 类似

*闭包* 即一个函数对象，即使函数对象的调用在它原始作用域之外，依然能够访问在它词法作用域内的变量。

函数可以封闭定义到它作用域内的变量

所有的函数都有返回值。没有显示返回语句的函数最后一行默认为执行 `return null`

在 Dart 语言中，`for` 循环中的闭包会自动捕获循环的 **索引值** 以避免 JavaScript 中一些常见的陷阱



**Switch 语句**在 Dart 中使用 `==` 来比较整数、字符串或编译时常量，比较的两个对象必须是同一个类型且不能是子类并且没有重写 `==` 操作符

Dart 是支持基于 mixin 继承机制的面向对象语言，所有对象都是一个类的实例，而所有的类都继承自 [Object](https://api.dart.dev/stable/dart-core/Object-class.html) 类。基于 *mixin 的继承* 意味着每个除 Object 类之外的类都只有一个超类，一个类的代码可以在其它多个类继承中重复使用。 [Extension 方法](https://dart.cn/guides/language/language-tour#extension-methods)是一种在不更改类或创建子类的情况下向类添加功能的方式

可以使用 *构造函数* 来创建一个对象。构造函数的命名方式可以为 `*类名*` 或 `*类名*.*标识符*` 的形式



可以使用 Object 对象的 `runtimeType` 属性在运行时获取一个对象的类型，该对象类型是 [Type](https://api.dart.dev/stable/dart-core/Type-class.html) 的实例

所有未初始化的实例变量其值均为 `null`。

所有实例变量均会隐式地声明一个 *Getter* 方法，非 final 类型的实例变量还会隐式地声明一个 *Setter* 方法

**如果你没有声明构造函数，那么 Dart 会自动生成一个无参数的构造函数并且该构造函数会调用其父类的无参数构造方法**

**子类不会继承父类的构造函数，如果子类没有声明构造函数，那么只会有一个默认无参数的构造函数**

默认情况下，子类的构造函数会调用父类的匿名无参数构造方法，并且该调用会在子类构造函数的函数体代码执行前，如果子类构造函数还有一个[初始化列表](https://dart.cn/guides/language/language-tour#initializer-list)，那么该初始化列表会在调用父类的该构造函数之前被执行，总的来说，这三者的调用顺序如下：

1. 初始化列表
2. 父类的无参数构造函数
3. 当前类的构造函数

如果父类没有匿名无参数构造函数，那么子类必须调用父类的其中一个构造函数，为子类的构造函数指定一个父类的构造函数只需在构造函数体前使用（`:`）指定



实例方法、Getter 方法以及 Setter 方法都可以是抽象的，定义一个接口方法而不去做具体的实现让实现它的类去实现该方法，抽象方法只能存在于[抽象类](https://dart.cn/guides/language/language-tour#abstract-classes)中。即abstract修饰的类

直接使用分号（;）替代方法体即可声明一个抽象方法

**每一个类都隐式地定义了一个接口并实现了该接口，这个接口包含所有这个类的实例成员以及这个类所实现的其它接口**

**一个类可以通过关键字 `implements` 来实现一个或多个接口并实现每个接口定义的 API，如果需要实现多个类接口，可以使用逗号分割每个接口类**



使用 `extends` 关键字来创建一个子类，并可使用 `super` 关键字引用一个父类

如果调用了对象上不存在的方法或实例变量将会触发 `noSuchMethod` 方法，你可以重写 `noSuchMethod` 方法来追踪和记录这一行为，类似于OC中的doesNotRecognizeSelector方法

**每一个枚举值都有一个名为 `index` 成员变量的 Getter 方法，该方法将会返回以 0 为基准索引的位置值**

**可以使用枚举类的 `values` 方法获取一个包含所有枚举值的列表，类似于swift中的allCases**



**Mixin 是一种在多重继承中复用某个类中代码的方法模式。**

**使用 `with` 关键字并在其后跟上 Mixin 类的名字来使用 Mixin 模式**

**定义一个类继承自 Object 并且不为该类定义构造函数，这个类就是 Mixin 类，除非你想让该类与普通的类一样可以被正常地使用，否则可以使用关键字 `mixin` 替代 `class` 让其成为一个单纯的 Mixin 类**

可以使用关键字 `on` 来指定哪些类可以使用该 Mixin 类



使用关键字 `static` 可以声明类变量或类方法

Dart的泛型类型是 *固化的*，这意味着即便在运行时也会保持类型信息

有时使用泛型的时候可能会想限制泛型的类型范围，这时候可以使用 `extends` 关键字，这一点倒是和Swift很类似。都是使用类似于对象继承这种语法。



`import` 和 `library` 关键字可以帮助你创建一个模块化和可共享的代码库。代码库不仅只是提供 API 而且还起到了封装的作用：以下划线（_）开头的成员仅在代码库中可见。*每个 Dart 程序都是一个库*，即便没有使用关键字 `library` 指定

使用 `import` 来指定命名空间以便其它库可以访问

`import` 的唯一参数是用于指定代码库的 URI，对于 Dart 内置的库，使用 `dart:xxxxxx` 的形式。而对于其它的库，你可以使用一个文件系统路径或者以 `package:xxxxxx` 的形式。`package:xxxxxx` 指定的库通过包管理器（比如 pub 工具）来提供



使用 `deferred as` 关键字来标识需要延时加载的代码库，当实际需要使用到库中 API 时先调用 `loadLibrary` 函数加载库



```
await *表达式的返回值通常是一个 Future 对象；如果不是的话也会自动将其包裹在一个 Future 对象里。Future 对象代表一个“承诺”，`await \*表达式\*`会阻塞直到需要的对象返回。*
```

**如果在使用 `await` 时导致编译错误，请确保 `await` 在一个异步函数中使用**



当你需要延迟地生成一连串的值时，可以考虑使用 *生成器函数*。Dart 内置支持两种形式的生成器方法：

- **同步** 生成器：返回一个 **[Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html)** 对象。
- **异步** 生成器：返回一个 **[Stream](https://api.dart.dev/stable/dart-async/Stream-class.html)** 对象。

通过在函数上加 `sync*` 关键字并将返回值类型设置为 Iterable 来实现一个 **同步** 生成器函数，在函数中使用 `yield` 语句来传递值



通过实现类的 `call()` 方法，允许使用类似函数调用的方式来使用该类的实例



为了解决多线程带来的并发问题，Dart 使用 isolates 替代线程，所有的 Dart 代码均运行在一个个 *isolates* 中。每一个 isolates 有它自己的堆内存以确保其状态不被其它 isolates 访问



在 Dart 语言中，函数与 String 和 Number 一样都是对象，可以使用 *类型定义*（或者叫 *方法类型别名*）来为函数的类型命名。使用函数命名将该函数类型的函数赋值给一个变量时，类型定义将会保留相关的类型信息



使用元数据可以为代码增加一些额外的信息。元数据注解以 `@` 开头，其后紧跟一个编译时常量（比如 `deprecated`）或者调用一个`常量构造函数`。

Dart 中有两个注解是所有代码都可以使用的：`@deprecated` 和 `@override`



在文档注释中，除非用中括号括起来，否则 Dart 编译器会忽略所有文本。使用中括号可以引用类、方法、字段、顶级变量、函数、和参数。括号中的符号会在已记录的程序元素的词法域中进行解析



[Dart中文网](https://dart.cn/guides/language/language-tour)