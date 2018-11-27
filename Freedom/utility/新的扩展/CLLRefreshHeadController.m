//
//  CLLRefreshHeadController.m
//  RefreshLoadView
#import "CLLRefreshHeadController.h"
#define CLLDefaultRefreshTotalPixels 60
@interface CLLRefreshHeadView ()
@property (nonatomic, strong) NSMutableArray *pullDownAnimations;
@property (nonatomic, strong) NSMutableArray *refreshAnimations;
@end
@implementation CLLRefreshHeadView
//刷新操作提示
- (UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 15, 160, 14)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:14.f];
        _statusLabel.textColor = [UIColor blackColor];
    }
    return _statusLabel;
}
//时间
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        CGRect timeLabelFrame = self.statusLabel.frame;
        timeLabelFrame.origin.y += CGRectGetHeight(timeLabelFrame) + 6;
        _timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:11.f];
        _timeLabel.textColor = [UIColor colorWithWhite:0.659 alpha:1.000];
    }
    return _timeLabel;
}
- (UIImageView *)animtionImageView{
    if (!_animtionImageView) {
        UIImage *image = [UIImage imageNamed:@"pull_down_animeted_0"];
        _animtionImageView = [[UIImageView alloc] initWithImage:image];
        [_animtionImageView sizeToFit];
        CGFloat right = self.statusLabel.frame.origin.x - 10;
        CGFloat bottom = CLLDefaultRefreshTotalPixels + 5;
        CGRect frame = CGRectMake(right - _animtionImageView.bounds.size.width, bottom - _animtionImageView.bounds.size.height, _animtionImageView.bounds.size.width, _animtionImageView.bounds.size.height);
        _animtionImageView.frame = frame;
    }
    return _animtionImageView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.statusLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.animtionImageView];
    }
    return self;
}
- (NSMutableArray*)pullDownAnimations{
    if (!_pullDownAnimations) {
        _pullDownAnimations = [NSMutableArray new];
        NSMutableArray *fileNames = [NSMutableArray new];
        for (int i = 0; i < 27; i++) {
            NSString *strImageName = [NSString stringWithFormat:@"%@%d", @"pull_down_animeted_", i];
            [fileNames addObject:strImageName];
        }
        NSArray *pullDownImages = fileNames;
        for (NSString *obj in pullDownImages) {
            UIImage *image = [UIImage imageNamed:obj];
            [_pullDownAnimations addObject:image];
        }
    }
    return _pullDownAnimations;
}
- (NSMutableArray*)refreshAnimations{
    if (!_refreshAnimations) {
        _refreshAnimations = [NSMutableArray new];
        NSMutableArray *fileNames = [NSMutableArray new];
        for (int i = 0; i < 15; i++) {
            NSString *strImageName = [NSString stringWithFormat:@"%@%d", @"refresh_animation_", i];
            [fileNames addObject:strImageName];
        }
        for (int i = 15 - 1; i >= 0; i--) {
            NSString *strImageName = [NSString stringWithFormat:@"%@%d", @"refresh_animation_", i];
            [fileNames addObject:strImageName];
        }
        NSArray *refreshImages = fileNames;
        for (NSString *obj in refreshImages) {
            UIImage *image = [UIImage imageNamed:obj];
            [_refreshAnimations addObject:image];
        }
    }
    return _refreshAnimations;
}
- (void)moveAnimationPercent:(CGFloat)percent{
    NSUInteger drawingIndex = percent * (self.pullDownAnimations.count - 1);
    self.animtionImageView.image = self.pullDownAnimations[drawingIndex];
}
//刷新动画
- (void)startRefreshAnimation{
    [self.animtionImageView stopAnimating];
    self.animtionImageView.animationImages = self.refreshAnimations;
    self.animtionImageView.animationDuration = 1.f;
    self.animtionImageView.animationRepeatCount = 0;
    [self.animtionImageView startAnimating];
}
- (void)resetAnimation{
    NSMutableArray *stopImages = [NSMutableArray new];
    unsigned long count = self.pullDownAnimations.count - 1;
    for (int i = (int)count; i >= 0; i--) {
        [stopImages addObject:self.pullDownAnimations[i]];
    }
    [self.animtionImageView stopAnimating];
    self.animtionImageView.animationImages = stopImages;
    self.animtionImageView.animationDuration = .7f;
    self.animtionImageView.animationRepeatCount = 1;
}
@end
@interface CLLRefreshFooterView ()
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end
@implementation CLLRefreshFooterView
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(135,(self.bounds.size.height - 14) * 0.5, 160, 14)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:14.f];
        _statusLabel.textColor = [UIColor grayColor];
    }
    return _statusLabel;
}
- (UIButton *)refreshButton{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshButton.backgroundColor = [UIColor lightGrayColor];
        _refreshButton.frame = CGRectMake(0, 10, self.frame.size.width, 35);
        CALayer *border = [CALayer layer];
        border.backgroundColor = [UIColor grayColor].CGColor;
        border.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
        [_refreshButton.layer  addSublayer:border];
        [_refreshButton addTarget:self action:@selector(clickRefreshAction)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refreshButton];
    }
    return _refreshButton;
}
- (void)clickRefreshAction{
    if (self.mClickRefreshButtonAction) {
        self.mClickRefreshButtonAction();
    }
}
- (void)setFooterTop:(CGFloat)footerTop{
    _footerTop = footerTop;
    CGRect frame = self.refreshButton.frame;
    frame.origin.y = footerTop;
    self.refreshButton.frame = frame;
}
- (void)animation{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation1.duration = 1;
    animation1.fromValue = @.8;
    animation1.toValue = @0.1;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation1.fillMode = kCAFillModeForwards;
    animation1.removedOnCompletion = NO;

    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation2.duration = 1;
    animation2.fromValue = @.1;
    animation2.toValue = @.8;
    animation2.beginTime = animation1.duration;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;

    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotateAni.duration = 0.2f;
    rotateAni.cumulative = YES;
    rotateAni.removedOnCompletion = NO;
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAni.toValue = [NSNumber numberWithFloat:M_PI / 2];
    rotateAni.repeatCount = MAXFLOAT;
    [self.circleLayer addAnimation:rotateAni forKey:@"rotate"];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 2;
    animationGroup.animations = @[animation1, animation2];
    animationGroup.repeatCount = MAXFLOAT;
    [self.circleLayer addAnimation:animationGroup forKey:@"groupAnimation"];
}
- (void)setRefreshType:(RefreshType)refreshType{
    _refreshType = refreshType;
    if (_refreshType == RefreshTypeLoading) {
        self.statusLabel.text = @"正在加载数据...";
        [self.statusLabel sizeToFit];
        CGFloat kMaxWidth = self.circleLayer.frame.size.width + self.statusLabel.frame.size.width + 5;
        CGRect _frame = self.circleLayer.frame;
        _frame.origin.x = (self.refreshButton.frame.size.width - kMaxWidth) / 2;
        _frame.origin.y = (self.refreshButton.frame.size.height - _frame.size.height) / 2;
        self.circleLayer.frame = _frame;

        CGFloat top = (self.refreshButton.frame.size.height - self.statusLabel.frame.size.height) / 2;
        CGFloat left = _frame.origin.x + _frame.size.width + 5;
        self.statusLabel.frame = CGRectMake(left,top, self.statusLabel.frame.size.width, self.statusLabel.frame.size.height);
        [self animation];
        self.refreshButton.userInteractionEnabled = NO;
    } else {
        if (_circleLayer) {
            [_circleLayer removeAllAnimations];
            [_circleLayer removeFromSuperlayer];
            _circleLayer = nil;
        }
        switch (refreshType) {
            case RefreshTypeNormal:
                self.statusLabel.text = @"上拉显示更多数据";
                self.refreshButton.userInteractionEnabled = YES;
                break;
            case RefreshTypeNotMore:
                self.statusLabel.text = @"已经没有更多了";
                self.refreshButton.userInteractionEnabled = NO;
                break;
            case RefreshTypeFail:
                self.refreshButton.userInteractionEnabled = YES;
                self.statusLabel.text = @"加载失败，点击重新加载";
                break;
            case RefreshTypeLoosen:
                self.refreshButton.userInteractionEnabled = NO;
                self.statusLabel.text = @"松开加载更多";
                break;
            case RefreshTypeNotFullowup:
                self.refreshButton.userInteractionEnabled = NO;
                self.statusLabel.text = @"暂无跟帖";
                break;
            default: self.statusLabel.text = @"上拉显示更多数据";
                break;
        }
        [self.statusLabel sizeToFit];
        CGFloat top = (self.refreshButton.frame.size.height - self.statusLabel.frame.size.height) / 2;
        CGFloat left = (self.refreshButton.frame.size.width - self.statusLabel.frame.size.width) / 2;
        self.statusLabel.frame = CGRectMake(left,top, self.statusLabel.frame.size.width, self.statusLabel.frame.size.height);
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.refreshButton addSubview:self.statusLabel];
    }
    return self;
}
#pragma mark - **** getter ***
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.frame = CGRectMake(0, 0, 20, 20);
        CGPoint center = CGPointMake(CGRectGetMidX(_circleLayer.frame), CGRectGetMidY(_circleLayer.frame));
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center
                                                                  radius:7
                                                              startAngle:-M_PI_2
                                                                endAngle:M_PI_2 * 2.7
                                                               clockwise:YES];
        _circleLayer.lineWidth = 1.f;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor redColor].CGColor;
        _circleLayer.path = bezierPath.CGPath;
        [self.refreshButton.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}
