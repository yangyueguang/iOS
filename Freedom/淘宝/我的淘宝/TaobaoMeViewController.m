//  TaobaoMeViewController.m
//  Created by Super on 17/1/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "TaobaoMeViewController.h"
#import <XCategory/UILabel+expanded.h>
@interface TaobaoMeViewCell1 : BaseCollectionViewCell
@end
@implementation TaobaoMeViewCell1
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, APPW/5-20,40)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,YH(self.icon), APPW/5-10, 20)];
    self.title.font = fontnomal;self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.title,self.icon,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"待收货";
    self.icon.image = [UIImage imageNamed:@"taobaomini2"];
}
@end
@interface TaobaoMeViewCell2 : BaseCollectionViewCell
@end
@implementation TaobaoMeViewCell2
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, APPW/5-20,40)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0,YH(self.icon), APPW/5-12, 20)];
    self.title.font = fontnomal;self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.title,self.icon,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"蚂蚁花呗";
    self.icon.image = [UIImage imageNamed:@"taobaomini1"];
}
@end
@interface TaobaoMeHeadView : UICollectionReusableView{
    UILabel *titleLabel;
}
@end
@implementation TaobaoMeHeadView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, APPW/2, 20)];
    titleLabel.textColor = redcolor;
    titleLabel.text = @"必备工具";
    UILabel *more = [[UILabel alloc]initWithFrame:CGRectMake(XW(titleLabel), Y(titleLabel), APPW-XW(titleLabel)-10, 20)];
    more.textColor = graycolor;
    more.textAlignment = NSTextAlignmentRight;
    more.font = fontnomal;
    more.text = @"查看更多 >";
    self.backgroundColor = whitecolor;
    [self addSubview:titleLabel];
    [self addSubview:more];
}
@end
@interface TaobaoMeViewController()<UICollectionViewDelegateFlowLayout>{}
@end
@implementation TaobaoMeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的淘宝";
    self.navigationController.navigationBar.tintColor = redcolor;
    UIImage *image = [[UIImage imageNamed:@"Taobaomessage@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain actionBlick:^{}];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TaobaoScanner@2x"] style:UIBarButtonItemStyleDone actionBlick:^{}];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone actionBlick:^{}];
    self.navigationItem.leftBarButtonItem  = left;
    self.navigationItem.rightBarButtonItems = @[right1,right2];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW, 100)];
    headView.backgroundColor = RGBCOLOR(252, 50, 50);
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(APPW/2-30, 0, 60, 60)];
    icon.layer.cornerRadius = 30;
    icon.image = [UIImage imageNamed:PuserLogo];
    icon.clipsToBounds = YES;
    UILabel *name = [UILabel labelWithFrame:CGRectMake(10, YH(icon), APPW-20, 20) font:fontSmallTitle color:whitecolor text:@"杨越光" textAlignment:NSTextAlignmentCenter];
    UILabel *taoqi = [UILabel labelWithFrame:CGRectMake(APPW/2-40, YH(name), 80, 15) font:fontnomal color:redcolor text:@"淘气值：710" textAlignment:NSTextAlignmentCenter];
    taoqi.clipsToBounds = YES;taoqi.layer.cornerRadius = 7;taoqi.backgroundColor = yellowcolor;
    [headView addSubviews:icon,name,taoqi,nil];
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 90) groupInset:UIEdgeInsetsMake(10, 10, 0, 10) itemSpace:10 linespace:10];
    layout.headerReferenceSize = CGSizeMake(APPW, 30);layout.footerReferenceSize = CGSizeZero;
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"流量充值",@"pic":PuserLogo}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:3 itemN:20 itemName:@"TaobaoMeViewCell1"];
    [self.collectionView registerClass:[TaobaoMeViewCell2 class] forCellWithReuseIdentifier:@"TaobaoMeViewCell2"];
    [self.collectionView registerClass:[TaobaoMeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview"];
    [self.collectionView registerClass:[TaobaoMeHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview"];
    [self.collectionView addSubview:headView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0)return 5;if (section == 1)return 12;if (section == 2)return 4;return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    if(indexPath.section == 0){
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier:self.collectionReuseId forIndexPath:indexPath];
        [cell  setCollectionDataWithDic:nil];
    }else if (indexPath.section == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaobaoMeViewCell2" forIndexPath:indexPath];
        [cell setCollectionDataWithDic:nil];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaobaoMeViewCell2" forIndexPath:indexPath];
        [cell setCollectionDataWithDic:nil];
    }
    return cell;
}
//FIXME: collectionViewDelegate
//item 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(APPW/5-12, 60);
    }else if(indexPath.section==1){
        return CGSizeMake(APPW/5-5, 60);
    }else{
        return CGSizeMake(APPW/5-5, 60);
    }
}
//分区头的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (section == 0) {return CGSizeMake(APPW, 30);}
//    return CGSizeMake(APPW,30);
//}
////分区尾的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeZero;
//}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview" forIndexPath:indexPath];
    }
//    if (kind == UICollectionElementKindSectionFooter) {
//        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview" forIndexPath:indexPath];
//    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *log = [NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row];
    [SVProgressHUD showSuccessWithStatus:log];DLog(@"%@",log);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section==0){
        return UIEdgeInsetsMake(80, 10, 0, 10);
    }else{
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
}
@end
