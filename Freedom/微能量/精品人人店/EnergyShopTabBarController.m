//  EnergyShopTabBarController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergyShopTabBarController.h"
#import "EnergyShopHomeViewController.h"
#import "EnergyShopFindViewController.h"
#import "EnergyShopCarViewController.h"
#import "EnergyShopMeViewController.h"
#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
static EnergyShopTabBarController *rootVC = nil;
@interface EnergyShopTabBarController ()
@property (nonatomic, strong) NSArray *childVCArray;
@end
@implementation EnergyShopTabBarController
+ (EnergyShopTabBarController *)sharedRootViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        rootVC = [[EnergyShopTabBarController alloc] init];
    });
    return rootVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.childVCArray = @[
    @{kClassKey:@"EnergyShopHomeViewController",kTitleKey:@"首页",kImgKey:@"tabbar_mainframe",kSelImgKey:@"tabbar_mainframeHL"},
    @{kClassKey:@"EnergyShopFindViewController",kTitleKey:@"人人店",kImgKey:@"tabbar_contacts",kSelImgKey:@"tabbar_contactsHL"},
    @{kClassKey:@"EnergyShopCarViewController",kTitleKey:@"购物车",kImgKey:@"tabbar_discover",kSelImgKey:@"tabbar_discoverHL"},
    @{kClassKey:@"EnergyShopMeViewController",kTitleKey:@"我的",kImgKey:@"tabbar_me",kSelImgKey:@"tabbar_meHL"}];
    [self.childVCArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        vc.title = dict[kTitleKey];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *item = nav.tabBarItem;
        item.title = dict[kTitleKey];
        item.image = [UIImage imageNamed:dict[kImgKey]];
        item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLOR(0, 190, 12)} forState:UIControlStateSelected];
        [self addChildViewController:nav];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
@end
