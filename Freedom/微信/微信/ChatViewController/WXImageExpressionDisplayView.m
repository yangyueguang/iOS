//  WXImageExpressionDisplayView.m
//  Freedom
//  Created by Super on 16/3/16.
#import "WXImageExpressionDisplayView.h"
#import "UIImage+GIF.h"
@interface WXImageExpressionDisplayView ()
@property (nonatomic, strong) UIImageView *bgLeftView;
@property (nonatomic, strong) UIImageView *bgCenterView;
@property (nonatomic, strong) UIImageView *bgRightView;
@property (nonatomic, strong) UIImageView *imageView;
@end
@implementation WXImageExpressionDisplayView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, 150, 162)]) {
        [self addSubview:self.bgLeftView];
        [self addSubview:self.bgCenterView];
        [self addSubview:self.bgRightView];
        [self addSubview:self.imageView];
        [self p_addMasonry];
    }
    return self;
}
- (void)displayEmoji:(TLEmoji *)emoji atRect:(CGRect)rect{
    [self setRect:rect];
    [self setEmoji:emoji];
}
static NSString *curID;
- (void)setEmoji:(TLEmoji *)emoji{
    if (_emoji == emoji) {
        return;
    }
    _emoji = emoji;
    curID = emoji.emojiID;
    NSData *data = [NSData dataWithContentsOfFile:emoji.emojiPath];
    if (data) {
        [self.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
    }else{
        NSString *urlString = [NSString stringWithFormat:@"http://123.57.155.230:8080/ibiaoqing/admin/expre/download.do?pId=%@",emoji.emojiID];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:emoji.emojiURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if ([urlString containsString:curID]) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                    if ([urlString containsString:curID]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.imageView setImage:[UIImage sd_animatedGIFWithData:data]];
                        });
                    }
                });
            }
        }];
    }
}
- (void)setRect:(CGRect)rect{
    CGRect frame = self.frame;
    frame.origin.y = rect.origin.y - self.frame.size.height + 13;
    self.frame = frame;
    CGFloat w = 150 - 25;
    CGFloat centerX = rect.origin.x + rect.size.width / 2;
    if (rect.origin.x + rect.size.width < self.frame.size.width) {     // 箭头在左边
        self.center = CGPointMake(centerX + (150 - w / 4 - 25) / 2 - 16,self.center.y);
        [self.bgLeftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w / 4);
        }];
    }else if (APPW - rect.origin.x < self.frame.size.width) {   // 箭头在右边
        self.center = CGPointMake(centerX - (150 - w / 4 - 25) / 2 + 16,self.center.y);
        [self.bgLeftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w / 4 * 3);
        }];
    }else{
        self.center = CGPointMake(centerX,self.center.y);
        [self.bgLeftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w / 2);
        }];
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.bgLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.mas_equalTo(self);
    }];
    [self.bgCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgLeftView.mas_right);
        make.top.and.bottom.mas_equalTo(self.bgLeftView);
        make.width.mas_equalTo(25);
    }];
    [self.bgRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgCenterView.mas_right);
        make.top.and.bottom.mas_equalTo(self.bgLeftView);
        make.right.mas_equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(10);
        make.left.mas_equalTo(self).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-10);
        make.height.mas_equalTo(self.imageView.mas_width);
    }];
}
#pragma mark - Getter -
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UIImageView *)bgLeftView{
    if (_bgLeftView == nil) {
        _bgLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiKB_bigTips_left"]];
    }
    return _bgLeftView;
}
- (UIImageView *)bgCenterView{
    if (_bgCenterView == nil) {
        _bgCenterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiKB_bigTips_middle"]];
    }
    return _bgCenterView;
}
- (UIImageView *)bgRightView{
    if (_bgRightView == nil) {
        _bgRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emojiKB_bigTips_right"]];
    }
    return _bgRightView;
}
@end
