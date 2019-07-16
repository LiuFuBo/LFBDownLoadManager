//
//  LFBBaseViewController.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBBaseViewController.h"

@interface LFBBaseViewController ()

@end

@implementation LFBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adaptiveView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)adaptiveView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    // iOS 11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    if (@available(iOS 11, *)) [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

@end