@end

@interface CLLRefreshHeadController ()
@property (nonatomic, copy) PullDownRefreshing refreshHeadPullDownRefreshing;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) id<CLLRefreshHeadControllerDelegate>delegate;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, assign) CLLRefreshState refreshState;
@property (nonatomic, assign) CLLLoadMoreState loadMoreState;
@property (nonatomic, assign) CLLRefreshViewLayerType refreshViewLayerType;
@property (nonatomic, assign) BOOL isPullDownRefreshed;
@property (nonatomic, assign) BOOL isPullUpLoadMore;
@property (nonatomic, assign) BOOL pullDownRefreshing;
@property (nonatomic, assign) BOOL pullDownMoreLoading;
@property (nonatomic, assign) BOOL isPauseMoreLoading;
@property (nonatomic, assign) BOOL didAddObserveForRefresh;
@end
@implementation CLLRefreshHeadController
- (void)removeHeader{
    if (_refreshHeadView) {
        [_refreshHeadView removeFromSuperview];
        _refreshHeadView = nil;
    }
}

- (void)removeFooter {
    if (_refreshFooterView) {
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = nil;
    }
}

#pragma mark - Pull Down Refreshing Method <上拉刷新>
//下拉刷新开始 <调用下拉刷新协议>
- (void)callBeginPullDownRefreshing {
    if ([self.delegate respondsToSelector:@selector(beginPullDownRefreshing)]) {
        [self.delegate beginPullDownRefreshing];
    }
    if (self.refreshHeadPullDownRefreshing) {
        self.refreshHeadPullDownRefreshing();
    }
}

