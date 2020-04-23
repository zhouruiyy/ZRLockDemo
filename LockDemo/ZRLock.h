//
//  ZRLock.h
//  LockDemo
//
//  Created by Zhou,Rui(ART) on 2020/4/23.
//  Copyright © 2020 Zhou,Rui(ART). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZRLock : NSObject

- (void)synchronized_mayCrash;

- (void)lock_dead;

- (void)testConditonLock;

- (void)testDispatchSemaphore;

- (void)testReadWriteLock;
- (void)zr_setValue:(id)value forKey:(NSString *)key;
- (id)zr_getValueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
