//
//  RCDAboutRongCloudTableViewController.m
//  RCloudMessage
//
//  Created by litao on 15/4/27.
//  Copyright (c) 2015年 胡利武. All rights reserved.
//
#import "RCDAboutRongCloudTableViewController.h"
@implementation RCDAboutRongCloudTableViewController
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"select row %ld", indexPath.row);
    NSArray *section0 = [NSArray arrayWithObjects:@"http://rongcloud.cn/downloads/history/ios", @"http://rongcloud.cn/features",@"http://docs.rongcloud.cn/api/ios/imkit/index.html",nil];
    NSArray *section1 = [NSArray arrayWithObjects:@"http://rongcloud.cn/", @"http://rongcloud.cn/", nil];
    NSArray *urls = [NSArray arrayWithObjects:section0, section1, nil];
    NSString *urlString = urls[indexPath.section][indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
    }];
}
@end
