//
//  StockChartTitleView.m
//  RRCP
#import "StockChartTitleView.h"
@interface StockChartTitleView () {
  CGFloat _btnWidth;
}
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) NSMutableArray *titleBtnArray;
@property(nonatomic, strong) UIView *indicateLine;
@end
@implementation StockChartTitleView
- (instancetype)initWithTitleArray:(NSArray *)titleArray {
  self = [super initWithFrame:CGRectZero];
  if (self) {
    _titleArray = titleArray;
    _titleBtnArray = [NSMutableArray array];
    self.frame = CGRectMake(0, 0, APPW, 44);
    CGFloat btnWidth = APPW / titleArray.count;
    _btnWidth = btnWidth;
    for (int i = 0; i < titleArray.count; i++) {
      UIButton *btn = [[UIButton alloc]
          initWithFrame:CGRectMake(i * btnWidth, 0, btnWidth, 44)];
      [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
      [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
      if (i == 0) {
        [btn setTitleColor:UIColor(60, 177, 227, 1)
                  forState:UIControlStateNormal];
      } else {
        [btn setTitleColor:[UIColor colorWithWhite:102/255.0 alpha:1]
                  forState:UIControlStateNormal];
      }
      btn.tag = i;
      [btn addTarget:self action:@selector(clickBtn:)
       forControlEvents:UIControlEventTouchDown];
      [self addSubview:btn];
      [_titleBtnArray addObject:btn];
    }
    _indicateLine = [[UIView alloc] init];
    _indicateLine.backgroundColor = UIColor(60, 177, 227, 1);
    _indicateLine.layer.cornerRadius = 1;
    _indicateLine.layer.masksToBounds = YES;
    [self addSubview:_indicateLine];
    WS(weakSelf);
    UIButton *firstBtn = (UIButton *)_titleBtnArray[0];
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = RGBCOLOR(245, 245, 245);
    [self addSubview:bottomView];
    [_indicateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstBtn);
        make.bottom.equalTo(weakSelf).offset(-1);
        make.height.mas_equalTo(@2);
        make.width.mas_equalTo(@(btnWidth - 10));
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(weakSelf);
      make.left.equalTo(weakSelf);
      make.right.equalTo(weakSelf);
      make.height.mas_equalTo(@1);
    }];
  }
  return self;
}
- (void)clickBtn:(UIButton *)btn {
  NSInteger tag = btn.tag;
  [self setItemSelected:tag];
  if (self.titleClickBlock) {
    self.titleClickBlock(tag);
  }
}
- (void)setItemSelected:(NSInteger)column {
  for (int i = 0; i < _titleBtnArray.count; i++) {
    UIButton *btn = _titleBtnArray[i];
    if (i == column) {
      [btn setTitleColor:UIColor(60, 177, 227, 1)
                forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor colorWithWhite:102/255.0 alpha:1]
                forState:UIControlStateNormal];
    }
  }
  CGFloat btnWidth = APPW / _titleBtnArray.count;
  _indicateLine.transform =
      CGAffineTransformMakeTranslation(btnWidth * column, 0);
}
- (void)setScrollDistance:(CGFloat)ratio {
  _indicateLine.transform =
      CGAffineTransformMakeTranslation(ratio * _btnWidth, 0);
}
@end
