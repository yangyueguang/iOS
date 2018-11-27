//  E_MagnifiterView.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
/*放大镜类*/
@interface E_MagnifiterView : UIView
@property (weak, nonatomic) UIView *viewToMagnify;
@property (nonatomic) CGPoint touchPoint;
@end
