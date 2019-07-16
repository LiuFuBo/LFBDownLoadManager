//
//  LFBDownLoadDataSQLite.h
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFBDownLoadModel;

typedef NS_OPTIONS(NSUInteger, LFBSQLiteUpdateOption) {
    LFBSQLiteUpdateOptionState       = 1 << 0, //更新状态
    LFBSQLiteUpdateOptionLastStateTime = 1 << 1, //更新状态最后改变的时间
    LFBSQLiteUpdateOptionResumeData = 1 << 2, //更新下载的数据
    LFBSQLiteUpdateOptionProgressData = 1 << 3, //更新进度数据 (包含tmpFileSize、totalFileSize、progress、intervalFileSize、lastSpeedTime)
    LFBSQLiteUpdateOptionAllParam = 1 << 4 //更新全部数据
};

@interface LFBDownLoadDataSQLite : NSObject

//获取单例
+ (instancetype)shareManager;

//插入数据
- (void)insertModel:(LFBDownLoadModel *)model;

//获取数据
- (LFBDownLoadModel *)getModelWithUrl:(NSString *)url; //根据url获取数据
- (LFBDownLoadModel *)getWaitingModel; //获取第一条等待的数据
- (LFBDownLoadModel *)getLastDownloadingModel; //获取最后一条正在下载的数据
- (NSArray<LFBDownLoadModel *> *)getAllCacheData; //获取所有数据
- (NSArray<LFBDownLoadModel *> *)getAllDownloadingData; //根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<LFBDownLoadModel *> *)getAllDownloadedData; //获取所有下载完成的数据
- (NSArray<LFBDownLoadModel *> *)getAllUnDownloadedData; //获取所有未下载完成的数据 (包含正在下载、等待、暂停、错误)
- (NSArray<LFBDownLoadModel *> *)getAllWaitingData; //获取所有等待下载的数据


//更新数据
- (void)updateWithModel:(LFBDownLoadModel *)model option:(LFBSQLiteUpdateOption)option;


//删除数据
- (void)deleteModelWithUrl:(NSString *)url;

@end


