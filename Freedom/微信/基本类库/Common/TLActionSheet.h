//  TLActionSheet.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
@protocol TLActionSheetDelegate; 
@interface TLActionSheet : UIView
@property(nonatomic, assign, readonly) NSInteger numberOfButtons;
@property(nonatomic, assign, readonly) NSInteger cancelButtonIndex;
@property(nonatomic, assign, readonly) NSInteger destructiveButtonIndex;
@property (nonatomic, assign) id<TLActionSheetDelegate> delegate;
- (id)initWithTitle:(NSString *)title
           delegate:(id<TLActionSheetDelegate>)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (void)show;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
@end
@protocol TLActionSheetDelegate <NSObject>
@optional;
- (void)actionSheet:(TLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(TLActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)actionSheet:(TLActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
@end
