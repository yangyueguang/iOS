//  ResumeViewController.m
//  Freedom
//  Created by Super on 16/8/18.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "ResumeViewController.h"
#import "ResumeListViewController.h"
#import "ResumeDetailViewController.h"
@interface ResumeViewCell:BaseTableViewCell
@end
@implementation ResumeViewCell
-(void)initUI{
}
-(void)setDataWithDict:(NSDictionary *)dict{
    
}
@end
@interface ResumeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *refTableView;
    UILabel *label;
    BaseScrollView *ResumeHomeScrollV;
}
@end
@implementation ResumeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    NSArray *a = [NSArray arrayWithObjects:@{@"pic":PuserLogo,@"name":@"我的简历",@"url":ResumeURL},@{@"pic":PuserLogo,@"name":@"微信小程序1",@"url":WeChatApplet1},@{@"pic":PuserLogo,@"name":@"微信小程序2",@"url":WeChatApplet2},
                  @{@"pic":PuserLogo,@"name":@"微页1",@"url":MicroPage1},@{@"pic":PuserLogo,@"name":@"微页2",@"url":MicroPage2},@{@"pic":PuserLogo,@"name":@"微页3",@"url":MicroPage3}, nil];
    NSArray *b = [NSArray arrayWithObjects:@{@"pic":PuserLogo,@"name":@"我的简历",@"url":ResumeURL},@{@"pic":PuserLogo,@"name":@"微信小程序1",@"url":WeChatApplet1},@{@"pic":PuserLogo,@"name":@"微信小程序2",@"url":WeChatApplet2},
                  @{@"pic":PuserLogo,@"name":@"微页1",@"url":MicroPage1},@{@"pic":PuserLogo,@"name":@"微页2",@"url":MicroPage2},@{@"pic":PuserLogo,@"name":@"微页3",@"url":MicroPage3}, nil];
    NSArray *c = [NSArray arrayWithObjects:@{@"pic":PuserLogo,@"name":@"我的简历",@"url":ResumeURL},@{@"pic":PuserLogo,@"name":@"微信小程序1",@"url":WeChatApplet1},@{@"pic":PuserLogo,@"name":@"微信小程序2",@"url":WeChatApplet2},
                  @{@"pic":PuserLogo,@"name":@"微页1",@"url":MicroPage1},@{@"pic":PuserLogo,@"name":@"微页2",@"url":MicroPage2},@{@"pic":PuserLogo,@"name":@"微页3",@"url":MicroPage3}, nil];
    NSArray *lists = @[a,b,c];
    
    NSArray *titles = @[@"我的成长史",@"我的作品",@"我的经历"];
    NSArray *controllers = @[@"ResumeListViewController",@"ResumeListViewController",@"ResumeListViewController"];
    ResumeHomeScrollV = [BaseScrollView sharedContentTitleViewWithFrame:CGRectMake(0, 0, APPW, APPH-TabBarH) titles:titles controllers:controllers inViewController:self];
    @weakobj(ResumeHomeScrollV);
    ResumeHomeScrollV.selectBlock = ^(NSInteger index, NSDictionary *dict) {
        ResumeListViewController *con = weak_ResumeHomeScrollV.contentScrollView.pushDelegateVC.childViewControllers[index];
        con.listArray = lists[index];
    };
}
@end
