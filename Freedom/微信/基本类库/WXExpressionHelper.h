//  WXExpressionHelper.h
//  Freedom
// Created by Super
#import <Foundation/Foundation.h>
#import "WXModes.h"
#import "TLEmojiKeyboard.h"
@interface WXExpressionHelper : NSObject
/// 默认表情（Face）
@property (nonatomic, strong) TLEmojiGroup *defaultFaceGroup;
/// 默认系统Emoji
@property (nonatomic, strong) TLEmojiGroup *defaultSystemEmojiGroup;
/// 用户表情组
@property (nonatomic, strong) NSArray *userEmojiGroups;
/// 用户收藏的表情
@property (nonatomic, strong) TLEmojiGroup *userPreferEmojiGroup;
+ (WXExpressionHelper *)sharedHelper;
/*根据groupID获取表情包*/
- (TLEmojiGroup *)emojiGroupByID:(NSString *)groupID;
/*添加表情包*/
- (BOOL)addExpressionGroup:(TLEmojiGroup *)emojiGroup;
/*删除表情包*/
- (BOOL)deleteExpressionGroupByID:(NSString *)groupID;
/*表情包是否被其他用户使用
 *
 *  用来判断是否可删除表情包文件*/
- (BOOL)didExpressionGroupAlwaysInUsed:(NSString *)groupID;
#pragma mark - 下载表情包
- (void)downloadExpressionsWithGroupInfo:(TLEmojiGroup *)group
                                progress:(void (^)(CGFloat progress))progress
                                 success:(void (^)(TLEmojiGroup *group))success
                                 failure:(void (^)(TLEmojiGroup *group, NSString *error))failure;
#pragma mark - 列表用
/*列表数据 — 我的表情*/
- (NSMutableArray *)myExpressionListData;
///FIXME:以下是网络
/*精选表情*/
- (void)requestExpressionChosenListByPageIndex:(NSInteger)page
                                       success:(void (^)(id data))success
                                       failure:(void (^)(NSString *error))failure;
/*竞选表情Banner*/
- (void)requestExpressionChosenBannerSuccess:(void (^)(id data))success
                                     failure:(void (^)(NSString *error))failure;
/*网络表情*/
- (void)requestExpressionPublicListByPageIndex:(NSInteger)page
                                       success:(void (^)(id data))success
                                       failure:(void (^)(NSString *error))failure;
/*表情搜索*/
- (void)requestExpressionSearchByKeyword:(NSString *)keyword
                                 success:(void (^)(id data))success
                                 failure:(void (^)(NSString *error))failure;
/*表情详情*/
- (void)requestExpressionGroupDetailByGroupID:(NSString *)groupID
                                    pageIndex:(NSInteger)pageIndex
                                      success:(void (^)(id data))success
                                      failure:(void (^)(NSString *error))failure;
@end
