#### [self class] 与 [super class]

下面的代码输出什么？

```objectivec
@implementation Son : Father
 - (id)init {
     self = [super init];
     if (self) {
         NSLog(@"%@", NSStringFromClass([self class]));
         NSLog(@"%@", NSStringFromClass([super class]));
     }
     return self;
 }
 @end
```

都会输出Son。

self 是的隐藏参数，指向当前调用方法的这个类的实例

super 本质是一个编译器标示符，和 self 是指向的同一个消息接受者。不同点在于：super 会告诉编译器，当调用方法时，起始的查找位置是父类的方法列表，而不是本类的方法列表

当使用 self 调用方法时，会从当前类的方法列表中开始找，如果没有，就从父类中再找；而当使用 super 时，则从父类的方法列表中开始找。然后调用父类的这个方法。

在调用[super class]的时候，runtime会去调用objc_msgSendSuper方法，而不是objc_msgSend；

```csharp
OBJC_EXPORT void objc_msgSendSuper(void /* struct objc_super *super, SEL op, ... */ )

/// Specifies the superclass of an instance. 
struct objc_super {
    /// Specifies an instance of a class.
    __unsafe_unretained id receiver;

    /// Specifies the particular superclass of the instance to message. 
#if !defined(__cplusplus)  &&  !__OBJC2__
    /* For compatibility with old objc-runtime.h header */
    __unsafe_unretained Class class;
#else
    __unsafe_unretained Class super_class;
#endif
    /* super_class is the first class to search */
};
```

在objc_msgSendSuper方法中，第一个参数是一个objc_super的结构体，这个结构体里面有两个变量，一个是接收消息的receiver，一个是当前类的父类super_class。

objc_msgSendSuper的工作原理应该是这样的:
 从objc_super结构体指向的superClass父类的方法列表开始查找selector，找到后以objc->receiver去调用父类的这个selector。注意，最后的调用者是objc->receiver，而不是super_class！

那么objc_msgSendSuper最后就转变成:

```objectivec
// 注意这里是从父类开始msgSend，而不是从本类开始
objc_msgSend(objc_super->receiver, @selector(class))

/// Specifies an instance of a class.  这是类的一个实例
__unsafe_unretained id receiver;   
// 由于是实例调用，所以是减号方法
- (Class)class {
    return object_getClass(self);
}
```

由于找到了父类NSObject里面的class方法的IMP，又因为传入的入参objc_super->receiver = self。self就是son，调用class，所以父类的方法class执行IMP之后，输出还是son，最后输出两个都一样，都是输出son

#### 以下的代码会输出什么结果？

```objectivec
@interface Sark : NSObject
@end
@implementation Sark
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        NSLog(@"%@", [NSObject class]);
        NSLog(@"%@", [Sark class]);

        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
        BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
        BOOL res3 = [(id)[Sark class] isKindOfClass:[Sark class]];
        BOOL res4 = [(id)[Sark class] isMemberOfClass:[Sark class]];
        NSLog(@"%d--%d--%d--%d", res1, res2, res3, res4);
    }
    return 0;
}
```

**结果：** 1--0--0--0

首先，我们先去查看一下题干中两个方法的源码：

```objectivec
  //  返回的直接是 是否是当前的类
- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}

//  返回的直接是 是否是当前的类， 
// 当前元类对象
+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
} 

// for循环查找 ， 会根据当前类和 当前类的父类去逐级查找 ，
- (BOOL)isKindOfClass:(Class)cls {
  for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
      if (tcls == cls) return YES;
  }
  return NO;
}

//   for循环查找 ， 会根据当前类和 当前类的额父类去逐级查找 ，
// 当前元类对象
 + (BOOL)isKindOfClass:(Class)cls {
  for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->superclass) {
      if (tcls == cls) return YES;
  }
  return NO;
} 
```

可以得知：

- isKindOfClass 的执行过程是拿到自己的 isa 指针和自己比较，若不等则继续取 isa 指针所指的 super class 进行比较。如此循环。
- isMemberOfClass 是拿到自己的 isa 指针和自己比较，是否相等。

1. [NSObject class] 执行完之后调用 isKindOfClass，第一次判断先判断 NSObject 和 NSObject 的 meta class 是否相等，之前讲到 meta class 的时候放了一张很详细的图，从图上我们也可以看出，NSObject 的 meta class 与本身不等。接着第二次循环判断 NSObject 与meta class 的 superclass 是否相等。还是从那张图上面我们可以看到：Root class(meta) 的 superclass 就是 Root class(class)，也就是 NSObject 本身。所以第二次循环相等，于是第一行 res1 输出应该为YES。
2. isa 指向 NSObject 的 Meta Class，所以和 NSObject Class不相等。
3. [Sark class] 执行完之后调用 isKindOfClass，第一次 for 循环，Sark 的 Meta Class 与 [Sark class] 不等，第二次 for 循环，Sark Meta Class 的 super class 指向的是 NSObject Meta Class， 和 Sark Class 不相等。第三次 for 循环，NSObject Meta Class 的 super class 指向的是 NSObject Class，和 Sark Class 不相等。第四次循环，NSObject Class 的super class 指向 nil， 和 Sark Class 不相等。第四次循环之后，退出循环，所以第三行的 res3 输出为 NO。
4. isa 指向 Sark 的 Meta Class，和 Sark Class 也不等