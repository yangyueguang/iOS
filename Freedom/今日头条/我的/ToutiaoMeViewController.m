//  ToutiaoMeViewController.m
//  Created by Super on 16/8/25.
//  Copyright © 2016年 Super. All rights reserved.
#import "ToutiaoMeViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface ToutiaoMeViewController ()
@end
@implementation ToutiaoMeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance]setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = YES;
    // 1.创建组
    SBaseGroup *group1 = [[SBaseGroup alloc]init];
    SBaseGroup *group2 = [[SBaseGroup alloc]init];
    SBaseGroup *group3 = [[SBaseGroup alloc]init];
    SBaseCell *c2 = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
    SBaseCell *c3 = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
    SBaseCell *c4 = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
    SBaseCell *c5 = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
    SBaseCell *c6 = [SBaseCell cellWithTableView:(UITableView *)self.tableView];
    self.c1.title = @"消息通知";
    __weak __typeof__(self) weakSelf = self;
    self.c1.operation = ^{
        [weakSelf doSomething];
    };
    c2.title = @"头条商城";
    c3.subtitle = @"点击速领200元新年红包";
    c3.title = @"京东特供";
    c4.title = @"我要爆料";
    c5.title = @"用户反馈";
    c6.title = @"系统设置";
    self.c1.accessoryType = c2.accessoryType = c3.accessoryType = c4.accessoryType = c5.accessoryType = c6.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    group1.items = @[self.c1];
    group2.items = @[c2,c3];
    group3.items = @[c4,c5,c6];
    [self.groups addObjectsFromArray:@[group1,group2,group3]];
    self.tableView.tableHeaderView = [self creatTableHeadView];
    self.tableView.frame = CGRectMake(0, 0, APPW, APPH);
    self.tableView.bounces = NO;
}
-(UIView*)creatTableHeadView{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 200)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 120)];
    for(int i=0;i<3;i++){
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50+120*i, 20, 50, 50)];
        button.layer.cornerRadius = 25;
        button.clipsToBounds = YES;
        [button setImage:[UIImage imageNamed:PuserLogo] forState:UIControlStateNormal];
        [view addSubview:button];
    }
    view.backgroundColor = RGBCOLOR(10, 10, 10);
    UILabel *label = [UILabel labelWithFrame:CGRectMake(10, H(view)-30, APPW-20, 20) font:fontnomal color:whitecolor text:@"登录推荐更精准" textAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    [head addSubview:view];
    NSArray *titles = @[@"收藏",@"历史",@"夜间"];
    for(int i=0;i<3;i++){
        UIButton *buton = [[UIButton alloc]initWithFrame:CGRectMake(i*APPW/3, YH(view), APPW/3, 60)];
        [buton setImage:[UIImage imageNamed:Pwechart] forState:UIControlStateNormal];
        [buton setTitle:titles[i] forState:UIControlStateNormal];
        [buton setImageEdgeInsets:UIEdgeInsetsMake(5, 45, 20, 45)];
        [buton setTitleEdgeInsets:UIEdgeInsetsMake(35, -APPW/3+10, 0, 0)];
        [buton setTitleColor:blacktextcolor forState:UIControlStateNormal];
        buton.titleLabel.font = fontnomal;
        buton.backgroundColor = whitecolor;
        [head addSubview:buton];
    }
    return head;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)doSomething{
    DLog(@"阿拉啦");
}
@end
