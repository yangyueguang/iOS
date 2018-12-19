//  TLMoreKeyboard.m
//  Freedom
//  Created by Super on 16/2/17.
#import "TLMoreKeyboard.h"
@implementation TLMoreKeyboardItem
+ (TLMoreKeyboardItem *)createByType:(TLMoreKeyboardItemType)type title:(NSString *)title imagePath:(NSString *)imagePath{
    TLMoreKeyboardItem *item = [[TLMoreKeyboardItem alloc] init];
    item.type = type;
    item.title = title;
    item.imagePath = imagePath;
    return item;
}
@end
@interface TLMoreKeyboardCell : UICollectionViewCell
@property (nonatomic, strong) TLMoreKeyboardItem *item;
@property (nonatomic, strong) void(^clickBlock)(TLMoreKeyboardItem *item);
@end
@interface TLMoreKeyboardCell()
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TLMoreKeyboardCell
- (id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconButton];
        [self.contentView addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}
- (void)setItem:(TLMoreKeyboardItem *)item{
    _item = item;
    if (item == nil) {
        [self.titleLabel setHidden:YES];
        [self.iconButton setHidden:YES];
        [self setUserInteractionEnabled:NO];
        return;
    }
    [self setUserInteractionEnabled:YES];
    [self.titleLabel setHidden:NO];
    [self.iconButton setHidden:NO];
    [self.titleLabel setText:item.title];
    [self.iconButton setImage:[UIImage imageNamed:item.imagePath] forState:UIControlStateNormal];
}
#pragma mark - Event Response -
- (void)iconButtonDown:(UIButton *)sender{
    self.clickBlock(self.item);
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.iconButton.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
}
#pragma mark - Getter -
- (UIButton *)iconButton{
    if (_iconButton == nil) {
        _iconButton = [[UIButton alloc] init];
        [_iconButton.layer setMasksToBounds:YES];
        [_iconButton.layer setCornerRadius:5.0f];
        [_iconButton.layer setBorderWidth:1];
        [_iconButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [_iconButton setBackgroundImage:[FreedomTools imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [_iconButton addTarget:self action:@selector(iconButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconButton;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}
@end
static TLMoreKeyboard *moreKB;
@implementation TLMoreKeyboard
+ (TLMoreKeyboard *)keyboard{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        moreKB = [[TLMoreKeyboard alloc] init];
    });
    return moreKB;
}
- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:UIColor(245.0, 245.0, 247.0, 1.0)];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self p_addMasonry];
        [self registerCellClass];
    }
    return self;
}
#pragma mark - Public Methods -
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;{
    if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardWillShow:)]) {
        [_keyboardDelegate chatKeyboardWillShow:self];
    }
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(view);
        make.height.mas_equalTo(215.0f);
        make.bottom.mas_equalTo(view).mas_offset(215.0f);
    }];
    [view layoutIfNeeded];
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(view);
            }];
            [view layoutIfNeeded];
            if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboard:didChangeHeight:)]) {
                [_keyboardDelegate chatKeyboard:self didChangeHeight:view.frame.size.height - self.frame.origin.y];
            }
        } completion:^(BOOL finished) {
            if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardDidShow:)]) {
                [_keyboardDelegate chatKeyboardDidShow:self];
            }
        }];
    }else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view);
        }];
        [view layoutIfNeeded];
        if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardDidShow:)]) {
            [_keyboardDelegate chatKeyboardDidShow:self];
        }
    }
}
- (void)dismissWithAnimation:(BOOL)animation{
    if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardWillDismiss:)]) {
        [_keyboardDelegate chatKeyboardWillDismiss:self];
    }
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.superview).mas_offset(215.0f);
            }];
            [self.superview layoutIfNeeded];
            if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboard:didChangeHeight:)]) {
                [_keyboardDelegate chatKeyboard:self didChangeHeight:self.superview.frame.size.height - self.frame.origin.y];
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardDidDismiss:)]) {
                [_keyboardDelegate chatKeyboardDidDismiss:self];
            }
        }];
    }else{
        [self removeFromSuperview];
        if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardDidDismiss:)]) {
            [_keyboardDelegate chatKeyboardDidDismiss:self];
        }
    }
}
- (void)reset{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:NO];
}
- (void)setChatMoreKeyboardData:(NSMutableArray *)chatMoreKeyboardData{
    _chatMoreKeyboardData = chatMoreKeyboardData;
    [self.collectionView reloadData];
    NSUInteger pageNumber = chatMoreKeyboardData.count / 8 + (chatMoreKeyboardData.count % 8 == 0 ? 0 : 1);
    [self.pageControl setNumberOfPages:pageNumber];
}
#pragma mark - Event Response -
- (void) pageControlChanged:(UIPageControl *)pageControl{
    [self.collectionView scrollRectToVisible:CGRectMake(self.collectionView.frame.size.width * pageControl.currentPage, 0, self.collectionView.frame.size.width, self.collectionView.frame.size.height) animated:YES];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(15);
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo((215.0f * 0.85 - 15));
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.bottom.mas_equalTo(self).mas_offset(-2);
    }];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, APPW, 0);
    CGContextStrokePath(context);
}
#pragma mark - Getter -
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        float h = (215.0f * 0.85 - 15) / 2 * 0.93;
        float spaceX = (APPW - 60 * 4) / 5;
        float spaceY = (215.0f * 0.85 - 15) - h * 2;
        [layout setItemSize:CGSizeMake(60, h)];
        [layout setMinimumInteritemSpacing:spaceY];
        [layout setMinimumLineSpacing:spaceX];
        [layout setHeaderReferenceSize:CGSizeMake(spaceX, (215.0f * 0.85 - 15))];
        [layout setFooterReferenceSize:CGSizeMake(spaceX, (215.0f * 0.85 - 15))];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    return _collectionView;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(self.center.x,_pageControl.center.y);
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.collectionView registerClass:[TLMoreKeyboardCell class] forCellWithReuseIdentifier:@"TLMoreKeyboardCell"];
}
#pragma mark - Delegate -
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.chatMoreKeyboardData.count / 8 + (self.chatMoreKeyboardData.count % 8 == 0 ? 0 : 1);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TLMoreKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLMoreKeyboardCell" forIndexPath:indexPath];
    NSUInteger index = indexPath.section * 8 + indexPath.row;
    NSUInteger tIndex = [self p_transformIndex:index];  // 矩阵坐标转置
    if (tIndex >= self.chatMoreKeyboardData.count) {
        [cell setItem:nil];
    }else{
        [cell setItem:self.chatMoreKeyboardData[tIndex]];
    }
    __weak typeof(self) weakSelf = self;
    [cell setClickBlock:^(TLMoreKeyboardItem *sItem) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreKeyboard:didSelectedFunctionItem:)]) {
            [self.delegate moreKeyboard:weakSelf didSelectedFunctionItem:sItem];
        }
    }];
    return cell;
}
//Mark: UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.pageControl setCurrentPage:(int)(scrollView.contentOffset.x / APPW)];
}
#pragma mark - Private Methods -
- (NSUInteger)p_transformIndex:(NSUInteger)index{
    NSUInteger page = index / 8;
    index = index % 8;
    NSUInteger x = index / 2;
    NSUInteger y = index % 2;
    return 4 * y + x + page * 8;
}
@end
