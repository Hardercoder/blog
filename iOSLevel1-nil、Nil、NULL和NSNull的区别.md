### nil、Nil、NULL和NSNull的区别：

- **nil：** 把对象置空，置空后是一个空对象且完全从内存中释放；
- **Nil：** 用nil的地方均可用Nil替换，Nil表示置空一个类；
- **NULL：** 表示把一个指针置空。（空指针）
- **NSNull**：** 把一个OC对象置空，但想保留其容器（大小）。

以下进行一个简单说明

nil在iOS开发中最常用的是将一个属性置空，另外还有一点需要注意的是当使用[NSArray arrayWithObjects:...]时是以第一个遇到的nil作为数组的结尾的

[文章参考](https://juejin.im/post/5ddc8815f265da7dd4154503)