//  ToutiaoAttentionViewController.m
//  Created by Super on 16/8/25.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "ToutiaoAttentionViewController.h"
@interface ToutiaoAttentionViewCell:BaseTableViewCell
@end
@implementation ToutiaoAttentionViewCell
-(void)initUI{
    self.icon =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(XW(self.icon)+10,25, APPW-XW(self.icon)-20, 20)];
    self.title.font = fontTitle;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, APPW, 1)];
    self.line.backgroundColor = gradcolor;
    [self addSubviews:self.icon,self.title,self.line,nil];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:PuserLogo];
    self.title.text = @"我关注的好友";
}
@end
@implementation ToutiaoAttentionViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.title = @"我关注的";
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = more;
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, APPH-TabBarH-44) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:70 sectionN:1 rowN:10 cellName:@"ToutiaoAttentionViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)moreAction{
    DLog(@"更多");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
