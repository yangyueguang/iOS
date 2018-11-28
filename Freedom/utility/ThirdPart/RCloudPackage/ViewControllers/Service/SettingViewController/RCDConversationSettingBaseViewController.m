//
//  RCDConversationSettingBaseViewController.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/7/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//
#import "RCDConversationSettingBaseViewController.h"
#import <RongIMLib/RongIMLib.h>
#define CellReuseIdentifierCellIsTop @"CellIsTop"
#define CellReuseIdentifierCellNewMessageNotify @"CellNewMessageNotify"
#define CellReuserIdentifierCellClearHistory @"CellClearHistory"
#import "UIImageView+WebCache.h"
#import <RongIMLib/RongIMLib.h>
#import "UIImageView+WebCache.h"
@implementation RCDConversationSettingTableViewHeaderItem
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _ivAva = [[UIImageView alloc] initWithFrame:CGRectZero];
        _ivAva.clipsToBounds = YES;
        _ivAva.layer.cornerRadius = 5.f;
        [_ivAva setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_ivAva];
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor colorWithRGBHex:0x999999]];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_titleLabel];
        _btnImg = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnImg setHidden:YES];
        [_btnImg setImage:[FreedomTools imageNamed:@"delete_member_tip" ofBundle:@"RongCloud.bundle"] forState:UIControlStateNormal];
        [_btnImg addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnImg];
        [_ivAva setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_btnImg setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_ivAva]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_ivAva)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleLabel]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_ivAva(55)]-9-[_titleLabel(==15)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel, _ivAva)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_btnImg(25)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_btnImg)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_btnImg(25)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(_btnImg)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_ivAva attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0]];
    }
    return self;
}
- (void)deleteItem:(id)sender {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(deleteTipButtonClicked:)]) {
        [self.delegate deleteTipButtonClicked:self];
    }
}
- (void)setUserModel:(RCUserInfo *)userModel {
    self.ivAva.image = nil;
    self.userId = userModel.userId;
    self.titleLabel.text = userModel.name;
    if ([userModel.portraitUri isEqualToString:@""]) {
        UIView *defaultPortrait = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        defaultPortrait.backgroundColor = [UIColor redColor];
        NSString *firstLetter = [ChineseToPinyin firstPinyinFromChinise:userModel.name];
        UILabel *firstCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(defaultPortrait.frame.size.width / 2 - 30, defaultPortrait.frame.size.height / 2 - 30, 60, 60)];
        firstCharacterLabel.text = firstLetter;
        firstCharacterLabel.textColor = [UIColor whiteColor];
        firstCharacterLabel.textAlignment = NSTextAlignmentCenter;
        firstCharacterLabel.font = [UIFont systemFontOfSize:50];
        [defaultPortrait addSubview:firstCharacterLabel];
        UIImage *portrait = [defaultPortrait imageFromView];
        self.ivAva.image = portrait;
    } else {
        [self.ivAva sd_setImageWithURL:[NSURL URLWithString:userModel.portraitUri]
                      placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
}
@end
@interface RCDConversationSettingTableViewHeader () <RCDConversationSettingTableViewHeaderItemDelegate>
@end
@implementation RCDConversationSettingTableViewHeader
- (NSArray *)users {
    if (!_users) {
        _users = [@[] mutableCopy];
    }
    return _users;
}
- (instancetype)init {
    CGRect tempRect = CGRectMake(0, 0, APPW, 120);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:tempRect collectionViewLayout:flowLayout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerClass:[RCDConversationSettingTableViewHeaderItem class] forCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItem"];
        self.isAllowedInviteMember = YES;
    }
    return self;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isAllowedDeleteMember) {
        return self.users.count + 2;
    } else {
        if (self.isAllowedInviteMember) {
            return self.users.count + 1;
        } else {
            return self.users.count;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCDConversationSettingTableViewHeaderItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RCDConversationSettingTableViewHeaderItem" forIndexPath:indexPath];
    if (self.users.count && (self.users.count - 1 >= indexPath.row)) {
        RCUserInfo *user = self.users[indexPath.row];
        if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
            [cell.btnImg setHidden:YES];
        } else {
            [cell.btnImg setHidden:!self.showDeleteTip];
        }
        [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:user.portraitUri] placeholderImage:[UIImage imageNamed:@"icon_person"]];
        cell.titleLabel.text = user.name;
        cell.userId = user.userId;
        cell.delegate = self;
        //长按显示减号
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteTip:)];
        longPressGestureRecognizer.minimumPressDuration = 0.28;
        [cell addGestureRecognizer:longPressGestureRecognizer];
        // cell.tag=[NSString stringWithFormat:@"%@",user.userId];
        //点击隐藏减号
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidesDeleteTip:)];
        [cell addGestureRecognizer:tap];
    } else if (self.users.count >= indexPath.row) {
        cell.btnImg.hidden = YES;
        cell.gestureRecognizers = nil;
        cell.titleLabel.text = @"";
        [cell.ivAva setImage:[FreedomTools imageNamed:@"add_members" ofBundle:@"RongCloud.bundle"]];
    } else {
        cell.btnImg.hidden = YES;
        cell.gestureRecognizers = nil;
        cell.titleLabel.text = @"";
        [cell.ivAva setImage:[FreedomTools imageNamed:@"delete_members" ofBundle:@"RongCloud.bundle"]];
//    长按显示减号
//    UILongPressGestureRecognizer *longPressGestureRecognizer =
//    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showDeleteTip:)];
//    longPressGestureRecognizer.minimumPressDuration = 0.28;
//    [cell addGestureRecognizer:longPressGestureRecognizer];
//点击去除减号
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notShowDeleteTip:)];
//    [cell addGestureRecognizer:singleTapGestureRecognizer];
    }
    cell.ivAva.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}
