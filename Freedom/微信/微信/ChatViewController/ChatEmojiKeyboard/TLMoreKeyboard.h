//  TLMoreKeyboard.h
//  Freedom
//  Created by Super on 16/2/17.
#import <UIKit/UIKit.h>
#import "TLEmojiKeyboard.h"
@interface TLMoreKeyboardItem : NSObject
@property (nonatomic, assign) TLMoreKeyboardItemType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imagePath;
+ (TLMoreKeyboardItem *)createByType:(TLMoreKeyboardItemType)type title:(NSString *)title imagePath:(NSString *)imagePath;
@end
@protocol TLMoreKeyboardDelegate <NSObject>
@optional
- (void) moreKeyboard:(id)keyboard didSelectedFunctionItem:(TLMoreKeyboardItem *)funcItem;
@end
@interface TLMoreKeyboard : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
- (void)registerCellClass;
@property (nonatomic, assign) id<TLKeyboardDelegate> keyboardDelegate;
@property (nonatomic, assign) id<TLMoreKeyboardDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *chatMoreKeyboardData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
+ (TLMoreKeyboard *)keyboard;
- (void)reset;
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;
@end
