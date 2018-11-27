//  SDHomeViewController.m
//  GSD_ZHIFUBAO
#import "SDHomeViewController.h"
#import "UIView+SDExtension.h"
#import "SDAddItemViewController.h"
#import "AlipayTools.h"
#import "SDHomeGridViewListItemView.h"
#import "SDCycleScrollView.h"
#define kHomeGridViewPerRowItemCount 4
#define kHomeGridViewTopSectionRowCount 3
#import "SDScanViewController.h"
@class SDHomeGridView;
@protocol SDHomeGridViewDeleate <NSObject>
@optional
- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index;
- (void)homeGrideViewmoreItemButtonClicked:(SDHomeGridView *)gridView;
- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView;
@end
@interface SDHomeGridView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, weak) id<SDHomeGridViewDeleate> gridViewDelegate;
@property (nonatomic, strong) NSArray *gridModelsArray;
@property (nonatomic, strong) NSArray *scrollADImageURLStringsArray;
@end
@implementation SDHomeGridView{
    NSMutableArray *_itemsArray;
    NSMutableArray *_rowSeparatorsArray;
    NSMutableArray *_columnSeparatorsArray;
    BOOL _shouldAdjustedSeparators;
    CGPoint _lastPoint;
    UIButton *_placeholderButton;
    SDHomeGridViewListItemView *_currentPressedView;
    SDCycleScrollView *_cycleScrollADView;
    UIView *_cycleScrollADViewBackgroundView;
    UIButton *_moreItemButton;
    CGRect _currentPresssViewFrame;
}
- (void)scanButtonClicked{
    SDBasicViewContoller *desVc = [[SDScanViewController alloc] init];
    [[self getCurrentViewController].navigationController pushViewController:desVc animated:YES];
}
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        _itemsArray = [NSMutableArray array];
        _rowSeparatorsArray = [NSMutableArray array];
        _columnSeparatorsArray = [NSMutableArray array];
        _shouldAdjustedSeparators = NO;
        _placeholderButton = [[UIButton alloc] init];
#pragma mark 在这里设置最上面的那个扫描二维码
        UIView *header = [[UIView alloc] init];
        header.frame = CGRectMake(0, 0, APPW, 100);
        header.backgroundColor = [UIColor colorWithRed:(38 / 255.0) green:(42 / 255.0) blue:(59 / 255.0) alpha:1];
        UIButton *scan = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, header.sd_width * 0.5, header.sd_height)];
        [scan setImage:[UIImage imageNamed:Pscan_y] forState:UIControlStateNormal];
        [scan addTarget:self action:@selector(scanButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:scan];
        UIButton *pay = [[UIButton alloc] initWithFrame:CGRectMake(scan.sd_width, 0, header.sd_width * 0.5, header.sd_height)];
        [pay setImage:[UIImage imageNamed:@"home_pay"] forState:UIControlStateNormal];
        [header addSubview:pay];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(APPW/2, 0, 0.5, 100)];
        line.backgroundColor = whitecolor;
        [header addSubview:line];
        [self addSubview:header];
        
        UIView *cycleScrollADViewBackgroundView = [[UIView alloc] init];
        cycleScrollADViewBackgroundView.backgroundColor = [UIColor colorWithRed:(235 / 255.0) green:(235 / 255.0) blue:(235 / 255.0) alpha:1];
        [self addSubview:cycleScrollADViewBackgroundView];
        _cycleScrollADViewBackgroundView = cycleScrollADViewBackgroundView;
        
        SDCycleScrollView *cycleView = [[SDCycleScrollView alloc] init];
        cycleView.autoScrollTimeInterval = 2.0;
        [self addSubview:cycleView];
        _cycleScrollADView = cycleView;
    }
    return self;
}
#pragma mark - properties
/*
 *  暂时用scrollview实现，随后用collectionview优化性能*/
