//
//  RCDCreateGroupViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/3/21.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDCreateGroupViewController.h"
#import "MBProgressHUD.h"
#import "RCDHttpTool.h"
#import "RCloudModel.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDChatViewController.h"
// 是否iPhone5
#define isiPhone5                                                              \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
       ? CGSizeEqualToSize(CGSizeMake(640, 1136),                              \
                           [[UIScreen mainScreen] currentMode].size)           \
       : NO)
// 是否iPhone4
#define isiPhone4                                                              \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
       ? CGSizeEqualToSize(CGSizeMake(640, 960),                               \
                           [[UIScreen mainScreen] currentMode].size)           \
       : NO)
@interface RCDGroupMemberCollectionViewCell : UICollectionViewCell
@property(strong, nonatomic) UIImageView *PortraitImageView;
@property(strong, nonatomic) UILabel *NicknameLabel;
@end
@implementation RCDGroupMemberCollectionViewCell
@end
@interface RCDCreateGroupViewController () {
  NSData *data;
  UIImage *image;
  //    NSMutableArray *memberIdsList;
  MBProgressHUD *hud;
  CGFloat deafultY;
}
@property (nonatomic,strong) UIView *blueLine;
@end
@implementation RCDCreateGroupViewController
+ (instancetype)createGroupViewController {
    return [[[self class] alloc] init];
}
- (instancetype)init {
    self= [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
    self.DoneBtn.hidden = YES;
    //群组头像的UIImageView
    CGFloat groupPortraitWidth = 100;
    CGFloat groupPortraitHeight = groupPortraitWidth;
    CGFloat groupPortraitX = APPW/2.0-groupPortraitWidth/2.0;
    CGFloat groupPortraitY = 80;
    self.GroupPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(groupPortraitX, groupPortraitY, groupPortraitWidth, groupPortraitHeight)];
    self.GroupPortrait.image = [UIImage imageNamed:@"AddPhotoDefault"];
    self.GroupPortrait.layer.masksToBounds = YES;
    self.GroupPortrait.layer.cornerRadius = 5.f;
    //为头像设置点击事件
    self.GroupPortrait.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chosePortrait)];
    [self.GroupPortrait addGestureRecognizer:singleClick];
    //群组名称的UITextField
    CGFloat groupNameWidth = 200;
    CGFloat groupNameHeight = 17;
    CGFloat groupNameX = APPW/2.0-groupNameWidth/2.0;
    CGFloat groupNameY = CGRectGetMaxY(self.GroupPortrait.frame)+120;
    self.GroupName = [[UITextField alloc]initWithFrame:CGRectMake(groupNameX, groupNameY, groupNameWidth, groupNameHeight)];
    self.GroupName.font = [UIFont systemFontOfSize:14];
    self.GroupName.placeholder = @"填写群名称（2-10个字符）";
    self.GroupName.textAlignment = NSTextAlignmentCenter;
    self.GroupName.delegate = self;
    self.GroupName.returnKeyType = UIReturnKeyDone;
    //底部蓝线
    CGFloat blueLineWidth = 240;
    CGFloat blueLineHeight = 1;
    CGFloat blueLineX = APPW/2.0-blueLineWidth/2.0;
    CGFloat blueLineY = CGRectGetMaxY(self.GroupName.frame)+1;
    self.blueLine = [[UIView alloc]initWithFrame:CGRectMake(blueLineX, blueLineY, blueLineWidth, blueLineHeight)];
    self.blueLine.backgroundColor = [UIColor colorWithRed:0 green:135/255.0 blue:251/255.0 alpha:1];
    [self.view addSubview:self.GroupPortrait];
    [self.view addSubview:self.GroupName];
    [self.view addSubview:self.blueLine];
    //给整个view添加手势，隐藏键盘
    UITapGestureRecognizer *resetBottomTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:resetBottomTapGesture];
    //创建rightBarButtonItem
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(ClickDoneBtn:)];
    item.tintColor = [RCIM sharedRCIM].globalNavigationBarTintColor;
    self.navigationItem.rightBarButtonItem = item;
    CGFloat navHeight = 44.0f;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    deafultY = navHeight + statusBarHeight;
}
- (void)viewDidLoad {
  [super viewDidLoad];
//    deafultY = self.navigationController.navigationBar.frame.size.height +
//    [[UIApplication sharedApplication] statusBarFrame].size.height;
  // Do any additional setup after loading the view.
//  self.DoneBtn.hidden = YES;
//
//  self.GroupPortrait.layer.masksToBounds = YES;
//  self.GroupPortrait.layer.cornerRadius = 5.f;
//
//  //为头像设置点击事件
//  self.GroupPortrait.userInteractionEnabled = YES;
//  UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chosePortrait)];
//  [self.GroupPortrait addGestureRecognizer:singleClick];
//
//  //    //动态取邀请成员的数量
//  //    NSInteger membersCount = [self.GroupMemberList count];
//  //    self.InviteMemberCount.text = [NSString
//  //    stringWithFormat:@"被邀请成员(%ld)",(long)membersCount];
//  //
//  //    self.GroupMembers.backgroundColor = [UIColor clearColor];
//  //
//  //    memberIdsList = [[NSMutableArray alloc] init];
//
//  _GroupName.delegate = self;
//  _GroupName.returnKeyType = UIReturnKeyDone;
//
//  UITapGestureRecognizer *resetBottomTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
//  [self.view addGestureRecognizer:resetBottomTapGesture];
//
//  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(ClickDoneBtn:)];
//  item.tintColor = [RCIM sharedRCIM].globalNavigationBarTintColor;
//  self.navigationItem.rightBarButtonItem = item;
//  deafultY = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if (isiPhone5) {
    [self moveView:-40];
  }
  if (isiPhone4) {
    [self moveView:-80];
  }
  return YES;
}
- (void)ClickDoneBtn:(id)sender {
  self.navigationItem.rightBarButtonItem.enabled = NO;
  [self moveView:deafultY];
  [_GroupName resignFirstResponder];
  NSString *nameStr = [self.GroupName.text copy];
  nameStr = [nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  //群组名称需要大于2位
  if ([nameStr length] == 0) {
    [self Alert:@"群组名称不能为空"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
  }
  //群组名称需要大于2个字
  else if ([nameStr length] < 2) {
    [self Alert:@"群组名称过短"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
  }
  //群组名称需要小于10个字
  else if ([nameStr length] > 10) {
    [self Alert:@"群组名称不能超过10个字"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
  } else {
    BOOL isAddedcurrentUserID = false;
    for (NSString *userId in _GroupMemberIdList) {
      if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        isAddedcurrentUserID = YES;
      } else {
        isAddedcurrentUserID = NO;
      }
    }
    if (isAddedcurrentUserID == NO) {
      [_GroupMemberIdList addObject:[RCIM sharedRCIM].currentUserInfo.userId];
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [FreedomTools colorWithRGBHex:0x343637];
    hud.labelText = @"创建中...";
    [hud show:YES];
    [[RCDHttpTool shareInstance]createGroupWithGroupName:nameStr GroupMemberList:_GroupMemberIdList complete:^(NSString *groupId) {
       if (groupId) {
         [RCDHTTPTOOL getGroupMembersWithGroupId:groupId Block:^(NSMutableArray *result) {
                                             //更新本地数据库中群组成员的信息
           }];
         if (image != nil) {
           [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId ImageData:data success:^(NSString *url) {
              RCGroup *groupInfo = [RCGroup new];
              groupInfo.portraitUri = url;
              groupInfo.groupId = groupId;
              groupInfo.groupName = nameStr;
              dispatch_async(dispatch_get_main_queue(), ^{
                [RCDHTTPTOOL setGroupPortraitUri:url groupId:groupId complete:^(BOOL result) {
                   [[RCIM sharedRCIM] refreshGroupInfoCache: groupInfo withGroupId:groupId];
                   if (result == YES) {
                     [self gotoChatView:groupInfo.groupId groupName:groupInfo.groupName];
                     //关闭HUD
                     [hud hide:YES];
                     [RCDHTTPTOOL getGroupByID:groupInfo.groupId successCompletion:^(RCDGroupInfo *group) {
                               [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                        }];
                   }
                   if (result == NO) {
                     self.navigationItem.rightBarButtonItem.enabled = YES; //关闭HUD
                     [hud hide:YES];
                     [self Alert:@"创建群组失败，请检查你的网络设置。"];
                   }
                 }];
              });
            }failure:^(NSError *err) {
              self.navigationItem.rightBarButtonItem.enabled = YES;
              //关闭HUD
              [hud hide:YES];
              [self Alert:@"创建群组失败，请检查你的网络设置。"];
            }];
         } else {
           RCGroup *groupInfo = [RCGroup new];
           groupInfo.portraitUri = [self createDefaultPortrait:groupId GroupName:nameStr];
           groupInfo.groupId = groupId;
           groupInfo.groupName = nameStr;
           [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupId];
           [RCDHTTPTOOL getGroupByID:groupInfo.groupId successCompletion:^(RCDGroupInfo *group) {
                     [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                   }];
           [self gotoChatView:groupInfo.groupId groupName:groupInfo.groupName];
         }
       } else {
         [hud hide:YES];
         self.navigationItem.rightBarButtonItem.enabled = YES;
         [self Alert:@"创建群组失败，请检查你的网络设置。"];
       }
     }];
  }
}
- (void)gotoChatView:(NSString *)groupId groupName:(NSString *)groupName{
  RCDChatViewController *chatVC = [[RCDChatViewController alloc] init];
  chatVC.needPopToRootView = YES;
  chatVC.targetId = groupId;
  chatVC.conversationType = ConversationType_GROUP;
  chatVC.csInfo.nickName = groupName;
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.navigationController pushViewController:chatVC animated:YES];
  });
}
- (void)Alert:(NSString *)alertContent {
    [SVProgressHUD showInfoWithStatus:alertContent];
}
- (void)chosePortrait {
  [self moveView:deafultY];
  [_GroupName resignFirstResponder];
    [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
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
  dispatch_async(dispatch_get_main_queue(), ^{
    self.GroupPortrait.image = image;
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
  [Image drawInRect:CGRectMake(0, 0, Image.size.width * scaleSize, Image.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [_GroupName resignFirstResponder];
  [self moveView:deafultY];
  return YES;
}
- (void)hideKeyboard:(id)sender {
  [self moveView:deafultY];
  [_GroupName resignFirstResponder];
}
//移动屏幕
- (void)moveView:(CGFloat)Y {
  [UIView beginAnimations:nil context:nil];
  self.view.frame = CGRectMake(0, Y, self.view.frame.size.width, self.view.frame.size.height);
  [UIView commitAnimations];
}
- (NSString *)createDefaultPortrait:(NSString *)groupId GroupName:(NSString *)groupName {
  UIView *defaultPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    defaultPortrait.backgroundColor = [UIColor redColor];
    NSString *firstLetter = [ChineseToPinyin firstPinyinFromChinise:groupName];
    UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
    firstCharacterLabel.text = firstLetter;
    firstCharacterLabel.textColor = [UIColor whiteColor];
    firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
    firstCharacterLabel.font = [UIFont systemFontOfSize:50];
    [defaultPortrait addSubview:firstCharacterLabel];
  UIImage *portrait = [defaultPortrait imageFromView];
  NSString *filePath = [self getIconCachePath:[NSString stringWithFormat:@"group%@.png", groupId]];
  BOOL result = [UIImagePNGRepresentation(portrait) writeToFile:filePath atomically:YES];
  if (result == YES) {
    NSURL *portraitPath = [NSURL fileURLWithPath:filePath];
    return [portraitPath absoluteString];
  }
  return nil;
}
- (NSString *)getIconCachePath:(NSString *)fileName {
  NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  NSString *filePath = [cachPath stringByAppendingPathComponent: [NSString stringWithFormat:@"CachedIcons/%@",fileName]]; // 保存文件的名称
  NSString *dirPath = [cachPath stringByAppendingPathComponent:[NSString stringWithFormat:@"CachedIcons"]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:dirPath]) {
    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  return filePath;
}
@end
