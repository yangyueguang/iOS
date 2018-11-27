//  TLPictureCarouselView.h
//  Freedom
// Created by Super
#import <UIKit/UIKit.h>
#define         DEFAULT_TIMEINTERVAL        5.0f
@protocol TLPictureCarouselProtocol <NSObject>
- (NSString *)pictureURL;
@end
@class TLPictureCarouselView;
@protocol TLPictureCarouselDelegate <NSObject>
- (void)pictureCarouselView:(TLPictureCarouselView *)pictureCarouselView
              didSelectItem:(id<TLPictureCarouselProtocol>)model;
@end
@interface TLPictureCarouselView : UIView
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) id<TLPictureCarouselDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
