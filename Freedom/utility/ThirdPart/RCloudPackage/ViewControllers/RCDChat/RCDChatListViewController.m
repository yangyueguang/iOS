//
//  FirstViewController.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
#import "RCDChatListViewController.h"
#import "AFHttpTool.h"
#import "KxMenu.h"
#import "RCDAddFriendViewController.h"
#import "RCDAddressBookViewController.h"
#import "RCDChatViewController.h"
#import "RCDContactSelectedTableViewController.h"
#import "RCDHttpTool.h"
#import "RCDServiceViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDSearchFriendViewController.h"
#import "RCloudModel.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDSearchViewController.h"
#import <RongIMKit/RongIMKit.h>
#define TabbarItemNums 4.0
@interface RCDTabBarBtn : UIButton
/** 大圆脱离小圆的最大距离 */
@property (nonatomic, assign) CGFloat maxDistance;
/** 小圆 */
@property (nonatomic, strong) UIView *samllCircleView;
/** 按钮消失的动画图片组 */
@property (nonatomic, strong) NSMutableArray *images;
/** 未读数 */
@property (nonatomic, strong) NSString *unreadCount;
@property (nonatomic, strong) UIImage *unreadCountImage;
/** 绘制不规则图形 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end
@interface RCDTabBarBtn()
@property (nonatomic, strong)NSString *tabBarIndex;
@end
@implementation RCDTabBarBtn
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(setTabBarIndexStr:)
         name:@"NotifyTabBarIndex"
         object:nil];
        self.tabBarIndex = 0;
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}
#pragma mark - 懒加载
- (NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
            [_images addObject:image];
        }
    }
    return _images;
}
- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [self.backgroundColor CGColor];
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    return _shapeLayer;
}
- (UIView *)samllCircleView{
    if (!_samllCircleView) {
        _samllCircleView = [[UIView alloc] init];
        _samllCircleView.backgroundColor = self.backgroundColor;
        [self.superview insertSubview:_samllCircleView belowSubview:self];
    }
    return _samllCircleView;
}
- (void)setUp{
    CGSize size = self.bounds.size;
    CGFloat cornerRadius = (size.height > size.width ? size.width / 2.0 : size.height / 2.0);
    self.backgroundColor = [FreedomTools colorWithRGBHex:0xf43530];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    _maxDistance = cornerRadius * 5;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    CGRect samllCireleRect = CGRectMake(0, 0, cornerRadius * (2 - 0.5) , cornerRadius * (2 - 0.5));
    self.samllCircleView.bounds = samllCireleRect;
    _samllCircleView.center = self.center;
    _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 手势
- (void)pan:(UIPanGestureRecognizer *)pan{
    [self.layer removeAnimationForKey:@"shake"];
    CGPoint panPoint = [pan translationInView:self];
    CGPoint changeCenter = self.center;
    changeCenter.x += panPoint.x;
    changeCenter.y += panPoint.y;
    self.center = changeCenter;
    [pan setTranslation:CGPointZero inView:self];
    //俩个圆的中心点之间的距离
    CGFloat dist = [self pointToPoitnDistanceWithPoint:self.center potintB:self.samllCircleView.center];
    if (dist < _maxDistance) {
        CGSize size = self.bounds.size;
        CGFloat cornerRadius = (size.height > size.width ? size.width / 2 : size.height / 2);
        CGFloat samllCrecleRadius = cornerRadius - dist / 10;
        _samllCircleView.bounds = CGRectMake(0, 0, samllCrecleRadius * (2 - 0.5), samllCrecleRadius * (2 - 0.5));
        _samllCircleView.layer.cornerRadius = _samllCircleView.bounds.size.width / 2;
        if (_samllCircleView.hidden == NO && dist > 0) {
            //画不规则矩形
            self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:_samllCircleView].CGPath;
        }
    } else {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        self.samllCircleView.hidden = YES;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (dist > _maxDistance) {
            //播放销毁动画
            //      [self startDestroyAnimations];
            //销毁全部控件
            [self killAll];
        } else {
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = self.samllCircleView.center;
            } completion:^(BOOL finished) {
                self.samllCircleView.hidden = NO;
            }];
        }
    }
}
#pragma mark - 俩个圆心之间的距离
- (CGFloat)pointToPoitnDistanceWithPoint:(CGPoint)pointA potintB:(CGPoint)pointB{
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(offestX * offestX + offestY * offestY);
    return dist;
}
- (void)killAll{
    [self.samllCircleView removeFromSuperview];
    [self.shapeLayer removeFromSuperlayer];
    [self removeFromSuperview];
    NSArray *conversationList = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *syncConversations = [[NSMutableArray alloc] init];
        for (int i = 0; i < conversationList.count; i++) {
            RCConversation *conversation = conversationList[i];
            if (conversation.unreadMessageCount > 0) {
                [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:conversation.conversationType targetId:conversation.targetId];
                [syncConversations addObject:conversation];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshConversationList" object:nil];
        for (RCConversation *conversation in syncConversations) {
            [NSThread sleepForTimeInterval:0.2];
            [RCKitUtility syncConversationReadStatusIfEnabled:conversation];
        }
    });
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
#pragma mark - 不规则路径
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.height / 2;
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;
    // 获取圆心距离
    CGFloat d = [self pointToPoitnDistanceWithPoint:self.samllCircleView.center potintB:self.center];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    [path addLineToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
}
#pragma mark - button消失动画
- (void)startDestroyAnimations{
    UIImageView *ainmImageView = [[UIImageView alloc] initWithFrame:self.frame];
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 1;
    ainmImageView.animationDuration = 0.5;
    [ainmImageView startAnimating];
    [self.superview addSubview:ainmImageView];
}
- (void)btnClick{
    //  [self startDestroyAnimations];
    //  [self killAll];
}
#pragma mark - 设置长按时候左右摇摆的动画
- (void)setHighlighted:(BOOL)highlighted{
    [self.layer removeAnimationForKey:@"shake"];
    //长按左右晃动的幅度大小
    CGFloat shake = 3;
    CAKeyframeAnimation *keyAnim = [CAKeyframeAnimation animation];
    keyAnim.keyPath = @"transform.translation.x";
    keyAnim.values = @[@(-shake), @(shake), @(-shake)];
    keyAnim.removedOnCompletion = NO;
    keyAnim.repeatCount = 2;
    //左右晃动一次的时间
    keyAnim.duration = 0.3;
    if ( [self.layer animationForKey:@"shake"] == nil) {
        [self.layer addAnimation:keyAnim forKey:@"shake"];
    }
}
-(void)setUnreadCount:(NSString *)unreadCount{
    [self setTitle:unreadCount forState:UIControlStateNormal];
}
- (void)setTabBarIndexStr:(NSNotification *)notify {
    if (notify != nil) {
        self.tabBarIndex = notify.object;
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
@interface UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index; //显示小红点
- (void)showBadgeOnItemIndex:(int)index badgeValue:(int)badgeValue; //显示带badge的红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
@implementation UITabBar (badge)
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888+index;
    badgeView.layer.cornerRadius = 5.f;//圆形
    badgeView.backgroundColor = [FreedomTools colorWithRGBHex:0xf43530];//颜色：红色
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.5) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
    [self addSubview:badgeView];
}
- (void)showBadgeOnItemIndex:(int)index badgeValue:(int)badgeValue{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    //新建小红点
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    float percentX = (index +0.5) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    if (badgeValue < 10) {
        [self initUnreadCountButton:CGRectMake(x, y, 18, 18) tag:888+index badgeValue:badgeValue];
    }
    if (badgeValue >= 10 && badgeValue < 100 ) {
        [self initUnreadCountButton:CGRectMake(x, y, 22, 18) tag:888+index badgeValue:badgeValue];
    }
    if (badgeValue >= 100) {
        RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:CGRectMake(x, y, 22, 18)];
        [btn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = 888+index;
        // btn.layer.cornerRadius = 9;//圆形
    }
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [((RCDTabBarBtn *)subView).shapeLayer removeFromSuperlayer];
            [subView removeFromSuperview];
        }
    }
}
-(void)initUnreadCountButton:(CGRect)frame tag:(NSUInteger)tag badgeValue:(int)badgeValue{
    RCDTabBarBtn *btn = [[RCDTabBarBtn alloc] initWithFrame:frame];
    [self addSubview:btn];
    btn.tag = tag;
    btn.layer.cornerRadius = 9;//圆形
    btn.unreadCount = [NSString stringWithFormat:@"%d",badgeValue];
}
@end
@interface RCDChatListCell : RCConversationBaseCell
@property(nonatomic, strong) UIImageView *ivAva;
@property(nonatomic, strong) UILabel *lblName;
@property(nonatomic, strong) UILabel *lblDetail;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, strong) UILabel *labelTime;
@end
@implementation RCDChatListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _ivAva = [UIImageView new];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 5.0f;
        if ([[RCIM sharedRCIM] globalConversationAvatarStyle] ==
            RC_USER_AVATAR_CYCLE) {
            _ivAva.layer.cornerRadius =
            [[RCIM sharedRCIM] globalConversationPortraitSize].height / 2;
        }
        [_ivAva setBackgroundColor:[UIColor blackColor]];
        _lblDetail = [UILabel new];
        [_lblDetail setFont:[UIFont systemFontOfSize:14.f]];
        [_lblDetail setTextColor:[FreedomTools colorWithRGBHex:0x8c8c8c]];
        _lblDetail.text =
        [NSString stringWithFormat:@"来自%@的好友请求", _userName];
        _lblName = [UILabel new];
        [_lblName setFont:[UIFont boldSystemFontOfSize:16.f]];
        [_lblName setTextColor:[FreedomTools colorWithRGBHex:0x252525]];
        _lblName.text = @"好友消息";
        _labelTime = [[UILabel alloc] init];
        _labelTime.backgroundColor = [UIColor clearColor];
        _labelTime.font = [UIFont systemFontOfSize:14];
        _labelTime.textColor = [UIColor lightGrayColor];
        _labelTime.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_ivAva];
        [self.contentView addSubview:_lblDetail];
        [self.contentView addSubview:_lblName];
        [self.contentView addSubview:_labelTime];
        _ivAva.translatesAutoresizingMaskIntoConstraints = NO;
        _lblName.translatesAutoresizingMaskIntoConstraints = NO;
        _lblDetail.translatesAutoresizingMaskIntoConstraints = NO;
        _labelTime.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *_bindingViews = NSDictionaryOfVariableBindings(
                                                                     _ivAva, _lblName, _lblDetail, _labelTime);
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-11-[_labelTime(20)]"
          options:0
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _labelTime)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:[_labelTime(200)]-11-|"
          options:0
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _labelTime)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-13-[_ivAva(width)]"
          options:0
          metrics:@{
                    @"width" : @(
                        [RCIM sharedRCIM]
                        .globalConversationPortraitSize
                        .width)
                    }
          views:NSDictionaryOfVariableBindings(
                                               _ivAva)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|-10-[_ivAva(height)]"
          options:0
          metrics:@{
                    @"height" : @(
                        [RCIM sharedRCIM]
                        .globalConversationPortraitSize
                        .height)
                    }
          views:NSDictionaryOfVariableBindings(
                                               _ivAva)]];
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:
                              @"V:[_lblName(18)]-[_lblDetail(18)]"
                              options:kNilOptions
                              metrics:kNilOptions
                              views:_bindingViews]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_lblName
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:_ivAva
                             attribute:NSLayoutAttributeTop
                             multiplier:1.0
                             constant:2.f]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_lblName
                             attribute:NSLayoutAttributeLeft
                             relatedBy:NSLayoutRelationEqual
                             toItem:_ivAva
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0
                             constant:8]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_lblDetail
                             attribute:NSLayoutAttributeLeft
                             relatedBy:NSLayoutRelationEqual
                             toItem:_lblName
                             attribute:NSLayoutAttributeLeft
                             multiplier:1.0
                             constant:1]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_lblDetail
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:_labelTime
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0
                             constant:-30]];
    }
    return self;
}
@end
@interface RCDChatListViewController ()<UISearchBarDelegate,RCDSearchViewDelegate>
@property (nonatomic,strong)UINavigationController *searchNavigationController;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UISearchBar *searchBar;
//@property (nonatomic,strong) NSMutableArray *myDataSource;
@property(nonatomic, strong) RCConversationModel *tempModel;
@property(nonatomic, assign) NSUInteger index;
@property(nonatomic, assign) BOOL isClick;
- (void)updateBadgeValueForTabBarItem;
@end
@implementation RCDChatListViewController
-(UISearchBar *)searchBar{
  if (!_searchBar) {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
      _searchBar.placeholder = @"搜索";
      _searchBar.keyboardType = UIKeyboardTypeDefault;
      _searchBar.backgroundImage = [FreedomTools imageWithColor:[UIColor clearColor]];
      //设置顶部搜索栏的背景色
      [_searchBar setBackgroundColor:[FreedomTools colorWithRGBHex:0xf0f0f6]];
      //设置顶部搜索栏输入框的样式
      UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
      searchField.layer.borderWidth = 0.5f;
      searchField.layer.borderColor = [[FreedomTools colorWithRGBHex:0xdfdfdf] CGColor];
      searchField.layer.cornerRadius = 5.f;
  }
  return _searchBar;
}
- (UIView *)headerView{
  if (!_headerView) {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
  }
  return _headerView;
}
/**
 *  此处使用storyboard初始化，代码初始化当前类时*****必须要设置会话类型和聚合类型*****
 *
 *  @param aDecoder aDecoder description
 *
 *  @return return value description
 */
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[
      @(ConversationType_PRIVATE),
      @(ConversationType_DISCUSSION),
      @(ConversationType_APPSERVICE),
      @(ConversationType_PUBLICSERVICE),
      @(ConversationType_GROUP),
      @(ConversationType_SYSTEM)
    ]];
    //聚合会话类型
    [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
  }
  return self;
}
- (id)init {
  self = [super init];
  if (self) {
    //设置要显示的会话类型
    [self setDisplayConversationTypes:@[
                                        @(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_PUBLICSERVICE),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_SYSTEM)
                                        ]];
    
    //聚合会话类型
    [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
    
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationController.navigationBar.translucent = NO;
  self.searchBar.delegate = self;
  [self.headerView addSubview:self.searchBar];
  self.conversationListTableView.tableHeaderView = self.headerView;
  //设置tableView样式
  self.conversationListTableView.separatorColor =
      [FreedomTools colorWithRGBHex:0xdfdfdf];
  self.conversationListTableView.tableFooterView = [UIView new];
  // 设置在NavigatorBar中显示连接中的提示
  self.showConnectingStatusOnNavigatorBar = YES;
  //修改tabbar的背景色
  UIView *tabBarBG = [UIView new];
  tabBarBG.backgroundColor = [FreedomTools colorWithRGBHex:0xf9f9f9];
  tabBarBG.frame = self.tabBarController.tabBar.bounds;
  [[UITabBar appearance] insertSubview:tabBarBG atIndex:0];
  [[UITabBarItem appearance]
      setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [FreedomTools colorWithRGBHex:0x999999],
                                               NSForegroundColorAttributeName, nil]
                    forState:UIControlStateNormal];
  [[UITabBarItem appearance]
      setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [FreedomTools colorWithRGBHex:0x0099ff],
                                               NSForegroundColorAttributeName, nil]
                    forState:UIControlStateSelected];
  
  //定位未读数会话
  self.index = 0;
  //接收定位到未读数会话的通知
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(GotoNextCoversation)
   name:@"GotoNextCoversation"
   object:nil];
  
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(updateForSharedMessageInsertSuccess)
   name:@"RCDSharedMessageInsertSuccess"
   object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshCell:)
                                               name:@"RefreshConversationList"
                                             object:nil];
  
  [self checkVersion];
    [self updateBadgeValueForTabBarItem];
}
- (UIBarButtonItem *)barButtonItemContainImage:(UIImage *)buttonImage imageViewFrame:(CGRect)imageFrame buttonTitle:(NSString *)buttonTitle titleColor:(UIColor*)titleColor titleFrame:(CGRect)titleFrame buttonFrame:(CGRect)buttonFrame target:(id)target action:(SEL)method {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = buttonFrame;
    UIImageView *image = [[UIImageView alloc]initWithImage:buttonImage];
    image.frame = imageFrame;
    [button addSubview:image];
    if (buttonTitle != nil && titleColor != nil) {
        UILabel *titleText = [[UILabel alloc] initWithFrame:titleFrame];
        titleText.text = buttonTitle;
        [titleText setBackgroundColor:[UIColor clearColor]];
        [titleText setTextColor:titleColor];
        [button addSubview:titleText];
    }
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    item.customView = button;
    return item;
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    //判断如果有未读数存在，发出定位到未读数会话的通知
    if ([[RCIMClient sharedRCIMClient] getTotalUnreadCount] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoNextCoversation" object:nil];
    }
  self.navigationController.navigationBar.translucent = NO;
  
  _isClick = YES;
  //自定义rightBarButtonItem
    UIBarButtonItem *rightBtn = [self barButtonItemContainImage:[UIImage imageNamed:@"u_add"] imageViewFrame:CGRectMake(0, 0, 17, 17) buttonTitle:nil titleColor:nil titleFrame:CGRectZero buttonFrame:CGRectMake(0, 0, 17, 17) target:self action:@selector(showMenu:)];
    NSArray<UIBarButtonItem *> *barButtonItems;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -6;
    barButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightBtn, nil];
  self.tabBarController.navigationItem.rightBarButtonItems = barButtonItems;
  
  self.tabBarController.navigationItem.title = @"会话";
