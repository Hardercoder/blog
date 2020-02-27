[TOC]



#### 多列表多计时器问题怎么解决

使用一个定时器，内部弱引用保存N多需要使用定时器的类

```
NS_ASSUME_NONNULL_BEGIN
@class TimerService;
//监听者需要实现的协议
@protocol TimerListener <NSObject>
@required
- (void)didOnTimer:(TimerService *)timer;
@end

@interface TimerService : NSObject
//对接提供的主要接口
+ (instancetype)sharedInstance;

- (void)startTimer;
- (void)stopTimer;

- (void)addListener:(id<TimerListener>)listener;
- (void)removeListener:(id<TimerListener>)listener;
@end

NS_ASSUME_NONNULL_END


@interface TimerService() {
    NSLock  *_operationLock;
    NSUInteger _elapseSeconds;
}
@property (nonatomic, strong) NSHashTable       *listeners;

@property (nonatomic, assign) NSTimeInterval    timeInterval;
@property (nonatomic, assign) NSTimeInterval    tolerance;
@property (nonatomic, strong) dispatch_queue_t  privateSerialQueue;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation TimerService

+ (instancetype)sharedInstance {
    static TimerService *timerService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerService = [[TimerService alloc] init];
        [timerService setup];
    });
    return timerService;
}

- (void)dealloc {
    [self stopTimer];
}

- (void)setup {
    _operationLock = [[NSLock alloc] init];
    _listeners = [NSHashTable weakObjectsHashTable];
    
    _elapseSeconds = 0;
    _timeInterval = 1.f;
    _tolerance = 0.f;
    NSString *privateQueueName = [NSString stringWithFormat:@"com.zk.timer.%p", self];
    _privateSerialQueue = dispatch_queue_create([privateQueueName cStringUsingEncoding:NSASCIIStringEncoding],
                                                DISPATCH_QUEUE_SERIAL);
}

#pragma mark - public
- (void)addListener:(id<TimerListener>)listener {
    [_operationLock lock];
    if (![self.listeners containsObject:listener]) {
        [self.listeners addObject:listener];
        if(self.listeners.count > 0) {
            //启动
            [self startTimer];
        }
    }
    [_operationLock unlock];
}

- (void)removeListener:(id<TimerListener>)listener {
    [_operationLock lock];
    if ([self.listeners containsObject:listener]) {
        [self.listeners removeObject:listener];
        if(self.listeners.count == 0){
            //暂停
            [self stopTimer];
        }
    }
    [_operationLock unlock];
}

- (void)startTimer {
    _elapseSeconds = 0;
    if (_timer == nil) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.privateSerialQueue);
        
        int64_t intervalInNanoseconds = (int64_t)(self.timeInterval * NSEC_PER_SEC);
        int64_t toleranceInNanoseconds = (int64_t)(self.tolerance * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer,
                                  dispatch_time(DISPATCH_TIME_NOW, intervalInNanoseconds),
                                  (uint64_t)intervalInNanoseconds,
                                  toleranceInNanoseconds
                                  );
        
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self onTimer];
            });
        });
        dispatch_resume(_timer); // 启动定时器
    }
}

- (void)stopTimer {
    _elapseSeconds = 0;
    if (_timer != nil) {
        dispatch_source_t timer = _timer;
        dispatch_async(_privateSerialQueue, ^{
            dispatch_source_cancel(timer);
        });
        _timer = nil;
    }
}

//定时器回调
- (void)onTimer {
    _elapseSeconds += 1;
    [self.listeners.allObjects enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<TimerListener> listener = obj;
        if ([listener respondsToSelector:@selector(didOnTimer:)]) {
            [listener didOnTimer:self];
        }
    }];
}

@end
```

