//  TLExpressionPublicViewController.m
//  Freedom
// Created by Super
#import "WXExpressionPublicViewController.h"
#import "WXExpressionSearchViewController.h"
#import "WXSearchController.h"
#import "WXExpressionDetailViewController.h"
#define         EDGE                20.0
#define         SPACE_CELL          EDGE
#define         WIDTH_CELL          ((APPW - EDGE * 2 - SPACE_CELL * 2.0) / 3.0)
#define         HEIGHT_CELL         (WIDTH_CELL + 20)
#import "WXExpressionHelper.h"
#import <UIKit/UIKit.h>
#import "TLEmojiBaseCell.h"
@interface WXExpressionPublicCell : UICollectionViewCell
@property (nonatomic, strong) TLEmojiGroup *group;
@end
@interface WXExpressionPublicCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation WXExpressionPublicCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)setGroup:(TLEmojiGroup *)group{
    _group = group;
    [self.titleLabel setText:group.groupName];
    UIImage *image = [UIImage imageNamed:group.groupIconPath];
    if (image) {
        [self.imageView setImage:image];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:group.groupIconURL] placeholderImage:[FreedomTools imageWithColor:[UIColor lightGrayColor]]];
    }
}
#pragma mark - Private Methods
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(7.0f);
        make.width.mas_lessThanOrEqualTo(self.contentView);
    }];
}
#pragma mark - Getter
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setUserInteractionEnabled:NO];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer setCornerRadius:5.0f];
        [_imageView.layer setBorderWidth:1];
        [_imageView.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    return _imageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _titleLabel;
}
@end
@interface WXExpressionPublicViewController () <UISearchBarDelegate>
@property (nonatomic, strong) WXSearchController *searchController;
@property (nonatomic, strong) WXExpressionSearchViewController *searchVC;
@property (nonatomic,strong) UICollectionView *collectionView;
@end
@implementation WXExpressionPublicViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGRect rect = CGRectMake(0, TopHeight + 20, APPW, APPH - TopHeight - 20);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setAlwaysBounceVertical:YES];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
//    [self.collectionView setTableHeaderView:self.searchController.searchBar];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [self.collectionView setMj_footer:footer];
    
    [self registerCellForCollectionView:self.collectionView];
    [self loadDataWithLoadingView:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
#pragma mark - Delegate
//MARK: UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}
#pragma mark - Getter
- (WXSearchController *)searchController{
    if (_searchController == nil) {
        _searchController = [[WXSearchController alloc] initWithSearchResultsController:self.searchVC];
        [_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"搜索表情"];
        [_searchController.searchBar setDelegate:self];
    }
    return _searchController;
}
- (WXExpressionSearchViewController *)searchVC{
    if (_searchVC == nil) {
        _searchVC = [[WXExpressionSearchViewController alloc] init];
    }
    return _searchVC;
}
- (WXExpressionHelper *)proxy{
    if (_proxy == nil) {
        _proxy = [WXExpressionHelper sharedHelper];
    }
    return _proxy;
}
- (void)registerCellForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[WXExpressionPublicCell class] forCellWithReuseIdentifier:@"TLExpressionPublicCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EmptyCell"];
}
#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count == 0 ? 1 : self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.data.count) {
        WXExpressionPublicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLExpressionPublicCell" forIndexPath:indexPath];
        TLEmojiGroup *emojiGroup = [self.data objectAtIndex:indexPath.row];
        [cell setGroup:emojiGroup];
        return cell;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyCell" forIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.data.count) {
        TLEmojiGroup *group = [self.data objectAtIndex:indexPath.row];
        WXExpressionDetailViewController *detailVC = [[WXExpressionDetailViewController alloc] init];
        [detailVC setGroup:group];
        [self.parentViewController setHidesBottomBarWhenPushed:YES];
        [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.data.count) {
        return CGSizeMake(WIDTH_CELL, HEIGHT_CELL);
    }
    return collectionView.bounds.size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.data.count == 0 ? 0 : SPACE_CELL;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.data.count == 0 ? 0 : SPACE_CELL;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.data.count == 0 ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(EDGE, EDGE, EDGE, EDGE);
}
- (void)loadDataWithLoadingView:(BOOL)showLoadingView{
    if (showLoadingView) {
        [SVProgressHUD show];
    }
    kPageIndex = 1;
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionPublicListByPageIndex:kPageIndex success:^(id data) {
        [SVProgressHUD dismiss];
        kPageIndex ++;
        weakSelf.data = [[NSMutableArray alloc] init];
        for (TLEmojiGroup *group in data) {     // 优先使用本地表情
            TLEmojiGroup *localEmojiGroup = [[WXExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
            if (localEmojiGroup) {
                [self.data addObject:localEmojiGroup];
            }else{
                [self.data addObject:group];
            }
        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)loadMoreData{
    __weak typeof(self) weakSelf = self;
    [self.proxy requestExpressionPublicListByPageIndex:kPageIndex success:^(NSMutableArray *data) {
        [SVProgressHUD dismiss];
        if (data.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshing];
            kPageIndex ++;
            for (TLEmojiGroup *group in data) {     // 优先使用本地表情
                TLEmojiGroup *localEmojiGroup = [[WXExpressionHelper sharedHelper] emojiGroupByID:group.groupID];
                if (localEmojiGroup) {
                    [self.data addObject:localEmojiGroup];
                }
                else {
                    [self.data addObject:group];
                }
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSString *error) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [SVProgressHUD dismiss];
    }];
}
@end
