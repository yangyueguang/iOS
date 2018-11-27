//  TLMomentDetailViewController.h
//  Freedom
//  Created by Super on 16/4/23.
#import "WXBaseViewController.h"
#import "WXModes.h"
@protocol WXMomentMultiImageViewDelegate <NSObject>
- (void)momentViewClickImage:(NSArray *)images atIndex:(NSInteger)index;
@end
@protocol WXMomentDetailViewDelegate <WXMomentMultiImageViewDelegate>
@end
@protocol WXMomentViewDelegate <WXMomentDetailViewDelegate>
@end
@interface WXMomentBaseView : UIView
@property (nonatomic, assign) id<WXMomentViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *detailContainerView;
@property (nonatomic, strong) UIView *extensionContainerView;
@property (nonatomic, strong) WXMoment *moment;
@end
@interface WXMomentImageView : WXMomentBaseView
@end
@interface WXMomentDetailViewController : WXBaseViewController
@property (nonatomic, strong) WXMoment *moment;
@end
