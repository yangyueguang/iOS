//  XFHomeViewController+Views.m
//  Freedom
//  Created by Super on 2017/11/3.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "XFHomeViewController+Views.h"
#import <XCategory/NSDate+expanded.h>
@implementation XFUser
+(instancetype)userWithDict:(NSDictionary *)dict {
    XFUser * user= [[self alloc]init];
    user.name = dict[@"name"];
    user.idstr = dict[@"idstr"];
    user.profile_image_url = dict[@"profile_image_url"];
    return user;
}
-(void)setMbtype:(int)mbtype {
    _mbtype = mbtype;
    self.vip = mbtype > 2;
}
@end
@interface XFStatusPhotosView : UIView
@property(nonatomic,strong) NSArray *photos;
// 根据图片个数计算相册的尺寸
+ (CGSize)sizeWithCount:(int)count;
@end
@interface XFPhoto : NSObject
/** 缩略图地址 */
@property (nonatomic, copy) NSString *thumbnail_pic;
@end
@implementation XFPhoto
@dynamic thumbnail_pic;
@end
@interface XFStatusPhotoView : UIImageView
@property (nonatomic, strong) XFPhoto *photo;
@end
@interface XFStatusPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation XFStatusPhotoView
- (UIImageView *)gifView{
    if (!_gifView) {
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
    }
    return _gifView;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
        // 超出边框的内容都剪掉
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setPhoto:(XFPhoto *)photo{
    _photo = photo;
    // 设置图片
    NSString *s = [photo valueForKey:@"thumbnail_pic"];
    [self sd_setImageWithURL:[NSURL URLWithString:s] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    self.gifView.hidden = ![s.lowercaseString hasSuffix:@"gif"];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.gifView.frameX = self.frameWidth - self.gifView.frameWidth;
    self.gifView.frameY = self.frameHeight - self.gifView.frameHeight;
}
@end
@implementation XFStatusPhotosView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    int photosCount = (int)photos.count;
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        XFStatusPhotoView *photoView = [[XFStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        XFStatusPhotoView *photoView = self.subviews[i];
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    //设置图片的尺寸和位置
    int photosCount = (int)self.photos.count;
    int maxCol = XFStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        XFStatusPhotoView *photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.frameX = col * (XFStatusPhotoWH + XFStatusPhotoMargin);
        int row = i / maxCol;
        photoView.frameY = row * (XFStatusPhotoWH + XFStatusPhotoMargin);
        photoView.frameWidth = XFStatusPhotoWH;
        photoView.frameHeight = XFStatusPhotoWH;
    }
}
+ (CGSize)sizeWithCount:(int)count{
    // 最大列数（一行最多有多少列）
    int maxCols = XFStatusPhotoMaxCol(count);
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * XFStatusPhotoWH + (cols - 1) * XFStatusPhotoMargin;
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * XFStatusPhotoWH + (rows - 1) * XFStatusPhotoMargin;
    return CGSizeMake(photosW, photosH);
}
@end
@implementation XFStatus
-(NSDictionary *)objectClassInArray {
    return @{@"pic_urls" : [XFPhoto class]};
}
-(NSString *)created_at {
    // _created_at == Thu Oct 16 17:06:25 +0800 2014
    // dateFormat == EEE MMM dd HH:mm:ss Z yyyy
    // NSString --> NSDate
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 微博的创建日期
    NSDate *creatDate = [fmt dateFromString:_created_at];
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calender = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期之间的差值
    NSDateComponents *component = [calender components:unit fromDate:creatDate toDate:now options:0];
    if ([creatDate isThisYear]) { // 今年
        if ([creatDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:creatDate];
        } else if ([creatDate isToday]) { // 今天
            if (component.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前", (long)component.hour];
            } else if (component.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", (long)component.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:creatDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:creatDate];
    }
}
- (void)setSource:(NSString *)source{
    // 正则表达式 NSRegularExpression
    // 截串 NSString
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = (NSInteger)[source rangeOfString:@"</"].location - range.location;
    //DLog(@"%@ %lu %lu",range,(unsigned long)range.length,(unsigned long)source.length);
    if(range.length > 150){
        return;
    }else{
        _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
        
    }
}
@end
@implementation XFStatusFrame
-(void)setStatus:(XFStatus *)status {
    _status  = status;
    XFUser *user = status.user;
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    /* 原创微博 */
    /** 头像 */
    CGFloat iconWH = 40;
    CGFloat iconX = XFStatusCellBorderW;
    CGFloat iconY = XFStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + XFStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:XFStatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX,nameY},nameSize};
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + XFStatusCellBorderH;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + XFStatusCellBorderH;
    CGSize timeSize = [status.created_at sizeOfFont:XFStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + XFStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeOfFont:XFStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    /** 正文 */
    CGFloat contentX = XFStatusCellBorderW;
    CGFloat contentY = CGRectGetMaxY(self.iconViewF) + XFStatusCellBorderW;
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [status.text sizeOfFont:XFStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    /** 配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) {
        CGFloat photosX = XFStatusCellBorderW;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + XFStatusCellBorderW;
        CGSize photosSize = [XFStatusPhotosView sizeWithCount:(int)status.pic_urls.count];
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        originalH = CGRectGetMaxY(self.photosViewF) + XFStatusCellBorderW;
    }else { // 没配图
        originalH = CGRectGetMaxY(self.contentLabelF) + XFStatusCellBorderW;
    }
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    CGFloat toolbarY = 0;
    /* 被转发微博 */
    if (status.retweeted_status) {
        XFStatus *retweeted_status = status.retweeted_status;
        XFUser *retweeted_status_user = retweeted_status.user;
        /** 被转发微博正文 */
        CGFloat retweetContentX = XFStatusCellBorderW;
        CGFloat retweetContentY = XFStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        CGSize retweetContentSize = [retweetContent sizeOfFont:XFStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGSize retweetPhotosSize = [XFStatusPhotosView sizeWithCount:(int)retweeted_status.pic_urls.count];
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + XFStatusCellBorderW;
            self.retweetPhotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetPhotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetPhotosViewF) + XFStatusCellBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + XFStatusCellBorderW;
        }
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        toolbarY = CGRectGetMaxY(self.retweetViewF);
    } else {
        toolbarY = CGRectGetMaxY(self.originalViewF);
    }
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF) + Boardseperad;
}
@end
@implementation XFTitleButton
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self setTitle:@"首页" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setImage:[UIImage imageNamed:PcellDown_y] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:PcellUp_y] forState:UIControlStateSelected];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    // 1.计算titleLabel的frame
    self.titleLabel.frameX = 0;
    // 2.计算imageView的frame
    self.imageView.frameX = CGRectGetMaxX(self.titleLabel.frame) + 10;
    //self.titleLabel.x = self.imageView.x;
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self sizeToFit];
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self sizeToFit];
}
@end
@implementation XFLoadMoreFooter
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc]init];
        label.frameWidth = [UIScreen mainScreen].bounds.size.width;
        label.frameHeight = 44;
        label.text = @"加载更多内容";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:18 weight:2.0];
        [self addSubview:label];
    }
    return self;
}
@end
@interface XFDropdownView()
//  将来用来显示具体内容的容器
@property (nonatomic, weak) UIImageView *containerView;
@end
@implementation XFDropdownView
- (UIImageView *)containerView{
    if (!_containerView) {
        // 添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage imageNamed:@"popover_background"];
        containerView.frameWidth = 180;
        containerView.frameHeight = 217;
        containerView.userInteractionEnabled = YES; // 开启交互
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除颜色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
+ (instancetype)menu{
    return [[self alloc] init];
}
- (void)setContent:(UIView *)content{
    _content = content;
    // 调整内容的位置
    content.frameX = 10;
    content.frameY = 15;
    // 调整内容的宽度
    content.frameWidth = self.containerView.frameWidth - 2 * content.frameX;
    // 设置灰色的高度
    self.containerView.frameHeight = CGRectGetMaxY(content.frame) + 10;
    // 添加内容到灰色图片中
    [self.containerView addSubview:content];
}
- (void)setContentController:(UIViewController *)contentController{
    _contentController = contentController;
    self.content = contentController.view;
}
/*显示*/
- (void)showFrom:(UIView *)from{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    // 2.添加自己到窗口上
    [window addSubview:self];
    // 3.设置尺寸
    self.frame = window.bounds;
    // 4.调整灰色图片的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.containerView.center = CGPointMake(CGRectGetMidX(newFrame),CGRectGetMaxY(newFrame));
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
}
/*销毁*/
- (void)dismiss{
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}
@end
@interface XFStatusToolbar : UIView
@property(nonatomic,strong)XFStatus *status;
+(instancetype)toolbar;
@end
@interface XFStatusToolbar()
/** 里面存放所有的按钮 */
@property (nonatomic, strong) NSMutableArray *btns;
/** 里面存放所有的分割线 */
@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) UIButton *repostBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;
@end
@implementation XFStatusToolbar
-(NSMutableArray *)btns {
    if (!_btns) {
        self.btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray *)dividers{
    if (!_dividers) {
        self.dividers = [NSMutableArray array];
    }
    return _dividers;
}
+(instancetype)toolbar {
    return [[self alloc]init];
}
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        // 添加按钮
        self.repostBtn = [self setupBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtn:@"赞" icon:@"timeline_icon_unlike"];
        
        //添加分割线
        [self setupDivider];
        [self setupDivider];
    }
    return self;
}
/**
 * 添加分割线*/
