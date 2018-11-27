//  EnergyHomeViewController.m
//  Created by Super on 16/9/5.
//  Copyright © 2016年 Super. All rights reserved.
#import "EnergyHomeViewController.h"
#import "EnergyDetailViewController.h"
@interface EnergyHomeViewCell : BaseCollectionViewCell
@end
@implementation EnergyHomeViewCell
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPW/5,60)];
    self.icon.layer.cornerRadius = 20;self.icon.clipsToBounds = YES;
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,YH(self.icon),W(self.icon),20)];self.title.textAlignment = NSTextAlignmentCenter;
    self.contentMode = UIViewContentModeCenter;
    [self addSubview:self.icon];[self addSubview:self.title];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = (NSString*)dict;
    self.icon.image = [UIImage imageNamed:@"taobaomini2"];
}
@end
@implementation EnergyHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}
-(void)buildUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"u_add_y"] style:UIBarButtonItemStylePlain actionBlick:^{}];
    self.navigationItem.rightBarButtonItem = more;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入问题关键字";
    self.navigationItem.titleView = searchBar;
    
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
    
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake(APPW/5, 80) groupInset:UIEdgeInsetsMake(YH(banner)+10, 10, 0, 10) itemSpace:10 linespace:10];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:
    @"微请柬",@"微渠道",@"微助手",@"分销版",@"微政务",@"微社区",@"微外卖",@"微配送",
    @"微挂号",@"微游戏",@"微OA",@"微名片",@"全景720",@"微贺卡",@"优惠券",@"微团购",
    @"微点菜",@"微小店",@"微彩票",@"问卷调查",@"微信打印机",@"微信wifi",@"客户备忘",@"微报名",
    @"订房易",@"抢元宝",@"微现场",@"超级加油",@"微网站",@"微商城",@"会员卡",@"微相册",
    @"微信支付",@"微喜帖",@"微测试",@"超级秒杀",@"全民经纪人",@"微投票",@"微签到",@"微预约",nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:1 itemN:40 itemName:@"EnergyHomeViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView addSubview:banner];
    [self.view addSubviews:self.collectionView,nil];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self pushController:[EnergyDetailViewController class] withInfo:nil withTitle:self.collectionView.dataArray[indexPath.row]];
}
@end
