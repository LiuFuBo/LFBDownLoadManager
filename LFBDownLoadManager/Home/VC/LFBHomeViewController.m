//
//  LFBHomeViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBHomeViewController.h"
#import "LFBHomeTableViewCell.h"
#import "LFBPlayViewController.h"
#import "MJExtension.h"

#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavHeight (KStatusBarHeight + 44.f)
#define KIsBangScreen (KStatusBarHeight > 20.1)  // 刘海屏，状态栏44pt，底部留功能区34pt
#define KTabBarHeight (KIsBangScreen ? 83.0f : 49.0f)
#define KBottomSafeArea (KIsBangScreen ? 34.0f : 0.0f)
@interface LFBHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<LFBDownLoadModel *> *dataSource;
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation LFBHomeViewController


- (NSMutableArray<LFBDownLoadModel *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建控件
    [self creatControl];
    
    // 添加通知
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 获取网络数据
    [self getInfo];
    
    // 获取缓存
    [self getCacheData];
}

- (void)getInfo
{
    // 模拟网络数据
    NSArray *testData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testData.plist" ofType:nil]];
    
    // 转模型
    self.dataSource = [LFBDownLoadModel mj_objectArrayWithKeyValuesArray:testData];
}

- (void)getCacheData
{
    // 获取已缓存数据
    NSArray *cacheData = [[LFBDownLoadDataSQLite shareManager] getAllCacheData];
    
    // 这里是把本地缓存数据更新到网络请求的数据中，实际开发还是尽可能避免这样在两个地方取数据再整合
    for (int i = 0; i < self.dataSource.count; i++) {
        LFBDownLoadModel *model = self.dataSource[i];
        for (LFBDownLoadModel *downloadModel in cacheData) {
            if ([model.url isEqualToString:downloadModel.url]) {
                self.dataSource[i] = downloadModel;
                break;
            }
        }
    }
    
    [_tableView reloadData];
}

- (void)creatControl
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, KMainW - 20, KMainH - KNavHeight - KTabBarHeight)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 80.f;
    tableView.sectionHeaderHeight = 5.f;
    tableView.sectionFooterHeight = 5.f;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)addNotification
{
    // 进度通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadProgress:) name:LFBDownloadProgressNotification object:nil];
    // 状态改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateChange:) name:LFBDownloadStateChangeNotification object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LFBHomeTableViewCell *cell = [LFBHomeTableViewCell cellWithTableView:tableView];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LFBDownLoadModel *model = self.dataSource[indexPath.row];
    
    if (model.state == LFBDownLoadStateFinish) {
        LFBPlayViewController *vc = [[LFBPlayViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

#pragma mark - HWDownloadNotification
// 正在下载，进度回调
- (void)downLoadProgress:(NSNotification *)notification
{
    LFBDownLoadModel *downloadModel = notification.object;
    
    [self.dataSource enumerateObjectsUsingBlock:^(LFBDownLoadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 主线程更新cell进度
            dispatch_async(dispatch_get_main_queue(), ^{
                LFBHomeTableViewCell *cell = [self->_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
                [cell updateViewWithModel:downloadModel];
            });
            
            *stop = YES;
        }
    }];
}

// 状态改变
- (void)downLoadStateChange:(NSNotification *)notification
{
    LFBDownLoadModel *downloadModel = notification.object;
    
    [self.dataSource enumerateObjectsUsingBlock:^(LFBDownLoadModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.url isEqualToString:downloadModel.url]) {
            // 更新数据源
            self.dataSource[idx] = downloadModel;
            
            // 主线程刷新cell
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
            
            *stop = YES;
        }
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
