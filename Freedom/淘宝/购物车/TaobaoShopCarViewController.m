//  TaobaoShopCarViewController.m
//  Created by Super on 17/1/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "TaobaoShopCarViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface TaobaoShopCarViewCell:BaseTableViewCell
@end
@implementation TaobaoShopCarViewCell
-(void)initUI{
    self.icon =[[UIImageView alloc]init];
    self.icon.contentMode = UIViewContentModeScaleToFill;
    self.title = [[UILabel alloc]init];
    self.title.font = fontTitle;
    self.title.numberOfLines = 0;
    self.script = [[UILabel alloc]init];
    self.script.font = fontnomal;
    self.script.textColor = self.title.textColor = blacktextcolor;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 99, APPW, 1)];
    self.line.backgroundColor = gradcolor;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 20)];
    UIButton *selecth = [[UIButton alloc]initWithFrame:CGRectMake(10, 2.5, 15, 15)];
    [selecth setImage:[UIImage imageNamed:@"taobaono"] forState:UIControlStateNormal];
    [selecth setImage:[UIImage imageNamed:@"taobaoon"] forState:UIControlStateSelected];
    UILabel *headTitle = [UILabel labelWithFrame:CGRectMake(XW(selecth), 0, APPW-150, 20) font:fontnomal color:gradtextcolor text:@"🍞中华精品城 >"];
    UIButton *lingquan = [[UIButton alloc]initWithFrame:CGRectMake(APPW-100, 0, 40, 20)];
    [lingquan setTitle:@"领券" forState:UIWindowLevelNormal];
    UIButton *edit = [[UIButton alloc]initWithFrame:CGRectMake(XW(lingquan)+10, 0, 40, 20)];
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    lingquan.titleLabel.font = edit.titleLabel.font = fontnomal;
    [headView addSubviews:selecth,headTitle,lingquan,edit,nil];
    UIView *contentV = [[UIView alloc]initWithFrame:CGRectMake(0, YH(headView), APPW, 80)];
    UIButton *selectc = [[UIButton alloc]initWithFrame:CGRectMake(10, 32, 15,15)];
    [selectc setImage:[UIImage imageNamed:@"taobaono"] forState:UIControlStateNormal];
    [selectc setImage:[UIImage imageNamed:@"taobaoon"] forState:UIControlStateSelected];
    self.icon.frame = CGRectMake(XW(selectc)+10, 5, 60, 70);
    self.title.frame = CGRectMake(XW(self.icon)+10,Y(self.icon), APPW-XW(self.icon)-20, 30);
    self.title.numberOfLines = 0;
    self.title.font = fontnomal;
    self.script.textColor = graycolor;
    self.script.frame = CGRectMake(X(self.title), YH(self.title), W(self.title), 20);
    UILabel *newPrice = [UILabel labelWithFrame:CGRectMake(X(self.script), YH(self.script), 60, 20) font:fontnomal color:redcolor text:@"￥199"];
    UILabel *oldPrice = [UILabel labelWithFrame:CGRectMake(XW(newPrice), Y(newPrice), 80, H(newPrice)) font:fontnomal color:graycolor text:@"￥299"];
    UILabel *num = [UILabel labelWithFrame:CGRectMake(APPW-50, Y(newPrice), 40, 20) font:fontnomal color:graycolor text:@"x1"];
    num.textAlignment = NSTextAlignmentRight;
    [contentV addSubviews:selectc,self.icon,self.title,self.script,newPrice,oldPrice,num,nil];
    [self addSubviews:headView,contentV,self.line,nil];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"05.jpg"];
    self.title.text = @"冬季外套女装学生韩版棉衣女中长款面包服女加厚棉服宽松冬装棉袄";
    self.script.text = @"颜色分类:红色;尺码:M";
}
@end
@implementation TaobaoShopCarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}
#pragma mark 搭建UI界面
-(void)buildUI{
  self.title = @"购物车(10)";
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(moreAction)];
    UIBarButtonItem *edit = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(moreAction)];
    self.navigationItem.rightBarButtonItems = @[edit,more];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, APPH-TabBarH-44-50) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:100 sectionN:1 rowN:10 cellName:@"TaobaoShopCarViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    UIView *totalView = [[UIView alloc]initWithFrame:CGRectMake(0, APPH-50-TabBarH-44, APPW, 40)];
    UIButton *totalb = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 56, 16)];
    [totalb setTitle:@"全选" forState:UIControlStateNormal];
    [totalb setImage:[UIImage imageNamed:@"taobaono"] forState:UIControlStateNormal];
    [totalb setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [totalb setImage:[UIImage imageNamed:@"taobaoon"] forState:UIControlStateSelected];
    UILabel *heji = [[UILabel alloc]initWithFrame:CGRectMake(XW(totalb)+20, 10, 200, 20)];
    heji.text = @"合计：￥100 不含运费";
    heji.font = fontTitle;
    UIButton *pay = [[UIButton alloc]initWithFrame:CGRectMake(APPW-80, 0, 80, 40)];
    [pay setTitle:@"结算(0)" forState:UIControlStateNormal];
    pay.backgroundColor = RGBCOLOR(252, 74, 1);
    [totalView addSubviews:totalb,heji,pay,nil];
    [self.view addSubview:totalView];
}
-(void)moreAction{
    DLog(@"更多");
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
