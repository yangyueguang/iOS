//  TLExpressionChosenViewController.h
//  Freedom
//  Created by Super on 16/4/4.
#import "TLTableViewController.h"
#import "TLExpressionHelper.h"
#define         HEIGHT_BANNERCELL       140.0f
#define         HEGIHT_EXPCELL          80.0f
#import "TLEmojiBaseCell.h"
#import "TLTableViewCell.h"
@protocol TLExpressionCellDelegate <NSObject>
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group;
@end
@interface TLExpressionCell : TLTableViewCell
@property (nonatomic, assign) id<TLExpressionCellDelegate> delegate;
@property (nonatomic, strong) TLEmojiGroup *group;
@end
@protocol TLExpressionBannerCellDelegate <NSObject>
- (void)expressionBannerCellDidSelectBanner:(id)item;
@end
@interface TLExpressionBannerCell : TLTableViewCell
@property (nonatomic, assign) id<TLExpressionBannerCellDelegate>delegate;
@property (nonatomic, strong) NSArray *data;
@end
@interface TLExpressionChosenViewController : TLTableViewController<TLExpressionCellDelegate, TLExpressionBannerCellDelegate>{
    NSInteger kPageIndex;
}
- (void)registerCellsForTableView:(UITableView *)tableView;
- (void)loadDataWithLoadingView:(BOOL)showLoadingView;
- (void)loadMoreData;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSArray *bannerData;
@property (nonatomic, strong) TLExpressionHelper *proxy;
@end
