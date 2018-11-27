//  TLUserHelper.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "TLEmojiBaseCell.h"
typedef NS_ENUM(NSInteger, TLChatUserType) {
    TLChatUserTypeUser = 0,
    TLChatUserTypeGroup,
};
//  TLContact.h
//  Freedom
// Created by Super
/*通讯录 Model*/
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TLContactStatus) {
    TLContactStatusStranger,
    TLContactStatusFriend,
    TLContactStatusWait,
};
@interface TLContact : NSObject
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

@protocol TLChatUserProtocol <NSObject>
@property (nonatomic, strong, readonly) NSString *chat_userID;
@property (nonatomic, strong, readonly) NSString *chat_username;
@property (nonatomic, strong, readonly) NSString *chat_avatarURL;
@property (nonatomic, strong, readonly) NSString *chat_avatarPath;
@property (nonatomic, assign, readonly) NSInteger chat_userType;
@optional;
- (id)groupMemberByID:(NSString *)userID;
- (NSArray *)groupMembers;
@end
@interface TLUserSetting : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL star;
@property (nonatomic, assign) BOOL dismissTimeLine;
@property (nonatomic, assign) BOOL prohibitTimeLine;
@property (nonatomic, assign) BOOL blackList;
@end
@interface TLUserDetail : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *qqNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSArray *albumArray;
@property (nonatomic, strong) NSString *motto;
@property (nonatomic, strong) NSString *momentsWallURL;
/// 备注信息
@property (nonatomic, strong) NSString *remarkInfo;
/// 备注图片（本地地址）
@property (nonatomic, strong) NSString *remarkImagePath;
/// 备注图片 (URL)
@property (nonatomic, strong) NSString *remarkImageURL;
/// 标签
@property (nonatomic, strong) NSMutableArray *tags;
@end
@interface TLUserChatSetting : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL top;
@property (nonatomic, assign) BOOL noDisturb;
@property (nonatomic, strong) NSString *chatBGPath;
@end
@interface TLUser : NSObject<TLChatUserProtocol>/// 用户ID
@property (nonatomic, strong) NSString *userID;/// 用户名
@property (nonatomic, strong) NSString *username;/// 昵称
@property (nonatomic, strong) NSString *nikeName;/// 头像URL
@property (nonatomic, strong) NSString *avatarURL;/// 头像Path
@property (nonatomic, strong) NSString *avatarPath;/// 备注名
@property (nonatomic, strong) NSString *remarkName;
/// 界面显示名称
@property (nonatomic, strong, readonly) NSString *showName;
#pragma mark - 其他
@property (nonatomic, strong) TLUserDetail *detailInfo;
@property (nonatomic, strong) TLUserSetting *userSetting;
@property (nonatomic, strong) TLUserChatSetting *chatSetting;
#pragma mark - 列表用
/*拼音来源：备注 > 昵称 > 用户名*/
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@end

@interface TLGroup : NSObject <TLChatUserProtocol>
/*讨论组名称*/
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *groupAvatarPath;
/*讨论组ID*/
@property (nonatomic, strong) NSString *groupID;
/*讨论组成员*/
@property (nonatomic, strong) NSMutableArray *users;
/*群公告*/
@property (nonatomic, strong) NSString *post;
/*我的群昵称*/
@property (nonatomic, strong) NSString *myNikeName;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *pinyinInitial;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, assign) BOOL showNameInChat;
- (void)addObject:(id)anObject;
- (id)objectAtIndex:(NSUInteger)index;
- (TLUser *)memberByUserID:(NSString *)uid;
@end

@interface TLUserGroup : NSObject
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, assign, readonly) NSInteger count;
- (id) initWithGroupName:(NSString *)groupName users:(NSMutableArray *)users;
- (void)addObject:(id)anObject;
- (id)objectAtIndex:(NSUInteger)index;
@end
@interface TLFriendHelper : NSObject
/// 好友列表默认项
@property (nonatomic, strong) TLUserGroup *defaultGroup;
#pragma mark - 好友
/// 好友数据(原始)
@property (nonatomic, strong) NSMutableArray *friendsData;
/// 格式化的好友数据（二维数组，列表用）
@property (nonatomic, strong) NSMutableArray *data;
/// 格式化好友数据的分组标题
@property (nonatomic, strong) NSMutableArray *sectionHeaders;
///  好友数量
@property (nonatomic, assign, readonly) NSInteger friendCount;
@property (nonatomic, strong) void(^dataChangedBlock)(NSMutableArray *friends, NSMutableArray *headers, NSInteger friendCount);
#pragma mark - 群
/// 群数据
@property (nonatomic, strong) NSMutableArray *groupsData;
#pragma mark - 标签
/// 标签数据
@property (nonatomic, strong) NSMutableArray *tagsData;
+ (TLFriendHelper *)sharedFriendHelper;
- (TLUser *)getFriendInfoByUserID:(NSString *)userID;
- (TLGroup *)getGroupInfoByGroupID:(NSString *)groupID;
/*获取铜须路好友
 *
 *  @param success 获取成功，异步返回（通讯录列表，格式化的通讯录列表，格式化的通讯录列表组标题）
 *  @param failed  获取失败*/
+ (void)tryToGetAllContactsSuccess:(void (^)(NSArray *data, NSArray *formatData, NSArray *headers))success
                            failed:(void (^)())failed;
- (NSMutableArray *)friendDetailArrayByUserInfo:(TLUser *)userInfo;
- (NSMutableArray *)friendDetailSettingArrayByUserInfo:(TLUser *)userInfo;
@end


@interface TLUserHelper : NSObject
@property (nonatomic, strong) TLUser *user;
+ (TLUserHelper *) sharedHelper;
- (void)emojiGroupDataComplete:(void (^)(NSMutableArray *))complete;
- (void)updateEmojiGroupData;
@end
