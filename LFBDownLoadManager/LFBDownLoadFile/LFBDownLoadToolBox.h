//
//  LFBDownLoadToolBox.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LFBDownLoadToolBox : NSObject

// 根据字节大小返回文件大小字符KB、MB
+ (NSString *)stringFromByteCount:(long long)byteCount;

// 时间转换为时间戳
+ (NSTimeInterval)getTimeStampWithDate:(NSDate *)date;

// 时间戳转换为时间
+ (NSDate *)getDateWithTimeStamp:(NSTimeInterval)timeStamp;

// 一个时间戳与当前时间的间隔（s）
+ (NSInteger)getIntervalsWithTimeStamp:(NSTimeInterval)timeStamp;

//获得当前设备型号
+ (NSString *)getCurrentDeviceModel;

//删除path路径下的文件
+ (void)clearCachesWithFilePath:(NSString *)path;

//获取沙盒Library的文件目录
+ (NSString *)LibraryDirectory;

//获取沙盒Document的文件目录
+ (NSString *)DocumentDirectory;

//获取沙盒Preference的文件目录
+ (NSString *)PreferencePanesDirectory;

// 获取沙盒Caches的文件目录
+ (NSString *)CachesDirectory;

//验证密码格式（包含大写、小写、数字）
+ (BOOL)isConformSXPassword:(NSString *)password;

//验证护照
+ (BOOL)isPassportNumber:(NSString *)number;

//计算文字的长度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

//去掉小数点后无效的零
+ (NSString *)deleteFailureZero:(NSString *)string;

//得到中英文混合字符串长度
+ (int)lengthForText:(NSString *)text;

//提示弹窗
+ (void)showAlertWithTitle:(NSString *)title sureMessage:(NSString *)sureMessage cancelMessage:(NSString *)cancelMessage warningMessage:(NSString *)warningMessage style:(UIAlertControllerStyle)UIAlertControllerStyle target:(id)target sureHandler:(void(^)(UIAlertAction *action))sureHandler cancelHandler:(void(^)(UIAlertAction *action))cancelHandler warningHandler:(void(^)(UIAlertAction *action))warningHandler;

//获取当前时间
+ (NSString *)currentTime;

// 获取当前时间（时分秒毫秒）
+ (NSString *)currentTimeCorrectToMillisecond;

@end


