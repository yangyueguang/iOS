//  JuheQuestionViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "JuheQuestionViewController.h"
#import "JuheDetailQuestion.h"
@interface JuheQuestionViewCell:BaseTableViewCell
@end
@implementation JuheQuestionViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 40, 40);
    self.title.frame = CGRectMake(XW(self.icon)+10, 10, APPW-XW(self.icon)-20, 20);
    self.script.frame = CGRectMake(X(self.title), YH(self.title), W(self.title), H(self.title));
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"juhetab2"];
    self.title.text = @"免费接口，不认证会影响使用吗？";
    self.script.text = @"👀 68次浏览    📝 1天前";
}
@end
@implementation JuheQuestionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}
#pragma mark 搭建UI界面
-(void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //设置右上角按钮
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"juheadd"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItem = more;
    //设置左上角按钮
//    UIBarButtonItem *map = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(mapAction)];
//    self.navigationItem.leftBarButtonItem = map;
    //创建搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入问题关键字";
    self.navigationItem.titleView = searchBar;
    
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, APPH) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:60 sectionN:1 rowN:11 cellName:@"JuheQuestionViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)moreAction{
    DLog(@"更多");
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushController:[JuheDetailQuestion class] withInfo:nil withTitle:@"问题详情"];
}
@end
