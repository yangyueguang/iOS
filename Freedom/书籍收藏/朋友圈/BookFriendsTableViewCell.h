//  YMTableViewCell.h
//  WFCoretext
//  Created by Super on 14/10/28.
#import <UIKit/UIKit.h>
#import "BookFriendsMode.h"
@protocol cellDelegate <NSObject>
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex;
@end
@interface BookFriendsTableViewCell : UITableViewCell
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * ymTextArray;
@property (nonatomic,strong) NSMutableArray * ymFavourArray;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,assign) id<cellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) UIButton *replyBtn;
@property (nonatomic,strong) UIImageView *favourImage;//点赞的图
/*用户头像imageview*/
@property (nonatomic,strong) UIImageView *userHeaderImage;
/*用户昵称label*/
@property (nonatomic,strong) UILabel *userNameLbl;
/*用户简介label*/
@property (nonatomic,strong) UILabel *userIntroLbl;
- (void)setYMViewWith:(YMTextData *)ymData;
@end
