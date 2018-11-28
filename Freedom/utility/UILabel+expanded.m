//
//  UILabel+expanded.m
#import "UILabel+expanded.h"
@implementation UILabel (expanded)
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext{
    return [self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:NSTextAlignmentLeft];
}
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment setLineSpacing:(float)afloat{
    UILabel *lblTemp=[self labelWithFrame:aframe font:afont color:acolor text:atext textAlignment:aalignment];
    if (!aframe.size.height) {
        lblTemp.numberOfLines=0;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lblTemp.text];
        NSMutableParagraphStyle *paragraphStyleT = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyleT setLineSpacing:afloat];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyleT range:NSMakeRange(0, [atext length])];
        lblTemp.attributedText = attributedString;
        CGSize size = [lblTemp sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        lblTemp.frame=aframe;
    }
    return lblTemp;
}
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment{
    UILabel *baseLabel=[[UILabel alloc] initWithFrame:aframe];
    if(afont)baseLabel.font=afont;
    if(acolor)baseLabel.textColor=acolor;
    baseLabel.text=atext;
    baseLabel.textAlignment=aalignment;
    baseLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height>20){
        baseLabel.numberOfLines=0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    baseLabel.backgroundColor=[UIColor clearColor];
    baseLabel.highlightedTextColor=acolor;
    return baseLabel;
}
@end
