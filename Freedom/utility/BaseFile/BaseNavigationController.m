//  BaseNavigationController.m
//  Freedom
//  Created by Super on 16/9/20.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "BaseNavigationController.h"
@interface BaseNavigationController ()
@end
@implementation BaseNavigationController
//第一次使用这个类的时候调用一次
+(void)initialize{
    //获得当前类下面的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    //设置导航条按钮的文字颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = redcolor;
}
@end
