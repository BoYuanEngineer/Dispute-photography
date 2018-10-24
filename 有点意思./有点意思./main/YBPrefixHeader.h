//
//  YBPrefixHeader.h
//  有点意思.
//
//  Created by mac on 2017/6/5.
//  Copyright © 2017年 Macx. All rights reserved.
//

#ifndef YBPrefixHeader_h
#define YBPrefixHeader_h

/**
 Masonry使用技巧:
 定义以下两个宏,在使用Masonry框架时就不需要加mas_前缀了
 (定义宏一定要在引入Masonry.h文件之前).
 */
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

//判断NSString是否为空
#define STRING_IS_NIL(content) ([content isEqualToString:@""] || [content isKindOfClass:[NSNull class]] || content == nil)

#define ZXTABHEIGHT 49
#define ZXNAVHEIGHT 64
#define ZXSTATEHEIGHT 20
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIScreenWidthScale SCREEN_WIDTH / 375 //以iphone6 尺寸为标准

#define USERDEFAULTS NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];

#import <Masonry.h>
#import "UIColor+Color.h"



#endif /* YBPrefixHeader_h */
