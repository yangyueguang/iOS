//  TLDBManager.m
//  Freedom
// Created by Super
#import "WXDBManager.h"
#import "WXUserHelper.h"
#import "WXMessageManager.h"
#import "NSFileManager+expanded.h"


@implementation WXDBMessageStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [WXDBManager sharedInstance].messageQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            DLog(@"DB: 聊天记录表创建失败");
        }
    }
    return self;
}
- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_MESSAGE_TABLE, MESSAGE_TABLE_NAME];
    return [self createTable:MESSAGE_TABLE_NAME withSQL:sqlString];
}
- (BOOL)addMessage:(WXMessage *)message{
    if (message == nil || message.messageID == nil || message.userID == nil || (message.friendID == nil && message.groupID == nil)) {
        return NO;
    }
    
    NSString *fid = @"";
    NSString *subfid;
    if (message.partnerType == TLPartnerTypeUser) {
        fid = message.friendID;
    }else{
        fid = message.groupID;
        subfid = message.friendID;
    }
    
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_MESSAGE, MESSAGE_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        message.messageID,
                        message.userID,
                        fid,
                        (subfid),
                        [NSString stringWithFormat:@"%lf", [message.date timeIntervalSince1970]],
                        [NSNumber numberWithInteger:message.partnerType],
                        [NSNumber numberWithInteger:message.ownerTyper],
                        [NSNumber numberWithInteger:message.messageType],
                        [message.content mj_JSONString],
                        [NSNumber numberWithInteger:message.sendState],
                        [NSNumber numberWithInteger:message.readState],
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}
- (void)messagesByUserID:(NSString *)userID partnerID:(NSString *)partnerID fromDate:(NSDate *)date count:(NSUInteger)count complete:(void (^)(NSArray *, BOOL))complete{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:
                           SQL_SELECT_MESSAGES_PAGE,
                           MESSAGE_TABLE_NAME,
                           userID,
                           partnerID,
                           [NSString stringWithFormat:@"%lf", date.timeIntervalSince1970],
                           (long)(count + 1)];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXMessage * message = [self p_createDBMessageByFMResultSet:retSet];
            [data insertObject:message atIndex:0];
        }
        [retSet close];
    }];
    
    BOOL hasMore = NO;
    if (data.count == count + 1) {
        hasMore = YES;
        [data removeObjectAtIndex:0];
    }
    complete(data, hasMore);
}
- (BOOL)isToday:(NSDate *)date{
    NSDateComponents *components1 = [date YMDComponents];
    NSDateComponents *components2 = [[NSDate date]YMDComponents];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}
