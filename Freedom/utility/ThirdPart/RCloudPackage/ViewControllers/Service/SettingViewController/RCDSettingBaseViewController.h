//
//  RCDSettingBaseViewController.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/7/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
#import "RCDConversationSettingBaseViewController.h"
#import <UIKit/UIKit.h>
typedef void(^rcdClearHistory)(BOOL isSuccess);
@interface RCDSettingBaseViewController: RCDConversationSettingBaseViewController
@property(nonatomic, copy) NSString *targetId;
@property(nonatomic, assign) RCConversationType conversationType;
/**
 *  清除历史消息后，会话页面调用roload data
 */
@property(nonatomic, copy) rcdClearHistory clearHistoryCompletion;
//@property(nonatomic, readonly, strong)UIActionSheet *clearMsgHistoryActionSheet;
- (void)clearHistoryMessage;
/**
 *  override 如果显示headerView时，最后一个+号点击事件
 *  @param settingTableViewHeader  settingTableViewHeader description
 *  @param indexPathOfSelectedItem indexPathOfSelectedItem description
 *  @param users                   所有在headerView中的user
 */
- (void)settingTableViewHeader:(RCDConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;
/**
 *  override 如果显示headerView时，所点击的-号事件
 *  @param indexPath 所点击左上角-号的索引
 */
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;
@end
