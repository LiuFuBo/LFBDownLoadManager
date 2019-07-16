//
//  LFBDownLoadManager.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/10.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFBDownLoadModel;

typedef NS_ENUM(NSInteger, LFBDownLoadState) {
    LFBDownLoadStateDefault = 0, //默认
    LFBDownLoadStateDownLoading, //正在下载
    LFBDownLoadStateWaiting, //等待
    LFBDownLoadStatePaused, //暂停
    LFBDownLoadStateFinish, //完成
    LFBDownLoadStateError //错误
};

@interface LFBDownLoadManager : NSObject


/**
 初始化单例 (若之前程序杀死时有正在下载的任务，会自动恢复下载)

 @return 返回单例
 */
+ (instancetype)shareManager;

//开始下载
- (void)startDownloadTask:(LFBDownLoadModel *)model;

//暂停下载
- (void)pauseDownloadTask:(LFBDownLoadModel *)model;

//删除下载任务及本地缓存
- (void)deleteTaskAndCache:(LFBDownLoadModel *)model;

@end