//  [self notifyUpdateUnreadMessageCount];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(receiveNeedRefreshNotification:)
             name:@"kRCNeedReloadDiscussionListNotification"
           object:nil];
  RCUserInfo *groupNotify = [[RCUserInfo alloc] initWithUserId:@"__system__"
                                                          name:@""
                                                      portrait:nil];
  [[RCIM sharedRCIM] refreshUserInfoCache:groupNotify withUserId:@"__system__"];
}
//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:@"kRCNeedReloadDiscussionListNotification"
              object:nil];
}
- (void)updateBadgeValueForTabBarItem {
  __weak typeof(self) __weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    int count = [[RCIMClient sharedRCIMClient]
        getUnreadCount:self.displayConversationTypeArray];
    if (count > 0) {
//      __weakSelf.tabBarItem.badgeValue =
//          [[NSString alloc] initWithFormat:@"%d", count];
      [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:0 badgeValue:count];
      
    } else {
//      __weakSelf.tabBarItem.badgeValue = nil;
      [__weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:0];
    }
  });
}
/**
 *  点击进入会话页面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
  if (_isClick) {
    _isClick = NO;
    if (model.conversationModelType ==
        RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
      RCDChatViewController *_conversationVC =
          [[RCDChatViewController alloc] init];
      _conversationVC.conversationType = model.conversationType;
      _conversationVC.targetId = model.targetId;
      _conversationVC.csInfo.nickName = model.conversationTitle;
      _conversationVC.title = model.conversationTitle;
      _conversationVC.conversation = model;
        _conversationVC.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:_conversationVC
                                           animated:YES];
    }
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
      RCDChatViewController *_conversationVC =
          [[RCDChatViewController alloc] init];
      _conversationVC.conversationType = model.conversationType;
      _conversationVC.targetId = model.targetId;
      _conversationVC.csInfo.nickName = model.conversationTitle;
      _conversationVC.title = model.conversationTitle;
      _conversationVC.conversation = model;
      _conversationVC.unReadMessage = model.unreadMessageCount;
      _conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
      _conversationVC.enableUnreadMessageIcon = YES;
      if (model.conversationType == ConversationType_SYSTEM) {
        _conversationVC.csInfo.nickName = @"系统消息";
        _conversationVC.title = @"系统消息";
      }
      if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
          RCDAddressBookViewController * addressBookVC= [RCDAddressBookViewController addressBookViewController];
        addressBookVC.needSyncFriendList = YES;
          addressBookVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addressBookVC
                                             animated:YES];
        return;
      }
      //如果是单聊，不显示发送方昵称
      if (model.conversationType == ConversationType_PRIVATE) {
        _conversationVC.displayUserNameInCell = NO;
      }
      [self.navigationController pushViewController:_conversationVC
                                           animated:YES];
    }
    //聚合会话类型，此处自定设置。
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
      RCDChatListViewController *temp =
          [[RCDChatListViewController alloc] init];
      NSArray *array = [NSArray
          arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
      [temp setDisplayConversationTypes:array];
      [temp setCollectionConversationType:nil];
      temp.isEnteredToCollectionViewController = YES;
      [self.navigationController pushViewController:temp animated:YES];
    }
    //自定义会话类型
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
      RCConversationModel *model =
          self.conversationListDataSource[indexPath.row];
      if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
          RCDAddressBookViewController * addressBookVC= [RCDAddressBookViewController addressBookViewController];
        [self.navigationController pushViewController:addressBookVC
                                             animated:YES];
      }
    }
  }
  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self refreshConversationTableViewIfNeeded];
      });
}
/**
 *  弹出层
 *
 *  @param sender sender description
 */
