//  YMShowImageView.h
//  WFCoretext
//  Created by Super on 14/11/3.
#import <UIKit/UIKit.h>
typedef  void(^didRemoveImage)(void);
@interface YMShowImageView : UIView<UIScrollViewDelegate>{
    UIImageView *showImage;
}
@property (nonatomic,copy) didRemoveImage removeImg;
- (void)show:(UIView *)bgView didFinish:(didRemoveImage)tempBlock;
- (id)initWithFrame:(CGRect)frame byClick:(NSInteger)clickTag appendArray:(NSArray *)appendArray;
@end
