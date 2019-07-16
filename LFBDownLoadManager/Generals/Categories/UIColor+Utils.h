//
//  UIColor+Utils.h
//  YXYT
//
//  Created by liufubo on 2018/12/20.
//  Copyright © 2018 yixingyiting. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Utils)

/**
 16进制颜色码转化为UIColor
 
 @param aColorString 16进制字符串
 @return 返回UIColor类型对象
 
   Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 */
+ (UIColor *)colorFromString:(NSString *)aColorString;

/**
 16进制颜色码转化为UIColor
 
 @param aColorString 16进制字符串
 @param aAlpha 透明度
 @return 返回UIColor类型对象
 
  Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 */
+ (UIColor *)colorFromString:(NSString *)aColorString alpha:(CGFloat)aAlpha;

/**
 UIColor对象类型转换为16进制编码
 
 @param aColor UIColor类型对象
 @return 16进制编码
 */
+ (NSString *)stringFromColor:(UIColor *)aColor;

@end