- (void)showMenu:(UIButton *)sender {
  NSArray *menuItems = @[
    [KxMenuItem menuItem:@"发起聊天"
                   image:[UIImage imageNamed:@"startchat_icon"]
                  target:self
                  action:@selector(pushChat:)],
    [KxMenuItem menuItem:@"创建群组"
                   image:[UIImage imageNamed:@"creategroup_icon"]
                  target:self
                  action:@selector(pushContactSelected:)],
    [KxMenuItem menuItem:@"添加好友"
                   image:[UIImage imageNamed:@"addfriend_icon"]
                  target:self
                  action:@selector(pushAddFriend:)],
    [KxMenuItem menuItem:@"创建讨论组"
                   image:[UIImage imageNamed:@"addfriend_icon"]
                  target:self
                  action:@selector(pushToCreateDiscussion:)],
  ];
  UIBarButtonItem *rightBarButton = self.tabBarController.navigationItem.rightBarButtonItems[1];
  CGRect targetFrame = rightBarButton.customView.frame;
  targetFrame.origin.y = targetFrame.origin.y + 15;
  [KxMenu setTintColor:[FreedomTools colorWithRGBHex:0x000000]];
  [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];
  [KxMenu showMenuInView:self.tabBarController.navigationController
                             .navigationBar.superview
                fromRect:targetFrame
               menuItems:menuItems];
}
/**
 *  发起聊天
 *
 *  @param sender sender description
 */
