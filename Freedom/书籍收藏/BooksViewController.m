//  BooksViewController.m
//  Freedom
//  Created by Super on 16/8/18.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "BooksViewController.h"
#import "WXViewController.h"
#import "E_ScrollViewController.h"
#import "ContantHead.h"
@interface BooksViewCell : BaseCollectionViewCell
@end
@implementation BooksViewCell
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, APPW/5-20,40)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,YH(self.icon), APPW/5-12, 20)];
    self.title.font = fontnomal;self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.title,self.icon,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = dict[@"name"];
    self.icon.image = [UIImage imageNamed:dict[@"pic"]];
}
@end
@interface BooksViewController()<UICollectionViewDelegateFlowLayout>{}
@end
@implementation BooksViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书籍📚阅读";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor yellowColor];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"阅读器" style:UIBarButtonItemStylePlain actionBlick:^{
        E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
        [self presentViewController:loginvctrl animated:NO completion:NULL];
    }];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:Padd] style:UIBarButtonItemStyleDone actionBlick:^{
        WXViewController *wxVc = [WXViewController new];
        [self presentViewController:wxVc animated:YES completion:NULL];
    }];
    self.navigationItem.leftBarButtonItem  = left;
    self.navigationItem.rightBarButtonItem = right;
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 60) groupInset:UIEdgeInsetsMake(0, 10, 0, 10) itemSpace:10 linespace:10];
    layout.headerReferenceSize = CGSizeMake(APPW, 30);layout.footerReferenceSize = CGSizeZero;
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo},@{@"name":@"流量充值",@"pic":PuserLogo}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:1 itemN:20 itemName:@"BooksViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = whitecolor;
    self.collectionView.frame = self.view.bounds;
    [self.view addSubview:self.collectionView];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *log = [NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row];
    [SVProgressHUD showSuccessWithStatus:log];DLog(@"%@",log);
    E_ScrollViewController *loginvctrl = [[E_ScrollViewController alloc] init];
    [self presentViewController:loginvctrl animated:NO completion:NULL];
}
@end
