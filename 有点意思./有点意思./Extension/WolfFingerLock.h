//
//  WolfFingerLock.h
//  SiriTest
//
//  Created by WolfCub on 16/11/16.
//  Copyright © 2016年 WolfCub. All rights reserved.
//

//依赖框架：LocalAuthentication.framework

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

#define LOCK_SHOW_WORDS @"把你的手指放在Home上！" //显示的话（副标题）

typedef void(^Successed)();

/**
 Error

 @param error error.code:{
                            LAErrorSystemCancel   :其他程序被唤起（打电话、点击通知消息），系统取消验证Touch ID
                            LAErrorUserCancel     :用户取消验证Touch ID
                            LAErrorUserFallback   :用户选择输入密码，切换主线程处理
                            LAErrorPasscodeNotSet :用户未设置指纹
                         }
 */
typedef void(^Failed)(NSError *error);

@interface WolfFingerLock : NSObject

/**
 判断设备是否支持指纹解锁，用于是否显示指纹解锁

 @return YES or NO
 */
+(BOOL)canShow;

/**
 唤起指纹解锁

 @param needPhonePassword 用户点击面板上的“输入密码”后，YES==输入iPhone解锁密码；NO==返回失败的Block中，error code==LAErrorUserFallback；只有在iOS9.0以上版本有效
 @param successed         指纹密码成功
 @param failed            指纹密码失败
 */
+(void)showLockNeedPhonePassword:(BOOL)needPhonePassword OnSuccess:(Successed)successed onFail:(Failed)failed;

@end
