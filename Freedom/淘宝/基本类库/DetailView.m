//  DetailView.m
//  DW
//  Created by boguang on 15/6/23.
#import "DetailView.h"
#include <objc/runtime.h>
#define kMinZoomScale 1.0f
#define kMaxZoomScale 2.5f
typedef NS_ENUM(NSInteger, DetailRefreshState) {
    DetailRefreshStateNormal,
    DetailRefreshStateLoading,
    DetailRefreshStateTriggerd
};
typedef NS_ENUM(NSInteger, DetailRefreshViewAnimateType) {
    DetailRefreshViewAnimateTypeAttachTop,          //吸顶, 默认值
    DetailRefreshViewAnimateTypeAttachBottom,       //跟随底部
    DetailRefreshViewAnimateTypeSpeed1,             //差速，速度是底部的1/3速度；难于滑动
    DetailRefreshViewAnimateTypeSpeed2,             //差速，是底部的1/2速度；易于滑动
};
@implementation MFullScreenView
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollview];
    }
    return self;
}
- (UIScrollView *) scrollview {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _scrollView.frame =[[UIScreen mainScreen] bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.imageView];
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
    }
    return _scrollView;
}
- (UIImageView *) imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _imageView.userInteractionEnabled = YES;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}
- (UITapGestureRecognizer *) doubleTap {
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}
- (UITapGestureRecognizer *) singleTap {
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}
- (void) onDoubleTap:(UITapGestureRecognizer *)recognizer {
    if (!self.isDoubleTapEnabled) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES];
    }
}
- (void) onSingleTap:(UITapGestureRecognizer *)recognizer {
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}
- (void) enableDoubleTap:(BOOL)isDoubleTapEnabled {
    _isDoubleTapEnabled = isDoubleTapEnabled;
    if (_isDoubleTapEnabled) {
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
    }
}
- (void) layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    [self adjustFrame];
}
- (void) adjustFrame {
    CGRect frame = self.scrollview.frame;
    if (self.imageView.image) {
        self.imageView.frame = [self.imageView.image getRectWithSize:[[UIScreen mainScreen] bounds].size];
        self.scrollview.contentSize = self.imageView.frame.size;
        self.imageView.center = [self centerOfScrollViewContent:self.scrollview];
        
        CGSize imageSize = self.imageView.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (frame.size.width<=frame.size.height) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        }
        CGFloat maxHeightScale = frame.size.height/imageFrame.size.height;
        if (maxHeightScale < 1.0f) {
            maxHeightScale = 1.0f / maxHeightScale;
        }
        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = MAX(kMaxZoomScale, maxHeightScale);
        [self.scrollview setZoomScale:1.0 animated:YES];
    } else {
        frame.origin = CGPointZero;
        self.imageView.frame = frame;
        self.scrollview.contentSize = self.imageView.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
}
- (void) reloadData {
    _scrollView.frame = self.bounds;
    [self adjustFrame];
}
#pragma mark ==
#pragma mark UIScrollViewDelegate
- (CGPoint) centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}
#pragma mark UIScrollViewDelegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self centerOfScrollViewContent:scrollView];
}
@end
@interface DetailRefreshView : UIView
@property (nonatomic, strong) UILabel               *bottomLabel;
@property (nonatomic, strong) UIImageView           *topImageView;
@property (nonatomic, assign) UIScrollView          *scrollView;
@property (nonatomic, assign) DetailRefreshState    state;
@property (nonatomic, assign) DetailRefreshViewAnimateType    animateType;
@property (nonatomic, copy)  void (^handler)(void);
@end
#pragma mark --
#pragma mark __DetailRefreshView
@interface UIScrollView(__DetailRefreshView)
@property (nonatomic, strong, readonly) DetailRefreshView *refreshView;
- (void) addDetailRefreshWithHandler:(void (^)(void)) handler;
@end
@interface DetailRefreshView()
@property (nonatomic, assign) CGFloat originalTopInset;
@property (nonatomic, assign) CGFloat thresHold;
@end
@implementation DetailRefreshView
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomLabel];
        self.thresHold = frame.size.height +  5;
        self.backgroundColor = [UIColor clearColor];
        self.animateType = DetailRefreshViewAnimateTypeAttachTop;
    }
    return self;
}
- (UILabel *) bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.bounds.size.width, 18)];
        _bottomLabel.font = [UIFont systemFontOfSize:12.0f];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.text = @"下拉，返回宝贝详情";
        _bottomLabel.backgroundColor = [UIColor clearColor];
    }
    return _bottomLabel;
}
- (UIImageView *) topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 25) / 2, 9, 22, 22)];
        _topImageView.backgroundColor = [UIColor clearColor];
        _topImageView.image = [UIImage imageNamed:@"detail_down_loading"];
    }
    return _topImageView;
}
- (void) didMoveToSuperview {
    if (!self.superview) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    } else {
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    self.originalTopInset = scrollView.contentInset.top;
    [self setState:DetailRefreshStateNormal];
}
#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
}
- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if (contentOffset.y > 0) {
        return;
    }
    CGFloat scrollOffsetThreshold = self.bottomLabel.bounds.size.height - self.thresHold  - self.scrollView.contentInset.top;
    if(!self.scrollView.isDragging && self.state == DetailRefreshStateLoading)
        self.state = DetailRefreshStateTriggerd;else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state != DetailRefreshStateLoading)
        self.state = DetailRefreshStateLoading;else if(contentOffset.y >= scrollOffsetThreshold && self.state != DetailRefreshStateNormal)
        self.state = DetailRefreshStateNormal;
    
    CGFloat offset = contentOffset.y + self.scrollView.contentInset.top;
    //    DLog(@"offset = %f | contentOffset= %f", offset, contentOffset.y);
    
    //move when cross the points
    if (offset <= -self.bounds.size.height && contentOffset.y <= -self.bounds.size.height) {
        switch (self.animateType) {
            case DetailRefreshViewAnimateTypeAttachTop:   //吸顶
                break;
            case DetailRefreshViewAnimateTypeAttachBottom:
                offset -= (offset + self.bounds.size.height) ; //开启，则跟随底部
                break;
            case DetailRefreshViewAnimateTypeSpeed1:
                offset -= (offset + self.bounds.size.height) /3.0f ; //开启，则速度是底部的1/3速度；差速
                break;
            case DetailRefreshViewAnimateTypeSpeed2:
                offset -= (offset + self.bounds.size.height) /2.0f ; //开启，则速度是底部的一半速度；差速
                break;
            default:      //吸顶
                break;
        }
    }
    self.frame = CGRectMake(0,offset - self.scrollView.contentInset.top + self.originalTopInset,
                            self.bounds.size.width, self.bounds.size.height);
    self.alpha = (offset < 0) ? (fabs(offset * 1.5f)/self.bounds.size.height) : 0;
}
- (void) setState:(DetailRefreshState)state {
    if (_state != state) {
        _state = state;
        __weak typeof(self) blockSelf = self;
        
        switch (_state) {
            case DetailRefreshStateTriggerd: {
                if (self.handler) {
                    self.handler();
                }
            }
                break;
            case DetailRefreshStateLoading: {
                _bottomLabel.text = @"释放，返回宝贝详情";
                [UIView animateWithDuration:0.2f animations:^{
                    [blockSelf.topImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];
            }
                
                break;
            case DetailRefreshStateNormal:{
                _bottomLabel.text = @"下拉，返回宝贝详情";
                [UIView animateWithDuration:0.2f animations:^{
                    [blockSelf.topImageView setTransform:CGAffineTransformIdentity];
                }];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
#pragma mark --
#pragma mark -- __DetailRefreshView
@implementation UIScrollView(__DetailRefreshView)
- (void)setRefreshView:(DetailRefreshView *)refreshView{
    objc_setAssociatedObject(self, @selector(refreshView), refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DetailRefreshView *) refreshView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void) addDetailRefreshWithHandler:(void (^)(void)) handler {
    if (!self.refreshView) {
        DetailRefreshView *detailRefreshView = [[DetailRefreshView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 64)];
        [self setRefreshView:detailRefreshView];
        self.refreshView.scrollView = self;
    }
    
    self.refreshView.handler = handler;
    [self addSubview:self.refreshView];
    [self sendSubviewToBack:self.refreshView];
}
@end
@interface UIScrollView (PageControl)
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
/*显示Page控件
 *
 *  @return
 **/
- (void) showPageControl;
/*根据当前的contentSize 及 frame.size.width,计算页数
 *
 *  @return
 **/
- (void) computePageControlPages;
@end
@interface DetailPageControl : UIPageControl
@end
@implementation DetailPageControl
- (void) setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    for (NSUInteger subViewIndex = 0 ; subViewIndex < [self.subviews count]; subViewIndex ++) {
        UIImageView *imageView = [self.subviews objectAtIndex:subViewIndex];
        CGRect rect = imageView.frame;
        rect.size.width = rect.size.height = 7.5f;
        imageView.layer.cornerRadius = 4.0f;
        imageView.layer.masksToBounds = YES;
        [imageView setFrame:rect];
    }
}
@end
#pragma mark --
#pragma mark UIScrollView (PageControl)
@implementation UIScrollView (PageControl)
- (UIPageControl *) pageControl {
    return  objc_getAssociatedObject(self, _cmd);
}
- (void) setPageControl:(UIPageControl *)pageControl {
    [self willChangeValueForKey:@"pageControl"];
    objc_setAssociatedObject(self, @selector(pageControl), pageControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"pageControl"];
}
- (void) showPageControl {
    if (!self.pageControl) {
        UIPageControl *control = [[DetailPageControl alloc]
                                  initWithFrame:CGRectMake(0, self.frame.origin.y + self.bounds.size.height - 40, self.bounds.size.width, 20)];
        control.backgroundColor = [UIColor clearColor];
        [control setEnabled:NO];
        control.pageIndicatorTintColor = [UIColor colorWithWhite:0.7 alpha:1];;
        control.currentPageIndicatorTintColor = [UIColor redColor];
        [self.superview addSubview:control];
        [self setPageControl:control];
    }
    [self.superview bringSubviewToFront:self.pageControl];
}
- (void) computePageControlPages {
    self.pageControl.numberOfPages = self.contentSize.width / self.frame.size.width;
    [self.pageControl setCurrentPage:(self.contentOffset.x + self.frame.size.width/2)/ self.frame.size.width];
}
@end
@implementation MFullScreenControl {
    BOOL _isGoingOut;
    CGRect _originRect;
}
- (void) dealloc {
    _screenPageView.delegate = nil;
    _screenPageView = nil;
}
- (UIView *) contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}
- (UIWindow *) screenWindow {
    if (!_screenWindow) {
        _screenWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _screenWindow;
}
- (UIImageView *) sourceImageView {
    if(!_sourceImageView) {
        _sourceImageView =  [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _sourceImageView;
}
- (UIScrollPageControlView *) screenPageView {
    if(!_screenPageView) {
        _screenPageView = [[UIScrollPageControlView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _screenPageView;
}
- (void) disAppearOnView:(UIView *) view {
    [self __imageViewHideTapAction:(UIView *) view];
}
- (void) appearOnView:(UIView *) view {
    self.isAppear = YES;
    self.fromView = (UIView *)view;;
    CGRect viewFrame = [_fromView.superview convertRect:_fromView.frame toView:self.screenWindow];
    [self.screenPageView.scrollView setContentOffset:CGPointMake([self.screenPageView itemWidth] * self.screenPageView.currentIndex, 0)];
    
    self.sourceImageView.frame = viewFrame;
    _originRect = viewFrame;
    [self.screenWindow addSubview:self.contentView];
    
    if ([view isKindOfClass:[UIImageView class]]) {
        self.sourceImageView.image = ((UIImageView *)_fromView).image;
    }
    self.sourceImageView.backgroundColor = _fromView.backgroundColor;
    self.sourceImageView.contentMode = _fromView.contentMode;
    self.sourceImageView.clipsToBounds = _fromView.clipsToBounds;
    
    [self.screenWindow addSubview:self.sourceImageView];
    [self.screenWindow makeKeyAndVisible];
    
    viewFrame = [_sourceImageView.image getRectWithSize:[[UIScreen mainScreen] bounds].size];
    _sourceImageView.alpha = 1.0f;
    [self.screenPageView reloadData];
    [UIView animateWithDuration:0.35f animations:^{
        _sourceImageView.frame = viewFrame;
        _contentView.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [_contentView addSubview:_screenPageView];
        [_sourceImageView removeFromSuperview];
    }];
}
- (void) __imageViewHideTapAction:(UIView *) view {
    self.isAppear = NO;
    if(_screenWindow && !_isGoingOut) {
        _isGoingOut = YES;
        if(view) {
            if ([view isKindOfClass:[UIImageView class]]) {
                _sourceImageView.image = ((UIImageView *)view).image;
            }else if([view isKindOfClass:[MFullScreenView class]]) {
                _sourceImageView.image = ((MFullScreenView *) view).imageView.image;
            }
            _sourceImageView.frame = [_sourceImageView.image getRectWithSize:[[UIScreen mainScreen] bounds].size];
            [_screenWindow addSubview:_sourceImageView];
            [_screenPageView removeFromSuperview];
        }
        
        [UIView animateWithDuration:view ? 0.35f : 0.0f animations:^{
            _contentView.backgroundColor = [UIColor clearColor];
            _sourceImageView.frame = _originRect;
            _sourceImageView.alpha = 0.85f;
        } completion:^(BOOL finished) {
            [_sourceImageView removeFromSuperview];
            [_screenPageView removeFromSuperview];
            [_contentView removeFromSuperview];
            [_screenWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_screenWindow removeFromSuperview];
            _screenWindow = nil;
            _isGoingOut = NO;
        }];
    }
}
@end
@class UIScrollPageControlView;
#pragma mark UIView(_reuseIdentifier)
@interface UIView(_reuseIdentifier)
@property (nonatomic, copy) NSString *reuseIdentifier;          //复用标识
@end
#pragma mark --
#pragma mark -- UIView(_reuseIdentifier)
static char UIViewReuseIdentifier;
@implementation UIView(_reuseIdentifier)
- (void) setReuseIdentifier:(NSString *)reuseIdentifier {
    objc_setAssociatedObject(self, &UIViewReuseIdentifier, reuseIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *) reuseIdentifier {
    return objc_getAssociatedObject(self, &UIViewReuseIdentifier);
}
@end
#pragma mark --
#pragma mark -- UIView(_reuseIdentifier)
@interface UIScrollPageControlView()
@property (nonatomic, assign) NSInteger                     reuseStartIndex;    //复用的起始值，一般为-_maxReuseCount/2
@property (nonatomic, strong) NSMutableDictionary           *reuseDictioary;    //复用的视图
@property (nonatomic, strong) NSMutableArray                *deletateViewArrays;//超出展示区域，需要删除以备复用的视图集
@end
@implementation UIScrollPageControlView {
    NSInteger   _maxReuseCount;
    NSInteger   _totalCount;
    CGSize      _contentSize;
    NSInteger   _oldIndex;
    CGFloat     _itemSpace;
}
@synthesize currentView = _currentView;
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _totalCount = 0;
        _maxReuseCount = 3;
        _currentIndex = 0;
        _oldIndex = -1;
        _contentSize = frame.size;
        _enablePageControl = YES;
        _reuseStartIndex = NSIntegerMin;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:self.scrollView];
    }
    return self;
}
- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    _contentSize = frame.size;
}
- (void) dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    _delegate = nil;
}
#pragma mark --
#pragma mark -- getter
- (NSMutableDictionary *) reuseDictioary {
    if (!_reuseDictioary) {
        _reuseDictioary = [NSMutableDictionary dictionaryWithCapacity:_maxReuseCount];
    }
    return _reuseDictioary;
}
- (NSMutableArray *) deletateViewArrays {
    if (!_deletateViewArrays) {
        _deletateViewArrays = [NSMutableArray array];
    }
    return _deletateViewArrays;
}
- (UIScrollView *) scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (void) setCurrentIndex:(NSInteger)currentIndex {
    @synchronized(self) {
        if (_currentIndex != currentIndex && (currentIndex - _totalCount) < 0) {
            
            [self willChangeValueForKey:@"currentIndex"];
            _oldIndex = _currentIndex;
            _currentIndex = currentIndex;
            [self didChangeValueForKey:@"currentIndex"];
            [self modifyCurrentIndex:(_currentIndex - _maxReuseCount / 2)];
            
            if (self.enablePageControl) {
                [self.scrollView.pageControl setCurrentPage:currentIndex];
            }
        }
    }
}
- (NSString *) keyAtIndex:(NSUInteger) index {
    for (NSString *key in [self.reuseDictioary allKeys]) {
        if (index == [self indexAtString:key]) {
            return key;
        }
    }
    return @"";
}
- (NSInteger) indexAtString:(NSString *) key {
    NSRange rang = [key rangeOfString:@"==bg==" options:NSBackwardsSearch];
    if (rang.location != NSNotFound) {
        NSInteger value = [[key substringFromIndex:rang.location +rang.length] integerValue];
        return value;
    }
    return NSNotFound;
}
- (void) setReuseStartIndex:(NSInteger)reuseStartIndex {
    
    @synchronized(self) {
        _reuseStartIndex = reuseStartIndex;
        NSInteger _minIndex = MAX(self.currentIndex - _maxReuseCount/2, 0);
        NSInteger _maxIndex = MIN(self.currentIndex + _maxReuseCount/2, _totalCount-1);
        
        NSMutableArray *addKeys = [NSMutableArray array];
        NSMutableArray *outData = [NSMutableArray array];
        
        //deal with add items
        for (NSInteger index = _minIndex; index <= _maxIndex; index++) {
            NSString *key = [self keyAtIndex:index];
            if ([key length] == 0) {
                [addKeys addObject:[NSString stringWithFormat:@"%@", @(index)]];
            }
        }
        
        //remove unused items
        for (NSString *key in [self.reuseDictioary allKeys]) {
            NSInteger value = [self indexAtString:key];
            if (!(value != NSNotFound && value >= _minIndex && value <= _maxIndex)) {
                [outData addObject:key];
                UIView *viewObject = [self.reuseDictioary valueForKey:key];
                [self.deletateViewArrays addObject:viewObject];
                [self.reuseDictioary removeObjectForKey:key];
            }
        }
        
        NSMutableDictionary *reuseDic = [self.reuseDictioary mutableCopy];
        
        //deal with new items
        for (NSString *key in addKeys) {
            [self __configItemAt:[key integerValue]];
        }
        
        
        //reconfig reuse items
        if (self.delegate && [self.delegate respondsToSelector:@selector(reconfigItemOfControl:at:withView:)]) {
            for (NSString *key in [reuseDic allKeys]) {
                UIView *view = [reuseDic valueForKey:key];
                NSInteger index = [self indexAtString:key];
                [self.delegate reconfigItemOfControl:self
                                                  at:index
                                            withView:view];
            }
        }
        [self computeCurrentView];
    }
}
- (void) computeCurrentView {
    UIView *currentViewWithIndex = [self.reuseDictioary objectForKey:[self keyAtIndex:self.currentIndex]];
    if (currentViewWithIndex) {
        self.currentView = currentViewWithIndex;
    }
}
- (void) setCurrentView:(UIView *)currentView {
    if (_currentView != currentView && currentView) {
        [self willChangeValueForKey:@"currentView"];
        _currentView = currentView;
        [self didChangeValueForKey:@"currentView"];
    }
}
- (void) modifyCurrentIndex:(NSInteger) value {
    NSInteger index = value;
    if (((index + _maxReuseCount/2) >= 0) && ((_totalCount - 1 - index) >=0) ) {
        self.reuseStartIndex = index;
    }
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"contentOffset" isEqualToString:keyPath]) {
        CGFloat contentOffsetX = self.scrollView.contentOffset.x;
        if (contentOffsetX >= 0 || contentOffsetX <= [self itemWidth] * (_totalCount - 1)) {
            self.currentIndex = (contentOffsetX  + [self itemWidth]/ 2) / [self itemWidth];
        }
    }
}
- (NSString *) reuseIdentifier:(NSString *) identifier index :(NSUInteger) index {
    return [NSString stringWithFormat:@"%@%@%@",identifier,@"==bg==", @(index)];
}
- (CGFloat) itemWidth {
    return (_contentSize.width + _itemSpace);
}
#pragma mark --
#pragma mark -- Action
- (void) __configItemAt:(NSUInteger) index {
    UIView *view = [self.delegate configItemOfControl:self at:index];
    CGRect viewFrame = view.frame;
    viewFrame.origin.x = index * _contentSize.width + (1 + index) * _itemSpace;
    viewFrame.origin.y = (_contentSize.height - viewFrame.size.height)/2.0f;
    view.frame = viewFrame;
    if (view.reuseIdentifier) {
        [self.reuseDictioary setObject:view forKey:[self reuseIdentifier:view.reuseIdentifier index:index]];
        view.userInteractionEnabled = YES;
        [self.scrollView addSubview:view];
    }
}
- (void) reloadData {
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reuseIdentifier length] > 0) {
            [obj removeFromSuperview];
        }
    }];
    [self.deletateViewArrays removeAllObjects];
    [self.reuseDictioary removeAllObjects];
    
    _totalCount = [self.delegate numberOfView:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(minimumRowSpacing:)]) {
        _itemSpace = [self.delegate minimumRowSpacing:self];
    }
    CGRect rect = CGRectMake(-_itemSpace, 0, _contentSize.width + 1 *_itemSpace, _contentSize.height);
    [self.scrollView setFrame:rect];
    [self.scrollView setContentSize:CGSizeMake(_totalCount * [self itemWidth]  + _itemSpace + 1, _contentSize.height)];
    if (self.enablePageControl) {
        [self.scrollView showPageControl];
        [self.scrollView.pageControl setNumberOfPages:_totalCount];
        [self.scrollView.pageControl setCurrentPage:_currentIndex];
    }
    _currentView = nil;
    [self setReuseStartIndex: -_maxReuseCount / 2 + _currentIndex];
}
- (UIView *) dequeueReusableViewWithIdentifier:(NSString *) identifier {
    if (!identifier || 0 == [identifier length]) {
        return nil;
    }
    for (UIView *view in self.deletateViewArrays) {
        if ([view.reuseIdentifier isEqualToString:identifier]) {
            [self.deletateViewArrays removeObject:view];
            return view;
        }
    }
    return nil;
}
@end
@implementation DetailTipView {
    UIView *_leftLine , *_rightLine;
    CGFloat layerWidth;
    CGFloat layerSpace;
}
- (id) initWithFrame:(CGRect)frame {
    layerSpace = 15.0f;
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1];
        label.text = @"继续拖动，查看图文详情";
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
        
        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        layerWidth = (self.bounds.size.width -  size.width - layerSpace * 4) / 2 ;
        [self addLeftRightLayer];
    }
    return self;
}
- (void) addLeftRightLayer {
    UIColor *lineColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:0.7f];
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(layerSpace, self.bounds.size.height/2 - 1, layerWidth, 1)];
    _leftLine.backgroundColor = lineColor;
    [self addSubview:_leftLine];
    
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - layerSpace - layerWidth), self.bounds.size.height/2 - 1, layerWidth, 1)];
    _rightLine.backgroundColor = lineColor;
    [self addSubview:_rightLine];
}
@end
typedef NS_ENUM(NSInteger, DetailPictureViewState) {
    DetailPictureViewStateNormal,
    DetailPictureViewStateLoading,
    DetailPictureViewStateTriggerd
};
typedef NS_ENUM(NSInteger, DetailPictureViewAnimateType) {
    DetailPictureViewAnimateTypeAttachRight,        //右边吸住，靠近边框, 默认值
    DetailPictureViewAnimateTypeAttachLeft,         //左边吸住，跟随变化
    DetailPictureViewAnimateTypeSpeed1,             //差速1
    DetailPictureViewAnimateTypeSpeed2,             //差速2
};
#pragma mark --
#pragma mark DetailPictureView
@interface DetailPictureView : UIView
@property (nonatomic, strong) UILabel               *rightLabel;
@property (nonatomic, strong) UIImageView           *leftImageView;
@property (nonatomic, assign) UIScrollView          *scrollView;
@property (nonatomic, assign) DetailPictureViewState state;
@property (nonatomic, assign) DetailPictureViewAnimateType animateType;
@property (nonatomic, copy)  void (^handler)(void);
@end
#pragma mark --
#pragma mark __DetailPictureView
@interface UIScrollView(__DetailPictureView)
@property (nonatomic, strong, readonly) DetailPictureView *pictureView;
- (void) addDetaiPictureViewWithHandler:(void (^)(void)) handler;
@end
#pragma mark --
#pragma mark --Parallas
@interface ParallasObject : NSObject
@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, weak) UIView          *targetView;
@property (nonatomic, assign) BOOL          isVertical;
@property (nonatomic, copy)  void (^handler)(void);
@end
#pragma mark --
#pragma mark --UIScrollView(__Parallas)
@interface UIScrollView(__Parallas)
@property (nonatomic, strong) ParallasObject *parallas;
- (void) addHorizeParallas:(UIView *) targetView block:(void (^)(void))block ;
- (void) addVerticalParallas:(UIView *) targetView block:(void (^)(void))block ;
@end
@interface DetailPictureView()
@property (nonatomic, assign) CGFloat originInsetY;
@property (nonatomic, assign) CGFloat thresHold;
@end
@implementation DetailPictureView
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightLabel];
        self.thresHold = self.rightLabel.frame.origin.x + self.rightLabel.frame.size.width;
        self.animateType = DetailPictureViewAnimateTypeAttachRight;
    }
    return self;
}
- (UILabel *) rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 18, self.bounds.size.height)];
        _rightLabel.font = [UIFont systemFontOfSize:12.0f];
        _rightLabel.numberOfLines = 0;
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.text = @"滑动，查看图文详情";
        _rightLabel.backgroundColor = [UIColor clearColor];
    }
    return _rightLabel;
}
- (UIImageView *) leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, (self.bounds.size.height - 25) / 2, 22, 22)];
        _leftImageView.backgroundColor = [UIColor clearColor];
        _leftImageView.image = [UIImage imageNamed:@"detail_left_loading"];
    }
    return _leftImageView;
}
- (void) didMoveToSuperview {
    if (!self.superview) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [_scrollView removeObserver:self forKeyPath:@"contentSize"];
    } else {
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    self.originInsetY = scrollView.contentInset.top;
    [self setState:DetailPictureViewStateNormal];
}
#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewDidScroll:self.scrollView.contentOffset];
    }
}
- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    CGFloat scrollOffsetThreshold = self.scrollView.contentSize.width + self.thresHold - self.scrollView.bounds.size.width;
    if(!self.scrollView.isDragging && self.state == DetailPictureViewStateLoading)
        self.state = DetailPictureViewStateTriggerd;else if(contentOffset.x > scrollOffsetThreshold && self.scrollView.isDragging && self.state != DetailPictureViewStateLoading)
        self.state = DetailPictureViewStateLoading;else if(contentOffset.x <= scrollOffsetThreshold && self.state != DetailPictureViewStateNormal)
        self.state = DetailPictureViewStateNormal;
    
    CGFloat offset = contentOffset.x + self.scrollView.contentInset.right + self.scrollView.bounds.size.width - self.scrollView.contentSize.width;
    
    //move when cross the points
    if (offset >= self.bounds.size.width) {
        switch (self.animateType) {
            case DetailPictureViewAnimateTypeAttachRight:
                offset = self.bounds.size.width;
                break;
            case DetailPictureViewAnimateTypeAttachLeft:
                break;
            case DetailPictureViewAnimateTypeSpeed1:
                offset += (self.bounds.size.width - offset)/2 ;
                break;
            case DetailPictureViewAnimateTypeSpeed2:
                offset += (self.bounds.size.width - offset)/4 ;
                break;
                
            default:
                break;
        }
    }
    
    self.frame = CGRectMake(contentOffset.x + self.scrollView.bounds.size.width - offset,0, self.bounds.size.width, self.bounds.size.height);
}
- (void) setState:(DetailPictureViewState)state {
    if (_state != state) {
        _state = state;
        switch (_state) {
            case DetailPictureViewStateTriggerd: {
                if (self.handler) {
                    self.handler();
                }
            }
                break;
            case DetailPictureViewStateLoading: {
                _rightLabel.text = @"释放，查看图文详情";
                [UIView animateWithDuration:0.2f animations:^{
                    [_leftImageView setTransform:CGAffineTransformMakeRotation(M_PI)];
                }];
            }
                
                break;
            case DetailPictureViewStateNormal:{
                _rightLabel.text = @"滑动，查看图文详情";
                
                [UIView animateWithDuration:0.2f animations:^{
                    [_leftImageView setTransform:CGAffineTransformIdentity];
                }];
            }
                break;
                
            default:
                break;
        }
    }
}
@end
#pragma mark --
#pragma mark -- UIScrollView(__DetailPictureView)
@implementation UIScrollView(__DetailPictureView)
- (void)setPictureView:(DetailPictureView *)pictureView {
    objc_setAssociatedObject(self, @selector(pictureView), pictureView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (DetailPictureView *) pictureView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void) addDetaiPictureViewWithHandler:(void (^)(void)) handler {
    if (!self.pictureView) {
        DetailPictureView *detailRefreshView = [[DetailPictureView alloc] initWithFrame:CGRectMake(0, self.bounds.size.width, 64, self.bounds.size.height)];
        [self setPictureView:detailRefreshView];
        detailRefreshView.scrollView = self;
    }
    
    self.pictureView.handler = handler;
    [self addSubview:self.pictureView];
    [self bringSubviewToFront:self.pictureView];
}
@end
#pragma mark --
#pragma mark --Paralles
@implementation ParallasObject
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"] && self.targetView ) {
        [self scrollViewDidVerticalScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
}
- (void)scrollViewDidVerticalScroll:(CGPoint)contentOffset {
    CGRect  targetFrame         = self.targetView.frame;
    UIEdgeInsets contentInsets  = self.scrollView.contentInset;
    if (self.isVertical) {
        CGFloat frameY = - targetFrame.size.height;
        CGFloat offset =  - contentOffset.y - contentInsets.top;
        //        if (offset< 0) {
        //        offset *= -2.0f;// -2.0f the imageview will stop at the top; 匀速  | remove offset charge ,then will adapter to all direction
        //        offset *= -3.0f;// -3.0f the imageview will stop at the top; 差速  | remove offset charge ,then will adapter to all direction
        //            offset *= -4.0f;// -4.0f the imageview will stop at the top; 吸顶 | remove offset charge ,then will adapter to all direction
        //        }
        targetFrame.origin.y = frameY + offset/4;
        _targetView.frame = targetFrame;
    }
}
- (void) dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
- (void) setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
@end
#pragma mark --
#pragma mark --UIScrollView(__Parallas)
@implementation UIScrollView(__Parallas)
- (void) setParallas:(ParallasObject *)parallas {
    objc_setAssociatedObject(self, @selector(parallas), parallas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ParallasObject *) parallas {
    return objc_getAssociatedObject(self, _cmd);
}
- (void) addHorizeParallas:(UIView *) targetView block:(void (^)(void))block {
    if (!self.parallas) {
        ParallasObject *object = [[ParallasObject alloc] init];
        object.targetView = targetView;
        object.scrollView = self;
        object.handler = block;
        object.isVertical = NO;
        [self setParallas:object];
    }
}
- (void) addVerticalParallas:(UIView *) targetView block:(void (^)(void))block {
    if (!self.parallas) {
        ParallasObject *object = [[ParallasObject alloc] init];
        object.targetView = targetView;
        object.scrollView = self;
        object.handler = block;
        object.isVertical = YES;
        [self setParallas:object];
    }
}
@end
static CGFloat animateTime  = 0.25f;
static CGFloat paddingSpace = 60.0f;
static CGFloat tipHeight    = 44.0f;
@interface DetailView ()
@property (nonatomic, strong) UIView                        *sectionView;
@property (nonatomic, strong) UIView                        *alphaView;
@property (nonatomic, strong) UIView                        *sectionLineView;
@property (nonatomic, assign) BOOL                          isTriggerd;
@property (nonatomic, assign) BOOL                          hidesForSingleTitle;    //中间的Section，是否对单个Ttitle的进行隐藏
@end
@implementation DetailView {
    __block CGFloat width, height, _middleHeight;
    NSInteger _currentIndex;
    NSUInteger _sectionTotal;
    __block NSTimeInterval  _timeInterval;
}
@synthesize topView             = _topView;
@synthesize bottomView          = _bottomView;
@synthesize tipView             = _tipView;
@synthesize fullScreencontrol   = _fullScreencontrol;
@synthesize topScrollPageView   = _topScrollPageView;
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = -1;
        _sectionTotal = 0;
        width = frame.size.width;
        height = frame.size.height;
        _middleHeight = 44.0f;
        _startYPosition = 0.0f;
        self.topScrollViewTopInset = 370.0f;
        self.hidesForSingleTitle = YES;
        _timeInterval = [[NSDate date] timeIntervalSince1970];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void) dealloc {
    _topScrollPageView.delegate = nil;
    _fullScreencontrol.screenPageView.delegate = nil;
    [_topScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [_topScrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (void) reloadData {
    self.isTriggerd = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(viewAtTop)]) {
        _sectionTotal = [_delegate numberOfSections];
        [self initTopScrollView];
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self configBottmSectionViews];
    }
    
    if (self.topScrollPageView.delegate) {
        [self configTopScrollView];
        [self.topScrollPageView reloadData];
    }
}
- (BOOL) isBottomViewShowed {
    if (_isTriggerd && self.topView.frame.origin.y >=0.0f) {
        return YES;
    }
    return NO;
}
- (void) disappearBottomView {
    if ([self isBottomViewShowed]) {
        [self hideBottomView];
    }
}
- (void) initTopScrollView {
    if (self.topScrollView) {
        return;
    }
    UIView *view = [self.delegate viewAtTop];
    if ([view isKindOfClass:[UIScrollView class]]) {
        self.topScrollView = (UIScrollView *)view;
    }else if ([view isKindOfClass:[UIWebView class]]) {
        self.topScrollView = ((UIWebView *) view).scrollView;
    }else {
        assert(0);
        DLog(@"scrollViewAtTop needs to be implemented");
        return;
    }
    
    [self.topScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    [self.topScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
    [self.topScrollView addSubview:self.tipView];
    [self.topScrollView setContentInset:UIEdgeInsetsMake(0, 0, tipHeight, 0)];
    [self.topView addSubview:view];
}
- (void) configTopScrollView {
    [self.topScrollView setContentInset:UIEdgeInsetsMake(_topScrollViewTopInset-20, 0, tipHeight, 0)];
//    [self.topScrollView addDetailRefreshWithHandler:nil];
    [self.topScrollView addVerticalParallas:self.topScrollPageView block:nil];
    [self.topScrollView addSubview:self.topScrollPageView];
//    [self.topScrollView addSubview:self.alphaView];   //add shadow effect
    [self.topScrollView sendSubviewToBack:self.topScrollPageView];
    [self.topScrollView setContentOffset:CGPointMake(0, 20-_topScrollViewTopInset)];
    __weak typeof(self) blockSelf = self;
    [self.imageScrollView addDetaiPictureViewWithHandler:^{
        [blockSelf addDetailPictureViewHandler];
    }];
}
- (void) addDetailPictureViewHandler {
    if (_sectionTotal == 0) {
        return ;
    }
    CGRect rect = self.bottomView.frame;
    rect.origin = CGPointMake(width, 0);
    [self.bottomView setFrame:rect];
    [self bringSubviewToFront:_bottomView];
    [self didFirstShowOnBottomView];
    self.isTriggerd = YES;
    [self animateContent];
    __weak typeof(self) blockSelf = self;
    [UIView animateWithDuration:animateTime animations:^{
        [blockSelf.bottomView setFrame:CGRectMake(0, 0, width, height)];
    } completion:^(BOOL finished) {
    }];
}
- (void)  hideBottomView {
    __weak typeof(self) blockSelf = self;
    self.isTriggerd = NO;
    [UIView animateWithDuration:animateTime animations:^{
        [blockSelf animateContent];
        [blockSelf.topView setFrame:CGRectMake(0, 0, width, height)];
        [blockSelf.bottomView setFrame:CGRectMake(0, height, width, height - _middleHeight - _startYPosition)];
    } completion:^(BOOL finished) {
        if(blockSelf.delegate && [blockSelf.delegate respondsToSelector:@selector(floatViewIsGoingTo:)]) {
            [blockSelf.delegate floatViewIsGoingTo:NO];
        }
    }];
}
- (void) configBottomView:(UIScrollView *) scrollView {
    __weak typeof(self) weakSelf = self;
    [scrollView addDetailRefreshWithHandler:^{
        [weakSelf hideBottomView];
    }];
}
- (void) configBottmSectionViews {
    [[[self bottomView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_delegate) {
        NSUInteger titleTotal = [_delegate numberOfSections];
        if (titleTotal == 0 || ![_delegate respondsToSelector:@selector(titleOfSectionAt:)]) {
            _middleHeight = 0.0f;
            return;
        }
        [[[self sectionView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat itemWidth = width/titleTotal;
        CGRect rect = self.sectionView.frame;
        if (titleTotal == 1 && self.hidesForSingleTitle ) {
            _middleHeight = 0.0f;
            rect.size.height = _middleHeight;
            self.sectionView.frame = rect;
        } else {
            _middleHeight = 44.0f;
            rect.origin.y = _startYPosition;
            rect.size.height = _middleHeight;
            self.sectionView.frame = rect;
            [_bottomView addSubview:self.sectionView];
            
            rect = self.sectionLineView.frame;
            rect.size.width = itemWidth;
            self.sectionLineView.frame = rect;
        }
        
        for (NSUInteger i = 0 ; i < titleTotal; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(itemWidth * i, 0, width/titleTotal, _middleHeight);
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:[_delegate titleOfSectionAt:i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            button.tag = 20140830 + i;
            [button addTarget:self action:@selector(sectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [[self sectionView] addSubview:button];
        }
        
        if (_middleHeight > 1.0f) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _middleHeight - 1, width, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            lineView.alpha = 0.5f;
            [[self sectionView] addSubview:lineView];
        }
        rect = self.bottomView.frame;
        float sectionHeight = _startYPosition;
        if (self.sectionView.superview) {
            sectionHeight = self.sectionView.frame.origin.y + self.sectionView.frame.size.height;
        }
        for (NSUInteger i = 0 ; i < titleTotal; i++) {
            UIView *view = nil;
            if ([_delegate respondsToSelector:@selector(viewOfSectionAt:)]) {
                view = [_delegate viewOfSectionAt:i];
                CGRect rect1 = CGRectMake(0, sectionHeight, width, height - sectionHeight);
                [view setFrame:rect1];
                [self configBottomView:[self firstScrollViewOfView:view]];
                view.tag = 20150830 + i;
                [self.bottomView addSubview:view];
            }
        }
        
    }
}
- (void) didFirstShowOnBottomView {
    if (!self.sectionLineView.superview) {
        [_sectionView addSubview:self.sectionLineView];
    }
    if (-1 == _currentIndex) {
        [self sectionButtonAction:[self.sectionView viewWithTag:20140830]];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(floatViewIsGoingTo:)]) {
        [_delegate floatViewIsGoingTo:YES];
    }
}
#pragma mark --
#pragma mark Getter & Setter
- (UIScrollPageControlView *) topScrollPageView {
    if (!_topScrollPageView) {
        _topScrollPageView = [[UIScrollPageControlView alloc] initWithFrame:CGRectMake(0, -_topScrollViewTopInset, width, _topScrollViewTopInset)];
        _topScrollPageView.scrollView.frame = CGRectMake(0, 10, width, _topScrollViewTopInset);
        _topScrollPageView.layer.masksToBounds = NO;
    }
    return _topScrollPageView;
}
- (MFullScreenControl *) fullScreencontrol {
    if (!_fullScreencontrol) {
        _fullScreencontrol = [[MFullScreenControl alloc] init];
        __weak typeof(self) blockSelf = self;
        [_fullScreencontrol.screenPageView.scrollView addDetaiPictureViewWithHandler:^{
            [blockSelf hideFullScreenOnView:nil];
            [blockSelf addDetailPictureViewHandler];
        }];
        _fullScreencontrol.screenPageView.scrollView.pictureView.rightLabel.textColor = [UIColor whiteColor];
        _fullScreencontrol.screenPageView.scrollView.pictureView.leftImageView.image = [UIImage imageNamed:@"detail_left_loading_white"];
    }
    return _fullScreencontrol;
}
- (UIView *) alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -2, width, 4)];
        _alphaView.backgroundColor     = [UIColor clearColor];
        _alphaView.layer.masksToBounds = NO;
        _alphaView.layer.shadowRadius  = 2.0f;
        _alphaView.layer.shadowOpacity = 0.25f;
        _alphaView.layer.shadowColor   = [[UIColor blackColor] CGColor];
        _alphaView.layer.shadowOffset  = CGSizeZero;
        _alphaView.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:CGRectMake(-4, 0, width+8, 4)] CGPath];
    }
    return _alphaView;
}
- (DetailTipView *) tipView {
    if (!_tipView) {
        _tipView = [[DetailTipView alloc] initWithFrame:CGRectMake(0, height, width, tipHeight)];
    }
    return _tipView;
}
- (UIView *) topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    }
    return _topView;
}
- (CGRect) bottomSectionFrame {
    return CGRectMake(0, _middleHeight, width, height - _middleHeight - _startYPosition);
}
- (UIView *) bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, height, width, height - _startYPosition)];
    }
    return _bottomView;
}
- (UIScrollView *) imageScrollView {
    return self.topScrollPageView.scrollView;
}
- (UIView *) sectionView {
    if (!_sectionView) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, _middleHeight)];
        _sectionView.backgroundColor = [UIColor whiteColor];
    }
    return _sectionView;
}
- (UIView *) sectionLineView {
    if (!_sectionLineView) {
        _sectionLineView = [[UIView alloc] initWithFrame:CGRectMake(width, _middleHeight - 2, width, 2)];
        _sectionLineView.backgroundColor = [UIColor redColor];
    }
    return _sectionLineView;
}
- (UIScrollView *) firstScrollViewOfView:(UIView *) rootView {
    if ([rootView isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)rootView;
    }else{
        __weak typeof(self) blockSelf = self;
        __block UIScrollView *scrollView = nil;
        [rootView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([blockSelf firstScrollViewOfView:obj]) {
                scrollView = obj;
                *stop = YES;
            }
        }];
        return scrollView;
    }
    return nil;
}
- (void) animateContent {
    float contentStartY = _startYPosition;
    if (fabsf(contentStartY) < 1) {
        return;
    }
    if (_sectionView.superview) {
        contentStartY = _sectionView.frame.origin.y + _sectionView.frame.size.height;
    }
    if (!_isTriggerd) {
        contentStartY -= _startYPosition;
    }
    for (NSUInteger i = 0, total = [self.delegate numberOfSections]; i < total; i++) {
        UIView *view = (UIView *) [self.bottomView viewWithTag:20150830 + i];
        CGRect rect  = CGRectMake(0, contentStartY, width, height - contentStartY);
        [view setFrame:rect];
    }
    
}
#pragma mark --
#pragma mark Action
- (void) showFullScreenOnView:(UIView *) view {
    [self.fullScreencontrol.screenPageView reloadData];
    self.fullScreencontrol.screenPageView.currentIndex = self.topScrollPageView.currentIndex;
    [self.fullScreencontrol appearOnView:view];
}
- (void) hideFullScreenOnView:(UIView *) view {
    [self.topScrollPageView.scrollView setContentOffset:CGPointMake(self.fullScreencontrol.screenPageView.currentIndex * [self.topScrollPageView itemWidth], 0)];
    [self.topScrollPageView reloadData];
    [self.fullScreencontrol disAppearOnView:view];
}
- (IBAction)sectionButtonAction:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    if (!button) {
        return;
    }
    __weak typeof(self) blockSelf = self;
    NSUInteger index = button.tag - 20140830;
    
    UIView *theSectionView = [self.bottomView viewWithTag:20150830 + index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(willChangeToSection:view:)]) {
        [self.delegate willChangeToSection:index view:theSectionView];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(canChangeToSection:)]) {
        if (![self.delegate canChangeToSection:index]) {
            return;
        }
    }
    for (NSUInteger i = 0 ; i < [self.delegate numberOfSections]; i++) {
        UIButton *buttonTmp = (UIButton *) [self.sectionView viewWithTag:20140830 + i];
        [buttonTmp setSelected:i == index];
    }
    if (button.isSelected) {
        CGRect rect = self.sectionLineView.frame;
        rect.origin.x = button.frame.size.width * index;
        [UIView animateWithDuration:animateTime animations:^{
            [blockSelf.sectionLineView setFrame:rect];
        } completion:nil];
    }
    for (NSUInteger i = 0 ; i < [self.delegate numberOfSections]; i++) {
        UIView *view = (UIView *) [self.bottomView viewWithTag:20150830 + i];
        [view setHidden:i != index];
    }
    _currentIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeToSection:view:)]) {
        [self.delegate didChangeToSection:index view:theSectionView];
    }
    
}
#pragma mark --
#pragma mark Observer
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self __scrollTipView:self.topScrollView];
    } else if ([@"contentOffset" isEqualToString:keyPath]) {
        [self __scrollAction:self.topScrollView];
    }
}
- (BOOL) __isNeedToAdjustTopScrollViewContentSize {
    CGFloat scrollSizeHeight = self.topScrollView.contentSize.height + self.topScrollView.contentInset.top + self.topScrollView.contentInset.bottom ;
    if (scrollSizeHeight  < height) {
        return YES;
    }
    return NO;
}
- (void) __adjustTopScrollViewContentSize {
    CGSize size = self.topScrollView.contentSize;
    size.height = height - (self.topScrollView.contentInset.top + self.topScrollView.contentInset.bottom);
    [self.topScrollView setContentSize:size];
}
- (void) __scrollTipView:(UIScrollView *)scrollView {
    if ([self __isNeedToAdjustTopScrollViewContentSize]) {
        [self __adjustTopScrollViewContentSize];
        return;
    }
    [self.tipView setFrame:CGRectMake(0, self.topScrollView.contentSize.height  , width, tipHeight)];
}
- (void)__scrollAction:(UIScrollView *)scrollView {
    if (scrollView == self.topScrollView && _sectionTotal > 0  && ![self __isNeedToAdjustTopScrollViewContentSize]) {
        CGSize contentSize          = scrollView.contentSize;
        CGPoint contentOffset       = scrollView.contentOffset;
        UIEdgeInsets contentInsets  = scrollView.contentInset;
        if (!_isTriggerd) {
            CGFloat startY =  (contentSize.height + contentInsets.bottom)  - (contentOffset.y + height);
            [self.bottomView setFrame:CGRectMake(0, startY + height, width, height)];
        }
        if (!scrollView.isDragging  && !_isTriggerd) {
            float value = self.topScrollView.contentOffset.y + height - self.topScrollView.contentSize.height;
            if (value > paddingSpace) {
                self.isTriggerd = YES;
                [self didFirstShowOnBottomView];
                __weak typeof(self) blockSelf = self;
                [UIView animateWithDuration:animateTime animations:^{
                    [blockSelf.bottomView setFrame:CGRectMake(0, 0, width, height)];
                    [blockSelf.topView setFrame:CGRectMake(0, -height, width, height)];
                    [blockSelf animateContent];
                } completion:nil];
            }
        }
    }
}
@end
