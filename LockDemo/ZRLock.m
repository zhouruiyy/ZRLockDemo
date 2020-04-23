//
//  ZRLock.m
//  LockDemo
//
//  Created by Zhou,Rui(ART) on 2020/4/23.
//  Copyright © 2020 Zhou,Rui(ART). All rights reserved.
//

#import "ZRLock.h"

@interface ZRLock ()

@property (nonatomic, strong) NSMutableDictionary *dic;

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation ZRLock

// 多线程同时操作同一对象，当dic为nil的时候，@synchronized是会判断对象是否为nil，如果为nil
// 不会加锁，这样会导致多线程访问同时修改一个对象，产生冲突。
- (void)synchronized_mayCrash {
    for (int i = 0; i < 9999; i++) {
        NSLog(@"i = %d", i);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @synchronized (self.dic) {
                self.dic = [@{} mutableCopy];
                self.dic = nil;
            }
        });
    }
}

// 递归加lock NSLock不能在同一个线程内多次加锁，会造成死锁
// 可以使用NSRecursiveLock
- (void)lock_dead {
    NSLock *lock = [[NSLock alloc] init];
//    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    void (^RecursiveMethod)(int);
    RecursiveMethod = ^(int value) {
        [lock lock];
        if (value > 0) {
            NSLog(@"value : %d", value);
            sleep(1);
            RecursiveMethod(--value);
        }
        [lock unlock];
    };
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RecursiveMethod(10);
    });
}

// NSConditonLock类似于信号量 也是一个lock
// 下面执行顺序 3->2->1
- (void)testConditonLock {
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:2];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [conditionLock lockWhenCondition:1];
        NSLog(@"1");
        [conditionLock unlockWithCondition:0];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [conditionLock lockWhenCondition:2];
        NSLog(@"2");
        [conditionLock unlockWithCondition:1];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [conditionLock lock];
        NSLog(@"3");
        [conditionLock unlock];
    });
}

- (void)testDispatchSemaphore {
    dispatch_queue_t queue = dispatch_queue_create("com.example.testqueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSMutableArray *arr = [NSMutableArray new];
    
    dispatch_async(queue, ^{
        NSLog(@"thread %@", [NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        for (int i = 1; i < 9999999; i++) {
            [arr addObject:@(i)];
        }
        NSLog(@"thread 1, arr count: %lu", [arr count]);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"thread %@", [NSThread currentThread]);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        for (int i = 1; i < 999999; i++) {
            [arr addObject:@(i)];
        }
        NSLog(@"thread 2, arr count: %lu", [arr count]);
        dispatch_semaphore_signal(semaphore);
    });
    
    [arr addObject:@0];
    NSLog(@"arr count:%lu", (unsigned long)[arr count]);
    dispatch_semaphore_signal(semaphore);
}

// 读写锁也是一种自旋锁
- (void)testReadWriteLock {
    self.queue = dispatch_queue_create("com.test.readwritelock", DISPATCH_QUEUE_CONCURRENT);
    self.dic = [@{} mutableCopy];
}

- (void)zr_setValue:(id)value forKey:(NSString *)key {
    dispatch_barrier_async(self.queue, ^{
        NSLog(@"write value: %@ for key:%@", value, key);
        [self.dic setObject:value forKey:key];
    });
}

- (id)zr_getValueForKey:(NSString *)key {
    __block id value;
    dispatch_sync(self.queue, ^{
        value = [self.dic objectForKey:key];
    });
    NSLog(@"read value: %@ from key:%@", value, key);
    return value;
}

@end
