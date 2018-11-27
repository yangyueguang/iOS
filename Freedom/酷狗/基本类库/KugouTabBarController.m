//  KugouTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "KugouTabBarController.h"
#import "MainViewController.h"
#import "SettingViewController.h"
#import "KugouRightSettingViewController.h"
#import "RESideMenu.h"
@interface KugouTabBarController ()
@end
@implementation KugouTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建RESideMenu对象(指定内容/左边/右边)
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:[MainViewController new]];
    RESideMenu *sideViewController = [[RESideMenu alloc] initWithContentViewController:navi leftMenuViewController:[SettingViewController new] rightMenuViewController:[[KugouRightSettingViewController alloc]init]];
    sideViewController.backgroundImage = [UIImage imageNamed:@"bj"];
    //设置内容控制器的阴影颜色/半径/enable
    sideViewController.contentViewShadowColor = [UIColor blackColor];
    sideViewController.contentViewShadowRadius = 10;
    sideViewController.contentViewShadowEnabled = YES;
    [self addChildViewController:sideViewController];
}
- (TabBarView *)coustomTabBar{
    if (_coustomTabBar == nil) {
        _coustomTabBar = [TabBarView show];
        _coustomTabBar.frame = CGRectMake(0, 49-TabBarH, APPW, TabBarH);
    }return _coustomTabBar;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.tabBar addSubview:self.coustomTabBar];
}
@end
