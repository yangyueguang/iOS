
//  AlipayTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "AlipayTabBarController.h"
#import "SDBasicNavigationController.h"
#import "SDBasicViewContoller.h"
#import "SDHomeViewController.h"
#import "SDAssetsTableViewController.h"
#import "SDServiceTableViewController.h"
#import "SDDiscoverTableViewController.h"
#import "AlipayTools.h"
@implementation AlipayTabBarController
- (void)viewDidLoad{
    [super viewDidLoad];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    id itemsCache = [AlipayTools itemsArray];
    if (!itemsCache) {
        // 模拟数据
        NSArray *itemsArray =  @[@{@"淘宝" : @"i00"}, // title => imageString
                                 @{@"生活缴费" : @"i01"},
                                 @{@"教育缴费" : @"i02"},
                                 @{@"红包" : Phongbao},
                                 @{@"物流" : @"i04"},
                                 @{@"信用卡" : @"i05"},
                                 @{@"转账" : @"i06"},
                                 @{@"爱心捐款" : @"i07"},
                                 @{@"彩票" : @"i08"},
                                 @{@"当面付" : @"i09"},
                                 @{@"余额宝" : @"i10"},
                                 @{@"AA付款" : @"i11"},
                                 @{@"国际汇款" : @"i12"},
                                 @{@"淘点点" : @"i13"},
                                 @{@"淘宝电影" : @"i14"},
                                 @{@"亲密付" : @"i15"},
                                 @{@"股市行情" : @"i16"},
                                 @{@"汇率换算" : @"i17"}
                                 ];
        [AlipayTools saveItemsArray:itemsArray];
    }
    [self setupChildControllers];
}
- (void)setupChildControllers{
//    [self setupChildNavigationControllerWithClass:[SDBasicNavigationController class] tabBarImageName:@"TabBar_HomeBar" rootViewControllerClass:[SDHomeViewController class] rootViewControllerTitle:@"支付宝"];
//    [self setupChildNavigationControllerWithClass:[SDBasicNavigationController class] tabBarImageName:@"TabBar_Discovery" rootViewControllerClass:[SDDiscoverTableViewController class] rootViewControllerTitle:@"口碑"];
//        [self setupChildNavigationControllerWithClass:[SDBasicNavigationController class] tabBarImageName:@"TabBar_PublicService" rootViewControllerClass:[SDServiceTableViewController class] rootViewControllerTitle:@"朋友"];
//    [self setupChildNavigationControllerWithClass:[SDBasicNavigationController class] tabBarImageName:@"TabBar_Assets" rootViewControllerClass:[SDAssetsTableViewController class] rootViewControllerTitle:@"我的"];
}
- (void)setupChildNavigationControllerWithClass:(Class)class tabBarImageName:(NSString *)name rootViewControllerClass:(Class)rootViewControllerClass rootViewControllerTitle:(NSString *)title{
    UIViewController *rootVC = [[rootViewControllerClass alloc] init];
    rootVC.title = title;
    UINavigationController *navVc = [[class  alloc] initWithRootViewController:rootVC];
    navVc.tabBarItem.image = [UIImage imageNamed:name];
    navVc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_Sel", name]];
    [self addChildViewController:navVc];
}
@end
