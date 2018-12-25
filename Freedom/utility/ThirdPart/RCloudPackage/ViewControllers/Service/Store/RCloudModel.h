//
//  RCloudModel.h
//  SealTalk
//  Created by Super on 7/5/18.
//  Copyright © 2018 RongCloud. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RCDChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RCUserInfo.h>
#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCGroup.h>
//本文件为了切换appkey测试用的，请应用开发者忽略关于本文件的信息。
#import <RongIMKit/RongIMKit.h>
#import "RCDSearchDataManager.h"

@interface RCDSearchResultModel : NSObject
@property(nonatomic, assign) RCConversationType conversationType;
@property(nonatomic, assign) RCDSearchType searchType;
@property(nonatomic, strong) NSString *targetId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *portraitUri;
@property(nonatomic, strong) NSString *otherInformation;
@property(nonatomic, assign) int count;
@property(nonatomic, copy) NSString *objectName;
@property(nonatomic, assign)long long time;
@end
@interface RCDSettingUserDefaults : NSObject
//设置appKey
+ (void)setRCAppKey:(NSString *)appKey;
//设置DemoServer
+ (void)setRCDemoServer:(NSString *)demoServer;
//设置NaviServer
+ (void)setRCNaviServer:(NSString *)naviServer;
//设置FileServer
+ (void)setRCFileServer:(NSString *)fileServer;
//获取appKey
+ (NSString *)getRCAppKey;
//获取DemoServer
+ (NSString *)getRCDemoServer;
//获取NaviServer
+ (NSString *)getRCNaviServer;
//获取FileServer
+ (NSString *)getRCFileServer;
@end
@interface RCDChatRoomInfo : NSObject
/** ID */
@property(nonatomic, strong) NSString *chatRoomId;
/** 名称 */
@property(nonatomic, strong) NSString *chatRoomName;
/** 头像 */
@property(nonatomic, strong) NSString *portrait;
/** 人数 */
@property(nonatomic, strong) NSString *number;
/** 最大人数 */
@property(nonatomic, strong) NSString *maxNumber;
/** 简介 */
@property(nonatomic, strong) NSString *introduce;
/** 类别 */
@property(nonatomic, strong) NSString *category;
/** 创建者Id */
//@property(nonatomic, strong) NSString* creatorId;
/** 创建日期 */
//@property(nonatomic, strong) NSString* creatorTime;
/** 是否加入 */
//@property(nonatomic, assign) bool  isJoin;
@end
@interface RCDGroupInfo : RCGroup <NSCoding>
/** 人数 */
@property(nonatomic, strong) NSString *number;
/** 最大人数 */
@property(nonatomic, strong) NSString *maxNumber;
/** 群简介 */
@property(nonatomic, strong) NSString *introduce;
/** 创建者Id */
@property(nonatomic, strong) NSString *creatorId;
/** 创建日期 */
@property(nonatomic, strong) NSString *creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL isJoin;
/** 是否解散 */
@property(nonatomic, strong) NSString *isDismiss;
@end
/*! Demo测试用的自定义消息类
 @discussion Demo测试用的自定义消息类，此消息会进行存储并计入未读消息数。*/
@interface RCDTestMessage : RCMessageContent <NSCoding>
/*! 测试消息的内容*/
@property(nonatomic, strong) NSString *content;
/*!测试消息的附加信息*/
@property(nonatomic, strong) NSString *extra;
/*! 初始化测试消息@param content 文本内容@return 测试消息对象*/
+ (instancetype)messageWithContent:(NSString *)content;
@end
@interface RCDUserInfo : RCUserInfo
/** 全拼*/
@property(nonatomic, strong) NSString *quanPin;
/** email*/
@property(nonatomic, strong) NSString *email;
/**status: 与好友的关系。下面是好友关系的对照表，上面数据得到的status 值是20，表示和这个用户已经是好友了。
 | 对自己的状态    |自己  | 好友 | 对好友的状态
 | 发出了好友邀请  | 10   | 11  | 收到了好友邀请
 | 发出了好友邀请  | 10   | 21  | 忽略了好友邀请
 | 已是好友       | 20   | 20  | 已是好友
 | 已是好友       | 20   | 30  | 删除了好友关系
 | 删除了好友关系  | 30   | 30  | 删除了好友关系*/
@property(nonatomic, strong) NSString *status;
@property(nonatomic, strong) NSString *updatedAt;
@property(nonatomic, strong) NSString *displayName;
@end
@interface RCDCustomerEmoticonTab : NSObject <RCEmoticonTabSource>
/*! 表情tab的标识符 @return 表情tab的标识符，请勿重复 */
@property(nonatomic, strong) NSString *identify;
/*! 表情tab的图标 @return 表情tab的图标 */
@property(nonatomic, strong) UIImage *image;
/*! 表情tab的页数 @return 表情tab的页数*/
@property(nonatomic, assign) int pageCount;
/*!表情tab的index页的表情View@return 表情tab的index页的表情View@discussion 返回的 view 大小必须等于 contentViewSize （宽度 = 屏幕宽度，高度 =186）*/
- (UIView *)loadEmoticonView:(NSString *)identify index:(int)index;
@end
@interface RCloudModel : NSObject
@end
