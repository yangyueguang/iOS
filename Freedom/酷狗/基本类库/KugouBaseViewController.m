//  KugouBaseViewController.m
//  Created by Super on 16/8/31.
//  Copyright © 2016年 Super. All rights reserved.
//
#import "KugouBaseViewController.h"
#define ItemImagewidth 20.0f
#define ItemButtonwidth 50.0f
@interface KugouBaseViewController ()
@end
@implementation KugouBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBar];
    if ([self.navigationController viewControllers].count>1) {
        [self addBackItem];
    }
    [self addleftItem:@""];
    [self addrightItem:@""];
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
/*添加NavBar*/
-(void)setNavBar{
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,APPW, 64)];
    _titleLabel = [[UILabel alloc] init];
    _titleLine  = [[UILabel alloc] init];
    _titleLine.backgroundColor = [UIColor grayColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 1;
    _titleLabel.textColor = whitecolor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = BoldFont(17);
    [_navBar addSubview:_titleLabel];
    [_navBar addSubview:_titleLine];
    
    _navBar.backgroundColor = RGBCOLOR(51, 124, 200);
    
    _titleLabel.frame = CGRectMake(0, 20, APPW, 64-20);
    _titleLine.frame = CGRectMake(0, 64, APPW, 0.26);
    self.titleLabel.text = self.title;
    [self.view addSubview:_navBar];
}
-(void)addBackItem{
    self.backItem.image = [UIImage imageNamed:@"backButton"];
}
-(UIImageView *)backItem{
    if (!_backItem){
        _backItem = [[UIImageView alloc]init];
        _backItem.contentMode = UIViewContentModeScaleAspectFit;
        _backItem.userInteractionEnabled = YES;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backItemTouched:)];
        [_backItem addGestureRecognizer:backTap];
        [_navBar addSubview:_backItem];
        _backItem.frame = CGRectMake(5, 30, ItemImagewidth, ItemImagewidth);
    }
    return _backItem;
}
/*添加左按钮，传入图片名
 *  @param leftItemImageName*/
-(void)addleftItem:(NSString *)leftItemImageName{
    if (leftItemImageName.length!=0){
        if (_backItem!=nil) {
            [_backItem removeFromSuperview];
        }self.leftItem.image = [UIImage imageNamed:leftItemImageName];
    }
}
-(UIImageView *)leftItem{
    if (!_leftItem) {
        _leftItem = [[UIImageView alloc]init];
        _leftItem.userInteractionEnabled = YES;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftItemTouched:)];
        [_leftItem addGestureRecognizer:backTap];
        [_navBar addSubview:_leftItem];
        _leftItem.frame = CGRectMake(5, 28, ItemImagewidth, ItemImagewidth);
    }return _leftItem;
}
/*添加右按钮，传入图片名
 *  @param rightItemImageName*/
-(void)addrightItem:(NSString *)rightItemImageName{
    if (rightItemImageName.length!=0){
        self.rightItem.image = [UIImage imageNamed:rightItemImageName];
    }
}
-(UIImageView *)rightItem{
    if (!_rightItem) {
        _rightItem = [[UIImageView alloc]init];
        _rightItem.userInteractionEnabled = YES;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightItemTouched:)];
        [_rightItem addGestureRecognizer:backTap];
        [_navBar addSubview:_rightItem];
        _rightItem.frame = CGRectMake(APPW-35, 28, ItemImagewidth, ItemImagewidth);
    }return _rightItem;
}
/*添加左侧按钮。传入一个Title
 *  @param Title*/
- (void)addleftButton:(NSString *)Title{
    if (Title.length!=0){
        [self.leftButton setTitle:Title forState:0];
    }
}
-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc]init];
        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.titleLabel.font = fontSmallTitle;
        [_leftButton setTitleColor:[UIColor whiteColor] forState:0];
        [_navBar addSubview:_leftButton];
        _leftButton.frame = CGRectMake(5, 28, ItemButtonwidth, ItemImagewidth);
    }return _leftButton;
}
/*添加右侧按钮。传入一个Title
 *  @param Title*/
- (void)addrightButton:(NSString *)Title{
    if (Title.length!=0){
        [self.rightButton setTitle:Title forState:0];
    }
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.titleLabel.font = fontSmallTitle;
        [_rightButton setTitleColor:[UIColor whiteColor] forState:0];
        [_navBar addSubview:_rightButton];
        _rightButton.frame =  CGRectMake(APPW-55, 28, ItemButtonwidth, ItemImagewidth);
    }return _rightButton;
}
- (void)backItemTouched:(id)sender{
    [self goBack];
}
-(void)leftItemTouched:(id)sender{
    DLog(@"用到图片的时候重写leftItemTouched方法");
}
- (void)rightItemTouched:(id)sender{
    DLog(@"用到图片的时候重写rightItemTouched方法");
}
- (void)leftButtonClick:(id)sender{
    DLog(@"用到按钮的时候重写leftButtonClick方法");
}
- (void)rightButtonClick:(id)sender{
    DLog(@"用到按钮的时候重写rightButtonClick方法");
}
-(void)goBack{
    NSArray* vcarr = [self.navigationController viewControllers];
    if (vcarr.count > 1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