- (NSArray *)chatFilesByUserID:(NSString *)userID partnerID:(NSString *)partnerID{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHAT_FILES, MESSAGE_TABLE_NAME, userID, partnerID];
    
    __block NSDate *lastDate = [NSDate date];
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXMessage * message = [self p_createDBMessageByFMResultSet:retSet];
            if ([self isToday:message.date]) {
                [array addObject:message];
            }else{
                lastDate = message.date;
                if (array.count > 0) {
                    [data addObject:array];
                }
                array = [[NSMutableArray alloc] initWithObjects:message, nil];
            }
        }
        if (array.count > 0) {
            [data addObject:array];
        }
        [retSet close];
    }];
    return data;
}
- (NSArray *)chatImagesAndVideosByUserID:(NSString *)userID partnerID:(NSString *)partnerID{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CHAT_MEDIA, MESSAGE_TABLE_NAME, userID, partnerID];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXMessage *message = [self p_createDBMessageByFMResultSet:retSet];
            [data addObject:message];
        }
        [retSet close];
    }];
    return data;
}
- (WXMessage *)lastMessageByUserID:(NSString *)userID partnerID:(NSString *)partnerID{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_LAST_MESSAGE, MESSAGE_TABLE_NAME, MESSAGE_TABLE_NAME, userID, partnerID];
    __block WXMessage * message;
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            message = [self p_createDBMessageByFMResultSet:retSet];
        }
        [retSet close];
    }];
    return message;
}
- (BOOL)deleteMessageByMessageID:(NSString *)messageID{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_MESSAGE, MESSAGE_TABLE_NAME, messageID];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
- (BOOL)deleteMessagesByUserID:(NSString *)userID partnerID:(NSString *)partnerID;{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND_MESSAGES, MESSAGE_TABLE_NAME, userID, partnerID];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
- (BOOL)deleteMessagesByUserID:(NSString *)userID{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_USER_MESSAGES, MESSAGE_TABLE_NAME, userID];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
#pragma mark - Private Methods -
- (WXMessage *)p_createDBMessageByFMResultSet:(FMResultSet *)retSet{
    TLMessageType type = [retSet intForColumn:@"msg_type"];
    WXMessage * message = [WXMessage createMessageByType:type];
    message.messageID = [retSet stringForColumn:@"msgid"];
    message.userID = [retSet stringForColumn:@"uid"];
    message.partnerType = [retSet intForColumn:@"partner_type"];
    if (message.partnerType == TLPartnerTypeGroup) {
        message.groupID = [retSet stringForColumn:@"fid"];
        message.friendID = [retSet stringForColumn:@"subfid"];
    }else{
        message.friendID = [retSet stringForColumn:@"fid"];
        message.groupID = [retSet stringForColumn:@"subfid"];
    }
    NSString *dateString = [retSet stringForColumn:@"date"];
    message.date = [NSDate dateWithTimeIntervalSince1970:dateString.doubleValue];
    message.ownerTyper = [retSet intForColumn:@"own_type"];
    message.messageType = [retSet intForColumn:@"msg_type"];
    NSString *content = [retSet stringForColumn:@"content"];
    message.content = [[NSMutableDictionary alloc] initWithDictionary:[content mj_JSONObject]];
    message.sendState = [retSet intForColumn:@"send_status"];
    message.readState = [retSet intForColumn:@"received_status"];
    return message;
}
@end
@interface WXDBConversationStore ()
@property (nonatomic, strong) WXDBMessageStore *messageStore;
@end
@implementation WXDBConversationStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [WXDBManager sharedInstance].messageQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            DLog(@"DB: 聊天记录表创建失败");
        }
    }
    return self;
}
- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_CONV_TABLE, CONV_TABLE_NAME];
    return [self createTable:CONV_TABLE_NAME withSQL:sqlString];
}
- (BOOL)addConversationByUid:(NSString *)uid fid:(NSString *)fid type:(NSInteger)type date:(NSDate *)date;{
    NSInteger unreadCount = [self unreadMessageByUid:uid fid:fid] + 1;
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_CONV, CONV_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        uid,
                        fid,
                        [NSNumber numberWithInteger:type],
                        [NSString stringWithFormat:@"%lf", [date timeIntervalSince1970]],
                        [NSNumber numberWithInteger:unreadCount],
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}
/*更新会话状态（已读）*/
- (void)updateConversationByUid:(NSString *)uid fid:(NSString *)fid{
}
/*查询所有会话*/
- (NSArray *)conversationsByUid:(NSString *)uid{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_CONVS, CONV_TABLE_NAME, uid];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXConversation *conversation = [[WXConversation alloc] init];
            conversation.partnerID = [retSet stringForColumn:@"fid"];
            conversation.convType = [retSet intForColumn:@"conv_type"];
            NSString *dateString = [retSet stringForColumn:@"date"];
            conversation.date = [NSDate dateWithTimeIntervalSince1970:dateString.doubleValue];
            conversation.unreadCount = [retSet intForColumn:@"unread_count"];
            [data addObject:conversation];
        }
        [retSet close];
    }];
    
    // 获取conv对应的msg
    for (WXConversation *conversation in data) {
        WXMessage * message = [self.messageStore lastMessageByUserID:uid partnerID:conversation.partnerID];
        if (message) {
            conversation.content = [message conversationContent];
            conversation.date = message.date;
        }
    }
    
    return data;
}
- (NSInteger)unreadMessageByUid:(NSString *)uid fid:(NSString *)fid{
    __block NSInteger unreadCount = 0;
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_CONV_UNREAD, CONV_TABLE_NAME, uid, fid];
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        if ([retSet next]) {
            unreadCount = [retSet intForColumn:@"unread_count"];
        }
        [retSet close];
    }];
    return unreadCount;
}
/*删除单条会话*/
- (BOOL)deleteConversationByUid:(NSString *)uid fid:(NSString *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_CONV, CONV_TABLE_NAME, uid, fid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
/*删除用户的所有会话*/
- (BOOL)deleteConversationsByUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_ALL_CONVS, CONV_TABLE_NAME, uid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
#pragma mark - Getter -
- (WXDBMessageStore *)messageStore{
    if (_messageStore == nil) {
        _messageStore = [[WXDBMessageStore alloc] init];
    }
    return _messageStore;
}
@end
@implementation WXDBExpressionStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [WXDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            DLog(@"DB: 聊天记录表创建失败");
        }
    }
    return self;
}
- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_EXP_GROUP_TABLE, EXP_GROUP_TABLE_NAME];
    BOOL ok = [self createTable:EXP_GROUP_TABLE_NAME withSQL:sqlString];
    if (!ok) {
        return NO;
    }
    sqlString = [NSString stringWithFormat:SQL_CREATE_EXPS_TABLE, EXPS_TABLE_NAME];
    ok = [self createTable:EXPS_TABLE_NAME withSQL:sqlString];
    return ok;
}
#pragma mark - 表情组
- (BOOL)addExpressionGroup:(TLEmojiGroup *)group forUid:(NSString *)uid{
    // 添加表情包
    NSString *sqlString = [NSString stringWithFormat:SQL_ADD_EXP_GROUP, EXP_GROUP_TABLE_NAME];
    NSArray *arr = [NSArray arrayWithObjects:
                    uid,
                    group.groupID,
                    [NSNumber numberWithInteger:group.type],
                    (group.groupName),
                    (group.groupInfo),
                    (group.groupDetailInfo),
                    [NSNumber numberWithInteger:group.count],
                    (group.authID),
                    (group.authName),
                    [NSString stringWithFormat:@"%lf", [group.date timeIntervalSince1970]],
                    @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arr];
    if (!ok) {
        return NO;
    }
    // 添加表情包里的所有表情
    ok = [self addExpressions:group.data toGroupID:group.groupID];
    return ok;
}
- (NSArray *)expressionGroupsByUid:(NSString *)uid{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid];
    
    // 读取表情包信息
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLEmojiGroup *group = [[TLEmojiGroup alloc] init];
            group.groupID = [retSet stringForColumn:@"gid"];
            group.type = [retSet intForColumn:@"type"];
            group.groupName = [retSet stringForColumn:@"name"];
            group.groupInfo = [retSet stringForColumn:@"desc"];
            group.groupDetailInfo = [retSet stringForColumn:@"detail"];
            group.count = [retSet intForColumn:@"count"];
            group.authID = [retSet stringForColumn:@"auth_id"];
            group.authName = [retSet stringForColumn:@"auth_name"];
            group.status = TLEmojiGroupStatusDownloaded;
            [data addObject:group];
        }
        [retSet close];
    }];
    
    // 读取表情包的所有表情信息
    for (TLEmojiGroup *group in data) {
        group.data = [self expressionsForGroupID:group.groupID];
    }
    
    return data;
}
- (BOOL)deleteExpressionGroupByID:(NSString *)gid forUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_EXP_GROUP, EXP_GROUP_TABLE_NAME, uid, gid];
    return [self excuteSQL:sqlString, nil];
}
- (NSInteger)countOfUserWhoHasExpressionGroup:(NSString *)gid{
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_COUNT_EXP_GROUP_USERS, EXP_GROUP_TABLE_NAME, gid];
    __block NSInteger count = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        count = [db intForQuery:sqlString];
    }];
    return count;
}
#pragma mark - 表情
- (BOOL)addExpressions:(NSArray *)expressions toGroupID:(NSString *)groupID{
    for (TLEmoji *emoji in expressions) {
        NSString *sqlString = [NSString stringWithFormat:SQL_ADD_EXP, EXPS_TABLE_NAME];
        NSArray *arr = [NSArray arrayWithObjects:
                        groupID,
                        emoji.emojiID,
                        (emoji.emojiName),
                        @"", @"", @"", @"", @"", nil];
        BOOL ok = [self excuteSQL:sqlString withArrParameter:arr];
        if (!ok) {
            return NO;
        }
    }
    return YES;
}
- (NSMutableArray *)expressionsForGroupID:(NSString *)groupID{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat: SQL_SELECT_EXPS, EXPS_TABLE_NAME, groupID];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            TLEmoji *emoji = [[TLEmoji alloc] init];
            emoji.groupID = [retSet stringForColumn:@"gid"];
            emoji.emojiID = [retSet stringForColumn:@"eid"];
            emoji.emojiName = [retSet stringForColumn:@"name"];
            [data addObject:emoji];
        }
        [retSet close];
    }];
    
    return data;
}
@end
@implementation WXDBFriendStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [WXDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            DLog(@"DB: 好友表创建失败");
        }
    }
    return self;
}
- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_FRIENDS_TABLE, FRIENDS_TABLE_NAME];
    return [self createTable:FRIENDS_TABLE_NAME withSQL:sqlString];
}
- (BOOL)addFriend:(WXUser *)user forUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_FRIEND, FRIENDS_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        (uid),
                        (user.userID),
                        (user.username),
                        (user.nikeName),
                        (user.avatarURL),
                        (user.remarkName),
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}
- (BOOL)updateFriendsData:(NSArray *)friendData forUid:(NSString *)uid{
    NSArray *oldData = [self friendsDataByUid:uid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (WXUser *user in friendData) {
            [newDataHash setValue:@"YES" forKey:user.userID];
        }
        for (WXUser *user in oldData) {
            if ([newDataHash objectForKey:user.userID] == nil) {
                BOOL ok = [self deleteFriendByFid:user.userID forUid:uid];
                if (!ok) {
                    DLog(@"DBError: 删除过期好友失败");
                }
            }
        }
    }
    
    for (WXUser *user in friendData) {
        BOOL ok = [self addFriend:user forUid:uid];
        if (!ok) {
            return ok;
        }
    }
    
    return YES;
}
- (NSMutableArray *)friendsDataByUid:(NSString *)uid{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_FRIENDS, FRIENDS_TABLE_NAME, uid];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXUser *user = [[WXUser alloc] init];
            user.userID = [retSet stringForColumn:@"uid"];
            user.username = [retSet stringForColumn:@"username"];
            user.nikeName = [retSet stringForColumn:@"nikename"];
            user.avatarURL = [retSet stringForColumn:@"avatar"];
            user.remarkName = [retSet stringForColumn:@"remark"];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}
