//
//  RCDSettingsTableViewController.m
//  RCloudMessage
//
//  Created by Liv on 14/11/20.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//
#import "RCDSettingsTableViewController.h"
#import "RCDataBaseManager.h"
#import "RCDChangePasswordViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDPrivacyTableViewController.h"
#import "RCDMessageNotifySettingTableViewController.h"
#import "RCDBaseSettingTableViewCell.h"
#import "RCDPushSettingViewController.h"
#import "Freedom-Swift.h"
#import "LanguageTableViewController.h"
@interface RCDSettingsTableViewController ()
@end
@implementation RCDSettingsTableViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  self.tableView.tableFooterView = [UIView new];
  self.tableView.backgroundColor = [FreedomTools colorWithRGBHex:0xf0f0f6];
  self.navigationItem.title = @"帐号设置";
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    [buttonItem setImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    [buttonItem setTitle:@"我" forState:UIControlStateNormal];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(cilckBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - Table view Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSUInteger row = 0;
  switch (section) {
    case 0:row = 5;break;
    case 1:row = 1;break;
    case 2:row = 1;break;
    default:break;
  }
  return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDBaseSettingTableViewCell";
  RCDBaseSettingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDBaseSettingTableViewCell alloc] init];
  }
  [cell setCellStyle:DefaultStyle];
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0: {
          cell.leftLabel.text = @"密码修改";
        }break;
        case 1: {
          cell.leftLabel.text = @"隐私";
        }break;
        case 2: {
          cell.leftLabel.text = @"新消息通知";
        }break;
        case 3: {
          cell.leftLabel.text = @"推送设置";
        }break;
        default:
              cell.leftLabel.text = @"语言设置";
              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
              cell.rightLabel.text = [defaults objectForKey:@"languageName"];
              break;
      }
    }break;
    case 1: {
    cell.leftLabel.text = @"清除缓存";
    }break;
    case 2: {
      return [self createQuitCell];
    }break;
    default:break;
  }
  return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 取消选中
  switch (indexPath.section) {
    case 0: {
      switch (indexPath.row) {
        case 0:{
          RCDChangePasswordViewController *vc = [[RCDChangePasswordViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 1:{
          RCDPrivacyTableViewController *vc = [[RCDPrivacyTableViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 2: {
          RCDMessageNotifySettingTableViewController *vc = [[RCDMessageNotifySettingTableViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 3: {
          RCDPushSettingViewController *vc = [[RCDPushSettingViewController alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
        }break;
        default:
          {
              LanguageTableViewController *languageVC = [[LanguageTableViewController alloc]initWithStyle:UITableViewStylePlain];
              UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:languageVC];

              languageVC.theLanguage = ^(NSIndexPath *index, NSString *name, NSString *code) {

                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  [defaults setObject:name forKey:@"languageName"];
                  [defaults setObject:code forKey:@"languageCode"];
                  [defaults synchronize];
                  [self.tableView reloadData];
              };
              languageVC.title = @"目标语言";
              [self presentViewController:navi animated:YES completion:nil];
          }
              break;
      }
    }break;
    case 1: {
      switch (indexPath.row) {
        case 0:{
          //清除缓存
            [self showAlerWithtitle:nil message:@"是否清理缓存？" style:UIAlertControllerStyleAlert ac1:^UIAlertAction *{
                return [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self clearCache];
                }];
            } ac2:^UIAlertAction *{
                return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
            } ac3:nil completion:nil];
        }break;
        default:break;
      }
    }break;
    case 2:{
      switch (indexPath.row) {
        case 0:{
          //退出登录
            [self showAlerWithtitle:nil message:@"是否退出登录？" style:UIAlertControllerStyleAlert ac1:^UIAlertAction *{
                return [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self logout];
                }];
            } ac2:^UIAlertAction *{
                return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
            } ac3:nil completion:nil];
        }break;
        default: break;
      }
    }
    default:break;
  }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
//清理缓存
- (void)clearCache {
  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //这里清除 Library/Caches 里的所有文件，融云的缓存文件及图片存放在 Library/Caches/RongCloud 下
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
          NSError *error;
          NSString *path = [cachPath stringByAppendingPathComponent:p];
          if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
          }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
      });
}
- (void)clearCacheSuccess {
    NSLog(@"缓存清理成功！");
}
//退出登录
- (void)logout {
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  //    [defaults removeObjectForKey:@"userName"];
  //    [defaults removeObjectForKey:@"userPwd"];
  [defaults removeObjectForKey:@"userToken"];
  [defaults removeObjectForKey:@"userCookie"];
  [defaults removeObjectForKey:@"isLogin"];
  [defaults synchronize];
  [[RCDataBaseManager shareInstance] closeDBForDisconnect];
  FreedomLoginViewController *loginVC = [[FreedomLoginViewController alloc] init];
  UINavigationController *navi =
      [[UINavigationController alloc] initWithRootViewController:loginVC];
  self.view.window.rootViewController = navi;
  [[RCIMClient sharedRCIMClient] logout];
  //[[RCIMClient sharedRCIMClient]disconnect:NO];
}
-(void)cilckBackBtn:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (UITableViewCell *)createQuitCell {
 UITableViewCell *quitCell = [[UITableViewCell alloc] init];
  UILabel *label = [[UILabel alloc] init];
  label.font = [UIFont systemFontOfSize:16];
  label.textColor = [FreedomTools colorWithRGBHex:0x000000];
  label.text = @"退出登录";
  label.translatesAutoresizingMaskIntoConstraints = NO;
  quitCell.contentView.layer.borderWidth = 0.5;
  quitCell.contentView.layer.borderColor = [[FreedomTools colorWithRGBHex:0xdfdfdf] CGColor];
  [quitCell setSeparatorInset:UIEdgeInsetsMake(0, 100, 0, 1000)];
  [quitCell.contentView addSubview:label];
  [quitCell.contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:label
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:quitCell.contentView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0]];
  
  [quitCell.contentView
   addConstraint:[NSLayoutConstraint constraintWithItem:label
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:quitCell.contentView
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1
                                               constant:0]];
  return quitCell;
}
@end
