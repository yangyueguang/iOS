//  TLMessageManager.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "TLDBManager.h"
#import "TLUserHelper.h"
#import <MapKit/MapKit.h>
/*消息所有者类型*/
typedef NS_ENUM(NSInteger, TLPartnerType){
    TLPartnerTypeUser,          // 用户
    TLPartnerTypeGroup,         // 群聊
};
/*消息拥有者*/
typedef NS_ENUM(NSInteger, TLMessageOwnerType){
    TLMessageOwnerTypeUnknown,  // 未知的消息拥有者
    TLMessageOwnerTypeSystem,   // 系统消息
    TLMessageOwnerTypeSelf,     // 自己发送的消息
    TLMessageOwnerTypeFriend,   // 接收到的他人消息
};
/*消息发送状态*/
typedef NS_ENUM(NSInteger, TLMessageSendState){
    TLMessageSendSuccess,       // 消息发送成功
    TLMessageSendFail,          // 消息发送失败
};
/*消息读取状态*/
typedef NS_ENUM(NSInteger, TLMessageReadState) {
    TLMessageUnRead,            // 消息未读
    TLMessageReaded,            // 消息已读
};

@interface TLConversation : NSObject
/*会话类型（个人，讨论组，企业号）*/
@property (nonatomic, assign) TLConversationType convType;
/*消息提醒类型*/
@property (nonatomic, assign) TLMessageRemindType remindType;
/*用户ID*/
@property (nonatomic, strong) NSString *partnerID;
/*用户名*/
@property (nonatomic, strong) NSString *partnerName;
/*头像地址（网络）*/
@property (nonatomic, strong) NSString *avatarURL;
/*头像地址（本地）*/
@property (nonatomic, strong) NSString *avatarPath;
/*时间*/
@property (nonatomic, strong) NSDate *date;
/*消息展示内容*/
@property (nonatomic, strong) NSString *content;
/*提示红点类型*/
@property (nonatomic, assign, readonly) TLClueType clueType;
@property (nonatomic, assign, readonly) BOOL isRead;
/*未读数量*/
@property (nonatomic, assign) NSInteger unreadCount;
- (void)updateUserInfo:(TLUser *)user;
- (void)updateGroupInfo:(TLGroup *)group;
@end
@protocol TLMessageProtocol <NSObject>
- (NSString *)messageCopy;
- (NSString *)conversationContent;
@end

@interface TLMessageFrame : NSObject
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize contentSize;
@end
@interface TLMessage : NSObject <TLMessageProtocol>{
    TLMessageFrame *kMessageFrame;
}
@property (nonatomic, strong) NSString *messageID;                  // 消息ID
@property (nonatomic, strong) NSString *userID;                     // 发送者ID
@property (nonatomic, strong) NSString *friendID;                   // 接收者ID
@property (nonatomic, strong) NSString *groupID;                    // 讨论组ID（无则为nil）
@property (nonatomic, strong) NSDate *date;                         // 发送时间
@property (nonatomic, strong) id<TLChatUserProtocol> fromUser;      // 发送者
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showName;
@property (nonatomic, assign) TLPartnerType partnerType;            // 对方类型
@property (nonatomic, assign) TLMessageType messageType;            // 消息类型
@property (nonatomic, assign) TLMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) TLMessageReadState readState;         // 读取状态
@property (nonatomic, assign) TLMessageSendState sendState;         // 发送状态
@property (nonatomic, strong) NSMutableDictionary *content;
@property (nonatomic, strong) TLMessageFrame *messageFrame;         // 消息frame
+ (TLMessage *)createMessageByType:(TLMessageType)type;
@end
@interface TLImageMessage : TLMessage
@property (nonatomic, strong) NSString *imagePath;                  // 本地图片Path
@property (nonatomic, strong) NSString *imageURL;                   // 网络图片URL
@property (nonatomic, assign) CGSize imageSize;
@end

@protocol TLMessageManagerConvVCDelegate <NSObject>
- (void)updateConversationData;
@end
@interface TLMessageManager : NSObject
@property (nonatomic, assign) id messageDelegate;
@property (nonatomic, assign) id<TLMessageManagerConvVCDelegate>conversationDelegate;
@property (nonatomic, strong, readonly) NSString *userID;
@property (nonatomic, strong) TLDBMessageStore *messageStore;
@property (nonatomic, strong) TLDBConversationStore *conversationStore;
+ (TLMessageManager *)sharedInstance;
#pragma mark - 发送
- (void)sendMessage:(TLMessage *)message
           progress:(void (^)(TLMessage *, CGFloat))progress
            success:(void (^)(TLMessage *))success
            failure:(void (^)(TLMessage *))failure;
#pragma mark - 查询
/*查询聊天记录*/
- (void)messageRecordForPartner:(NSString *)partnerID
                       fromDate:(NSDate *)date
                          count:(NSUInteger)count
                       complete:(void (^)(NSArray *, BOOL))complete;
/*查询聊天文件*/
- (void)chatFilesForPartnerID:(NSString *)partnerID
                    completed:(void (^)(NSArray *))completed;
/*查询聊天图片*/
- (void)chatImagesAndVideosForPartnerID:(NSString *)partnerID
                              completed:(void (^)(NSArray *))completed;
#pragma mark - 删除
/*删除单条聊天记录*/
- (BOOL)deleteMessageByMsgID:(NSString *)msgID;
/*删除与某好友的聊天记录*/
- (BOOL)deleteMessagesByPartnerID:(NSString *)partnerID;
/*删除所有聊天记录*/
- (BOOL)deleteAllMessages;
- (BOOL)addConversationByMessage:(TLMessage *)message;
- (void)conversationRecord:(void (^)(NSArray *))complete;
- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID;


- (void)requestClientInitInfoSuccess:(void (^)(id))clientInitInfo
                             failure:(void (^)(NSString *))error;
- (void)userLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      success:(void (^)(id))userInfo
                      failure:(void (^)(NSString *))error;
- (NSMutableArray *)chatDetailDataByUserInfo:(TLUser *)userInfo;
- (NSMutableArray *)chatDetailDataByGroupInfo:(TLGroup *)groupInfo;
@end
