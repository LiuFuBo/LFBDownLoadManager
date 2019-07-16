//
//  AppDelegate.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/10.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//后台所有下载任务完成回调
@property (nonatomic, copy) void(^backgroundSessionCompletionHandler)(void);

@end

