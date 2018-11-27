//  TLMomentDetailViewController.h
//  Freedom
//  Created by Super on 16/4/23.
#import "TLViewController.h"
#import "WechartModes.h"
//  TLMomentImageView.h
//  Freedom
//  Created by Super on 16/4/23.
//  Copyright © 2016年 Super. All rights reserved.
#import <UIKit/UIKit.h>
#import "WechartModes.h"
@protocol TLMomentMultiImageViewDelegate <NSObject>
- (void)momentViewClickImage:(NSArray *)images atIndex:(NSInteger)index;
@end
@protocol TLMomentDetailViewDelegate <TLMomentMultiImageViewDelegate>
@end
@protocol TLMomentViewDelegate <TLMomentDetailViewDelegate>
@end
@interface TLMomentBaseView : UIView
@property (nonatomic, assign) id<TLMomentViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *detailContainerView;
@property (nonatomic, strong) UIView *extensionContainerView;
@property (nonatomic, strong) TLMoment *moment;
@end
@interface TLMomentImageView : TLMomentBaseView
@end

@interface TLMomentDetailViewController : TLViewController
@property (nonatomic, strong) TLMoment *moment;
@end
