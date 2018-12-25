//
//  RCDGroupSettingsTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDGroupSettingsTableViewController.h"
#import "MBProgressHUD.h"
#import "RCDAddFriendViewController.h"
#import "RCDContactSelectedTableViewController.h"
#import "RCDConversationSettingBaseViewController.h"
#import "RCDEditGroupNameViewController.h"
#import "RCDGroupMembersTableViewController.h"
#import "RCDHttpTool.h"
#import "RCDPersonDetailViewController.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDGroupAnnouncementViewController.h"
#import "RCDSearchHistoryMessageController.h"
static NSString *CellIdentifier = @"RCDBaseSettingTableViewCell";
#import "RCloudModel.h"
#import "RCDBaseSettingTableViewCell.h"
@class RCDGroupInfo;
#define RCDGroupSettingsTableViewCellGroupNameTag 999
#define RCDGroupSettingsTableViewCellGroupPortraitTag 1000
#define SwitchButtonTag  1111
@interface RCDGroupSettingsTableViewCell : RCDBaseSettingTableViewCell
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath andGroupInfo:(RCDGroupInfo *)groupInfo;
@end
@implementation RCDGroupSettingsTableViewCell
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath andGroupInfo:(RCDGroupInfo *)groupInfo {
    //带右边图片的cell
    if(indexPath.section == 1 && indexPath.row == 0){
        NSString *groupPortrait;
        if ([groupInfo.portraitUri isEqualToString:@""]) {
            groupPortrait = [FreedomTools defaultGroupPortrait:groupInfo];
        } else {
            groupPortrait = groupInfo.portraitUri;
        }
        self = [super initWithLeftImageStr:nil leftImageSize:CGSizeZero rightImaeStr:groupPortrait rightImageSize:CGSizeMake(25, 25)];
    }
    //一般cell
    else {
        self = [super init];
    }
    [self initSubviewsWithIndexPath:indexPath andGroupInfo:groupInfo];
    return self;
}
- (void)initSubviewsWithIndexPath:(NSIndexPath *)indexPath andGroupInfo:(RCDGroupInfo *)groupInfo{
    if(indexPath.section == 0){
        [self setCellStyle:DefaultStyle];
        self.tag = RCDGroupSettingsTableViewCellGroupNameTag;
        self.leftLabel.text = [NSString stringWithFormat:@"全部群成员(%@)", groupInfo.number];
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0: {
                [self setCellStyle:DefaultStyle];
                self.tag = RCDGroupSettingsTableViewCellGroupPortraitTag;
                self.leftLabel.text = @"群组头像";
            }break;
            case 1:
                [self setCellStyle:DefaultStyle_RightLabel];
                self.leftLabel.text = @"群组名称";
                self.rightLabel.text = groupInfo.groupName;
                break;
            case 2:
                [self setCellStyle:DefaultStyle];
                self.leftLabel.text = @"群公告";
                break;
            default:break;
        }
    }else if(indexPath.section == 2){
        [self setCellStyle:DefaultStyle];
        self.leftLabel.text = @"查找聊天记录";
    }else{
        switch (indexPath.row) {
            case 0:
                [self setCellStyle:SwitchStyle];
                self.leftLabel.text = @"消息免打扰";
                self.switchButton.tag = SwitchButtonTag;
                break;
            case 1:
                [self setCellStyle:SwitchStyle];
                self.leftLabel.text = @"会话置顶";
                self.switchButton.tag = SwitchButtonTag + 1;
                break;
            case 2:
                [self setCellStyle:DefaultStyle];
                self.leftLabel.text= @"清除聊天记录";
                break;
            default:
                break;
        }
    }
}
@end
@interface RCDGroupSettingsTableViewController ()
//开始会话
@property(strong, nonatomic) UIButton *btChat;
//加入或退出群组
@property(strong, nonatomic) UIButton *btJoinOrQuitGroup;
//解散群组
@property(strong, nonatomic) UIButton *btDismissGroup;
@end
@implementation RCDGroupSettingsTableViewController {
  NSInteger numberOfSections;
  RCConversation *currentConversation;
  BOOL enableNotification;
  NSMutableArray *collectionViewResource;
  UICollectionView *headerView;
  NSString *groupId;
  NSString *creatorId;
  BOOL isCreator;
  UIImage *image;
  NSData *data;
  MBProgressHUD *hud;
}
+ (instancetype)groupSettingsTableViewController {
    return [[[self class] alloc]init];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
}
- (void)setGroup:(RCDGroupInfo *)Group {
    _Group = Group;
    if (_Group) {
        groupId = _Group.groupId;
        if (creatorId == nil) {
            creatorId = _Group.creatorId;
            if ([creatorId
                 isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
                isCreator = YES;
            }
        }
    }
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
  self.tableView.backgroundColor = [FreedomTools colorWithRGBHex:0xf0f0f6];
  self.tableView.separatorColor = [FreedomTools colorWithRGBHex:0xdfdfdf];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  numberOfSections = 0;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 87, 23);
    UIImageView *backImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
    backImg.frame = CGRectMake(-6, 4, 10, 17);
    [backBtn addSubview:backImg];
    UILabel *backText =[[UILabel alloc] initWithFrame:CGRectMake(9,4, 85, 17)];
    backText.text = @"返回";
    [backText setBackgroundColor:[UIColor clearColor]];
    [backText setTextColor:[UIColor whiteColor]];
    [backBtn addSubview:backText];
    [backBtn addTarget:self action:@selector(backBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
  CGRect tempRect = CGRectMake(0, 0, APPW,headerView.collectionViewLayout.collectionViewContentSize.height);
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  headerView = [[UICollectionView alloc] initWithFrame:tempRect collectionViewLayout:flowLayout];
  headerView.delegate = self;
  headerView.dataSource = self;
  headerView.scrollEnabled = NO;
  headerView.backgroundColor = [UIColor whiteColor];
  [headerView registerClass:[RCDConversationSettingTableViewHeaderItem class]
      forCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItem"];
  [headerView registerClass:[RCDConversationSettingTableViewHeaderItem class]forCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItemForSigns"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  if (collectionViewResource.count < 1) {
    [self startLoad];
  }
    if(self.Group.number){
        self.title = [NSString stringWithFormat:@"群组信息(%@)",self.Group.number];
    }else{
        self.title = @"群组信息";
    }
}
#pragma mark - 本类的私有方法
- (void)clickNotificationBtn:(id)sender {
  UISwitch *swch = sender;
  [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:groupId isBlocked:swch.on success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"成功");
      }error:^(RCErrorCode status) {
        NSLog(@"失败");
      }];
}
- (void)clickIsTopBtn:(id)sender {
  UISwitch *swch = sender;
  [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:groupId isTop:swch.on];
}
- (void)backBarButtonItemClicked:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)startLoad {
  currentConversation = [[RCIMClient sharedRCIMClient] getConversation:ConversationType_GROUP targetId:groupId];
  if (currentConversation.targetId == nil) {
    numberOfSections = 3;
    [self.tableView reloadData];
  } else {
    numberOfSections = 4;
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP
        targetId:groupId success:^(RCConversationNotificationStatus nStatus) {
          enableNotification = NO;
          if (nStatus == NOTIFY) {
            enableNotification = YES;
          }
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
          });
        }error:^(RCErrorCode status){
        }];
  }
  NSMutableArray *groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:groupId];
  groupMemberList = [self moveCreator:groupMemberList];
  NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:groupMemberList];
  groupMemberList = [[NSMutableArray alloc] initWithArray:resultList];
    for (RCUserInfo *user in groupMemberList) {
        [[RCDUserInfoManager shareInstance] getFriendInfo:user.userId completion:^(RCUserInfo *user) {
             [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
           dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
           });
         }];
    }
  if ([groupMemberList count] > 0) {
    /******************添加headerview*******************/
    collectionViewResource =
        [[NSMutableArray alloc] initWithArray:groupMemberList];
    //dispatch_async(dispatch_get_main_queue(), ^{
      [self setHeaderView];
   // });
  }
    __weak typeof(self) weakSelf = self;
    [RCDHTTPTOOL getGroupMembersWithGroupId:groupId Block:^(NSMutableArray *result) {
       if ([result count] > 0) {
           dispatch_async(dispatch_get_main_queue(), ^{
               weakSelf.title = [NSString stringWithFormat:@"群组信息(%lu)",(unsigned long)result.count];
               RCDGroupSettingsTableViewCell *cell = (RCDGroupSettingsTableViewCell *)
               [self.tableView viewWithTag:RCDGroupSettingsTableViewCellGroupNameTag];
               cell.leftLabel.text = [NSString stringWithFormat:@"全部群成员(%lu)", (unsigned long)result.count];
           });
         collectionViewResource = [NSMutableArray new];
         NSMutableArray *tempArray = result;
         tempArray = [self moveCreator:tempArray];
         NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:tempArray];
         NSMutableArray *groupMemberList = [[NSMutableArray alloc] initWithArray:resultList];
         collectionViewResource = [groupMemberList mutableCopy];
         [self setHeaderView];
         [[RCDataBaseManager shareInstance]insertGroupMemberToDB:result groupId:groupId complete:^(BOOL results) {
          }];
         for (RCDUserInfo *user in result) {
           [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:user.userId];
         }
       }
     }];
  /******************添加footerview*******************/
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
  //删除并退出按钮
  UIImage *quitImage = [UIImage imageNamed:@"group_quit"];
  UIImage *quitImageSelected = [UIImage imageNamed:@"group_quit_hover"];
  _btJoinOrQuitGroup = [[UIButton alloc] init];
  [_btJoinOrQuitGroup setBackgroundImage:quitImage forState:UIControlStateNormal];
  [_btJoinOrQuitGroup setBackgroundImage:quitImageSelected forState:UIControlStateSelected];
  [_btJoinOrQuitGroup setTitle:@"删除并退出" forState:UIControlStateNormal];
  [_btJoinOrQuitGroup setCenter:CGPointMake(view.bounds.size.width / 2,view.bounds.size.height / 2)];
  [_btJoinOrQuitGroup addTarget:self action:@selector(btnJOQAction:) forControlEvents:UIControlEventTouchUpInside];
  _btJoinOrQuitGroup.layer.cornerRadius = 5.f;
  _btJoinOrQuitGroup.layer.borderWidth = 0.5f;
  _btJoinOrQuitGroup.layer.borderColor = [[FreedomTools colorWithRGBHex:0xcc4445] CGColor];
  [view addSubview:_btJoinOrQuitGroup];
  //解散群组按钮
  _btDismissGroup = [[UIButton alloc] init];
  [_btDismissGroup setBackgroundImage:quitImage forState:UIControlStateNormal];
  [_btDismissGroup setBackgroundImage:quitImageSelected forState:UIControlStateSelected];
  [_btDismissGroup setTitle:@"解散并删除" forState:UIControlStateNormal];
  [_btDismissGroup setBackgroundColor:[UIColor orangeColor]];
  [_btDismissGroup setCenter:CGPointMake(view.bounds.size.width / 2,                                       view.bounds.size.height / 2)];
  [_btDismissGroup addTarget:self action:@selector(btnDismissAction:) forControlEvents:UIControlEventTouchUpInside];
  _btDismissGroup.layer.cornerRadius = 5.f;
  [_btDismissGroup setHidden:YES];
  _btDismissGroup.layer.borderWidth = 0.5f;
  _btDismissGroup.layer.borderColor = [[FreedomTools colorWithRGBHex:0xcc4445] CGColor];
  [view addSubview:_btDismissGroup];
  //自动布局
  [_btChat setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_btJoinOrQuitGroup setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_btDismissGroup setTranslatesAutoresizingMaskIntoConstraints:NO];
  NSDictionary *views = NSDictionaryOfVariableBindings(_btJoinOrQuitGroup, _btDismissGroup);
  if (isCreator == YES) {
    [_btDismissGroup setHidden:NO];
    [_btJoinOrQuitGroup setHidden:YES];
    [view
        addConstraints:[NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|-29-[_"
                                                       @"btDismissGroup(42)]"
                                               options:0
                                               metrics:nil
                                                 views:views]];
    
    [view addConstraints:[NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|-10-[_btDismissGroup]-10-|"
                                               options:0
                                               metrics:nil
                                               views:views]];
  } else {
    [view
        addConstraints:[NSLayoutConstraint
                           constraintsWithVisualFormat:@"V:|-29-[_"
                                                       @"btJoinOrQuitGroup(42)]"
                                               options:0
                                               metrics:nil
                                                 views:views]];
    [view addConstraints:[NSLayoutConstraint
                             constraintsWithVisualFormat:
                                 @"H:|-10-[_btJoinOrQuitGroup]-10-|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]];
  }
  self.tableView.tableFooterView = view;
}
- (void)buttonChatAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnJOQAction:(id)sender {
    [self showAlerWithtitle:@"确定退出群组？" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //判断如果当前群组已经解散，直接删除消息和会话，并跳转到会话列表页面。
            if ([_Group.isDismiss isEqualToString:@"YES"]) {
                [[RCIMClient sharedRCIMClient]clearMessages:ConversationType_GROUP targetId:groupId];
                [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:groupId];
                [[RCDataBaseManager shareInstance]deleteGroupToDB:groupId];
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
            [RCDHTTPTOOL quitGroupWithGroupId:groupId complete:^(BOOL isOk) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (isOk) {
                         [[RCIMClient sharedRCIMClient]clearMessages:ConversationType_GROUP targetId:groupId];
                        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:groupId];
                         [[RCDataBaseManager shareInstance]deleteGroupToDB:groupId];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     } else {
                         NSLog(@"退出失败!");
                     }
                 });
             }];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    } ac3:nil completion:nil];
}
- (void)btnDismissAction:(id)sender {
    [self showAlerWithtitle:@"确定解散群组？" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [RCDHTTPTOOL dismissGroupWithGroupId:groupId complete:^(BOOL isOk) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (isOk) {
                         [[RCIMClient sharedRCIMClient]clearMessages:ConversationType_GROUP targetId:groupId];
                         [[RCIMClient sharedRCIMClient]removeConversation:ConversationType_GROUP targetId:groupId];
                         [[RCDataBaseManager shareInstance] deleteGroupToDB:groupId];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     } else {
                         NSLog(@"解散群组失败！");
                     }
                 });
             }];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    } ac3:nil completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [UIApplication sharedApplication].statusBarHidden = NO;
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  if ([mediaType isEqual:@"public.image"]) {
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect captureRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    UIImage *captureImage = [self getSubImage:originImage Rect:captureRect imageOrientation:originImage.imageOrientation];
    UIImage *scaleImage = [self scaleImage:captureImage toScale:0.8];
    data = UIImageJPEGRepresentation(scaleImage, 0.00001);
  }
  image = [UIImage imageWithData:data];
  [self dismissViewControllerAnimated:YES completion:nil];
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.color = [FreedomTools colorWithRGBHex:0x343637];
  hud.labelText = @"上传头像中...";
  [hud show:YES];
   __weak typeof(self) weakSelf = self;
  [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId ImageData:data success:^(NSString *url) {
        RCGroup *groupInfo = [RCGroup new];
        groupInfo.groupId = weakSelf.Group.groupId;
        groupInfo.portraitUri = url;
        groupInfo.groupName = weakSelf.Group.groupName;
        weakSelf.Group.portraitUri = url;
        [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupInfo.groupId];
        [RCDHTTPTOOL setGroupPortraitUri:url groupId:weakSelf.Group.groupId complete:^(BOOL result) {
          if (result == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
              RCDBaseSettingTableViewCell *cell = (RCDBaseSettingTableViewCell *)[self.tableView viewWithTag:1000];
                [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.Group.portraitUri]];
              //在修改群组头像成功后，更新本地数据库。
              [[RCDataBaseManager shareInstance] insertGroupToDB:self.Group];
//              cell.PortraitImg.image = image;
              //关闭HUD
              [hud hide:YES];
            });
          }
          if (result == NO) {
            //关闭HUD
            [hud hide:YES];
              NSLog(@"上传头像失败");
          }
        }];
      }failure:^(NSError *err) {
        //关闭HUD
        [hud hide:YES];
          NSLog(@"上传头像失败");
      }];
  dispatch_async(dispatch_get_main_queue(), ^{
    RCDBaseSettingTableViewCell *cell = (RCDBaseSettingTableViewCell *)[self.tableView viewWithTag:RCDGroupSettingsTableViewCellGroupPortraitTag];
      [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.Group.portraitUri]];
//    cell.PortraitImg.image = image;
  });
}
-(UIImage*)getSubImage:(UIImage *)originImage Rect:(CGRect)rect imageOrientation:(UIImageOrientation)imageOrientation{
  CGImageRef subImageRef = CGImageCreateWithImageInRect(originImage.CGImage, rect);
  CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
  UIGraphicsBeginImageContext(smallBounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, smallBounds, subImageRef);
  UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1.f orientation:imageOrientation];
  UIGraphicsEndImageContext();
  return smallImage;
}
- (UIImage *)scaleImage:(UIImage *)Image toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(CGSizeMake(Image.size.width * scaleSize, Image.size.height * scaleSize));
  [Image drawInRect:CGRectMake(0, 0, Image.size.width * scaleSize,Image.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}
- (void)chosePortrait {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController
                 isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                NSLog(@"模拟器无法连接相机");
            }
            [self presentViewController:picker animated:YES completion:nil];
        }];
    } ac3:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
    } completion:nil];
}
- (void)clearCacheAlertMessage:(NSString *)msg {
    NSLog(msg);
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (numberOfSections > 0) {
    return numberOfSections;
  }
  return 0;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  NSInteger rows;
  switch (section) {
  case 0:rows = 1;break;
  case 1:rows = 3;break;
  case 2:rows = 1;break;
  case 3:rows = 3;break;
  default:rows = 0;break;
  }
  return rows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDGroupSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[RCDGroupSettingsTableViewCell alloc]initWithIndexPath:indexPath andGroupInfo:_Group];
    }
    //设置switchbutton的开关状态
    if(indexPath.section == 3 && indexPath.row == 0){
        cell.switchButton.on = !enableNotification;
    }else if (indexPath.section ==3 && indexPath.row == 1){
        cell.switchButton.on = currentConversation.isTop;
    }
    cell.baseSettingTableViewDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return 0;
  }
  return 14.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 44.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:{
      RCDGroupMembersTableViewController *GroupMembersVC = [[RCDGroupMembersTableViewController alloc] init];
      NSMutableArray *groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:_Group.groupId];
      groupMemberList = [self moveCreator:groupMemberList];
      GroupMembersVC.GroupMembers = groupMemberList;
      [self.navigationController pushViewController:GroupMembersVC animated:YES];
    }break;
    case 1:{
      switch (indexPath.row) {
        case 0:{
          if (isCreator == YES) {
            [self chosePortrait];
          }else{
            [self showAlert:@"只有群主可以修改群组头像"];
          }
        }break;
        case 1:{
          if (isCreator == YES) {
              //如果是创建者，进入修改群名称页面
              RCDEditGroupNameViewController *editGroupNameVC = [RCDEditGroupNameViewController editGroupNameViewController];
              editGroupNameVC.groupInfo = _Group;
            [self.navigationController pushViewController:editGroupNameVC animated:YES];
          }else{
            [self showAlert:@"只有群主可以修改群组名称"];
          }
        }break;
          case 2:{
          RCDGroupAnnouncementViewController *vc = [[RCDGroupAnnouncementViewController alloc] init];
          vc.GroupId = _Group.groupId;
          [self.navigationController pushViewController:vc animated:YES];
          /*
          if (isCreator == YES) {
            RCDGroupAnnouncementViewController *vc = [[RCDGroupAnnouncementViewController alloc] init];
            vc.GroupId = _Group.groupId;
            [self.navigationController pushViewController:vc animated:YES];
          }else{
            [self showAlert:@"只有群主可以发布群公告"];
          }
           */
        }break;
        default:break;
      }
    }break;
    case 2:{
      RCDSearchHistoryMessageController *searchViewController = [[RCDSearchHistoryMessageController alloc] init];
      searchViewController.conversationType = ConversationType_GROUP;
      searchViewController.targetId = self.Group.groupId;
      [self.navigationController pushViewController:searchViewController animated:YES];
    }break;
      case 3:{
      switch (indexPath.row) {
        case 2:{
            [self showAlerWithtitle:@"确定清除聊天记录？" message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
                return [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                    RCDBaseSettingTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    UIActivityIndicatorView *activityIndicatorView =
                    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    float cellWidth = cell.bounds.size.width;
                    UIView *loadingView = [[UIView alloc]initWithFrame:CGRectMake(cellWidth - 50, 10, 40, 40)];
                    [loadingView addSubview:activityIndicatorView];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [activityIndicatorView startAnimating];
                        [cell addSubview:loadingView];
                    });
                    [[RCIMClient sharedRCIMClient]deleteMessages:ConversationType_GROUP targetId:groupId success:^{
                        [self performSelectorOnMainThread:@selector(clearCacheAlertMessage:)
                                               withObject:@"清除聊天记录成功！"
                                            waitUntilDone:YES];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"ClearHistoryMsg" object:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [loadingView removeFromSuperview];
                        });
                    } error:^(RCErrorCode status) {
                        [self performSelectorOnMainThread:@selector(clearCacheAlertMessage:)
                                               withObject:@"清除聊天记录失败！"
                                            waitUntilDone:YES];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [loadingView removeFromSuperview];
                        });
                    }];
                }];
            } ac2:^UIAlertAction *{
                return [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            } ac3:nil completion:nil];
        }break;
          
        default:
          break;
      }
    }break;
    default:
      break;
  }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  float width = 55;
  float height = width + 15 + 9;
  return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
  return 12;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
  flowLayout.minimumInteritemSpacing = 20;
  flowLayout.minimumLineSpacing = 12;
  return UIEdgeInsetsMake(15, 10, 10, 10);
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [collectionViewResource count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  RCDConversationSettingTableViewHeaderItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItem" forIndexPath:indexPath];
  if (collectionViewResource.count > 0) {
    if (indexPath.row == 0) {
    collectionViewResource = [self moveCreator:collectionViewResource];
    }
    if (![collectionViewResource[indexPath.row] isKindOfClass:[UIImage class]]) {
      RCUserInfo *user = collectionViewResource[indexPath.row];
      if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        [cell.btnImg setHidden:YES];
      }
      [cell setUserModel:user];
    } else {
      RCDConversationSettingTableViewHeaderItem *cellForSigns = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItemForSigns" forIndexPath:indexPath];
        UIImage *Image = collectionViewResource[indexPath.row];
        cellForSigns.ivAva.image = nil;
        cellForSigns.ivAva.image = Image;
        cellForSigns.titleLabel.text = @"";
        return cellForSigns;
    }
  }
  cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
  return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RCDContactSelectedTableViewController * contactSelectedVC= [[RCDContactSelectedTableViewController alloc]init];
  contactSelectedVC.groupId = _Group.groupId;
  contactSelectedVC.isAllowsMultipleSelection = YES;
  NSMutableArray *membersId = [NSMutableArray new];
  NSMutableArray *groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:_Group.groupId];
  for (id user in groupMemberList) {
    if ([user isKindOfClass:[RCUserInfo class]]) {
      NSString *userId = ((RCUserInfo*)user).userId;
      [membersId addObject:userId];
    }
  }
  //判断如果是创建者
  if (isCreator == YES) {
    //点加号
    if (indexPath.row == collectionViewResource.count - 2) {
      contactSelectedVC.titleStr = @"选择联系人";
      contactSelectedVC.addGroupMembers = membersId;
      [self.navigationController pushViewController:contactSelectedVC animated:YES];
      return;
    }
    //点减号
    if (indexPath.row == collectionViewResource.count - 1) {
      if (collectionViewResource.count == 3) {
        return;
      }
      contactSelectedVC.titleStr = @"移除成员";
      NSMutableArray *members = [NSMutableArray new];
      for (id user in groupMemberList) {
        if ([user isKindOfClass:[RCUserInfo class]]) {
          if (![((RCUserInfo *)user).userId isEqualToString:creatorId]) {
            [members addObject:user];
          }
        }
      }
      contactSelectedVC.delGroupMembers = members;
      [self.navigationController pushViewController:contactSelectedVC
                                           animated:YES];
      return;
    }
  } else {
    if (indexPath.row == collectionViewResource.count - 1) {
      NSLog(@"点加号");
      contactSelectedVC.titleStr = @"选择联系人";
      contactSelectedVC.addGroupMembers = membersId;
      [self.navigationController pushViewController:contactSelectedVC animated:YES];
      return;
    }
  }
  RCUserInfo *selectedUser = [collectionViewResource objectAtIndex:indexPath.row];
  BOOL isFriend = NO;
  NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
  for (RCDUserInfo *friend in friendList) {
    if ([selectedUser.userId isEqualToString:friend.userId] &&
        [friend.status isEqualToString:@"20"]) {
      isFriend = YES;
    }
  }
  if (isFriend == YES ||
      [selectedUser.userId
       isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc]init];
        [self.navigationController pushViewController:detailViewController animated:YES];
        RCUserInfo *user = [collectionViewResource objectAtIndex:indexPath.row];
        detailViewController.userId = user.userId;
  } else {
      RCDAddFriendViewController *addViewController = [[RCDAddFriendViewController alloc]init];
      addViewController.targetUserInfo = [collectionViewResource objectAtIndex:indexPath.row];
      [self.navigationController pushViewController:addViewController animated:YES];
  }
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
  RCMessage *message = notification.object;
  if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
    RCGroupNotificationMessage *groupNotification = (RCGroupNotificationMessage *)message.content;
    if ([groupNotification.operation isEqualToString:@"Dismiss"]) {
      return;
    } else if ([groupNotification.operation isEqualToString:@"Quit"] || [groupNotification.operation isEqualToString:@"Add"] || [groupNotification.operation isEqualToString:@"Kicked"]) {
      [RCDHTTPTOOL getGroupMembersWithGroupId:message.targetId Block:^(NSMutableArray *result) {
          [[RCDataBaseManager shareInstance]insertGroupMemberToDB:result groupId:message.targetId complete:^(BOOL results) {
             dispatch_async(dispatch_get_main_queue(), ^{
               self.title = [NSString stringWithFormat:@"群组信息(%lu)",(unsigned long)result.count];
               [self refreshHeaderView];
               [self refreshTabelViewInfo];
             });
           }];
        }];
    } else if ([groupNotification.operation isEqualToString:@"Rename"]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTabelViewInfo];
      });
    }
  }
}
- (void)refreshTabelViewInfo {
  [RCDHTTPTOOL getGroupByID:groupId successCompletion:^(RCDGroupInfo *group) {
    dispatch_async(dispatch_get_main_queue(), ^{
      _Group = group;
      [self.tableView reloadData];
    });
  }];
}
- (void)refreshHeaderView {
  NSMutableArray *groupMemberList = [[RCDataBaseManager shareInstance] getGroupMember:groupId];
  collectionViewResource = [[NSMutableArray alloc] initWithArray:groupMemberList];
  [self setHeaderView];
}
- (void)limitDisplayMemberCount {
  if (isCreator == YES && [collectionViewResource count] > 18) {
    NSRange rang = NSMakeRange(18, [collectionViewResource count] - 18);
    [collectionViewResource removeObjectsInRange:rang];
  } else if ([collectionViewResource count] > 19) {
    NSRange rang = NSMakeRange(19, [collectionViewResource count] - 19);
    [collectionViewResource removeObjectsInRange:rang];
  }
}
-(void)showAlert:(NSString *)alertContent{
    NSLog(alertContent);
}
//将创建者挪到第一的位置
-(NSMutableArray *) moveCreator:(NSMutableArray *)GroupMemberList{
  if (GroupMemberList ==nil || GroupMemberList.count == 0) {
    return nil;
  }
  NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:GroupMemberList];
  int index = 0;
  RCUserInfo *creator;
  for (int i = 0; i < [temp count]; i++) {
    RCUserInfo *user = [temp objectAtIndex:i];
    if ([creatorId isEqualToString:user.userId]) {
      index = i;
      creator = user;
      break;
    }
  }
  if (creator == nil) {
    return nil;
  }
  [temp insertObject:creator atIndex:0];
  [temp removeObjectAtIndex:index+1];
  return temp;
}
- (void)setHeaderView{
  [self limitDisplayMemberCount];
  UIImage *addImage = [UIImage imageNamed:@"add_member"];
  [collectionViewResource addObject:addImage];
  //判断如果是创建者，添加踢人按钮
  if (isCreator == YES) {
    UIImage *delImage = [UIImage imageNamed:@"delete_member"];
    [collectionViewResource addObject:delImage];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [headerView reloadData];
    headerView.frame = CGRectMake(0, 0, APPW,headerView.collectionViewLayout.collectionViewContentSize.height);
    CGRect frame = headerView.frame;
    frame.size.height += 14;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    [self.tableView.tableHeaderView addSubview:headerView];
      UIView *separatorLine = [[UIView alloc]initWithFrame:CGRectMake(10, frame.size.height-1, frame.size.width-10, 1)];
      separatorLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
      [self.tableView.tableHeaderView addSubview:separatorLine];
  });
}
#pragma mark - RCDBaseSettingTableViewCellDelegate
- (void)onClickSwitchButton:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    //如果是“消息免打扰”的switch点击
    if(switchBtn.tag == SwitchButtonTag){
        [self clickNotificationBtn:sender];
    }else { //否则是“会话置顶”的switch点击
        [self clickIsTopBtn:sender];
    }
}
@end
