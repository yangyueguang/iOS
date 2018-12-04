//
//  RCDReceiptDetailsTableViewController.m
//  RCloudMessage
//
//  Created by Jue on 16/9/22.
//  Copyright © 2016年 RongCloud. All rights reserved.
//
#import "RCDReceiptDetailsTableViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDataBaseManager.h"
#import "RCDPersonDetailViewController.h"
#import "RCDAddFriendViewController.h"
#import "RCDConversationSettingBaseViewController.h"
#import "RCDataBaseManager.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDHttpTool.h"
/*!用户信息提供者@discussion SDK需要通过您实现的用户信息提供者，获取用户信息并显示。*/
@protocol RCDReceiptDetailsCellDelegate <NSObject>
@optional
- (void)clickHasReadButton;
- (void)clickUnreadButton;
- (void)clickPortrait:(NSString *)userId;
@end
@interface RCDReceiptDetailsTableViewCell : UITableViewCell
@property(nonatomic, strong)NSArray *userList;
@property(nonatomic, strong)NSArray *groupMemberList;
@property(nonatomic, weak) id<RCDReceiptDetailsCellDelegate> delegate;
@property(nonatomic, assign)BOOL displayHasreadUsers;
@property(nonatomic, assign)NSUInteger hasReadUsersCount;
@property(nonatomic, assign)NSUInteger unreadUsersCount;
@property(nonatomic, assign)CGFloat cellHeight;
@end
@interface RCDReceiptDetailsTableViewCell()<UICollectionViewDataSource,
UICollectionViewDelegate>
@property(nonatomic, strong) NSDictionary *CellSubviews;
@property(nonatomic, strong) UIView *verticalLine;
@property(nonatomic, strong) UIButton *hasReadButton;
@property(nonatomic, strong) UIButton *unReadButton;
@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UIView *leftSelectLine;
@property(nonatomic, strong) UIView *rightSelectLine;
@property(nonatomic, strong) UICollectionView *userListView;
@property(nonatomic, strong) NSMutableArray *collectionViewResource;
@end
@implementation RCDReceiptDetailsTableViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize{
    self.collectionViewResource = [NSMutableArray new];
    self.verticalLine = [self createLine:[FreedomTools colorWithRGBHex:0xdfdfdf]];
    [self.contentView addSubview:self.verticalLine];
    self.hasReadButton = [self createButton:[NSString stringWithFormat:@"%lu人已读",(unsigned long)self.userList.count]];
    [self.hasReadButton addTarget:self action:@selector(clickHasReadButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.hasReadButton];
    self.hasReadButton.selected = YES;
    self.leftSelectLine = [self createLine:[FreedomTools colorWithRGBHex:0x0099ff]];
    [self.hasReadButton addSubview:self.leftSelectLine];
    self.unReadButton = [self createButton:@"0人未读"];
    [self.unReadButton addTarget:self action:@selector(clickUnreadButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.unReadButton];
    self.rightSelectLine = [self createLine:[FreedomTools colorWithRGBHex:0x0099ff]];
    [self.unReadButton addSubview:self.rightSelectLine];
    self.rightSelectLine.hidden = YES;
    self.line = [self createLine:[FreedomTools colorWithRGBHex:0xdfdfdf]];
    [self.contentView addSubview:self.line];
    self.CellSubviews = NSDictionaryOfVariableBindings(_verticalLine, _hasReadButton,_unReadButton, _line);
    [self setAutoLayout];
}
- (UIView *)createLine:(UIColor *)lineColor {
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = lineColor;
    line.translatesAutoresizingMaskIntoConstraints = NO;
    return line;
}
- (UIButton *)createButton:(NSString *)buttonTitle {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    UIColor *normalColor = [FreedomTools colorWithRGBHex:0x000000];
    UIColor *selectedColor = [FreedomTools colorWithRGBHex:0x0099ff];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateHighlighted];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}
- (void)setAutoLayout {
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[_hasReadButton(width)][_verticalLine(1)]"
                     options:0
                     metrics:@{@"width" :
                                   @(APPW / 2 - 1)
                               }
                     views:self.CellSubviews]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:|[_hasReadButton(44)][_line(0.5)]"
                     options:0
                     metrics:nil
                     views:self.CellSubviews]];
    [self.contentView
     addConstraint:[NSLayoutConstraint constraintWithItem:_verticalLine
                                                attribute:NSLayoutAttributeCenterY
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.hasReadButton
                                                attribute:NSLayoutAttributeCenterY
                                               multiplier:1
                                                 constant:0]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[_verticalLine(24)]"
                     options:0
                     metrics:nil
                     views:self.CellSubviews]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:[_unReadButton(width)]|"
                     options:0
                     metrics:@{@"width" :
                                   @(APPW / 2 - 1)
                               }
                     views:self.CellSubviews]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:|[_unReadButton(44)]"
                     options:0
                     metrics:nil
                     views:self.CellSubviews]];
    [self.contentView
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[_line]|"
                     options:0
                     metrics:nil
                     views:self.CellSubviews]];
    [self.hasReadButton
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[_leftSelectLine]|"
                     options:0
                     metrics:nil
                     views:NSDictionaryOfVariableBindings(_leftSelectLine, _rightSelectLine)]];
    [self.hasReadButton
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[_leftSelectLine(2)]|"
                     options:0
                     metrics:nil
                     views:NSDictionaryOfVariableBindings(_leftSelectLine, _rightSelectLine)]];
    [self.unReadButton
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[_rightSelectLine]|"
                     options:0
                     metrics:nil
                     views:NSDictionaryOfVariableBindings(_leftSelectLine, _rightSelectLine)]];
    [self.unReadButton
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[_rightSelectLine(2)]|"
                     options:0
                     metrics:nil
                     views:NSDictionaryOfVariableBindings(_leftSelectLine, _rightSelectLine)]];
}
- (void)clickHasReadButton:(UIButton *)button {
    if (button.selected == YES) {
        return;
    }
    button.selected = !button.selected;
    [self.delegate clickHasReadButton];
}
- (void)clickUnreadButton:(UIButton *)button {
    if (button.selected == YES) {
        return;
    }
    button.selected = !button.selected;
    [self.delegate clickUnreadButton];
}
- (void)setUserList:(NSArray *)userList {
    _userList = userList;
    for (NSString *userId in userList) {
        for (RCUserInfo *user in self.groupMemberList) {
            if ([userId isEqualToString:user.userId]) {
                [self.collectionViewResource addObject:user];
            }
        }
    }
    if (self.collectionViewResource.count == userList.count) {
        //cell的高度 - button的高度 - 蓝色线的高度 = collectionView的高度
        CGRect tempRect = CGRectMake(0, 44.5, APPW,self.cellHeight - 44 - 1);
        UICollectionViewFlowLayout *flowLayout =
        [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.userListView = [[UICollectionView alloc] initWithFrame:tempRect collectionViewLayout:flowLayout];
        self.userListView.delegate = self;
        self.userListView.dataSource = self;
        self.userListView.scrollEnabled = YES;
        self.userListView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.userListView];
        [self.userListView registerClass:[RCDConversationSettingTableViewHeaderItem class] forCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItem"];
        [self.userListView reloadData];
    }
}
- (void)setDisplayHasreadUsers:(BOOL)displayHasreadUsers {
    if (displayHasreadUsers == YES) {
        self.leftSelectLine.hidden = NO;
        self.rightSelectLine.hidden = YES;
        self.unReadButton.selected = NO;
        self.hasReadButton.selected = YES;
    } else {
        self.leftSelectLine.hidden = YES;
        self.rightSelectLine.hidden = NO;
        self.hasReadButton.selected = NO;
        self.unReadButton.selected = YES;
    }
}
- (void)setHasReadUsersCount:(NSUInteger)hasReadUsersCount {
    [self.hasReadButton setTitle:[NSString stringWithFormat:@"%lu人已读",(unsigned long)hasReadUsersCount] forState:UIControlStateNormal];
}
- (void)setUnreadUsersCount:(NSUInteger)unreadUsersCount {
    [self.unReadButton setTitle:[NSString stringWithFormat:@"%lu人未读",(unsigned long)unreadUsersCount] forState:UIControlStateNormal];
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = 55;
    float height = width + 15 + 9;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout =
    (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 12;
    return UIEdgeInsetsMake(15, 10, 10, 10);
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionViewResource count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCDConversationSettingTableViewHeaderItem *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:
     @"RCDConversationSettingTableViewHeaderItem" forIndexPath:indexPath];
    if (self.collectionViewResource.count > 0) {
        RCUserInfo *user = self.collectionViewResource[indexPath.row];
        if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
            [cell.btnImg setHidden:YES];
        }
        [cell setUserModel:user];
    }
    cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate clickPortrait:[_userList objectAtIndex:indexPath.row]];
}
@end
@interface RCDReceiptDetailsTableViewController ()<RCDReceiptDetailsCellDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageContentLabel;
@property (nonatomic, strong) UIButton *openAndCloseButton;
@property (nonatomic, strong) NSDictionary *headerSubViews;
@property(nonatomic, strong) NSArray *MessageContentLabelConstraints;
@property(nonatomic, assign) CGFloat labelHeight;
@property(nonatomic, strong) NSArray *displayUserList;
@property(nonatomic, strong) NSArray *UnreadUserList;
@property(nonatomic, strong) NSArray *groupMemberList;
@property(nonatomic, assign) BOOL displayHasreadUsers;
@property(nonatomic, assign) CGFloat headerViewHeight;
@property(nonatomic, assign) CGFloat cellHeight;
//避免重复点击同一个按钮导致的重复刷新
@property(nonatomic, assign) NSInteger selectedButton;
@end
@implementation RCDReceiptDetailsTableViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"回执详情";
    UIButton *buttonItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 87, 23)];
    [buttonItem setImage:[UIImage imageNamed:@"navigator_btn_back"] forState:UIControlStateNormal];
    [buttonItem setTitle:@"返回" forState:UIControlStateNormal];
    [buttonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonItem addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
  [self setHeaderView];
  self.displayUserList = self.hasReadUserList;
  self.UnreadUserList = [self getUnreadUserList];
  [self.tableView reloadData];
  self.displayHasreadUsers = YES;
  self.tableView.tableFooterView = [UIView new];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //默认选中左边的按钮
  self.selectedButton = 0;
  self.cellHeight = 0;
  self.tableView.scrollEnabled = NO;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.cellHeight == 0 && self.headerViewHeight > 0) {
    //屏幕的高度 - sectionHeader的高度 - 导航栏的高度 = cell的高度
    self.cellHeight = APPH - self.headerViewHeight - 15 - 64;
  }
  return  self.cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reusableCellWithIdentifier = @"RCDReceiptDetailsTableViewCell";
  RCDReceiptDetailsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
  if (cell == nil) {
    cell = [[RCDReceiptDetailsTableViewCell alloc] init];
  }
  cell.cellHeight = self.cellHeight;
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.delegate = self;
  cell.groupMemberList = self.groupMemberList;
  cell.userList = self.displayUserList;
  cell.displayHasreadUsers = self.displayHasreadUsers;
  cell.hasReadUsersCount = self.hasReadUserList.count;
  cell.unreadUsersCount = self.UnreadUserList.count;
  return cell;
}
#pragma mark setHeaderView
- (void)setHeaderView {
  self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
  self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.nameLabel.font = [UIFont systemFontOfSize:16.f];
  self.nameLabel.textColor =[FreedomTools colorWithRGBHex:0x000000];
  self.nameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
  self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.headerView addSubview:self.nameLabel];
  self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.timeLabel.font = [UIFont systemFontOfSize:14.f];
  self.timeLabel.textColor =[FreedomTools colorWithRGBHex:0x999999];
  self.timeLabel.text = self.messageSendTime;
  self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.headerView addSubview:self.timeLabel];
  self.messageContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.messageContentLabel.font = [UIFont systemFontOfSize:16.f];
  self.messageContentLabel.textColor =[FreedomTools colorWithRGBHex:0x000000];
  self.messageContentLabel.text = self.messageContent;
  self.messageContentLabel.numberOfLines = 4;
  self.messageContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [self.headerView addSubview:self.messageContentLabel];
  self.openAndCloseButton = [[UIButton alloc] initWithFrame:CGRectZero];
  [self.openAndCloseButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
  [self.openAndCloseButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateSelected];
  [self.openAndCloseButton addTarget:self action:@selector(openAndCloseMessageContentLabel:) forControlEvents:UIControlEventTouchUpInside];
  self.openAndCloseButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.headerView addSubview:self.openAndCloseButton];
  self.headerSubViews = NSDictionaryOfVariableBindings(_nameLabel, _timeLabel, _messageContentLabel, _openAndCloseButton);
  [self setHeaderViewAutolayout];
}
-(void)setHeaderViewAutolayout {
  self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.headerViewHeight);
  [self.headerView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-9.5-[_nameLabel]-100-|"
                   options:0
                   metrics:nil
                   views:self.headerSubViews]];
  
  
  [self.headerView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:[_timeLabel]-10-|"
                   options:0
                   metrics:nil
                   views:self.headerSubViews]];
  
  [self.headerView
   addConstraints:[NSLayoutConstraint
                   constraintsWithVisualFormat:@"H:|-9.5-[_messageContentLabel]-10-|"
                   options:0
                   metrics:nil
                   views:self.headerSubViews]];
  NSUInteger lines = [self numberOfRowsInLabel:self.messageContentLabel];
  if (lines <= 4) {
    self.openAndCloseButton.hidden = YES;
    self.MessageContentLabelConstraints = [NSLayoutConstraint
                                      constraintsWithVisualFormat:@"V:|-7.5-[_nameLabel(21)]-7-[_messageContentLabel]"
                                      options:0
                                      metrics:nil
                                      views:self.headerSubViews];
    
    [self commitSetAutoLayout];
    self.headerViewHeight = 47 + [self.messageContentLabel sizeThatFits:CGSizeMake(self.messageContentLabel.frame.size.width, MAXFLOAT)].height;
    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.headerViewHeight);
    self.tableView.tableHeaderView = self.headerView;
  }
  if (lines > 4) {
    self.MessageContentLabelConstraints = [[NSLayoutConstraint
                                            constraintsWithVisualFormat:@"V:|-7.5-[_nameLabel(21)]-7-[_messageContentLabel]-8.5-[_openAndCloseButton(14)]"
                                            options:0
                                            metrics:nil
                                            views:self.headerSubViews]
                                           
                                           arrayByAddingObjectsFromArray:
                                           [NSLayoutConstraint
                                            constraintsWithVisualFormat:@"H:|[_openAndCloseButton]|"
                                            options:0
                                            metrics:nil
                                            views:self.headerSubViews]];
    [self commitSetAutoLayout];
    self.headerViewHeight = 145;
    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 145);
    self.tableView.tableHeaderView = self.headerView;
  }
  [self.headerView
   addConstraint:[NSLayoutConstraint constraintWithItem:_timeLabel
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:_nameLabel
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:0]];
}
- (void)openAndCloseMessageContentLabel:(id)sender {
  UIButton *button = (UIButton *)sender;
  [button setSelected: !button.selected];
  if (button.selected == YES) {
    self.messageContentLabel.numberOfLines = 0;
    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 69.5+self.labelHeight);
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.scrollEnabled = YES;
  } else {
    self.messageContentLabel.numberOfLines = 4;
    self.headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 145);
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
    self.tableView.scrollEnabled = NO;
  }
}
- (NSInteger)numberOfRowsInLabel:(UILabel *)label {
  CGFloat labelWidth = self.tableView.frame.size.width - 20;
  NSDictionary *attrs = @{NSFontAttributeName : label.font};
  CGSize maxSize = CGSizeMake(labelWidth, MAXFLOAT);
  CGFloat  textH = [label.text  boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
  self.labelHeight = textH;
  CGFloat lineHeight = label.font.lineHeight;
  NSInteger lineCount = textH / lineHeight;
  return lineCount;
}
- (void)commitSetAutoLayout {
  [self.headerView addConstraints:self.MessageContentLabelConstraints];
  [self.headerView setNeedsUpdateConstraints];
  [self.headerView updateConstraintsIfNeeded];
  [self.headerView layoutIfNeeded];
}
- (void)clickBackBtn {
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickHasReadButton {
  if (self.selectedButton != 0) {
    self.selectedButton = 0;
    self.displayUserList = self.hasReadUserList;
    self.displayHasreadUsers = YES;
    [self refreshCell];
  }
}
- (void)clickUnreadButton {
  if (self.selectedButton != 1) {
    self.selectedButton = 1;
    self.displayUserList = self.UnreadUserList;
    self.displayHasreadUsers = NO;
    [self refreshCell];
  }
}
- (void)clickPortrait:(NSString *)userId {
  RCDUserInfo *user = [[RCDataBaseManager shareInstance] getFriendInfo:userId];
  if (user != nil) {
    RCDPersonDetailViewController *vc = [[RCDPersonDetailViewController alloc] init];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
  } else {
    for (RCUserInfo *user in self.groupMemberList) {
      if ([user.userId isEqualToString:userId]) {
        RCDAddFriendViewController *addViewController = [[RCDAddFriendViewController alloc]init];
        addViewController.targetUserInfo = user;
        [self.navigationController pushViewController:addViewController animated:YES];
      }
    }
  }
}
- (void)refreshCell {
  NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (NSArray *)getUnreadUserList {
  NSArray *UserList;
  NSArray *allUsers = [[RCDataBaseManager shareInstance] getGroupMember:self.targetId];
  self.groupMemberList = allUsers;
  NSMutableArray *allUsersId = [NSMutableArray new];
  for (RCUserInfo *user in allUsers) {
    if (![user.userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
      [allUsersId addObject:user.userId];
    }
  }
  UserList = allUsersId;
  NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.hasReadUserList];
  UserList = [UserList filteredArrayUsingPredicate:filterPredicate];
  return UserList;
}
@end
