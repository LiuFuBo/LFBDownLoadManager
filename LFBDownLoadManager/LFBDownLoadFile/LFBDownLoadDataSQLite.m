//
//  LFBDownLoadDataSQLite.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBDownLoadDataSQLite.h"
#import "LFBDownLoadModel.h"
#import "LFBDownLoadConst.h"
#import "LFBDownLoadToolBox.h"
#import "FMDB.h"

typedef NS_ENUM(NSInteger, LFBSQLiteGetDataOption) {
    LFBSQLiteGetDataOptionAllCacheData = 0, //所有缓存数据
    LFBSQLiteGetDataOptionAllDownloadingData, //所有正在下载的数据
    LFBSQLiteGetDataOptionAllDownloadedData, //所有下载完成的数据
    LFBSQLiteGetDataOptionAllUnDownloadedData, //所有未下载完成的数据
    LFBSQLiteGetDataOptionAllWaitingData, //所有等待下载的数据
    LFBSQLiteGetDataOptionModelWithUrl, //通过url获取单条数据
    LFBSQLiteGetDataOptionWaitingMode, //第一条等待的数据
    LFBSQLiteGetDataOptionLastDownloadingModel, //最后一条正在下载的数据
};

@interface LFBDownLoadDataSQLite ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation LFBDownLoadDataSQLite

+ (instancetype)shareManager {
    static LFBDownLoadDataSQLite *instance = nil;
    static dispatch_once_t o;
    dispatch_once(&o, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatCachesTable];
    }
    return self;
}

#pragma mark - 创建表
- (void)creatCachesTable {
    
    //数据库文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LFBDownloadFileDataCaches.sqlite"];
    //创建队列对象,内部会自动创建一个数据库，并且自动打开
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
       //创建表
        BOOL creatTableResult = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS l_fileDataCaches (id integer PRIMARY KEY AUTOINCREMENT, vid text, fileName text, url text, resumeData blob, totalFileSize integer, tmpFileSize integer, state integer, progress float, lastSpeedTime double, intervalFileSize integer, lastStateTime integer)"];
        if (creatTableResult) {
            LFBLog(@"创建表成功");
        }else{
            LFBLog(@"创建缓存数据表失败");
        }
    }];
}

#pragma mark - 插入数据
- (void)insertModel:(LFBDownLoadModel *)model {
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL insertDataResult = [db executeUpdate:@"INSERT INTO l_fileDataCaches (vid,fileName,url,resumeData,totalFileSize,tmpFileSize,state,progress,lastSpeedTime,intervalFileSize,lastStateTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",model.vid,model.fileName,model.url,model.resumeData,[NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithInteger:model.state], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithDouble:0], [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:0]];
        if (insertDataResult) {
            LFBLog(@"插入数据成功");
        }else {
            LFBLog(@"插入失败: %@",model.fileName);
        }
    }];
}

#pragma mark - 获取单条数据
- (LFBDownLoadModel *)getModelWithUrl:(NSString *)url {
    return [self getModelWithOption:LFBSQLiteGetDataOptionModelWithUrl url:url];
}

#pragma mark - 获取第一条等待的数据
- (LFBDownLoadModel *)getWaitingModel {
    return [self getModelWithOption:LFBSQLiteGetDataOptionWaitingMode url:nil];
}

#pragma mark - 获取最后一条正在下载的数据
- (LFBDownLoadModel *)getLastDownloadingModel {
    return [self getModelWithOption:LFBSQLiteGetDataOptionLastDownloadingModel url:nil];
}

#pragma mark - 获取所有数据
- (NSArray<LFBDownLoadModel *> *)getAllCacheData {
    return [self getDataWithOption:LFBSQLiteGetDataOptionAllCacheData];
}

#pragma mark - 根据lastStateTime倒叙获取所有正在下载的数据
- (NSArray<LFBDownLoadModel *> *)getAllDownloadingData {
    return [self getDataWithOption:LFBSQLiteGetDataOptionAllDownloadingData];
}

#pragma mark - 获取所有下载完成的数据
- (NSArray<LFBDownLoadModel *> *)getAllDownloadedData {
    return [self getDataWithOption:LFBSQLiteGetDataOptionAllDownloadedData];
}

#pragma mark - 获取所有未下载完成的数据
- (NSArray<LFBDownLoadModel *> *)getAllUnDownloadedData {
    return [self getDataWithOption:LFBSQLiteGetDataOptionAllUnDownloadedData];
}

#pragma mark - 获取所有等待下载的数据
- (NSArray<LFBDownLoadModel *> *)getAllWaitingData {
    return [self getDataWithOption:LFBSQLiteGetDataOptionAllWaitingData];
}

//获取单条数据
- (LFBDownLoadModel *)getModelWithOption:(LFBSQLiteGetDataOption)option url:(NSString *)url {
    
    __block LFBDownLoadModel *model = nil;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet;
        switch (option) {
            case LFBSQLiteGetDataOptionModelWithUrl:
                resultSet = [db executeQuery:@"SELECT *FROM l_fileDataCaches WHERE url = ?",url];
                break;
            case LFBSQLiteGetDataOptionWaitingMode:
                resultSet = [db executeQuery:@"SELECT *FROM l_fileDataCaches WHERE state = ? order by lastStateTime asc limit 0,1",[NSNumber numberWithInteger:LFBDownLoadStateWaiting]];
                break;
            case LFBSQLiteGetDataOptionLastDownloadingModel:
                resultSet = [db executeQuery:@"SELECT *FROM l_fileDataCaches WHERE state = ? order by lastStateTime desc limit 0,1",[NSNumber numberWithInteger:LFBDownLoadStateDownLoading]];
                break;
            default:
                break;
        }
        while ([resultSet next]) {
            model = [[LFBDownLoadModel alloc]initWithFMResultSet:resultSet];
        }
    }];
    return model;
}

