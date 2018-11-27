//  TLExpressionDetailViewController.h
//  Freedom
// Created by Super
#import "TLViewController.h"
#import "TLImageExpressionDisplayView.h"
#import "TLEmojiBaseCell.h"
@interface TLExpressionDetailViewController : TLViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
- (void)registerCellForCollectionView:(UICollectionView *)collectionView;
- (void)didLongPressScreen:(UILongPressGestureRecognizer *)sender;
- (void)didTap5TimesScreen:(UITapGestureRecognizer *)sender;
@property (nonatomic, strong) TLEmojiGroup *group;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TLImageExpressionDisplayView *emojiDisplayView;
@end
