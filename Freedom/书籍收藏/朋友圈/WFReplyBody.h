//  WFMessageBody.h
//  WFCoretext
//  Created by Super on 15/4/28.
#import <Foundation/Foundation.h>
@interface WFReplyBody : NSObject
/*评论者*/
@property (nonatomic,copy) NSString *replyUser;
/*回复该评论者的人*/
@property (nonatomic,copy) NSString *repliedUser;
/*回复内容*/
@property (nonatomic,copy) NSString *replyInfo;
@end
