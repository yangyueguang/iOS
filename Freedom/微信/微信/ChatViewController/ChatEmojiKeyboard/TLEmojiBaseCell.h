//  TLEmojiBaseCell.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WXPictureCarouselView.h"
@interface TLEmoji : NSObject
@property (nonatomic, assign) TLEmojiType type;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *emojiID;
@property (nonatomic, strong) NSString *emojiName;
@property (nonatomic, strong) NSString *emojiPath;
@property (nonatomic, strong) NSString *emojiURL;
@property (nonatomic, assign) CGFloat size;
@end
typedef NS_ENUM(NSInteger, TLEmojiGroupStatus) {
    TLEmojiGroupStatusUnDownload,
    TLEmojiGroupStatusDownloaded,
    TLEmojiGroupStatusDownloading,
};
@interface TLEmojiGroup : NSObject<WXPictureCarouselProtocol>
@property (nonatomic, assign) TLEmojiType type;
/// 基本信息
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSString *groupIconPath;
@property (nonatomic, strong) NSString *groupIconURL;
/// Banner用
@property (nonatomic, strong) NSString *bannerID;
@property (nonatomic, strong) NSString *bannerURL;
/// 总数
@property (nonatomic, assign) NSUInteger count;
/// 详细信息
@property (nonatomic, strong) NSString *groupInfo;
@property (nonatomic, strong) NSString *groupDetailInfo;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) TLEmojiGroupStatus status;
/// 作者
@property (nonatomic, strong) NSString *authName;
@property (nonatomic, strong) NSString *authID;
#pragma mark - 本地信息
@property (nonatomic, strong) NSMutableArray *data;
#pragma mark - 展示用
/// 每页个数
@property (nonatomic, assign) NSUInteger pageItemCount;
/// 页数
@property (nonatomic, assign) NSUInteger pageNumber;
/// 行数
@property (nonatomic, assign) NSUInteger rowNumber;
/// 列数
@property (nonatomic, assign) NSUInteger colNumber;
- (id)objectAtIndex:(NSUInteger)index;
@end
///FIXME: CELL
@interface TLEmojiBaseCell : UICollectionViewCell
@property (nonatomic, strong) TLEmoji *emojiItem;
@property (nonatomic, strong) UIImageView *bgView;
/*选中时的背景图片，默认nil*/
@property (nonatomic, strong) UIImage *highlightImage;
@property (nonatomic, assign) BOOL showHighlightImage;
@end
@interface TLEmojiFaceItemCell : TLEmojiBaseCell
@end
@interface TLEmojiImageItemCell : TLEmojiBaseCell
@end
@interface TLEmojiImageTitleItemCell : TLEmojiBaseCell
@end
@interface TLEmojiItemCell : TLEmojiBaseCell
@end
@interface TLEmojiGroupCell : UICollectionViewCell
@property (nonatomic, strong) TLEmojiGroup *emojiGroup;
@end
typedef NS_ENUM(NSInteger, TLGroupControlSendButtonStatus) {
    TLGroupControlSendButtonStatusGray,
    TLGroupControlSendButtonStatusBlue,
    TLGroupControlSendButtonStatusNone,
};
@class TLEmojiGroupControl;
@protocol TLEmojiGroupControlDelegate <NSObject>
- (void)emojiGroupControl:(TLEmojiGroupControl*)emojiGroupControl didSelectedGroup:(TLEmojiGroup *)group;
- (void)emojiGroupControlEditButtonDown:(TLEmojiGroupControl *)emojiGroupControl;
- (void)emojiGroupControlEditMyEmojiButtonDown:(TLEmojiGroupControl *)emojiGroupControl;
- (void)emojiGroupControlSendButtonDown:(TLEmojiGroupControl *)emojiGroupControl;
@end
@interface TLEmojiGroupControl : UIView
@property (nonatomic, assign) TLGroupControlSendButtonStatus sendButtonStatus;
@property (nonatomic, strong) NSMutableArray *emojiGroupData;
@property (nonatomic, assign) id<TLEmojiGroupControlDelegate>delegate;
@end
