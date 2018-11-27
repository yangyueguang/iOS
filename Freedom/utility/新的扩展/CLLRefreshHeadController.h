//
//  CLLRefreshHeadController.h
//  RefreshLoadView
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface CLLRefreshHeadView : UIView//刷新操作提示
@property (nonatomic,strong)UILabel *statusLabel;//刷新时间
@property (nonatomic,strong)UILabel *timeLabel;//动画ImageView
@property (nonatomic, strong) UIImageView *animtionImageView;
/**
 *  下拉时改变动画帧
 *  @param percent 比例
 */
- (void)moveAnimationPercent:(CGFloat)percent;
/// 开始刷新动画
- (void)startRefreshAnimation;
/// 重置动画
- (void)resetAnimation;
@end

typedef void(^clickRefreshButtonAction)();
typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeNormal,
    RefreshTypeLoading,
    RefreshTypeNotMore,
    RefreshTypeFail,
    RefreshTypeLoosen,
    RefreshTypeNotFullowup,
};
@interface CLLRefreshFooterView : UIView
@property (nonatomic, copy) clickRefreshButtonAction mClickRefreshButtonAction;
//刷新操作提示
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, assign) CGFloat footerTop;
@end
typedef NS_ENUM(NSInteger, CLLRefreshState) {
    CLLRefreshStatePulling   = 0,
    CLLRefreshStateNormal    = 1,
    CLLRefreshStateLoading   = 2,
    CLLRefreshStateStopped   = 3,
};
typedef NS_ENUM(NSInteger, CLLLoadMoreState) {
    CLLLoadMoreStateNormal    = 10,
    CLLLoadMoreStateLoading   = 11,
    CLLLoadMoreStateStopped   = 12,
    CLLLoadMoreStatePulling,
};
typedef NS_ENUM(NSInteger, CLLRefreshViewLayerType) {
    CLLRefreshViewLayerTypeOnScrollViews = 0,
    CLLRefreshViewLayerTypeOnSuperView = 1,
};
typedef void(^PullDownRefreshing)(void); /*< 下拉刷新开始*/
@protocol CLLRefreshHeadControllerDelegate <NSObject>
@required /* 必须协议*/
- (void)beginPullDownRefreshing;
- (void)beginPullUpLoading;
@optional /*可选协议*/
- (CLLRefreshViewLayerType)refreshViewLayerType;
/**
 *  2、UIScrollView的控制器是否保留iOS7新的特性，意思是：tablView的内容是否可以显示导航条后面
 *  @return 如果不实现该delegate方法，默认是不支持的
 **/
- (BOOL)keepiOS7NewApiCharacter;
- (BOOL)hasRefreshHeaderView;
- (BOOL)hasRefreshFooterView;
@end
@interface CLLRefreshHeadController : NSObject
@property (nonatomic, strong)CLLRefreshHeadView *refreshHeadView;
@property (nonatomic, strong)CLLRefreshFooterView *refreshFooterView;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) CGFloat footerTop;
- (id)initWithScrollView:(UIScrollView *)scrollView viewDelegate:(id <CLLRefreshHeadControllerDelegate>)delegate;
- (void)setScrollView:(UIScrollView *)scrollView andDelegate:(id <CLLRefreshHeadControllerDelegate>)delegate;
- (void)addPullDownRefreshBlock:(PullDownRefreshing)refreshing;
- (void)startPullDownRefreshing;
- (void)startPullUpRefreshing;
- (void)endPullDownRefreshing;
- (void)endPullUpLoading;
/**新加 上啦刷新页面类型控制*/
@property (nonatomic, assign) RefreshType refreshFooterType;
- (void)notMoreHaveContent;
- (void)footerRefreshFail;
/***  重置所有刷新状态到初始状态*/
- (void)resetFooterRefreshStatus;
- (void)removeHeader;
- (void)removeFooter;
- (void)removeObserverWithScrollView:(UIScrollView *)scrollView;
- (void)removeAllObserver;
@end
