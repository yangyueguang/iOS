//  JFSubscribeCell.h
//  Freedom
//  Created by Freedom on 15/10/16.
#import <UIKit/UIKit.h>
@interface JFSubItemModel : NSObject
@property(nonatomic, strong) NSNumber *itemID;
@property(nonatomic, strong) NSString *formatTotalTime;
@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSNumber *totalTime;
@property(nonatomic, strong) NSNumber *pubDate;
@property(nonatomic, strong) NSString *playLink;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *userpic_220_220;
@property(nonatomic, strong) NSNumber *playNum;
@property(nonatomic, strong) NSString *bigPic;
@property(nonatomic, strong) NSNumber *limit;
@property(nonatomic, strong) NSString *picurl;
@property(nonatomic, strong) NSNumber *playtimes;
@property(nonatomic, strong) NSString *userpic;
@property(nonatomic, strong) NSString *formatPubDate;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSNumber *uid;
@end
@interface JFSubscribeModel : NSObject
@property(nonatomic, strong) NSNumber *video_count;
@property(nonatomic, strong) NSString *Description;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *channelized_type;
@property(nonatomic, strong) NSString *subed_count;
@property(nonatomic, strong) NSMutableArray *last_item;
@property(nonatomic, strong) NSString *podcast_user_id;
@property(nonatomic, strong) NSString *isVuser;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *avatar;
@end
@class JFSubscribeModel,JFSubscribeCell,JFSubItemModel;
@protocol JFSubscribeCellDelagate <NSObject>
-(void)didSelectSubscribeCell:(JFSubscribeCell *)subCell subItem:(JFSubItemModel *)subItem;
@end
@interface JFSubscribeCell : UITableViewCell
@property(nonatomic, strong)JFSubscribeModel *subscribeM;
@property(nonatomic, weak)id <JFSubscribeCellDelagate>delegate;
@end
