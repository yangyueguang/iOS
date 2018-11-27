//  TLMyQRCodeViewController.m
//  Freedom
//  Created by Super on 16/3/4.
#import "WXMyQRCodeViewController.h"
#import "WXScanningViewController.h"
#import "WXQRCodeViewController.h"
#import "WXUserHelper.h"
@interface WXMyQRCodeViewController ()
@property (nonatomic, strong) WXQRCodeViewController *qrCodeVC;
@end
@implementation WXMyQRCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.navigationItem setTitle:@"我的二维码"];
    [self.view addSubview:self.qrCodeVC.view];
    [self addChildViewController:self.qrCodeVC];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [self setUser:[WXUserHelper sharedHelper].user];
}
- (void)setUser:(WXUser *)user{
    _user = user;
    self.qrCodeVC.avatarURL = user.avatarURL;
    self.qrCodeVC.username = self.user.showName;
    self.qrCodeVC.subTitle = self.user.detailInfo.location;
    self.qrCodeVC.qrCode = self.user.userID;
    self.qrCodeVC.introduction = @"扫一扫上面的二维码图案，加我微信";
}
#pragma mark - Event Response
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    UIAlertAction *ac;
    if ([self.navigationController findViewController:@"TLScanningViewController"]) {
        ac = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    }else{
        ac = [UIAlertAction actionWithTitle:@"扫描二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WXScanningViewController *scannerVC = [[WXScanningViewController alloc] init];
            [scannerVC setDisableFunctionBar:YES];
            [self setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:scannerVC animated:YES];
        }];
    }
    [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"换个样式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.qrCodeVC saveQRCodeToSystemAlbum];
        }];
    } ac3:^UIAlertAction *{
        return ac;
    } completion:nil];
}
#pragma mark - Getter
- (WXQRCodeViewController *)qrCodeVC{
    if (_qrCodeVC == nil) {
        _qrCodeVC = [[WXQRCodeViewController alloc] init];
    }
    return _qrCodeVC;
}
@end
