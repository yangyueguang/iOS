//  CKRadialView.h
//  Freedom
//  Created by Freedom on 12/7/14.
#import <UIKit/UIKit.h>
@class CKRadialMenu;
@protocol CKRadialMenuDelegate <NSObject>
@optional//点击，放大和缩小
-(void)radialMenu:(CKRadialMenu *)radialMenu didSelectPopoutWithIndentifier: (NSString *) identifier;
-(BOOL)radialMenuShouldExpand:(CKRadialMenu *)radialMenu;
-(void)radialMenuDidExpand:(CKRadialMenu *)radialMenu;
-(BOOL)radialMenuShouldRetract:(CKRadialMenu *)radialMenu;
-(void)radialMenuDidRetract:(CKRadialMenu *)radialMenu;
@end
@interface CKRadialMenu : UIView
- (void) addPopoutView: (UIView *) popoutView withIndentifier: (NSString *) identifier;
-(void)addPopoutViews:(UIView *)popoutView,...;
- (UIView *) getPopoutViewWithIndentifier: (NSString *) identifier;
- (void) expand;
- (void) retract;
- (void) enableDevelopmentMode;
@property (nonatomic, weak) NSObject<CKRadialMenuDelegate> *delegate;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) NSMutableArray *popoutViews;
@property CGFloat popoutViewSize;
@property CGFloat distanceFromCenter;
@property CGFloat distanceBetweenPopouts;
@property CGFloat startAngle;
@property CGFloat animationDuration;
@property NSTimeInterval stagger;
@property BOOL menuIsExpanded;
#pragma mark 外界调用
- (void) didTapCenterView: (UITapGestureRecognizer *) sender;
@end
