//  TLUserHelper.m
//  Freedom
// Created by Super
#import "TLUserHelper.h"
#import "TLExpressionHelper.h"
#import "TLEmojiBaseCell.h"
#import "NSString+expanded.h"
#import "TLDBManager.h"
#import "WechartModes.h"
#import <AddressBookUI/AddressBookUI.h>
#import "NSString+expanded.h"
@implementation TLUserChatSetting
@end
@implementation TLUserDetail
@end
@implementation TLUserSetting
@end
@implementation TLUser
- (id)init{
    if (self = [super init]) {
        [TLUser mj_setupObjectClassInArray:^NSDictionary *{
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
        self.pinyinInitial = username.pinyinInitial;
    }
}
- (void)setNikeName:(NSString *)nikeName{
    if ([nikeName isEqualToString:_nikeName]) {
        return;
    }
    _nikeName = nikeName;
    if (self.remarkName.length == 0 && self.nikeName.length > 0) {
        self.pinyin = nikeName.pinyin;
        self.pinyinInitial = nikeName.pinyinInitial;
    }
}
- (void)setRemarkName:(NSString *)remarkName{
    if ([remarkName isEqualToString:_remarkName]) {
        return;
    }
    _remarkName = remarkName;
    if (_remarkName.length > 0) {
        self.pinyin = remarkName.pinyin;
        self.pinyinInitial = remarkName.pinyinInitial;
    }
}
#pragma mark - Getter
- (NSString *)showName{
    return self.remarkName.length > 0 ? self.remarkName : (self.nikeName.length > 0 ? self.nikeName : self.username);
}
- (TLUserDetail *)detailInfo{
    if (_detailInfo == nil) {
        _detailInfo = [[TLUserDetail alloc] init];
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

@implementation TLUserGroup
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
@implementation TLGroup
- (id)init{
    if (self = [super init]) {
        [TLGroup mj_setupObjectClassInArray:^NSDictionary *{
            return @{ @"users" : @"TLUser" };
        }];
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
- (TLUser *)memberByUserID:(NSString *)uid{
    for (TLUser *user in self.users) {
        if ([user.userID isEqualToString:uid]) {
            return user;
        }
    }
    return nil;
}
- (NSString *)groupName{
    if (_groupName == nil || _groupName.length == 0) {
        for (TLUser *user in self.users) {
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
        _myNikeName = [TLUserHelper sharedHelper].user.showName;
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
        _pinyinInitial = self.groupName.pinyinInitial;
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
@implementation TLContact
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
        _pinyinInitial = self.name.pinyinInitial;
    }
    return _pinyinInitial;
}
@end

static TLFriendHelper *friendHelper = nil;
@interface TLFriendHelper ()
@property (nonatomic, strong) TLDBFriendStore *friendStore;
@property (nonatomic, strong) TLDBGroupStore *groupStore;
@end
@implementation TLFriendHelper
+ (TLFriendHelper *)sharedFriendHelper{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        friendHelper = [[TLFriendHelper alloc] init];
    });
    return friendHelper;
}
- (id)init{
    if (self = [super init]) {
        // 初始化好友数据
        self.friendsData = [self.friendStore friendsDataByUid:[TLUserHelper sharedHelper].user.userID];
        self.data = [[NSMutableArray alloc] initWithObjects:self.defaultGroup, nil];
        self.sectionHeaders = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
        // 初始化群数据
        self.groupsData = [self.groupStore groupsDataByUid:[TLUserHelper sharedHelper].user.userID];
        // 初始化标签数据
        self.tagsData = [[NSMutableArray alloc] init];
        [self p_initTestData];
    }
    return self;
}
#pragma mark - Public Methods -
- (TLUser *)getFriendInfoByUserID:(NSString *)userID{
    if (userID == nil) {
        return nil;
    }
    for (TLUser *user in self.friendsData) {
        if ([user.userID isEqualToString:userID]) {
            return user;
        }
    }
    return nil;
}
- (TLGroup *)getGroupInfoByGroupID:(NSString *)groupID{
    if (groupID == nil) {
        return nil;
    }
    for (TLGroup *group in self.groupsData) {
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
        NSString *strA = ((TLUser *)obj1).pinyin;
        NSString *strB = ((TLUser *)obj2).pinyin;
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
    TLUserGroup *curGroup;
    TLUserGroup *othGroup = [[TLUserGroup alloc] init];
    [othGroup setGroupName:@"#"];
    for (TLUser *user in serializeArray) {
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
            curGroup = [[TLUserGroup alloc] init];
            [curGroup setGroupName:[NSString stringWithFormat:@"%c", c]];
            [curGroup addObject:user];
        }else{
            [curGroup addObject:user];
        }
        
        // TAGs
        if (user.detailInfo.tags.count > 0) {
            for (NSString *tag in user.detailInfo.tags) {
                TLUserGroup *group = [tagsDic objectForKey:tag];
                if (group == nil) {
                    group = [[TLUserGroup alloc] init];
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
    NSArray *arr = [TLUser mj_objectArrayWithKeyValuesArray:jsonArray];
    [self.friendsData removeAllObjects];
    [self.friendsData addObjectsFromArray:arr];
    // 更新好友数据到数据库
    BOOL ok = [self.friendStore updateFriendsData:self.friendsData forUid:[TLUserHelper sharedHelper].user.userID];
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
    arr = [TLGroup mj_objectArrayWithKeyValuesArray:jsonArray];
    [self.groupsData removeAllObjects];
    [self.groupsData addObjectsFromArray:arr];
    ok = [self.groupStore updateGroupsData:self.groupsData forUid:[TLUserHelper sharedHelper].user.userID];
    if (!ok) {
        DLog(@"保存群数据到数据库失败!");
    }
    // 生成Group Icon
    for (TLGroup *group in self.groupsData) {
        [FreedomTools createGroupAvatar:group finished:nil];
    }
}
#pragma mark - Getter
- (TLUserGroup *)defaultGroup{
    if (_defaultGroup == nil) {
        TLUser *item_new = [[TLUser alloc] init];
        item_new.userID = @"-1";
        item_new.avatarPath = PpersonAddHL;
        item_new.remarkName = @"新的朋友";
        TLUser *item_group = [[TLUser alloc] init];
        item_group.userID = @"-2";
        item_group.avatarPath = @"add_friend_icon_addgroup@3x";
        item_group.remarkName = @"群聊";
        TLUser *item_tag = [[TLUser alloc] init];
        item_tag.userID = @"-3";
        item_tag.avatarPath = @"Contact_icon_ContactTag@3x";
        item_tag.remarkName = @"标签";
        TLUser *item_public = [[TLUser alloc] init];
        item_public.userID = @"-4";
        item_public.avatarPath = @"add_friend_icon_offical@3x";
        item_public.remarkName = @"公共号";
        _defaultGroup = [[TLUserGroup alloc] initWithGroupName:nil users:[NSMutableArray arrayWithObjects:item_new, item_group, item_tag, item_public, nil]];
    }
    return _defaultGroup;
}
- (NSInteger)friendCount{
    return self.friendsData.count;
}
- (TLDBFriendStore *)friendStore{
    if (_friendStore == nil) {
        _friendStore = [[TLDBFriendStore alloc] init];
    }
    return _friendStore;
}
- (TLDBGroupStore *)groupStore{
    if (_groupStore == nil) {
        _groupStore = [[TLDBGroupStore alloc] init];
    }
    return _groupStore;
}
- (NSMutableArray *)friendDetailArrayByUserInfo:(TLUser *)userInfo{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    // 1
    TLInfo *user = TLCreateInfo(@"个人", nil);
    user.type = TLInfoTypeOther;
    user.userInfo = userInfo;
    [arr addObject:user];
    [data addObject:arr];
    
    // 2
    arr = [[NSMutableArray alloc] init];
    if (userInfo.detailInfo.phoneNumber.length > 0) {
        TLInfo *tel = TLCreateInfo(@"电话号码", userInfo.detailInfo.phoneNumber);
        tel.showDisclosureIndicator = NO;
        [arr addObject:tel];
    }
    if (userInfo.detailInfo.tags.count == 0) {
        TLInfo *remark = TLCreateInfo(@"设置备注和标签" , nil);
        [arr insertObject:remark atIndex:0];
    }else{
        NSString *str = [userInfo.detailInfo.tags componentsJoinedByString:@","];
        TLInfo *remark = TLCreateInfo(@"标签", str);
        [arr addObject:remark];
    }
    [data addObject:arr];
    arr = [[NSMutableArray alloc] init];
    
    // 3
    if (userInfo.detailInfo.location.length > 0) {
        TLInfo *location = TLCreateInfo(@"地区", userInfo.detailInfo.location);
        location.showDisclosureIndicator = NO;
        location.disableHighlight = YES;
        [arr addObject:location];
    }
    TLInfo *album = TLCreateInfo(@"个人相册", nil);
    album.userInfo = userInfo.detailInfo.albumArray;
    album.type = TLInfoTypeOther;
    [arr addObject:album];
    TLInfo *more = TLCreateInfo(@"更多", nil);
    [arr addObject:more];
    [data addObject:arr];
    arr = [[NSMutableArray alloc] init];
    
    // 4
    TLInfo *sendMsg = TLCreateInfo(@"发消息", nil);
    sendMsg.type = TLInfoTypeButton;
    sendMsg.titleColor = [UIColor whiteColor];
    sendMsg.buttonBorderColor = colorGrayLine;
    [arr addObject:sendMsg];
    if (![userInfo.userID isEqualToString:[TLUserHelper sharedHelper].user.userID]) {
        TLInfo *video = TLCreateInfo(@"视频聊天", nil);
        video.type = TLInfoTypeButton;
        video.buttonBorderColor = colorGrayLine;
        video.buttonColor = [UIColor whiteColor];
        [arr addObject:video];
    }
    [data addObject:arr];
    
    return data;
}
- (NSMutableArray *)friendDetailSettingArrayByUserInfo:(TLUser *)userInfo{
    TLSettingItem *remark = TLCreateSettingItem(@"设置备注及标签");
    if (userInfo.remarkName.length > 0) {
        remark.subTitle = userInfo.remarkName;
    }
    TLSettingGroup *group1 = TLCreateSettingGroup(nil, nil, @[remark]);
    
    TLSettingItem *recommand = TLCreateSettingItem(@"把他推荐给朋友");
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, @[recommand]);
    
    TLSettingItem *starFriend = TLCreateSettingItem(@"设为星标朋友");
    starFriend.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group3 = TLCreateSettingGroup(nil, nil, @[starFriend]);
    
    TLSettingItem *prohibit = TLCreateSettingItem(@"不让他看我的朋友圈");
    prohibit.type = TLSettingItemTypeSwitch;
    TLSettingItem *dismiss = TLCreateSettingItem(@"不看他的朋友圈");
    dismiss.type = TLSettingItemTypeSwitch;
    TLSettingGroup *group4 = TLCreateSettingGroup(nil, nil, (@[prohibit, dismiss]));
    
    TLSettingItem *blackList = TLCreateSettingItem(@"加入黑名单");
    blackList.type = TLSettingItemTypeSwitch;
    TLSettingItem *report = TLCreateSettingItem(@"举报");
    TLSettingGroup *group5 = TLCreateSettingGroup(nil, nil, (@[blackList, report]));
    
    return [NSMutableArray arrayWithObjects:group1, group2, group3, group4, group5, nil];
}
+ (void)tryToGetAllContactsSuccess:(void (^)(NSArray *data, NSArray *formatData, NSArray *headers))success
                            failed:(void (^)())failed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1、获取通讯录信息
        ABAddressBookRef addressBooks = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }else{
            addressBooks = ABAddressBookCreate();
        }
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        
        // 2、加载缓存
        if (allPeople != nil &&  CFArrayGetCount(allPeople) > 0) {
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
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                failed();
            });
            return;
        }
        
        // 3、格式转换
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < nPeople; i++) {
            TLContact  *contact = [[TLContact  alloc] init];
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            }else{
                if ((__bridge id)abLastName != nil) {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            contact.name = nameString;
            contact.recordID = (int)ABRecordGetRecordID(person);;
            
            if(ABPersonHasImageData(person)) {
                NSData *imageData = (__bridge NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
                NSString *imageName = [NSString stringWithFormat:@"%.0lf.jpg", [NSDate date].timeIntervalSince1970 * 10000];
                NSString *imagePath = [NSFileManager pathContactsAvatar:imageName];
                [imageData writeToFile:imagePath atomically:YES];
                contact.avatarPath = imageName;
            }
            
            ABPropertyID multiProperties[] = {
                kABPersonPhoneProperty,
                kABPersonEmailProperty
            };
            NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
            for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
                ABPropertyID property = multiProperties[j];
                ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
                NSInteger valuesCount = 0;
                if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
                if (valuesCount == 0) {
                    CFRelease(valuesRef);
                    continue;
                }
                for (NSInteger k = 0; k < valuesCount; k++) {
                    CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                    switch (j) {
                        case 0: {// Phone number
                            contact.tel = (__bridge NSString*)value;
                            break;
                        }
                        case 1: {// Email
                            contact.email = (__bridge NSString*)value;
                            break;
                        }
                    }
                    CFRelease(value);
                }
                CFRelease(valuesRef);
            }
            [data addObject:contact];
            
            if (abName) CFRelease(abName);
            if (abLastName) CFRelease(abLastName);
            if (abFullName) CFRelease(abFullName);
        }
        
        // 4、排序
        NSArray *serializeArray = [data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            int i;
            NSString *strA = ((TLContact *)obj1).pinyin;
            NSString *strB = ((TLContact *)obj2).pinyin;
            for (i = 0; i < strA.length && i < strB.length; i ++) {
                char a = toupper([strA characterAtIndex:i]);
                char b = toupper([strB characterAtIndex:i]);
                if (a > b) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else if (a < b) {
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
        TLUserGroup *curGroup;
        TLUserGroup *othGroup = [[TLUserGroup alloc] init];
        [othGroup setGroupName:@"#"];
        for (TLContact *contact in serializeArray) {
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
                curGroup = [[TLUserGroup alloc] init];
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
    });
}
@end


static TLUserHelper *helper;
@interface TLUserHelper()
@property (nonatomic, strong) NSMutableArray *systemEmojiGroups;
@property (nonatomic, strong) void (^complete)(NSMutableArray *);
@end
@implementation TLUserHelper
+ (TLUserHelper *) sharedHelper{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        helper = [[TLUserHelper alloc] init];
    });
    return helper;
}
- (id) init{
    if (self = [super init]) {
        self.user = [[TLUser alloc] init];
        self.user.userID = @"这是我的二维码：2829969299 \n没错，我爱你。";//我的二维码数据
        self.user.avatarURL = @"https://p1.ssl.qhmsg.com/dm/110_110_100/t01fffa4efd00af1898.jpg";
        self.user.nikeName = @"薛超";
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
        NSArray *defaultEmojiGroups = @[[TLExpressionHelper sharedHelper].defaultFaceGroup,
                                        [TLExpressionHelper sharedHelper].defaultSystemEmojiGroup];
        [emojiGroupData addObject:defaultEmojiGroups];
        
        // 用户收藏的表情包
        TLEmojiGroup *preferEmojiGroup = [TLExpressionHelper sharedHelper].userPreferEmojiGroup;
        if (preferEmojiGroup && preferEmojiGroup.count > 0) {
            [emojiGroupData addObject:@[preferEmojiGroup]];
        }
        
        // 用户的表情包
        NSArray *userGroups = [TLExpressionHelper sharedHelper].userEmojiGroups;
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
