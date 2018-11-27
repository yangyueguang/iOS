//  TLEmojiKeyboard.m
//  Freedom
//  Created by Super on 16/2/17.
#import "TLEmojiKeyboard.h"
static TLEmojiKeyboard *emojiKB;
@implementation TLEmojiKeyboard
+ (TLEmojiKeyboard *)keyboard{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        emojiKB = [[TLEmojiKeyboard alloc] init];
    });
    return emojiKB;
}
- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:RGBACOLOR(245.0, 245.0, 247.0, 1.0)];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self addSubview:self.groupControl];
        [self p_addMasonry];
        
        [self registerCellClass];
        [self addGusture];
    }
    return self;
}
- (void)setEmojiGroupData:(NSMutableArray *)emojiGroupData{
    [self.groupControl setEmojiGroupData:emojiGroupData];
}
#pragma mark - Public Methods -
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;{
    if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardWillShow:)]) {
        [_keyboardDelegate chatKeyboardWillShow:self];
    }
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(view);
        make.height.mas_equalTo(HEIGHT_CHAT_KEYBOARD);
        make.bottom.mas_equalTo(view).mas_offset(HEIGHT_CHAT_KEYBOARD);
    }];
    [view layoutIfNeeded];
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(view);
            }];
            [view layoutIfNeeded];
            if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboard:didChangeHeight:)]) {
                [_keyboardDelegate chatKeyboard:self didChangeHeight:view.frameHeight - self.frameY];
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
    [self updateSendButtonStatus];
    if (_delegate && [_delegate respondsToSelector:@selector(emojiKeyboard:selectedEmojiGroupType:)]) {
        [_delegate emojiKeyboard:self selectedEmojiGroupType:self.curGroup.type];
    }
}
- (void)dismissWithAnimation:(BOOL)animation{
    if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboardWillDismiss:)]) {
        [_keyboardDelegate chatKeyboardWillDismiss:self];
    }
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.superview).mas_offset(HEIGHT_CHAT_KEYBOARD);
            }];
            [self.superview layoutIfNeeded];
            if (_keyboardDelegate && [_keyboardDelegate respondsToSelector:@selector(chatKeyboard:didChangeHeight:)]) {
                [_keyboardDelegate chatKeyboard:self didChangeHeight:self.superview.frameHeight - self.frameY];
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
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.frameWidth, self.collectionView.frameHeight) animated:NO];
    // 更新发送按钮状态
    [self updateSendButtonStatus];
}
#pragma mark - Event Response -
- (void) pageControlChanged:(UIPageControl *)pageControl{
    [self.collectionView scrollRectToVisible:CGRectMake(WIDTH_SCREEN * pageControl.currentPage, 0, WIDTH_SCREEN, HEIGHT_PAGECONTROL) animated:YES];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(HEIGHT_TOP_SPACE);
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(HEIGHT_EMOJIVIEW);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.groupControl.mas_top);
        make.height.mas_equalTo(HEIGHT_PAGECONTROL);
    }];
    [self.groupControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self);
        make.height.mas_equalTo(HEIGHT_GROUPCONTROL);
    }];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    // 顶部直线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, colorGrayLine.CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, WIDTH_SCREEN, 0);
    CGContextStrokePath(context);
}
#pragma mark - Getter -
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
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
        _pageControl.center = CGPointMake(self.center.x, _pageControl.center.y);
        [_pageControl setPageIndicatorTintColor:colorGrayLine];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
- (TLEmojiGroupControl *)groupControl{
    if (_groupControl == nil) {
        _groupControl = [[TLEmojiGroupControl alloc] init];
        [_groupControl setDelegate:self];
    }
    return _groupControl;
}
#pragma mark - Public Methods -
- (void)registerCellClass{
    [self.collectionView registerClass:[TLEmojiItemCell class] forCellWithReuseIdentifier:@"TLEmojiItemCell"];
    [self.collectionView registerClass:[TLEmojiFaceItemCell class] forCellWithReuseIdentifier:@"TLEmojiFaceItemCell"];
    [self.collectionView registerClass:[TLEmojiImageItemCell class] forCellWithReuseIdentifier:@"TLEmojiImageItemCell"];
    [self.collectionView registerClass:[TLEmojiImageTitleItemCell class] forCellWithReuseIdentifier:@"TLEmojiImageTitleItemCell"];
}
/*转换index
 *
 *  @param index collectionView中的Index
 *
 *  @return model中的Index*/
