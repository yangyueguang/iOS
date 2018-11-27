//  DetailView.h
//  DW
#import <UIKit/UIKit.h>
@class MFullScreenControl;
@class UIScrollPageControlView;
@interface MFullScreenControl : NSObject
@property (nonatomic, strong) UIScrollPageControlView       *screenPageView;    //滚动视图
@property (nonatomic, assign) BOOL                           isAppear;          //记录当前状态
- (void) appearOnView:(UIView *) view;
- (void) disAppearOnView:(UIView *) view;
@end
@interface MFullScreenControl()
@property (nonatomic, strong) UIWindow                      *screenWindow;      //全屏窗体
@property (nonatomic, strong) UIView                        *contentView;       //视图容器
@property (nonatomic, strong) UIView                        *fromView;          //启动视图
@property (nonatomic, strong) UIImageView                   *sourceImageView;   //克隆的启动视图，用于动画展示
@end
@interface MFullScreenView : UIView
@property (nonatomic, strong) UIScrollView  *scrollView;    //容器
@property (nonatomic, strong) UIImageView   *imageView;     //执行动画的图片视图
@property (nonatomic, assign, setter=enableDoubleTap:) BOOL isDoubleTapEnabled; //是否允许双击放大
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);   //单击的回调处理
- (void) reloadData;
@end
@interface MFullScreenView() <UIScrollViewDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@end
@protocol UIScrollPageControlViewDelegate <NSObject>
@required
// 配置复用视图总数
- (NSUInteger) numberOfView:(UIScrollPageControlView *) control;
// 配置索引位置的视图，类似于UITableViewCell的生成方式
- (UIView *) configItemOfControl:(UIScrollPageControlView *) control at:(NSUInteger) index ;
@optional
- (CGFloat) minimumRowSpacing:(UIScrollPageControlView *) control;
// 配置正常呈现的视图，主要用于图片失去焦点时，进行场景还原操作，此方法有待优化
- (void) reconfigItemOfControl:(UIScrollPageControlView *)control at:(NSUInteger) index withView:(UIView *)view;
@end
#pragma mark UIScrollPageControlView
@interface UIScrollPageControlView : UIView
@property (nonatomic, strong) UIScrollView                          *scrollView;
@property (nonatomic, assign) BOOL                                  enablePageControl;  //默认为YES
@property (nonatomic, assign) NSInteger                             currentIndex;       //当前展示
@property (nonatomic, assign, readonly) UIView                      *currentView;       //当前展示的视图
@property (nonatomic, assign) id<UIScrollPageControlViewDelegate>   delegate;
- (CGFloat) itemWidth;
- (UIView *) dequeueReusableViewWithIdentifier:(NSString *) identifier;
- (void) reloadData;
@end
@protocol DetailViewSectionDelegate <NSObject>
@required
//顶部的滚动视图，此视图可以为如下值，UIWebView, UIScrollView及其之类@return 视图
- (UIView *) viewAtTop;
// 配置中间区间值的数量
- (NSUInteger ) numberOfSections;
// 配置中间区间的标题
- (NSString *) titleOfSectionAt:(NSUInteger )index;
@optional
// 配置区间中某个索引对应的视图，可以为空
- (UIView *) viewOfSectionAt:(NSUInteger ) index;
// 配置区间之间，是否可以进行页面切换，若不能切换，则在此编写具体的业务逻辑
- (BOOL) canChangeToSection:(NSUInteger) index;
//将要切换到某个区间
- (void) willChangeToSection:(NSUInteger) index view:(UIView *) view;
// 已经切换到某个区间
- (void) didChangeToSection:(NSUInteger) index view:(UIView *) view;
//  弹出层将要出现或者消失
- (void) floatViewIsGoingTo:(BOOL) appear;
@end
@interface DetailTipView : UIView
@end
@interface DetailView : UIView
@property (nonatomic, weak) UIScrollView                                *topScrollView;         //最重要的视图，用于作各种效果
@property (nonatomic, weak) UIScrollView                                *imageScrollView;       //banner上的图片滚动视图
@property (nonatomic, strong, readonly) DetailTipView                   *tipView;               //中间的提示视图
@property (nonatomic, strong, readonly) UIScrollPageControlView         *topScrollPageView;     //banner视图，包含滚动视图和页面控件
@property (nonatomic, strong, readonly) MFullScreenControl            *fullScreencontrol;     //全屏浏览控件，内聚有查看更多功能，即将底部的section上移；
@property (nonatomic, strong, readonly) UIView                          *topView;               //顶部视图的容器
@property (nonatomic, strong, readonly) UIView                          *bottomView;            //底部视图的容器
@property (nonatomic, assign) CGFloat                                   startYPosition;         //Section与顶部的间隙，全屏是设置为64.0f，默认为0.0f
@property (nonatomic, assign) CGFloat                                   topScrollViewTopInset;  //banner的高度设置，默认为370.0f
@property (nonatomic, weak  ) id<DetailViewSectionDelegate>             delegate;               //代理
// 底部视图是否已经显示
- (BOOL) isBottomViewShowed;
// 触发底部视图消失
- (void) disappearBottomView;
// 显示图片的全屏浏览
- (void) showFullScreenOnView:(UIView *) view;
// 隐藏图片的全屏浏览模式，
- (void) hideFullScreenOnView:(UIView *) view;
// 刷新页面
- (void) reloadData;
@end
