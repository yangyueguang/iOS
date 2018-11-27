//
//  RCDMeInfoTableViewController.m
//  RCloudMessage
//
//  Created by litao on 15/11/4.
//  Copyright © 2015年 RongCloud. All rights reserved.
//
#import "RCDMeInfoTableViewController.h"
#import "MBProgressHUD.h"
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDBaseSettingTableViewCell.h"
#import "AFHttpTool.h"
#import "MBProgressHUD.h"
#import "RCDChatViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import <RongIMLib/RongIMLib.h>
@interface RCDEditUserNameViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *userName;
@property(nonatomic, strong) UIView *BGView;
@end
@interface RCDEditUserNameViewController ()
@property(nonatomic, strong) NSDictionary *subViews;
@property (nonatomic, strong) UIBarButtonItem *rightBtn;
@property (nonatomic, strong) UIBarButtonItem *leftBtn;
@property (nonatomic, strong) NSString *nickName;
@end
@implementation RCDEditUserNameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[RCDRCIMDataSource shareInstance]
     getUserInfoWithUserId:[RCIMClient sharedRCIMClient].currentUserInfo.userId
     completion:^(RCUserInfo *userInfo) {
         dispatch_async(dispatch_get_main_queue(), ^{
             self.userName.text = userInfo.name;
             self.nickName = self.userName.text;
         });
     }];
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f6];
    [self setNavigationButton];
    [self setSubViews];
    self.navigationItem.title = @"昵称修改";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:self.userName];
}
- (void)saveUserName:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"修改中...";
    [hud show:YES];
    __weak __typeof(&*self) weakSelf = self;
    NSString *errorMsg = @"";
    if (self.userName.text.length == 0) {
        errorMsg = @"用户名不能为空!";
    } else if (self.userName.text.length > 32) {
        errorMsg = @"用户名不能大于32位!";
    }
    if ([errorMsg length] > 0) {
        [hud hide:YES];
        [SVProgressHUD showErrorWithStatus:errorMsg];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [defaults objectForKey:@"userId"];
        [AFHttpTool modifyNickname:userId nickname:weakSelf.userName.text success:^(id response) {
           if ([response[@"code"] intValue] == 200) {
               RCUserInfo *userInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
               userInfo.name = weakSelf.userName.text;
               [[RCDataBaseManager shareInstance] insertUserToDB:userInfo];
               [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
               [defaults setObject:weakSelf.userName.text forKey:@"userNickName"];
               [defaults synchronize];
               [weakSelf.navigationController popViewControllerAnimated:YES];
           }
       }failure:^(NSError *err) {
           [hud hide:YES];
           [SVProgressHUD showErrorWithStatus:@"修改失败，请检查输入的名称"];
       }];
    }
}
- (void)setNavigationButton {
    self.leftBtn = [FreedomTools barButtonItemContainImage:[UIImage imageNamed:@"navigator_btn_back"] imageViewFrame:CGRectMake(-6, 4, 10, 17) buttonTitle:@"返回" titleColor:[UIColor whiteColor] titleFrame:CGRectMake(9, 4, 85, 17) buttonFrame:CGRectMake(0, 6, 87, 23) target:self action:@selector(clickBackBtn)];
    self.navigationItem.leftBarButtonItem = self.leftBtn;
    self.rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserName:)];
    self.rightBtn.customView.userInteractionEnabled = NO;
    NSArray<UIBarButtonItem *> *barButtonItems;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    barButtonItems = [NSArray arrayWithObjects:negativeSpacer, self.rightBtn, nil];
    self.navigationItem.rightBarButtonItems = barButtonItems;
}
- (void)setSubViews {
    self.BGView = [UIView new];
    self.BGView.backgroundColor = [UIColor whiteColor];
    self.BGView.layer.borderWidth = 0.5;
    self.BGView.layer.borderColor = [[UIColor colorWithRGBHex:0xdfdfdf] CGColor];
    self.BGView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.BGView];
    UITapGestureRecognizer *clickBGView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEditNickname)];
    [self.BGView addGestureRecognizer:clickBGView];
    self.userName = [UITextField new];
    self.userName.borderStyle = UITextBorderStyleNone;
    self.userName.clearButtonMode = UITextFieldViewModeAlways;
    self.userName.font = [UIFont systemFontOfSize:16.f];
    self.userName.textColor = [UIColor colorWithRGBHex:0x000000];
    self.userName.delegate = self;
    self.userName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.BGView addSubview:self.userName];
    self.subViews = NSDictionaryOfVariableBindings(_BGView,_userName);
    [self.view
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:|-15-[_BGView(44)]"
                     options:0
                     metrics:nil
                     views:self.subViews]];
    [self.view
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[_BGView]|"
                     options:0
                     metrics:nil
                     views:self.subViews]];
    [self.BGView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|-9-[_userName]-3-|"
                     options:0
                     metrics:nil
                     views:self.subViews]];
    [self.BGView
     addConstraint:[NSLayoutConstraint constraintWithItem:_userName
                                                attribute:NSLayoutAttributeCenterY
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.BGView
                                                attribute:NSLayoutAttributeCenterY
                                               multiplier:1
                                                 constant:0]];
}
- (void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)beginEditNickname {
    [self.userName becomeFirstResponder];
}
-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (![toBeString isEqualToString:self.nickName]) {
        self.rightBtn.customView.userInteractionEnabled = YES;
    } else {
        self.rightBtn.customView.userInteractionEnabled = NO;
    }
}
@end
@interface RCDMeInfoTableViewController () {
    NSData *data;
    UIImage *image;
    MBProgressHUD *hud;
}
@end
@implementation RCDMeInfoTableViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
  self.tabBarController.navigationItem.rightBarButtonItem = nil;
  self.tabBarController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
  self.tableView.backgroundColor = [UIColor colorWithRGBHex:0xf0f0f6];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.navigationItem.title = @"个人信息";
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    [buttonItem setImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    [buttonItem setTitle:@"我" forState:UIControlStateNormal];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(cilckBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
  RCDBaseSettingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDBaseSettingTableViewCell alloc] init];
  }
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          NSString *portraitUrl = [defaults stringForKey:@"userPortraitUri"];
          if ([portraitUrl isEqualToString:@""]) {
            portraitUrl = [FreedomTools defaultUserPortrait:[RCIM sharedRCIM].currentUserInfo];
          }
          [cell setImageView:cell.rightImageView ImageStr:portraitUrl imageSize:CGSizeMake(65, 65) LeftOrRight:1];
          cell.rightImageCornerRadius = 5.f;
          cell.leftLabel.text = @"头像";
          return cell;
        }break;
        case 1: {
          [cell setCellStyle:DefaultStyle_RightLabel];
          cell.leftLabel.text = @"昵称";
          cell.rightLabel.text = [defaults stringForKey:@"userNickName"];
          return cell;
        }break;
        case 2: {
          [cell setCellStyle:DefaultStyle_RightLabel_WithoutRightArrow];
          cell.leftLabel.text = @"手机号";
          cell.rightLabel.text = [defaults stringForKey:@"userName"];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
        }break;
        default: break;
      }
    }break;
    default:break;
  }
  return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = 0;
  switch (indexPath.section) {
    case 0:{
      switch (indexPath.row) {
        case 0:height = 88.f;break;
        default:height = 44.f;break;
      }
    }break;
    default:break;
  }
  return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 15.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中
  switch (indexPath.row) {
    case 0: {
      if ([self dealWithNetworkStatus]) {
        [self changePortrait];
      }
    }break;
    case 1: {
      if ([self dealWithNetworkStatus]) {
        RCDEditUserNameViewController *vc = [[RCDEditUserNameViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
      }
    }break;
    default:break;
  }
}
- (void)changePortrait {
    [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = YES;
            picker.delegate = self;
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
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
  [UIApplication sharedApplication].statusBarHidden = NO;
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  if ([mediaType isEqual:@"public.image"]) {
    //获取原图
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取截取区域
     CGRect captureRect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
    //获取截取区域的图像
    UIImage *captureImage = [self getSubImage:originImage Rect:captureRect imageOrientation:originImage.imageOrientation];
    UIImage *scaleImage = [self scaleImage:captureImage toScale:0.8];
    data = UIImageJPEGRepresentation(scaleImage, 0.00001);
  }
  image = [UIImage imageWithData:data];
  [self dismissViewControllerAnimated:YES completion:nil];
  hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.color = [UIColor colorWithRGBHex:0x343637];
  hud.labelText = @"上传头像中...";
  [hud show:YES];
  [RCDHTTPTOOL uploadImageToQiNiu:[RCIM sharedRCIM].currentUserInfo.userId ImageData:data success:^(NSString *url) {
        [RCDHTTPTOOL setUserPortraitUri:url complete:^(BOOL result) {
            if (result == YES) {
              [RCIM sharedRCIM].currentUserInfo.portraitUri = url;
              RCUserInfo *userInfo = [RCIM sharedRCIM].currentUserInfo;
              userInfo.portraitUri = url;
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              [defaults setObject:url forKey:@"userPortraitUri"];
              [defaults synchronize];
              [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:[RCIM sharedRCIM].currentUserInfo.userId];
              [[RCDataBaseManager shareInstance]insertUserToDB:userInfo];
              [[NSNotificationCenter defaultCenter]postNotificationName:@"setCurrentUserPortrait" object:image];
              dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //关闭HUD
                [hud hide:YES];
              });
            }
            if (result == NO) {
              //关闭HUD
              [hud hide:YES];
                [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
            }
          }];
      }failure:^(NSError *err) {
        //关闭HUD
        [hud hide:YES];
          [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
      }];
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
- (UIImage *)scaleImage:(UIImage *)tempImage toScale:(float)scaleSize {
  UIGraphicsBeginImageContext(CGSizeMake(tempImage.size.width * scaleSize,tempImage.size.height * scaleSize));
  [tempImage drawInRect:CGRectMake(0, 0, tempImage.size.width * scaleSize,tempImage.size.height * scaleSize)];
  UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return scaledImage;
}
-(void)cilckBackBtn:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)dealWithNetworkStatus {
  BOOL isconnected = NO;
  RCNetworkStatus networkStatus = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
  if (networkStatus == 0) {
      [SVProgressHUD showErrorWithStatus:@"当前网络不可用，请检查你的网络设置"];
    return isconnected;
  }
  return isconnected = YES;
}
@end
