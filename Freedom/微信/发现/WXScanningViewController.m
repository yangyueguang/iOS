//  TLScanningViewController.m
//  Freedom
// Created by Super
#import "WXScanningViewController.h"
#import "WXScannerViewController.h"
#import "WXWebViewController.h"
#import "WXMyQRCodeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa-Swift.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#define     HEIGHT_BOTTOM_VIEW      82
@interface WXScannerButton : UIButton
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *iconHLPath;
@property (nonatomic, assign) TLScannerType type;
@property (nonatomic, assign) NSUInteger msgNumber;
- (id) initWithType:(TLScannerType)type title:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath;
@end
@interface WXScannerButton ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;
@end
@implementation WXScannerButton
- (id) initWithType:(TLScannerType)type title:(NSString *)title iconPath:(NSString *)iconPath iconHLPath:(NSString *)iconHLPath{
    if (self = [super init]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.textLabel];
        [self p_addMasonry];
        self.type = type;
        self.title = title;
        self.iconPath = iconPath;
        self.iconHLPath = iconHLPath;
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
- (void)setIconHLPath:(NSString *)iconHLPath{
    _iconHLPath = iconHLPath;
    [self.iconImageView setHighlightedImage:[UIImage imageNamed:iconHLPath]];
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self.iconImageView setHighlighted:selected];
    [self.textLabel setHighlighted:selected];
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(self.iconImageView.mas_width);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
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
        [_textLabel setHighlightedTextColor:[UIColor greenColor]];
    }
    return _textLabel;
}
@end
@interface WXScanningViewController () <WXScannerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, assign) TLScannerType curType;
@property (nonatomic, strong) WXScannerViewController *scanVC;
@property (nonatomic, strong) UIBarButtonItem *albumBarButton;
@property (nonatomic, strong) UIButton *myQRButton;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) WXScannerButton *qrButton;
@property (nonatomic, strong) WXScannerButton *coverButton;
@property (nonatomic, strong) WXScannerButton *streetButton;
@property (nonatomic, strong) WXScannerButton *translateButton;
@end
@implementation WXScanningViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.scanVC.view];
    [self addChildViewController:self.scanVC];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.myQRButton];
    
    [self.bottomView addSubview:self.qrButton];
    [self.bottomView addSubview:self.coverButton];
    [self.bottomView addSubview:self.streetButton];
    [self.bottomView addSubview:self.translateButton];
    
    [self p_addMasonry];
}
- (void)setDisableFunctionBar:(BOOL)disableFunctionBar{
    _disableFunctionBar = disableFunctionBar;
    [self.bottomView setHidden:disableFunctionBar];
}
#pragma mark - TLScannerDelegate -
- (void)scannerViewControllerInitSuccess:(WXScannerViewController *)scannerVC{
    [self scannerButtonDown:self.qrButton];    // 初始化
}
- (void)scannerViewController:(WXScannerViewController *)scannerVC initFailed:(NSString *)errorString{
    [SVProgressHUD showErrorWithStatus:errorString];
    UIAlertController *alvc = [UIAlertController alertControllerWithTitle:@"错误" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alvc addAction:a];
    [self presentViewController:alvc animated:YES completion:nil];
}
- (void)scannerViewController:(WXScannerViewController *)scannerVC scanAnswer:(NSString *)ansStr{
    [self p_analysisQRAnswer:ansStr];
}
#pragma mark - Event Response -
- (void)scannerButtonDown:(WXScannerButton *)sender{
    if (sender.isSelected) {
        if (![self.scanVC isRunning]) {
            [self.scanVC startCodeReading];
        }
        return;
    }
    self.curType = sender.type;
    [self.qrButton setSelected:self.qrButton.type == sender.type];
    [self.coverButton setSelected:self.coverButton.type == sender.type];
    [self.streetButton setSelected:self.streetButton.type == sender.type];
    [self.translateButton setSelected:self.translateButton.type == sender.type];
    if (sender.type == TLScannerTypeQR) {
        [self.navigationItem setRightBarButtonItem:self.albumBarButton];
        [self.myQRButton setHidden:NO];
        [self.navigationItem  setTitle:@"二维码/条码"];
    }else{
        [self.navigationItem setRightBarButtonItem:nil];
        [self.myQRButton setHidden:YES];
        if (sender.type == TLScannerTypeCover) {
            [self.navigationItem setTitle:@"封面"];
        }else if (sender.type == TLScannerTypeStreet) {
            [self.navigationItem setTitle:@"街景"];
        }else if (sender.type == TLScannerTypeTranslate) {
            [self.navigationItem setTitle:@"翻译"];
        }
    }
    [self.scanVC setScannerType:sender.type];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        [SVProgressHUD showWithStatus:@"扫描中，请稍候"];
        [WXScannerViewController scannerQRCodeFromImage:image ans:^(NSString *ansStr) {
            [SVProgressHUD dismiss];
            if (ansStr == nil) {
                UIAlertController *alvc = [UIAlertController alertControllerWithTitle:@"扫描失败" message:@"请换张图片，或换个设备重试~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.scanVC startCodeReading];
                }];
                [alvc addAction:a];
                [self presentViewController:alvc animated:YES completion:nil];
            }
            else {
                [self p_analysisQRAnswer:ansStr];
            }
        }];
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [SVProgressHUD showWithStatus:@"扫描中，请稍候"];
        [WXScannerViewController scannerQRCodeFromImage:image ans:^(NSString *ansStr) {
            [SVProgressHUD dismiss];
            if (ansStr == nil) {
                UIAlertController *alvc = [UIAlertController alertControllerWithTitle:@"扫描失败" message:@"请换张图片，或换个设备重试~" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.scanVC startCodeReading];
                }];
                [alvc addAction:a];
                [self presentViewController:alvc animated:YES completion:nil];
            }
            else {
                [self p_analysisQRAnswer:ansStr];
            }
        }];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)albumBarButtonDown:(UIBarButtonItem *)sender{
    [self.scanVC stopCodeReading];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)myQRButtonDown{
    WXMyQRCodeViewController *myQRCodeVC = [[WXMyQRCodeViewController alloc] init];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:myQRCodeVC animated:YES];
}
#pragma mark - Private Methods -
- (void)p_analysisQRAnswer:(NSString *)ansStr{
    if ([ansStr hasPrefix:@"http"]) {
        WXWebViewController *webVC = [[WXWebViewController alloc] init];
        [webVC setUrl:ansStr];
        __block id vc = self.navigationController.rootViewController;
        [self.navigationController popViewControllerAnimated:NO completion:^(BOOL finished) {
            if (finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [vc setHidesBottomBarWhenPushed:YES];
                    [[vc navigationController] pushViewController:webVC animated:YES];
                    [vc setHidesBottomBarWhenPushed:NO];
                });
            }
        }];
    }else{
        UIAlertController *alvc = [UIAlertController alertControllerWithTitle:@"扫描结果" message:ansStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.scanVC startCodeReading];
        }];
        [alvc addAction:a];
        [self presentViewController:alvc animated:YES completion:nil];
    }
}
- (void)p_addMasonry{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(HEIGHT_BOTTOM_VIEW);
    }];
    
    // bottom
    CGFloat widthButton = 35;
    CGFloat hightButton = 55;
    CGFloat space = (APPW - widthButton * 4) / 5;
    [self.qrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView);
        make.left.mas_equalTo(self.bottomView).mas_offset(space);
        make.width.mas_equalTo(widthButton);
        make.height.mas_equalTo(hightButton);
    }];
    [self.coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.width.mas_equalTo(self.qrButton);
        make.left.mas_equalTo(self.qrButton.mas_right).mas_offset(space);
    }];
    [self.streetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.width.mas_equalTo(self.qrButton);
        make.left.mas_equalTo(self.coverButton.mas_right).mas_offset(space);
    }];
    [self.translateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.width.mas_equalTo(self.qrButton);
        make.left.mas_equalTo(self.streetButton.mas_right).mas_offset(space);
    }];
    [self.myQRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_offset(-40);
    }];
}
#pragma mark - Getter -
- (WXScannerViewController *)scanVC{
    if (_scanVC == nil) {
        _scanVC = [[WXScannerViewController alloc] init];
        [_scanVC setDelegate:self];
    }
    return _scanVC;
}
- (UIView *)bottomView{
    if (_bottomView == nil) {
        UIView *blackView = [[UIView alloc] init];
        [blackView setBackgroundColor:[UIColor blackColor]];
        [blackView setAlpha:0.5f];
        _bottomView = [[UIView alloc] init];
        [_bottomView addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_bottomView);
        }];
    }
    return _bottomView;
}
- (WXScannerButton *)qrButton{
    if (_qrButton == nil) {
        _qrButton = [[WXScannerButton alloc] initWithType:TLScannerTypeQR title:@"扫码" iconPath:@"u_scanQRCode" iconHLPath:@"u_scanQRCodeHL"];
        [_qrButton addTarget:self action:@selector(scannerButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrButton;
}
- (WXScannerButton *)coverButton{
    if (_coverButton == nil) {
        _coverButton = [[WXScannerButton alloc] initWithType:TLScannerTypeCover title:@"封面" iconPath:@"scan_book" iconHLPath:@"scan_book_HL"];
        [_coverButton addTarget:self action:@selector(scannerButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}
- (WXScannerButton *)streetButton{
    if (_streetButton == nil) {
        _streetButton = [[WXScannerButton alloc] initWithType:TLScannerTypeStreet title:@"街景" iconPath:@"scan_street" iconHLPath:@"scan_street_HL"];
        [_streetButton addTarget:self action:@selector(scannerButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _streetButton;
}
- (WXScannerButton *)translateButton{
    if (_translateButton == nil) {
        _translateButton = [[WXScannerButton alloc] initWithType:TLScannerTypeTranslate title:@"翻译" iconPath:@"scan_word" iconHLPath:@"scan_word_HL"];
        [_translateButton addTarget:self action:@selector(scannerButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _translateButton;
}
- (UIBarButtonItem *)albumBarButton{
    if (_albumBarButton == nil) {
        _albumBarButton = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(albumBarButtonDown:)];
    }
    return _albumBarButton;
}
- (UIButton *)myQRButton{
    if (_myQRButton == nil) {
        _myQRButton = [[UIButton alloc] init];
        [_myQRButton setTitle:@"我的二维码" forState:UIControlStateNormal];
        [_myQRButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_myQRButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_myQRButton addTarget:self action:@selector(myQRButtonDown) forControlEvents:UIControlEventTouchUpInside];
        [_myQRButton setHidden:YES];
    }
    return _myQRButton;
}
@end
