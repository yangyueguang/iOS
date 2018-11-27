//  EnergySampleViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergySampleViewController.h"
#import "EnergyBusinessListViewController.h"
@interface EnergySampleViewCell:BaseTableViewCell
@end
@implementation EnergySampleViewCell
-(void)initUI{
    [super initUI];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.icon.frame = CGRectMake(10, 10, 50,50);
    self.title.frame = CGRectMake(XW(self.icon)+20,  (70 - 20)/2.0,APPW-XW(self.icon), 20);
    self.line.frame = CGRectMake(Boardseperad, 69, APPW-2*Boardseperad, 1);
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.title.text = (NSString*)dict;
    self.icon.image = [UIImage imageNamed:@"taobaomini2"];
}
@end
@implementation EnergySampleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
-(void)loadUI{
    self.title = @"经典案例";
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110)];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:70 sectionN:1 rowN:17 cellName:@"EnergySampleViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"政府机构/媒体",@"母婴/儿童",@"教育/培训",@"商场百货",@"电商/商贸/零售",@"金融/投资/保险",@"医疗/健康/保健/养生",@"旅游",@"酒店",@"婚庆",@"房产",@"装饰",@"娱乐",@"金融",@"政务",@"汽车",@"餐饮",nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *value = self.tableView.dataArray[indexPath.row];
    [self pushController:[EnergyBusinessListViewController class] withInfo:nil withTitle:value withOther:value];
    
}
@end
