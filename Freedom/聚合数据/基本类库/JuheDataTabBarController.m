//  JuheDataTabBarController.m
//  Created by Super on 16/8/19.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "JuheDataTabBarController.h"
@interface JuheDataTabBarController ()
@property (nonatomic, strong) NSMutableArray *items;
@end
@implementation JuheDataTabBarController
- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //通过设置文本属性来设置字体颜色
    for(UIViewController *s in self.childViewControllers){
        NSMutableDictionary *attM = [NSMutableDictionary dictionary];
        [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
        [s.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
        s.tabBarItem.image = [s.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        s.tabBarItem.selectedImage = [s.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //管理子控制器
    //    [self setUpAllChildViewController];
}
#pragma mark 添加所有子控制器
-(void)setUpAllChildViewController{
    //首页
    //    DZHomeController *home = [[DZHomeController alloc] init];
    //    [self setUpOneChildViewController:home image:@"home_footbar_icon_dianping@2x" selectedImage:@"home_footbar_icon_dianping_pressed@2x" title:@"首页"];
    //
    //    //团购
    //    DZDealController *deal = [[DZDealController alloc] init];
    //    [self setUpOneChildViewController:deal image:@"home_footbar_icon_group@2x" selectedImage:@"home_footbar_icon_group_pressed@2x" title:@"团购"];
    //
    //    //发现
    //    DZDiscoverController *discover = [[DZDiscoverController alloc] init];
    //    [self setUpOneChildViewController:discover image:@"home_footbar_icon_found@2x" selectedImage:@"home_footbar_icon_found_pressed@2x" title:@"发现"];
    //
    //    //我的
    //    DZMeController *profile = [[DZMeController alloc] init];
    //    [self setUpOneChildViewController:profile image:@"home_footbar_icon_my@2x" selectedImage:@"home_footbar_icon_my_pressed@2x" title:@"我的"];
    
}
#pragma mark 添加一个子控制器
-(void)setUpOneChildViewController:(UIViewController *)viewController image:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title{
    //    viewController.tabBarItem.title = title;
    //    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    //    viewController.tabBarItem.selectedImage = [UIImage imageWithRenderingOriginalName:selectedImageName];
    //
    //    //通过设置文本属性来设置字体颜色
    //    NSMutableDictionary *attM = [NSMutableDictionary dictionary];
    //    [attM setObject:[UIColor orangeColor] forKey:NSForegroundColorAttributeName];
    //    [viewController.tabBarItem setTitleTextAttributes:attM forState:UIControlStateSelected];
    //
    //    // 保存tabBarItem模型到数组
    //    [self.items addObject:viewController.tabBarItem];
    //
    //    DianpingNavigationController *nav = [[DianpingNavigationController alloc] initWithRootViewController:viewController];
    //    
    //    [self addChildViewController:nav];
}
@end
