//  TLTableViewCell.m
//  Freedom
// Created by Super
#import "TLTableViewCell.h"
@implementation TLTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _leftSeparatorSpace = 15.0f;
        _topLineStyle = TLCellLineStyleNone;
        _bottomLineStyle = TLCellLineStyleDefault;
    }
    return self;
}
- (void)setTopLineStyle:(TLCellLineStyle)topLineStyle{
    _topLineStyle = topLineStyle;
    [self setNeedsDisplay];
}
- (void)setBottomLineStyle:(TLCellLineStyle)bottomLineStyle{
    _bottomLineStyle = bottomLineStyle;
    [self setNeedsDisplay];
}
- (void)setLeftSeparatorSpace:(CGFloat)leftSeparatorSpace{
    _leftSeparatorSpace = leftSeparatorSpace;
    [self setNeedsDisplay];
}
- (void)setRightSeparatorSpace:(CGFloat)rightSeparatorSpace{
    _rightSeparatorSpace = rightSeparatorSpace;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, BORDER_WIDTH_1PX * 2);
    CGContextSetStrokeColorWithColor(context, colorGrayLine.CGColor);
    if (self.topLineStyle != TLCellLineStyleNone) {
        CGContextBeginPath(context);
        CGFloat startX = (self.topLineStyle == TLCellLineStyleFill ? 0 : _leftSeparatorSpace);
        CGFloat endX = self.frameWidth - self.rightSeparatorSpace;
        CGFloat y = 0;
        CGContextMoveToPoint(context, startX, y);
        CGContextAddLineToPoint(context, endX, y);
        CGContextStrokePath(context);
    }
    if (self.bottomLineStyle != TLCellLineStyleNone) {
        CGContextBeginPath(context);
        CGFloat startX = (self.bottomLineStyle == TLCellLineStyleFill ? 0 : _leftSeparatorSpace);
        CGFloat endX = self.frameWidth - self.rightSeparatorSpace;
        CGFloat y = self.frameHeight;
        CGContextMoveToPoint(context, startX, y);
        CGContextAddLineToPoint(context, endX, y);
        CGContextStrokePath(context);
    }
}
@end
