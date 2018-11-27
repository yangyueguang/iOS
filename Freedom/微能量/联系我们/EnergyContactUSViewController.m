//  EnergyContactUSViewController.m
//  Freedom
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "EnergyContactUSViewController.h"
#import "EnergyContactDetailViewController.h"
@interface EnergyContactUSViewCell:BaseTableViewCell
@end
@implementation EnergyContactUSViewCell
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
@interface EnergyContactUSViewController ()
@end
@implementation EnergyContactUSViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}
-(void)loadUI{
    self.title = @"联系我们";
    BaseScrollView *banner = [[BaseScrollView alloc]initWithFrame:CGRectMake(0,0, APPW, 120)];
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
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-64)];
    [self fillTheTableDataWithHeadV:banner footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:80 sectionN:1 rowN:6 cellName:@"EnergyContactUSViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"一键导航",@"关注公众号",@"查看历史消息",@"微信营销交流",@"客服聊天",@"诚聘精英",nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *value = self.tableView.dataArray[indexPath.row];
    [self pushController:[EnergyContactDetailViewController class] withInfo:nil withTitle:value withOther:value];
    
}
@end
