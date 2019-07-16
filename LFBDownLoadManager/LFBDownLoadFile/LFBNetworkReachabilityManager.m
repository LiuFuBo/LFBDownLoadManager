//
//  LFBNetworkReachabilityManager.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBNetworkReachabilityManager.h"
#import "LFBDownLoadConst.h"

@interface LFBNetworkReachabilityManager ()
@property (nonatomic, assign, readwrite) AFNetworkReachabilityStatus networkReachabilityStatus;
@end

@implementation LFBNetworkReachabilityManager


+ (instancetype)shareManager
{
    static LFBNetworkReachabilityManager *instance = nil;
    
    static dispatch_once_t o;
    dispatch_once(&o, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

// 监听网络状态
- (void)monitorNetworkStatus
{
    // 创建网络监听者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                // 未知网络
                NSLog(@"当前网络：未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                // 无网络
                NSLog(@"当前网络：无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                // 蜂窝数据
                NSLog(@"当前网络：蜂窝数据");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // 无线网络
                NSLog(@"当前网络：无线网络");
                break;
                
            default:
                break;
        }
        
        if (self->_networkReachabilityStatus != status) {
            self->_networkReachabilityStatus = status;
            // 网络改变通知
            [[NSNotificationCenter defaultCenter] postNotificationName:LFBNetworkingReachabilityDidChangeNotification object:[NSNumber numberWithInteger:status]];
        }
    }];
    
    // 开始监听
    [manager startMonitoring];
}

@end
