//
//  UIColor+Color.h
//  中孝社区
//
//  Created by 吴思达 on 2016/10/18.
//  Copyright © 2016年 吴思达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)

+ (UIColor *)colorWithColorString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithColorString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

@end