- (BOOL)deleteFriendByFid:(NSString *)fid forUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_FRIEND, FRIENDS_TABLE_NAME, uid, fid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
@end
@implementation WXDBGroupStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [WXDBManager sharedInstance].commonQueue;
        BOOL ok = [self createTable];
        if (!ok) {
            DLog(@"DB: 讨论组表创建失败");
        }
    }
    return self;
}
- (BOOL)createTable{
    NSString *sqlString = [NSString stringWithFormat:SQL_CREATE_GROUPS_TABLE, GROUPS_TABLE_NAME];
    BOOL ok = [self createTable:GROUPS_TABLE_NAME withSQL:sqlString];
    if (ok) {
        sqlString = [NSString stringWithFormat:SQL_CREATE_GROUP_MEMBERS_TABLE, GROUP_MEMBER_TABLE_NAMGE];
        ok = [self createTable:GROUP_MEMBER_TABLE_NAMGE withSQL:sqlString];
    }
    return ok;
}
- (BOOL)addGroup:(WXGroup *)group forUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_GROUP, GROUPS_TABLE_NAME];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        (uid),
                        (group.groupID),
                        (group.groupName),
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    if (ok) {
        // 将通讯录成员插入数据库
        ok = [self addGroupMembers:group.users forUid:uid andGid:group.groupID];
    }
    return ok;
}
- (BOOL)updateGroupsData:(NSArray *)groupData forUid:(NSString *)uid{
    NSArray *oldData = [self groupsDataByUid:uid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (WXGroup *group in groupData) {
            [newDataHash setValue:@"YES" forKey:group.groupID];
        }
        for (WXGroup *group in oldData) {
            if ([newDataHash objectForKey:group.groupID] == nil) {
                BOOL ok = [self deleteGroupByGid:group.groupID forUid:uid];
                if (!ok) {
                    DLog(@"DBError: 删除过期讨论组失败！");
                }
            }
        }
    }
    
    // 将数据插入数据库
    for (WXGroup *group in groupData) {
        BOOL ok = [self addGroup:group forUid:uid];
        if (!ok) {
            return ok;
        }
    }
    
    return YES;
}
- (NSMutableArray *)groupsDataByUid:(NSString *)uid{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_GROUPS, GROUPS_TABLE_NAME, uid];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXGroup *group = [[WXGroup alloc] init];
            group.groupID = [retSet stringForColumn:@"gid"];
            group.groupName = [retSet stringForColumn:@"name"];
            [data addObject:group];
        }
        [retSet close];
    }];
    
    // 获取讨论组成员
    for (WXGroup *group in data) {
        group.users = [self groupMembersForUid:uid andGid:group.groupID];
    }
    
    return data;
}
- (BOOL)deleteGroupByGid:(NSString *)gid forUid:(NSString *)uid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_GROUP, GROUPS_TABLE_NAME, uid, gid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
#pragma mark - Group Members
- (BOOL)addGroupMember:(WXUser *)user forUid:(NSString *)uid andGid:(NSString *)gid{
    NSString *sqlString = [NSString stringWithFormat:SQL_UPDATE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE];
    NSArray *arrPara = [NSArray arrayWithObjects:
                        (uid),
                        (gid),
                        (user.userID),
                        (user.username),
                        (user.nikeName),
                        (user.avatarURL),
                        (user.remarkName),
                        @"", @"", @"", @"", @"", nil];
    BOOL ok = [self excuteSQL:sqlString withArrParameter:arrPara];
    return ok;
}
- (BOOL)addGroupMembers:(NSArray *)users forUid:(NSString *)uid andGid:(NSString *)gid{
    NSArray *oldData = [self groupMembersForUid:uid andGid:gid];
    if (oldData.count > 0) {
        // 建立新数据的hash表，用于删除数据库中的过时数据
        NSMutableDictionary *newDataHash = [[NSMutableDictionary alloc] init];
        for (WXUser *user in users) {
            [newDataHash setValue:@"YES" forKey:user.userID];
        }
        for (WXUser *user in oldData) {
            if ([newDataHash objectForKey:user.userID] == nil) {
                BOOL ok = [self deleteGroupMemberForUid:uid gid:gid andFid:user.userID];
                if (!ok) {
                    DLog(@"DBError: 删除过期好友失败");
                }
            }
        }
    }
    for (WXUser *user in users) {
        BOOL ok = [self addGroupMember:user forUid:uid andGid:gid];
        if (!ok) {
            return NO;
        }
    }
    return YES;
}
- (NSMutableArray *)groupMembersForUid:(NSString *)uid andGid:(NSString *)gid{
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:SQL_SELECT_GROUP_MEMBERS, GROUP_MEMBER_TABLE_NAMGE, uid];
    
    [self excuteQuerySQL:sqlString resultBlock:^(FMResultSet *retSet) {
        while ([retSet next]) {
            WXUser *user = [[WXUser alloc] init];
            user.userID = [retSet stringForColumn:@"uid"];
            user.username = [retSet stringForColumn:@"username"];
            user.nikeName = [retSet stringForColumn:@"nikename"];
            user.avatarURL = [retSet stringForColumn:@"avatar"];
            user.remarkName = [retSet stringForColumn:@"remark"];
            [data addObject:user];
        }
        [retSet close];
    }];
    
    return data;
}
- (BOOL)deleteGroupMemberForUid:(NSString *)uid gid:(NSString *)gid andFid:(NSString *)fid{
    NSString *sqlString = [NSString stringWithFormat:SQL_DELETE_GROUP_MEMBER, GROUP_MEMBER_TABLE_NAMGE, uid, gid, fid];
    BOOL ok = [self excuteSQL:sqlString, nil];
    return ok;
}
@end
@implementation WXDBBaseStore
- (id)init{
    if (self = [super init]) {
        self.dbQueue = [WXDBManager sharedInstance].commonQueue;
    }
    return self;
}
- (BOOL)createTable:(NSString *)tableName withSQL:(NSString *)sqlString{
    __block BOOL ok = YES;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if(![db tableExists:tableName]){
            ok = [db executeUpdate:sqlString withArgumentsInArray:@[]];
        }
    }];
    return ok;
}
- (BOOL)excuteSQL:(NSString *)sqlString withArrParameter:(NSArray *)arrParameter{
    __block BOOL ok = NO;
    if (self.dbQueue) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withArgumentsInArray:arrParameter];
        }];
    }
    return ok;
}
- (BOOL)excuteSQL:(NSString *)sqlString withDicParameter:(NSDictionary *)dicParameter{
    __block BOOL ok = NO;
    if (self.dbQueue) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withParameterDictionary:dicParameter];
        }];
    }
    return ok;
}
- (BOOL)excuteSQL:(NSString *)sqlString,...{
    __block BOOL ok = NO;
    if (self.dbQueue) {
        va_list args;
        va_list *p_args;
        p_args = &args;
        va_start(args, sqlString);
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            ok = [db executeUpdate:sqlString withVAList:*p_args];
        }];
        va_end(args);
    }
    return ok;
}
- (void)excuteQuerySQL:(NSString*)sqlStr resultBlock:(void(^)(FMResultSet * rsSet))resultBlock{
    if (self.dbQueue) {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet * retSet = [db executeQuery:sqlStr];
            if (resultBlock) {
                resultBlock(retSet);
            }
        }];
    }
}
@end
static WXDBManager *manager;
@implementation WXDBManager
+ (WXDBManager *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *userID = [WXUserHelper sharedHelper].user.userID;
        manager = [[WXDBManager alloc] initWithUserID:userID];
    });
    return manager;
}
- (id)initWithUserID:(NSString *)userID{
    if (self = [super init]) {
        NSString *commonQueuePath = [NSFileManager pathDBCommon];
        self.commonQueue = [FMDatabaseQueue databaseQueueWithPath:commonQueuePath];
        NSString *messageQueuePath = [NSFileManager pathDBMessage];
        self.messageQueue = [FMDatabaseQueue databaseQueueWithPath:messageQueuePath];
    }
    return self;
}
- (id)init{
    DLog(@"TLDBManager：请使用 initWithUserID: 方法初始化");
    return nil;
}
@end
