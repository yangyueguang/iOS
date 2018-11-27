//
//  StockDetailTopView.m
//  RRCP
#import "StockDetailTopView.h"
@interface StockDetailTopView ()
//实时价格
@end
@implementation StockDetailTopView
- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
      self.backgroundColor = [UIColor darkGrayColor];
      [self updateConstraintsIfNeeded];
  }
  return self;
}
- (void)updateConstraints {
  [super updateConstraints];

}

@end
