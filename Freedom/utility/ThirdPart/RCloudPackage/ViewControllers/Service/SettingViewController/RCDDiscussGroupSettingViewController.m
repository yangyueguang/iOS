//
//  RCDiscussGroupSettingViewController.m
//  RongIMToolkit
//
//  Created by Liv on 15/3/30.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//
#import "RCDDiscussGroupSettingViewController.h"
#import "RCDAddFriendViewController.h"
#import "RCDChatViewController.h"
#import "RCDContactSelectedTableViewController.h"
#import "RCDHttpTool.h"
#import "RCDPersonDetailViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import <RongIMKit/RongIMKit.h>
#import <UIKit/UIKit.h>
typedef void (^setDisplayText)(NSString *text);
@interface RCDUpdateNameViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
/** *  初始化方法*/
+ (instancetype)updateNameViewController;
/***  更改讨论组名称的textField*/
@property (nonatomic, strong) UITextField *nameTextField;
/***  讨论组id*/
@property(nonatomic, copy) NSString *targetId;
/***  讨论组名称*/
@property(nonatomic, copy) NSString *displayText;
/***  保存讨论组名称block*/
@property(nonatomic, copy) setDisplayText setDisplayTextCompletion;
@end
NSString *const RCDUpdateNameTableViewCellIdentifier = @"RCDUpdateNameTableViewCellIdentifier";
@implementation RCDUpdateNameViewController
+ (instancetype)updateNameViewController {
    return [[[self class] alloc] init];
}
- (instancetype)init {
    self = [super init];
    if(self){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RCDUpdateNameTableViewCellIdentifier];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRGBHex:0x0195ff]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    self.nameTextField.text = self.displayText;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.nameTextField.text = self.displayText;
}
- (void)backBarButtonItemClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightBarButtonItemClicked:(id)sender {
    //保存讨论组名称
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入讨论组名称!"];
        return;
    }
    //讨论组名称不能包含空格
    NSRange range = [self.nameTextField.text rangeOfString:@" "];
    if (range.location != NSNotFound) {
        [SVProgressHUD showErrorWithStatus:@"讨论组名称不能包含空格!"];
        return;
    }
    //回传值
    if (self.setDisplayTextCompletion) {
        self.setDisplayTextCompletion(self.nameTextField.text);
    }
    //保存设置
    [[RCIM sharedRCIM] setDiscussionName:self.targetId name:self.nameTextField.text success:^{
      }error:^(RCErrorCode status){
     }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //收起键盘
    [self.nameTextField resignFirstResponder];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RCDUpdateNameTableViewCellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RCDUpdateNameTableViewCellIdentifier];
    }
    [cell.contentView addSubview:self.nameTextField];
    return cell;
}
- (UITextField *)nameTextField {
    if(!_nameTextField){
        _nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(8, 0, APPW-8-8, 44.0f)];
        _nameTextField.font = [UIFont systemFontOfSize:14];
        _nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    return _nameTextField;
}
@end
@interface RCDDiscussSettingSwitchCell : UITableViewCell
@property(nonatomic, strong) UISwitch *swich;
@property(nonatomic, strong) UILabel *label;
@end
@implementation RCDDiscussSettingSwitchCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setText:@"test"];
        [_label setTextAlignment:NSTextAlignmentLeft];
        _swich = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self addSubview:_label];
        [self addSubview:_swich];
        [_swich setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_swich(33)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0f
                             constant:-20]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_label(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-16-[_label][_swich]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label, _swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_label
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
    }
    return self;
}
@end
@interface RCDDiscussSettingCell : UITableViewCell
@property(strong, nonatomic) UILabel *lblDiscussName;
@property(strong, nonatomic) UILabel *lblTitle;
@end
@implementation RCDDiscussSettingCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _lblDiscussName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_lblDiscussName setTextAlignment:NSTextAlignmentRight];
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lblTitle];
        [self.contentView addSubview:_lblDiscussName];
        [_lblDiscussName setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_lblTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:
          @"H:|-16-[_lblTitle]-80-[_lblDiscussName]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _lblDiscussName, _lblTitle)]];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_lblTitle(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _lblTitle)]];
        [self.contentView
         addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_lblDiscussName(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _lblDiscussName)]];
        [self.contentView
         addConstraint:[NSLayoutConstraint
                        constraintWithItem:_lblTitle
                        attribute:NSLayoutAttributeCenterY
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.contentView
                        attribute:NSLayoutAttributeCenterY
                        multiplier:1.0f
                        constant:0]];
        [self.contentView
         addConstraint:[NSLayoutConstraint
                        constraintWithItem:_lblDiscussName
                        attribute:NSLayoutAttributeCenterY
                        relatedBy:NSLayoutRelationEqual
                        toItem:self.contentView
                        attribute:NSLayoutAttributeCenterY
                        multiplier:1.0f
                        constant:0]];
    }
    return self;
}
@end
@interface RCDDiscussGroupSettingViewController () <UIActionSheetDelegate>
@property(nonatomic, copy) NSString *discussTitle;
@property(nonatomic, copy) NSString *creatorId;
@property(nonatomic, strong) NSMutableDictionary *members;
@property(nonatomic, strong) NSMutableArray *userList;
@property(nonatomic) BOOL isOwner;
@property(nonatomic, assign) BOOL isClick;
@end
@implementation RCDDiscussGroupSettingViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  //显示顶部视图
  self.headerHidden = NO;
  _members = [[NSMutableDictionary alloc] init];
  _userList = [[NSMutableArray alloc] init];
  //添加当前聊天用户
  if (self.conversationType == ConversationType_PRIVATE) {
    [RCDHTTPTOOL getUserInfoByUserID:self.targetId completion:^(RCUserInfo *user) {
        [self addUsers:@[ user ]];
        [_members setObject:user forKey:user.userId];
        [_userList addObject:user];
      }];
  }
  //添加讨论组成员
  if (self.conversationType == ConversationType_DISCUSSION) {
    __weak RCDSettingBaseViewController *weakSelf = self;
    [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
          if (discussion) {
            _creatorId = discussion.creatorId;
            if ([[RCIMClient sharedRCIMClient].currentUserInfo.userId isEqualToString:discussion.creatorId]) {
              [weakSelf disableDeleteMemberEvent:NO];
              self.isOwner = YES;
            } else {
              [weakSelf disableDeleteMemberEvent:YES];
              self.isOwner = NO;
              if (discussion.inviteStatus == 1) {
                [self disableInviteMemberEvent:YES];
              }
            }
            NSMutableArray *users = [NSMutableArray new];
            for (NSString *targetId in discussion.memberIdList) {
              [RCDHTTPTOOL getUserInfoByUserID:targetId completion:^(RCUserInfo *user) {
                 if ([discussion.creatorId isEqualToString:user.userId]) {
                   [users insertObject:user atIndex:0];
                 } else {
                   [users addObject:user];
                 }
                 [_members setObject:user forKey:user.userId];
                 if (users.count == discussion.memberIdList.count) {
                   [weakSelf addUsers:users];
                   [_userList addObjectsFromArray:users];
                 }
               }];
            }
          }
        }error:^(RCErrorCode status){
    }];
  }
  UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
  UIImage *image = [UIImage imageNamed:@"group_quit"];
  UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 42, 90 / 2)];
  [button setBackgroundImage:image forState:UIControlStateNormal];
  [button setTitle:@"删除并退出" forState:UIControlStateNormal];
  [button setCenter:CGPointMake(view.bounds.size.width / 2,view.bounds.size.height / 2)];
  [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:button];
  self.tableView.tableFooterView = view;
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshHeaderView:) name:@"addDiscussiongroupMember" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _isClick = YES;
}
- (void)buttonAction:(UIButton *)sender {
    [self showAlerWithtitle:@"删除并且退出讨论组" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __weak typeof(&*self) weakSelf = self;
            [[RCIM sharedRCIM] quitDiscussion:self.targetId success:^(RCDiscussion *discussion) {
              NSLog(@"退出讨论组成功");
              UIViewController *temp = nil;
              NSArray *viewControllers =
              weakSelf.navigationController.viewControllers;
              temp = viewControllers[viewControllers.count - 1 - 2];
              if (temp) {
                  //切换主线程
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [weakSelf.navigationController popToViewController:temp animated:YES];
                  });
              }
            }error:^(RCErrorCode status) {
                NSLog(@"quit discussion status is %ld", (long)status);
            }];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    } ac3:nil completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isOwner) {
    return self.defaultCells.count + 2;
  } else {
    return self.defaultCells.count + 1;
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  int offset = 2;
  if (!self.isOwner) {
    offset = 1;
  }
  switch (indexPath.row) {
  case 0: {
    RCDDiscussSettingCell *discussCell = [[RCDDiscussSettingCell alloc] initWithFrame:CGRectZero];
    discussCell.lblDiscussName.text = self.conversationTitle;
    discussCell.lblTitle.text = @"讨论组名称";
    cell = discussCell;
    _discussTitle = discussCell.lblDiscussName.text;
  } break;
  case 1: {
    if (self.isOwner) {
      RCDDiscussSettingSwitchCell *switchCell = [[RCDDiscussSettingSwitchCell alloc] initWithFrame:CGRectZero];
      switchCell.label.text = @"开放成员邀请";
      [[RCIMClient sharedRCIMClient] getDiscussion:self.targetId success:^(RCDiscussion *discussion) {
            if (discussion.inviteStatus == 0) {
              switchCell.swich.on = YES;
            }
          }error:^(RCErrorCode status){
          }];
      [switchCell.swich addTarget:self action:@selector(openMemberInv:) forControlEvents:UIControlEventTouchUpInside];
      cell = switchCell;
    } else {
      cell = self.defaultCells[0];
    }
  } break;
  case 2: {
    cell = self.defaultCells[indexPath.row - offset];
  } break;
  case 3: {
    cell = self.defaultCells[indexPath.row - offset];
  } break;
  case 4: {
    cell = self.defaultCells[indexPath.row - offset];
  } break;
  }
  return cell;
}
#pragma mark - RCConversationSettingTableViewHeader Delegate
//点击最后一个+号事件
- (void)settingTableViewHeader:(RCConversationSettingTableViewHeader *)settingTableViewHeader indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem allTheSeletedUsers:(NSArray *)users {
  //点击最后一个+号,调出选择联系人UI
  if (indexPathOfSelectedItem.row == settingTableViewHeader.users.count) {
    RCDContactSelectedTableViewController * contactSelectedVC= [[RCDContactSelectedTableViewController alloc]init];
    contactSelectedVC.addDiscussionGroupMembers = _userList;
    if (self.conversationType == ConversationType_DISCUSSION) {
      contactSelectedVC.discussiongroupId = self.targetId;
      contactSelectedVC.isAllowsMultipleSelection = YES;
    }
    [self.navigationController pushViewController:contactSelectedVC animated:YES];
  }
}
#pragma mark - private method
- (void)refreshHeaderView:(NSNotification *)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *members = notification.object;
    [_userList addObjectsFromArray:members];
    [self addUsers:_userList];
  });
}
- (void)createDiscussionOrInvokeMemberWithSelectedUsers:(NSArray *)selectedUsers {
  //    __weak RCDSettingViewController *weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (ConversationType_DISCUSSION == self.conversationType) {
      // invoke new member to current discussion
      NSMutableArray *addIdList = [NSMutableArray new];
      for (RCUserInfo *user in selectedUsers) {
        [addIdList addObject:user.userId];
      }
      //加入讨论组
      if (addIdList.count != 0) {
        [[RCIM sharedRCIM] addMemberToDiscussion:self.targetId userIdList:addIdList success:^(RCDiscussion *discussion) {
              NSLog(@"成功");
            }error:^(RCErrorCode status){
        }];
      }
    } else if (ConversationType_PRIVATE == self.conversationType) {
      // create new discussion with the new invoked member.
      NSUInteger _count = [_members.allKeys count];
      if (_count > 1) {
        NSMutableString *discussionTitle = [NSMutableString string];
        NSMutableArray *userIdList = [NSMutableArray new];
        for (int i = 0; i < _count; i++) {
          RCUserInfo *_userInfo = (RCUserInfo *)_members.allValues[i];
          [discussionTitle appendString:[NSString stringWithFormat:@"%@%@", _userInfo.name, @","]];
          [userIdList addObject:_userInfo.userId];
        }
        [discussionTitle deleteCharactersInRange:NSMakeRange(discussionTitle.length - 1, 1)];
        self.conversationTitle = discussionTitle;
        __weak typeof(&*self) weakSelf = self;
        [[RCIM sharedRCIM] createDiscussion:discussionTitle userIdList:userIdList success:^(RCDiscussion *discussion) {
              dispatch_async(dispatch_get_main_queue(), ^{
                RCDChatViewController *chat = [[RCDChatViewController alloc] init];
                chat.targetId = discussion.discussionId;
                chat.csInfo.nickName = discussion.discussionName;
                chat.conversationType = ConversationType_DISCUSSION;
                chat.title = discussionTitle;
                  //[NSString stringWithFormat:@"讨论组(%lu)",(unsigned long)_count];
                UITabBarController *tabbarVC = weakSelf.navigationController.viewControllers[0];
                [weakSelf.navigationController popToViewController:tabbarVC animated:NO];
                [tabbarVC.navigationController pushViewController:chat animated:YES];
              });
            }error:^(RCErrorCode status){
//            DebugLog(@"create discussion Failed > %ld!",
//            (long)status);
            }];
      }
    }
  });
}
- (void)openMemberInv:(UISwitch *)swch {
  //设置成员邀请权限
  [[RCIM sharedRCIM] setDiscussionInviteStatus:self.targetId isOpen:swch.on success:^{
        //        DebugLog(@"设置成功");
      }error:^(RCErrorCode status){
  }];
}
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if (self.setDiscussTitleCompletion) {
    self.setDiscussTitleCompletion(_discussTitle);
  }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    RCDDiscussSettingCell *discussCell = (RCDDiscussSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    discussCell.lblTitle.text = @"讨论组名称";
      RCDUpdateNameViewController *updateNameViewController = [RCDUpdateNameViewController updateNameViewController];
    updateNameViewController.targetId = self.targetId;
    updateNameViewController.displayText = discussCell.lblDiscussName.text;
    updateNameViewController.setDisplayTextCompletion = ^(NSString *text) {
      discussCell.lblDiscussName.text = text;
      _discussTitle = text;
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:updateNameViewController];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
  }
}
/**
 *  override
 *  @param 添加顶部视图显示的user,必须继承以调用父类添加user
 */
