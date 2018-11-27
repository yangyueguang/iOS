//
//  RCDMeTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 14/11/28.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//
#import "RCDMeTableViewController.h"
#import "AFHttpTool.h"
#import "RCDChatViewController.h"
#import "RCDServiceViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDSettingsTableViewController.h"
#import "RCDMeInfoTableViewController.h"
#import "RCDAboutRongCloudTableViewController.h"
#import "RCDBaseSettingTableViewCell.h"
/* RedPacket_FTR */
#import <JrmfWalletKit/JrmfWalletKit.h>
#define SERVICE_ID @"KEFU146001495753714"
#define SERVICE_ID_XIAONENG1 @"kf_4029_1483495902343"
#define SERVICE_ID_XIAONENG2 @"op_1000_1483495280515"
#import <RongIMKit/RongIMKit.h>
#import "RCDBaseSettingTableViewCell.h"
@interface RCDMeCell : RCDBaseSettingTableViewCell
- (id)initWithImageName:(NSString *)imageName labelName:(NSString *)labelName;
- (void)setCellWithImageName:(NSString *)imageName labelName:(NSString *)labelName;
- (void)addRedpointImageView;
@end
@interface RCDMeDetailsCell : RCDBaseSettingTableViewCell
@end
@implementation RCDMeCell
- (void)setCellWithImageName:(NSString *)imageName labelName:(NSString *)labelName {
    [self setImageView:self.leftImageView ImageStr:imageName imageSize:CGSizeMake(18, 18) LeftOrRight:0];
    self.leftLabel.text = labelName;
}
- (id)initWithImageName:(NSString *)imageName labelName:(NSString *)labelName {
    if (self) {
        self = [super initWithLeftImageStr:imageName leftImageSize:CGSizeMake(18, 18) rightImaeStr:nil rightImageSize:CGSizeZero];
        self.leftLabel.text = labelName;
        // [self setCellStyle:DefaultStyle];
    }
    return self;
}
- (void)addRedpointImageView {
    if (self.leftLabelConstraints != nil) {
        [self.contentView removeConstraints:self.leftLabelConstraints];
    }
    UIImageView *redpointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpoint"]];
    redpointImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:redpointImageView];
    UILabel *leftLabel =  self.leftLabel;
    UIImageView *leftImageView = self.leftImageView;
    UIImageView *rightArrow = self.rightArrow;
    NSDictionary *views = NSDictionaryOfVariableBindings(leftLabel,redpointImageView,leftImageView,rightArrow);
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|-10-[leftImageView(width)]-8-[leftLabel]-10-[redpointImageView(12)]-(>=0)-[rightArrow(8)]-10-|"
                     options:0
                     metrics:@{@"width":@(self.leftImageView.frame.size.width)}
                     views:views]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[redpointImageView(12)]"
                     options:0
                     metrics:nil
                     views:views]];
    [self.contentView
     addConstraint:[NSLayoutConstraint constraintWithItem:redpointImageView
                                                attribute:NSLayoutAttributeCenterY
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.contentView
                                                attribute:NSLayoutAttributeCenterY
                                               multiplier:1
                                                 constant:0]];
}
@end
@implementation RCDMeDetailsCell
-(id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *portraitUrl = [defaults stringForKey:@"userPortraitUri"];
        if ([portraitUrl isEqualToString:@""]) {
            portraitUrl = [FreedomTools defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
        }
        self = [[RCDMeDetailsCell alloc] initWithLeftImageStr:portraitUrl leftImageSize:CGSizeMake(65, 65) rightImaeStr:nil rightImageSize:CGSizeZero];
        self.leftImageCornerRadius = 5.f;
        self.leftLabel.text = [defaults stringForKey:@"userNickName"];
    }
    return self;
}
@end
@interface RCDMeTableViewController ()
@property(nonatomic) BOOL hasNewVersion;
@property(nonatomic) NSString *versionUrl;
@property(nonatomic, strong) NSString *versionString;
@property(nonatomic, strong) NSURLConnection *connection;
@property(nonatomic, strong) NSMutableData *receiveData;
@end
@implementation RCDMeTableViewController {
  UIImage *userPortrait;
  BOOL isSyncCurrentUserInfo;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationController.navigationBar.translucent = NO;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f6];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tabBarController.navigationItem.rightBarButtonItem = nil;
  self.tabBarController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserPortrait:) name:@"setCurrentUserPortrait" object:nil];
  isSyncCurrentUserInfo = NO;
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tabBarController.navigationItem.title = @"我";
  self.tabBarController.navigationItem.rightBarButtonItems = nil;
  [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger rows = 0;
  switch (section) {
    case 0:rows = 1;break;
    case 1:
    /* RedPacket_FTR */ //添加了红包，row+=1；
      rows = 2;break;
    case 2:rows = 4;break;
    default:break;
  }
  return rows;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDMeCell";
  RCDMeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  static NSString *detailsCellWithIdentifier = @"RCDMeDetailsCell";
  RCDMeDetailsCell *detailsCell = [self.tableView dequeueReusableCellWithIdentifier:detailsCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDMeCell alloc] init];
  }
  if (detailsCell == nil) {
    detailsCell = [[RCDMeDetailsCell alloc] init];
  }
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          return detailsCell;
        }break;
        default:break;
      }
    }break;
    case 1: {
        switch (indexPath.row) {
            case 0: {
                [cell setCellWithImageName:@"setting_up" labelName:@"帐号设置"];
            }break;
          /* RedPacket_FTR */ //wallet cell
            case 1: {
                [cell setCellWithImageName:@"wallet" labelName:@"我的钱包"];
            }
            default:break;
        }
      return cell;
    }break;
    case 2: {
      switch (indexPath.row) {
        case 0:{
          [cell setCellWithImageName:@"sevre_inactive" labelName:@"意见反馈"];
          return cell;
        }break;
        case 1:{
          [cell setCellWithImageName:@"userLogo" labelName:@"关于 SealTalk"];
          NSString *isNeedUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedUpdate"];
          if ([isNeedUpdate isEqualToString:@"YES"]) {
            [cell addRedpointImageView];
          }return cell;
        }break;
        case 2:{
          [cell setCellWithImageName:@"sevre_inactive" labelName:@"小能客服1"];
          return cell;
        }break;
        case 3:{
          [cell setCellWithImageName:@"sevre_inactive" labelName:@"小能客服2"];
          return cell;
        }break;
        default:break;
      }
    }break;
    default:break;
  }
  return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height;
  switch (indexPath.section) {
    case 0:height = 88.f;break;
    default:height = 44.f;break;
  }
  return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  switch (indexPath.section) {
    case 0: {
      RCDMeInfoTableViewController *vc = [[RCDMeInfoTableViewController alloc] init];
      [self.navigationController pushViewController:vc animated:YES];
    }break;
    case 1: {
      switch (indexPath.row) {
        case 0: {
          RCDSettingsTableViewController *vc = [[RCDSettingsTableViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }break;
        /* RedPacket_FTR */ //open my wallet
          case 1: {
              [JrmfWalletSDK openWallet];
          }break;
        default:break;
      }
    }break;
    case 2: {
      switch (indexPath.row) {
        case 0: {
          [self chatWithCustomerService:SERVICE_ID];
        }break;
        case 1: {
          RCDAboutRongCloudTableViewController *vc = [[RCDAboutRongCloudTableViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 2: {
          [self chatWithCustomerService:SERVICE_ID_XIAONENG1];
        }break;
        case 3: {
          [self chatWithCustomerService:SERVICE_ID_XIAONENG2];
        }break;
        default:break;
      }
    }break;
    default:break;
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (void)setUserPortrait:(NSNotification *)notifycation {
  userPortrait = [notifycation object];
}
- (void)chatWithCustomerService:(NSString *)kefuId {
  RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
  // live800  KEFU146227005669524   live800的客服ID
  // zhichi   KEFU146001495753714   智齿的客服ID
  chatService.conversationType = ConversationType_CUSTOMERSERVICE;
  chatService.targetId = kefuId;
  //上传用户信息，nickname是必须要填写的
  RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
  csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
  csInfo.nickName = @"昵称";
  csInfo.loginName = @"登录名称";
  csInfo.name = @"用户名称";
  csInfo.grade = @"11级";
  csInfo.gender = @"男";
  csInfo.birthday = @"2016.5.1";
  csInfo.age = @"36";
  csInfo.profession = @"software engineer";
  csInfo.portraitUrl = [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
  csInfo.province = @"beijing";
  csInfo.city = @"beijing";
  csInfo.memo = @"这是一个好顾客!";
  csInfo.mobileNo = @"13800000000";
  csInfo.email = @"test@example.com";
  csInfo.address = @"北京市北苑路北泰岳大厦";
  csInfo.QQ = @"88888888";
  csInfo.weibo = @"my weibo account";
  csInfo.weixin = @"myweixin";
  csInfo.page = @"卖化妆品的页面来的";
  csInfo.referrer = @"客户端";
  csInfo.enterUrl = @"testurl";
  csInfo.skillId = @"技能组";
  csInfo.listUrl = @[@"用户浏览的第一个商品Url",@"用户浏览的第二个商品Url"];
  csInfo.define = @"自定义信息";
  chatService.csInfo = csInfo;
  chatService.title = @"客服";
  [self.navigationController pushViewController:chatService animated:YES];
}
@end
