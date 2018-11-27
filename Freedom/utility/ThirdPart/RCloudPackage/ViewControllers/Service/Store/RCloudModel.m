//
//  RCloudModel.m
//  SealTalk
//
//  Created by Super on 7/5/18.
//  Copyright © 2018 RongCloud. All rights reserved.
#import "RCloudModel.h"
@implementation RCDSearchResultModel
@end
#define RCUserDefaultsSet(value,key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:key]
#define RCUserDefaultsGet(key) [[NSUserDefaults standardUserDefaults] valueForKey:key]
static NSString *rcAppKeySettingKey = @"rcAppKeySettingKey";
static NSString *rcDemoServerSettingKey = @"rcDemoServerSettingKey";
static NSString *rcNaviServerSettingKey = @"rcNaviServerSettingKey";
static NSString *rcFileServerSettingKey = @"rcFileServerSettingKey";
@implementation RCDSettingUserDefaults
//设置appKey
+ (void)setRCAppKey:(NSString *)appKey {
    RCUserDefaultsSet(appKey, rcAppKeySettingKey);
}
//设置DemoServer
+ (void)setRCDemoServer:(NSString *)demoServer {
    RCUserDefaultsSet(demoServer, rcDemoServerSettingKey);
}
//设置NaviServer
+ (void)setRCNaviServer:(NSString *)naviServer {
    RCUserDefaultsSet(naviServer, rcNaviServerSettingKey);
}
//设置FileServer
+ (void)setRCFileServer:(NSString *)fileServer {
    RCUserDefaultsSet(fileServer, rcFileServerSettingKey);
}
//获取appKey
+ (NSString *)getRCAppKey {
    return RCUserDefaultsGet(rcAppKeySettingKey);
}
//获取DemoServer
+ (NSString *)getRCDemoServer {
    return RCUserDefaultsGet(rcDemoServerSettingKey);
}
//获取NaviServer
+ (NSString *)getRCNaviServer {
    return RCUserDefaultsGet(rcNaviServerSettingKey);
}
//获取FileServer
+ (NSString *)getRCFileServer {
    return RCUserDefaultsGet(rcFileServerSettingKey);
}
@end
@implementation RCDChatRoomInfo
@end
@implementation RCDGroupInfo
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        if (decoder == nil) {
            return self;
        }
        self.number = [decoder decodeObjectForKey:@"number"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.number forKey:@"number"];
}
@end
@implementation RCDTestMessage
///初始化
+ (instancetype)messageWithContent:(NSString *)content {
    RCDTestMessage *text = [[RCDTestMessage alloc] init];
    if (text) {
        text.content = content;
    }
    return text;
}
///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}
/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}
/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}
///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.content forKey:@"content"];
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}
///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.content = dictionary[@"content"];
            self.extra = dictionary[@"extra"];
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}
/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.content;
}
///消息的类型名
+ (NSString *)getObjectName {
    return @"RCD:TstMsg";
}
@end
@implementation RCDUserInfo
@end
@implementation RCloudModel
@end
@interface RCDCustomerEmoticonTab()
@end
@implementation RCDCustomerEmoticonTab
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index {
    UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 186)];
    view11.backgroundColor = [UIColor blackColor];
    switch (index) {
        case 1:view11.backgroundColor = [UIColor yellowColor];break;
        case 2:view11.backgroundColor = [UIColor redColor];break;
        case 3:view11.backgroundColor = [UIColor greenColor];break;
        case 4:view11.backgroundColor = [UIColor grayColor];break;
        default:break;
    }
    return view11;
}
@end
