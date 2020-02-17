[TOC]

#### ios 平台怎么做数据的持久化?coredata 和sqlite有无必然联系？coredata是一个关系型数据库吗？

- iOS 中可以有四种持久化数据的方式：属性列表(plist)、对象归档、 SQLite3 和 Core Data；
- core data 可以使你以图形界面的方式快速的定义 app 的数据模型，同时在你的代码中容易获取到它。 coredata 提供了基础结构去处理常用的功能，例如保存，恢复，撤销和重做，允许你在 app 中继续创建新的任务。在使用 core data 的时候，你不用安装额外的数据库系统，因为 core data 使用内置的 sqlite 数据库。 core data 将你 app 的模型层放入到一组定义在内存中的数据对象。 coredata 会追踪这些对象的改变，同时可以根据需要做相反的改变，例如用户执行撤销命令。当 core data 在对你 app 数据的改变进行保存的时候， core data 会把这些数据归档，并永久性保存。 mac os x 中sqlite 库，它是一个轻量级功能强大的关系数据引擎，也很容易嵌入到应用程序。可以在多个平台使用， sqlite 是一个轻量级的嵌入式 sql 数据库编程
- 与 core data 框架不同的是， sqlite 是使用程序式的， sql 的主要的 API 来直接操作数据表。 Core Data 不是一个关系型数据库，也不是关系型数据库管理系统 (RDBMS) 。虽然 Core Dta 支持SQLite 作为一种存储类型，但它不能使用任意的 SQLite 数据库。 Core Data 在使用的过程种自己创建这个数据库。 Core Data 支持对一、对多的关系

#### 什么是序列化和反序列化，用来做什么

- 序列化：把对象转化为字节序列的过程
- 反序列：把直接序列恢复成对象
- 作用：把对象写到文件或者数据库中，并且读取出来

#### SQLite 数据存储是怎么用

- 添加SQLite动态库
- 导入主头文件 `#import <sqlite3.h>`
- 利用C语言函数创建/打开数据库，编写SQL语句

#### CoreData是什么

- CoreData是iOS5之后才出现的一个框架，本质上是对SQLite的一个封装
- 它提供了对象-关系映射(ORM)的功能，能够将OC对象转化成数据，保存在SQLite数据库文件中，也能够将保存在数据库中的数据还原成OC对象
- 通过CoreData管理应用程序的数据模型，可以极大程度减少需要编写的代码数量

#### 简单描述下客户端的缓存机制

- 缓存可以分为：内存数据缓存、数据库缓存、文件缓存

- 每次想获取数据的时候先检测内存中有无缓存

- 再检测本地有无缓存(数据库/文件)

- 最终发送网络请求

- 将服务器返回的网络数据进行缓存(内存、数据库、文件)， 以便下次读取

#### 说一说你对SQLite的认识

- SQLite是目前主流的嵌入式关系型数据库，其最主要的特点就是轻量级、跨平台，当前很多嵌入式操作系统都将其作为数据库首选

#### 说一说你对FMDB的认识

- FMDB是一个处理数据存储的三方框架，框架是对SQLite的封装，整个框架非常轻量级但又不失灵活性，而且更加面向对象
- 直接使用libsqlite3进行数据库操作不是线程安全的，如果遇到多个线程同时操作一个表的时候可能会发生意想不到的结果。为了解决这个问题建议在多线程中使用FMDatabaseQueue对象，相比FMDatabase而言，它是线程安全的
- 将事务放到FMDB中去说并不是因为只有FMDB才支持事务，而是因为FMDB将其封装成了几个方法来调用，不用自己写对应的sql而已。其实在在使用libsqlite3操作数据库时也是原生支持事务的（因为这里的事务是基于数据库的，FMDB还是使用的SQLite数据库），只要在执行sql语句前加上“begin transaction;”执行完之后执行“commit transaction;”或者“rollback transaction;”进行提交或回滚即可。另外在Core Data中大家也可以发现，所有的增、删、改操作之后必须调用上下文的保存方法，其实本身就提供了事务的支持，只要不调用保存方法，之前所有的操作是不会提交的。在FMDB中FMDatabase有beginTransaction、commit、rollback三个方法进行开启事务、提交事务和回滚事务

#### 什么是沙盒机制

- 每个iOS程序都有一个独立的文件系统（存储空间），而且只能在对应的文件系统中进行操作，此区域被称为沙盒。应用必须待在自己的沙盒里，其他应用不能访问该沙盒

#### 沙盒目录结构是怎样的？

- Documents：常用目录，iCloud备份目录，存放数据，这里不能存缓存文件,否则上架不被通过
- Library
  - Caches：存放体积大又不需要备份的数据,SDWebImage缓存路径就是这个
  - Preference：设置目录，iCloud会备份设置信息
- tmp：存放临时文件，不会被备份，而且这个文件下的数据有可能随时被清除的可能

#### 代码题目分析,打印结果是什么

```css
NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
BOOL flag = NO;
[userdefault setObject:@(flag) forKey:@"flag"];

if ([userdefault objectForKey:@"flag"]) {
    BOOL eq = [userdefault objectForKey:@"flag"];
    if (eq) {
        NSLog(@"a");
    }else{
        NSLog(@"b");
    }
}else{
    BOOL eq = [userdefault objectForKey:@"flag"];
    if (eq) {
        NSLog(@"c");
    }else{
        NSLog(@"d");
    }
}
```

打印结果 a
 分析: flag被包装成 oc 对象(NSNumber)，OC对象有值，转 BOOL 都是 YES

#### 如果后期需要增加数据库中的字段怎么实现，如果不使用CoreData呢

- 编写SQL语句来操作原来表中的字段
- 增加表字段：ALTER TABLE 表名 ADD COLUMN 字段名 字段类型;
- 删除表字段：ALTER TABLE 表名 DROP COLUMN 字段名;
- 修改表字段：ALTER TABLE 表名 RENAME COLUMN 旧字段名 TO 新字段名;

#### FMDB使用 线程与事务

- FMDatabaseQueue 使用该类保证线程安全，串行队列

- **事务：**作为单个逻辑工作单元执行的一系列操作，而这些逻辑工作单元需要具有原子性，一致性，隔离性和持久性
- 是并发控制的基本单元。所谓的事务，它是一个操作序列，这些操作要么都执行，要么都不执行，它是一个不可分割的工作单元。
- 事务是一种机制，用于维护数据库的完整性

#### 解析XML文件有哪几种方式？

以 DOM 方式解析 XML 文件；以 SAX 方式解析 XML 文件

#### 熟悉常用SQL语句

```jsx
create database name
drop database name
alter table name add column col type
select * from table1 where col=value
select count as totalcount from table1
select sum(field1) as sumvalue from table1
'insert into table1 (field1,field2) values(value1,value2) '
delete from table1 where something
update table1 set field1=value1 where field1 like ’%value1%'
```

[一些常用SQL语句大全](https://www.cnblogs.com/acpe/p/4970765.html)

#### 当数据库中的某项数据为 null 时候，通过FMDB获取的数据为

```
[NSNull null]
```