#pragma mark - RCConversationSettingTableViewHeaderItemDelegate
- (void)deleteTipButtonClicked:(RCDConversationSettingTableViewHeaderItem *)item {
    NSIndexPath *indexPath = [self indexPathForCell:item];
    RCUserInfo *user = self.users[indexPath.row];
    if ([user.userId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
        NSString *mes = NSLocalizedStringFromTable(@"CanNotRemoveSelf",@"RongCloudKit", nil);
        [SVProgressHUD showInfoWithStatus:mes];
        return;
    }
    [self.users removeObjectAtIndex:indexPath.row];
    [self deleteItemsAtIndexPaths:@[ indexPath ]];
    if (self.settingTableViewHeaderDelegate && [self.settingTableViewHeaderDelegate respondsToSelector:@selector(deleteTipButtonClicked:)]) {
            [self.settingTableViewHeaderDelegate deleteTipButtonClicked:indexPath];
            [self reloadData];
        }
}
//长按显示减号
- (void)showDeleteTip:(RCDConversationSettingTableViewHeaderItem *)cell {
    if (self.isAllowedDeleteMember) {
        self.showDeleteTip = YES;
        [self reloadData];
    }
}
//点击去除减号
//- (void)notShowDeleteTip:(RCDConversationSettingTableViewHeaderItem *)cell {
//    if (self.showDeleteTip == YES) {
//        self.showDeleteTip = NO;
//        [self reloadData];
//    }
//}
//点击隐藏减号
- (void)hidesDeleteTip:(UITapGestureRecognizer *)recognizer {
    if (self.showDeleteTip) {
        self.showDeleteTip = NO;
        [self reloadData];
    } else {
        if (self.settingTableViewHeaderDelegate && [self.settingTableViewHeaderDelegate respondsToSelector:@selector(didTipHeaderClicked:)]) {
                RCDConversationSettingTableViewHeaderItem *cell = (RCDConversationSettingTableViewHeaderItem *)recognizer.view;
                [self.settingTableViewHeaderDelegate didTipHeaderClicked:cell.userId];
            }
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = 56;
    float height = width + 15 + 5;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.users.count + 1) {
        if (self.isAllowedDeleteMember) {
            self.showDeleteTip = !self.showDeleteTip;
            [self reloadData];
        }
    }
    if (indexPath && self.settingTableViewHeaderDelegate &&
        [self.settingTableViewHeaderDelegate respondsToSelector:@selector(settingTableViewHeader:indexPathOfSelectedItem: allTheSeletedUsers:)]) {
             [self.settingTableViewHeaderDelegate settingTableViewHeader:self indexPathOfSelectedItem:indexPath allTheSeletedUsers:self.users];
         }
}
@end
@interface RCDConversationSettingTableViewCell : UITableViewCell
@property(nonatomic, strong) UISwitch *swich;
@property(nonatomic, strong) UILabel *label;
@end
@implementation RCDConversationSettingTableViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setTextAlignment:NSTextAlignmentLeft];
        _swich = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self addSubview:_label];
        [self addSubview:_swich];
        [_swich setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_swich(33)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(_swich)]];
        //        [self addConstraints:[NSLayoutConstraint
        //        constraintsWithVisualFormat:@"H:[_swich(35)]-30-|"
        //         options:kNilOptions
        //                                                                     metrics:nil
        //                                                                       views:NSDictionaryOfVariableBindings(_swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_label(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-16-[_label]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _label, _swich)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_swich
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeRight
                             multiplier:1.0f
                             constant:-20]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_label
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
    }
    return self;
}
@end
@interface RCDConversationSettingClearMessageCell : UITableViewCell
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *touchBtn;
@end
@implementation RCDConversationSettingClearMessageCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        _touchBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_nameLabel];
        [self addSubview:_touchBtn];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_touchBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:|[_touchBtn(44)]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _touchBtn)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|[_touchBtn]|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _touchBtn)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"V:[_nameLabel(30)]"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _nameLabel)]];
        [self addConstraints:
         [NSLayoutConstraint
          constraintsWithVisualFormat:@"H:|-16-[_nameLabel]-20-|"
          options:kNilOptions
          metrics:nil
          views:NSDictionaryOfVariableBindings(
                                               _nameLabel)]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:_nameLabel
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self
                             attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f
                             constant:0]];
    }
    return self;
}
@end
@interface RCDConversationSettingBaseViewController () <RCDConversationSettingTableViewHeaderDelegate>
@property(nonatomic, strong) RCDConversationSettingTableViewHeader *header;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) RCDConversationSettingTableViewCell *cell_isTop;
@property(nonatomic, strong)RCDConversationSettingTableViewCell *cell_newMessageNotify;
@end
@implementation RCDConversationSettingBaseViewController
- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
  // add the header view
  _headerView = [[UIView alloc] initWithFrame:CGRectZero];
  _header = [[RCDConversationSettingTableViewHeader alloc] init];
  _header.settingTableViewHeaderDelegate = self;
  [_header setBackgroundColor:[UIColor whiteColor]];
  [_headerView addSubview:_header];
  [_header setTranslatesAutoresizingMaskIntoConstraints:NO];
  [_headerView
      addConstraints:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"V:|-10-[_header]|"
                                  options:kNilOptions
                                  metrics:nil
                                    views:NSDictionaryOfVariableBindings(
                                              _header)]];
  [_headerView
      addConstraints:
          [NSLayoutConstraint
              constraintsWithVisualFormat:@"H:|[_header]|"
                                  options:kNilOptions
                                  metrics:nil
                                    views:NSDictionaryOfVariableBindings(
                                              _header)]];
  // footer view
  self.tableView.tableFooterView = [UIView new];
}
- (void)addUsers:(NSMutableArray *)users {
  if (!users)return;
  _header.users = [NSMutableArray arrayWithArray:users];
  self.users = users;
  [_header reloadData];
  _headerView.frame = CGRectMake(0, 0, APPW,_header.collectionViewLayout.collectionViewContentSize.height + 20);
  self.tableView.tableHeaderView = _headerView;
}
- (void)disableDeleteMemberEvent:(BOOL)disable {
  if (_header) {
    _header.isAllowedDeleteMember = !disable;
  }
}
- (void)disableInviteMemberEvent:(BOOL)disable {
  if (_header) {
    _header.isAllowedInviteMember = !disable;
  }
}
- (NSArray *)defaultCells {
  _cell_isTop = [[RCDConversationSettingTableViewCell alloc] initWithFrame:CGRectZero];
  [_cell_isTop.swich addTarget:self action:@selector(onClickIsTopSwitch:) forControlEvents:UIControlEventValueChanged];
  _cell_isTop.swich.on = _switch_isTop;
  _cell_isTop.label.text = NSLocalizedStringFromTable(@"SetToTop", @"RongCloudKit", nil); //@"置顶聊天";
  _cell_newMessageNotify = [[RCDConversationSettingTableViewCell alloc] initWithFrame:CGRectZero];
  [_cell_newMessageNotify.swich addTarget:self action:@selector(onClickNewMessageNotificationSwitch:) forControlEvents:UIControlEventValueChanged];
  _cell_newMessageNotify.swich.on = _switch_newMessageNotify;
  _cell_newMessageNotify.label.text = NSLocalizedStringFromTable(@"NewMsgNotification", @"RongCloudKit", nil); //@"新消息通知";
  RCDConversationSettingClearMessageCell *cell_clearHistory = [[RCDConversationSettingClearMessageCell alloc] initWithFrame:CGRectZero];
  [cell_clearHistory.touchBtn addTarget:self action:@selector(onClickClearMessageHistory:) forControlEvents:UIControlEventTouchUpInside];
  cell_clearHistory.nameLabel.text = NSLocalizedStringFromTable(
      @"ClearRecord", @"RongCloudKit", nil); //@"清除聊天记录";
  NSArray *_defaultCells = @[ _cell_isTop, _cell_newMessageNotify, cell_clearHistory ];
  return _defaultCells;
}
- (void)setSwitch_isTop:(BOOL)switch_isTop {
  _cell_isTop.swich.on = switch_isTop;
  _switch_isTop = switch_isTop;
}
- (void)setSwitch_newMessageNotify:(BOOL)switch_newMessageNotify {
  _cell_newMessageNotify.swich.on = switch_newMessageNotify;
  _switch_newMessageNotify = switch_newMessageNotify;
}
// landspace notification
- (void)orientChange:(NSNotification *)noti {
  _headerView.frame = CGRectMake(0, 0, APPW,_header.collectionViewLayout.collectionViewContentSize.height + 20);
  self.tableView.tableHeaderView = _headerView;
  if (self.headerHidden) {
    self.tableView.tableHeaderView = nil;
  }
}
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  _headerView.frame = CGRectMake(0, 0, APPW, _header.collectionViewLayout.collectionViewContentSize.height + 20);
  self.tableView.tableHeaderView = _headerView;
  if (self.headerHidden) {
    self.tableView.tableHeaderView = nil;
  }
  if (_headerView) {
    _header.showDeleteTip = NO;
    [_header reloadData];
  }
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.defaultCells.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.defaultCells[indexPath.row];
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 20;
}
// override to impletion
//置顶聊天
- (void)onClickIsTopSwitch:(id)sender {
}
//新消息通知
- (void)onClickNewMessageNotificationSwitch:(id)sender {
}
//清除聊天记录
- (void)onClickClearMessageHistory:(id)sender {
}
//子类重写以下两个回调实现点击事件
#pragma mark - RCConversationSettingTableViewHeader Delegate
- (void)settingTableViewHeader:(RCDConversationSettingTableViewHeader *)settingTableViewHeader indexPathOfSelectedItem:(NSIndexPath *)indexPathOfSelectedItem allTheSeletedUsers:(NSArray *)users {
}
- (void)deleteTipButtonClicked:(NSIndexPath *)indexPath {
}
- (void)didTipHeaderClicked:(NSString *)userId {
}
@end
