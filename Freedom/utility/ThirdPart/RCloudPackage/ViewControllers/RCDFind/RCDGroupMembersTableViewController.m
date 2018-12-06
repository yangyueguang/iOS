//
//  RCDGroupMembersTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/4/10.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDGroupMembersTableViewController.h"
#import "RCDAddFriendViewController.h"
#import "RCDContactTableViewCell.h"
#import "RCDPersonDetailViewController.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
@interface RCDGroupMembersTableViewController ()
@end
@implementation RCDGroupMembersTableViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
  self.title = [NSString stringWithFormat:@"群组成员(%lu)",(unsigned long)[_GroupMembers count]];
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    [buttonItem setImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    [buttonItem setTitle:@"返回" forState:UIControlStateNormal];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_GroupMembers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
  RCDContactTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDContactTableViewCell alloc] init];
  }
  RCDUserInfo *user = _GroupMembers[indexPath.row];
  if ([user.portraitUri isEqualToString:@""]) {
    UIView *defaultPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
      defaultPortrait.backgroundColor = [UIColor redColor];
      NSString *firstLetter = [user.name pinyinFirstLetter];
      UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
      firstCharacterLabel.text = firstLetter;
      firstCharacterLabel.textColor = [UIColor whiteColor];
      firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
      firstCharacterLabel.font = [UIFont systemFontOfSize:50];
      [defaultPortrait addSubview:firstCharacterLabel];
    UIImage *portrait = [defaultPortrait imageFromView];
    cell.portraitView.image = portrait;
  } else {
    [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"contact"]];
  }
  cell.portraitView.layer.masksToBounds = YES;
  cell.portraitView.layer.cornerRadius = 5.f;
  cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
  cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
  cell.nicknameLabel.text = user.name;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  RCUserInfo *user = _GroupMembers[indexPath.row];
  BOOL isFriend = NO;
  NSArray *friendList = [[RCDataBaseManager shareInstance] getAllFriends];
  for (RCDUserInfo *friend in friendList) {
    if ([user.userId isEqualToString:friend.userId] && [friend.status isEqualToString:@"20"]) {
      isFriend = YES;
    }
  }
  if (isFriend == YES || [user.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc]init];
    [self.navigationController pushViewController:detailViewController animated:YES];
    RCUserInfo *user = _GroupMembers[indexPath.row];
    detailViewController.userId = user.userId;
  } else {
      RCDAddFriendViewController *addViewController = [[RCDAddFriendViewController alloc]init];
    addViewController.targetUserInfo = _GroupMembers[indexPath.row];
    [self.navigationController pushViewController:addViewController animated:YES];
  }
}
- (void)clickBackBtn {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
