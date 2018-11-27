//  TLExpressionPublicViewController.h
//  Freedom
// Created by Super
#import "WXBaseViewController.h"
#import "WXExpressionHelper.h"
@interface WXExpressionPublicViewController : WXBaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger kPageIndex;
}
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;
- (void)loadDataWithLoadingView:(BOOL)showLoadingView;
- (void)loadMoreData;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) WXExpressionHelper *proxy;
@end
