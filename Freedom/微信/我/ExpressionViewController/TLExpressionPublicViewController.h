//  TLExpressionPublicViewController.h
//  Freedom
// Created by Super
#import "TLViewController.h"
#import "TLExpressionHelper.h"
@interface TLExpressionPublicViewController : TLViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger kPageIndex;
}
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;
- (void)loadDataWithLoadingView:(BOOL)showLoadingView;
- (void)loadMoreData;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) TLExpressionHelper *proxy;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
