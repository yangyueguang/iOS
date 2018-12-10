//  WXUserHelper.m
//  Freedom
// Created by Super
#import "WXUserHelper.h"
#import "WXExpressionHelper.h"
#import "TLEmojiBaseCell.h"
#import "WXDBManager.h"
#import "WXModes.h"
#import "NSFileManager+expanded.h"
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
@implementation WXUserChatSetting
@end
@implementation WXUserDetail
@end
@implementation WXUserSetting
@end
@implementation WXUser
- (id)init{
    if (self = [super init]) {
        [WXUser mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"detailInfo" : @"TLUserDetail",
                      @"userSetting" : @"TLUserSetting",
                      @"chatSetting" : @"TLUserChatSetting",};
        }];
    }
    return self;
}
- (void)setUsername:(NSString *)username{
    if ([username isEqualToString:_username]) {
        return;
    }
    _username = username;
    if (self.remarkName.length == 0 && self.nikeName.length == 0 && self.username.length > 0) {
        self.pinyin = username.pinyin;
        self.pinyinInitial = username.pinyin;
    }
}
- (void)setNikeName:(NSString *)nikeName{
    if ([nikeName isEqualToString:_nikeName]) {
        return;
    }
    _nikeName = nikeName;
    if (self.remarkName.length == 0 && self.nikeName.length > 0) {
        self.pinyin = nikeName.pinyin;
        self.pinyinInitial = nikeName.pinyin;
    }
}
- (void)setRemarkName:(NSString *)remarkName{
    if ([remarkName isEqualToString:_remarkName]) {
        return;
    }
    _remarkName = remarkName;
    if (_remarkName.length > 0) {
        self.pinyin = remarkName.pinyin;
        self.pinyinInitial = remarkName.pinyin;
    }
}
#pragma mark - Getter
- (NSString *)showName{
    return self.remarkName.length > 0 ? self.remarkName : (self.nikeName.length > 0 ? self.nikeName : self.username);
}
- (WXUserDetail *)detailInfo{
    if (_detailInfo == nil) {
        _detailInfo = [[WXUserDetail alloc] init];
    }
    return _detailInfo;
}
- (NSString *)chat_userID{
    return self.userID;
}
- (NSString *)chat_username{
    return self.showName;
}
- (NSString *)chat_avatarURL{
    return self.avatarURL;
}
- (NSString *)chat_avatarPath{
    return self.avatarPath;
}
- (NSInteger)chat_userType{
    return TLChatUserTypeUser;
}
@end
@implementation WXUserGroup
- (id) initWithGroupName:(NSString *)groupName users:(NSMutableArray *)users{
    if (self = [super init]) {
        self.groupName = groupName;
        self.users = users;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder{
    self.groupName = [decoder decodeObjectForKey:@"name"];
    self.users = [decoder decodeObjectForKey:@"users"];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.groupName forKey:@"name"];
    [encoder encodeObject:self.users forKey:@"users"];
}
- (NSMutableArray *) users{
    if (_users == nil) {
        _users = [[NSMutableArray alloc] init];
    }
    return _users;
}
- (NSInteger) count{
    return self.users.count;
}
- (void)addObject:(id)anObject{
    [self.users addObject:anObject];
}
- (id) objectAtIndex:(NSUInteger)index{
    return [self.users objectAtIndex:index];
}
@end
@implementation WXGroup
+(NSDictionary *)mj_objectClassInArray{
    return @{ @"users" : @"WXUser" };
}
- (id)init{
    if (self = [super init]) {
//        [WXGroup mj_setupObjectClassInArray:^NSDictionary *{
//            return @{ @"users" : @"WXUser" };
//        }];
    }
    return self;
}
- (NSInteger)count{
    return self.users.count;
}
- (void)addObject:(id)anObject{
    [self.users addObject:anObject];
}
- (id)objectAtIndex:(NSUInteger)index{
    return [self.users objectAtIndex:index];
}
- (WXUser *)memberByUserID:(NSString *)uid{
    for (WXUser *user in self.users) {
        if ([user.userID isEqualToString:uid]) {
            return user;
        }
    }
    return nil;
}
- (NSString *)groupName{
    if (_groupName == nil || _groupName.length == 0) {
        for (WXUser *user in self.users) {
            if (user.showName.length > 0) {
                if (_groupName == nil || _groupName.length <= 0) {
                    _groupName = user.showName;
                }
                else {
                    _groupName = [NSString stringWithFormat:@"%@,%@", _groupName, user.showName];
                }
            }
        }
    }
    return _groupName;
}
- (NSString *)myNikeName{
    if (_myNikeName.length == 0) {
        _myNikeName = [WXUserHelper sharedHelper].user.showName;
    }
    return _myNikeName;
}
- (NSString *)pinyin{
    if (_pinyin == nil) {
        _pinyin = self.groupName.pinyin;
    }
    return _pinyin;
}
- (NSString *)pinyinInitial{
    if (_pinyinInitial == nil) {
        _pinyinInitial = self.groupName.pinyin;
    }
    return _pinyinInitial;
}
- (NSString *)groupAvatarPath{
    if (_groupAvatarPath == nil) {
        _groupAvatarPath = [self.groupID stringByAppendingString:@".png"];
    }
    return _groupAvatarPath;
}
- (NSString *)chat_userID{
    return self.groupID;
}
- (NSString *)chat_username{
    return self.groupName;
}
- (NSString *)chat_avatarURL{
    return nil;
}
- (NSString *)chat_avatarPath{
    return self.groupAvatarPath;
}
- (NSInteger)chat_userType{
    return TLChatUserTypeGroup;
}
- (id)groupMemberByID:(NSString *)userID{
    return [self memberByUserID:userID];
}
- (NSArray *)groupMembers{
    return self.users;
}
@end
@implementation WechatContact
- (id)initWithCoder:(NSCoder *)decoder{
    self.name = [decoder decodeObjectForKey:@"name"];
    self.avatarPath = [decoder decodeObjectForKey:@"avatarPath"];
    self.avatarURL = [decoder decodeObjectForKey:@"avatarURL"];
    self.tel = [decoder decodeObjectForKey:@"tel"];
    self.status = [decoder decodeIntegerForKey:@"status"];
    self.recordID = [decoder decodeIntForKey:@"recordID"];
    self.email = [decoder decodeObjectForKey:@"email"];
    self.pinyin = [decoder decodeObjectForKey:@"pinyin"];
    self.pinyinInitial = [decoder decodeObjectForKey:@"pinyinInitial"];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.avatarPath forKey:@"avatarPath"];
    [encoder encodeObject:self.avatarURL forKey:@"avatarURL"];
    [encoder encodeObject:self.tel forKey:@"tel"];
    [encoder encodeInteger:self.status forKey:@"status"];
    [encoder encodeInt:self.recordID forKey:@"recordID"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.pinyin forKey:@"pinyin"];
    [encoder encodeObject:self.pinyinInitial forKey:@"pinyinInitial"];
}
- (NSString *)pinyin{
    if (_pinyin == nil) {
        _pinyin = self.name.pinyin;
    }
    return _pinyin;
}
- (NSString *)pinyinInitial{
    if (_pinyinInitial == nil) {
        _pinyinInitial = self.name.pinyin;
    }
    return _pinyinInitial;
}
@end
static WXFriendHelper *friendHelper = nil;
@interface WXFriendHelper ()
@property (nonatomic, strong) WXDBFriendStore *friendStore;
@property (nonatomic, strong) WXDBGroupStore *groupStore;
@end
@implementation WXFriendHelper
+ (WXFriendHelper *)sharedFriendHelper{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        friendHelper = [[WXFriendHelper alloc] init];
    });
    return friendHelper;
}
- (id)init{
    if (self = [super init]) {
        // 初始化好友数据
        self.friendsData = [self.friendStore friendsDataByUid:[WXUserHelper sharedHelper].user.userID];
        self.data = [[NSMutableArray alloc] initWithObjects:self.defaultGroup, nil];
        self.sectionHeaders = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
        // 初始化群数据
        self.groupsData = [self.groupStore groupsDataByUid:[WXUserHelper sharedHelper].user.userID];
        // 初始化标签数据
        self.tagsData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
#pragma mark - Public Methods -
- (WXUser *)getFriendInfoByUserID:(NSString *)userID{
    if (userID == nil) {
        return nil;
    }
    for (WXUser *user in self.friendsData) {
        if ([user.userID isEqualToString:userID]) {
            return user;
        }
    }
    return nil;
}
- (WXGroup *)getGroupInfoByGroupID:(NSString *)groupID{
    if (groupID == nil) {
        return nil;
    }
    for (WXGroup *group in self.groupsData) {
        if ([group.groupID isEqualToString:groupID]) {
            return group;
        }
    }
    return nil;
}
#pragma mark - Private Methods -
- (void)p_resetFriendData{
    // 1、排序
    NSArray *serializeArray = [self.friendsData sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int i;
        NSString *strA = ((WXUser *)obj1).pinyin;
        NSString *strB = ((WXUser *)obj2).pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = toupper([strA characterAtIndex:i]);
            char b = toupper([strB characterAtIndex:i]);
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;
            }else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;
            }
        }
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // 2、分组
    NSMutableArray *ansData = [[NSMutableArray alloc] initWithObjects:self.defaultGroup, nil];
    NSMutableArray *ansSectionHeaders = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
    NSMutableDictionary *tagsDic = [[NSMutableDictionary alloc] init];
    char lastC = '1';
    WXUserGroup *curGroup;
    WXUserGroup *othGroup = [[WXUserGroup alloc] init];
    [othGroup setGroupName:@"#"];
    for (WXUser *user in serializeArray) {
        // 获取拼音失败
        if (user.pinyin == nil || user.pinyin.length == 0) {
            [othGroup addObject:user];
            continue;
        }
        
        char c = toupper([user.pinyin characterAtIndex:0]);
        if (!isalpha(c)) {      // #组
            [othGroup addObject:user];
        }else if (c != lastC){
            if (curGroup && curGroup.count > 0) {
                [ansData addObject:curGroup];
                [ansSectionHeaders addObject:curGroup.groupName];
            }
            lastC = c;
            curGroup = [[WXUserGroup alloc] init];
            [curGroup setGroupName:[NSString stringWithFormat:@"%c", c]];
            [curGroup addObject:user];
        }else{
            [curGroup addObject:user];
        }
        
        // TAGs
        if (user.detailInfo.tags.count > 0) {
            for (NSString *tag in user.detailInfo.tags) {
                WXUserGroup *group = [tagsDic objectForKey:tag];
                if (group == nil) {
                    group = [[WXUserGroup alloc] init];
                    group.groupName = tag;
                    [tagsDic setObject:group forKey:tag];
                    [self.tagsData addObject:group];
                }
                [group.users addObject:user];
            }
        }
    }
    if (curGroup && curGroup.count > 0) {
        [ansData addObject:curGroup];
        [ansSectionHeaders addObject:curGroup.groupName];
    }
    if (othGroup.count > 0) {
        [ansData addObject:othGroup];
        [ansSectionHeaders addObject:othGroup.groupName];
    }
    
    [self.data removeAllObjects];
    [self.data addObjectsFromArray:ansData];
    [self.sectionHeaders removeAllObjects];
    [self.sectionHeaders addObjectsFromArray:ansSectionHeaders];
    if (self.dataChangedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataChangedBlock(self.data, self.sectionHeaders, self.friendCount);
        });
    }
}
- (void)p_initTestData{
    // 好友数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FriendList" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    NSArray *arr = [WXUser mj_objectArrayWithKeyValuesArray:jsonArray];
    [self.friendsData removeAllObjects];
    [self.friendsData addObjectsFromArray:arr];
    // 更新好友数据到数据库
    BOOL ok = [self.friendStore updateFriendsData:self.friendsData forUid:[WXUserHelper sharedHelper].user.userID];
    if (!ok) {
        DLog(@"保存好友数据到数据库失败!");
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self p_resetFriendData];
    });
    
    // 群数据
    path = [[NSBundle mainBundle] pathForResource:@"FriendGroupList" ofType:@"json"];
    jsonData = [NSData dataWithContentsOfFile:path];
    jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    arr = [WXGroup mj_objectArrayWithKeyValuesArray:jsonArray];
    [self.groupsData removeAllObjects];
    [self.groupsData addObjectsFromArray:arr];
    ok = [self.groupStore updateGroupsData:self.groupsData forUid:[WXUserHelper sharedHelper].user.userID];
    if (!ok) {
        DLog(@"保存群数据到数据库失败!");
    }
    // 生成Group Icon
    for (WXGroup *group in self.groupsData) {
        [self createGroupAvatar:group finished:nil];
    }
}
- (void)createGroupAvatar:(WXGroup *)group finished:(void (^)(NSString *groupID))finished{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger usersCount = group.users.count > 9 ? 9 : group.users.count;
        CGFloat viewWidth = 200;
        CGFloat width = viewWidth / 3 * 0.85;
        CGFloat space3 = (viewWidth - width * 3) / 4;               // 三张图时的边距（图与图之间的边距）
        CGFloat space2 = (viewWidth - width * 2 + space3) / 2;      // 两张图时的边距
        CGFloat space1 = (viewWidth - width) / 2;                   // 一张图时的边距
        CGFloat y = usersCount > 6 ? space3 : (usersCount > 3 ? space2 : space1);
        CGFloat x = usersCount % 3 == 0 ? space3 : (usersCount % 3 == 2 ? space2 : space1);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        [view setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.6]];
        __block NSInteger count = 0;        // 下载完成图片计数器
        for (NSInteger i = usersCount - 1; i >= 0; i--) {
            WXUser *user = [group.users objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
            [view addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:PuserLogo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                count ++;
                if (count == usersCount) {     // 图片全部下载完成
                    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 2.0);
                    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CGImageRef imageRef = image.CGImage;
                    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, CGRectMake(0, 0, view.frame.size.width * 2, view.frame.size.height * 2));
                    UIImage *ansImage = [[UIImage alloc] initWithCGImage:imageRefRect];
                    NSData *imageViewData = UIImagePNGRepresentation(ansImage);
                    NSString *savedImagePath = [NSFileManager pathUserAvatar:group.groupAvatarPath];
                    [imageViewData writeToFile:savedImagePath atomically:YES];
                    CGImageRelease(imageRefRect);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (finished) {
                            finished(group.groupID);
                        }
                    });
                }
            }];
            if (i % 3 == 0) {   // 换行
                y += (width + space3);
                x = space3;
            }else if(i == 2 && usersCount == 3) {  // 换行，只有三个时
                y += (width + space3);
                x = space2;
            }else{
                x += (width + space3);
            }
        }
    });
}
#pragma mark - Getter
- (WXUserGroup *)defaultGroup{
    if (_defaultGroup == nil) {
        WXUser *item_new = [[WXUser alloc] init];
        item_new.userID = @"-1";
        item_new.avatarPath = @"u_personAddHL";
        item_new.remarkName = @"新的朋友";
        WXUser *item_group = [[WXUser alloc] init];
        item_group.userID = @"-2";
        item_group.avatarPath = @"add_friend_icon_addgroup";
        item_group.remarkName = @"群聊";
        WXUser *item_tag = [[WXUser alloc] init];
        item_tag.userID = @"-3";
        item_tag.avatarPath = @"Contact_icon_ContactTag";
        item_tag.remarkName = @"标签";
        WXUser *item_public = [[WXUser alloc] init];
        item_public.userID = @"-4";
        item_public.avatarPath = @"add_friend_icon_offical";
        item_public.remarkName = @"公共号";
        _defaultGroup = [[WXUserGroup alloc] initWithGroupName:nil users:[NSMutableArray arrayWithObjects:item_new, item_group, item_tag, item_public, nil]];
    }
    return _defaultGroup;
}
- (NSInteger)friendCount{
    return self.friendsData.count;
}
- (WXDBFriendStore *)friendStore{
    if (_friendStore == nil) {
        _friendStore = [[WXDBFriendStore alloc] init];
    }
    return _friendStore;
}
- (WXDBGroupStore *)groupStore{
    if (_groupStore == nil) {
        _groupStore = [[WXDBGroupStore alloc] init];
    }
    return _groupStore;
}
- (NSMutableArray *)friendDetailArrayByUserInfo:(WXUser *)userInfo{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    // 1
    WXInfo *user = TLCreateInfo(@"个人", nil);
    user.type = TLInfoTypeOther;
    user.userInfo = userInfo;
    [arr addObject:user];
    [data addObject:arr];
    
    // 2
    arr = [[NSMutableArray alloc] init];
    if (userInfo.detailInfo.phoneNumber.length > 0) {
        WXInfo *tel = TLCreateInfo(@"电话号码", userInfo.detailInfo.phoneNumber);
        tel.showDisclosureIndicator = NO;
        [arr addObject:tel];
    }
    if (userInfo.detailInfo.tags.count == 0) {
        WXInfo *remark = TLCreateInfo(@"设置备注和标签" , nil);
        [arr insertObject:remark atIndex:0];
    }else{
        NSString *str = [userInfo.detailInfo.tags componentsJoinedByString:@","];
        WXInfo *remark = TLCreateInfo(@"标签", str);
        [arr addObject:remark];
    }
    [data addObject:arr];
    arr = [[NSMutableArray alloc] init];
    
    // 3
    if (userInfo.detailInfo.location.length > 0) {
        WXInfo *location = TLCreateInfo(@"地区", userInfo.detailInfo.location);
        location.showDisclosureIndicator = NO;
        location.disableHighlight = YES;
        [arr addObject:location];
    }
    WXInfo *album = TLCreateInfo(@"个人相册", nil);
    album.userInfo = userInfo.detailInfo.albumArray;
    album.type = TLInfoTypeOther;
    [arr addObject:album];
    WXInfo *more = TLCreateInfo(@"更多", nil);
    [arr addObject:more];
    [data addObject:arr];
    arr = [[NSMutableArray alloc] init];
    
    // 4
    WXInfo *sendMsg = TLCreateInfo(@"发消息", nil);
    sendMsg.type = TLInfoTypeButton;
    sendMsg.titleColor = [UIColor whiteColor];
    sendMsg.buttonBorderColor = [UIColor grayColor];
    [arr addObject:sendMsg];
    if (![userInfo.userID isEqualToString:[WXUserHelper sharedHelper].user.userID]) {
        WXInfo *video = TLCreateInfo(@"视频聊天", nil);
        video.type = TLInfoTypeButton;
        video.buttonBorderColor = [UIColor grayColor];
        video.buttonColor = [UIColor whiteColor];
        [arr addObject:video];
    }
    [data addObject:arr];
    
    return data;
}
- (NSMutableArray *)friendDetailSettingArrayByUserInfo:(WXUser *)userInfo{
    WXSettingItem *remark = TLCreateSettingItem(@"设置备注及标签");
    if (userInfo.remarkName.length > 0) {
        remark.subTitle = userInfo.remarkName;
    }
    WXSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[remark]);
    WXSettingItem *recommand = TLCreateSettingItem(@"把他推荐给朋友");
    WXSettingGroup *group2 = TLCreateSettingGroup(nil, nil, @[recommand]);
    WXSettingItem *starFriend = TLCreateSettingItem(@"设为星标朋友");
    starFriend.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[starFriend]);
    WXSettingItem *prohibit = TLCreateSettingItem(@"不让他看我的朋友圈");
    prohibit.type = TLSettingItemTypeSwitch;
    WXSettingItem *dismiss = TLCreateSettingItem(@"不看他的朋友圈");
    dismiss.type = TLSettingItemTypeSwitch;
    WXSettingGroup *group4 = TLCreateSettingGroup(nil, nil, (@[prohibit, dismiss]));
    WXSettingItem *blackList = TLCreateSettingItem(@"加入黑名单");
    blackList.type = TLSettingItemTypeSwitch;
    WXSettingItem *report = TLCreateSettingItem(@"举报");
    WXSettingGroup *group5 = TLCreateSettingGroup(nil, nil, (@[blackList, report]));
    return [NSMutableArray arrayWithObjects:group1, group2, group3, group4, group5, nil];
}
+ (void)gotNextEventWithWechatContacts:(NSMutableArray*)data success:(void (^)(NSArray *data, NSArray *formatData, NSArray *headers))success{
    // 4、排序
    NSArray *serializeArray = [data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int i;
        NSString *strA = ((WechatContact *)obj1).pinyin;
        NSString *strB = ((WechatContact *)obj2).pinyin;
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = toupper([strA characterAtIndex:i]);
            char b = toupper([strB characterAtIndex:i]);
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;
            }else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;
            }
        }
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    // 5、分组
    data = [[NSMutableArray alloc] init];
    NSMutableArray *headers = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
    char lastC = '1';
    WXUserGroup *curGroup;
    WXUserGroup *othGroup = [[WXUserGroup alloc] init];
    [othGroup setGroupName:@"#"];
    for (WechatContact *contact in serializeArray) {
        // 获取拼音失败
        if (contact.pinyin == nil || contact.pinyin.length == 0) {
            [othGroup addObject:contact];
            continue;
        }
        char c = toupper([contact.pinyin characterAtIndex:0]);
        if (!isalpha(c)) {      // #组
            [othGroup addObject:contact];
        }else if (c != lastC){
            if (curGroup && curGroup.count > 0) {
                [data addObject:curGroup];
                [headers addObject:curGroup.groupName];
            }
            lastC = c;
            curGroup = [[WXUserGroup alloc] init];
            [curGroup setGroupName:[NSString stringWithFormat:@"%c", c]];
            [curGroup addObject:contact];
        }else{
            [curGroup addObject:contact];
        }
    }
    if (curGroup && curGroup.count > 0) {
        [data addObject:curGroup];
        [headers addObject:curGroup.groupName];
    }
    if (othGroup.count > 0) {
        [data addObject:othGroup];
        [headers addObject:othGroup.groupName];
    }
    // 6、数据返回
    dispatch_async(dispatch_get_main_queue(), ^{
        success(serializeArray, data, headers);
    });
    // 7、存入本地缓存
    NSDictionary *dic = @{@"data": serializeArray,
                          @"formatData": data,
                          @"headers": headers};
    NSString *path = [NSFileManager pathContactsData];
    if(![NSKeyedArchiver archiveRootObject:dic toFile:path]){
        DLog(@"缓存联系人数据失败");
    }
}
+ (void)tryToGetAllContactsSuccess:(void (^)(NSArray *data, NSArray *formatData, NSArray *headers))success failed:(void (^)())failed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 3、加载缓存
        NSString *path = [NSFileManager pathContactsData];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (dic) {
            NSArray *data = dic[@"data"];
            NSArray *formatData = dic[@"formatData"];
            NSArray *headers = dic[@"headers"];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data, formatData, headers);
            });
        }
        // 1.获取授权状态
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        // 2.判断授权状态,如果不是已经授权,则直接返回
        if (status != CNAuthorizationStatusAuthorized) return;
        // 3.创建通信录对象
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        // 4.创建获取通信录的请求对象
        // 4.1.拿到所有打算获取的属性对应的key
        NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        // 4.2.创建CNContactFetchRequest对象
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        // 5.遍历所有的联系人
        // 3、格式转换
        NSMutableArray<WechatContact*> *data = [[NSMutableArray alloc] init];
        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            WechatContact *con = [[WechatContact  alloc] init];
            // 1.获取联系人的姓名
            NSString *lastname = contact.familyName;
            NSString *firstname = contact.givenName;
            // 2.获取联系人的电话号码
            NSArray *phoneNums = contact.phoneNumbers;
            for (CNLabeledValue *labeledValue in phoneNums) {
                NSString *phoneLabel = labeledValue.label;
                CNPhoneNumber *phoneNumer = labeledValue.value;
                NSString *phoneValue = phoneNumer.stringValue;
                NSLog(@"%@ %@", phoneLabel, phoneValue);
                con.tel = phoneValue;
            }
            NSArray<CNLabeledValue<NSString*>*> *emails = contact.emailAddresses;
            for(CNLabeledValue *labeldValue in emails){
                NSString *email = labeldValue.label;
                con.email = [NSString stringWithFormat:@"%@%@",email,labeldValue.value];
            }
            con.name = [NSString stringWithFormat:@"%@ %@",lastname,firstname];
            con.recordID = contact.identifier.intValue;
            NSData *imageData = contact.imageData;
            NSString *imageName = [NSString stringWithFormat:@"%.0lf.jpg", [NSDate date].timeIntervalSince1970 * 10000];
            NSString *imagePath = [NSFileManager pathContactsAvatar:imageName];
            [imageData writeToFile:imagePath atomically:YES];
            con.avatarPath = imageName;
            if(stop){
                [self gotNextEventWithWechatContacts:data success:success];
            }
        }];
    });
}
@end
static WXUserHelper *helper;
@interface WXUserHelper()
@property (nonatomic, strong) NSMutableArray *systemEmojiGroups;
@property (nonatomic, strong) void (^complete)(NSMutableArray *);
@end
@implementation WXUserHelper
+ (WXUserHelper *) sharedHelper{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[WXUserHelper alloc] init];
    });
    return helper;
}
- (id) init{
    if (self = [super init]) {
        self.user = [[WXUser alloc] init];
        self.user.userID = @"这是我的二维码：2829969299 \n没错，我爱你。";//我的二维码数据
        self.user.avatarURL = @"https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg";
        self.user.nikeName = @"Super";
        self.user.username = @"2829969299";
        self.user.detailInfo.qqNumber = @"2829969299";
        self.user.detailInfo.email = @"2829969299@qq.com";
        self.user.detailInfo.location = @"上海市 浦东新区";
        self.user.detailInfo.sex = @"男";
        self.user.detailInfo.motto = @"失败与挫折相伴，成功与掌声共存!";
        self.user.detailInfo.momentsWallURL = @"https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg";
    }
    return self;
}
- (void)updateEmojiGroupData{
    if (self.user.userID && self.complete) {
        [self emojiGroupDataComplete:self.complete];
    }
}
- (void)emojiGroupDataComplete:(void (^)(NSMutableArray *))complete{
    self.complete = complete;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *emojiGroupData = [[NSMutableArray alloc] init];
        
        // 默认表情包
        NSArray *defaultEmojiGroups = @[[WXExpressionHelper sharedHelper].defaultFaceGroup,
                                        [WXExpressionHelper sharedHelper].defaultSystemEmojiGroup];
        [emojiGroupData addObject:defaultEmojiGroups];
        
        // 用户收藏的表情包
        TLEmojiGroup *preferEmojiGroup = [WXExpressionHelper sharedHelper].userPreferEmojiGroup;
        if (preferEmojiGroup && preferEmojiGroup.count > 0) {
            [emojiGroupData addObject:@[preferEmojiGroup]];
        }
        
        // 用户的表情包
        NSArray *userGroups = [WXExpressionHelper sharedHelper].userEmojiGroups;
        if (userGroups && userGroups.count > 0) {
            [emojiGroupData addObject:userGroups];
        }
        // 系统设置
        [emojiGroupData addObject:self.systemEmojiGroups];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(emojiGroupData);
        });
    });
}
#pragma mark - Getter -
- (NSMutableArray *)systemEmojiGroups{
    if (_systemEmojiGroups == nil) {
        TLEmojiGroup *editGroup = [[TLEmojiGroup alloc] init];
        editGroup.type = TLEmojiTypeOther;
        editGroup.groupIconPath = @"emojiKB_settingBtn";
        _systemEmojiGroups = [[NSMutableArray alloc] initWithObjects:editGroup, nil];
    }
    return _systemEmojiGroups;
}
@end
