//  TLScannerViewController.h
//  Freedom
//  Created by Super on 16/2/24.
#import <UIKit/UIkit.h>
#import "WXBaseViewController.h"
@class WXScannerViewController;
@protocol WXScannerDelegate <NSObject>
@optional
- (void)scannerViewControllerInitSuccess:(WXScannerViewController *)scannerVC;
- (void)scannerViewController:(WXScannerViewController *)scannerVC
                   initFailed:(NSString *)errorString;
- (void)scannerViewController:(WXScannerViewController *)scannerVC
                   scanAnswer:(NSString *)ansStr;
@end
@interface WXScannerViewController : WXBaseViewController
@property (nonatomic, assign) TLScannerType scannerType;
@property (nonatomic, assign) id<WXScannerDelegate>delegate;
@property (nonatomic, assign, readonly) BOOL isRunning;
- (void)startCodeReading;
- (void)stopCodeReading;
+ (void)scannerQRCodeFromImage:(UIImage *)image ans:(void (^)(NSString *ansStr))ans;
@end
