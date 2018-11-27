//
//  RCDConversationSettingBaseViewController.h
//  RCloudMessage
//
//  Created by 杜立召 on 15/7/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
#import <RongIMLib/RongIMLib.h>
@protocol RCDConversationSettingTableViewHeaderItemDelegate;
@interface RCDConversationSettingTableViewHeaderItem : UICollectionViewCell
@property(nonatomic, strong) UIImageView *ivAva;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *btnImg;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, weak) id<RCDConversationSettingTableViewHeaderItemDelegate> delegate;
- (void)setUserModel:(RCUserInfo *)userModel;
@end
@protocol RCDConversationSettingTableViewHeaderItemDelegate <NSObject>
- (void)deleteTipButtonClicked:(RCDConversationSettingTableViewHeaderItem *)item;
@end
@class RCDConversationSettingTableViewHeader;
@protocol RCDConversationSettingTableViewHeaderDelegate <NSObject>
@optional
/**
 *  设置选中item的回调操作
 *  @param settingTableViewHeader   settingTableViewHeader description
 *  @param indexPathForSelectedItem indexPathForSelectedItem description
 *  @param users users description
 */
- (void)settingTableViewHeader:(RCDConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;
///点击删除的回调
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;
///点击头像的回调
- (void)didTipHeaderClicked:(NSString *)userId;
@end
@interface RCDConversationSettingTableViewHeader: UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, assign) BOOL showDeleteTip;
@property(nonatomic, assign) BOOL isAllowedDeleteMember;
@property(nonatomic, assign) BOOL isAllowedInviteMember;
@property(weak, nonatomic) id<RCDConversationSettingTableViewHeaderDelegate>settingTableViewHeaderDelegate;
///contains the RCUserInfo
@property(strong, nonatomic) NSMutableArray *users;
@end
@class RCDConversationSettingTableViewHeader;
///会话设置页面
@interface RCDConversationSettingBaseViewController : UITableViewController
///内置置顶聊天，新消息通知，清除消息记录三个cell
@property(nonatomic, strong, readonly) NSArray *defaultCells;
///是否隐藏顶部视图
@property(nonatomic, assign) BOOL headerHidden;
///设置top switch
@property(nonatomic, assign) BOOL switch_isTop;
///新消息通知switchs
@property(nonatomic, assign) BOOL switch_newMessageNotify;
///设置顶部视图显示的users
@property(nonatomic, strong) NSMutableArray *users;
///禁用删除成员事件
- (void)disableDeleteMemberEvent:(BOOL)disable;
///禁用邀请成员事件
- (void)disableInviteMemberEvent:(BOOL)disable;
///重写以下方法，自定义点击事件
///置顶聊天
- (void)onClickIsTopSwitch:(id)sender;
///新消息通知
- (void)onClickNewMessageNotificationSwitch:(id)sender;
///清除聊天记录
- (void)onClickClearMessageHistory:(id)sender;
///添加users到顶部视图
- (void)addUsers:(NSArray *)users;
/**
 *  重写以下两个方法以实现顶部视图item点击事件
 *  @param settingTableViewHeader  settingTableViewHeader description
 *  @param indexPathOfSelectedItem indexPathOfSelectedItem description
 *  @param users                   users description
 */
- (void)settingTableViewHeader:
            (RCDConversationSettingTableViewHeader *)settingTableViewHeader
       indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem
            allTheSeletedUsers:(NSArray *)users;
///点击删除图标事件
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath;
///点击上面头像列表的头像
- (void)didTipHeaderClicked:(NSString *)userId;
@end
