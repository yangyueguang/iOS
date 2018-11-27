//  TLExpressionHelper.m
//  Freedom
// Created by Super
#import "TLExpressionHelper.h"
#import "TLDBManager.h"
#import "TLUserHelper.h"
#import "TLEmojiBaseCell.h"
#define     IEXPRESSION_HOST_URL        @"http://123.57.155.230:8080/ibiaoqing/admin/"
#define     IEXPRESSION_NEW_URL         [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=%ld&status=Y&status1=B"]
#define     IEXPRESSION_BANNER_URL      [IEXPRESSION_HOST_URL stringByAppendingString: @"advertisement/getAll.do?status=on"]
#define     IEXPRESSION_PUBLIC_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=%ld&status=Y&status1=B&count=yes"]
#define     IEXPRESSION_SEARCH_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/listBy.do?pageNumber=1&status=Y&eName=%@&seach=yes"]
#define     IEXPRESSION_DETAIL_URL      [IEXPRESSION_HOST_URL stringByAppendingString:@"expre/getByeId.do?pageNumber=%ld&eId=%@"]
@interface TLExpressionHelper ()
@property (nonatomic, strong) TLDBExpressionStore *store;
@end
@implementation TLExpressionHelper
@synthesize defaultFaceGroup = _defaultFaceGroup;
@synthesize defaultSystemEmojiGroup = _defaultSystemEmojiGroup;
@synthesize userEmojiGroups = _userEmojiGroups;
+ (TLExpressionHelper *)sharedHelper{
    static TLExpressionHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[TLExpressionHelper alloc] init];
    });
    return helper;
}
- (NSArray *)userEmojiGroups{
    return [self.store expressionGroupsByUid:[TLUserHelper sharedHelper].user.userID];
}
- (BOOL)addExpressionGroup:(TLEmojiGroup *)emojiGroup{
    BOOL ok = [self.store addExpressionGroup:emojiGroup forUid:[TLUserHelper sharedHelper].user.userID];
    if (ok) {       // 通知表情键盘
        [[TLUserHelper sharedHelper]updateEmojiGroupData];
    }
    return ok;
}
- (BOOL)deleteExpressionGroupByID:(NSString *)groupID{
    BOOL ok = [self.store deleteExpressionGroupByID:groupID forUid:[TLUserHelper sharedHelper].user.userID];
    if (ok) {       // 通知表情键盘
        [[TLUserHelper sharedHelper] updateEmojiGroupData];
    }
    return ok;
}
- (BOOL)didExpressionGroupAlwaysInUsed:(NSString *)groupID{
    NSInteger count = [self.store countOfUserWhoHasExpressionGroup:groupID];
    return count > 0;
}
- (TLEmojiGroup *)emojiGroupByID:(NSString *)groupID;{
    for (TLEmojiGroup *group in self.userEmojiGroups) {
        if ([group.groupID isEqualToString:groupID]) {
            return group;
        }
    }
    return nil;
}
- (void)downloadExpressionsWithGroupInfo:(TLEmojiGroup *)group
                                progress:(void (^)(CGFloat))progress
                                 success:(void (^)(TLEmojiGroup *))success
                                 failure:(void (^)(TLEmojiGroup *, NSString *))failure{
    dispatch_queue_t downloadQueue = dispatch_queue_create([group.groupID UTF8String], nil);
    dispatch_group_t downloadGroup = dispatch_group_create();
    
    for (int i = 0; i <= group.data.count; i++) {
        dispatch_group_async(downloadGroup, downloadQueue, ^{
            NSString *groupPath = [NSFileManager pathExpressionForGroupID:group.groupID];
            NSString *emojiPath;
            NSData *data = nil;
            if (i == group.data.count) {
                emojiPath = [NSString stringWithFormat:@"%@icon_%@", groupPath, group.groupID];
                data = [NSData dataWithContentsOfURL:TLURL(group.groupIconURL)];
            }else{
                TLEmoji *emoji = group.data[i];
                NSString *urlString = [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/download.do?pId=%@",emoji.emojiID];
                data = [NSData dataWithContentsOfURL:TLURL(urlString)];
                if (data == nil) {
                    urlString = [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/downloadsuo.do?pId=%@", emoji.emojiID];
                    data = [NSData dataWithContentsOfURL:TLURL(urlString)];
                }
                emojiPath = [NSString stringWithFormat:@"%@%@", groupPath, emoji.emojiID];
            }
            
            [data writeToFile:emojiPath atomically:YES];
        });
    }
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        success(group);
    });
}
#pragma mark - 
- (TLDBExpressionStore *)store{
    if (_store == nil) {
        _store = [[TLDBExpressionStore alloc] init];
    }
    return _store;
}
- (NSMutableArray *)myExpressionListData{
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSMutableArray *myEmojiGroups = [NSMutableArray arrayWithArray:[self.store expressionGroupsByUid:[TLUserHelper sharedHelper].user.userID]];
    if (myEmojiGroups.count > 0) {
        TLSettingGroup *group1 = TLCreateSettingGroup(@"聊天面板中的表情", nil, myEmojiGroups);
        [data addObject:group1];
    }
    
    TLSettingItem *userEmojis = TLCreateSettingItem(@"添加的表情");
    TLSettingItem *buyedEmojis = TLCreateSettingItem(@"购买的表情");
    TLSettingGroup *group2 = TLCreateSettingGroup(nil, nil, (@[userEmojis, buyedEmojis]));
    [data addObject:group2];
    
    return data;
}
- (TLEmojiGroup *)defaultFaceGroup{
    if (_defaultFaceGroup == nil) {
        _defaultFaceGroup = [[TLEmojiGroup alloc] init];
        _defaultFaceGroup.type = TLEmojiTypeFace;
        _defaultFaceGroup.groupIconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FaceEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultFaceGroup.data = [TLEmoji mj_objectArrayWithKeyValuesArray:data];
    }
    return _defaultFaceGroup;
}
- (TLEmojiGroup *)defaultSystemEmojiGroup{
    if (_defaultSystemEmojiGroup == nil) {
        _defaultSystemEmojiGroup = [[TLEmojiGroup alloc] init];
        _defaultSystemEmojiGroup.type = TLEmojiTypeEmoji;
        _defaultSystemEmojiGroup.groupIconPath = @"emojiKB_group_face";
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SystemEmoji" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _defaultSystemEmojiGroup.data = [TLEmoji mj_objectArrayWithKeyValuesArray:data];
    }
    return _defaultSystemEmojiGroup;
}
- (void)requestExpressionChosenListByPageIndex:(NSInteger)pageIndex
                                       success:(void (^)(id data))success
                                       failure:(void (^)(NSString *error))failure{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_NEW_URL, (long)pageIndex];
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [TLEmojiGroup mj_objectArrayWithKeyValuesArray:infoArray];
            success(data);
        }else{
            failure(status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error description]);
    }];
}
- (void)requestExpressionChosenBannerSuccess:(void (^)(id))success
                                     failure:(void (^)(NSString *))failure{
    NSString *urlString = IEXPRESSION_BANNER_URL;
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [TLEmojiGroup mj_objectArrayWithKeyValuesArray:infoArray];
            success(data);
        }else{
            failure(status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error description]);
    }];
}
- (void)requestExpressionPublicListByPageIndex:(NSInteger)pageIndex
                                       success:(void (^)(id data))success
                                       failure:(void (^)(NSString *error))failure{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_PUBLIC_URL, (long)pageIndex];
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [TLEmojiGroup mj_objectArrayWithKeyValuesArray:infoArray];
            success(data);
        }else{
            failure(status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error description]);
    }];
}
- (void)requestExpressionSearchByKeyword:(NSString *)keyword
                                 success:(void (^)(id data))success
                                 failure:(void (^)(NSString *error))failure{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_SEARCH_URL, [[keyword urlEncode] urlEncode]];
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [TLEmojiGroup mj_objectArrayWithKeyValuesArray:infoArray];
            success(data);
        }else{
            failure(status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error description]);
    }];
}
- (void)requestExpressionGroupDetailByGroupID:(NSString *)groupID
                                    pageIndex:(NSInteger)pageIndex
                                      success:(void (^)(id data))success
                                      failure:(void (^)(NSString *error))failure{
    NSString *urlString = [NSString stringWithFormat:IEXPRESSION_DETAIL_URL, (long)pageIndex, groupID];
    [NetBase POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *respArray = [responseObject mj_JSONObject];
        NSString *status = respArray[0];
        if ([status isEqualToString:@"OK"]) {
            NSArray *infoArray = respArray[2];
            NSMutableArray *data = [TLEmoji mj_objectArrayWithKeyValuesArray:infoArray];
            success(data);
        }else{
            failure(status);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([error description]);
    }];
}
@end
