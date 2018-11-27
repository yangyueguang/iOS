//  ToutiaoTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "ToutiaoTabBarController.h"
@implementation ToutiaoTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    //通过设置文本属性来设置字体颜色
    for(UIViewController *s in self.childViewControllers){
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:redcolor forKey:NSForegroundColorAttributeName];
        [s.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        s.tabBarItem.image = [s.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.selectedImage = [s.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //管理子控制器
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
@end