//上拉加载更多开始 <调用上拉加载更多协议>
- (void)callBeginPullUpLoading {
    if ([self.delegate respondsToSelector:@selector(beginPullUpLoading)]) {
        [self.delegate beginPullUpLoading];
    }
}
//手动停止下拉刷新
- (void)endPullDownRefreshing {
    if (self.isPullDownRefreshed) {
        self.pullDownRefreshing = NO;
        self.refreshState = CLLRefreshStateStopped;
        [self resetScrollViewContentInset];
    }
}

//手动停止上拉
- (void)endPullUpLoading {
    if (!self.isPullUpLoadMore) {
        if (_refreshFooterView) {
            [_refreshFooterView removeFromSuperview];
            _refreshFooterView = nil;
        }
    }else {
        self.refreshFooterType = RefreshTypeNormal;
    }
    self.pullDownMoreLoading = NO;
    [self resetScrollViewContentInsetWithDoneLoadMore];
}
- (void)setRefreshFooterType:(RefreshType)refreshFooterType{
    _refreshFooterType = refreshFooterType;
    self.refreshFooterView.refreshType = refreshFooterType;
    [self setupFooterView];
}
- (void)notFullowup{
    self.refreshFooterView.refreshType = RefreshTypeNotFullowup;
    [self setupFooterView];
}
- (void)notMoreHaveContent{
    self.refreshFooterView.refreshType = RefreshTypeNotMore;
    [self setupFooterView];
}
- (void)footerRefreshFail{
    self.refreshFooterView.refreshType = RefreshTypeFail;
}
- (void)resetFooterRefreshStatus{
    if (_refreshFooterView) {
        _refreshFooterView.refreshType = RefreshTypeNormal;
    }
}
//手动开始上拉刷新
- (void)startPullUpRefreshing{
    if (self.isPullUpLoadMore && self.refreshFooterView && !self.pullDownMoreLoading) {
        self.pullDownMoreLoading = YES;
        self.loadMoreState = CLLLoadMoreStateLoading;
    }
}
//手动开始刷新
- (void)startPullDownRefreshing {
    if (self.isPullDownRefreshed) {
        self.pullDownRefreshing = YES;
        self.refreshState = CLLRefreshStatePulling;
        self.refreshState = CLLRefreshStateLoading;
        self.scrollView.contentOffset = CGPointMake(0, -self.refreshTotalPixels);
    }
}
//刷新动画
- (void)animationWithRefresh{
    if (_refreshHeadView) {
        [self.refreshHeadView startRefreshAnimation];
    }
    [self callBeginPullDownRefreshing];
}


