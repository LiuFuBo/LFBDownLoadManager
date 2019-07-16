//
//  LFBDownloadingViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/16.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBDownloadingViewController.h"
#import "LFBDownLoadFile.h"

@interface LFBDownloadingViewController ()

@end

@implementation LFBDownloadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在缓存";
    // 添加通知
    [self addNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    // 获取缓存
    [self getCacheData];
}


- (void)addNotification
{
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgress:) name:LFBDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:LFBDownloadStateChangeNotification object:nil];
}

- (void)getCacheData
{
    // 获取所有未下载完成的数据
    self.dataSource = [[[LFBDownLoadDataSQLite shareManager] getAllUnDownloadedData] mutableCopy];
    [self reloadTableView];
}

#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downLoadProgress:(NSNotification *)notification
{
    LFBDownLoadModel *downloadModel = notification.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource enumerateObjectsUsingBlock:^(LFBDownLoadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.url isEqualToString:downloadModel.url]) {
                // 更新cell进度
                [self updateViewWithModel:downloadModel index:idx];
                
                *stop = YES;
            }
        }];
    });
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    LFBDownLoadModel *downloadModel = notification.object;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataSource enumerateObjectsUsingBlock:^(LFBDownLoadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.url isEqualToString:downloadModel.url]) {
                if (downloadModel.state == LFBDownLoadStateFinish) {
                    // 下载完成，移除cell
                    [self deleteRowAtIndex:idx];
                    
                    // 没有正在下载的数据，则返回
                    if (self.dataSource.count == 0) [self.navigationController popViewControllerAnimated:YES];
                    
                }else {
                    // 刷新列表
                    [self reloadRowWithModel:downloadModel index:idx];
                }
                
                *stop = YES;
            }
        }];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
