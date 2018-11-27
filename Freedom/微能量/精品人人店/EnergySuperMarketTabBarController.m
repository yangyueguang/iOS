//  EnergySuperMarketTabBarController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergySuperMarketTabBarController.h"
#import "EnergySuperHomeViewController.h"
#import "EnergyShopTabBarController.h"
#import "EnergyShopViewController.h"
#import "EnergySuperMeViewController.h"
#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"
static EnergySuperMarketTabBarController *rootVC = nil;
@interface EnergySuperMarketTabBarController ()
@property (nonatomic, strong) EnergyShopTabBarController *stabbar;
@property (nonatomic, strong) NSArray *childVCArray;
@end
@implementation EnergySuperMarketTabBarController
+ (EnergySuperMarketTabBarController *)sharedRootViewController{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        rootVC = [[EnergySuperMarketTabBarController alloc] init];
    });
    return rootVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.childVCArray = @[
                          @{kClassKey:@"EnergySuperHomeViewController",kTitleKey:@"微商城",kImgKey:@"tabbar_mainframe",kSelImgKey:@"tabbar_mainframeHL"},
                          @{kClassKey:@"EnergyShopViewController",kTitleKey:@"人人店案例",kImgKey:@"tabbar_contacts",kSelImgKey:@"tabbar_contactsHL"},
                          @{kClassKey:@"EnergySuperMeViewController",kTitleKey:@"个人中心",kImgKey:@"tabbar_me",kSelImgKey:@"tabbar_meHL"}];
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
-(EnergyShopTabBarController *)stabbar{
    if(!_stabbar){
        _stabbar = [EnergyShopTabBarController sharedRootViewController];
    }
    return _stabbar;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.stabbar popoverPresentationController];
    [self.stabbar removeFromParentViewController];
    [self.superTabbar setSelectedIndex:self.backTab];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self setSelectedIndex:1];
//}
@end
