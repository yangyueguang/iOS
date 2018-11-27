//  MicroEnergyTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "MicroEnergyTabBarController.h"
#import "UIImage+expanded.h"
#import "EnergyNavigationController.h"
#import "EnergySuperMarketTabBarController.h"
@interface MicroEnergyTabBarController ()<UITabBarControllerDelegate>{
    EnergySuperMarketTabBarController *myTabBar;
}
@end
@implementation MicroEnergyTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = RGBACOLOR(59, 59, 59,1);
    //通过设置文本属性来设置字体颜色
    for(int i=0;i<self.childViewControllers.count;i++){
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        UIViewController *s = self.childViewControllers[i];
        [s.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        s.tabBarItem.image = [s.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.selectedImage = [s.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.tag = i;
    }
    myTabBar=[EnergySuperMarketTabBarController sharedRootViewController];
    myTabBar.hidesBottomBarWhenPushed = YES;
    myTabBar.superTabbar = self;
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item.tag!=3){
         myTabBar.backTab = item.tag;
    }else{
        EnergyNavigationController *navi = self.childViewControllers[3];
        [navi pushViewController:myTabBar animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
@end
