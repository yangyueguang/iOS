//  TLDBManager.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "WXDBManager.h"
#import "WXUserHelper.h"
#import "TLEmojiBaseCell.h"
#import "TLDBMessageStoreSQL.h"
@interface WXDBManager : NSObject
/*DB队列（除IM相关）*/
@property (nonatomic, strong) FMDatabaseQueue *commonQueue;
/*与IM相关的DB队列*/
@property (nonatomic, strong) FMDatabaseQueue *messageQueue;
+ (WXDBManager *)sharedInstance;
@end
@class WXMessage;
@interface WXDBBaseStore : NSObject
/// 数据库操作队列(从TLDBManager中获取，默认使用commonQueue)
@property (nonatomic, weak) FMDatabaseQueue *dbQueue;
/*表创建*/
- (BOOL)createTable:(NSString*)tableName withSQL:(NSString*)sqlString;
/*
 *  执行带数组参数的sql语句 (增，删，改)*/
-(BOOL)excuteSQL:(NSString*)sqlString withArrParameter:(NSArray*)arrParameter;
/*
 *  执行带字典参数的sql语句 (增，删，改)*/
-(BOOL)excuteSQL:(NSString*)sqlString withDicParameter:(NSDictionary*)dicParameter;
/*
 *  执行格式化的sql语句 (增，删，改)*/
- (BOOL)excuteSQL:(NSString *)sqlString,...;
/*执行查询指令*/
- (void)excuteQuerySQL:(NSString*)sqlStr resultBlock:(void(^)(FMResultSet * rsSet))resultBlock;
@end
@interface WXDBMessageStore : WXDBBaseStore
#pragma mark - 添加
/*添加消息记录*/
- (BOOL)addMessage:(WXMessage *)message;
#pragma mark - 查询
/*获取与某个好友的聊天记录*/
- (void)messagesByUserID:(NSString *)userID
               partnerID:(NSString *)partnerID
                fromDate:(NSDate *)date
                   count:(NSUInteger)count
                complete:(void (^)(NSArray *data, BOOL hasMore))complete;
/*获取与某个好友/讨论组的聊天文件*/
- (NSArray *)chatFilesByUserID:(NSString *)userID partnerID:(NSString *)partnerID;
/*获取与某个好友/讨论组的聊天图片及视频*/
- (NSArray *)chatImagesAndVideosByUserID:(NSString *)userID partnerID:(NSString *)partnerID;
/*最后一条聊天记录（消息页用）*/
- (WXMessage *)lastMessageByUserID:(NSString *)userID partnerID:(NSString *)partnerID;
#pragma mark - 删除
/*删除单条消息*/
- (BOOL)deleteMessageByMessageID:(NSString *)messageID;
/*删除与某个好友/讨论组的所有聊天记录*/
- (BOOL)deleteMessagesByUserID:(NSString *)userID partnerID:(NSString *)partnerID;
/*删除用户的所有聊天记录*/
- (BOOL)deleteMessagesByUserID:(NSString *)userID;
@end
@interface WXDBConversationStore : WXDBBaseStore
/*新的会话（未读）*/
- (BOOL)addConversationByUid:(NSString *)uid fid:(NSString *)fid type:(NSInteger)type date:(NSDate *)date;
/*更新会话状态（已读）*/
- (void)updateConversationByUid:(NSString *)uid fid:(NSString *)fid;
/*查询所有会话*/
- (NSArray *)conversationsByUid:(NSString *)uid;
/*未读消息数*/
- (NSInteger)unreadMessageByUid:(NSString *)uid fid:(NSString *)fid;
/*删除单条会话*/
- (BOOL)deleteConversationByUid:(NSString *)uid fid:(NSString *)fid;
/*删除用户的所有会话*/
- (BOOL)deleteConversationsByUid:(NSString *)uid;
@end
@interface WXDBExpressionStore : WXDBBaseStore
/*添加表情包*/
- (BOOL)addExpressionGroup:(TLEmojiGroup *)group forUid:(NSString *)uid;
/*查询所有表情包*/
- (NSArray *)expressionGroupsByUid:(NSString *)uid;
/*删除表情包*/
- (BOOL)deleteExpressionGroupByID:(NSString *)gid forUid:(NSString *)uid;
/*拥有某表情包的用户数*/
- (NSInteger)countOfUserWhoHasExpressionGroup:(NSString *)gid;
@end
@interface WXDBFriendStore : WXDBBaseStore
- (BOOL)updateFriendsData:(NSArray *)friendData
                   forUid:(NSString *)uid;
- (BOOL)addFriend:(WXUser *)user forUid:(NSString *)uid;
- (NSMutableArray *)friendsDataByUid:(NSString *)uid;
- (BOOL)deleteFriendByFid:(NSString *)fid forUid:(NSString *)uid;
@end
@interface WXDBGroupStore : WXDBBaseStore
- (BOOL)updateGroupsData:(NSArray *)groupData
                  forUid:(NSString *)uid;
- (BOOL)addGroup:(WXGroup *)group forUid:(NSString *)uid;
- (NSMutableArray *)groupsDataByUid:(NSString *)uid;
- (BOOL)deleteGroupByGid:(NSString *)gid forUid:(NSString *)uid;
@end
