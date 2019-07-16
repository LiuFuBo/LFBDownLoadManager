//
//  LFBTabBarVc.m
//  LFBDownLoadManager
//
//  Created by liufubo on 2019/7/15.
//  Copyright © 2019 liufubo. All rights reserved.
//

#import "LFBTabBarVc.h"
#import "LFBHomeViewController.h"
#import "LFBMineViewController.h"

@interface LFBTabBarVc ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation LFBTabBarVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpControllers];
    self.tabBar.translucent = NO;
    self.delegate = self;
}


- (void)setUpControllers{
    
    //首页
    LFBHomeViewController *homeVc = [[LFBHomeViewController alloc]init];
    [self setupChildViewController:homeVc title:@"首页" imageName:@"home_tab_bar_nor" selectedImageName:@"home_tab_bar_sel"];
    
    //个人中心
    LFBMineViewController *mineVc = [[LFBMineViewController alloc]init];
    [self setupChildViewController:mineVc title:@"我的" imageName:@"mine_tab_bar_nor" selectedImageName:@"mine_tab_bar_sel"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    //1.设置控制器的属性
    childVc.title = title;
    //设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    [childVc.tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    
    //设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    //包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}

@end
