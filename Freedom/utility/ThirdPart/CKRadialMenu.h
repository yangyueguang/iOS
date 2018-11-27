//  CKRadialView.h
//  Freedom
//  Created by Super on 12/7/14.
#import <UIKit/UIKit.h>
@interface CKRadialMenu : UIView
- (void)addPopoutView:(UIView *_Nullable)popoutView withIndentifier:(NSString *)identifier;
- (void)addPopoutViews:(NSArray<UIView*>*)popoutViews;//增加中间多次点击的弹出的按钮
- (UIView*)getPopoutViewWithIndentifier:(NSString*)identifier;
- (void) expand;
- (void) retract;
///如果didExpand就是结束发射了,如果didRetract就是结束收起了,如果两者都是NO,才是被点击了.
@property (nonatomic, strong) void(^ _Nullable didSelectBlock)(CKRadialMenu  * _Nonnull menu,BOOL didExpand,BOOL didRetract,NSString *_Nullable identifier);
@property (nonatomic, strong) UIView * _Nullable centerView;
@property (nonatomic, strong) NSMutableArray<UIView*> * _Nonnull popoutViews;
@property CGFloat popoutViewSize;
@property CGFloat distanceFromCenter;
@property CGFloat distanceBetweenPopouts;
@property CGFloat startAngle;
@property CGFloat animationDuration;
@property NSTimeInterval stagger;
@property BOOL menuIsExpanded;
@end
