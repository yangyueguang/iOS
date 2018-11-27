//  ResumeNavigationController.m
//  Freedom
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "ResumeNavigationController.h"
@implementation ResumeNavigationController
//第一次使用这个类的时候调用一次
+(void)initialize{
    //获得当前类下面的UIBarButtonItem
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    
    //设置导航条按钮的文字颜色
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [item setTitleTextAttributes:titleAttr forState:UIControlStateNormal];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
