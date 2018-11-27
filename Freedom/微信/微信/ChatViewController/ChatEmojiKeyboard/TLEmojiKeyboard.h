//  TLEmojiKeyboard.h
//  Freedom
//  Created by Super on 16/2/17.
#import <UIKit/UIKit.h>
#import "TLEmojiBaseCell.h"
#define     HEIGHT_TOP_SPACE            10
#define     HEIGHT_EMOJIVIEW            (215.0f * 0.75 - HEIGHT_TOP_SPACE)
#define     HEIGHT_PAGECONTROL          215.0f * 0.1
#define     HEIGHT_GROUPCONTROL         215.0f * 0.17
@protocol TLKeyboardDelegate <NSObject>
@optional
- (void) chatKeyboardWillShow:(id)keyboard;
- (void) chatKeyboardDidShow:(id)keyboard;
- (void) chatKeyboardWillDismiss:(id)keyboard;
- (void) chatKeyboardDidDismiss:(id)keyboard;
- (void) chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height;
@end
@class TLEmojiKeyboard;
@protocol TLEmojiKeyboardDelegate <NSObject>
- (BOOL)chatInputViewHasText;
@optional
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didTouchEmojiItem:(TLEmoji *)emoji atRect:(CGRect)rect;
- (void)emojiKeyboardCancelTouchEmojiItem:(TLEmojiKeyboard *)emojiKB;
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB didSelectedEmojiItem:(TLEmoji *)emoji;
- (void)emojiKeyboardSendButtonDown;
- (void)emojiKeyboardEmojiEditButtonDown;
- (void)emojiKeyboardMyEmojiEditButtonDown;
- (void)emojiKeyboard:(TLEmojiKeyboard *)emojiKB selectedEmojiGroupType:(TLEmojiType)type;
@end
@interface TLEmojiKeyboard : UIView<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,TLEmojiGroupControlDelegate>{
    CGSize cellSize;
    CGSize headerReferenceSize;
    CGSize footerReferenceSize;
    CGFloat minimumLineSpacing;
    CGFloat minimumInteritemSpacing;
    UIEdgeInsets sectionInsets;
}
- (void)registerCellClass;
- (NSUInteger)transformCellIndex:(NSInteger)index;
- (NSUInteger)transformModelIndex:(NSInteger)index;
- (void)resetCollectionSize;
- (void)addGusture;
- (void)updateSendButtonStatus;
@property (nonatomic, assign) NSMutableArray *emojiGroupData;
@property (nonatomic, assign) id<TLEmojiKeyboardDelegate>delegate;
@property (nonatomic, assign) id<TLKeyboardDelegate> keyboardDelegate;
@property (nonatomic, strong) TLEmojiGroup *curGroup;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) TLEmojiGroupControl *groupControl;
+ (TLEmojiKeyboard *)keyboard;
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;
- (void)dismissWithAnimation:(BOOL)animation;
- (void)reset;
@end
