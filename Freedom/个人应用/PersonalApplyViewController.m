//  PersonalApplyViewController.m
//  Freedom
//  Created by Super on 16/8/18.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "PersonalApplyViewController.h"
#import "PersonalInternetViewController.h"
#import "PersonalEducationViewController.h"
#import "PersonalSoftViewController.h"
#import "PersonalHardwareViewController.h"
#import "PersonalComputerViewController.h"
#import "PersonalFoodViewController.h"
#import "PersonalFastGoodsViewController.h"
#import "PersonalConsumerViewController.h"
#import "PersonalPhoneViewController.h"
#import "PersonalHouseViewController.h"
#import "PersonalCarViewController.h"
#import "PersonalLuxuryViewController.h"
@interface PersonalApplyViewCell:BaseTableViewCell
@end
@implementation PersonalApplyViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 60, 60);
    self.title.frame = CGRectMake(XW(self.icon)+10, 20, APPW-XW(self.icon)-20, 20);
    self.script.frame = CGRectMake(X(self.title), YH(self.title), W(self.title), H(self.title));
    self.script.textColor = [UIColor grayColor];
    self.line.frame = CGRectMake(10,79, APPW-20, 1);
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:dict[@"pic"]];
    self.title.text = dict[@"name"];
    self.script.text = dict[@"url"];
}
@end
@implementation PersonalApplyViewController{
    NSArray *controllers;
    BaseScrollView *banner;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"个人应用";
    banner = [[BaseScrollView alloc]initWithFrame:CGRectMake(0,0, APPW, 120)];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil];
    [Net GET:GETBanner parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *adViewArr = responseObject[@"data"][@"list"];
        if (adViewArr != nil && adViewArr.count > 0) {
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:10];
            for(int i=0;i<adViewArr.count;i++){
                NSString *url = [adViewArr[i] objectForJSONKey:@"pic"];
                [urls addObject:url];
            }
            [banner setWithTitles:nil icons:urls round:NO size:CGSizeZero type:MyScrollTypeBanner controllers:nil selectIndex:^(NSInteger index, NSDictionary *dict) {
                DLog(@"选中了其中的某个banner：%ld",index);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];
    }];
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-TabBarH) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:80 sectionN:1 rowN:11 cellName:@"PersonalApplyViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:
  @{@"pic":PuserLogo,@"name":@"互联网行业",@"url":ResumeURL},@{@"pic":PuserLogo,@"name":@"教育培训行业1",@"url":WeChatApplet1},@{@"pic":PuserLogo,@"name":@"计算机软件",@"url":WeChatApplet2},
  @{@"pic":PuserLogo,@"name":@"计算机硬件",@"url":MicroPage1},@{@"pic":PuserLogo,@"name":@"个人电脑",@"url":MicroPage2},@{@"pic":PuserLogo,@"name":@"食品连锁",@"url":MicroPage3},
  @{@"pic":PuserLogo,@"name":@"快消品行业",@"url":MicroPage3}, @{@"pic":PuserLogo,@"name":@"耐消品行业",@"url":MicroPage3}, @{@"pic":PuserLogo,@"name":@"手机市场",@"url":MicroPage3},
  @{@"pic":PuserLogo,@"name":@"房地产行业",@"url":MicroPage3}, @{@"pic":PuserLogo,@"name":@"汽车行业",@"url":MicroPage3}, @{@"pic":PuserLogo,@"name":@"奢侈品行业",@"url":MicroPage3},
  @{@"pic":PuserLogo,@"name":@"其他行业",@"url":MicroPage3}, nil];
    controllers = [NSArray arrayWithObjects:@"PersonalInternetViewController",@"PersonalEducationViewController",@"PersonalSoftViewController",@"PersonalHardwareViewController",
                   @"PersonalComputerViewController",@"PersonalFoodViewController",@"PersonalFastGoodsViewController",@"PersonalConsumerViewController",
                   @"PersonalPhoneViewController",@"PersonalHouseViewController",@"PersonalCarViewController",@"PersonalLuxuryViewController",@"PersonalLuxuryViewController", nil];
    self.tableView.tableHeaderView = banner;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight|UIRectEdgeBottom;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.tableView.dataArray[indexPath.row];
    [self pushController:NSClassFromString(controllers[indexPath.row]) withInfo:dict withTitle:dict[@"name"] withOther:dict];
}
@end
