//  TaobaoViewController.m
#import "TaobaoHomeViewController.h"
#import <XCategory/UIGestureRecognizer+expanded.h>
#import <Masonry/Masonry.h>
//cell等比高
#define cell_height(i) APPW*((i)/375.0f)
@interface YYFPSLabel : UILabel
@end
#define kSize CGSizeMake(70, 22)
@implementation YYFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    //    _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}
- (void)dealloc {
    [_link invalidate];
}
- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}
- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    
    self.attributedText = text;
    self.textColor = color;
}
@end
@interface TitlesImageViewFull : UIView
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@property (nonatomic, strong) UIImageView *iconview;
@property (nonatomic, strong) UIImageView *imageview;
- (void)setImage:(UIImage *)img titleIcon:(UIImage *)icon;
- (void)setTitle:(NSString *)str1 subTitle:(NSString *)str2 size1:(CGFloat)s1 size2:(CGFloat)s2 color1:(UIColor *)c1 color2:(UIColor *)c2;
//方便背景间隔条，直接把self背景设置白色就好。默认的padding为0
- (void)setPadding:(CGFloat)padding;
@end
@implementation TitlesImageViewFull
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];if (self) {[self setUpView];}return self;
}
- (void)setUpView {
    _title = [[UILabel alloc] init];
    _subtitle = [[UILabel alloc] init];
    _iconview = [[UIImageView alloc] init];
    _imageview = [[UIImageView alloc] init];
    _imageview.contentMode = UIViewContentModeScaleAspectFit;
    _iconview.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_title];
    [self addSubview:_subtitle];
    [self addSubview:_iconview];
    [self addSubview:_imageview];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(0);
        make.width.greaterThanOrEqualTo(@40);
        make.height.equalTo(@14);
    }];
    [self.iconview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(_title.mas_right).offset(4);
        make.width.greaterThanOrEqualTo(@10);
        make.height.equalTo(_title.mas_height);
    }];
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(_title.mas_bottom).offset(3);
        make.height.equalTo(@12);
    }];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(_subtitle.mas_bottom).offset(3);
    }];
}
- (void)setTitle:(NSString *)str1 subTitle:(NSString *)str2 size1:(CGFloat)s1 size2:(CGFloat)s2 color1:(UIColor *)c1 color2:(UIColor *)c2 {
    _title.text = str1;
    _title.textColor = c1;
    _title.font = [UIFont boldSystemFontOfSize:s1];
    _subtitle.text = str2;
    _subtitle.textColor = c2;
    _subtitle.font = [UIFont systemFontOfSize:s2];
    [_title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:s1]);
    }];
    [_subtitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo([NSNumber numberWithFloat:s2]);
    }];
    [self layoutIfNeeded];
}
- (void)setImage:(UIImage *)img titleIcon:(UIImage *)icon {
    _imageview.image = img;
    _iconview.image  = icon;
}
- (void)setPadding:(CGFloat)paddingfloat {
    NSNumber *padding = [NSNumber numberWithFloat:paddingfloat];
    [_title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(padding);
    }];
    [_subtitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(padding);
    }];
    [_imageview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(padding);
        make.right.equalTo([NSNumber numberWithFloat:-paddingfloat]);
    }];
    [self layoutIfNeeded];
}
@end
@interface TaoTiaoView : UIView
- (void)setData:(NSString *)str1 str:(NSString *)str2;
- (NSString *)toString;
@end
@implementation TaoTiaoView{
    UILabel *lab1;
    UILabel *lab2;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}
    return self;
}
-(void)initUI{
    lab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, W(self)-20, H(self)/2)];
    lab2 = [[UILabel alloc]initWithFrame:CGRectMake(X(lab1), YH(lab1), W(lab1), H(lab1))];
    [self addSubviews:lab1,lab2,nil];
}
- (void)setData:(NSString *)str1 str:(NSString *)str2 {
    lab1.text = str1;
    lab2.text = str2;
}
- (NSString *)toString {
    return lab1.text;
}
@end
@interface DaRenTaoCell : UICollectionViewCell
- (CGFloat)getHeight;
@end
@implementation DaRenTaoCell {
    UIView *mainView;
    TitlesImageViewFull *view1, *view2, *view3;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    UIButton *daren = [[UIButton alloc]initWithFrame:CGRectMake(APPW/2-50, 0, 100, 20)];
    [daren setImage:[UIImage imageNamed:@"mini01.jpg"] forState:UIControlStateNormal];
    [daren setTitle:@"达人淘" forState:UIControlStateNormal];
    [daren setTitleColor:redcolor forState:UIControlStateNormal];
    UILabel *more = [[UILabel alloc]initWithFrame:CGRectMake(APPW-80, 0, 60, 20)];
    more.text = @"更多 >";
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, YH(daren), APPW, H(self)-YH(daren)-30)];
    mainView.backgroundColor = [UIColor whiteColor];
    CGFloat height = (APPW-32)/3 +14+3+12+3;
    view1 = [[TitlesImageViewFull alloc] initWithFrame:CGRectMake(8, 6, (APPW-32)/3, height)];
    view2 = [[TitlesImageViewFull alloc] initWithFrame:CGRectMake(8+(APPW-32)/3+8, 6, (APPW-32)/3, height)];
    view3 = [[TitlesImageViewFull alloc] initWithFrame:CGRectMake(8+(APPW-32)/3+8+(APPW-32)/3+8, 6, (APPW-32)/3, height)];
    [mainView addSubview:view1];
    [mainView addSubview:view2];
    [mainView addSubview:view3];
    [view1 setTitle:@"红人圈" subTitle:@"别怕，红人圈来了" size1:14 size2:12 color1:[UIColor redColor] color2:[UIColor lightGrayColor]];
    [view1 setImage:[UIImage imageNamed:@"mini1.png"] titleIcon:[UIImage imageNamed:@"hot.png"]];
    [view2 setTitle:@"视频直播" subTitle:@"别怕，学会保护自己!" size1:14 size2:12 color1:[UIColor greenColor] color2:[UIColor lightGrayColor]];
    [view2 setImage:[UIImage imageNamed:@"mini2.png"] titleIcon:nil];
    [view3 setTitle:@"搭配控" subTitle:@"我有我的fan" size1:14 size2:12 color1:[UIColor orangeColor] color2:[UIColor lightGrayColor]];
    [view3 setImage:[UIImage imageNamed:@"mini3.png"] titleIcon:nil];
    [view1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [FreedomTools show:@"红人圈"];
    }]];
    [view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [FreedomTools show:@"视频直播"];
    }]];
    [view3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [FreedomTools show:@"搭配控"];
    }]];
    UILabel *subscrib = [[UILabel alloc]initWithFrame:CGRectMake(10, YH(mainView)-20, APPW-100, 20)];
    subscrib.text = @"小秘书为你精选推荐的N个达人";
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(APPW-40,Y(subscrib), 30, 30)];
    icon.image = [UIImage imageNamed:@"mini1"];
    [self addSubviews:daren,more,mainView,subscrib,icon,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    
}
- (CGFloat)getHeight {
    return (APPW-32)/3 +8+30+8+42+42;
}
@end
@interface Cell1 : UICollectionViewCell{
    UIImageView *image1,*image2,*image3,*image4;
    UIView *view;
}
@end
@implementation Cell1
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self)*2/5.0, H(self))];
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(image1)+1, 0, W(self)-XW(image1)-1, H(self)/2.0)];
    view = [[UIView alloc]initWithFrame:CGRectMake(X(image2), YH(image2)+1, W(image2), H(image2)-1)];
    image3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (W(view)-1)/2.0, H(view))];
    image4 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(image3)+1,0, W(image3), H(image3))];
    [view addSubviews:image3,image4,nil];
    [self addSubviews:image1,image2,view,nil];
    [self setDataWithDict:nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    image1.image = [UIImage imageNamed:@"01.jpg"];
    image2.image = [UIImage imageNamed:@"02.jpg"];
    image3.image = [UIImage imageNamed:@"03.jpg"];
    image4.image = [UIImage imageNamed:@"04.jpg"];
}
@end
@interface GridCell : UICollectionViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgPath;
- (void)hiddenTitle:(BOOL)hidden;
@end
@implementation GridCell{
    UIView *bgview;
    UIImageView *iv;
    UILabel *titleLab,*priceLabel,*flagLab;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self), H(self)-60)];
    iv.clipsToBounds = YES;
    bgview = [[UIView alloc]initWithFrame:self.bounds];
    bgview.layer.shadowColor =[UIColor blackColor].CGColor;
    bgview.layer.shadowOffset = CGSizeMake(0, 1);
    bgview.layer.shadowOpacity = 0.2;
    bgview.layer.shadowRadius = 10;
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(iv), W(self), 40)];
    priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, YH(titleLab), 100, 20)];
    flagLab = [[UILabel alloc]initWithFrame:CGRectMake(W(self)-60, Y(priceLabel), 40, 20)];
    flagLab.backgroundColor = redcolor;
    [self addSubviews:bgview,iv,titleLab,priceLabel,flagLab,nil];
    [self setDataWithDict:nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    iv.image = [UIImage imageNamed:@"image1.jpg"];
    titleLab.text = @"户外腰包男女士跑步运动音乐手机包轻薄贴身防水";
    flagLab.text = @"热销";
    priceLabel.text = @"￥19800.0";
}
- (void)setTitle:(NSString *)title {
    titleLab.text = title;
    titleLab.highlightedTextColor = RGBCOLOR(200, 200, 200);
}
- (void)setImgPath:(NSString *)imgPath {
    iv.image = [UIImage imageNamed:imgPath];
}
- (void)hiddenTitle:(BOOL)hidden {
    titleLab.hidden = hidden;
}
@end
@interface GridCell2 : UICollectionViewCell{
    UIImageView *image1,*image2,*image3;
    UILabel *label1,*label2;
}
@end
@implementation GridCell2
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self)*2/3.0, H(self)-40)];
    image2 = [[UIImageView alloc]initWithFrame:CGRectMake(XW(image1), 0, W(self)-XW(image1), H(image1)/2)];
    image3 = [[UIImageView alloc]initWithFrame:CGRectMake(X(image2), YH(image2), W(image2), H(image2))];
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, YH(image1), W(self)-20, 20)];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(X(label1), YH(label1), W(label1), H(label1))];
    label2.font = fontnomal;
    [self addSubviews:image1,image2,image3,label1,label2,nil];
    [self setDataWithDict:nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    image1.image = [UIImage imageNamed:@"image1.jpg"];
    image2.image = [UIImage imageNamed:@"image2.jpg"];
    image3.image = [UIImage imageNamed:@"image3.jpg"];
    label1.text = @"【生活家--爱的杂货店";
    label2.text = @"115.5万人正在逛店";
}
@end
@interface GridCell3 : UICollectionViewCell
@end
@implementation GridCell3 {
    UIImageView *iv;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    iv = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, W(self)-20, W(self)-20)];
    iv.layer.cornerRadius  = (APPW/5-8/5 -20) /2;
    iv.layer.masksToBounds = YES;
    iv.clipsToBounds = YES;
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, YH(iv), W(self), 20)];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = @"天猫来了";
    [self addSubviews:iv,name,nil];
    [self setDataWithDict:nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    iv.image = [UIImage imageNamed:@"mini1"];
}
//为什么获取的不是正确的值，值是xib对应的width，非实际width
//本来 cornerRadius 是设置在这里的
//有大神知道的指点下 谢谢
- (void)layoutSubviews {
    [super layoutSubviews];
    DLog(@"宽度 %f", iv.frame.size.width);
    //iv.layer.cornerRadius  = iv.frame.size.width /2;
}
@end
@interface HotShiChangCell : UICollectionViewCell{
    UIView *mainView;
    TitlesImageViewFull *view1, *view2;
}
@property (nonatomic, strong) NSArray *dataArr;
@end
@implementation HotShiChangCell
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
                     @{@"title":@"内衣", @"subtitle":@"性感装备", @"image":@"06.jpg", @"icon":@""},
                     @{@"title":@"数码", @"subtitle":@"潮流新机", @"image":@"06.jpg", @"icon":@""},
                     @{@"title":@"运动", @"subtitle":@"潮流新品", @"image":@"07.jpg", @"icon":@""},
                     @{@"title":@"家电", @"subtitle":@"爆款现货抢", @"image":@"06.jpg", @"icon":@""},
                     @{@"title":@"美女", @"subtitle":@"暖被窝女神", @"image":@"07.jpg", @"icon":@""},
                     @{@"title":@"质+", @"subtitle":@"休息裙", @"image":@"06.jpg", @"icon":@""},
                     @{@"title":@"中老年", @"subtitle":@"巧策", @"image":@"07.jpg", @"icon":@""},
                     @{@"title":@"篮球公园", @"subtitle":@"虎扑识货", @"image":@"06.jpg", @"icon":@""}
                     ];
    }
    return _dataArr;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(W(self)/2-50, 0, 100, 20)];
    [titleButton setTitle:@"热门市场" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"mini01.jpg"] forState:UIControlStateNormal];
    UILabel *more = [[UILabel alloc]initWithFrame:CGRectMake(W(self)-80, 0, 60, 20)];
    more.text = @"更多 >";
    mainView = [[UIView alloc]initWithFrame:CGRectMake(0, YH(titleButton), W(self), H(self)-YH(titleButton)-80)];
    mainView.backgroundColor = [UIColor clearColor];
    view1 = [[TitlesImageViewFull alloc] initWithFrame:CGRectMake(0, 0, (APPW-1)/2, 120)];
    view2 = [[TitlesImageViewFull alloc] initWithFrame:CGRectMake((APPW-1)/2+1, 0, (APPW-1)/2, 120)];
    view1.backgroundColor = view2.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:view1];[mainView addSubview:view2];
    [view1 setTitle:@"家具" subTitle:@"尖货推荐" size1:14 size2:12 color1:[UIColor blackColor] color2:[UIColor lightGrayColor]];
    [view2 setTitle:@"女装" subTitle:@"新品推荐" size1:14 size2:12 color1:[UIColor blackColor] color2:[UIColor lightGrayColor]];
    [view1 setImage:[UIImage imageNamed:@"05.jpg"] titleIcon:nil];
    [view2 setImage:[UIImage imageNamed:@"05.jpg"] titleIcon:nil];
    [view1 setPadding:8];[view2 setPadding:8];
    [view1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [FreedomTools show:@"家具"];
    }]];
    [view2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [FreedomTools show:@"女装"];
    }]];
    UIImageView *footimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, YH(mainView), W(self), 80)];
    footimage.image = [UIImage imageNamed:@"image2.jpg"];
    [self addSubviews:titleButton,more,mainView,footimage,nil];
    [self initData];
    
}
-(void)setDataWithDict:(NSDictionary*)dict{
}
- (void)initData {
    TitlesImageViewFull *view;
    //当前i的数据
    float x = 0;
    float y = 0;
    int row = 0;
    int col = 0;
    float width  = (APPW-3)/4; //间隔为1，4列，总间隔3
    float height = 100;
    for (int i=0; i<self.dataArr.count; i++) {
        NSDictionary *dic = self.dataArr[i];
        view = [[TitlesImageViewFull alloc] init];
        view.userInteractionEnabled = YES;
        if (i%4 == 0) {row = (i/4); DLog(@"行 %zd", (i/4));}
        col = (i%4);     DLog(@" 列 %zd", (i%4));
        x = (APPW-3)/4*i + col - row*(APPW-3);
        y = 120 +row*1+1 +row*height;//顶部 间隔 行高
        view.frame = CGRectMake(x, y, width, height);
        if (i == _dataArr.count-1 || i == _dataArr.count -2) {
            [view setTitle:dic[@"title"] subTitle:dic[@"subtitle"] size1:13 size2:11 color1:[UIColor orangeColor] color2:[UIColor grayColor]];
        }else {
            [view setTitle:dic[@"title"] subTitle:dic[@"subtitle"] size1:13 size2:11 color1:[UIColor blackColor] color2:[UIColor lightGrayColor]];
        }
        [view setImage:[UIImage imageNamed:dic[@"image"]] titleIcon:nil];
        [view setPadding:8];
        view.backgroundColor = [UIColor whiteColor];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
            [FreedomTools show:dic[@"title"]];
        }]];
        [mainView addSubview:view];
    }
}
@end
@interface Headview1 : UICollectionReusableView
@end
@implementation Headview1 {
    UIScrollView *scroll;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    scroll = [[UIScrollView alloc]initWithFrame:self.bounds];
    scroll.contentSize = CGSizeMake(APPW *2, APPW/4);
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator   = NO;
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPW, APPW/4)];
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(APPW, 0, APPW, APPW/4)];
    image1.image = [UIImage imageNamed:@"image2.jpg"];
    image2.image = [UIImage imageNamed:@"image4.jpg"];
    [scroll addSubview:image1];
    [scroll addSubview:image2];
    [self addSubview:scroll];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    
}
@end
@interface Headview2 : UICollectionReusableView
@end
@implementation Headview2
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 40,40)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(XW(icon), 0, 200, 20)];
    UILabel *subscrib = [[UILabel alloc]initWithFrame:CGRectMake(X(title), YH(title), W(title), 20)];
    self.contentMode = UIViewContentModeCenter;
    [self addSubviews:icon,title,subscrib,nil];
    icon.image = [UIImage imageNamed:@"xin@2x"];
    title.text = @"猜你喜欢的";
    subscrib.text = @"今日11：00更新";
}
-(void)setDataWithDict:(NSDictionary*)dict{
    
}
@end
@interface Headview3 : UICollectionReusableView
@end
@implementation Headview3 {
    UILabel *lable;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 20, APPW, 1)];
    line.backgroundColor = gradcolor;
    lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 300, 20)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"实时推荐最适合你的宝贝";
    lable.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    self.contentMode = UIViewContentModeCenter;
    [self addSubviews:line,lable,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
    
}
@end
@interface Footview0 : UICollectionReusableView<UIScrollViewDelegate> {
    UIView *mainview;
    TaoTiaoView *ttv1, *ttv2, *ttv3;
    UIScrollView *scroll;
    CGFloat sHeight, sWidth;
}
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSArray *dataArr;
@end
@implementation Footview0
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, H(self), H(self))];
    icon.image = [UIImage imageNamed:@"toutiao.jpg"];
    mainview = [[UIView alloc]initWithFrame:CGRectMake(XW(icon)+1, 0, W(self)-XW(icon)-1, H(self))];
    _dataArr = @[@"111尼玛xx门又出现了啊，为什么没有我啊",@"222淘宝开新店了优惠多多，速度购",@"333好吧你又被骗了哈哈, 好笨啊"];
    _currentIndex = 0;
    sHeight = 50;
    sWidth = APPW -sHeight*3/2;
    scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(0, 0, sWidth, sHeight);
    scroll.pagingEnabled = YES;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    [mainview addSubview:scroll];
    ttv1 = [[TaoTiaoView alloc]initWithFrame:CGRectMake(0, sHeight *0, sWidth, sHeight)];
    ttv2 = [[TaoTiaoView alloc]initWithFrame:CGRectMake(0, sHeight *1, sWidth, sHeight)];
    ttv3 = [[TaoTiaoView alloc]init];
    [scroll addSubview:ttv1];
    [scroll addSubview:ttv2];
    [ttv1 setData:_dataArr[0] str:_dataArr[0]];
    [ttv2 setData:_dataArr[1] str:_dataArr[1]];
    __weak TaoTiaoView *weak_ttv = ttv1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id sender) {
        [FreedomTools show:[weak_ttv toString]];
    }];
    [scroll addGestureRecognizer:tap];
    [scroll setContentSize:CGSizeMake(sWidth, sHeight *2)];
    [scroll setContentOffset:CGPointMake(0, 0) animated:YES];
    scroll.delegate = self;
    [self addSubviews:icon,mainview,nil];
    [self startTimer];
}
-(void)setDataWithDict:(NSDictionary*)dict{
}
- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeNews) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)stopTimer{
    [_timer invalidate];_timer = nil;
}
- (void)changeNews {
    [scroll setContentOffset:CGPointMake(0, sHeight) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scroll.contentOffset.y;
    if (offset >= sHeight) {
        _currentIndex++;
        scroll.contentOffset = CGPointMake(0, 0);
        if (_currentIndex == _dataArr.count-1) {
            [ttv1 setData:_dataArr[_currentIndex] str:_dataArr[_currentIndex ]];
            [ttv2 setData:_dataArr[0] str:_dataArr[0]];
            _currentIndex = -1;
        }else{
            [ttv1 setData:_dataArr[_currentIndex] str:_dataArr[_currentIndex]];
            [ttv2 setData:_dataArr[_currentIndex+1] str:_dataArr[_currentIndex+1]];
        }
    }
}
@end
@interface Footview1 : UICollectionReusableView
@end
@implementation Footview1
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, APPW-20, 20)];
    name.textAlignment = NSTextAlignmentCenter;
    name.text = @"宝贝已经看完了，18：00后更新";
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, YH(name), W(name), 70)];
    image.image = [UIImage imageNamed:@"image2.jpg"];
    [self addSubviews:name,image,nil];
}
-(void)setDataWithDict:(NSDictionary*)dict{
}
@end
@interface TitlesImageView : UIView
- (void)setTitle:(NSString*)str color:(UIColor*)aColor size:(CGFloat)aSize;
- (void)setSubTitle:(NSString*)str color:(UIColor*)aColor size:(CGFloat)aSize;
- (void)setImage:(UIImage*)aImage;
@end
@implementation TitlesImageView {
    UILabel *title;
    UILabel *subTitle;
    UIImageView *imageview;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {[self initUI];}return self;
}
-(void)initUI{
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, W(self)-20, 20)];
    subTitle = [[UILabel alloc]initWithFrame:CGRectMake(X(title), YH(title), W(title), H(title))];
    subTitle.font = fontnomal;
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, YH(subTitle), W(self), H(self)-YH(subTitle))];
    [self addSubviews:title,subTitle,nil];
}
- (void)setTitle:(NSString*)str color:(UIColor*)aColor size:(CGFloat)aSize {
    title.text = str;
    title.textColor = aColor;
    title.font = [UIFont boldSystemFontOfSize:aSize];
}
- (void)setSubTitle:(NSString*)str color:(UIColor*)aColor size:(CGFloat)aSize {
    subTitle.text = str;
    subTitle.textColor = aColor;
    subTitle.font = [UIFont systemFontOfSize:aSize];
}
- (void)setImage:(UIImage*)aImage {
    imageview.image = aImage;
}
@end
//FIXME: 以下是正式的VC
@interface TaobaoHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic ,strong) UICollectionView *grid;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) UILabel *msgLab;
@end
@implementation TaobaoHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}
- (void)setUpView {
    _dataArr    = [NSArray new];
    _sectionArr = [NSArray new];
    self.navigationController.navigationBarHidden = NO;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"输入搜索关键字";
    self.navigationItem.titleView = searchBar;
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    UIImage *image = [[UIImage imageNamed:@"Taobaomessage@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftI = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"TaobaoScanner@2x"] style:UIBarButtonItemStyleDone actionBlick:^{
    }];
    UIBarButtonItem *rightI = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone actionBlick:^{
    }];
    
    self.navigationItem.leftBarButtonItem  = leftI;
    self.navigationItem.rightBarButtonItem = rightI;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.headerReferenceSize = CGSizeMake(320, 40);
    _grid = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [self.view addSubview:_grid];
    _grid.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    _grid.delegate = self;
    _grid.dataSource = self;
    [_grid registerClass:[GridCell class] forCellWithReuseIdentifier:@"GridCell"];
    [_grid registerClass:[GridCell2 class] forCellWithReuseIdentifier:@"GridCell2"];
    [_grid registerClass:[GridCell3 class] forCellWithReuseIdentifier:@"GridCell3"];
    [_grid registerClass:[Cell1 class] forCellWithReuseIdentifier:@"Cell1"];
    [_grid registerClass:[HotShiChangCell class] forCellWithReuseIdentifier:@"HotShiChangCell"];
    [_grid registerClass:[DaRenTaoCell class] forCellWithReuseIdentifier:@"DaRenTaoCell"];
    
    [_grid registerClass:[Headview1 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview1"];
    [_grid registerClass:[Headview2 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview2"];
    [_grid registerClass:[Headview3 class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview3"];
    [_grid registerClass:[Footview0 class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview0"];
    [_grid registerClass:[Footview1 class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview1"];
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0)return 10;
    if (section == 1)return 6;
    if (section == 2)return 4;
    if (section == 3)return 10;
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        GridCell3 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell3" forIndexPath:indexPath];gridcell = cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0){
            Cell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];gridcell = cell;
        }else if (indexPath.row == 1) {
            Cell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];gridcell = cell;
        }else if (indexPath.row == 2) {
            Cell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];gridcell = cell;
        }else if (indexPath.row == 3) {
            Cell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];gridcell = cell;
        }else if (indexPath.row == 4) {
            HotShiChangCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotShiChangCell" forIndexPath:indexPath];gridcell = cell;
        }else if (indexPath.row == 5) {
            DaRenTaoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DaRenTaoCell" forIndexPath:indexPath];gridcell = cell;
        }else {
            
        }
    }else if (indexPath.section == 2) {
        GridCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell2" forIndexPath:indexPath];gridcell = cell;
    }else {//可以加载更多的那个cell
        GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];gridcell = cell;
    }
    return gridcell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader){
            Headview1 *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview1" forIndexPath:indexPath];
            reusableview = headerView;
        }
        if (kind == UICollectionElementKindSectionFooter) {
            Footview0 *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview0" forIndexPath:indexPath];
            reusableview = footview;
        }
    }else if (indexPath.section == 2) {
        if (kind == UICollectionElementKindSectionHeader){
            Headview2 *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview2" forIndexPath:indexPath];
            reusableview = headerView;
        }
    }else if (indexPath.section == 3) {
        if (kind == UICollectionElementKindSectionHeader){
            Headview3 *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headview3" forIndexPath:indexPath];
            reusableview = headerView;
        }
        if (kind == UICollectionElementKindSectionFooter) {
            Footview1 *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview1" forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    return reusableview;
}
//item 宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//9宫格组//减1去除误差
        //DLog(@"########%f", (SCREEN_W-4-4-1)/5;
        return CGSizeMake((APPW-4-4-1)/5 , APPW/5 + 20);
    }
    if (indexPath.section == 1) {//乱七八糟组
        if (indexPath.row == 0)return CGSizeMake(APPW, cell_height(190)+8);
        if (indexPath.row == 4)return CGSizeMake(APPW, 8+30+1+120+1+70 +2*101);
        if (indexPath.row == 5)return CGSizeMake(APPW, (APPW-32)/3 +8+30+8+42+40);
        return CGSizeMake(APPW, cell_height(190)+8);
    }
    if (indexPath.section == 2) {//喜欢组
        return CGSizeMake(APPW/2-4/2, (APPW/2-4/2)*2/3 +48);
    }
    if (indexPath.section == 3) {//推荐组
        return CGSizeMake(APPW/2-4/2, APPW/2-4/2 +80);
    }
    return CGSizeMake(0, 0);
}
//head 宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {return CGSizeMake(APPW, APPW/4);} //图片滚动的宽高
    if (section == 2) {return CGSizeMake(APPW, 50);}    //猜你喜欢的宽高
    if (section == 3) {return CGSizeMake(APPW, 35);}    //推荐适合的宽高
    return CGSizeMake(0, 0);
}
//foot 宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {return CGSizeMake(APPW, 50);}  //淘宝头条的宽高
    if (section == 3) {return CGSizeMake(APPW, 110);} //最底部view的宽高
    return CGSizeZero;
}
//边缘间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {return UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);}return UIEdgeInsetsZero;
}
//x 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//y 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {return 1;}if (section == 1) {return 0;}if (section == 2) {return 4;}return 2;
}
//:FIXME collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {return;}
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"你选择的是%zd，%zd", indexPath.section, indexPath.row]];
    DLog(@"你选择的是%zd，%zd", indexPath.section, indexPath.row);
}
@end
