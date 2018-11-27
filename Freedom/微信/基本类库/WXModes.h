//
//  WXModes.h
//  Freedom
//
//  Created by Super on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
#import <Foundation/Foundation.h>
#import "WXMessageManager.h"
#define     TLCreateMenuItem(IconPath, Title) [WXMenuItem createMenuWithIconPath:IconPath title:Title]
#define     TLCreateSettingGroup(Header, Footer, Items)  [WXSettingGroup createGroupWithHeaderTitle:Header footerTitle:Footer items:[NSMutableArray arrayWithArray:Items]]
#define     TLCreateInfo(t, st) [WXInfo createInfoWithTitle:t subTitle:st]
#define     TLCreateSettingItem(title) [WXSettingItem createItemWithTitle:title]
typedef NS_ENUM(NSUInteger, TLInfoType) {
    TLInfoTypeDefault,
    TLInfoTypeTitleOnly,
    TLInfoTypeImages,
    TLInfoTypeMutiRow,
    TLInfoTypeButton,
    TLInfoTypeOther,
};
@interface WXMomentFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightDetail;
@property (nonatomic, assign) CGFloat heightExtension;
@end
@interface WXMomentDetailFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightText;
@property (nonatomic, assign) CGFloat heightImages;
@end
@interface WXMomentDetail : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) WXMomentDetailFrame *detailFrame;
@end
@interface WXMomentExtensionFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightLiked;
@property (nonatomic, assign) CGFloat heightComments;
@end
@interface WXMomentExtension : NSObject
@property (nonatomic, strong) NSMutableArray *likedFriends;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) WXMomentExtensionFrame *extensionFrame;
@end
@interface WXMoment : NSObject
@property (nonatomic, strong) NSString *momentID;
@property (nonatomic, strong) WXUser *user;
@property (nonatomic, strong) NSDate *date;/// 详细内容
@property (nonatomic, strong) WXMomentDetail *detail;/// 附加（评论，赞）
@property (nonatomic, strong) WXMomentExtension *extension;
@property (nonatomic, strong) WXMomentFrame *momentFrame;
@end
@interface WXMomentCommentFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@end
@interface WXMomentComment : NSObject
@property (nonatomic, strong) WXUser *user;
@property (nonatomic, strong) WXUser *toUser;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) WXMomentCommentFrame *commentFrame;
@end
@interface WXAddMenuHelper : NSObject
@property (nonatomic, strong) NSMutableArray *menuData;
@end
@interface WXInfo : NSObject
@property (nonatomic, assign) TLInfoType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSMutableArray *subImageArray;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UIColor *buttonHLColor;
@property (nonatomic, strong) UIColor *buttonBorderColor;
/*是否显示箭头（默认YES）*/
@property (nonatomic, assign) BOOL showDisclosureIndicator;
/*停用高亮（默认NO）*/
@property (nonatomic, assign) BOOL disableHighlight;
+ (WXInfo *)createInfoWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end
@interface WXMenuItem : NSObject
/*左侧图标路径*/
@property (nonatomic, strong) NSString *iconPath;
/*标题*/
@property (nonatomic, strong) NSString *title;
//副标题/
@property (nonatomic, strong) NSString *subTitle;
//副图片URL*/
@property (nonatomic, strong) NSString *rightIconURL;
/*是否显示红点*/
@property (nonatomic, assign) BOOL showRightRedPoint;
+ (WXMenuItem *) createMenuWithIconPath:(NSString *)iconPath title:(NSString *)title;
@end
@interface WXSettingGroup : NSObject
/*section头部标题*/
@property (nonatomic, strong) NSString *headerTitle;
/*section尾部说明*/
@property (nonatomic, strong) NSString *footerTitle;
/*setcion元素*/
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign, readonly) CGFloat headerHeight;
@property (nonatomic, assign, readonly) CGFloat footerHeight;
@property (nonatomic, assign, readonly) NSUInteger count;
+ (WXSettingGroup *)createGroupWithHeaderTitle:(NSString *)headerTitle
                                   footerTitle:(NSString *)footerTitle
                                         items:(NSMutableArray *)items;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)obj;
- (void)removeObject:(id)obj;
@end
@interface WXSettingItem : NSObject
typedef NS_ENUM(NSInteger, TLSettingItemType) {
    TLSettingItemTypeDefalut = 0,
    TLSettingItemTypeTitleButton,
    TLSettingItemTypeSwitch,
    TLSettingItemTypeOther,
};
/*主标题*/
@property (nonatomic, strong) NSString *title;
/*副标题*/
@property (nonatomic, strong) NSString *subTitle;
/*右图片(本地)*/
@property (nonatomic, strong) NSString *rightImagePath;
/*右图片(网络)*/
@property (nonatomic, strong) NSString *rightImageURL;
/*是否显示箭头（默认YES）*/
@property (nonatomic, assign) BOOL showDisclosureIndicator;
/*停用高亮（默认NO）*/
@property (nonatomic, assign) BOOL disableHighlight;
/*cell类型，默认default*/
@property (nonatomic, assign) TLSettingItemType type;
+ (WXSettingItem *) createItemWithTitle:(NSString *)title;
- (NSString *) cellClassName;
@end
@interface WXAddMenuItem : NSObject
@property (nonatomic, assign) TLAddMneuType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *className;
+ (WXAddMenuItem *)createWithType:(TLAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className;
@end
@interface WXModes : NSObject
@end
