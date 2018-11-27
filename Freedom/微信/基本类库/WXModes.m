//
//  WXModes.m
//  Freedom
//
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
#import "WXModes.h"
#define     EDGE_MOMENT_EXTENSION       5.0f
#define     WIDTH_MOMENT_CONTENT        (APPW - 70.0f)
@implementation WXMoment
- (id)init{
    if (self = [super init]) {
        [WXMoment mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"user" : @"TLUser",
                      @"detail" : @"TLMomentDetail",
                      @"extension" : @"TLMomentExtension"};
        }];
    }
    return self;
}
- (WXMomentFrame *)momentFrame{
    if (_momentFrame == nil) {
        _momentFrame = [[WXMomentFrame alloc] init];
        _momentFrame.height = 76.0f;
        _momentFrame.height += _momentFrame.heightDetail = self.detail.detailFrame.height;  // 正文高度
        _momentFrame.height += _momentFrame.heightExtension = self.extension.extensionFrame.height;   // 拓展高度
    }
    return _momentFrame;
}
@end
@implementation WXMomentFrame
@end
@implementation WXMomentComment
- (id)init{
    if (self = [super init]) {
        [WXMomentComment mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"user" : @"TLUser",
                      @"toUser" : @"TLUser"};
        }];
    }
    return self;
}
- (WXMomentCommentFrame *)commentFrame{
    if (_commentFrame == nil) {
        _commentFrame = [[WXMomentCommentFrame alloc] init];
        _commentFrame.height = 35.0f;
    }
    return _commentFrame;
}
@end
@implementation WXMomentCommentFrame
@end
@implementation WXMomentDetail
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
- (WXMomentDetailFrame *)detailFrame{
    if (_detailFrame == nil) {
        _detailFrame = [[WXMomentDetailFrame alloc] init];
        _detailFrame.height = 0.0f;
        _detailFrame.height += _detailFrame.heightText = [self heightText];
        _detailFrame.height += _detailFrame.heightImages = [self heightImages];
    }
    return _detailFrame;
}
@end
@implementation WXMomentDetailFrame
@end
@implementation WXMomentExtension
- (id)init{
    if (self = [super init]) {
        [WXMomentExtension mj_setupObjectClassInArray:^NSDictionary *{
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
    for (WXMomentComment *comment in self.comments) {
        height += comment.commentFrame.height;
    }
    return height;
}
- (WXMomentExtensionFrame *)extensionFrame{
    if (_extensionFrame == nil) {
        _extensionFrame = [[WXMomentExtensionFrame alloc] init];
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
@implementation WXMomentExtensionFrame
@end
@interface WXAddMenuHelper ()
@property (nonatomic, strong) NSArray *menuItemTypes;
@end
@implementation WXAddMenuHelper
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
            WXAddMenuItem *item = [self p_getMenuItemByType:[type integerValue]];
            [_menuData addObject:item];
        }
    }
    return _menuData;
}
- (WXAddMenuItem *)p_getMenuItemByType:(TLAddMneuType)type{
    switch (type) {
        case TLAddMneuTypeGroupChat:        // 群聊
            return  [WXAddMenuItem createWithType:TLAddMneuTypeGroupChat title:@"发起群聊" iconPath:@"nav_menu_groupchat" className:@""];
            break;
        case TLAddMneuTypeAddFriend:        // 添加好友
            return [WXAddMenuItem createWithType:TLAddMneuTypeAddFriend title:@"添加朋友" iconPath:@"nav_menu_addfriend" className:@"TLAddFriendViewController"];
            break;
        case TLAddMneuTypeWallet:           // 收付款
            return [WXAddMenuItem createWithType:TLAddMneuTypeWallet title:@"收付款" iconPath:@"nav_menu_wallet" className:@""];
            break;
        case TLAddMneuTypeScan:             // 扫一扫
            return [WXAddMenuItem createWithType:TLAddMneuTypeScan title:@"扫一扫" iconPath:@"nav_menu_scan" className:@"TLScanningViewController"];
            break;
        default:
            break;
    }
}
@end
@implementation WXInfo
+ (WXInfo *)createInfoWithTitle:(NSString *)title subTitle:(NSString *)subTitle{
    WXInfo *info = [[WXInfo alloc] init];
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
@implementation WXMenuItem
+ (WXMenuItem *) createMenuWithIconPath:(NSString *)iconPath title:(NSString *)title{
    WXMenuItem *item = [[WXMenuItem alloc] init];
    item.iconPath = iconPath;
    item.title = title;
    return item;
}
@end
//  TLSettingGroup.m
//  Freedom
// Created by Super
static UILabel *hLabel = nil;
@implementation WXSettingGroup
+ (WXSettingGroup *) createGroupWithHeaderTitle:(NSString *)headerTitle
                                    footerTitle:(NSString *)footerTitle
                                          items:(NSMutableArray *)items{
    WXSettingGroup *group= [[WXSettingGroup alloc] init];
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
    _headerHeight = [self getTextHeightOfText:headerTitle font:[UIFont systemFontOfSize:14.0f] width:APPW - 30];
}
- (void) setFooterTitle:(NSString *)footerTitle{
    _footerTitle = footerTitle;
    _footerHeight = [self getTextHeightOfText:footerTitle font:[UIFont systemFontOfSize:14.0f] width:APPW - 30];
}
- (CGFloat) getTextHeightOfText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
    if (hLabel == nil) {
        hLabel = [[UILabel alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [hLabel setNumberOfLines:0];
    }
    hLabel.frameWidth = width;
    [hLabel setFont:font];
    [hLabel setText:text];
    return [hLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}
#pragma mark - Getter
- (NSUInteger) count{
    return self.items.count;
}
@end
@implementation WXSettingItem
+ (WXSettingItem *) createItemWithTitle:(NSString *)title{
    WXSettingItem *item = [[WXSettingItem alloc] init];
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
@implementation WXAddMenuItem
+ (WXAddMenuItem *)createWithType:(TLAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className{
    WXAddMenuItem *item = [[WXAddMenuItem alloc] init];
    item.type = type;
    item.title = title;
    item.iconPath = iconPath;
    item.className = className;
    return item;
}
@end
@implementation WXModes
@end
