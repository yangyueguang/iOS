//
//  WXModes.h
//  Freedom
#import <Realm/Realm.h>
#import <Foundation/Foundation.h>

@interface CRRouteLine : RLMObject
@property int CodeID;
@end

@interface WXModes : RLMObject
@property (assign, nonatomic) int id;
@property (assign, nonatomic) int code;
@property (nonatomic,assign) BOOL isLike; // 实际使用
@property (assign, nonatomic) double longitude;
@property (strong, nonatomic) NSArray *tags;
@property (nonatomic,strong) NSString *charge;
@property (nonatomic, strong) NSNumber<RLMInt> *groupId;
@end

typedef NS_ENUM(NSInteger, XContactStatus) {
    XContactStatusStranger,
    XContactStatusFriend,
    XContactStatusWait,
};
@interface WechatContact : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) XContactStatus status;
@property (nonatomic, assign) int recordID;
@property (nonatomic, assign) NSString *email;
@end

@interface WXUserSetting : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL star;
@property (nonatomic, assign) BOOL dismissTimeLine;
@property (nonatomic, assign) BOOL prohibitTimeLine;
@property (nonatomic, assign) BOOL blackList;
@end

@interface WXUserDetail : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *qqNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong, nonnull) NSArray *albumArray;
@property (nonatomic, strong) NSString *motto;
@property (nonatomic, strong) NSString *momentsWallURL;
@property (nonatomic, strong) NSString *remarkInfo;
@property (nonatomic, strong) NSString *remarkImagePath;
@property (nonatomic, strong) NSString *remarkImageURL;
@property (nonatomic, strong, nonnull) RLMArray<NSString*><RLMString> *tags;
@end

@interface WXUserChatSetting : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL noDisturb;
@property (nonatomic, strong) NSString *chatBGPath;
@end

@class WXUser;
@interface WXModel: NSObject
@property (nonatomic, strong) NSString *userID;/// 用户名
@property (nonatomic, strong) NSString *username;/// 昵称
@property (nonatomic, strong) NSString *nikeName;/// 头像URL
@property (nonatomic, strong) NSString *avatarURL;/// 头像Path
@property (nonatomic, strong) NSString *avatarPath;
- (WXUser*)groupMemberbyID:(NSString*)userID;
- (NSArray<WXUser*>*)groupMembers;
- (BOOL)isUser;
@end

@interface WXUser : WXModel/// 备注名
@property (nonatomic, strong) NSString *remarkName;
@property (nonatomic, strong) NSString *showName;
@property (nonatomic, strong) WXUserDetail *detailInfo;
@property (nonatomic, strong) WXUserSetting *userSetting;
@property (nonatomic, strong) WXUserChatSetting *chatSetting;
@end

@interface WXGroup : WXModel
@property (nonatomic, strong, nonnull) NSArray *users;
@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *myNikeName;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign) BOOL showNameInChat;
- (WXUser*)user;
@end

@interface WXUserGroup : NSObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong, nonnull) NSArray *users;
@end

@interface WXMomentDetail : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong, nonnull) RLMArray<RLMString> *images;
@end

@interface WXMomentComment : NSObject
@property (nonatomic, strong) WXUser *user;
@property (nonatomic, strong) WXUser *toUser;
@property (nonatomic, strong) NSString *content;
@end

@interface WXMomentExtension : NSObject
@property (nonatomic, strong, nonnull) NSArray *likedFriends;
@property (nonatomic, strong, nonnull) NSArray *comments;
@end

@interface WXMoment : NSObject
@property (nonatomic, strong) NSString *momentID;
@property (nonatomic, strong) WXUser *user;
@property (nonatomic, strong) NSDate *date;/// 详细内容
@property (nonatomic, strong) WXMomentDetail *detail;/// 附加（评论，赞）
@property (nonatomic, strong) WXMomentExtension *extension;
@end

@interface WXInfo : NSObject
@property (nonatomic, assign) int type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong, nonnull) NSArray *subImageArray;
@property (nonatomic, strong, nonnull) NSArray *userInfo;
@property (nonatomic, assign) BOOL showDisclosureIndicator;
@property (nonatomic, assign) BOOL disableHighlight;
@end


