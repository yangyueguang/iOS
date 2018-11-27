//  TaobaoMiniTopicViewController.m
//  Created by Super on 17/1/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "TaobaoMiniTopicViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface TaobaoMiniTopicViewCell:BaseTableViewCell{
    UILabel *sees;
}
@end
@implementation TaobaoMiniTopicViewCell
-(void)initUI{
    [super initUI];
    self.icon.frame = CGRectMake(10, 10, 70, 70);
    self.title.frame = CGRectMake(XW(self.icon)+10,Y(self.icon), APPW-XW(self.icon)-10, 20);
    self.script.frame = CGRectMake(X(self.title), YH(self.title)+10, W(self.title), 20);
    sees = [UILabel labelWithFrame:CGRectMake(X(self.script), YH(self.script),W(self.script), 15) font:Font(12) color:graycolor text:nil];
    self.line.frame = CGRectMake(0, 90-1, APPW, 1);
    DLog(@"==%lf",H(self));
    [self addSubviews:sees,nil];
}
-(void)setDataWithDict:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"mini5"];
    self.title.text = @"韩国年度榜";
    self.script.text = @"主持人：全球购买手小队长";
    sees.text = @"热度：79570  参与人：100";
}
@end
@implementation TaobaoMiniTopicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0,0, APPW, self.view.frameHeight-20) style:UITableViewStylePlain];
    [self fillTheTableDataWithHeadV:banner footV:nil canMove:NO canEdit:NO headH:0 footH:0 rowH:90 sectionN:1 rowN:11 cellName:@"TaobaoMiniTopicViewCell"];
    self.tableView.dataArray = [NSMutableArray arrayWithObjects:@"b",@"a",@"v",@"f",@"d",@"a",@"w",@"u",@"n",@"o",@"2", nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}
-(void)viewWillLayoutSubviews{
    self.tableView.frameHeight = self.view.frameHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
