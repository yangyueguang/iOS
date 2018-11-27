//  EnergyBusinessListViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergyBusinessListViewController.h"
#import "EnergyBusinessDetailViewController.h"
@interface EnergyBusinessViewCell:BaseTableViewCell
@end
@implementation EnergyBusinessViewCell
-(void)initUI{
    [super initUI];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.icon.frame = CGRectMake(10, 10, 50, 50);
    self.title.frame = CGRectMake(XW(self.icon)+20,  (70 - 20)/2.0,APPW-XW(self.icon), 20);
    self.line.frame = CGRectMake(Boardseperad, 69, APPW-2*Boardseperad, 1);
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.title.text = (NSString*)dict;
    self.icon.image = [UIImage imageNamed:@"taobaomini3"];
}
@end
@implementation EnergyBusinessListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
-(void)loadUI{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-64)];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:70 sectionN:1 rowN:15 cellName:@"EnergyBusinessViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"桌上美食",@"真心真艺",@"音响科技有限公司",@"智联招聘",@"前程无忧",@"百度百科",@"雅虎中国",@"360",@"布丁酒店",@"如家",@"莫泰168",@"宜家家居",@"微软中国",@"苹果公司",@"IBM",nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *value = self.tableView.dataArray[indexPath.row];
    [self pushController:[EnergyBusinessDetailViewController class] withInfo:nil withTitle:value withOther:value];
    
}
@end