- (void)setGridModelsArray:(NSArray *)gridModelsArray{
    _gridModelsArray = gridModelsArray;
    [_itemsArray removeAllObjects];
    [_rowSeparatorsArray removeAllObjects];
    [_columnSeparatorsArray removeAllObjects];
    [gridModelsArray enumerateObjectsUsingBlock:^(SDHomeGridItemModel *model, NSUInteger idx, BOOL *stop) {
        SDHomeGridViewListItemView *item = [[SDHomeGridViewListItemView alloc] init];
        item.itemModel = model;
        __weak typeof(self) weakSelf = self;
        item.itemLongPressedOperationBlock = ^(UILongPressGestureRecognizer *longPressed){
            [weakSelf buttonLongPressed:longPressed];
        };
        item.iconViewClickedOperationBlock = ^(SDHomeGridViewListItemView *view){
            [weakSelf deleteView:view];
        };
        item.buttonClickedOperationBlock = ^(SDHomeGridViewListItemView *view){
            if (!_currentPressedView.hidenIcon && _currentPressedView) {
                _currentPressedView.hidenIcon = YES;
                return;
            }
            if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideView:selectItemAtIndex:)]) {
                [self.gridViewDelegate homeGrideView:self selectItemAtIndex:[_itemsArray indexOfObject:view]];
            }
        };
        [self addSubview:item];
        [_itemsArray addObject:item];
    }];
    UIButton *more = [[UIButton alloc] init];
    [more setImage:[UIImage imageNamed:@"tf_home_more"] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(moreItemButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:more];
    [_itemsArray addObject:more];
    _moreItemButton = more;
#pragma mark 设置中间分割线的位置
    long rowCount = [self rowCountWithItemsCount:gridModelsArray.count];
    UIColor *lineColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    for (int i = 0; i < (rowCount + 1); i++) {
        UIView *rowSeparator = [[UIView alloc] init];
        rowSeparator.backgroundColor = lineColor;
        [self addSubview:rowSeparator];
        [_rowSeparatorsArray addObject:rowSeparator];
    }
    for (int i = 0; i < (kHomeGridViewPerRowItemCount + 1); i++) {
        UIView *columnSeparator = [[UIView alloc] init];
        columnSeparator.backgroundColor = lineColor;
        [self addSubview:columnSeparator];
        [_columnSeparatorsArray addObject:columnSeparator];
    }
    _shouldAdjustedSeparators = YES;
    [self bringSubviewToFront:_cycleScrollADViewBackgroundView];
    [self bringSubviewToFront:_cycleScrollADView];
}
#pragma mark - actions
- (void)moreItemButtonClicked{
    if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideViewmoreItemButtonClicked:)]) {
        [self.gridViewDelegate homeGrideViewmoreItemButtonClicked:self];
    }
}
- (void)setScrollADImageURLStringsArray:(NSArray *)scrollADImageURLStringsArray{
    _scrollADImageURLStringsArray = scrollADImageURLStringsArray;
    _cycleScrollADView.imageURLStringsGroup = scrollADImageURLStringsArray;
}
- (NSInteger)rowCountWithItemsCount:(NSInteger)count{
    long rowCount = (count + kHomeGridViewPerRowItemCount - 1) / kHomeGridViewPerRowItemCount;
    rowCount = (rowCount < 4) ? 4 : ++rowCount;
    return rowCount;
}
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)longPressed{
    SDHomeGridViewListItemView *pressedView = (SDHomeGridViewListItemView *)longPressed.view;
    CGPoint point = [longPressed locationInView:self];
    if (longPressed.state == UIGestureRecognizerStateBegan) {
        _currentPressedView.hidenIcon = YES;
        _currentPressedView = pressedView;
        _currentPresssViewFrame = pressedView.frame;
        longPressed.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        pressedView.hidenIcon = NO;
        long index = [_itemsArray indexOfObject:longPressed.view];
        [_itemsArray  removeObject:longPressed.view];
        [_itemsArray  insertObject:_placeholderButton atIndex:index];
        _lastPoint = point;
        [self bringSubviewToFront:longPressed.view];
    }
    CGRect temp = longPressed.view.frame;
    temp.origin.x += point.x - _lastPoint.x;
    temp.origin.y += point.y - _lastPoint.y;
    longPressed.view.frame = temp;
    _lastPoint = point;
    [_itemsArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        if (button == _moreItemButton) return;
        if (CGRectContainsPoint(button.frame, point) && button != longPressed.view) {
            [_itemsArray removeObject:_placeholderButton];
            [_itemsArray insertObject:_placeholderButton atIndex:idx];
            *stop = YES;
            [UIView animateWithDuration:0.5 animations:^{
                [self setupSubViewsFrame];
            }];
        }
    }];
    if (longPressed.state == UIGestureRecognizerStateEnded) {
        long index = [_itemsArray indexOfObject:_placeholderButton];
        [_itemsArray removeObject:_placeholderButton];
        [_itemsArray insertObject:longPressed.view atIndex:index];
        [self sendSubviewToBack:longPressed.view];
        // 保存数据
        [self saveItemsSettingCache];
        [UIView animateWithDuration:0.4 animations:^{
            longPressed.view.transform = CGAffineTransformIdentity;
            [self setupSubViewsFrame];
        } completion:^(BOOL finished) {
            if (!CGRectEqualToRect(_currentPresssViewFrame, _currentPressedView.frame)) {
                _currentPressedView.hidenIcon = YES;
            }
        }];
    }
}
- (void)deleteView:(SDHomeGridViewListItemView *)view{
    [_itemsArray removeObject:view];
    [view removeFromSuperview];
    [self saveItemsSettingCache];
    [UIView animateWithDuration:0.4 animations:^{
        [self setupSubViewsFrame];
    }];
}
- (void)saveItemsSettingCache{
    NSMutableArray *tempItemsContainer = [NSMutableArray new];
    [_itemsArray enumerateObjectsUsingBlock:^(SDHomeGridViewListItemView *button, NSUInteger idx, BOOL *stop) {
        if ([button isKindOfClass:[SDHomeGridViewListItemView class]]) {
            [tempItemsContainer addObject:@{button.itemModel.title : button.itemModel.imageResString}];
        }
    }];
    [AlipayTools saveItemsArray:[tempItemsContainer copy]];
    if ([self.gridViewDelegate respondsToSelector:@selector(homeGrideViewDidChangeItems:)]) {
        [self.gridViewDelegate homeGrideViewDidChangeItems:self];
    }
}
- (void)setupSubViewsFrame{
    CGFloat itemW = self.sd_width / kHomeGridViewPerRowItemCount;
    CGFloat itemH = itemW * 1.1;
    [_itemsArray enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        long rowIndex = idx / kHomeGridViewPerRowItemCount;
        long columnIndex = idx % kHomeGridViewPerRowItemCount;
        CGFloat x = itemW * columnIndex;
        CGFloat y = 0;
        if (idx < kHomeGridViewPerRowItemCount * kHomeGridViewTopSectionRowCount) {
            y = itemH * rowIndex+100;
        } else {
            y = itemH * (rowIndex + 1);
        }
        item.frame = CGRectMake(x, y, itemW, itemH);
        if (idx == (_itemsArray.count - 1)) {
            self.contentSize = CGSizeMake(0, item.sd_height + item.sd_y);
        }
    }];
}
#pragma mark - life circles
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat itemW = self.sd_width / kHomeGridViewPerRowItemCount;
    CGFloat itemH = itemW * 1.1;
    [self setupSubViewsFrame];
    if (_shouldAdjustedSeparators) {
        [_rowSeparatorsArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            CGFloat w = self.sd_width;
            CGFloat h = 0.4;
            CGFloat x = 0;
            CGFloat y = idx * itemH+100;
            view.frame = CGRectMake(x, y, w, h);
        }];
        [_columnSeparatorsArray enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            CGFloat w = 0.4;
            CGFloat h = MAX(self.contentSize.height-100, self.sd_height-100);
            CGFloat x = idx * itemW;
            CGFloat y = 100;
            view.frame = CGRectMake(x, y, w, h);
        }];
        _shouldAdjustedSeparators = NO;
    }
    _cycleScrollADViewBackgroundView.frame = CGRectMake(0, itemH * kHomeGridViewTopSectionRowCount, self.sd_width, itemH);
    _cycleScrollADView.frame = CGRectMake(0, _cycleScrollADViewBackgroundView.sd_y + 10, self.sd_width, itemH - 10 * 2);
}
#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _currentPressedView.hidenIcon = YES;
}
@end
@interface SDHomeViewController () <SDHomeGridViewDeleate,UIScrollViewDelegate>
@property (nonatomic, weak) SDHomeGridView *mainView;
@property (nonatomic, strong) NSArray *dataArray;
@end
@implementation SDHomeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"支付宝";
    SDHomeGridView *mainView = [[SDHomeGridView alloc] init];
    mainView.gridViewDelegate = self;
    mainView.showsVerticalScrollIndicator = NO;
    [self setupDataArray];
    mainView.gridModelsArray = _dataArray;
    // 模拟轮播图数据源
    mainView.scrollADImageURLStringsArray = @[@"http://ww3.sinaimg.cn/bmiddle/9d857daagw1er7lgd1bg1j20ci08cdg3.jpg",
                                              @"http://ww4.sinaimg.cn/bmiddle/763cc1a7jw1esr747i13xj20dw09g0tj.jpg",
                                              @"http://ww4.sinaimg.cn/bmiddle/67307b53jw1esr4z8pimxj20c809675d.jpg"];
    [self.view addSubview:mainView];
    _mainView = mainView;
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat tabbarHeight = [[self.tabBarController tabBar] sd_height];
    _mainView.frame = CGRectMake(0, 0, self.view.sd_width, APPH-tabbarHeight);
}
- (void)setupDataArray{
    NSArray *itemsArray = [AlipayTools itemsArray];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *itemDict in itemsArray) {
        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
        model.destinationClass = [SDBasicViewContoller class];
        model.imageResString =[itemDict.allValues firstObject];
        model.title = [itemDict.allKeys firstObject];
        [temp addObject:model];
    }
    _dataArray = [temp copy];
}
#pragma mark - SDHomeGridViewDeleate
- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index{
    SDHomeGridItemModel *model = _dataArray[index];
    UIViewController *vc = [[model.destinationClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)homeGrideViewmoreItemButtonClicked:(SDHomeGridView *)gridView{
    SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
    addVc.title = @"添加更多";
    [self.navigationController pushViewController:addVc animated:YES];
}
- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView{
    [self setupDataArray];
}
@end