- (void)pushChat:(id)sender {
    RCDContactSelectedTableViewController *contactSelectedVC = [[RCDContactSelectedTableViewController alloc]init];
  //    contactSelectedVC.forCreatingDiscussionGroup = YES;
  contactSelectedVC.isAllowsMultipleSelection = NO;
  contactSelectedVC.titleStr = @"发起聊天";
  [self.navigationController pushViewController:contactSelectedVC animated:YES];
}
/**
 *  创建群组
 *
 *  @param sender sender description
 */
- (void)pushContactSelected:(id)sender {
    RCDContactSelectedTableViewController *contactSelectedVC = [[RCDContactSelectedTableViewController alloc]init];
  contactSelectedVC.forCreatingGroup = YES;
  contactSelectedVC.isAllowsMultipleSelection = YES;
  contactSelectedVC.titleStr = @"选择联系人";
  [self.navigationController pushViewController:contactSelectedVC animated:YES];
}
/**
 *  公众号会话
 *
 *  @param sender sender description
 */
- (void)pushPublicService:(id)sender {
  RCDPublicServiceListViewController *publicServiceVC =
      [[RCDPublicServiceListViewController alloc] init];
  [self.navigationController pushViewController:publicServiceVC animated:YES];
}
/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void)pushAddFriend:(id)sender {
  RCDSearchFriendViewController *searchFirendVC =
      [RCDSearchFriendViewController searchFriendViewController];
  [self.navigationController pushViewController:searchFirendVC animated:YES];
}
/**
 *  通讯录
 *
 *  @param sender sender description
 */
