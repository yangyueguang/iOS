//  DZHomeController.m
//  Freedom
//  Created by Super on 15/12/1.
#import "DZHomeController.h"
#import <XCategory/UILabel+expanded.h>
@interface DZHomeViewCell1 : BaseCollectionViewCell
@end
@implementation DZHomeViewCell1
-(void)initUI{//120
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, W(self)/2-10,60)];
    UIView *view = [self getViewWithFrame:CGRectMake(0, 0, APPW/2-10, 55)];
    UIView *view2 = [self getViewWithFrame:CGRectMake(APPW/2, 0, APPW/2-10, 55)];
    UIView *view3 = [self getViewWithFrame:CGRectMake(X(view2), YH(view2)+10, W(view2), H(view2))];
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(W(view2)-40, 0, 40, H(view2))];
    image1.image = [UIImage imageNamed:@"image1.jpg"];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(W(view2)-40, 0, 40, H(view2))];
    image2.image = [UIImage imageNamed:@"image2.jpg"];
    [view2 addSubview:image1];
    [view3 addSubview:image2];
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 198, APPW, 2)];
    self.line.backgroundColor = whitecolor;
    [self addSubviews:view,view2,self.icon,view3,nil];
}
-(UIView*)getViewWithFrame:(CGRect)rect{
    UIView *view = [[UIView alloc]initWithFrame:rect];
    UILabel *a = [UILabel labelWithFrame:CGRectMake(10, 0, APPW/2-20, 18) font:fontnomal color:redcolor text:@"外卖贺新春"];
    UILabel *b = [UILabel labelWithFrame:CGRectMake(X(a), YH(a), W(a), H(a)) font:fontnomal color:blacktextcolor text:@"省事省力又省心"];
    UILabel *c = [UILabel labelWithFrame:CGRectMake(X(a), YH(b), 100, 15) font:fontnomal color:yellowcolor text:@"用外卖订年夜饭"];
    c.layer.cornerRadius = 7;c.layer.borderWidth=1;c.layer.borderColor = redcolor.CGColor;
    [view addSubviews:a,b,c,nil];
    return view;
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.icon.image = [UIImage imageNamed:@"image4.jpg"];
}
@end
@interface DZHomeViewCell2 : BaseCollectionViewCell
@end
@implementation DZHomeViewCell2
-(void)initUI{//100
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPW/4,60)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(20, YH(self.icon), W(self.icon), 20)];
    self.script = [[UILabel alloc]initWithFrame:CGRectMake(X(self.title),YH(self.title), W(self.title), H(self.title))];
    self.script.font = fontnomal;
    self.title.font = fontSmallTitle;self.script.textColor = gradtextcolor;
    [self addSubviews:self.icon,self.title,self.script,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"全球贺新年";
    self.script.text = @"春节专享";
    self.icon.image = [UIImage imageNamed:@"taobaomini2"];
}
@end
@interface DZHomeViewCell3 : BaseCollectionViewCell
@end
@implementation DZHomeViewCell3
-(void)initUI{//80
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPW/4-11,50)];
    self.icon.clipsToBounds = YES;self.icon.layer.cornerRadius = 10;
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(self.icon), W(self.icon), 18)];
    self.script = [[UILabel alloc]initWithFrame:CGRectMake(X(self.title),YH(self.title), W(self.title), 15)];
    self.script.font = Font(12);
    self.title.font = fontnomal;self.script.textColor = gradtextcolor;
    self.title.textAlignment = NSTextAlignmentCenter;self.script.textAlignment = NSTextAlignmentCenter;
    [self addSubviews:self.icon,self.title,self.script,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"爱车";
    self.script.text = @"9.9元洗车";
    self.icon.image = [UIImage imageNamed:@"taobaomini1"];
}
@end
@interface DZHomeViewCell4 : BaseCollectionViewCell
@end
@implementation DZHomeViewCell4
-(void)initUI{//100
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, APPW/4,80)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(XW(self.icon)+10, Y(self.icon), APPW-XW(self.icon)-20, 20)];
    self.script = [[UILabel alloc]initWithFrame:CGRectMake(X(self.title), YH(self.title), W(self.title), 40)];
    UILabel *a = [[UILabel alloc]initWithFrame:CGRectMake(APPW-80, Y(self.title), 70, H(self.title))];
    a.textAlignment = NSTextAlignmentRight;
    UILabel *b = [[UILabel alloc]initWithFrame:CGRectMake(X(self.title), YH(self.script), W(self.title), H(self.title))];
    UILabel *d = [[UILabel alloc]initWithFrame:CGRectMake(X(a), Y(b), W(a), H(a))];
    d.textAlignment = NSTextAlignmentRight;
    self.script.font = a.font = d.font = fontnomal;
    self.script.numberOfLines =0;
    self.script.textColor = a.textColor = d.textColor = graycolor;
    b.textColor = redcolor;
    a.text = @"575m";b.text = @"￥69";
    d.text = @"已售50000";
    UIView *ling = [[UIView alloc]initWithFrame:CGRectMake(10,99, APPW-20, 1)];
    ling.backgroundColor = whitecolor;
    [self addSubviews:self.icon,self.title,a,self.script,b,d,ling,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"上海海洋水族馆(4A)";
    self.script.text = @"[陆家嘴]4.2分|门票、套餐、线路游 等优惠，欢迎上门体验";
    self.icon.image = [UIImage imageNamed:PuserLogo];
}
@end
@interface DZHomeHeadView1 : UICollectionReusableView{
    BaseScrollView *DZtoutiaoV;
}
@end
@implementation DZHomeHeadView1
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
  
    DZtoutiaoV = [BaseScrollView sharedViewBannerWithFrame:CGRectMake(20, 0, APPW-40, 60) viewsNumber:5 viewOfIndex:^UIView *(NSInteger index) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPW-50, 60)];
        UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40,40)];
        icon.clipsToBounds = YES;icon.layer.cornerRadius = 20;
        icon.image = [UIImage imageNamed:PuserLogo];
        UILabel *label1 = [UILabel labelWithFrame:CGRectMake(XW(icon)+10, 10, APPW/2, 40) font:fontnomal color:blacktextcolor text:@"好友蜂蜜绿茶，吃完这家，还有下一家。地点中环广场店"];
        label1.numberOfLines = 0;
        [view addSubviews:icon,label1,nil];
        view.backgroundColor = redcolor;
        if(index%2){view.backgroundColor = yellowcolor;}
        return view;
    } Vertically:YES setFire:YES];
    [self addSubview:DZtoutiaoV];
}
@end
@interface DZHomeHeadView2 : UICollectionReusableView{
    UILabel *titleLabel;
}
@end
@implementation DZHomeHeadView2
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, APPW, 20)];
    titleLabel.textColor = redcolor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"为你优选BEST";
    self.backgroundColor = whitecolor;
    [self addSubview:titleLabel];
}
@end
//FIXME:大众点评正式VC
@interface DZHomeController ()<UICollectionViewDelegateFlowLayout>{
    BaseScrollView *itemScrollView;
}
@end
@implementation DZHomeController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *more = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithRenderingOriginalName:@"u_add_y"] style:UIBarButtonItemStylePlain actionBlick:^{}];
    self.navigationItem.rightBarButtonItem = more;
    UIBarButtonItem *map = [[UIBarButtonItem alloc]initWithTitle:@"北京" style:UIBarButtonItemStylePlain actionBlick:^{}];
    self.navigationItem.leftBarButtonItem = map;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入商户名、地点";
    self.navigationItem.titleView = searchBar;
    NSArray *titles = @[@"美食",@"电影",@"酒店",@"休闲娱乐",@"外卖",@"机票/火车票",@"丽人",@"周边游",@"亲子",@"KTV",@"高端酒店",@"足疗按摩",@"结婚",@"家族",@"学习培训",@"景点",@"游乐园",@"生活服务",@"洗浴",@"全部分类"];
    NSArray *icons = @[@"taobaomini1",@"taobaomini2",@"taobaomini3",@"taobaomini4",@"taobaomini5",@"taobaomini1",@"taobaomini2",@"taobaomini3",@"taobaomini4",@"taobaomini5",@"taobaomini1",@"taobaomini2",@"taobaomini3",@"taobaomini4",@"taobaomini5",@"taobaomini1",@"taobaomini2",@"taobaomini3",@"taobaomini4",@"taobaomini5"];
    itemScrollView = [BaseScrollView sharedScrollItemWithFrame:CGRectMake(0, 60, APPW, 200) icons:icons titles:titles size:CGSizeMake(APPW/5.0, 70) hang:2 round:YES];
    itemScrollView.backgroundColor = whitecolor;
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 90) groupInset:UIEdgeInsetsMake(10, 10, 0, 10) itemSpace:10 linespace:10];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"流量充值",@"pic":PuserLogo}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:4 itemN:20 itemName:@"DZHomeViewCell1"];
    [self.collectionView registerClass:[DZHomeViewCell2 class] forCellWithReuseIdentifier:@"DZHomeViewCell2"];
    [self.collectionView registerClass:[DZHomeViewCell3 class] forCellWithReuseIdentifier:@"DZHomeViewCell3"];
    [self.collectionView registerClass:[DZHomeViewCell4 class] forCellWithReuseIdentifier:@"DZHomeViewCell4"];
    [self.collectionView registerClass:[DZHomeHeadView1 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview1"];
    [self.collectionView registerClass:[DZHomeHeadView2 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview2"];
    [self.collectionView addSubview:itemScrollView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0)return 1;if (section == 1)return 6;if (section == 2)return 8;return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    if(indexPath.section == 0){
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier:self.collectionReuseId forIndexPath:indexPath];
        [cell  setCollectionDataWithDic:nil];
    }else if (indexPath.section == 1) {
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"DZHomeViewCell2" forIndexPath:indexPath];
        [cell  setCollectionDataWithDic:nil];
    }else if (indexPath.section == 2) {
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"DZHomeViewCell3" forIndexPath:indexPath];
        [cell  setCollectionDataWithDic:nil];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DZHomeViewCell4" forIndexPath:indexPath];
        [cell setCollectionDataWithDic:nil];
    }
    return cell;
}
//FIXME: collectionViewDelegate
//item 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(APPW, 130);
    }else if(indexPath.section==1){
        return CGSizeMake(APPW/3-15, 100);
    }else if(indexPath.section==2){
        return CGSizeMake(APPW/4-15, 90);
    }else{
        return CGSizeMake(APPW, 100);
    }
}
//分区头的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {return CGSizeMake(APPW, 60);
    }else if(section==1){
        return CGSizeMake(APPW, 30);
    }else if(section==2){
        return CGSizeMake(APPW, 60);
    }else if(section==3){
        return CGSizeMake(APPW, 30);
    }
    return CGSizeMake(APPW,30);
}
//分区尾的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if(section==0){
        return UIEdgeInsetsMake(160, 10, 0, 10);
    }else{
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader){
        if(indexPath.section==0){
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview1" forIndexPath:indexPath];
        }else if(indexPath.section==1){
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview2" forIndexPath:indexPath];
        }else if(indexPath.section==2){
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview1" forIndexPath:indexPath];
        }else{
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview2" forIndexPath:indexPath];
    }
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *log = [NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row];
    [SVProgressHUD showSuccessWithStatus:log];DLog(@"%@",log);
}
@end