#pragma mark - Getter Method
- (BOOL)isPullDownRefreshed {
    if ([self.delegate respondsToSelector:@selector(hasRefreshHeaderView)]) {
        BOOL hasHeaderView = [self.delegate hasRefreshHeaderView];
        if (!hasHeaderView) {
            [self removeHeader];
        }else {
            if (!_refreshHeadView) {
                [self setup];
            }
        }
        return hasHeaderView;
    }
    return YES;
}

- (BOOL)isPullUpLoadMore {
    if ([self.delegate respondsToSelector:@selector(hasRefreshFooterView)]) {
        BOOL hasFooterView = [self.delegate hasRefreshFooterView];
        if (hasFooterView) {
            if (!_refreshFooterView) {
                [self setupFooterView];
            }
        }else {
            if (_refreshFooterView
                && _refreshFooterView.refreshType != RefreshTypeNotMore
                && _refreshFooterView.refreshType != RefreshTypeNotFullowup) {
                UIEdgeInsets contentInset = self.scrollView.contentInset;
                contentInset.bottom = 0;
                contentInset.bottom = self.refreshFooterView.frame.size.height;
                [self.scrollView setContentInset:contentInset];
                [self removeFooter];
                
            }
        }
        return hasFooterView;
    }
    return NO;
}