- (void)pushAddressBook:(id)sender {
    RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
  [self.navigationController pushViewController:addressBookVC animated:YES];
}
/**
 *  添加公众号
 *
 *  @param sender sender description
 */
- (void)pushAddPublicService:(id)sender {
  RCPublicServiceSearchViewController *searchFirendVC =
      [[RCPublicServiceSearchViewController alloc] init];
  [self.navigationController pushViewController:searchFirendVC animated:YES];
}
//*********************插入自定义Cell*********************//
//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
  for (int i = 0; i < dataSource.count; i++) {
    RCConversationModel *model = dataSource[i];
    //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
    if (model.conversationType == ConversationType_SYSTEM &&
        [model.lastestMessage
            isMemberOfClass:[RCContactNotificationMessage class]]) {
      model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    }
    if ([model.lastestMessage
            isKindOfClass:[RCGroupNotificationMessage class]]) {
      RCGroupNotificationMessage *groupNotification =
          (RCGroupNotificationMessage *)model.lastestMessage;
      if ([groupNotification.operation isEqualToString:@"Quit"]) {
        NSData *jsonData =
            [groupNotification.data dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization
            JSONObjectWithData:jsonData
                       options:NSJSONReadingMutableContainers
                         error:nil];
        NSDictionary *data =
            [dictionary[@"data"] isKindOfClass:[NSDictionary class]]
                ? dictionary[@"data"]
                : nil;
        NSString *nickName =
            [data[@"operatorNickname"] isKindOfClass:[NSString class]]
                ? data[@"operatorNickname"]
                : nil;
        if ([nickName isEqualToString:[RCIM sharedRCIM].currentUserInfo.name]) {
          [[RCIMClient sharedRCIMClient]
              removeConversation:model.conversationType
                        targetId:model.targetId];
          [self refreshConversationTableViewIfNeeded];
        }
      }
    }
  }
  return dataSource;
}
//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
  //可以从数据库删除数据
  RCConversationModel *model = self.conversationListDataSource[indexPath.row];
  [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM
                                           targetId:model.targetId];
  [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
  [self.conversationListTableView reloadData];
}
//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 67.0f;
}
//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:
                                      (NSIndexPath *)indexPath {
  RCConversationModel *model = self.conversationListDataSource[indexPath.row];
  __block NSString *userName = nil;
  __block NSString *portraitUri = nil;
  RCContactNotificationMessage *_contactNotificationMsg = nil;
  __weak RCDChatListViewController *weakSelf = self;
  //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
  if (nil == model.extend) {
    // Not finished yet, To Be Continue...
    if (model.conversationType == ConversationType_SYSTEM &&
        [model.lastestMessage
            isMemberOfClass:[RCContactNotificationMessage class]]) {
      _contactNotificationMsg =
          (RCContactNotificationMessage *)model.lastestMessage;
      if (_contactNotificationMsg.sourceUserId == nil) {
        RCDChatListCell *cell =
            [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@""];
        cell.lblDetail.text = @"好友请求";
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                      placeholderImage:[UIImage imageNamed:@"system_notice"]];
        return cell;
      }
      NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]
          objectForKey:_contactNotificationMsg.sourceUserId];
      if (_cache_userinfo) {
        userName = _cache_userinfo[@"username"];
        portraitUri = _cache_userinfo[@"portraitUri"];
      } else {
        NSDictionary *emptyDic = @{};
        [[NSUserDefaults standardUserDefaults]
            setObject:emptyDic
               forKey:_contactNotificationMsg.sourceUserId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [RCDHTTPTOOL
            getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                     completion:^(RCUserInfo *user) {
                       if (user == nil) {
                         return;
                       }
                       RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                       rcduserinfo_.name = user.name;
                       rcduserinfo_.userId = user.userId;
                       rcduserinfo_.portraitUri = user.portraitUri;
                       model.extend = rcduserinfo_;
                       // local cache for userInfo
                       NSDictionary *userinfoDic = @{
                         @"username" : rcduserinfo_.name,
                         @"portraitUri" : rcduserinfo_.portraitUri
                       };
                       [[NSUserDefaults standardUserDefaults]
                           setObject:userinfoDic
                              forKey:_contactNotificationMsg.sourceUserId];
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       [weakSelf.conversationListTableView
                           reloadRowsAtIndexPaths:@[ indexPath ]
                                 withRowAnimation:
                                     UITableViewRowAnimationAutomatic];
                     }];
      }
    }
  } else {
    RCDUserInfo *user = (RCDUserInfo *)model.extend;
    userName = user.name;
    portraitUri = user.portraitUri;
  }
  RCDChatListCell *cell =[[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
  NSString *operation = _contactNotificationMsg.operation;
  NSString *operationContent;
  if ([operation isEqualToString:@"Request"]) {
    operationContent = [NSString stringWithFormat:@"来自%@的好友请求", userName];
  } else if ([operation isEqualToString:@"AcceptResponse"]) {
    operationContent = [NSString stringWithFormat:@"%@通过了你的好友请求", userName];
  }
  cell.lblDetail.text = operationContent;
  [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                placeholderImage:[UIImage imageNamed:@"system_notice"]];
  cell.labelTime.text = [RCKitUtility ConvertMessageTime:model.sentTime/1000];
  cell.model = model;
  return cell;
}
//*********************插入自定义Cell*********************//
#pragma mark - 收到消息监听
- (void)didReceiveMessageNotification:(NSNotification *)notification {
  __weak typeof(&*self) blockSelf_ = self;
  //处理好友请求
  RCMessage *message = notification.object;
  if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
    if (message.conversationType != ConversationType_SYSTEM) {
      NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
      @throw [[NSException alloc]
          initWithName:@"error"
                reason:@"好友消息要发系统消息！！！"
              userInfo:nil];
#endif
    }
    RCContactNotificationMessage *_contactNotificationMsg =
        (RCContactNotificationMessage *)message.content;
    if (_contactNotificationMsg.sourceUserId == nil ||
        _contactNotificationMsg.sourceUserId.length == 0) {
      return;
    }
    //该接口需要替换为从消息体获取好友请求的用户信息
    [RCDHTTPTOOL
        getUserInfoByUserID:_contactNotificationMsg.sourceUserId
                 completion:^(RCUserInfo *user) {
                   RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
                   rcduserinfo_.name = user.name;
                   rcduserinfo_.userId = user.userId;
                   rcduserinfo_.portraitUri = user.portraitUri;
                   RCConversationModel *customModel = [RCConversationModel new];
                   customModel.conversationModelType =
                       RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
                   customModel.extend = rcduserinfo_;
                   customModel.conversationType = message.conversationType;
                   customModel.targetId = message.targetId;
                   customModel.sentTime = message.sentTime;
                   customModel.receivedTime = message.receivedTime;
                   customModel.senderUserId = message.senderUserId;
                   customModel.lastestMessage = _contactNotificationMsg;
                   //[_myDataSource insertObject:customModel atIndex:0];
                   // local cache for userInfo
                   NSDictionary *userinfoDic = @{
                     @"username" : rcduserinfo_.name,
                     @"portraitUri" : rcduserinfo_.portraitUri
                   };
                   [[NSUserDefaults standardUserDefaults]
                       setObject:userinfoDic
                          forKey:_contactNotificationMsg.sourceUserId];
                   [[NSUserDefaults standardUserDefaults] synchronize];
                   dispatch_async(dispatch_get_main_queue(), ^{
                     //调用父类刷新未读消息数
                     [blockSelf_
                         refreshConversationTableViewWithConversationModel:
                             customModel];
                     [self notifyUpdateUnreadMessageCount];
                     //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                     //原因请查看super didReceiveMessageNotification的注释。
                     NSNumber *left =
                         [notification.userInfo objectForKey:@"left"];
                     if (0 == left.integerValue) {
                       [super refreshConversationTableViewIfNeeded];
                     }
                   });
                 }];
  } else {
    //调用父类刷新未读消息数
    [super didReceiveMessageNotification:notification];
  }
}
- (void)didTapCellPortrait:(RCConversationModel *)model {
  if (model.conversationModelType ==
      RC_CONVERSATION_MODEL_TYPE_PUBLIC_SERVICE) {
    RCDChatViewController *_conversationVC =
        [[RCDChatViewController alloc] init];
    _conversationVC.conversationType = model.conversationType;
    _conversationVC.targetId = model.targetId;
    _conversationVC.csInfo.nickName = model.conversationTitle;
    _conversationVC.title = model.conversationTitle;
    _conversationVC.conversation = model;
    _conversationVC.unReadMessage = model.unreadMessageCount;
    [self.navigationController pushViewController:_conversationVC animated:YES];
  }
  if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
    RCDChatViewController *_conversationVC =
        [[RCDChatViewController alloc] init];
    _conversationVC.conversationType = model.conversationType;
    _conversationVC.targetId = model.targetId;
    _conversationVC.csInfo.nickName = model.conversationTitle;
    _conversationVC.title = model.conversationTitle;
    _conversationVC.conversation = model;
    _conversationVC.unReadMessage = model.unreadMessageCount;
    _conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
    _conversationVC.enableUnreadMessageIcon = YES;
    if (model.conversationType == ConversationType_SYSTEM) {
      _conversationVC.csInfo.nickName = @"系统消息";
      _conversationVC.title = @"系统消息";
    }
    if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
        RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
      addressBookVC.needSyncFriendList = YES;
      [self.navigationController pushViewController:addressBookVC animated:YES];
      return;
    }
    //如果是单聊，不显示发送方昵称
    if (model.conversationType == ConversationType_PRIVATE) {
      _conversationVC.displayUserNameInCell = NO;
    }
    [self.navigationController pushViewController:_conversationVC animated:YES];
  }
  //聚合会话类型，此处自定设置。
  if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
    RCDChatListViewController *temp = [[RCDChatListViewController alloc] init];
    NSArray *array = [NSArray
        arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
    [temp setDisplayConversationTypes:array];
    [temp setCollectionConversationType:nil];
    temp.isEnteredToCollectionViewController = YES;
    [self.navigationController pushViewController:temp animated:YES];
  }
  //自定义会话类型
  if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
    //        RCConversationModel *model =
    //        self.conversationListDataSource[indexPath.row];
    if ([model.objectName isEqualToString:@"RC:ContactNtf"]) {
        RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
      [self.navigationController pushViewController:addressBookVC animated:YES];
    }
  }
}
/*
//会话有新消息通知的时候显示数字提醒，设置为NO,不显示数字只显示红点
-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model=
  self.conversationListDataSource[indexPath.row];
    if (model.conversationType == ConversationType_PRIVATE) {
        ((RCConversationCell *)cell).isShowNotificationNumber = NO;
    }
}
 */