- (void)setupDivider{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}
-(UIButton *)setupBtn:(NSString *)title icon:(NSString *)icon{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    // 设置按钮的frame
    int btnCount = (int)self.btns.count;
    CGFloat btnw = self.frameWidth / btnCount;
    CGFloat btnH = self.frameHeight;
    
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.frameHeight = btnH;
        btn.frameWidth = btnw;
        btn.frameX = i * btnw;
        btn.frameY = 0;
        
    }
    // 设置分割线的frame
    int dividerCount = (int)self.dividers.count;
    for (int i = 0; i<dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.frameWidth = 1;
        divider.frameHeight = btnH;
        divider.frameX = (i+1) * btnw;
        divider.frameY = 0;
    }
}
-(void)setStatus:(XFStatus *)status {
    _status = status;
    //转发
    [self setupBtnCount:status.reposts_count btn:self.repostBtn title:@"转发"];
    // 评论
    [self setupBtnCount:status.comments_count btn:self.commentBtn title:@"评论"];
    // 赞
    [self setupBtnCount:status.attitudes_count btn:self.attitudeBtn title:@"赞"];
}
- (void)setupBtnCount:(int)count btn:(UIButton *)btn title:(NSString *)title {
    if (count) {
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%d",count];
        }else{
            double wan = count / 10000;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}
@end
@interface XFIconView : UIImageView
@property (nonatomic,strong) XFUser *user;
@end
@interface XFIconView ()
@property (nonatomic,weak)UIImageView *verifiedView;
@end
@implementation XFIconView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(UIImageView *)verifiedView {
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc]init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}
-(void)setUser:(XFUser *)user {
    _user = user;
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 2.设置加V图片
    switch (user.verified_type) {
        case XFUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case XFUserVerifiedOrgEnterprice:
        case XFUserVerifiedOrgMedia:
        case XFUserVerifiedOrgWebsite: // 官方认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case XFUserVerifiedDaren: // 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.verifiedView.frameSize = self.verifiedView.image.size;
    self.verifiedView.frameX = self.frameWidth - self.verifiedView.frameWidth * 0.6;
    self.verifiedView.frameY = self.frameHeight - self.verifiedView.frameHeight * 0.6;
}
@end
@interface XFStatusViewCell ()
/* 原创微博 */
/** 原创微博整体 */
@property (nonatomic, weak) UIView *originalView;
/** 头像 */
@property (nonatomic, weak) XFIconView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) XFStatusPhotosView *photosView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
/* 转发微博 */
/** 转发微博整体 */
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) XFStatusPhotosView *retweetPhotosView;
/** 工具条 */
@property (nonatomic, weak) XFStatusToolbar *toolbar;
@end
@implementation XFStatusViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"status";
    XFStatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[XFStatusViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
/*cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置*/
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化原创微博
        [self setupOriginal];
        
        // 初始化转发微博
        [self setupRetweet];
        //初始化工具条
        [self setupToolbar];
    }
    return  self;
}
-(void)setupToolbar{
    XFStatusToolbar *toolbar = [[XFStatusToolbar alloc]init];
    //toolbar.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
}
/**
 * 初始化转发微博*/
