//  TLMessageManager.m
//  Freedom
// Created by Super
#import "TLMessageManager.h"
#import "TLChatViewController.h"
#import "TLUserHelper.h"
#import "WechartModes.h"
@implementation TLImageMessage
@synthesize imagePath = _imagePath;
@synthesize imageURL = _imageURL;
#pragma mark -
- (NSString *)imagePath{
    if (_imagePath == nil) {
        _imagePath = [self.content objectForKey:@"path"];
    }
    return _imagePath;
}
- (void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    [self.content setObject:imagePath forKey:@"path"];
}
- (NSString *)imageURL{
    if (_imageURL == nil) {
        _imageURL = [self.content objectForKey:@"url"];
    }
    return _imageURL;
}
- (void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    [self.content setObject:imageURL forKey:@"url"];
}
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
- (TLMessageFrame *)messageFrame{
    if (kMessageFrame == nil) {
        kMessageFrame = [[TLMessageFrame alloc] init];
        kMessageFrame.height = 20 + (self.showTime ? 30 : 0) + (self.showName ? 15 : 0);
        CGSize imageSize = self.imageSize;
        if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
            kMessageFrame.contentSize = CGSizeMake(100, 100);
        }else if (imageSize.width > imageSize.height) {
            CGFloat height = WIDTH_SCREEN * 0.45 * imageSize.height / imageSize.width;
            height = height < WIDTH_SCREEN * 0.25 ? WIDTH_SCREEN * 0.25 : height;
            kMessageFrame.contentSize = CGSizeMake(WIDTH_SCREEN * 0.45, height);
        }else{
            CGFloat width = WIDTH_SCREEN * 0.45 * imageSize.width / imageSize.height;
            width = width < WIDTH_SCREEN * 0.25 ? WIDTH_SCREEN * 0.25 : width;
            kMessageFrame.contentSize = CGSizeMake(width, WIDTH_SCREEN * 0.45);
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

@implementation TLConversation
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
- (void)updateUserInfo:(TLUser *)user{
    self.partnerName = user.showName;
    self.avatarPath = user.avatarPath;
    self.avatarURL = user.avatarURL;
}
- (void)updateGroupInfo:(TLGroup *)group{
    self.partnerName = group.groupName;
    self.avatarPath = group.groupAvatarPath;
}
@end

@implementation TLMessageFrame
@end
@implementation TLMessage
+ (TLMessage *)createMessageByType:(TLMessageType)type{
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

static TLMessageManager *messageManager;
@implementation TLMessageManager
+ (TLMessageManager *)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        messageManager = [[TLMessageManager alloc] init];
    });
    return messageManager;
}
- (void)sendMessage:(TLMessage *)message
           progress:(void (^)(TLMessage *, CGFloat))progress
            success:(void (^)(TLMessage *))success
            failure:(void (^)(TLMessage *))failure{
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
- (TLDBMessageStore *)messageStore{
    if (_messageStore == nil) {
        _messageStore = [[TLDBMessageStore alloc] init];
    }
    return _messageStore;
}
- (TLDBConversationStore *)conversationStore{
    if (_conversationStore == nil) {
        _conversationStore = [[TLDBConversationStore alloc] init];
    }
    return _conversationStore;
}
- (NSString *)userID{
    return [TLUserHelper sharedHelper].user.userID;
}
- (BOOL)addConversationByMessage:(TLMessage *)message{
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
        [[TLChatViewController sharedChatVC] resetChatVC];
    }
    return ok;
}
- (BOOL)deleteAllMessages{
    BOOL ok = [self.messageStore deleteMessagesByUserID:self.userID];
    if (ok) {
        [[TLChatViewController sharedChatVC] resetChatVC];
        ok = [self.conversationStore deleteConversationsByUid:self.userID];
    }
    return ok;
}
- (void)requestClientInitInfoSuccess:(void (^)(id)) clientInitInfo
                             failure:(void (^)(NSString *))error{
    NSString *urlString = [HOST_URL stringByAppendingString:@"client/getClientInitInfo/"];
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
- (NSMutableArray *)chatDetailDataByUserInfo:(TLUser *)userInfo{
    TLSettingItem *users = TLCreateSettingItem(@"users");
    users.type = TLSettingItemTypeOther;
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[users]);
    
    TLSettingItem *top = TLCreateSettingItem(@"置顶聊天");
    top.type = TLSettingItemTypeSwitch;
    TLSettingItem *screen = TLCreateSettingItem(@"消息免打扰");
    screen.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[top, screen]));
    
    TLSettingItem *chatFile = TLCreateSettingItem(@"聊天文件");
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[chatFile]);
    
    TLSettingItem *chatBG = TLCreateSettingItem(@"设置当前聊天背景");
    TLSettingItem *chatHistory = TLCreateSettingItem(@"查找聊天内容");
    TLSettingGroup *group4 = TLCreateSettingGroup(nil, nil, (@[chatBG, chatHistory]));
    
    TLSettingItem *clear = TLCreateSettingItem(@"清空聊天记录");
    clear.showDisclosureIndicator = NO;
    TLSettingGroup *group5 = TLCreateSettingGroup(nil, nil, @[clear]);
    
    TLSettingItem *report = TLCreateSettingItem(@"举报");
    TLSettingGroup *group6 = TLCreateSettingGroup(nil, nil, @[report]);
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObjectsFromArray:@[group1, group2, group3, group4, group5, group6]];
    return data;
}
- (NSMutableArray *)chatDetailDataByGroupInfo:(TLGroup *)groupInfo{
    TLSettingItem *users = TLCreateSettingItem(@"users");
    users.type = TLSettingItemTypeOther;
    TLSettingItem *allUsers = TLCreateSettingItem(([NSString stringWithFormat:@"全部群成员(%ld)", (long)groupInfo.count]));
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, (@[users, allUsers]));
    
    TLSettingItem *groupName = TLCreateSettingItem(@"群聊名称");
    groupName.subTitle = groupInfo.groupName;
    TLSettingItem *groupQR = TLCreateSettingItem(@"群二维码");
    groupQR.rightImagePath = PQRCode;
    TLSettingItem *groupPost = TLCreateSettingItem(@"群公告");
    if (groupInfo.post.length > 0) {
        groupPost.subTitle = groupInfo.post;
    }else{
        groupPost.subTitle = @"未设置";
    }
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[groupName, groupQR, groupPost]));
    
    TLSettingItem *screen = TLCreateSettingItem(@"消息免打扰");
    screen.type = TLSettingItemTypeSwitch;
    TLSettingItem *top = TLCreateSettingItem(@"置顶聊天");
    top.type = TLSettingItemTypeSwitch;
    TLSettingItem *save = TLCreateSettingItem(@"保存到通讯录");
    save.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, nil, (@[screen, top, save]));
    
    TLSettingItem *myNikeName = TLCreateSettingItem(@"我在本群的昵称");
    myNikeName.subTitle = groupInfo.myNikeName;
    TLSettingItem *showOtherNikeName = TLCreateSettingItem(@"显示群成员昵称");
    showOtherNikeName.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group4 = TLCreateSettingGroup(nil, nil, (@[myNikeName, showOtherNikeName]));
    
    TLSettingItem *chatFile = TLCreateSettingItem(@"聊天文件");
    TLSettingItem *chatHistory = TLCreateSettingItem(@"查找聊天内容");
    TLSettingItem *chatBG = TLCreateSettingItem(@"设置当前聊天背景");
    TLSettingItem *report = TLCreateSettingItem(@"举报");
    TLSettingGroup *group5 = TLCreateSettingGroup(nil, nil, (@[chatFile, chatHistory, chatBG, report]));
    
    TLSettingItem *clear = TLCreateSettingItem(@"清空聊天记录");
    clear.showDisclosureIndicator = NO;
    TLSettingGroup *group6 = TLCreateSettingGroup(nil, nil, @[clear]);
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    [data addObjectsFromArray:@[group1, group2, group3, group4, group5, group6]];
    return data;
}
@end
