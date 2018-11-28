//
//  SecondViewController.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//
#import "RCDGroupViewController.h"
#import "AFHttpTool.h"
#import "MBProgressHUD.h"
#import "RCDChatViewController.h"
#import "RCloudModel.h"
#import "RCDGroupSettingsTableViewController.h"
#import "RCDHttpTool.h"
#import "RCDRCIMDataSource.h"
#import "RCDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "RCloudModel.h"
#import "RCDHttpTool.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#define CellHeight 54.5f
@class RCDGroupInfo;
@interface RCDGroupTableViewCell : UITableViewCell
+ (CGFloat)cellHeight;
/***  给控件填充数据*  @param group 设置群组模型*/
- (void)setModel:(RCDGroupInfo *)group;
@property(nonatomic, copy) NSString *groupID;
/** *  群组名称label */
@property(nonatomic, strong) UILabel *lblGroupName;
/** *  群组头像 */
@property(nonatomic, strong) UIImageView *imvGroupPort;
/** *  群组id的label */
@property(nonatomic, strong) UILabel *lblGroupId;
@end
@implementation RCDGroupTableViewCell
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    CGFloat cellWidth = APPW;
    CGFloat cellHeight = CellHeight;
    //群组头像
    CGFloat imvGroupPortWidth = 36;
    CGFloat imvGroupPortHeight = imvGroupPortWidth;
    CGFloat imvGroupPortX = 10;
    CGFloat imvGroupPortY = cellHeight/2.0-imvGroupPortHeight/2.0;
    self.imvGroupPort = [[UIImageView alloc]initWithFrame:CGRectMake(imvGroupPortX, imvGroupPortY, imvGroupPortWidth, imvGroupPortHeight)];
    //切圆角
    self.imvGroupPort.layer.masksToBounds = YES;
    self.imvGroupPort.layer.cornerRadius = 2.f;
    //群组名称
    CGFloat lblGroupNameHeight = 21;
    CGFloat lblGroupNameX = CGRectGetMaxX(self.imvGroupPort.frame)+10;
    CGFloat lblGroupNameY = cellHeight/2.0-lblGroupNameHeight/2.0;
    CGFloat lblGroupNameWidth = cellWidth-100-lblGroupNameX;
    self.lblGroupName = [[UILabel alloc]initWithFrame:CGRectMake(lblGroupNameX, lblGroupNameY, lblGroupNameWidth, lblGroupNameHeight)];
    self.lblGroupName.font = [UIFont systemFontOfSize:15];
    //群组id
    CGFloat lblGroupIdWidth = 200;
    CGFloat lblGroupIdHeight = 21;
    CGFloat lblGroupIdX = 100;
    CGFloat lblGroupIdY = CGRectGetMaxY(self.lblGroupName.frame)-2;
    self.lblGroupId = [[UILabel alloc]initWithFrame:CGRectMake(lblGroupIdX, lblGroupIdY, lblGroupIdWidth, lblGroupIdHeight)];
    self.lblGroupId.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.imvGroupPort];
    [self.contentView addSubview:self.lblGroupName];
    [self.contentView addSubview:self.lblGroupId];
}
- (void)setModel:(RCDGroupInfo *)group {
    self.lblGroupName.text = group.groupName;
    self.groupID = group.groupId;
    if ([RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE && [RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE) {
        self.imvGroupPort.layer.masksToBounds = YES;
        self.imvGroupPort.layer.cornerRadius = 28.f;
    } else {
        self.imvGroupPort.layer.masksToBounds = YES;
        self.imvGroupPort.layer.cornerRadius = 5.f;
    }
    if ([group.portraitUri isEqualToString:@""]) {
        UIView *defaultPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        defaultPortrait.backgroundColor = [UIColor redColor];
        NSString *firstLetter = [ChineseToPinyin firstPinyinFromChinise:group.groupName];
        UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
        firstCharacterLabel.text = firstLetter;
        firstCharacterLabel.textColor = [UIColor whiteColor];
        firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
        firstCharacterLabel.font = [UIFont systemFontOfSize:50];
        [defaultPortrait addSubview:firstCharacterLabel];
        UIImage *portrait = [defaultPortrait imageFromView];
        self.imvGroupPort.image = portrait;
    } else {
        [self.imvGroupPort sd_setImageWithURL:[NSURL URLWithString:group.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
    self.imvGroupPort.contentMode = UIViewContentModeScaleAspectFill;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}
+ (CGFloat)cellHeight {
    return CellHeight;
}
@end
@interface RCDGroupViewController () <
UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSMutableArray *groups;
//@property(nonatomic, strong) UILabel *noGroup;
@end
@implementation RCDGroupViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //设置为不用默认渲染方式
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_group"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_group_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //设置tableView样式
        self.tableView.separatorColor =
        [UIColor colorWithRGBHex:0xdfdfdf];
        self.tableView.tableFooterView = [UIView new];
        __weak RCDGroupViewController *weakSelf = self;
        _groups = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllGroup]];
        if ([_groups count] > 0) {
            [weakSelf.tableView reloadData];
        }
        [RCDHTTPTOOL getMyGroupsWithBlock:^(NSMutableArray *result) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
               NSMutableArray *tempGroups = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllGroup]];
               dispatch_async(dispatch_get_main_queue(), ^{
                   _groups = tempGroups;
                   [weakSelf.tableView reloadData];
               });
           });
        }];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //设置为不用默认渲染方式
        self.tabBarItem.image = [[UIImage imageNamed:@"icon_group"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_group_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"群组";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groups.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDGroupInfo *groupInfo = _groups[indexPath.row];
    RCDChatViewController *temp = [[RCDChatViewController alloc] init];
    temp.targetId = groupInfo.groupId;
    temp.conversationType = ConversationType_GROUP;
    temp.csInfo.nickName = groupInfo.groupName;
    temp.title = groupInfo.groupName;
    [self.navigationController pushViewController:temp animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *isDisplayID = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDisplayID"];
    static NSString *CellIdentifier = @"RCDGroupCell";
    RCDGroupTableViewCell *cell = (RCDGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[RCDGroupTableViewCell alloc]init];
    }
    RCDGroupInfo *group = _groups[indexPath.row];
    if ([isDisplayID isEqualToString:@"YES"]) {
        cell.lblGroupId.text = group.groupId;
    }
    [cell setModel:group];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RCDGroupTableViewCell cellHeight];
}
@end
