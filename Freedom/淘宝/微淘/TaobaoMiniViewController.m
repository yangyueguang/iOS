
//  TaobaoMiniViewController.m
//  Created by Super on 17/1/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "TaobaoMiniViewController.h"
#import "TaobaoMiniDynamicViewController.h"
#import "TaobaoMiniNewViewController.h"
#import "TaobaoMiniVideoViewController.h"
#import "TaobaoMiniArticleViewController.h"
#import "TaobaoMiniTopicViewController.h"
@interface TaobaoMiniViewController (){
    BaseScrollView *TaobaoMiniScrollV;
}
@end
@implementation TaobaoMiniViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TaobaoScanner@2x"] style:UIBarButtonItemStyleDone actionBlick:^{
    }];
    UIBarButtonItem *rightI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TaobaoScanner@2x"] style:UIBarButtonItemStyleDone actionBlick:^{
    }];
    UIBarButtonItem *rightII = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TaobaoScanner@2x"] style:UIBarButtonItemStyleDone actionBlick:^{
    }];
    self.navigationItem.leftBarButtonItem  = leftI;
    self.navigationItem.rightBarButtonItems = @[rightI,rightII];
    self.title = @"微淘";
    NSArray *titles = @[@"动态",@"上新",@"视频",@"热文",@"话题榜"];
    NSArray *icons = @[@"taobaomini1",@"taobaomini2",@"taobaomini3",@"taobaomini4",@"taobaomini5"];
    NSArray *controllers = @[@"TaobaoMiniDynamicViewController",@"TaobaoMiniNewViewController",@"TaobaoMiniVideoViewController",@"TaobaoMiniArticleViewController",@"TaobaoMiniTopicViewController"];
    TaobaoMiniScrollV = [BaseScrollView sharedContentIconViewWithFrame:CGRectMake(0, 0, APPW,APPH-TabBarH-55) titles:titles icons:icons controllers:controllers inViewController:self];
    TaobaoMiniScrollV.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        DLog(@"点击了%ld,%@",index,dict);
    };
    [TaobaoMiniScrollV selectThePage:3];
}
@end
