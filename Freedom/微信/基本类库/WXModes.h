//
//  WXModes.h
//  Freedom
//
//  Created by Chao Xue 薛超 on 2019/1/11.
//  Copyright © 2019 薛超. All rights reserved.
//
#import <Realm/Realm.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface CRRouteLine : RLMObject
@property int CodeID;
@end
RLM_ARRAY_TYPE(CRRouteLine)
@interface WXModes : RLMObject
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int code;
@property (nonatomic,assign) BOOL isLike; // 实际使用
@property (assign, nonatomic) double longitude;
//@property (readonly,nonatomic) RLMLinkingObjects *parent;
@property (strong, nonatomic) RLMArray<CRRouteLine *><CRRouteLine> *tags;
@property (nonatomic,strong) NSString *charge;
@property (nonatomic, strong) NSNumber<RLMInt> *groupId;
@end
RLM_ARRAY_TYPE(WXModes)
typedef NS_ENUM(NSInteger, TLChatUserType) {
    TLChatUserTypeUser = 0,
    TLChatUserTypeGroup,
};
typedef NS_ENUM(NSInteger, TLContactStatus) {
    TLContactStatusStranger,
    TLContactStatusFriend,
    TLContactStatusWait,
};
typedef NS_ENUM(int, TLInfoType) {
    TLInfoTypeDefaultType,
    TLInfoTypeTitleOnly,
    TLInfoTypeImages,
    TLInfoTypeMutiRow,
    TLInfoTypeButton,
    TLInfoTypeOther,
};
typedef NS_ENUM(NSInteger, TLSettingItemType) {
    TLSettingItemTypeDefalut1 = 0,
    TLSettingItemTypeTitleButton,
    TLSettingItemTypeSwitchBtn,
    TLSettingItemTypeOther,
};
@interface WechatContact : RLMObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) TLContactStatus status;
@property (nonatomic, assign) int recordID;
@property (nonatomic, assign) NSString *email;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@end
RLM_ARRAY_TYPE(WechatContact)
@interface WXUserSetting : RLMObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL star;
@property (nonatomic, assign) BOOL dismissTimeLine;
@property (nonatomic, assign) BOOL prohibitTimeLine;
@property (nonatomic, assign) BOOL blackList;
@end
RLM_ARRAY_TYPE(WXUserSetting)
@interface WXUserDetail : RLMObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *qqNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong, nonnull) RLMArray<RLMString> *albumArray;
@property (nonatomic, strong) NSString *motto;
@property (nonatomic, strong) NSString *momentsWallURL;
@property (nonatomic, strong) NSString *remarkInfo;
@property (nonatomic, strong) NSString *remarkImagePath;
@property (nonatomic, strong) NSString *remarkImageURL;
@property (nonatomic, strong, nonnull) RLMArray<NSString*><RLMString> *tags;
@end
RLM_ARRAY_TYPE(WXUserDetail)
@interface WXUserChatSetting : RLMObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL noDisturb;
@property (nonatomic, strong) NSString *chatBGPath;
@end
RLM_ARRAY_TYPE(WXUserChatSetting)
@interface WXUser : RLMObject
@property (nonatomic, strong) NSString *userID;/// 用户名
@property (nonatomic, strong) NSString *username;/// 昵称
@property (nonatomic, strong) NSString *nikeName;/// 头像URL
@property (nonatomic, strong) NSString *avatarURL;/// 头像Path
@property (nonatomic, strong) NSString *avatarPath;/// 备注名
@property (nonatomic, strong) NSString *remarkName;
@property (nonatomic, strong) NSString *showName;
@property (nonatomic, strong) WXUserDetail *detailInfo;
@property (nonatomic, strong) WXUserSetting *userSetting;
@property (nonatomic, strong) WXUserChatSetting *chatSetting;
@end
RLM_ARRAY_TYPE(WXUser)
@interface WXGroup : RLMObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong, nonnull) NSString *groupAvatarPath;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong, nonnull) RLMArray<WXUser*><WXUser> *users;
@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *myNikeName;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign) BOOL showNameInChat;
@end
RLM_ARRAY_TYPE(WXGroup)
@interface WXUserGroup : RLMObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong, nonnull) RLMArray<WXUser*><WXUser> *users;
@property (nonatomic, assign, readonly) NSInteger count;
@end
RLM_ARRAY_TYPE(WXUserGroup)
@interface WXMomentFrame : RLMObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightDetail;
@property (nonatomic, assign) CGFloat heightExtension;
@end
RLM_ARRAY_TYPE(WXMomentFrame)
@interface WXMomentDetailFrame : RLMObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightText;
@property (nonatomic, assign) CGFloat heightImages;
@end
RLM_ARRAY_TYPE(WXMomentDetailFrame)
@interface WXMomentDetail : RLMObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, nonnull) RLMArray<RLMString> *images;
@property (nonatomic, strong) WXMomentDetailFrame *detailFrame;
@end
RLM_ARRAY_TYPE(WXMomentDetail)
@interface WXMomentExtensionFrame : RLMObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat heightLiked;
@property (nonatomic, assign) CGFloat heightComments;
@end
RLM_ARRAY_TYPE(WXMomentExtensionFrame)