- (id)initWithScrollView:(UIScrollView *)scrollView
            viewDelegate:(id <CLLRefreshHeadControllerDelegate>)delegate{
    self = [super init];
    if (self) {
        [self setScrollView:scrollView
                andDelegate:delegate];
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView
          andDelegate:(id <CLLRefreshHeadControllerDelegate>)delegate{
    if (delegate == self.delegate && scrollView == self.scrollView ){
        return;
    }
    self.delegate = delegate;
    self.scrollView = scrollView;
    self.isPauseMoreLoading = NO;
    [self setup];
}
- (void)setupFooterView{
    CGRect tmpFrame = self.refreshFooterView.frame;
    tmpFrame.origin.y = self.scrollView.contentSize.height;
    self.refreshFooterView.frame = tmpFrame;
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = self.refreshFooterView.frame.size.height;
    [self.scrollView setContentInset:contentInset];
    if (self.refreshFooterView.refreshType != RefreshTypeNotMore
        && self.refreshFooterView.refreshType != RefreshTypeNotFullowup) {
        self.loadMoreState = CLLLoadMoreStateNormal;
    }
}
- (void)addPullDownRefreshBlock:(PullDownRefreshing)refreshing{
    self.refreshHeadPullDownRefreshing = refreshing;
}
- (CLLRefreshViewLayerType)refreshViewLayerType {
    CLLRefreshViewLayerType currentRefreshViewLayerType = CLLRefreshViewLayerTypeOnSuperView;
    if ([self.delegate respondsToSelector:@selector(refreshViewLayerType)]) {
        currentRefreshViewLayerType = [self.delegate refreshViewLayerType];
    }else {
        currentRefreshViewLayerType = CLLRefreshViewLayerTypeOnSuperView;
    }
    return currentRefreshViewLayerType;
}
- (void)setup{
    self.originalTopInset = self.scrollView.contentInset.top;
    [self configuraObserverWithScrollView:self.scrollView];
    self.refreshHeadView.timeLabel.text = @"仙人掌，让炒股变得简单！";
    self.refreshHeadView.statusLabel.text = @"下拉刷新";
    self.refreshState = CLLRefreshStateNormal;
    
    if (self.refreshViewLayerType == CLLRefreshViewLayerTypeOnSuperView) {
        self.scrollView.backgroundColor = [UIColor clearColor];
        if (self.isPullDownRefreshed) {
            [self.scrollView.superview insertSubview:self.refreshHeadView belowSubview:self.scrollView];
        }
    } else if (self.refreshViewLayerType == CLLRefreshViewLayerTypeOnScrollViews) {
        if (self.isPullDownRefreshed) {
            [self.scrollView addSubview:self.refreshHeadView];
        }
    }
}
#pragma mark - SrollerView 下拉刷新后的 重置
- (void)resetScrollViewContentInset {
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.originalTopInset;
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        self.refreshState = CLLRefreshStateNormal;
        if (_refreshHeadView) {
            [self.refreshHeadView resetAnimation];
        }
    }];
}
#pragma mark - SrollerView 上拉加载更多后的 重置
- (void)resetScrollViewContentInsetWithDoneLoadMore {
    if (_refreshFooterView) {
        if (self.refreshFooterView.refreshType != RefreshTypeNotMore
            && self.refreshFooterView.refreshType != RefreshTypeFail
            && _refreshFooterView.refreshType != RefreshTypeNotFullowup) {
            self.loadMoreState = CLLLoadMoreStateNormal;
        }
        [self performSelector:@selector(resetLock) withObject:nil afterDelay:.5f];
    }
}
- (void)resetLock{
    self.isPauseMoreLoading = NO;
}
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }completion:^(BOOL finished) {
                         if (self.refreshState == CLLRefreshStateStopped) {
                             self.refreshState = CLLRefreshStateNormal;
                         }
                     }];
}

