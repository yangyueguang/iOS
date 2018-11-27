//  EnergyNewsViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergyNewsViewController.h"
#import "EnergyNewsDetailViewController.h"
@interface EnergyNewsViewCell:BaseTableViewCell
@end
@implementation EnergyNewsViewCell
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
@implementation EnergyNewsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
-(void)loadUI{
    self.title = @"新闻动态";
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-64)];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:70 sectionN:1 rowN:10 cellName:@"EnergyNewsViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"人人店分销团队如何持续裂变",@"微营销流量引入的几点思考",@"”微时代 新电商“邀您对话千万资产",@"养出80\%的回购率",@"0.2元低成本吸粉的玩法",@"阿罗古堡人人店，上线当月销量近60万",@"高潮迭起 微巴人人店征战中国",@"微营销对话微市场，新时代的迭起",nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *value = self.tableView.dataArray[indexPath.row];
    [self pushController:[EnergyNewsDetailViewController class] withInfo:nil withTitle:value withOther:value];
    
}
@end