- (void)notifyUpdateUnreadMessageCount {
  [self updateBadgeValueForTabBarItem];
}
- (void)receiveNeedRefreshNotification:(NSNotification *)status {
  __weak typeof(&*self) __blockSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (__blockSelf.displayConversationTypeArray.count == 1 &&
        [self.displayConversationTypeArray[0] integerValue] ==
            ConversationType_DISCUSSION) {
      [__blockSelf refreshConversationTableViewIfNeeded];
    }
  });
}
-(void)checkVersion{
  [RCDHTTPTOOL getVersioncomplete:^(NSDictionary *versionInfo) {
    if (versionInfo) {
      NSString *isNeedUpdate = [versionInfo objectForKey:@"isNeedUpdate"];
      NSString *finalURL;
      if ([isNeedUpdate isEqualToString:@"YES"]) {
        __weak typeof(self) __weakSelf = self;
        [__weakSelf.tabBarController.tabBar showBadgeOnItemIndex:3];
        //获取系统当前的时间戳
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now = [dat timeIntervalSince1970] * 1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", now];
        //为html增加随机数，避免缓存。
        NSString *applist = [versionInfo objectForKey:@"applist"];
        applist = [NSString stringWithFormat:@"%@?%@",applist,timeString];
        finalURL = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",applist];
      }
      [[NSUserDefaults standardUserDefaults] setObject:finalURL forKey:@"applistURL"];
      [[NSUserDefaults standardUserDefaults] setObject:isNeedUpdate forKey:@"isNeedUpdate"];
      [[NSUserDefaults standardUserDefaults] synchronize];
    }
  }];
}
- (void)pushToCreateDiscussion:(id)sender {
  RCDContactSelectedTableViewController * contactSelectedVC= [[RCDContactSelectedTableViewController alloc]init];
  contactSelectedVC.forCreatingDiscussionGroup = YES;
  contactSelectedVC.isAllowsMultipleSelection = YES;
  contactSelectedVC.titleStr = @"选择联系人";
  [self.navigationController pushViewController:contactSelectedVC animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
  NSIndexPath *indexPath = [self.conversationListTableView indexPathForRowAtPoint:scrollView.contentOffset];
  self.index = indexPath.row;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  //恢复conversationListTableView的自动回滚功能。
  self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void) GotoNextCoversation{
  NSUInteger i;
  //设置contentInset是为了滚动到底部的时候，避免conversationListTableView自动回滚。
  self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, self.conversationListTableView.frame.size.height, 0);
  for (i = self.index + 1; i < self.conversationListDataSource.count; i++) {
    RCConversationModel *model = self.conversationListDataSource[i];
    if (model.unreadMessageCount > 0) {
      NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        self.index = i;
        [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                              atScrollPosition:UITableViewScrollPositionTop animated:YES];
        break;
    }
  }
  //滚动到起始位置
  if (i >= self.conversationListDataSource.count) {
//    self.conversationListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    for (i = 0; i < self.conversationListDataSource.count; i++) {
      RCConversationModel *model = self.conversationListDataSource[i];
      if (model.unreadMessageCount > 0) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
          self.index = i;
          [self.conversationListTableView scrollToRowAtIndexPath:scrollIndexPath
                                                atScrollPosition:UITableViewScrollPositionTop animated:YES];
          break;
      }
    }
  }
}
- (void)updateForSharedMessageInsertSuccess{
  [self refreshConversationTableViewIfNeeded];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  RCDSearchViewController *searchViewController = [[RCDSearchViewController alloc] init];
  self.searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
  searchViewController.delegate = self;
  [self.navigationController.view addSubview:self.searchNavigationController.view];
}
- (void)onSearchCancelClick{
    [self.searchNavigationController.view removeFromSuperview];
    [self.searchNavigationController removeFromParentViewController];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refreshConversationTableViewIfNeeded];
}
-(void)refreshCell:(NSNotification *)notify{
  /*
  NSString *row = [notify object];
  RCConversationModel *model = [self.conversationListDataSource objectAtIndex:[row intValue]];
  model.unreadMessageCount = 0;
  NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
  });
   */
  [self refreshConversationTableViewIfNeeded];
}
@end
