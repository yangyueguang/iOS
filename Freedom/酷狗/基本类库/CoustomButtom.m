//  CoustomButtom.m
//  CLKuGou
//  Created by Darren on 16/7/30.
#import "CoustomButtom.h"
@implementation CoustomButtom
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片居中
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }return self;
}
- (void)setHighlighted:(BOOL)highlighted{}
/*覆盖父类的方法，设置button的文字位置*/
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = self.frame.size.width;
    CGFloat titleX = 0;
    CGFloat titleY = self.frameHeight - 25;
    CGFloat titleH = 25;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = self.frameWidth-10;
    CGFloat imageX = (self.frameWidth-imageW)*0.5;
    CGFloat imageH = self.frameHeight-35;
    CGFloat imageY = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
@end