- (NSUInteger)transformModelIndex:(NSInteger)index{
    NSUInteger page = index / self.curGroup.pageItemCount;
    index = index % self.curGroup.pageItemCount;
    NSUInteger x = index / self.curGroup.rowNumber;
    NSUInteger y = index % self.curGroup.rowNumber;
    return self.curGroup.colNumber * y + x + page * self.curGroup.pageItemCount;
}
- (NSUInteger)transformCellIndex:(NSInteger)index{
    NSUInteger page = index / self.curGroup.pageItemCount;
    index = index % self.curGroup.pageItemCount;
    NSUInteger x = index / self.curGroup.colNumber;
    NSUInteger y = index % self.curGroup.colNumber;
    return self.curGroup.rowNumber * y + x + page * self.curGroup.pageItemCount;
}
#pragma mark - Delegate -
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.curGroup.pageNumber;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.curGroup.pageItemCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.section * self.curGroup.pageItemCount + indexPath.row;
    TLEmojiBaseCell *cell;
    if (self.curGroup.type == TLEmojiTypeEmoji) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiItemCell" forIndexPath:indexPath];
    }else if (self.curGroup.type == TLEmojiTypeFace) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiFaceItemCell" forIndexPath:indexPath];
    }else if (self.curGroup.type == TLEmojiTypeImageWithTitle) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiImageTitleItemCell" forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TLEmojiImageItemCell" forIndexPath:indexPath];
    }
    NSUInteger tIndex = [self transformModelIndex:index];  // 矩阵坐标转置
    TLEmoji *emojiItem = self.curGroup.count > tIndex ? [self.curGroup objectAtIndex:tIndex] : nil;
    [cell setEmojiItem:emojiItem];
    return cell;
}
#pragma mark - Public Methods -
- (void)resetCollectionSize{
    float cellHeight;
    float cellWidth;
    float topSpace = 0;
    float btmSpace = 0;
    float hfSpace = 0;
    if (self.curGroup.type == TLEmojiTypeFace || self.curGroup.type == TLEmojiTypeEmoji) {
        cellWidth = cellHeight = (HEIGHT_EMOJIVIEW / self.curGroup.rowNumber) * 0.55;
        topSpace = 11;
        btmSpace = 19;
        hfSpace = (WIDTH_SCREEN - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber + 1) * 1.4;
    }else if (self.curGroup.type == TLEmojiTypeImageWithTitle){
        cellHeight = (HEIGHT_EMOJIVIEW / self.curGroup.rowNumber) * 0.96;
        cellWidth = cellHeight * 0.8;
        hfSpace = (WIDTH_SCREEN - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber + 1) * 1.2;
    }else{
        cellWidth = cellHeight = (HEIGHT_EMOJIVIEW / self.curGroup.rowNumber) * 0.72;
        topSpace = 8;
        btmSpace = 16;
        hfSpace = (WIDTH_SCREEN - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber + 1) * 1.2;
    }
    
    cellSize = CGSizeMake(cellWidth, cellHeight);
    headerReferenceSize = CGSizeMake(hfSpace, HEIGHT_EMOJIVIEW);
    footerReferenceSize = CGSizeMake(hfSpace, HEIGHT_EMOJIVIEW);
    minimumLineSpacing = (WIDTH_SCREEN - hfSpace * 2 - cellWidth * self.curGroup.colNumber) / (self.curGroup.colNumber - 1);
    minimumInteritemSpacing = (HEIGHT_EMOJIVIEW - topSpace - btmSpace - cellHeight * self.curGroup.rowNumber) / (self.curGroup.rowNumber - 1);
    sectionInsets = UIEdgeInsetsMake(topSpace, 0, btmSpace, 0);
}
#pragma mark - Delegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.pageControl setCurrentPage:(int)(scrollView.contentOffset.x / WIDTH_SCREEN)];
}
//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger index = indexPath.section * self.curGroup.pageItemCount + indexPath.row;
    NSUInteger tIndex = [self transformModelIndex:index];  // 矩阵坐标转置
    if (tIndex < self.curGroup.count) {
        TLEmoji *item = [self.curGroup objectAtIndex:tIndex];
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:didSelectedEmojiItem:)]) {
            //FIXME: 表情类型
            item.type = self.curGroup.type;
            [self.delegate emojiKeyboard:self didSelectedEmojiItem:item];
        }
    }
    [self updateSendButtonStatus];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return cellSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return headerReferenceSize;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return footerReferenceSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return minimumLineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return minimumInteritemSpacing;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return sectionInsets;
}
#pragma mark - Public Methods -
- (void)updateSendButtonStatus{
    if (self.curGroup.type == TLEmojiTypeEmoji || self.curGroup.type == TLEmojiTypeFace) {
        if ([self.delegate chatInputViewHasText]) {
            [self.groupControl setSendButtonStatus:TLGroupControlSendButtonStatusBlue];
        }else{
            [self.groupControl setSendButtonStatus:TLGroupControlSendButtonStatusGray];
        }
    }else{
        [self.groupControl setSendButtonStatus:TLGroupControlSendButtonStatusNone];
    }
}
#pragma mark - Delegate -
//MARK: TLEmojiGroupControlDelegate
- (void)emojiGroupControl:(TLEmojiGroupControl *)emojiGroupControl didSelectedGroup:(TLEmojiGroup *)group{
    // 显示Group表情
    self.curGroup = group;
    [self resetCollectionSize];
    [self.pageControl setNumberOfPages:group.pageNumber];
    [self.pageControl setCurrentPage:0];
    [self.collectionView reloadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.frameWidth, self.collectionView.frameHeight) animated:NO];
    // 更新发送按钮状态
    [self updateSendButtonStatus];
    // 更新chatBar的textView状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:selectedEmojiGroupType:)]) {
        [self.delegate emojiKeyboard:self selectedEmojiGroupType:group.type];
    }
}
- (void)emojiGroupControlEditMyEmojiButtonDown:(TLEmojiGroupControl *)emojiGroupControl{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardMyEmojiEditButtonDown)]) {
        [self.delegate emojiKeyboardMyEmojiEditButtonDown];
    }
}
- (void)emojiGroupControlEditButtonDown:(TLEmojiGroupControl *)emojiGroupControl{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardEmojiEditButtonDown)]) {
        [self.delegate emojiKeyboardEmojiEditButtonDown];
    }
}
- (void)emojiGroupControlSendButtonDown:(TLEmojiGroupControl *)emojiGroupControl{
    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardSendButtonDown)]) {
        [self.delegate emojiKeyboardSendButtonDown];
    }
    // 更新发送按钮状态
    [self updateSendButtonStatus];
}
#pragma mark - Public Methods
- (void)addGusture{
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPressGR];
}
#pragma mark - Event Response
static UICollectionViewCell *lastCell;
- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {        // 长按停止
        lastCell = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardCancelTouchEmojiItem:)]) {
            [self.delegate emojiKeyboardCancelTouchEmojiItem:self];
        }
    }else{
        CGPoint point = [sender locationInView:self.collectionView];
        
        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
            if (cell.frameX - minimumLineSpacing / 2.0 <= point.x && cell.frameY - minimumInteritemSpacing / 2.0 <= point.y && cell.frameX + cell.frameWidth + minimumLineSpacing / 2.0 >= point.x && cell.frameY + cell.frameHeight + minimumInteritemSpacing / 2.0 >= point.y) {
                if (lastCell == cell) {
                    return;
                }
                lastCell = cell;
                NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
                NSUInteger index = indexPath.section * self.curGroup.pageItemCount + indexPath.row;
                NSUInteger tIndex = [self transformModelIndex:index];  // 矩阵坐标转置
                if (tIndex >= self.curGroup.count) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardCancelTouchEmojiItem:)]) {
                        [self.delegate emojiKeyboardCancelTouchEmojiItem:self];
                    }
                    return;
                }
                TLEmoji *emoji = [self.curGroup objectAtIndex:tIndex];
                if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboard:didTouchEmojiItem:atRect:)]) {
                    emoji.type = self.curGroup.type;
                    CGRect rect = [cell frame];
                    rect.origin.x = rect.origin.x - self.frameWidth * (int)(rect.origin.x / self.frameWidth);
                    [self.delegate emojiKeyboard:self didTouchEmojiItem:emoji atRect:rect];
                }
                return;
            }
        }
        
        lastCell = nil;
        if (self.delegate && [self.delegate respondsToSelector:@selector(emojiKeyboardCancelTouchEmojiItem:)]) {
            [self.delegate emojiKeyboardCancelTouchEmojiItem:self];
        }
    }
}
@end
