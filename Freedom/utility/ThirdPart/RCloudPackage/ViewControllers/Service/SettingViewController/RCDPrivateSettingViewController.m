//
//  RCDPrivateViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//
#import "RCDPrivateSettingViewController.h"
@interface RCDPrivateSettingViewController ()
@end
@implementation RCDPrivateSettingViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = [UIView new];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.defaultCells[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  //覆盖父类实现，什么也不做
}
@end
