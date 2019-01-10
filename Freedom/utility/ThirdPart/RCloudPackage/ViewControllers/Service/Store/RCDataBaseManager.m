//
//  RCDataBaseManager.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/6/3.
//  Copyright (c) 2015年 dlz. All rights reserved.
//
#import "RCDataBaseManager.h"
#import "RCDHttpTool.h"
#import "RCloudModel.h"
#import <Realm/Realm.h>
#import <Foundation/Foundation.h>
@interface XRCUserInfo: RLMObject
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *portraitUri;
@property(nonatomic, assign) BOOL isBlack;

@property(nonatomic, strong) NSString *quanPin;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *updatedAt;
@property(nonatomic, strong) NSString *displayName;
- (instancetype)initWithUserInfo:(RCUserInfo *)info;
- (instancetype)initWithRCDUserInfo:(RCDUserInfo *)info;
- (RCUserInfo*)toRCUserInfo;
- (RCDUserInfo*)toRCDUserInfo;
@end
@interface XRCGroup: RLMObject
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) NSString *portraitUri;
@property(nonatomic, strong) NSString *number;
@property(nonatomic, strong) NSString *maxNumber;
@property(nonatomic, strong) NSString *introduce;
@property(nonatomic, strong) NSString *creatorId;
@property(nonatomic, strong) NSString *creatorTime;
@property(nonatomic, assign) BOOL isJoin;
@property(nonatomic, strong) NSString *isDismiss;
- (instancetype)initWithGroupInfo:(RCDGroupInfo *)info;
- (RCDGroupInfo*)toRCGroupInfo;
@end
@implementation XRCUserInfo
+(NSString *)primaryKey {
    return @"userId";
}
- (instancetype)initWithUserInfo:(RCUserInfo *)info {
    XRCUserInfo *user = [[XRCUserInfo alloc]init];
    user.userId = info.userId;
    user.name = info.name;
    user.portraitUri = info.portraitUri;
    if (user.portraitUri.length <= 0) {
        user.portraitUri = [FreedomTools defaultUserPortrait:info];
    }
    return user;
}
-(instancetype)initWithRCDUserInfo:(RCDUserInfo *)info {
    XRCUserInfo *user = [[XRCUserInfo alloc]init];
    user.userId = info.userId;
    user.name = info.name;
    user.portraitUri = info.portraitUri;
    if (user.portraitUri.length <= 0) {
        user.portraitUri = [FreedomTools defaultUserPortrait:info];
    }
    user.quanPin = info.quanPin;
    user.email = info.email;
    user.status = info.status;
    user.updatedAt = info.updatedAt;
    user.displayName = info.displayName;
    return user;
}
- (RCUserInfo*)toRCUserInfo {
    return [[RCUserInfo alloc]initWithUserId:self.userId name:self.name portrait:self.portraitUri];
}
-(RCDUserInfo *)toRCDUserInfo {
    RCDUserInfo *user = [[RCDUserInfo alloc]initWithUserId:self.userId name:self.name portrait:self.portraitUri];
    user.quanPin = self.quanPin;
    user.email = self.email;
    user.status = self.status;
    user.updatedAt = self.updatedAt;
    user.displayName = self.displayName;
    return user;
}
@end
@implementation XRCGroup
+(NSString *)primaryKey{
    return @"groupId";
}
-(instancetype)initWithGroupInfo:(RCDGroupInfo *)info {
    self = [super init];
    self.groupId = info.groupId;
    self.groupName = info.groupName;
    self.portraitUri = info.portraitUri;
    self.number = info.number;
    self.maxNumber = info.maxNumber;
    self.introduce = info.introduce;
    self.creatorId = info.creatorId;
    self.creatorTime = info.creatorTime;
    self.isJoin = info.isJoin;
    self.isDismiss = info.isDismiss;
    return self;
}
-(RCDGroupInfo *)toRCGroupInfo {
    RCDGroupInfo *info = [[RCDGroupInfo alloc]initWithGroupId:self.groupId groupName:self.groupName portraitUri:self.portraitUri];
    info.number = self.number;
    info.maxNumber = self.maxNumber;
    info.introduce = self.introduce;
    info.creatorId = self.creatorId;
    info.creatorTime = self.creatorTime;
    info.isJoin = self.isJoin;
    info.isDismiss = self.isDismiss;
    return info;
}
@end

@interface RCDataBaseManager ()
@property(nonatomic,strong)RLMRealm *rcRealm;
@end
@implementation RCDataBaseManager
+ (RCDataBaseManager *)shareInstance {
  static RCDataBaseManager *instance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[[self class] alloc] init];
    [instance rcRealm];
  });
  return instance;
}

