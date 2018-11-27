
#import "TaobaoCommunityViewController.h"
@interface TaobaoCommunityViewCell1 : BaseCollectionViewCell
@end
@implementation TaobaoCommunityViewCell1
-(void)initUI{
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, APPW-20, 40)];
    self.title.numberOfLines = 0;
    self.title.font = fontTitle;
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, YH(self.title), W(self)-20,100)];
    self.icon.layer.cornerRadius = 10;
    self.icon.clipsToBounds = YES;
    self.script = [[UILabel alloc]initWithFrame:CGRectMake(10, YH(self.icon), APPW-20, 60)];
    self.script.numberOfLines = 0;
    self.script.font = fontnomal;self.script.textColor = gradtextcolor;
    self.line = [[UIView alloc]initWithFrame:CGRectMake(0, 198, APPW, 2)];
    self.line.backgroundColor = whitecolor;
    [self addSubviews:self.title,self.icon,self.script,self.line,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"😋我想买一个6000到8000左右的游戏本，求各位大神给个推荐";
    self.icon.image = [UIImage imageNamed:@"image4.jpg"];
    self.script.text = @"👌这款笔记本电脑💻，用料考究，做工精细，运行速度快，携带方便，是您居家旅行的不二之选，它极致的性能堪比外挂，性价比特别高，建议选联想拯救者或惠普精灵系列的电脑，买电脑千万别图便宜，一分价格一分货。";
}
@end
@interface TaobaoCommunityViewCell2 : BaseCollectionViewCell
@end
@implementation TaobaoCommunityViewCell2
-(void)initUI{
    self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, APPW/2-20,100)];
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(self.icon), W(self.icon), 70)];
    self.title.font = fontnomal;self.title.textColor = gradtextcolor;
    self.title.numberOfLines = 0;
    [self addSubviews:self.icon,self.title,nil];
}
-(void)setCollectionDataWithDic:(NSDictionary *)dict{
    self.title.text = @"做工很精细，大品牌，值得信赖！用了几天才评价，真实堪称完美！质量上乘，使用方便，是您居家旅行，过节送礼，朋友关系维护的绝佳产品，可以送老人，送孩子，送长辈，价格合理，你值得拥有！";
    self.icon.image = [UIImage imageNamed:@"mini4"];
}
@end
@interface TaobaoCommunityHeadView : UICollectionReusableView{
    UILabel *titleLabel;
}
@end
@implementation TaobaoCommunityHeadView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, APPW, 20)];
    titleLabel.textColor = redcolor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"💗🌹👌🍚每日必看";
    self.backgroundColor = whitecolor;
    [self addSubview:titleLabel];
}
@end
@interface TaobaoCommunityViewController()<UICollectionViewDelegateFlowLayout>{
    BaseScrollView *banner;
}
@end
@implementation TaobaoCommunityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"你想要的购物经验，这里都能找到";
    self.navigationItem.titleView = searchBar;
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    UIImage *image = [[UIImage imageNamed:@"Taobaomessage@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TaobaoScanner@2x"] style:UIBarButtonItemStyleDone actionBlick:^{}];
    UIBarButtonItem *rightI = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone actionBlick:^{}];
    self.navigationItem.leftBarButtonItem  = leftI;
    self.navigationItem.rightBarButtonItem = rightI;
    banner = [[BaseScrollView alloc]initWithFrame:CGRectMake(0,30, APPW, 130)];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"type", nil];
    [Net GET:GETBanner parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *adViewArr = responseObject[@"data"][@"list"];
        if (adViewArr != nil && adViewArr.count > 0) {
            NSMutableArray *urls = [NSMutableArray arrayWithCapacity:10];
            for(int i=0;i<adViewArr.count;i++){
                NSString *url = [adViewArr[i] objectForJSONKey:@"pic"];
                [urls addObject:url];
            }
            [banner setWithTitles:nil icons:urls round:NO size:CGSizeZero type:MyScrollTypeBanner controllers:nil selectIndex:^(NSInteger index, NSDictionary *dict) {}];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:alertErrorTxt];
    }];
    BaseCollectionViewLayout *layout = [BaseCollectionViewLayout sharedFlowlayoutWithCellSize:CGSizeMake((APPW-50)/4, 90) groupInset:UIEdgeInsetsMake(10, 10, 0, 10) itemSpace:10 linespace:10];
//    layout.headerReferenceSize = CGSizeMake(320, 40);layout.footerReferenceSize = CGSizeMake(APPW, 30);
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-110) collectionViewLayout:layout];
    self.collectionView.dataArray = [NSMutableArray arrayWithObjects:@{@"name":@"流量充值",@"pic":PuserLogo}, nil];
    [self fillTheCollectionViewDataWithCanMove:NO sectionN:3 itemN:20 itemName:@"TaobaoCommunityViewCell1"];
    [self.collectionView registerClass:[TaobaoCommunityViewCell2 class] forCellWithReuseIdentifier:@"TaobaoCommunityViewCell2"];
    [self.collectionView registerClass:[BaseCollectionViewCell class] forCellWithReuseIdentifier:@"basecell"];
    [self.collectionView registerClass:[TaobaoCommunityHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview"];
    [self.collectionView registerClass:[TaobaoCommunityHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0)return 1;if (section == 1)return 5;if (section == 2)return 10;return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = nil;
    if(indexPath.section == 0){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"basecell" forIndexPath:indexPath];
        cell.frame=CGRectMake(0, 0, APPW, 100);
        [cell addSubview:banner];
    }else if (indexPath.section == 1) {
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"basecell" forIndexPath:indexPath];
        [cell  setCollectionDataWithDic:nil];
        
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaobaoCommunityViewCell2" forIndexPath:indexPath];
        [cell setCollectionDataWithDic:nil];
    }
    return cell;
}
//FIXME: collectionViewDelegate
//item 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(APPW, 120);
    }else if(indexPath.section==1){
        return CGSizeMake(APPW, 200);
    }else{
        return CGSizeMake(APPW/2-20, APPW/2-20);
    }
}
//分区头的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {return CGSizeMake(APPW, 30);}
    return CGSizeMake(APPW,30);
}
//分区尾的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        if (kind == UICollectionElementKindSectionHeader){
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview" forIndexPath:indexPath];
        }
        if (kind == UICollectionElementKindSectionFooter) {
            return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview" forIndexPath:indexPath];
        }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *log = [NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row];
    [SVProgressHUD showSuccessWithStatus:log];DLog(@"%@",log);
}
@end