//获取数据集合
- (NSArray<LFBDownLoadModel *> *)getDataWithOption:(LFBSQLiteGetDataOption)option {
    
    __block NSArray<LFBDownLoadModel *> *array = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet;
        switch (option) {
            case LFBSQLiteGetDataOptionAllCacheData:
                resultSet = [db executeQuery:@"SELECT * FROM l_fileDataCaches"];
                break;
                
            case LFBSQLiteGetDataOptionAllDownloadingData:
                resultSet = [db executeQuery:@"SELECT * FROM l_fileDataCaches WHERE state = ? order by lastStateTime desc", [NSNumber numberWithInteger:LFBDownLoadStateDownLoading]];
                break;
                
            case LFBSQLiteGetDataOptionAllDownloadedData:
                resultSet = [db executeQuery:@"SELECT * FROM l_fileDataCaches WHERE state = ?", [NSNumber numberWithInteger:LFBDownLoadStateFinish]];
                break;
                
            case LFBSQLiteGetDataOptionAllUnDownloadedData:
                resultSet = [db executeQuery:@"SELECT * FROM l_fileDataCaches WHERE state != ?", [NSNumber numberWithInteger:LFBDownLoadStateFinish]];
                break;
                
            case LFBSQLiteGetDataOptionAllWaitingData:
                resultSet = [db executeQuery:@"SELECT * FROM l_fileDataCaches WHERE state = ?", [NSNumber numberWithInteger:LFBDownLoadStateWaiting]];
                break;
                
            default:
                break;
        }
        
        NSMutableArray *tmpArr = [NSMutableArray array];
        while ([resultSet next]) {
            [tmpArr addObject:[[LFBDownLoadModel alloc] initWithFMResultSet:resultSet]];
        }
        array = tmpArr;
    }];
    
    return array;
}

#pragma mark - 更新数据
- (void)updateWithModel:(LFBDownLoadModel *)model option:(LFBSQLiteUpdateOption)option {
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (option & LFBSQLiteUpdateOptionState) {
            [self postStateChangeNotificationWithFMDatabase:db model:model];
            [db executeUpdate:@"UPDATE l_fileDataCaches SET state = ? WHERE url = ?", [NSNumber numberWithInteger:model.state], model.url];
        }
        if (option & LFBSQLiteUpdateOptionLastStateTime) {
            [db executeUpdate:@"UPDATE l_fileDataCaches SET lastStateTime = ? WHERE url = ?", [NSNumber numberWithInteger:[LFBDownLoadToolBox getTimeStampWithDate:[NSDate date]]], model.url];
        }
        if (option & LFBSQLiteUpdateOptionResumeData) {
            [db executeUpdate:@"UPDATE l_fileDataCaches SET resumeData = ? WHERE url = ?", model.resumeData, model.url];
        }
        if (option & LFBSQLiteUpdateOptionProgressData) {
            [db executeUpdate:@"UPDATE l_fileDataCaches SET tmpFileSize = ?, totalFileSize = ?, progress = ?, lastSpeedTime = ?, intervalFileSize = ? WHERE url = ?", [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.totalFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize], model.url];
        }
        if (option & LFBSQLiteUpdateOptionAllParam) {
            [self postStateChangeNotificationWithFMDatabase:db model:model];
            [db executeUpdate:@"UPDATE l_fileDataCaches SET resumeData = ?, totalFileSize = ?, tmpFileSize = ?, progress = ?, state = ?, lastSpeedTime = ?, intervalFileSize = ?, lastStateTime = ? WHERE url = ?", model.resumeData, [NSNumber numberWithInteger:model.totalFileSize], [NSNumber numberWithInteger:model.tmpFileSize], [NSNumber numberWithFloat:model.progress], [NSNumber numberWithInteger:model.state], [NSNumber numberWithDouble:model.lastSpeedTime], [NSNumber numberWithInteger:model.intervalFileSize], [NSNumber numberWithInteger:[LFBDownLoadToolBox getTimeStampWithDate:[NSDate date]]], model.url];
        }
    }];
}

//状态变更通知
- (void)postStateChangeNotificationWithFMDatabase:(FMDatabase *)db model:(LFBDownLoadModel *)model {
    
    //原状态
    NSInteger oldState = [db intForQuery:@"SELECT state FROM l_fileDataCaches WHERE url = ?",model.url];
    if (oldState != model.state && oldState != LFBDownLoadStateFinish) {
        //发送状态改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LFBDownloadStateChangeNotification object:model];
    }
}

#pragma mark - 删除数据
- (void)deleteModelWithUrl:(NSString *)url {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"DELETE FROM l_fileDataCaches WHERE url = ?", url];
        if (result) {
            LFBLog(@"删除成功：%@", url);
        }else {
            LFBLog(@"删除失败：%@", url);
        }
    }];
}

@end
