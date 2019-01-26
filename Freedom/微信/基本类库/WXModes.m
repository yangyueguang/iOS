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
//+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties{
//        return @{@"parent":[RLMPropertyDescriptor descriptorWithClass:[CRRouteLine class] propertyName:@"CodeID"]};
//}
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
+ (NSString *)primaryKey{
    return @"userID";
}
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
+ (NSString *)primaryKey{
    return @"groupID";
}
+(NSDictionary *)defaultPropertyValues{
    return @{@"showNameInChat": @1};
}
@end
@implementation WechatContact
@end
@implementation WXMoment
+(NSDictionary *)defaultPropertyValues{
    return @{@"height": @76};
}
@end
@implementation WXMomentComment
+(NSDictionary *)defaultPropertyValues{
    return @{@"height": @35};
}
@end
@implementation WXMomentDetail
@end
@implementation WXMomentExtension
@end
@implementation WXInfo
@end
