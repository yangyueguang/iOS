//  FreedomDetailViewController.m
//  Freedom
// Created by Super
#import "WXChatDetailViewController.h"
#import "WXFriendDetailViewController.h"
#import "WXMessageManager.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WXUserGroupCell.h"
#import "WXChatViewController.h"
#import "WXChatFileViewController.h"
#import "WXBgSettingViewController.h"
@interface WXChatDetailViewController () <WechatUserGroupCellDelegate>
@property (nonatomic, strong) WXMessageManager *helper;
@end
@implementation WXChatDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天详情"];
    
    self.helper = [WXMessageManager sharedInstance];
    self.data = [self.helper chatDetailDataByUserInfo:self.user];
    
    [self.tableView registerClass:[WXUserGroupCell class] forCellReuseIdentifier:@"TLUserGroupCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        WXUserGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLUserGroupCell"];
        [cell setUsers:[NSMutableArray arrayWithArray:@[self.user]]];
        [cell setDelegate:self];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"聊天文件"]) {
        WXChatFileViewController *chatFileVC = [[WXChatFileViewController alloc] init];
        [chatFileVC setPartnerID:self.user.userID];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatFileVC animated:YES];
    }else if ([item.title isEqualToString:@"设置当前聊天背景"]) {
        WXBgSettingViewController *chatBGSettingVC = [[WXBgSettingViewController alloc] init];
        [chatBGSettingVC setPartnerID:self.user.userID];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatBGSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"清空聊天记录"]) {
        [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"清空聊天记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                BOOL ok = [[WXMessageManager sharedInstance] deleteMessagesByPartnerID:self.user.userID];
                if (!ok) {
                    [SVProgressHUD showErrorWithStatus:@"清空聊天记录失败"];
                }else{
                    [[WXChatViewController sharedChatVC] resetChatVC];
                }
            }];
        } ac2:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
        } ac3:nil completion:nil];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSUInteger count = self.user ? 1 : 0;
        return ((count + 1) / 4 + ((((count + 1) % 4) == 0) ? 0 : 1)) * 90 + 15;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
//MARK: TLUserGroupCellDelegate
- (void)userGroupCellDidSelectUser:(WXUser *)user{
    WXFriendDetailViewController *detailVC = [[WXFriendDetailViewController alloc] init];
    [detailVC setUser:user];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)userGroupCellAddUserButtonDown{
    [SVProgressHUD showInfoWithStatus:@"添加讨论组成员"];
}
@end
