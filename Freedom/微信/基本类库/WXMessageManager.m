//  WXMessageManager.m
//  Freedom
// Created by Super
#import "WXMessageManager.h"
#import "WXChatViewController.h"
#import "WXUserHelper.h"
#import "WXModes.h"
@implementation WXImageMessage
- (CGSize)imageSize{
    CGFloat width = [[self.content objectForKey:@"w"] doubleValue];
    CGFloat height = [[self.content objectForKey:@"h"] doubleValue];
    return CGSizeMake(width, height);
}
- (void)setImageSize:(CGSize)imageSize{
    [self.content setObject:[NSNumber numberWithDouble:imageSize.width] forKey:@"w"];
    [self.content setObject:[NSNumber numberWithDouble:imageSize.height] forKey:@"h"];
}
#pragma mark -
- (WXMessageFrame *)messageFrame{
    if (kMessageFrame == nil) {
        kMessageFrame = [[WXMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        CGSize imageSize = self.imageSize;
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            kMessageFrame.contentSize = CGSizeMake(100, 100);
        }else if (imageSize.width > imageSize.height) {
            CGFloat height = APPW * 0.45 * imageSize.height / imageSize.width;
            height = height < APPW * 0.25 ? APPW * 0.25 : height;
            kMessageFrame.contentSize = CGSizeMake(APPW * 0.45, height);
        }else{
            CGFloat width = APPW * 0.45 * imageSize.width / imageSize.height;
            width = width < APPW * 0.25 ? APPW * 0.25 : width;
            kMessageFrame.contentSize = CGSizeMake(width, APPW * 0.45);
        }
        
        kMessageFrame.height += kMessageFrame.contentSize.height;
    }
    return kMessageFrame;
}
- (NSString *)conversationContent{
    return @"[图片]";
}
- (NSString *)messageCopy{
    return [self.content mj_JSONString];
}
@end
@implementation WXConversation
- (void)setConvType:(TLConversationType)convType{
    _convType = convType;
    switch (convType) {
        case TLConversationTypePersonal:
        case TLConversationTypeGroup:
            _clueType = TLClueTypePointWithNumber;
            break;
        case TLConversationTypePublic:
        case TLConversationTypeServerGroup:
            _clueType = TLClueTypePoint;
            break;
        default:
            break;
    }
}
- (BOOL)isRead{
    return self.unreadCount == 0;
}
- (void)updateUserInfo:(WXUser *)user{
    self.partnerName = user.showName;
    self.avatarPath = user.avatarPath;
    self.avatarURL = user.avatarURL;
}
- (void)updateGroupInfo:(WXGroup *)group{
    self.partnerName = group.groupName;
    self.avatarPath = group.groupAvatarPath;
}
@end
@implementation WXMessageFrame
@end
@implementation WXMessage
+ (WXMessage *)createMessageByType:(TLMessageType)type{
    NSString *className;
    if (type == TLMessageTypeText) {
        className = @"TLTextMessage";
    }else if (type == TLMessageTypeImage) {
        className = @"TLImageMessage";
    }else if (type == TLMessageTypeExpression) {
        className = @"TLExpressionMessage";
    }
    if (className) {
        return [[NSClassFromString(className) alloc] init];
    }
    return nil;
}
- (id)init{
    if (self = [super init]) {
        self.messageID = [NSString stringWithFormat:@"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 10000)];
    }
    return self;
}
#pragma mark - Protocol
- (NSString *)conversationContent{
    return @"子类未定义";
}
- (NSString *)messageCopy{
    return @"子类未定义";
}
#pragma mark -
- (NSMutableDictionary *)content{
    if (_content == nil) {
        _content = [[NSMutableDictionary alloc] init];
    }
    return _content;
}
@end
static WXMessageManager *messageManager;
@implementation WXMessageManager
+ (WXMessageManager *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageManager = [[WXMessageManager alloc] init];
    });
    return messageManager;
}
- (void)sendMessage:(WXMessage *)message
           progress:(void (^)(WXMessage *, CGFloat))progress
            success:(void (^)(WXMessage *))success
            failure:(void (^)(WXMessage *))failure{
    BOOL ok = [self.messageStore addMessage:message];
    if (!ok) {
        DLog(@"存储Message到DB失败");
    }else{      // 存储到conversation
        ok = [self addConversationByMessage:message];
        if (!ok) {
            DLog(@"存储Conversation到DB失败");
        }
    }
}
#pragma mark - Getter -
- (WXDBMessageStore *)messageStore{
    if (_messageStore == nil) {
        _messageStore = [[WXDBMessageStore alloc] init];
    }
    return _messageStore;
}
- (WXDBConversationStore *)conversationStore{
    if (_conversationStore == nil) {
        _conversationStore = [[WXDBConversationStore alloc] init];
    }
    return _conversationStore;
}
- (NSString *)userID{
    return [WXUserHelper sharedHelper].user.userID;
}
- (BOOL)addConversationByMessage:(WXMessage *)message{
    NSString *partnerID = message.friendID;
    NSInteger type = 0;
    if (message.partnerType == TLPartnerTypeGroup) {
        partnerID = message.groupID;
        type = 1;
    }
    BOOL ok = [self.conversationStore addConversationByUid:message.userID fid:partnerID type:type date:message.date];
    
    return ok;
}
- (void)conversationRecord:(void (^)(NSArray *))complete{
    NSArray *data = [self.conversationStore conversationsByUid:self.userID];
    complete(data);
}
- (BOOL)deleteConversationByPartnerID:(NSString *)partnerID{
    BOOL ok = [self deleteMessagesByPartnerID:partnerID];
    if (ok) {
        ok = [self.conversationStore deleteConversationByUid:self.userID fid:partnerID];
    }
    return ok;
}
- (void)messageRecordForPartner:(NSString *)partnerID
                       fromDate:(NSDate *)date
                          count:(NSUInteger)count
                       complete:(void (^)(NSArray *, BOOL))complete{
    [self.messageStore messagesByUserID:self.userID partnerID:partnerID fromDate:date count:count complete:^(NSArray *data, BOOL hasMore) {
        complete(data, hasMore);
    }];
}
- (void)chatFilesForPartnerID:(NSString *)partnerID
                    completed:(void (^)(NSArray *))completed{
    NSArray *data = [self.messageStore chatFilesByUserID:self.userID partnerID:partnerID];
    completed(data);
}
- (void)chatImagesAndVideosForPartnerID:(NSString *)partnerID
                              completed:(void (^)(NSArray *))completed
{
    NSArray *data = [self.messageStore chatImagesAndVideosByUserID:self.userID partnerID:partnerID];
    completed(data);
}
- (BOOL)deleteMessageByMsgID:(NSString *)msgID{
    return [self.messageStore deleteMessageByMessageID:msgID];
}
- (BOOL)deleteMessagesByPartnerID:(NSString *)partnerID{
    BOOL ok = [self.messageStore deleteMessagesByUserID:self.userID partnerID:partnerID];
    if (ok) {
        [[WXChatViewController sharedChatVC] resetChatVC];
    }
    return ok;
}
- (BOOL)deleteAllMessages{
    BOOL ok = [self.messageStore deleteMessagesByUserID:self.userID];
    if (ok) {
        [[WXChatViewController sharedChatVC] resetChatVC];
        ok = [self.conversationStore deleteConversationsByUid:self.userID];
    }
    return ok;
}
- (void)requestClientInitInfoSuccess:(void (^)(id)) clientInitInfo
                             failure:(void (^)(NSString *))error{
    NSString *HOST_URL = @"http://127.0.0.1:8000/";            // 本地测试服务器
//    HOST_URL = @"http://121.42.29.15:8000/";        // 远程线上服务器
    NSString *urlString = [HOST_URL stringByAppendingString:@"client/getClientInitInfo/"];
    [[AFHTTPSessionManager manager] POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"OK");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"OK");
    }];
}
- (void)userLoginWithUsername:(NSString *)username
                     password:(NSString *)password
                      success:(void (^)(id))userInfo
                      failure:(void (^)(NSString *))error{
}
- (NSMutableArray *)chatDetailDataByUserInfo:(WXUser *)userInfo{
    WXSettingItem *users = TLCreateSettingItem(@"users");
    users.type = TLSettingItemTypeOther;
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[users]);
    
    WXSettingItem *top = TLCreateSettingItem(@"置顶聊天");
    top.type = TLSettingItemTypeSwitch;
    WXSettingItem *screen = TLCreateSettingItem(@"消息免打扰");
    screen.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[top, screen]));
    
    WXSettingItem *chatFile = TLCreateSettingItem(@"聊天文件");
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[chatFile]);
    
    WXSettingItem *chatBG = TLCreateSettingItem(@"设置当前聊天背景");
    WXSettingItem *chatHistory = TLCreateSettingItem(@"查找聊天内容");
    WXSettingGroup *group4 = TLCreateSettingGroup(nil, nil, (@[chatBG, chatHistory]));
    
    WXSettingItem *clear = TLCreateSettingItem(@"清空聊天记录");
    clear.showDisclosureIndicator = NO;
    WXSettingGroup *group5 = TLCreateSettingGroup(nil, nil, @[clear]);
    
    WXSettingItem *report = TLCreateSettingItem(@"举报");
    WXSettingGroup *group6 = TLCreateSettingGroup(nil, nil, @[report]);
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObjectsFromArray:@[group1, group2, group3, group4, group5, group6]];
    return data;
}
- (NSMutableArray *)chatDetailDataByGroupInfo:(WXGroup *)groupInfo{
    WXSettingItem *users = TLCreateSettingItem(@"users");
    users.type = TLSettingItemTypeOther;
    WXSettingItem *allUsers = TLCreateSettingItem(([NSString stringWithFormat:@"全部群成员(%ld)", (long)groupInfo.count]));
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, (@[users, allUsers]));
    
    WXSettingItem *groupName = TLCreateSettingItem(@"群聊名称");
    groupName.subTitle = groupInfo.groupName;
    WXSettingItem *groupQR = TLCreateSettingItem(@"群二维码");
    groupQR.rightImagePath = PQRCode;
    WXSettingItem *groupPost = TLCreateSettingItem(@"群公告");
    if (groupInfo.post.length > 0) {
        groupPost.subTitle = groupInfo.post;
    }else{
        groupPost.subTitle = @"未设置";
    }
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[groupName, groupQR, groupPost]));
    
    WXSettingItem *screen = TLCreateSettingItem(@"消息免打扰");
    screen.type = TLSettingItemTypeSwitch;
    WXSettingItem *top = TLCreateSettingItem(@"置顶聊天");
    top.type = TLSettingItemTypeSwitch;
    WXSettingItem *save = TLCreateSettingItem(@"保存到通讯录");
    save.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, (@[screen, top, save]));
    
    WXSettingItem *myNikeName = TLCreateSettingItem(@"我在本群的昵称");
    myNikeName.subTitle = groupInfo.myNikeName;
    WXSettingItem *showOtherNikeName = TLCreateSettingItem(@"显示群成员昵称");
    showOtherNikeName.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group4 = TLCreateSettingGroup(nil, nil, (@[myNikeName, showOtherNikeName]));
    
    WXSettingItem *chatFile = TLCreateSettingItem(@"聊天文件");
    WXSettingItem *chatHistory = TLCreateSettingItem(@"查找聊天内容");
    WXSettingItem *chatBG = TLCreateSettingItem(@"设置当前聊天背景");
    WXSettingItem *report = TLCreateSettingItem(@"举报");
    WXSettingGroup *group5 = TLCreateSettingGroup(nil, nil, (@[chatFile, chatHistory, chatBG, report]));
    
    WXSettingItem *clear = TLCreateSettingItem(@"清空聊天记录");
    clear.showDisclosureIndicator = NO;
    WXSettingGroup *group6 = TLCreateSettingGroup(nil, nil, @[clear]);
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObjectsFromArray:@[group1, group2, group3, group4, group5, group6]];
    return data;
}
@end
