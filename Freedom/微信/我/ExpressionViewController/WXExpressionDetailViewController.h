//  WXExpressionDetailViewController.h
//  Freedom
// Created by Super
#import "WXBaseViewController.h"
#import "WXImageExpressionDisplayView.h"
#import "TLEmojiBaseCell.h"
@interface WXExpressionDetailViewController : WXBaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;
- (void)didLongPressScreen:(UILongPressGestureRecognizer *)sender;
- (void)didTap5TimesScreen:(UITapGestureRecognizer *)sender;
@property (nonatomic, strong) TLEmojiGroup *group;
@property (nonatomic, strong) WXImageExpressionDisplayView *emojiDisplayView;
@end
