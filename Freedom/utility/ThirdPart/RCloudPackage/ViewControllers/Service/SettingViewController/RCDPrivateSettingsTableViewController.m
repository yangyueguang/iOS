//
//  RCDPrivateSettingsTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/5/18.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDPrivateSettingsTableViewController.h"
#import "RCDHttpTool.h"
#import "RCloudModel.h"
#import "UIImageView+WebCache.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDataBaseManager.h"
#import "RCDSearchHistoryMessageController.h"
#import "RCDSettingBaseViewController.h"
@interface RCDPrivateSettingsUserInfoCell : UITableViewCell
@property(strong, nonatomic) UIImageView *PortraitImageView;
@property(strong, nonatomic) UILabel *NickNameLabel;
@property (strong, nonatomic) UILabel *displayNameLabel;
- (id)initWithIsHaveDisplayName:(BOOL)isHaveDisplayName;
@end
@implementation RCDPrivateSettingsUserInfoCell
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    self.PortraitImageView = [[UIImageView alloc]init];
    self.PortraitImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.PortraitImageView];
    self.NickNameLabel = [[UILabel alloc]init];
    self.NickNameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.NickNameLabel.textColor = [UIColor colorWithRGBHex:0x000000];
    [self.contentView addSubview:self.NickNameLabel];
    self.NickNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(_PortraitImageView, _NickNameLabel);
    [self.contentView
     addConstraint:[NSLayoutConstraint
                    constraintWithItem:self.PortraitImageView
                    attribute:NSLayoutAttributeCenterY
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.contentView
                    attribute:NSLayoutAttributeCenterY
                    multiplier:1.0f
                    constant:0]];
    [self.contentView
     addConstraint:[NSLayoutConstraint
                    constraintWithItem:self.NickNameLabel
                    attribute:NSLayoutAttributeCenterY
                    relatedBy:NSLayoutRelationEqual
                    toItem:self.contentView
                    attribute:NSLayoutAttributeCenterY
                    multiplier:1.0f
                    constant:0]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[_PortraitImageView(65)]"
                     options:0
                     metrics:nil
                     views:views]];
    [self.contentView
     addConstraints: [NSLayoutConstraint
                      constraintsWithVisualFormat:@"H:|-10-[_PortraitImageView(65)]-[_NickNameLabel]-40-|"
                      options:0
                      metrics:nil
                      views:views]];
}
- (id)initWithIsHaveDisplayName:(BOOL)isHaveDisplayName{
    self = [super init];
    if (self) {
        self.PortraitImageView = [[UIImageView alloc] init];
        self.PortraitImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.PortraitImageView];
        self.NickNameLabel = [[UILabel alloc] init];
        self.NickNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.NickNameLabel.font = [UIFont systemFontOfSize:16.f];
        self.NickNameLabel.textColor = [UIColor colorWithRGBHex:0x000000];
        [self addSubview:self.NickNameLabel];
        NSDictionary *subViews = NSDictionaryOfVariableBindings(_PortraitImageView,_NickNameLabel);
        [self
         addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.PortraitImageView
                        attribute:NSLayoutAttributeCenterY
                        relatedBy:NSLayoutRelationEqual
                        toItem:self
                        attribute:NSLayoutAttributeCenterY
                        multiplier:1
                        constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_PortraitImageView(65)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:subViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_PortraitImageView(65)]-10-[_NickNameLabel]-10-|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:subViews]];
        if (isHaveDisplayName == YES) {
            self.displayNameLabel = [[UILabel alloc] init];
            self.displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.displayNameLabel.font = [UIFont systemFontOfSize:12.f];
            self.displayNameLabel.textColor = [UIColor colorWithRGBHex:0x999999];
            [self addSubview:self.displayNameLabel];
            [self
             addConstraint:[NSLayoutConstraint
                            constraintWithItem:self.NickNameLabel
                            attribute:NSLayoutAttributeTop
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.PortraitImageView
                            attribute:NSLayoutAttributeTop
                            multiplier:1
                            constant:13.5]];
            [self
             addConstraint:[NSLayoutConstraint
                            constraintWithItem:self.displayNameLabel
                            attribute:NSLayoutAttributeBottom
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.PortraitImageView
                            attribute:NSLayoutAttributeBottom
                            multiplier:1
                            constant:-13.5]];
            [self
             addConstraint:[NSLayoutConstraint
                            constraintWithItem:self.displayNameLabel
                            attribute:NSLayoutAttributeLeft
                            relatedBy:NSLayoutRelationEqual
                            toItem:self.NickNameLabel
                            attribute:NSLayoutAttributeLeft
                            multiplier:1
                            constant:0]];
        } else {
            [self
             addConstraint:[NSLayoutConstraint
                            constraintWithItem:self.NickNameLabel
                            attribute:NSLayoutAttributeCenterY
                            relatedBy:NSLayoutRelationEqual
                            toItem:self
                            attribute:NSLayoutAttributeCenterY
                            multiplier:1
                            constant:0]];
        }
    }
    return self;
}
@end
@interface RCDPrivateSettingsCell : UITableViewCell
@property(strong, nonatomic) UILabel *TitleLabel;
@property(strong, nonatomic) UISwitch *SwitchButton;
@end
@implementation RCDPrivateSettingsCell
@end
static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";
@interface RCDPrivateSettingsTableViewController ()
@property(strong, nonatomic) RCDUserInfo *userInfo;
@end
@implementation RCDPrivateSettingsTableViewController {
  NSString *portraitUrl;
  NSString *nickname;
  BOOL enableNotification;
  RCConversation *currentConversation;
}
+ (instancetype)privateSettingsTableViewController {
    return [[[self class] alloc]init];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self startLoadView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 87, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-6, 4, 10, 17);
    [backBtn addSubview:backImg];
    UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(9,4, 85, 17)];
    backText.text = @"返回"; // NSLocalizedStringFromTable(@"Back",
    // @"RongCloudKit", nil);
    //   backText.font = [UIFont systemFontOfSize:17];
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.title = @"聊天详情";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f6];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)leftBarButtonItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSInteger rows;
  switch (section) {
  case 0:rows = 1;break;
  case 1:rows = 1;break;
  case 2:rows = 3;break;
    default:rows = 0;break;
  }
  return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 1 || section == 2) {
    return 20.f;
  }
  return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heigh = 0;
  switch (indexPath.section) {
  case 0:heigh = 86.f;break;
  case 1:heigh = 43.f;break;
  case 2:heigh = 43.f;break;
  default:break;
  }
  return heigh;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//<<<<<<< HEAD
    static NSString *InfoCellIdentifier = @"RCDPrivateSettingsUserInfoCell";
    RCDPrivateSettingsUserInfoCell *infoCell = (RCDPrivateSettingsUserInfoCell *)[tableView dequeueReusableCellWithIdentifier:InfoCellIdentifier];
    if(!infoCell) {
        infoCell = [[RCDPrivateSettingsUserInfoCell alloc]init];
    }
    RCDBaseSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[RCDBaseSettingTableViewCell alloc]init];
    }
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
      RCDPrivateSettingsUserInfoCell *infoCell;
      if (self.userInfo != nil) {
        portraitUrl = self.userInfo.portraitUri;
        if (self.userInfo.displayName.length > 0) {
          infoCell = [[RCDPrivateSettingsUserInfoCell alloc] initWithIsHaveDisplayName:YES];
          infoCell.NickNameLabel.text = self.userInfo.displayName;
          infoCell.displayNameLabel.text = [NSString stringWithFormat:@"昵称: %@",self.userInfo.name];
        } else {
          infoCell = [[RCDPrivateSettingsUserInfoCell alloc] initWithIsHaveDisplayName:NO];
          infoCell.NickNameLabel.text = self.userInfo.name;
        }
      } else {
        infoCell = [[RCDPrivateSettingsUserInfoCell alloc] initWithIsHaveDisplayName:NO];
        infoCell.NickNameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
        portraitUrl = [RCIM sharedRCIM].currentUserInfo.portraitUri;
      }
      if ([portraitUrl isEqualToString:@""]) {
        UIView *defaultPortrait = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
          defaultPortrait.backgroundColor = [UIColor redColor];
          NSString *firstLetter = [ChineseToPinyin firstPinyinFromChinise:nickname];
          UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
          firstCharacterLabel.text = firstLetter;
          firstCharacterLabel.textColor = [UIColor whiteColor];
          firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
          firstCharacterLabel.font = [UIFont systemFontOfSize:50];
          [defaultPortrait addSubview:firstCharacterLabel];
        UIImage *portrait = [defaultPortrait imageFromView];
        infoCell.PortraitImageView.image = portrait;
      } else {
        [infoCell.PortraitImageView sd_setImageWithURL:[NSURL URLWithString:portraitUrl] placeholderImage:[UIImage imageNamed:@"icon_person"]];
      }
      infoCell.PortraitImageView.layer.masksToBounds = YES;
      infoCell.PortraitImageView.layer.cornerRadius = 5.f;
      infoCell.PortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
      infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
      return infoCell;
    }
  if (indexPath.section == 1) {
    RCDBaseSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
      cell = [[RCDBaseSettingTableViewCell alloc]init];
    }
    cell.leftLabel.text = @"查找聊天记录";
    [cell setCellStyle:DefaultStyle];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  if (indexPath.section == 2) {
    switch (indexPath.row) {
      case 0: {
        [cell setCellStyle:SwitchStyle];
        cell.leftLabel.text = @"消息免打扰";
        cell.switchButton.hidden = NO;
        cell.switchButton.on = !enableNotification;
        [cell.switchButton removeTarget:self action:@selector(clickIsTopBtn:) forControlEvents:UIControlEventValueChanged];
        [cell.switchButton addTarget:self action:@selector(clickNotificationBtn:) forControlEvents:UIControlEventValueChanged];
      } break;
      case 1: {
        [cell setCellStyle:SwitchStyle];
        cell.leftLabel.text = @"会话置顶";
        cell.switchButton.hidden = NO;
        cell.switchButton.on = currentConversation.isTop;
        [cell.switchButton addTarget:self action:@selector(clickIsTopBtn:) forControlEvents:UIControlEventValueChanged];
      } break;
      case 2: {
        [cell setCellStyle:SwitchStyle];
        cell.leftLabel.text = @"清除聊天记录";
        cell.switchButton.hidden = YES;
      } break;
      default:break;
    }
    return cell;
  }
  return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1) {
    RCDSearchHistoryMessageController *searchViewController = [[RCDSearchHistoryMessageController alloc] init];
    searchViewController.conversationType = ConversationType_PRIVATE;
    searchViewController.targetId = self.userId;
    [self.navigationController pushViewController:searchViewController animated:YES];
  }
  if (indexPath.section == 2) {
    if (indexPath.row == 2) {
        [self showAlerWithtitle:@"确定清除聊天记录？" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self clearChatHistory];
            }];
        } ac2:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
        } ac3:nil completion:nil];
    }
  }
}
- (void)clearChatHistory{
      NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      RCDPrivateSettingsCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
      UIActivityIndicatorView *activityIndicatorView =
      [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
      float cellWidth = cell.bounds.size.width;
      UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(cellWidth - 50, 15, 40, 40)];
      [loadingView addSubview:activityIndicatorView];
      dispatch_async(dispatch_get_main_queue(), ^{
        [activityIndicatorView startAnimating];
        [cell addSubview:loadingView];
      });
      [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_PRIVATE targetId:_userId success:^{
        [self performSelectorOnMainThread:@selector(clearCacheAlertMessage:) withObject:@"清除聊天记录成功！" waitUntilDone:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearHistoryMsg" object:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
          [loadingView removeFromSuperview];
        });
      } error:^(RCErrorCode status) {
        [self performSelectorOnMainThread:@selector(clearCacheAlertMessage:) withObject:@"清除聊天记录失败！" waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
          [loadingView removeFromSuperview];
        });
      }];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearHistoryMsg" object:nil];
}
- (void)clearCacheAlertMessage:(NSString *)msg {
    [SVProgressHUD showInfoWithStatus:msg];
}
#pragma mark - 本类的私有方法
- (void)startLoadView {
  currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:self.userId];
  [[RCIMClient sharedRCIMClient]getConversationNotificationStatus:ConversationType_PRIVATE targetId:self.userId success:^(RCConversationNotificationStatus nStatus) {
        enableNotification = NO;
        if (nStatus == NOTIFY) {
          enableNotification = YES;
        }
        [self.tableView reloadData];
      }error:^(RCErrorCode status){
      }];
  [self loadUserInfo:self.userId];
}
- (void)loadUserInfo:(NSString *)userId {
  if (![userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
    self.userInfo = [[RCDataBaseManager shareInstance] getFriendInfo:userId];
  }
}
- (void)clickNotificationBtn:(id)sender {
  UISwitch *swch = sender;
  [[RCIMClient sharedRCIMClient]setConversationNotificationStatus:ConversationType_PRIVATE targetId:self.userId isBlocked:swch.on success:^(RCConversationNotificationStatus nStatus) {
      }error:^(RCErrorCode status){
      }];
}
- (void)clickIsTopBtn:(id)sender {
  UISwitch *swch = sender;
  [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:self.userId isTop:swch.on];
}
@end