- (void)moveFile:(NSString*)fileName fromPath:(NSString*)fromPath toPath:(NSString*)toPath{
  if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  NSString* srcPath = [fromPath stringByAppendingPathComponent:fileName];
  NSString* dstPath = [toPath stringByAppendingPathComponent:fileName];
  [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:nil];
}
-(RLMRealm *)rcRealm {
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId == nil) {
        return nil;
    }
    if (!_rcRealm) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask, YES);
        NSString *library = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"RongCloud"];
        NSFileManager *man = [NSFileManager defaultManager];
        if (![man fileExistsAtPath:library]) {
            [man createDirectoryAtPath:library withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *dbPath = [library stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.realm",[RCIMClient sharedRCIMClient].currentUserInfo.userId]];
        _rcRealm = [RLMRealm realmWithURL:[NSURL fileURLWithPath:dbPath]];
        [_rcRealm transactionWithBlock:^{
            [XRCUserInfo createOrUpdateInRealm:self.rcRealm withValue:[XRCUserInfo new]];
            [XRCGroup createOrUpdateInRealm:self.rcRealm withValue:[XRCGroup new]];
        }];
    }
    return _rcRealm;
}
//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user {
    [self.rcRealm transactionWithBlock:^{
        XRCUserInfo *info = [[XRCUserInfo alloc]initWithUserInfo:user];
        [self.rcRealm addOrUpdateObject:info];
    }];
}
//存储用户列表信息
- (void)insertUserListToDB:(NSMutableArray *)userList complete:(void (^)(BOOL))result{
  if (userList == nil || [userList count] < 1)return;
  [self.rcRealm transactionWithBlock:^{
      for (RCUserInfo *user in userList) {
          XRCUserInfo *info = [[XRCUserInfo alloc]initWithUserInfo:user];
          [self.rcRealm addOrUpdateObject:info];
      }
  }];
  result (YES);
}
//插入黑名单列表
- (void)insertBlackListToDB:(RCUserInfo *)user {
    [self.rcRealm transactionWithBlock:^{
        XRCUserInfo *info = [[XRCUserInfo alloc]initWithUserInfo:user];
        info.isBlack = YES;
        [self.rcRealm addOrUpdateObject:info];
    }];
}
- (void)insertBlackListUsersToDB:(NSMutableArray *)userList complete:(void (^)(BOOL))result{
  if (userList == nil || [userList count] < 1)return;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [self.rcRealm transactionWithBlock:^{
          for (RCUserInfo *user in userList) {
              XRCUserInfo *info = [[XRCUserInfo alloc]initWithUserInfo:user];
              info.isBlack = YES;
              [self.rcRealm addOrUpdateObject:info];
          }
      }];
    result (YES);
  });
}
//获取黑名单列表
- (NSArray *)getBlackList {
  NSMutableArray *allBlackList = [NSMutableArray new];
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"isBlack = %d",1];
        for (XRCUserInfo *user in results) {
            RCUserInfo *info = user.toRCUserInfo;
            [allBlackList addObject:info];
        }
    }];
  return allBlackList;
}
//移除黑名单
- (void)removeBlackList:(NSString *)userId {
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"userId = %@",userId];
        XRCUserInfo *info = [results firstObject];
        [self.rcRealm deleteObject:info];
    }];
}
//清空黑名单缓存数据
- (void)clearBlackListData {
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"isBlack = %d",1];
        if (results.count > 0){
        [self.rcRealm deleteObjects:results];
        }
    }];
}
//从表中获取用户信息
- (RCUserInfo *)getUserByUserId:(NSString *)userId {
    RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"userId = %@",userId];
    XRCUserInfo *info = [results firstObject];
    RCUserInfo *user = [info toRCUserInfo];
    return user;
}
//从表中获取所有用户信息
- (NSArray *)getAllUserInfo {
    NSMutableArray *allUsers = [NSMutableArray new];
    RLMResults *results = [XRCUserInfo allObjects];
    for (XRCUserInfo *info in results) {
        RCUserInfo *user = [info toRCUserInfo];
        [allUsers addObject:user];
    }
  return allUsers;
}
//存储群组信息
- (void)insertGroupToDB:(RCDGroupInfo *)group {
    if (group == nil || [group.groupId length] < 1)return;
    [self.rcRealm transactionWithBlock:^{
        XRCGroup *xgroup = [[XRCGroup alloc]initWithGroupInfo:group];
        [self.rcRealm addObject:xgroup];
    }];

}
- (void)insertGroupsToDB:(NSMutableArray *)groupList complete:(void (^)(BOOL))result{
  if (groupList == nil || [groupList count] < 1)return;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [self.rcRealm transactionWithBlock:^{
          for (RCDGroupInfo *group in groupList) {
              XRCGroup *xgroup = [[XRCGroup alloc]initWithGroupInfo:group];
              [self.rcRealm addOrUpdateObject:xgroup];
          }
      }];
    result (YES);
  });
}
//从表中获取群组信息
- (RCDGroupInfo *)getGroupByGroupId:(NSString *)groupId {
    RLMResults *results = [XRCGroup objectsInRealm:self.rcRealm where:@"groupId = %@",groupId];
    XRCGroup *info = [results firstObject];
    RCDGroupInfo *group = [info toRCGroupInfo];
    return group;
}
//删除表中的群组信息
- (void)deleteGroupToDB:(NSString *)groupId {
    if ([groupId length] < 1)return;
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"groupId = %@",groupId];
        if(results.count > 0) {
        [self.rcRealm deleteObjects:results];
        }
    }];
}
//清空表中的所有的群组信息
- (BOOL)clearGroupfromDB {
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCGroup allObjects];
        if (results.count > 0){
            [self.rcRealm deleteObjects:results];
        }
    }];
    return YES;
}
//从表中获取所有群组信息
- (NSMutableArray *)getAllGroup {
    NSMutableArray *allGroups = [NSMutableArray new];
    RLMResults *results = [XRCGroup allObjects];
    for (XRCGroup *group in results) {
        RCDGroupInfo *info = [group toRCGroupInfo];
        [allGroups addObject:info];
    }
    return allGroups;
}
//存储群组成员信息
- (void)insertGroupMemberToDB:(NSMutableArray *)groupMemberList groupId:(NSString *)groupId complete:(void (^)(BOOL))result{
    if (groupMemberList == nil || [groupMemberList count] < 1)return;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [self.rcRealm transactionWithBlock:^{
          RLMResults *results = [XRCGroup objectsInRealm:self.rcRealm where:@"groupId = %@",groupId];
          if(results.count>0){
          [self.rcRealm deleteObjects:results];
          }
          for (RCUserInfo *user in groupMemberList) {
              XRCUserInfo *info = [[XRCUserInfo alloc]initWithUserInfo:user];
              [self.rcRealm addOrUpdateObject:info];
          }
      }];
      result (YES);
  });
}
//从表中获取群组成员信息
- (NSMutableArray *)getGroupMember:(NSString *)groupId {
    NSMutableArray *allUsers = [NSMutableArray new];
    RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"userId = %@",groupId];
    for (XRCUserInfo *info in results) {
        RCUserInfo *user = [info toRCUserInfo];
        [allUsers addObject:user];
    }
    return allUsers;
}
//存储好友信息
- (void)insertFriendToDB:(RCDUserInfo *)friendInfo {
    [self.rcRealm transactionWithBlock:^{
        XRCUserInfo *user = [[XRCUserInfo alloc]initWithRCDUserInfo:friendInfo];
        [self.rcRealm addOrUpdateObject:user];
    }];
}
- (void)insertFriendListToDB:(NSMutableArray *)FriendList complete:(void (^)(BOOL))result{
  if (FriendList == nil || [FriendList count] < 1)return;
  [self.rcRealm transactionWithBlock:^{
      for (RCDUserInfo *user in FriendList) {
          XRCUserInfo *info = [[XRCUserInfo alloc]initWithRCDUserInfo:user];
          [self.rcRealm addOrUpdateObject:info];
      }
  }];
    result (YES);
}
//从表中获取所有好友信息 //RCUserInfo
- (NSArray *)getAllFriends {
  NSMutableArray *allUsers = [NSMutableArray new];
    RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"status != """];
    for (XRCUserInfo *user in results){
        RCDUserInfo *info = [user toRCDUserInfo];
        [allUsers addObject:info];
    }
  return allUsers;
}
//从表中获取某个好友的信息
- (RCDUserInfo *)getFriendInfo:(NSString *)friendId {
    RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"userid = %@", friendId];
    XRCUserInfo *info = results.firstObject;
    return [info toRCDUserInfo];
}
//清空群组缓存数据
- (void)clearGroupsData {
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCGroup allObjects];
        if(results.count>0){
        [self.rcRealm deleteObjects:results];
        }
    }];
}
//清空好友缓存数据
- (void)clearFriendsData {
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCUserInfo allObjects];
        if(results.count>0){
            [self.rcRealm deleteObjects:results];
        }
    }];
}
- (void)deleteFriendFromDB:(NSString *)userId {
    [self.rcRealm transactionWithBlock:^{
        RLMResults *results = [XRCUserInfo objectsInRealm:self.rcRealm where:@"userid = %@",userId];
        if(results.count>0){
        [self.rcRealm deleteObjects:results];
        }
    }];
}
@end
