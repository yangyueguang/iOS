
//  TLGroupQRCodeViewController.m
//  Freedom
// Created by Super
#import "WXGroupQRCodeViewController.h"
#import "WXQRCodeViewController.h"
#import <XCategory/NSDate+expanded.h>
@interface WXGroupQRCodeViewController ()
@property (nonatomic, strong) WXQRCodeViewController *qrCodeVC;
@end
@implementation WXGroupQRCodeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBACOLOR(46.0, 49.0, 50.0, 1.0)];
    [self.navigationItem setTitle:@"群二维码名片"];
    
    [self.view addSubview:self.qrCodeVC.view];
    [self addChildViewController:self.qrCodeVC];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonDown:)];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}
- (void)setGroup:(WXGroup *)group{
    _group = group;
    self.qrCodeVC.avatarPath = group.groupAvatarPath;
    self.qrCodeVC.username = group.groupName;
    self.qrCodeVC.qrCode = group.groupID;
    NSDate *date = [NSDate dateWithDaysFromNow:7];
    self.qrCodeVC.introduction = [NSString stringWithFormat:@"该二维码7天内(%lu月%lu日前)有效，重新进入将更新", (long)date.month, (long)date.day];
}
#pragma mark - Event Response -
- (void)rightBarButtonDown:(UIBarButtonItem *)sender{
    [self showAlerWithtitle:nil message:nil style:UIAlertControllerStyleActionSheet ac1:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"用邮件发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showErrorWithStatus:@"正在开发"];
        }];
    } ac2:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.qrCodeVC saveQRCodeToSystemAlbum];
        }];
    } ac3:^UIAlertAction *{
        return [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    } completion:nil];
}
#pragma mark - Getter -
- (WXQRCodeViewController *)qrCodeVC{
    if (_qrCodeVC == nil) {
        _qrCodeVC = [[WXQRCodeViewController alloc] init];
    }
    return _qrCodeVC;
}
@end
