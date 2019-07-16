//
//  LFBMineViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBMineViewController.h"
#import "LFBCacheViewController.h"
#import "LFBSettingViewController.h"

#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavHeight (KStatusBarHeight + 44.f)
#define KIsBangScreen (KStatusBarHeight > 20.1)  // 刘海屏，状态栏44pt，底部留功能区34pt
#define KTabBarHeight (KIsBangScreen ? 83.0f : 49.0f)
#define KBottomSafeArea (KIsBangScreen ? 34.0f : 0.0f)
@interface LFBMineViewController ()

@end

@implementation LFBMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    
    //我的缓存
    UIButton *cacheBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, KNavHeight + 50, [UIScreen mainScreen].bounds.size.width - 60, 44)];
    [cacheBtn setTitle:@"我的缓存" forState:UIControlStateNormal];
    [cacheBtn setBackgroundColor:[UIColor lightGrayColor]];
    [cacheBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cacheBtn addTarget:self action:@selector(cacheBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cacheBtn];
    
    //设置
    UIButton *setBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(cacheBtn.frame) + 50, [UIScreen mainScreen].bounds.size.width - 60, 44)];
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [setBtn setBackgroundColor:[UIColor lightGrayColor]];
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
}

- (void)cacheBtnOnClick {
    LFBCacheViewController *cacheVc = [[LFBCacheViewController alloc]init];
    [self.navigationController pushViewController:cacheVc animated:YES];
}

- (void)setBtnOnClick {
    LFBSettingViewController *setVc = [[LFBSettingViewController alloc]init];
    [self.navigationController pushViewController:setVc animated:YES];
}

@end
