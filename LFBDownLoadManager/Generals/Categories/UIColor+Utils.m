//
//  UIColor+Utils.m
//  YXYT
//
//  Created by liufubo on 2018/12/20.
//  Copyright © 2018 yixingyiting. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorFromString:(NSString *)aColorString alpha:(CGFloat)aAlpha{
    
    if (aColorString.length == 0) {
        return nil;
    }
    
    if ([aColorString hasPrefix:@"#"]) {
        aColorString = [aColorString substringFromIndex:1];
    }
    
    if (aColorString.length == 6) {
        int len = (int)aColorString.length/3;
        unsigned int a[3];
        for (int i= 0 ; i< 3; i++) {
            NSRange range;
            range.location = i * len;
            range.length = len;
            NSString *str = [aColorString substringWithRange:range];
            [[NSScanner scannerWithString:str] scanHexInt: a + i];
        }
        
        return [self colorWithRed:a[0]/255.0f green:a[1]/255.0f blue:a[2]/255.0f alpha:aAlpha];
    }else if (aColorString.length == 8){
        
        int len = (int)aColorString.length/4;
        unsigned int a[4];
        for (int i=0; i<4; i++) {
            NSRange range;
            range.location = i * len;
            range.length = len;
            NSString *str = [aColorString substringWithRange:range];
            [[NSScanner scannerWithString:str] scanHexInt: a + i];
        }
        return [self colorWithRed:a[0]/255.0f green:a[1]/255.0f blue:a[2]/255.0f alpha:a[3]/255.0f];
    }else if (aColorString.length <= 2){
        
        unsigned int gray;//灰度
        [[NSScanner scannerWithString:aColorString] scanHexInt:&gray];
        if (aColorString.length == 1) {
            gray *= 17;
        }
        return [self colorWithWhite:gray/255.0f alpha:aAlpha];
    }
    return nil;
}

+ (UIColor *)colorFromString:(NSString *)aColorString{
    
    return [self colorFromString:aColorString alpha:1.0f];
}

+ (NSString *)stringFromColor:(UIColor *)aColor{
    
    const CGFloat *rgba = CGColorGetComponents(aColor.CGColor);
    NSString *colorString = [NSString stringWithFormat:@"%02X%02X%02X%02X",(int)(rgba[0] * 255),(int)(rgba[1] * 255),(int)(rgba[2] * 255),(int)(rgba[3] * 255)];
    
    return colorString;
}

@end
