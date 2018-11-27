//  TLExpressionChosenViewController.h
//  Freedom
//  Created by Super on 16/4/4.
#import "WXTableViewController.h"
#import "WXExpressionHelper.h"
#import "TLEmojiBaseCell.h"
#import "WXTableViewCell.h"
@protocol WXExpressionCellDelegate <NSObject>
- (void)expressionCellDownloadButtonDown:(TLEmojiGroup *)group;
@end
@interface WXExpressionCell : WXTableViewCell
@property (nonatomic, assign) id<WXExpressionCellDelegate> delegate;
@property (nonatomic, strong) TLEmojiGroup *group;
@end
@protocol WXExpressionBannerCellDelegate <NSObject>
- (void)expressionBannerCellDidSelectBanner:(id)item;
@end
@interface WXExpressionBannerCell : WXTableViewCell
@property (nonatomic, assign) id<WXExpressionBannerCellDelegate>delegate;
@property (nonatomic, strong) NSArray *data;
@end
@interface WXExpressionChosenViewController : WXTableViewController<WXExpressionCellDelegate, WXExpressionBannerCellDelegate>{
    NSInteger kPageIndex;
}
- (void)registerCellsForTableView:(UITableView *)tableView;
- (void)loadDataWithLoadingView:(BOOL)showLoadingView;
- (void)loadMoreData;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSArray *bannerData;
@property (nonatomic, strong) WXExpressionHelper *proxy;
@end
