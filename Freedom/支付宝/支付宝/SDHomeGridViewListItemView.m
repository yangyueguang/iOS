//  SDHomeGridViewListItemView.m
//  GSD_ZHIFUBAO
//  Created by Super on 15-6-3.
#import "SDHomeGridViewListItemView.h"
#import "UIButton+WebCache.h"
#import "UIView+SDExtension.h"
@implementation SDHomeGridItemModel
@end
@implementation SDHomeGridViewListItemView{
    UIButton *_button;
    UIButton *_iconView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {[self initialization];}return self;
}
- (void)initialization{
    self.backgroundColor = [UIColor whiteColor];
    _button = [[UIButton alloc] init];
    [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
    UIButton *icon = [[UIButton alloc] init];
    [icon setImage:[UIImage imageNamed:Pdelete] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(iconViewClicked) forControlEvents:UIControlEventTouchUpInside];
    icon.hidden = YES;
    [self addSubview:icon];
    _iconView = icon;
    UILongPressGestureRecognizer *longPressed = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemLongPressed:)];
    [self addGestureRecognizer:longPressed];
}
#pragma mark - actions
- (void)itemLongPressed:(UILongPressGestureRecognizer *)longPressed{
    if (self.itemLongPressedOperationBlock) {
        self.itemLongPressedOperationBlock(longPressed);
    }
}
- (void)buttonClicked{
    if (self.buttonClickedOperationBlock) {self.buttonClickedOperationBlock(self);}
}
- (void)iconViewClicked{
    if (self.iconViewClickedOperationBlock) {self.iconViewClickedOperationBlock(self);}
}
#pragma mark - properties
- (void)setItemModel:(SDHomeGridItemModel *)itemModel{
    _itemModel = itemModel;
    if (itemModel.title) {
        [_button setTitle:itemModel.title forState:UIControlStateNormal];
    }
    if (itemModel.imageResString) {
        if ([itemModel.imageResString hasPrefix:@"http:"]) {
            [_button sd_setImageWithURL:[NSURL URLWithString:itemModel.imageResString] forState:UIControlStateNormal placeholderImage:nil];
        } else {
            [_button setImage:[UIImage imageNamed:itemModel.imageResString] forState:UIControlStateNormal];
        }
    }
}
- (void)setHidenIcon:(BOOL)hidenIcon{
    _hidenIcon = hidenIcon;
    _iconView.hidden = hidenIcon;
}
- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    [_iconView setImage:iconImage forState:UIControlStateNormal];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 10;
    _button.frame = self.bounds;
    CGFloat h = H(_button);
    CGFloat w = W(_button);
    [_button setImageEdgeInsets:UIEdgeInsetsMake(h*0.2, w*0.32, h*0.3, w*0.32)];
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(h*0.6, -w*0.4, 0, 0)];
    _iconView.frame = CGRectMake(self.sd_width - _iconView.sd_width - margin, margin, 20, 20);
}
@end
