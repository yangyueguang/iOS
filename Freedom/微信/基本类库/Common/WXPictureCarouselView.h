//  TLPictureCarouselView.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#define         DEFAULT_TIMEINTERVAL        5.0f
@protocol WXPictureCarouselProtocol <NSObject>
- (NSString *)pictureURL;
@end
@class WXPictureCarouselView;
@protocol WXPictureCarouselDelegate <NSObject>
- (void)pictureCarouselView:(WXPictureCarouselView *)pictureCarouselView
              didSelectItem:(id<WXPictureCarouselProtocol>)model;
@end
@interface WXPictureCarouselView : UIView
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) id<WXPictureCarouselDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
