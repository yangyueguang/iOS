//  FreedomGroupDetailViewController.m
//  Freedom
// Created by Super
#import "WXCGroupDetailViewController.h"
#import "WXUserGroupCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "WXChatViewController.h"
#import "WXMessageManager.h"
#import "WXFriendDetailViewController.h"
#import "WXGroupQRCodeViewController.h"
#import "WXChatFileViewController.h"
#import "WXBgSettingViewController.h"
@interface WXCGroupDetailViewController () <WechatUserGroupCellDelegate>
@property (nonatomic, strong) WXMessageManager *helper;
@end
@implementation WXCGroupDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"聊天详情"];
    
    self.helper = [WXMessageManager sharedInstance];
    self.data = [self.helper chatDetailDataByGroupInfo:self.group];
    
    [self.tableView registerClass:[WXUserGroupCell class] forCellReuseIdentifier:@"TLUserGroupCell"];
}
#pragma mark - Delegate -
//MARK: UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        WXUserGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLUserGroupCell"];
        [cell setUsers:self.group.users];
        [cell setDelegate:self];
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
//MARK: UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WXSettingItem *item = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([item.title isEqualToString:@"群二维码"]) {
        WXGroupQRCodeViewController *gorupQRCodeVC = [[WXGroupQRCodeViewController alloc] init];
        [gorupQRCodeVC setGroup:self.group];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:gorupQRCodeVC animated:YES];
    }else if ([item.title isEqualToString:@"设置当前聊天背景"]) {
        WXBgSettingViewController *chatBGSettingVC = [[WXBgSettingViewController alloc] init];
        [chatBGSettingVC setPartnerID:self.group.groupID];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatBGSettingVC animated:YES];
    }else if ([item.title isEqualToString:@"聊天文件"]) {
        WXChatFileViewController *chatFileVC = [[WXChatFileViewController alloc] init];
        [chatFileVC setPartnerID:self.group.groupID];
        [self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:chatFileVC animated:YES];
    }else if ([item.title isEqualToString:@"清空聊天记录"]) {
        [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
            return [UIAlertAction actionWithTitle:@"清空聊天记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                BOOL ok = [[WXMessageManager sharedInstance] deleteMessagesByPartnerID:self.group.groupID];
                if (!ok) {
                    [SVProgressHUD showErrorWithStatus:@"清空讨论组聊天记录失败"];
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
        NSUInteger count = self.group.count;
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
