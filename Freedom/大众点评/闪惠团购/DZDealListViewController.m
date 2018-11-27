//  DZDealListViewController.m
//  Created by Super on 17/1/17.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "DZDealListViewController.h"
#import "DZDealDetailViewController.h"
#import <XCategory/UILabel+expanded.h>
//FIXME:横着的cell
@interface DZDealListViewTransverseCell:BaseTableViewCell
@end
@implementation DZDealListViewTransverseCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10,0, APPW-20, 60);
    self.title.frame = CGRectMake(X(self.icon),YH(self.icon), W(self.icon), 30);
    self.script.frame = CGRectMake(X(self.title), YH(self.title), W(self.title), 13);
    self.title.numberOfLines = 0;
    self.title.font = fontnomal;self.script.font = Font(11);
    self.line.frame = CGRectMake(0, 100-1, APPW, 1);
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"image4.jpg"];
    self.title.text = @"与爱齐名，为有初心不变，小编为大家收集了超多好文好店，从手工匠人到原型设计，他们并没有忘记";
    self.script.text = @"地道风味 精选外卖优惠";
}
@end
//FIXME:竖着的cell
@interface DZDealListViewVerticalCell:BaseTableViewCell{
    UILabel *name,*sees,*times;
}
@end
@implementation DZDealListViewVerticalCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 70, 70);
    name = [UILabel labelWithFrame:CGRectMake(XW(self.icon)+10, 10, APPW-XW(self.icon)-30, 20) font:fontSmallTitle color:RGBCOLOR(0, 111, 255) text:nil];
    times = [UILabel labelWithFrame:CGRectMake(APPW-100, Y(name), 80, 15) font:Font(11) color:graycolor text:nil];
    times.textAlignment = NSTextAlignmentRight;
    self.title.frame = CGRectMake(X(name),YH(name)+5, W(name), 20);self.title.font = fontnomal;
    self.script.frame = CGRectMake(X(self.title), YH(self.title)+5, 80, 20);
    sees = [UILabel labelWithFrame:CGRectMake(X(times), Y(self.script),W(times), 15) font:Font(11) color:graycolor text:nil];
    sees.textAlignment = NSTextAlignmentRight;
    self.line.frame = CGRectMake(0, 100-1, APPW, 1);
    self.script.backgroundColor = redcolor;self.script.textColor = whitecolor;
    [self addSubviews:name,times,sees,nil];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"image2.jpg"];
    name.text = @"传说张无忌肉夹馍";
    times.text = @"2.3km";
    self.picV.image = [UIImage imageNamed:@"image4.jpg"];
    self.title.text = @"49分钟送达|起送￥20.0|配送￥3.0";
    self.script.text = @"满20减10";
    sees.text = @"月售1000";
}
@end
@implementation DZDealListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, self.view.frameHeight-20) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:100 sectionN:1 rowN:20 cellName:@"TaobaoMiniDynamicViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseTableViewCell *cell;
    if(indexPath.row%5){
        //竖着的
        cell = [tableView dequeueReusableCellWithIdentifier:[DZDealListViewVerticalCell getTableCellIdentifier]];
        if(!cell){
            cell = [DZDealListViewVerticalCell getInstance];
        }
    }else{
        //横着的
        cell = [tableView dequeueReusableCellWithIdentifier:[DZDealListViewTransverseCell getTableCellIdentifier]];
        if(!cell){
            cell = [DZDealListViewTransverseCell getInstance];
        }
    }
    [cell  setDataWithDict:nil];
    return cell;
}
-(void)viewWillLayoutSubviews{
    self.tableView.frameHeight = self.view.frameHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self pushController:[DZDealDetailViewController class] withInfo:nil withTitle:@"详情"];
}
@end
