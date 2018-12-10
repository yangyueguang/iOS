//  TLBottleViewController.m
//  Freedom
// Created by Super
#import "WXBottleViewController.h"
#import <BlocksKit/BlocksKit.h>
typedef NS_ENUM(NSUInteger, TLBottleButtonType) {
    TLBottleButtonTypeThrow,
    TLBottleButtonTypePickUp,
    TLBottleButtonTypeMine,
};
@interface WXBottleButton : UIButton
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, assign) TLBottleButtonType type;
@property (nonatomic, assign) NSUInteger msgNumber;
- (id) initWithType:(TLBottleButtonType)type title:(NSString *)title iconPath:(NSString *)iconPath;
@end
@interface WXBottleButton ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@end
@implementation WXBottleButton
- (id)initWithType:(TLBottleButtonType)type title:(NSString *)title iconPath:(NSString *)iconPath{
    if (self = [super init]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.textLabel];
        [self p_addMasonry];
        self.type = type;
        self.title = title;
        self.iconPath = iconPath;
    }
    return self;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self.textLabel setText:title];
}
- (void)setIconPath:(NSString *)iconPath{
    _iconPath = iconPath;
    [self.iconImageView setImage:[UIImage imageNamed:iconPath]];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.textLabel.mas_top).mas_offset(9);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(-3);
    }];
}
#pragma mark - Getter -
- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [_textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setTextColor:[UIColor whiteColor]];
    }
    return _textLabel;
}
@end
@interface WXBottleViewController (){
    NSTimer *timer;
    UITapGestureRecognizer *tapGes;
}
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *bottomBoard;
@property (nonatomic, strong) WXBottleButton *throwButton;
@property (nonatomic, strong) WXBottleButton *pickUpButton;
@property (nonatomic, strong) WXBottleButton *mineButton;
@end
@implementation WXBottleViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"漂流瓶"];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.bottomBoard];
    [self.view addSubview:self.throwButton];
    [self.view addSubview:self.pickUpButton];
    [self.view addSubview:self.mineButton];
    [self p_addMasonry];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [timer invalidate];
    timer = [NSTimer bk_scheduledTimerWithTimeInterval:2.0 block:^(NSTimer *tm) {
        [tm invalidate];
        [self p_setNavBarHidden:YES];
    } repeats:NO];
    tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    [self.view addGestureRecognizer:tapGes];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self p_setNavBarHidden:NO];
    [timer invalidate];
    [self.view removeGestureRecognizer:tapGes];
}
#pragma mark - Event Response
- (void)boardButtonDown:(WXBottleButton *)sender{
    [SVProgressHUD showInfoWithStatus:sender.title];
}
- (void) didTapView{
    [timer invalidate];
    [self p_setNavBarHidden:![self.navigationController.navigationBar isHidden]];
}
- (void) rightBarButtonDown:(UIBarButtonItem *)sender{
}
#pragma mark - Private Methods
- (void) p_setNavBarHidden:(BOOL)hidden{
    if (hidden) {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rec = self.navigationController.navigationBar.frame;
            rec.origin.y = -TopHeight - 20;
            self.navigationController.navigationBar.frame = rec;
        } completion:^(BOOL finished) {
            [self.navigationController.navigationBar setHidden:YES];
        }];
    }else{
        [self.navigationController.navigationBar setHidden:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rec = self.navigationController.navigationBar.frame;
            rec.origin.y = 20;
            self.navigationController.navigationBar.frame = rec;
        }];
    }
}
- (void)p_addMasonry{
    [self.bottomBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
    }];
    
    CGFloat widthButton = 75;
    CGFloat space = (APPW - widthButton * 3) / 4;
    [self.pickUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.bottom.mas_equalTo(self.view);
        make.width.mas_equalTo(widthButton);
    }];
    [self.throwButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.bottom.mas_equalTo(self.pickUpButton);
        make.right.mas_equalTo(self.pickUpButton.mas_left).mas_offset(-space);
    }];
    [self.mineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.bottom.mas_equalTo(self.pickUpButton);
        make.left.mas_equalTo(self.pickUpButton.mas_right).mas_offset(space);
    }];
}
#pragma mark - Getter -
- (UIImageView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH"];
        int hour = [dateFormatter stringFromDate:[NSDate date]].intValue;
        if (hour >= 6 && hour <= 18) {
            [_backgroundView setImage:[UIImage imageNamed:@"bottle_backgroud_day"]];
        }else{
            [_backgroundView setImage:[UIImage imageNamed:@"bottle_backgroud_night"]];
        }
    }
    return _backgroundView;
}
- (UIImageView *)bottomBoard{
    if (_bottomBoard == nil) {
        _bottomBoard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottle_board"]];
    }
    return _bottomBoard;
}
- (WXBottleButton *)throwButton{
    if (_throwButton == nil) {
        _throwButton = [[WXBottleButton alloc] initWithType:TLBottleButtonTypeThrow title:@"扔一个" iconPath:@"bottle_button_throw"];
        [_throwButton addTarget:self action:@selector(boardButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _throwButton;
}
- (WXBottleButton *)pickUpButton{
    if (_pickUpButton == nil) {
        _pickUpButton = [[WXBottleButton alloc] initWithType:TLBottleButtonTypePickUp title:@"捡一个" iconPath:@"bottle_button_pickup"];
        [_pickUpButton addTarget:self action:@selector(boardButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickUpButton;
}
- (WXBottleButton *)mineButton{
    if (_mineButton == nil) {
        _mineButton = [[WXBottleButton alloc] initWithType:TLBottleButtonTypeMine title:@"我的瓶子" iconPath:@"bottle_button_mine"];
        [_mineButton addTarget:self action:@selector(boardButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mineButton;
}
@end
