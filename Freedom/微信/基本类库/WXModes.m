//
//  WXModes.m
//  Freedom
#import "WXModes.h"
//#import "Freedom-Swift.h"
@implementation CRRouteLine
@end
@implementation WXModes
+ (NSString *)primaryKey{
    return @"code";
}
+(NSDictionary *)defaultPropertyValues{
    return @{@"code": @0};
}
+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"isLike"];
}
@end
@implementation WXUserChatSetting
@end
@implementation WXUserDetail
@end
@implementation WXUserSetting
@end
@implementation WXUser
+(NSDictionary *)defaultPropertyValues{
    WXUserDetail *detail = [[WXUserDetail alloc]init];
    WXUserSetting *setting = [[WXUserSetting alloc]init];
    WXUserChatSetting *chatSet = [[WXUserChatSetting alloc]init];
    return @{@"detailInfo": detail,@"userSetting":setting,@"chatSetting":chatSet,@"avatarPath":@"",@"nikeName":@""};
}
@end
@implementation WXUserGroup
+ (NSString *)primaryKey{
    return @"groupName";
}
@end
@implementation WXGroup
+(NSDictionary *)defaultPropertyValues{
    return @{@"showNameInChat": @1};
}
- (WXUser*)groupMemberbyID:(NSString*)userID{
    for (int i = 0; i < self.users.count; i++) {
        WXUser *user = self.users[i];
        if ([user.userID isEqualToString:userID]) {
            return user;
        }
    }
    return nil;
}
- (NSArray<WXUser*>*)groupMembers {
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < self.users.count; i++) {
        [temp addObject:self.users[i]];
    }
    return temp;
}
- (WXUser*)user{
    WXUser *user = [[WXUser alloc]init];
    user.userID = self.userID;
    user.username = self.username;
    return user;
}
-(BOOL)isUser {
    return false;
}
@end
@implementation WechatContact
@end
@implementation WXMoment
+ (NSString *)primaryKey{
    return @"momentID";
}
@end
@implementation WXModel
- (WXUser*)groupMemberbyID:(NSString*)userID{
    return nil;
}
- (NSArray<WXUser*>*)groupMembers {
    return @[];
}
+ (NSString *)primaryKey{
    return @"userID";
}
+(NSDictionary *)defaultPropertyValues{
    return @{@"userID": @"0"};
}
-(BOOL)isUser {
    return true;
}
@end
@implementation WXMomentComment
@end
@implementation WXMomentDetail
@end
@implementation WXMomentExtension
@end
@implementation WXInfo
@end