- (void)addUsers:(NSArray *)users {
  [super addUsers:users];
}
/**
 *  override 左上角删除按钮回调
 *  @param indexPath indexPath description
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath {
  RCUserInfo *user = self.users[indexPath.row];
  if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
    return;
  }
  [[RCIM sharedRCIM] removeMemberFromDiscussion:self.targetId userId:user.userId success:^(RCDiscussion *discussion) {
        NSLog(@"踢人成功");
        [_userList removeObject:user];
        [self.users removeObject:user];
        [self.members removeObjectForKey:user.userId];
        [self addUsers:self.users];
      }error:^(RCErrorCode status) {
        NSLog(@"踢人失败");
      }];
}
- (void)didTipHeaderClicked:(NSString *)userId {
  if (_isClick) {
    _isClick = NO;
    [[RCDRCIMDataSource shareInstance] getUserInfoWithUserId:userId completion:^(RCUserInfo *userInfo) {
     [[RCDHttpTool shareInstance] updateUserInfo:userId success:^(RCUserInfo *user) {
           if (![userInfo.name isEqualToString:user.name]) {
             [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
           }
           NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
           for (RCUserInfo *USER in friendList) {
             if ([userId isEqualToString:USER.userId] || [userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                RCDPersonDetailViewController *temp = [[RCDPersonDetailViewController alloc]init];
               temp.userId = user.userId;
               [self.navigationController pushViewController:temp animated:YES];
               return;
             }
           }
             RCDAddFriendViewController *addViewController = [[RCDAddFriendViewController alloc]init];
             addViewController.targetUserInfo = userInfo;
             [self.navigationController pushViewController:addViewController animated:YES];
         }failure:^(NSError *err) {
           _isClick = NO;
         }];
   }];
  }
}
@end
