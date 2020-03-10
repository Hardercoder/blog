Dart 是类型安全的编程语言：Dart 使用静态类型检查和 [运行时检查](https://dart.cn/guides/language/sound-dart#runtime-checks) 的组合来确保变量的值始终与变量的静态类型或其他安全类型相匹配。尽管类型是必需的，但由于 [类型推断](https://dart.cn/guides/language/sound-dart#type-inference)，类型的注释是可选的

静态类型检查的一个好处是能够使用 Dart 的 [静态分析器](https://dart.cn/guides/language/analysis-options) 在编译时找到错误



#### 静态检查中的一些技巧

大多数静态类型的规则都很容易理解。下面是一些不太明显的规则：

- 重写方法时，使用类型安全返回值。
- 重写方法时，使用类型安全的参数。
- 不要将动态类型的 List 看做是有类型的 List



分析器（analyzer）可以推断字段，方法，局部变量和大多数泛型类型参数的类型。当分析器没有足够的信息来推断出一个特定类型时，会使用 `dynamic` 作为类型



[具体学习资料](https://dart.cn)



















