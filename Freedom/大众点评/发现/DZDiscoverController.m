//  DZDiscoverController.m
//  Freedom
//  Created by Super on 15/12/1.
//  Copyright (c) 2015年 dengw. All rights reserved.
#import "DZDiscoverController.h"
@interface DZDiscoverController (){
    BaseScrollView *contentScrollView;
}
@end
@implementation DZDiscoverController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}
-(void)buildUI{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入商户名、地点";
    self.navigationItem.titleView = searchBar;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *map = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain actionBlick:^{
    }];
    self.navigationItem.leftBarButtonItem = map;
    NSArray *titles = @[@"精选",@"嗨周末",@"变漂亮",@"潮餐厅",@"出去浪",@"探店报告"];
    NSArray *controllers = @[@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController"];
    contentScrollView = [BaseScrollView sharedContentTitleViewWithFrame:CGRectMake(0, 0, APPW, APPH-55) titles:titles controllers:controllers inViewController:self];
    contentScrollView.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        DLog(@"点击了%ld,%@",index,dict);
    };
    
}
@end