@interface WXMomentCommentFrame : RLMObject
    @property (nonatomic, assign) CGFloat height;
    @end
RLM_ARRAY_TYPE(WXMomentCommentFrame)
@interface WXMomentComment : RLMObject
    @property (nonatomic, strong) WXUser *user;
    @property (nonatomic, strong) WXUser *toUser;
    @property (nonatomic, strong) NSString *content;
    @property (nonatomic, strong) WXMomentCommentFrame *commentFrame;
    @end
RLM_ARRAY_TYPE(WXMomentComment)
@interface WXMomentExtension : RLMObject
@property (nonatomic, strong, nonnull) RLMArray<WXUser*><WXUser> *likedFriends;
@property (nonatomic, strong, nonnull) RLMArray<WXMomentComment*><WXMomentComment> *comments;
@property (nonatomic, strong) WXMomentExtensionFrame *extensionFrame;
@end
RLM_ARRAY_TYPE(WXMomentExtension)
@interface WXMoment : RLMObject
@property (nonatomic, strong) NSString *momentID;
@property (nonatomic, strong) WXUser *user;
@property (nonatomic, strong) NSDate *date;/// 详细内容
@property (nonatomic, strong) WXMomentDetail *detail;/// 附加（评论，赞）
@property (nonatomic, strong) WXMomentExtension *extension;
@property (nonatomic, strong) WXMomentFrame *momentFrame;
@end
RLM_ARRAY_TYPE(WXMoment)

@interface WXInfo : RLMObject
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong, nonnull) RLMArray<RLMString> *subImageArray;
@property (nonatomic, strong, nonnull) RLMArray<RLMString> *userInfo;
//@property (nonatomic, strong) UIColor *titleColor;
//@property (nonatomic, strong) UIColor *buttonColor;
//@property (nonatomic, strong) UIColor *buttonHLColor;
//@property (nonatomic, strong) UIColor *buttonBorderColor;
@property (nonatomic, assign) BOOL showDisclosureIndicator;
@property (nonatomic, assign) BOOL disableHighlight;
@end
RLM_ARRAY_TYPE(WXInfo)
@interface WXMenuItem : RLMObject
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong, nullable) NSString *rightIconURL;
@property (nonatomic, assign) BOOL showRightRedPoint;
@end
RLM_ARRAY_TYPE(WXMenuItem)

@interface WXSettingItem : RLMObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *rightImagePath;
@property (nonatomic, strong) NSString *rightImageURL;
@property (nonatomic, assign) BOOL showDisclosureIndicator;
@property (nonatomic, assign) BOOL disableHighlight;
@property (nonatomic, assign) TLSettingItemType type;
@end
RLM_ARRAY_TYPE(WXSettingItem)
@interface WXSettingGroup : RLMObject
@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *footerTitle;
@property (nonatomic, strong, nonnull) RLMArray<WXSettingItem*><WXSettingItem> *items;
@property (nonatomic, assign, readonly) CGFloat headerHeight;
@property (nonatomic, assign, readonly) CGFloat footerHeight;
//@property (nonatomic, assign, readonly) NSUInteger count;
@end
RLM_ARRAY_TYPE(WXSettingGroup)
NS_ASSUME_NONNULL_END
