//
//  WechartModes.m
//  Freedom
//
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 薛超. All rights reserved.
#import "WechartModes.h"
#define     EDGE_MOMENT_EXTENSION       5.0f
#define     WIDTH_MOMENT_CONTENT        (WIDTH_SCREEN - 70.0f)
@implementation TLMoment
- (id)init{
    if (self = [super init]) {
        [TLMoment mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"user" : @"TLUser",
                      @"detail" : @"TLMomentDetail",
                      @"extension" : @"TLMomentExtension"};
        }];
    }
    return self;
}
- (TLMomentFrame *)momentFrame{
    if (_momentFrame == nil) {
        _momentFrame = [[TLMomentFrame alloc] init];
        _momentFrame.height = 76.0f;
        _momentFrame.height += _momentFrame.heightDetail = self.detail.detailFrame.height;  // 正文高度
        _momentFrame.height += _momentFrame.heightExtension = self.extension.extensionFrame.height;   // 拓展高度
    }
    return _momentFrame;
}
@end
@implementation TLMomentFrame
@end
@implementation TLMomentComment
- (id)init{
    if (self = [super init]) {
        [TLMomentComment mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"user" : @"TLUser",
                      @"toUser" : @"TLUser"};
        }];
    }
    return self;
}
- (TLMomentCommentFrame *)commentFrame{
    if (_commentFrame == nil) {
        _commentFrame = [[TLMomentCommentFrame alloc] init];
        _commentFrame.height = 35.0f;
    }
    return _commentFrame;
}
@end
@implementation TLMomentCommentFrame
@end
@implementation TLMomentDetail
#pragma mark -
- (CGFloat)heightText{
    if (self.text.length > 0) {
        CGFloat textHeight = [self.text boundingRectWithSize:CGSizeMake(WIDTH_MOMENT_CONTENT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15.0f]} context:nil].size.height;
        //???: 浮点数会导致部分cell顶部多出来一条线，莫名其妙！！！
        return (int)textHeight + 1.0;
    }
    return 0.0f;
}
- (CGFloat)heightImages{
    CGFloat height = 0.0f;
    if (self.images.count > 0) {
        if (self.text.length > 0) {
            height += 7.0f;
        }else{
            height += 3.0f;
        }
        CGFloat space = 4.0;
        if (self.images.count == 1) {
            height += WIDTH_MOMENT_CONTENT * 0.6 * 0.8;
        }else{
            NSInteger row = (self.images.count / 3) + (self.images.count % 3 == 0 ? 0 : 1);
            height += (WIDTH_MOMENT_CONTENT * 0.31 * row + space * (row - 1));
        }
    }
    return height;
}
- (TLMomentDetailFrame *)detailFrame{
    if (_detailFrame == nil) {
        _detailFrame = [[TLMomentDetailFrame alloc] init];
        _detailFrame.height = 0.0f;
        _detailFrame.height += _detailFrame.heightText = [self heightText];
        _detailFrame.height += _detailFrame.heightImages = [self heightImages];
    }
    return _detailFrame;
}
@end
@implementation TLMomentDetailFrame
@end
@implementation TLMomentExtension
- (id)init{
    if (self = [super init]) {
        [TLMomentExtension mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"likedFriends" : @"TLUser",
                      @"comments" : @"TLMomentComment"};
        }];
    }
    return self;
}
- (CGFloat)heightLiked{
    CGFloat height = 0.0f;
    if (self.likedFriends.count > 0) {
        height = 30.0f;
    }
    return height;
}
- (CGFloat)heightComments{
    CGFloat height = 0.0f;
    for (TLMomentComment *comment in self.comments) {
        height += comment.commentFrame.height;
    }
    return height;
}
- (TLMomentExtensionFrame *)extensionFrame{
    if (_extensionFrame == nil) {
        _extensionFrame = [[TLMomentExtensionFrame alloc] init];
        _extensionFrame.height = 0.0f;
        if (self.likedFriends.count > 0 || self.comments.count > 0) {
            _extensionFrame.height += EDGE_MOMENT_EXTENSION;
        }
        _extensionFrame.height += _extensionFrame.heightLiked = [self heightLiked];
        _extensionFrame.height += _extensionFrame.heightComments = [self heightComments];
    }
    return _extensionFrame;
}
@end
@implementation TLMomentExtensionFrame
@end
@interface TLAddMenuHelper ()
@property (nonatomic, strong) NSArray *menuItemTypes;
@end
@implementation TLAddMenuHelper
- (id)init{
    if (self = [super init]) {
        _menuItemTypes = @[@"0", @"1", @"2", @"3"];
    }
    return self;
}
- (NSMutableArray *)menuData{
    if (_menuData == nil) {
        _menuData = [[NSMutableArray alloc] init];
        for (NSString *type in self.menuItemTypes) {
            TLAddMenuItem *item = [self p_getMenuItemByType:[type integerValue]];
            [_menuData addObject:item];
        }
    }
    return _menuData;
}
- (TLAddMenuItem *)p_getMenuItemByType:(TLAddMneuType)type{
    switch (type) {
        case TLAddMneuTypeGroupChat:        // 群聊
            return  [TLAddMenuItem createWithType:TLAddMneuTypeGroupChat title:@"发起群聊" iconPath:@"nav_menu_groupchat" className:@""];
            break;
        case TLAddMneuTypeAddFriend:        // 添加好友
            return [TLAddMenuItem createWithType:TLAddMneuTypeAddFriend title:@"添加朋友" iconPath:@"nav_menu_addfriend" className:@"TLAddFriendViewController"];
            break;
        case TLAddMneuTypeWallet:           // 收付款
            return [TLAddMenuItem createWithType:TLAddMneuTypeWallet title:@"收付款" iconPath:@"nav_menu_wallet" className:@""];
            break;
        case TLAddMneuTypeScan:             // 扫一扫
            return [TLAddMenuItem createWithType:TLAddMneuTypeScan title:@"扫一扫" iconPath:@"nav_menu_scan" className:@"TLScanningViewController"];
            break;
        default:
            break;
    }
}
@end
@implementation TLInfo
+ (TLInfo *)createInfoWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    TLInfo *info = [[TLInfo alloc] init];
    info.title = title;
    info.subTitle = subTitle;
    return info;
}
- (id)init{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
    }
    return self;
}
- (UIColor *)buttonColor{
    if (_buttonColor == nil) {
        return colorGreenDefault;
    }
    return _buttonColor;
}
- (UIColor *)buttonHLColor{
    if (_buttonHLColor == nil) {
        return [self buttonColor];
    }
    return _buttonHLColor;
}
- (UIColor *)titleColor{
    if (_titleColor == nil) {
        return [UIColor blackColor];
    }
    return _titleColor;
}
- (UIColor *)buttonBorderColor{
    if (_buttonBorderColor == nil) {
        return colorGrayLine;
    }
    return _buttonBorderColor;
}
@end
@implementation TLMenuItem
+ (TLMenuItem *) createMenuWithIconPath:(NSString *)iconPath title:(NSString *)title{
    TLMenuItem *item = [[TLMenuItem alloc] init];
    item.iconPath = iconPath;
    item.title = title;
    return item;
}
@end
//  TLSettingGroup.m
//  Freedom
// Created by Super

