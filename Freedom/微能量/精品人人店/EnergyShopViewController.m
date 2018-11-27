//  EnergyShopViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
#import "EnergyShopViewController.h"
#import "EnergyShopTabBarController.h"
@interface EnergyShopViewCell:BaseTableViewCell
@end
@implementation EnergyShopViewCell
-(void)initUI{
    [super initUI];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.icon.frame = CGRectMake(10, 10, 60, 60);
    self.title.frame = CGRectMake(XW(self.icon)+20,  (80 - 20)/2.0,APPW-XW(self.icon), 20);
    self.line.frame = CGRectMake(Boardseperad, 79, APPW-2*Boardseperad, 1);
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.title.text = (NSString*)dict;
    self.icon.image = [UIImage imageNamed:@"taobaomini3"];
}
@end
@interface EnergyShopViewController ()
@end
@implementation EnergyShopViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
-(void)loadUI{
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110)];
    [self fillTheTableDataWithHeadV:nil footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:80 sectionN:1 rowN:18 cellName:@"EnergyShopViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"酒水",@"茶饮",@"水果",@"生鲜",@"土地产",@"旅游",@"美丽人生",@"养生",@"服饰鞋袜",@"百货",@"美食",@"坚果零食",@"饰品",@"手工制品",@"家电家居",@"健身",@"宠品",nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *s = @"EnergyShopTabBarController";
//    UIViewController *con = [[NSClassFromString(s) alloc]init];
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    [self presentViewController:con animated:NO completion:^{}];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    EnergyShopTabBarController *myTabBar=[EnergyShopTabBarController sharedRootViewController];
    myTabBar.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myTabBar animated:YES];
}
@end
