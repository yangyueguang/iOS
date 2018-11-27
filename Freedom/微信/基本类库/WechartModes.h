//
//  WechartModes.h
//  Freedom
//
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 薛超. All rights reserved.
#import <Foundation/Foundation.h>
#import "TLMessageManager.h"

#define     TLCreateMenuItem(IconPath, Title) [TLMenuItem createMenuWithIconPath:IconPath title:Title]
#define     TLCreateSettingGroup(Header, Footer, Items)  [TLSettingGroup createGroupWithHeaderTitle:Header footerTitle:Footer items:[NSMutableArray arrayWithArray:Items]]
#define     TLCreateInfo(t, st) [TLInfo createInfoWithTitle:t subTitle:st]
#define     TLCreateSettingItem(title) [TLSettingItem createItemWithTitle:title]
typedef NS_ENUM(NSUInteger, TLInfoType) {
    TLInfoTypeDefault,
    TLInfoTypeTitleOnly,
    TLInfoTypeImages,
    TLInfoTypeMutiRow,
    TLInfoTypeButton,
    TLInfoTypeOther,
};
@interface TLMomentFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightDetail;
@property (nonatomic, assign) CGFloat heightExtension;
@end
@interface TLMomentDetailFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightText;
@property (nonatomic, assign) CGFloat heightImages;
@end
@interface TLMomentDetail : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) TLMomentDetailFrame *detailFrame;
@end
@interface TLMomentExtensionFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightLiked;
@property (nonatomic, assign) CGFloat heightComments;
@end
@interface TLMomentExtension : NSObject
@property (nonatomic, strong) NSMutableArray *likedFriends;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) TLMomentExtensionFrame *extensionFrame;
@end
@interface TLMoment : NSObject
@property (nonatomic, strong) NSString *momentID;
@property (nonatomic, strong) TLUser *user;
@property (nonatomic, strong) NSDate *date;/// 详细内容
@property (nonatomic, strong) TLMomentDetail *detail;/// 附加（评论，赞）
@property (nonatomic, strong) TLMomentExtension *extension;
@property (nonatomic, strong) TLMomentFrame *momentFrame;
@end
@interface TLMomentCommentFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@end
@interface TLMomentComment : NSObject
@property (nonatomic, strong) TLUser *user;
@property (nonatomic, strong) TLUser *toUser;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) TLMomentCommentFrame *commentFrame;
@end
@interface TLAddMenuHelper : NSObject
@property (nonatomic, strong) NSMutableArray *menuData;
@end
@interface TLInfo : NSObject
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
+ (TLInfo *)createInfoWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
@end
@interface TLMenuItem : NSObject
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
+ (TLMenuItem *) createMenuWithIconPath:(NSString *)iconPath title:(NSString *)title;
@end

@interface TLSettingGroup : NSObject
/*section头部标题*/
@property (nonatomic, strong) NSString *headerTitle;
/*section尾部说明*/
@property (nonatomic, strong) NSString *footerTitle;
/*setcion元素*/
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign, readonly) CGFloat headerHeight;
@property (nonatomic, assign, readonly) CGFloat footerHeight;
@property (nonatomic, assign, readonly) NSUInteger count;
+ (TLSettingGroup *)createGroupWithHeaderTitle:(NSString *)headerTitle
                                   footerTitle:(NSString *)footerTitle
                                         items:(NSMutableArray *)items;
- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)obj;
- (void)removeObject:(id)obj;
@end
@interface TLSettingItem : NSObject
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
+ (TLSettingItem *) createItemWithTitle:(NSString *)title;
- (NSString *) cellClassName;
@end
@interface TLAddMenuItem : NSObject
@property (nonatomic, assign) TLAddMneuType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *className;
+ (TLAddMenuItem *)createWithType:(TLAddMneuType)type title:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className;
@end
@interface WechartModes : NSObject
@end