@implementation TLSettingGroup
+ (TLSettingGroup *) createGroupWithHeaderTitle:(NSString *)headerTitle
                                    footerTitle:(NSString *)footerTitle
                                          items:(NSMutableArray *)items{
    TLSettingGroup *group= [[TLSettingGroup alloc] init];
    group.headerTitle = headerTitle;
    group.footerTitle = footerTitle;
    group.items = items;
    return group;
}
#pragma mark - Public Mthods
- (id) objectAtIndex:(NSUInteger)index{
    return [self.items objectAtIndex:index];
}
- (NSUInteger)indexOfObject:(id)obj{
    return [self.items indexOfObject:obj];
}
- (void)removeObject:(id)obj{
    [self.items removeObject:obj];
}
#pragma mark - Setter
- (void) setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    _headerHeight = [FreedomTools getTextHeightOfText:headerTitle font:[UIFont fontSettingHeaderAndFooterTitle] width:WIDTH_SCREEN - 30];
}
- (void) setFooterTitle:(NSString *)footerTitle{
    _footerTitle = footerTitle;
    _footerHeight = [FreedomTools getTextHeightOfText:footerTitle font:[UIFont fontSettingHeaderAndFooterTitle] width:WIDTH_SCREEN - 30];
}
#pragma mark - Getter
- (NSUInteger) count{
    return self.items.count;
}
@end
@implementation TLSettingItem
+ (TLSettingItem *) createItemWithTitle:(NSString *)title{
    TLSettingItem *item = [[TLSettingItem alloc] init];
    item.title = title;
    return item;
}
- (id) init{
    if (self = [super init]) {
        self.showDisclosureIndicator = YES;
    }
    return self;
}
- (NSString *) cellClassName{
    switch (self.type) {
        case TLSettingItemTypeDefalut:
            return @"TLSettingCell";
            break;
        case TLSettingItemTypeTitleButton:
            return @"TLSettingButtonCell";
            break;
        case TLSettingItemTypeSwitch:
            return @"TLSettingSwitchCell";
            break;
        default:
            break;
    }
    return nil;
}
@end
@implementation TLAddMenuItem
+ (TLAddMenuItem *)createWithType:(TLAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className{
    TLAddMenuItem *item = [[TLAddMenuItem alloc] init];
    item.type = type;
    item.title = title;
    item.iconPath = iconPath;
    item.className = className;
    return item;
}
@end
@implementation WechartModes

@end
