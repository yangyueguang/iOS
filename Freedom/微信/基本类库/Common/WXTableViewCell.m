//  WXTableViewCell.m
//  Freedom
// Created by Super
#import "WXTableViewCell.h"
@implementation WXTableViewCell
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
    CGContextSetLineWidth(context, 1 * 2);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    if (self.topLineStyle != TLCellLineStyleNone) {
        CGContextBeginPath(context);
        CGFloat startX = (self.topLineStyle == TLCellLineStyleFill ? 0 : _leftSeparatorSpace);
        CGFloat endX = self.frame.size.width - self.rightSeparatorSpace;
        CGFloat y = 0;
        CGContextMoveToPoint(context, startX, y);
        CGContextAddLineToPoint(context, endX, y);
        CGContextStrokePath(context);
    }
    if (self.bottomLineStyle != TLCellLineStyleNone) {
        CGContextBeginPath(context);
        CGFloat startX = (self.bottomLineStyle == TLCellLineStyleFill ? 0 : _leftSeparatorSpace);
        CGFloat endX = self.frame.size.width - self.rightSeparatorSpace;
        CGFloat y = self.frame.size.height;
        CGContextMoveToPoint(context, startX, y);
        CGContextAddLineToPoint(context, endX, y);
        CGContextStrokePath(context);
    }
}
@end
