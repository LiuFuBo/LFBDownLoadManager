//
//  AppDelegate.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/10.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "AppDelegate.h"
#import "LFBTabBarVc.h"
#import "LFBDownLoadManager.h"
#import "LFBNetworkReachabilityManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LFBTabBarVc *tabBarVc = [[LFBTabBarVc alloc]init];
    [self.window setRootViewController:tabBarVc];
    [self.window makeKeyAndVisible];
    //开启网络监听
    [[LFBNetworkReachabilityManager shareManager] monitorNetworkStatus];
    //初始化下载单例，若之前程序杀死时有正在下载的任务，会自动恢复下载
    [LFBDownLoadManager shareManager];
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    _backgroundSessionCompletionHandler = completionHandler;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
