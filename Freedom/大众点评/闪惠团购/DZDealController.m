//  DZDealController.m
//  Freedom
//  Created by Super on 15/12/1.
#import "DZDealController.h"
#import "DZDealListViewController.h"
@interface DZDealController (){
    BaseScrollView *contentScrollView;
}
@end
@implementation DZDealController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}
#pragma mark 搭建UI界面
-(void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *map = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain actionBlick:^{
    }];
    self.navigationItem.leftBarButtonItem = map;
    self.navigationItem.title = @"团购";
    NSArray *titles = @[@"精选",@"享美食",@"点外卖",@"看电影",@"趣休闲"];
    NSArray *controllers = @[@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController",@"DZDealListViewController"];
    contentScrollView = [BaseScrollView sharedContentTitleViewWithFrame:CGRectMake(0, 0, APPW, APPH-100) titles:titles controllers:controllers inViewController:self];
    contentScrollView.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        DLog(@"点击了%ld,%@",index,dict);
    };
}
@end