- (void)setupRetweet {
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = RGBCOLOR(240, 240, 240);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = XFStatusCellRetweetContentFont;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    /** 转发微博配图 */
    XFStatusPhotosView *retweetPhotosView = [[XFStatusPhotosView alloc] init];
    //retweetPhotosView.backgroundColor = [UIColor blueColor];
    [retweetView addSubview:retweetPhotosView];
    self.retweetPhotosView = retweetPhotosView;
}
/**
 * 初始化原创微博*/
- (void)setupOriginal {
    /** 原创微博整体 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    XFIconView *iconView = [[XFIconView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 配图 */
    XFStatusPhotosView *photosView = [[XFStatusPhotosView alloc] init];
    [originalView addSubview:photosView];
    self.photosView = photosView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = XFStatusCellNameFont;
    [originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = XFStatusCellTimeFont;
    timeLabel.textColor = [UIColor orangeColor];
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = XFStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = XFStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}
-(void)setStatusFrame:(XFStatusFrame *)statusFrame {
    _statusFrame = statusFrame;
    XFStatus *status = statusFrame.status;
    XFUser *user = status.user;
    
    /** 原创微博整体 */
    self.originalView.frame = statusFrame.originalViewF;
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    self.iconView.user = user;
    /** 会员图标 */
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    /** 配图 */
    if (status.pic_urls.count) {
        self.photosView.frame = statusFrame.photosViewF;
        self.photosView.photos = status.pic_urls;
        self.photosView.hidden = NO;
    }else {
        self.photosView.hidden = YES;
    }
    /** 昵称 */
    self.nameLabel.text = user.name;
    self.nameLabel.frame = statusFrame.nameLabelF;
    
    /** 时间 */
    NSString *time = status.created_at;
    CGFloat timeX = statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(statusFrame.nameLabelF) + 10;
    CGSize timeSize = [time sizeWithFont:XFStatusCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + 10;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:XFStatusCellSourceFont];
    self.sourceLabel.textColor = [UIColor grayColor];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    self.sourceLabel.text = status.source;
    /** 正文 */
    self.contentLabel.text = status.text;
    self.contentLabel.frame = statusFrame.contentLabelF;
    /** 被转发的微博 */
    if (status.retweeted_status) {
        XFStatus *retweeted_status = status.retweeted_status;
        XFUser *retweeted_status_user = retweeted_status.user;
        self.retweetView.hidden = NO;
        /** 被转发的微博整体 */
        self.retweetView.frame = statusFrame.retweetViewF;
        /** 被转发的微博正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status_user.name, retweeted_status.text];
        self.retweetContentLabel.text = retweetContent;
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        /** 被转发的微博配图 */
        if (retweeted_status.pic_urls.count) {
            self.retweetPhotosView.frame = statusFrame.retweetPhotosViewF;
            self.retweetPhotosView.photos = retweeted_status.pic_urls;
            self.retweetPhotosView.hidden = NO;
        } else {
            self.retweetPhotosView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = status;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
@implementation XFHomeViewController (Views)
@end
