//
//  ViewController.m
//  LockDemo
//
//  Created by Zhou,Rui(ART) on 2020/4/23.
//  Copyright © 2020 Zhou,Rui(ART). All rights reserved.
//

#import "ViewController.h"
#import "ZRLock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZRLock *lock = [[ZRLock alloc] init];
    // 1.synchronize test
    [lock synchronized_mayCrash];
    
    // 2.lock test
//    [lock lock_dead];
    
    // 3.test NSConditonLock
//    [lock testConditonLock];
    
    // 4.test dispatch_semaphore
//    [lock testDispatchSemaphore];
    
    // 5.test read write lock
//    [lock testReadWriteLock];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [lock zr_setValue:[NSObject new] forKey:@"a"];
//        [lock zr_getValueForKey:@"a"];
//        [lock zr_getValueForKey:@"a"];
//        [lock zr_getValueForKey:@"a"];
//        [lock zr_setValue:[NSObject new] forKey:@"b"];
//        [lock zr_setValue:[NSObject new] forKey:@"c"];
//        [lock zr_getValueForKey:@"b"];
//        [lock zr_getValueForKey:@"c"];
//    });
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [lock zr_setValue:[NSObject new] forKey:@"d"];
//        [lock zr_getValueForKey:@"d"];
//        [lock zr_getValueForKey:@"d"];
//        [lock zr_getValueForKey:@"d"];
//        [lock zr_setValue:[NSObject new] forKey:@"e"];
//        [lock zr_setValue:[NSObject new] forKey:@"f"];
//        [lock zr_getValueForKey:@"f"];
//        [lock zr_getValueForKey:@"e"];
//    });
}


@end
