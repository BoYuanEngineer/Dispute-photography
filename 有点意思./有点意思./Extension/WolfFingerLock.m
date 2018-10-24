//
//  WolfFingerLock.m
//  SiriTest
//
//  Created by WolfCub on 16/11/16.
//  Copyright © 2016年 WolfCub. All rights reserved.
//

#import "WolfFingerLock.h"
#import <UIKit/UIKit.h>

@interface WolfFingerLock ()

@property (nonatomic, retain) LAContext *context;

@end

@implementation WolfFingerLock

+(instancetype)shareLock {
    
    static dispatch_once_t onceToken;
    
    static WolfFingerLock* lock=nil;
    
    dispatch_once(&onceToken, ^{
        
        lock=[[WolfFingerLock alloc] init];
        
        lock.context = [[LAContext alloc] init];
    });
    
    return lock;
}

+(BOOL)canShow {
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        
        return NO;
    }
    
    if (![[WolfFingerLock shareLock].context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        
        return NO;
    }
    
    return YES;
}

+(void)showLockNeedPhonePassword:(BOOL)needPhonePassword OnSuccess:(Successed)successed onFail:(Failed)failed {
    
    NSInteger policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    
    if (needPhonePassword && [UIDevice currentDevice].systemVersion.floatValue > 9.0) {
        
        policy = LAPolicyDeviceOwnerAuthentication;
    }
    
    [[WolfFingerLock shareLock].context evaluatePolicy:policy localizedReason:LOCK_SHOW_WORDS reply:^(BOOL success, NSError * _Nullable error) {
       
        if (success) {
            
            successed();
            
        } else {
            
            failed(error);
        }
        
    }];
}

@end
