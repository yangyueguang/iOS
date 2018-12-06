
//
//  RCLocationPickerViewController.m
//  iOS-IMKit
//
//  Created by YangZigang on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//
#import "RealTimeLocationViewController.h"
#import "MBProgressHUD.h"
#import "RCAnnotationView.h"
#import <MapKit/MapKit.h>
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import <UIKit/UIKit.h>
@protocol HeadCollectionTouchDelegate <NSObject>
- (void)onUserSelected:(RCUserInfo *)user atIndex:(NSUInteger)index;
@optional
- (BOOL)quitButtonPressed;
- (BOOL)backButtonPressed;
@end
@interface HeadCollectionView : UIView
@property(nonatomic, strong) UIButton *quitButton;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, assign) RCUserAvatarStyle avatarStyle;
@property(nonatomic, weak) id<HeadCollectionTouchDelegate> touchDelegate;
- (instancetype)initWithFrame:(CGRect)frame
                 participants:(NSArray *)userIds
                touchDelegate:touchDelegate;
- (instancetype)initWithFrame:(CGRect)frame
                 participants:(NSArray *)userIds
                touchDelegate:touchDelegate
              userAvatarStyle:(RCUserAvatarStyle)avatarStyle;
#pragma mark user source processing
- (BOOL)participantJoin:(NSString *)userId;
- (BOOL)participantQuit:(NSString *)userId;
- (NSArray *)getParticipantsUserInfo;
@end
@interface HeadCollectionView ()
@property(nonatomic) CGRect headViewRect;
@property(nonatomic) CGFloat headViewSize;
@property(nonatomic) CGFloat headViewSpace;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) NSMutableArray *headsView;
@property(nonatomic, strong) NSMutableArray *rcUserInfos;
@end
@implementation HeadCollectionView
#pragma mark init
- (instancetype)initWithFrame:(CGRect)frame participants:(NSArray *)userIds touchDelegate:touchDelegate {
    self = [[HeadCollectionView alloc] initWithFrame:frame participants:userIds touchDelegate:touchDelegate userAvatarStyle:RC_USER_AVATAR_CYCLE];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame participants:(NSArray *)userIds touchDelegate:touchDelegate userAvatarStyle:(RCUserAvatarStyle)avatarStyle {
    self = [super initWithFrame:frame];
    if (self) {
        self.headsView = [[NSMutableArray alloc] init];
        self.rcUserInfos = [[NSMutableArray alloc] init];
        self.touchDelegate = touchDelegate;
        self.avatarStyle = avatarStyle;
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
        self.headViewSize = 42;
        self.headViewSpace = 8;
        self.headViewRect = CGRectMake(8 + 26 + 8, 20 + 8, frame.size.width - (8 + 26 + 8) * 2,self.headViewSize);
        UIButton *quitButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 41.5, 26, 26)];
        [quitButton setImage:[UIImage imageNamed:@"quit_location_share"] forState:UIControlStateNormal];
        [quitButton addTarget:self action:@selector(onQuitButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:quitButton];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.headViewRect];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 8 - 26, 41.5, 26,26)];
        [backButton setImage:[UIImage imageNamed:@"back_to_conversation"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backButton];
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headViewRect.origin.x,20 + self.headViewSize + 12,self.headViewRect.size.width, 13)];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.font = [UIFont boldSystemFontOfSize:13];
        [self showUserShareInfo];
        [self addSubview:self.tipLabel];
        for (NSString *userId in userIds) {
            [self addUser:userId showChange:NO];
        }
    }
    return self;
}
#pragma mark user source processing
- (BOOL)participantJoin:(NSString *)userId {
    return [self addUser:userId showChange:YES];
}
- (BOOL)participantQuit:(NSString *)userId {
    return [self removeUser:userId showChange:YES];
}
- (BOOL)addUser:(NSString *)userId showChange:(BOOL)show {
    if (userId && [self getUserIndex:userId] < 0) {
        if ([RCIM sharedRCIM].userInfoDataSource && [[RCIM sharedRCIM].userInfoDataSource
             respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
            [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
                 if (!userInfo) {
                     userInfo = [[RCUserInfo alloc]initWithUserId:userId name:[NSString stringWithFormat:@"user<%@>",userId] portrait:nil];
                 }
                 [self.rcUserInfos addObject:userInfo];
                 [self addHeadViewUser:userInfo];
                 if (show) {
                     [self showUserChangeInfo:[NSString stringWithFormat:@"%@加入...",userInfo.name]];
                 } else {
                     self.tipLabel.text = [NSString stringWithFormat:@"%lu人在共享位置",(unsigned long)self.rcUserInfos.count];
                 }
             }];
        } else {
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userId portrait:nil];
            [self.rcUserInfos addObject:userInfo];
            [self addHeadViewUser:userInfo];
            if (show) {
                [self showUserChangeInfo:[NSString stringWithFormat:@"%@加入...",userInfo.name]];
            } else {
                self.tipLabel.text = [NSString stringWithFormat:@"%lu人在共享位置",(unsigned long)self.rcUserInfos.count];
            }
        }
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)removeUser:(NSString *)userId showChange:(BOOL)show {
    if (userId) {
        NSInteger index = [self getUserIndex:userId];
        if (index >= 0) {
            RCUserInfo *userInfo = self.rcUserInfos[index];
            [self.rcUserInfos removeObjectAtIndex:index];
            [self removeHeadViewUser:index];
            if (show) {
                [self showUserChangeInfo:[NSString stringWithFormat:@"%@退出...",userInfo.name]];
            } else {
                self.tipLabel.text = [NSString stringWithFormat:@"%lu人在共享位置",(unsigned long)self.rcUserInfos.count];
            }
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}
- (void)showUserChangeInfo:(NSString *)changInfo {
    self.tipLabel.text = changInfo;
    self.tipLabel.textColor = [UIColor greenColor];
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(showUserShareInfo) userInfo:nil repeats:NO];
}
- (void)showUserShareInfo {
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.text = [NSString stringWithFormat:@"%lu人在共享位置",(unsigned long)self.rcUserInfos.count];
}
- (NSArray *)getParticipantsUserInfo {
    return [self.rcUserInfos copy];
}
- (void)addHeadViewUser:(RCUserInfo *)user{
{
        CGFloat scrollViewWidth = [self getScrollViewWidth];
        UIImageView *userHead = [[UIImageView alloc] init];
        [userHead sd_setImageWithURL:[NSURL URLWithString:user.portraitUri]];
        [userHead setFrame:CGRectMake(scrollViewWidth - self.headViewSize, 0,self.headViewSize, self.headViewSize)];
        if (self.avatarStyle == RC_USER_AVATAR_CYCLE) {
            userHead.layer.cornerRadius = self.headViewSize / 2;
            userHead.layer.masksToBounds = YES;
        }
        userHead.layer.borderWidth = 1.0f;
        userHead.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onUserSelected:)];
        [userHead addGestureRecognizer:tap];
        userHead.userInteractionEnabled = YES;
        [self.headsView addObject:userHead];
        [self.scrollView addSubview:userHead];
        if (scrollViewWidth < self.headViewRect.size.width) {
            [self.scrollView setFrame:CGRectMake((self.frame.size.width - scrollViewWidth) / 2,self.headViewRect.origin.y, scrollViewWidth,self.headViewRect.size.height)];
        } else {
            [self.scrollView setFrame:self.headViewRect];
        }
        [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, self.scrollView.frame.size.height)];
    }
}
- (void)removeHeadViewUser:(NSUInteger)index {
    CGFloat scrollViewWidth = [self getScrollViewWidth];
    UIImageView *removeUserHead = [self.headsView objectAtIndex:index];
    for (NSUInteger i = index + 1; i < [self.headsView count]; i++) {
        UIImageView *userHead = self.headsView[i];
        [userHead setFrame:CGRectMake(userHead.frame.origin.x - self.headViewSize - self.headViewSpace,0, self.headViewSize, self.headViewSize)];
    }
    [self.headsView removeObject:removeUserHead];
    [removeUserHead removeFromSuperview];
    if (scrollViewWidth < self.headViewRect.size.width) {
        [self.scrollView setFrame:CGRectMake((self.frame.size.width - scrollViewWidth) / 2,self.headViewRect.origin.y, scrollViewWidth,self.headViewRect.size.height)];
    } else {
        [self.scrollView setFrame:self.headViewRect];
    }
    [self.scrollView setContentSize:CGSizeMake(scrollViewWidth,self.scrollView.frame.size.height)];
}
- (void)onUserSelected:(UITapGestureRecognizer *)tap {
    UIImageView *selectUserHead = (UIImageView *)tap.view;
    NSUInteger index = [self.headsView indexOfObject:selectUserHead];
    RCUserInfo *user = self.rcUserInfos[index];
    if (self.touchDelegate) {
        [self.touchDelegate onUserSelected:user atIndex:index];
    }
}
- (NSInteger)getUserIndex:(NSString *)userId {
    for (NSUInteger index = 0; index < self.rcUserInfos.count; index++) {
        RCUserInfo *user = self.rcUserInfos[index];
        if ([userId isEqualToString:user.userId]) {
            return index;
        }
    }
    return -1;
}
- (CGFloat)getScrollViewWidth {
    if (self.rcUserInfos && self.rcUserInfos.count > 0) {
        return self.rcUserInfos.count * self.headViewSize +
        (self.rcUserInfos.count - 1) * self.headViewSpace;
    } else {
        return 0.0f;
    }
}
- (void)onQuitButtonPressed:(id)sender {
    if (self.touchDelegate) {
        [self.touchDelegate quitButtonPressed];
    }
}
- (void)onBackButtonPressed:(id)sender {
    if (self.touchDelegate) {
        [self.touchDelegate backButtonPressed];
    }
}
- (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png", name];
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    return image;
}
@end
@interface RealTimeLocationViewController () <RCRealTimeLocationObserver, MKMapViewDelegate, HeadCollectionTouchDelegate,UIActionSheetDelegate>{
    MBProgressHUD *hud;
}
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) UIView *headBackgroundView;
@property(nonatomic, strong) NSMutableDictionary *userAnnotationDic;
@property(nonatomic, assign) MKCoordinateSpan theSpan;
@property(nonatomic, assign) MKCoordinateRegion theRegion;
@property(nonatomic, assign) BOOL isFristTimeToLoad;
@property(nonatomic, strong) HeadCollectionView *headCollectionView;
@end
@implementation RealTimeLocationViewController
- (instancetype)init {
  if (self = [super init]) {
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  _isFristTimeToLoad = YES;
  self.userAnnotationDic = [[NSMutableDictionary alloc] init];
  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
  [self.mapView setMapType:MKMapTypeStandard];
  self.mapView.showsUserLocation = YES;
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = NO;
  [self.view addSubview:self.mapView];
  self.headCollectionView = [[HeadCollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 95) participants:[self.realTimeLocationProxy getParticipants] touchDelegate:self];
  [self.view addSubview:self.headCollectionView];
  self.headCollectionView.touchDelegate = self;
  UIImageView *gpsImg = [[UIImageView alloc]initWithFrame:CGRectMake(18,[UIScreen mainScreen].bounds.size.height - 80,50, 50)];
  gpsImg.image = [UIImage imageNamed:@"gps.png"];
  [self.view addSubview:gpsImg];
  gpsImg.userInteractionEnabled = YES;
  UITapGestureRecognizer *gpsImgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGpsImgEvent:)];
  [gpsImg addGestureRecognizer:gpsImgTap];
  CLLocation *currentLocation = [self.realTimeLocationProxy getLocation:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
  if (currentLocation) {
    __weak RealTimeLocationViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf onReceiveLocation:currentLocation type:RCRealTimeLocationTypeWGS84 fromUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId];
    });
  }
  hud = [MBProgressHUD showHUDAddedTo:self.mapView animated:YES];
  hud.color = [UIColor greenColor];
  hud.labelText = @"定位中...";
  [hud show:YES];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.realTimeLocationProxy addRealTimeLocationObserver:self];
  CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
  if (status == kCLAuthorizationStatusDenied) {
    [hud hide:YES];
      [self showAlerWithtitle:@"无法访问" message:@"没有权限访问位置信息，请从设置-隐私-定位服务中打开位置访问权限" style:UIAlertControllerStyleAlert ac1:^UIAlertAction *{
          return [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
      } ac2:nil ac3:nil completion:nil];
  }
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.realTimeLocationProxy removeRealTimeLocationObserver:self];
}
- (void)tapGpsImgEvent:(UIGestureRecognizer *)gestureRecognizer {
  [self onSelectUserLocationWithUserId:[RCIM sharedRCIM].currentUserInfo.userId];
}
- (void)onUserSelected:(RCUserInfo *)user atIndex:(NSUInteger)index {
  [self onSelectUserLocationWithUserId:user.userId];
}
- (BOOL)quitButtonPressed {
    [self showAlerWithtitle:@"是否结束位置共享？" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"结束" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __weak typeof(&*self) __weakself = self;
            [self dismissViewControllerAnimated:YES completion:^{
                 [__weakself.realTimeLocationProxy quitRealTimeLocation];
             }];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    } ac3:nil completion:nil];
  return YES;
}
- (BOOL)backButtonPressed {
  [self dismissViewControllerAnimated:YES completion:^{ }];
  return YES;
}
- (void)setRealTimeLocationProxy:(id<RCRealTimeLocationProxy>)realTimeLocationProxy {
  _realTimeLocationProxy = realTimeLocationProxy;
  [_realTimeLocationProxy addRealTimeLocationObserver:self];
}
#pragma mark - RCRealTimeLocationObserver
- (void)onRealTimeLocationStatusChange:(RCRealTimeLocationStatus)status {
  if ([self.realTimeLocationProxy getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING ||
      [self.realTimeLocationProxy getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
    [self dismissViewControllerAnimated:YES completion:^{}];
  }
}
- (void)onReceiveLocation:(CLLocation *)location fromUserId:(NSString *)userId {
  __weak typeof(&*self) __weakself = self;
  if (self.isFristTimeToLoad) {
    if (-90.0f <= location.coordinate.latitude && location.coordinate.latitude <= 90.0f &&
        -180.0f <= location.coordinate.longitude && location.coordinate.longitude <= 180.0f) {
      CLLocationCoordinate2D center;
      center.latitude = location.coordinate.latitude;
      center.longitude = location.coordinate.longitude;
      MKCoordinateSpan span;
      span.latitudeDelta = 0.1;
      span.longitudeDelta = 0.1;
      MKCoordinateRegion region = {center, span};
      self.theSpan = span;
      self.theRegion = region;
      [self.mapView setCenterCoordinate:center animated:YES];
      [self.mapView setRegion:self.theRegion];
    }
  }
  self.isFristTimeToLoad = NO;
  CLLocation *cll = [self.realTimeLocationProxy getLocation:userId];
  if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [hud hide:YES];
    });
  }
  RCAnnotation *annotaton = [self.userAnnotationDic objectForKey:userId];
  if (annotaton == nil) {
    RCLocationView *annotatonView = [[RCLocationView alloc] init];
    // annotatonView.imageUrl = [UIImage imageNamed:@"apple.jpg"];
    annotatonView.userId = userId;
    annotatonView.coordinate = [RCLocationConvert wgs84ToGcj02:cll.coordinate];
    RCAnnotation *ann = [[RCAnnotation alloc] initWithThumbnail:annotatonView];
    [self.mapView addAnnotation:ann];
    [self.userAnnotationDic setObject:ann forKey:userId];
    if ([RCIM sharedRCIM].userInfoDataSource &&
        [[RCIM sharedRCIM].userInfoDataSource respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
      [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
           if (!userInfo) {
             userInfo = [[RCUserInfo alloc]initWithUserId:userId name:[NSString stringWithFormat:@"user<%@>",userId] portrait:nil];
           }
           dispatch_async(dispatch_get_main_queue(), ^{
             RCAnnotation *annotaton = [__weakself.userAnnotationDic objectForKey:userInfo.userId];
             annotatonView.isMyLocation = NO;
             if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
               annotatonView.isMyLocation = YES;
             }
             annotaton.thumbnail.imageurl = userInfo.portraitUri;
             [annotaton updateThumbnail:annotaton.thumbnail animated:YES];
           });
         }];
    }
  } else {
    //            if ([RCIM sharedRCIM].userInfoDataSource && [[RCIM
    //            sharedRCIM].userInfoDataSource
    //            respondsToSelector:@selector(getUserInfoWithUserId:completion:)])
    //            {
    //                [[RCIM sharedRCIM].userInfoDataSource
    //                getUserInfoWithUserId:userId completion:^(RCUserInfo
    //                *userInfo) {
    //                    if (!userInfo) {
    //                        userInfo = [[RCUserInfo alloc]
    //                        initWithUserId:userId name:[NSString
    //                        stringWithFormat:@"user<%@>", userId]
    //                        portrait:nil];
    //                    }
    dispatch_async(dispatch_get_main_queue(), ^{
      annotaton.coordinate = [RCLocationConvert wgs84ToGcj02:cll.coordinate];
      annotaton.thumbnail.coordinate = [RCLocationConvert wgs84ToGcj02:cll.coordinate];
      annotaton.thumbnail.isMyLocation = NO;
      if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        annotaton.thumbnail.isMyLocation = YES;
      }
      // annotaton.thumbnail.imageurl=userInfo.portraitUri;
      [__weakself.mapView removeAnnotation:annotaton];
      [__weakself.mapView addAnnotation:annotaton];
      [annotaton updateThumbnail:annotaton.thumbnail animated:YES];
    });
    //                    }];
    //            }
  }
}
- (void)onParticipantsJoin:(NSString *)userId {
  RCAnnotation *annotaton = [self.userAnnotationDic objectForKey:userId];
  __weak typeof(&*self) __weakself = self;
  if (annotaton == nil) {
    RCLocationView *annotatonView = [[RCLocationView alloc] init];
    annotatonView.userId = userId;
    RCAnnotation *ann = [[RCAnnotation alloc] initWithThumbnail:annotatonView];
    annotatonView.isMyLocation = NO;
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      annotatonView.isMyLocation = YES;
    }
    [self.mapView addAnnotation:ann];
    [self.userAnnotationDic setObject:ann forKey:userId];
    if ([RCIM sharedRCIM].userInfoDataSource &&
        [[RCIM sharedRCIM].userInfoDataSource respondsToSelector:@selector(getUserInfoWithUserId:completion:)]) {
      [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
           if (!userInfo) {
             userInfo = [[RCUserInfo alloc]initWithUserId:userId name:[NSString stringWithFormat:@"user<%@>",userId] portrait:nil];
           }
           dispatch_async(dispatch_get_main_queue(), ^{
             RCAnnotation *annotaton = [__weakself.userAnnotationDic objectForKey:userInfo.userId];
             annotaton.thumbnail.imageurl = userInfo.portraitUri;
             [annotaton updateThumbnail:annotaton.thumbnail animated:YES];
           });
         }];
    }
  }
  if (self.headCollectionView) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [__weakself.headCollectionView participantJoin:userId];
    });
  }
}
- (void)onParticipantsQuit:(NSString *)userId {
  __weak typeof(&*self) __weakself = self;
  if (self.headCollectionView) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [__weakself.headCollectionView participantQuit:userId];
    });
  }
  RCAnnotation *annotaton = [self.userAnnotationDic objectForKey:userId];
  if (annotaton) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [__weakself.userAnnotationDic removeObjectForKey:userId];
      [__weakself.mapView removeAnnotation:annotaton];
    });
  }
  if ([self.realTimeLocationProxy getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING ||
      [self.realTimeLocationProxy getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [__weakself dismissViewControllerAnimated:YES completion:^{}];
    });
  }
}
- (void)onFailUpdateLocation:(NSString *)description {
  dispatch_async(dispatch_get_main_queue(), ^{
    [hud hide:YES];
  });
}
//选择用户时以用户坐标为中心
- (void)onSelectUserLocationWithUserId:(NSString *)userId {
  __weak typeof(&*self) __weakself = self;
  RCAnnotation *annotaton = [self.userAnnotationDic objectForKey:userId];
  if (annotaton) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [__weakself.mapView removeAnnotation:annotaton];
      [__weakself.mapView addAnnotation:annotaton];
      [__weakself.mapView setCenterCoordinate:annotaton.coordinate animated:YES];
      [__weakself.mapView selectAnnotation:annotaton animated:YES];
    });
  }
}
#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  if ([view conformsToProtocol:@protocol(RCAnnotationViewProtocol)]) {
    [((NSObject<RCAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
  }
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  if ([view conformsToProtocol:@protocol(RCAnnotationViewProtocol)]) {
    [((NSObject<RCAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
  }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation conformsToProtocol:@protocol(RCAnnotationProtocol)]) {
    MKAnnotationView *view = [((NSObject<RCAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    return view;
  }
  return nil;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  self.theRegion = mapView.region;
}
- (void)dealloc {
  //  [self.realTimeLocationProxy removeRealTimeLocationObserver:self];
  NSLog(@"dealloc");
}
@end