- (void)setScrollViewContentInsetForLoading {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.refreshTotalPixels;
    [self setScrollViewContentInset:currentInsets];
}
#pragma mark - Life Cycle
- (void)configuraObserverWithScrollView:(UIScrollView *)scrollView {
    if (self.didAddObserveForRefresh) {
        return;
    }
    self.didAddObserveForRefresh = YES;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverWithScrollView:(UIScrollView *)scrollView {
    if (self.didAddObserveForRefresh) {
        self.didAddObserveForRefresh = NO;
        [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [scrollView removeObserver:self forKeyPath:@"contentInset" context:nil];
        [scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    }
}

- (CLLRefreshFooterView *)refreshFooterView {
    if (!_refreshFooterView) {
        _refreshFooterView = [[CLLRefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), 55)];
        if (_footerHeight != 0) {
            _refreshFooterView.footerTop = _footerTop;
            CGRect frame = _refreshFooterView.frame;
            frame.size.height = _footerHeight;
            _refreshFooterView.frame = frame;
        }
        if ([self.scrollView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (id)self.scrollView;
            if (tableView.style == UITableViewStyleGrouped) {
                _refreshFooterView.footerTop = 0;
                CGRect frame = _refreshFooterView.frame;
                frame.size.height = 45;
                _refreshFooterView.frame = frame;
            }
        }
        _refreshFooterView.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:_refreshFooterView];
        _refreshFooterView.mClickRefreshButtonAction = ^{
            self.pullDownMoreLoading = YES;
            self.loadMoreState = CLLLoadMoreStateLoading;
        };
    }
    return _refreshFooterView;
}
- (CLLRefreshHeadView *)refreshHeadView{
    if (!_refreshHeadView) {
        _refreshHeadView = [[CLLRefreshHeadView alloc] initWithFrame:CGRectMake(0, (self.refreshViewLayerType == CLLRefreshViewLayerTypeOnScrollViews? - CLLDefaultRefreshTotalPixels : self.originalTopInset), CGRectGetWidth([[UIScreen mainScreen] bounds]),CLLDefaultRefreshTotalPixels)];
        _refreshHeadView.backgroundColor = [UIColor clearColor];
    }
    return _refreshHeadView;
}
#pragma mark -上拉
- (void)setLoadMoreState:(CLLLoadMoreState)loadMoreState {
    switch (loadMoreState) {
        case CLLLoadMoreStateStopped:
        case CLLLoadMoreStateNormal:{
            //上拉加载更多
            if (self.refreshFooterView.refreshType != RefreshTypeFail) {
                self.refreshFooterView.refreshType = RefreshTypeNormal;
            }
        }break;
        case CLLLoadMoreStatePulling:
            self.refreshFooterView.refreshType = RefreshTypeLoosen;
            break;
        case CLLLoadMoreStateLoading:{
            //加载中
            self.refreshFooterView.refreshType = RefreshTypeLoading;
            if (self.pullDownMoreLoading) {
                [self callBeginPullUpLoading];
                //                [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.frame.size.height) animated:YES];
            }
        }break;
        default:break;
    }
    _loadMoreState = loadMoreState;
    //如果是加载中，加载完重置为normal
    if (loadMoreState == CLLLoadMoreStateLoading) {
        _loadMoreState = CLLLoadMoreStateNormal;
    }
}

#pragma mark -下拉
- (void)setRefreshState:(CLLRefreshState)refreshState{
    if (_refreshHeadView) {
        switch (refreshState) {
            case CLLRefreshStateStopped:
            case CLLRefreshStateNormal: {
                self.refreshHeadView.statusLabel.text = @"下拉刷新";
                break;
            }
            case CLLRefreshStateLoading: {
                if (self.pullDownRefreshing) {
                    self.refreshHeadView.statusLabel.text = @"正在加载";
                    [self setScrollViewContentInsetForLoading];
                    if(_refreshState == CLLRefreshStatePulling) {
                        [self animationWithRefresh];
                    }
                }break;
            }
            case CLLRefreshStatePulling:
                self.refreshHeadView.statusLabel.text = @"释放立即刷新";
                break;
            default:break;
        }
        _refreshState = refreshState;
    }
}
//是否支持 ios7 这里暂时不支持
- (CGFloat)getAdaptorHeight {
    if ([self.delegate respondsToSelector:@selector(keepiOS7NewApiCharacter)]) {
        return ([self.delegate keepiOS7NewApiCharacter] ? 64 : 0);
    } else {
        return 0;
    }
}
- (CGFloat)refreshTotalPixels {
    return CLLDefaultRefreshTotalPixels;// + [self getAdaptorHeight];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if (self.isPullDownRefreshed) {
            // 下拉刷新的逻辑方法
            if(self.refreshState != CLLRefreshStateLoading) {
                //动画效果
                CGFloat offset = -(self.scrollView.contentOffset.y);
                if (offset >= -5 && offset <= CLLDefaultRefreshTotalPixels + 5) {
                    CGFloat percent = 0;
                    if (offset < 0) {
                        offset = 0;
                    }
                    if (offset > CLLDefaultRefreshTotalPixels) {
                        offset = CLLDefaultRefreshTotalPixels;
                    }
                    percent = offset / CLLDefaultRefreshTotalPixels;
                    if (_refreshHeadView) {
                        [self.refreshHeadView moveAnimationPercent:percent];
                    }
                }
                CGFloat scrollOffsetThreshold;
                scrollOffsetThreshold = -(CLLDefaultRefreshTotalPixels + self.originalTopInset);
                if(!self.scrollView.isDragging && self.refreshState == CLLRefreshStatePulling) {
                    self.pullDownRefreshing = YES;
                    self.refreshState = CLLRefreshStateLoading;
                } else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.refreshState == CLLRefreshStateStopped) {
                    self.refreshState = CLLRefreshStatePulling;
                } else if(contentOffset.y >= scrollOffsetThreshold && self.refreshState != CLLRefreshStateStopped) {
                    self.refreshState = CLLRefreshStateStopped;
                }
            } else {
                CGFloat offset;
                UIEdgeInsets contentInset;
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.refreshTotalPixels);
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
            }
        }
        if (self.isPullUpLoadMore && contentOffset.y > 0 && self.refreshFooterView.refreshType != RefreshTypeNotMore && self.refreshFooterView.refreshType != RefreshTypeNotFullowup) {
            if(self.loadMoreState != CLLLoadMoreStateLoading && !self.isPauseMoreLoading && contentOffset.y != 0 && !self.pullDownMoreLoading) {
                contentOffset.y += self.scrollView.bounds.size.height;
                float scrollOContentSizeHeight = self.scrollView.contentSize.height + 80;
                if(!self.scrollView.isDragging && contentOffset.y > scrollOContentSizeHeight) {
                    self.pullDownMoreLoading = YES;
                    self.loadMoreState = CLLLoadMoreStateLoading;
                    //下拉刷新上锁
                    self.isPauseMoreLoading = YES;
                }else if (self.scrollView.isDragging && contentOffset.y > scrollOContentSizeHeight && self.loadMoreState != CLLLoadMoreStatePulling && self.loadMoreState != CLLLoadMoreStateLoading) {
                    self.loadMoreState = CLLLoadMoreStatePulling;
                }else if (self.scrollView.isDragging && contentOffset.y <= scrollOContentSizeHeight && self.refreshFooterView.refreshType != RefreshTypeFail && self.loadMoreState != CLLLoadMoreStateNormal) {
                    self.loadMoreState = CLLLoadMoreStateNormal;
                }
            }else {
                if (self.pullDownMoreLoading && !self.isPullUpLoadMore) {
                    CGFloat offset;
                    UIEdgeInsets contentInset;
                    offset = 0;
                    offset = MAX(offset, self.refreshFooterView.frame.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                }
            }
        }
    } else if ([keyPath isEqualToString:@"contentInset"]) {
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        BOOL hasFooterView = [self isPullUpLoadMore];
        if (hasFooterView) {
            CGRect tmpFrame = self.refreshFooterView.frame;
            tmpFrame.origin.y = self.scrollView.contentSize.height;
            self.refreshFooterView.frame = tmpFrame;
        }
    };
}

- (void)dealloc {
    _delegate = nil;
    [self removeObserverWithScrollView:_scrollView];
    if (_refreshHeadView) {
        [_refreshHeadView removeFromSuperview];
        _refreshHeadView = nil;
    }
    if (_refreshFooterView) {
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = nil;
    }
    NSLog(@"dealloc::%@", [self classForKeyedArchiver]);
}
- (void)removeAllObserver {
    _delegate = nil;
    [self removeObserverWithScrollView:_scrollView];
    if (_refreshHeadView) {
        [_refreshHeadView removeFromSuperview];
        _refreshHeadView = nil;
    }
    if (_refreshFooterView) {
        [_refreshFooterView removeFromSuperview];
        _refreshFooterView = nil;
    }
    NSLog(@"dealloc::%@", [self classForKeyedArchiver]);
}
@end
