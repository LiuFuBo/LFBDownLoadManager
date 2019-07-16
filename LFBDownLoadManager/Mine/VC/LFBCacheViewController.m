//
//  LFBCacheViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/16.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBCacheViewController.h"
#import "LFBDownloadingViewController.h"
#import "UIView+Utils.h"

#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavHeight (KStatusBarHeight + 44.f)
#define KIsBangScreen (KStatusBarHeight > 20.1)  // 刘海屏，状态栏44pt，底部留功能区34pt
#define KTabBarHeight (KIsBangScreen ? 83.0f : 49.0f)
#define KBottomSafeArea (KIsBangScreen ? 34.0f : 0.0f)
@interface LFBCacheViewController ()
@property (nonatomic, weak) UIButton *downloadingBtn;
@property (nonatomic, assign) NSInteger downloadingCount;
@end

@implementation LFBCacheViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 获取缓存
    [self getCacheData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缓存";
    [self initUI];
    // 添加通知
    [self addNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)initUI {
    // 正在缓存按钮
    UIButton *downloadingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    downloadingBtn.hidden = YES;
    downloadingBtn.backgroundColor = [UIColor lightGrayColor];
    [downloadingBtn addTarget:self action:@selector(downloadingBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downloadingBtn];
    _downloadingBtn = downloadingBtn;
}


- (void)downloadingBtnOnClick
{
    [self.navigationController pushViewController:[[LFBDownloadingViewController alloc] init] animated:YES];
}

- (void)addNotification
{
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:LFBDownloadStateChangeNotification object:nil];
}

- (void)getCacheData
{
    // 获取已缓存数据
    self.dataSource = [[[LFBDownLoadDataSQLite shareManager] getAllDownloadedData] mutableCopy];
    [self reloadTableView];
    
    // 获取所有未下载完成的数据
    _downloadingCount = [[LFBDownLoadDataSQLite shareManager] getAllUnDownloadedData].count;
    [self reloadCacheView];
}

// 刷新正在缓存提示视图
- (void)reloadCacheView
{
    _downloadingBtn.hidden = _downloadingCount == 0;
    [_downloadingBtn setTitle:[NSString stringWithFormat:@"%ld个文件正在缓存", _downloadingCount] forState:UIControlStateNormal];
    
    self.tableView.top = _downloadingCount == 0 ? 0 : _downloadingBtn.height;
    self.tableView.height = KMainH - KNavHeight;
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    LFBDownLoadModel *downloadModel = notification.object;
    
    if (downloadModel.state == LFBDownLoadStateFinish) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self insertModel:downloadModel];
            self->_downloadingCount--;
            [self reloadCacheView];
        });
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
