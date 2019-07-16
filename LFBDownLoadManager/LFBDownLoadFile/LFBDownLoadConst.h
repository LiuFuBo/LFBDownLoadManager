//
//  LFBDownLoadConst.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/12.
//  Copyright © 2019 liufubo. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LFBDownLoadToolBox.h"
#import <Foundation/Foundation.h>

//进度回调通知
UIKIT_EXTERN NSString *const LFBDownloadProgressNotification;
//状态改变通知
UIKIT_EXTERN NSString *const LFBDownloadStateChangeNotification;
//最大同时下载数量key
UIKIT_EXTERN NSString *const LFBDownloadMaxConcurrentCountKey;
//最大同时下载数量改变通知
UIKIT_EXTERN NSString *const LFBDownloadMaxConcurrentCountChangeNotification;
//是否允许蜂窝网络下载key
UIKIT_EXTERN NSString *const LFBDownloadAllowsCellularAccessKey;
//是否允许蜂窝网络下载改变通知
UIKIT_EXTERN NSString *const LFBDownloadAllowsCellularAccessChangeNotification;
//网络改变通知
UIKIT_EXTERN NSString *const LFBNetworkingReachabilityDidChangeNotification;

#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;

#define NSLog(...) printf("[%s] %s [第%d行] %s\n", [[LFBDownLoadToolBox currentTimeCorrectToMillisecond] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#ifdef DEBUG
#define LFBLog(format, ...) printf("[%s] %s [第%d行] %s\n", [[LFBDownLoadToolBox currentTimeCorrectToMillisecond] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define LFBLog(format, ...)
#endif


@interface LFBDownLoadConst : NSObject



@end


