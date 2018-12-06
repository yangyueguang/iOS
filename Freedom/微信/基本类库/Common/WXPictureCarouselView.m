//  TLPictureCarouselView.m
//  Freedom
// Created by Super
#import "WXPictureCarouselView.h"
#import <BlocksKit/BlocksKit.h>
@interface WXPictureCarouselViewCell : UICollectionViewCell
@property (nonatomic, strong) id<WXPictureCarouselProtocol> model;
@end
@interface WXPictureCarouselViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation WXPictureCarouselViewCell
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        
        [self p_addMasonry];
    }
    return self;
}
- (void)setModel:(id<WXPictureCarouselProtocol>)model{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[model pictureURL]]];
}
#pragma mark - 
- (void)p_addMasonry{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}
#pragma mark - 
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
@interface WXPictureCarouselView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation WXPictureCarouselView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.timeInterval = DEFAULT_TIMEINTERVAL;
        [self addSubview:self.collectionView];
        
        [self p_addMasonry];
        
        [self.collectionView registerClass:[WXPictureCarouselViewCell class] forCellWithReuseIdentifier:@"TLPictureCarouselViewCell"];
    }
    return self;
}
- (void)setData:(NSArray *)data{
    _data = data;
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGPoint offset = CGPointMake(self.collectionView.frame.size.width * 1,self.collectionView.contentOffset.y);
        [self.collectionView setContentOffset:offset animated:NO];
        
        if (self.timer == nil && self.data.count > 1) {
            __weak typeof(self) weakSelf = self;
            self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:2.0 block:^(NSTimer *tm) {
                [weakSelf scrollToNextPage];
            } repeats:YES];
        }
    });
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count == 0 ? 0 : self.data.count + 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row == 0 ? self.data.count - 1 : (indexPath.row == self.data.count + 1 ? 0 : indexPath.row - 1);
    id<WXPictureCarouselProtocol> model = self.data[row];
    WXPictureCarouselViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLPictureCarouselViewCell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row == 0 ? self.data.count - 1 : (indexPath.row == self.data.count - 1 ? 0 : indexPath.row - 1);
    id<WXPictureCarouselProtocol> model = self.data[row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pictureCarouselView:didSelectItem:)]) {
        [self.delegate pictureCarouselView:self didSelectItem:model];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return collectionView.frame.size;
}
//MARK: UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.timer == nil && self.data.count > 1) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:2.0 block:^(NSTimer *tm) {
            [weakSelf scrollToNextPage];
        } repeats:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 轮播实现
    
    if (scrollView.contentOffset.x / scrollView.frame.size.width == 0) {
        CGPoint offset = CGPointMake(self.collectionView.frame.size.width * self.data.count,self.collectionView.contentOffset.y);
        [scrollView setContentOffset:offset animated:NO];
    }else if (scrollView.contentOffset.x / scrollView.frame.size.width == self.data.count + 1) {
        CGPoint offset = CGPointMake(self.collectionView.frame.size.width * 1,self.collectionView.contentOffset.y);
        [scrollView setContentOffset:offset animated:NO];
    }
}
#pragma mark - Event Response
- (void)scrollToNextPage{
    NSInteger nextPage;
    if (self.collectionView.contentOffset.x / self.collectionView.frame.size.width == self.data.count) {
        CGPoint offset = CGPointMake(self.collectionView.frame.size.width * 0,self.collectionView.contentOffset.y);
        [self.collectionView setContentOffset:offset animated:NO];
        nextPage = 1;
    }else {
        nextPage = self.collectionView.contentOffset.x / self.collectionView.frame.size.width + 1;
    }
    CGPoint offset = CGPointMake(self.collectionView.frame.size.width * nextPage,self.collectionView.contentOffset.y);
    [self.collectionView setContentOffset:offset animated:YES];
}
#pragma mark - 
- (void)p_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - 
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        [layout setSectionInset:UIEdgeInsetsZero];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
    }
    return _collectionView;
}
@end
