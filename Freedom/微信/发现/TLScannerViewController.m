//  TLScannerViewController.m
//  Freedom
//  Created by Super on 16/2/24.
#import "TLScannerViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface TLScannerView : UIView
/*隐藏扫描指示器，默认NO*/
@property (nonatomic, assign) BOOL hiddenScannerIndicator;
- (void)startScanner;
- (void)stopScanner;
@end
@interface TLScannerView (){
    NSTimer *timer;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topLeftView;
@property (nonatomic, strong) UIImageView *topRightView;
@property (nonatomic, strong) UIImageView *btmLeftView;
@property (nonatomic, strong) UIImageView *btmRightView;
@property (nonatomic, strong) UIImageView *scannerLine;
@end
@implementation TLScannerView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setClipsToBounds:YES];
        [self addSubview:self.bgView];
        [self addSubview:self.topLeftView];
        [self addSubview:self.topRightView];
        [self addSubview:self.btmLeftView];
        [self addSubview:self.btmRightView];
        [self addSubview:self.scannerLine];
        [self p_addMasonry];
    }
    return self;
}
#pragma mark - Public Methods -
- (void)startScanner{
    [self stopScanner];
    timer = [NSTimer bk_scheduledTimerWithTimeInterval:1.0 / 60 block:^(NSTimer *timer) {
        if (self.hiddenScannerIndicator) {
            return;
        }
        self.scannerLine.center = CGPointMake(self.bgView.center.x,self.scannerLine.center.y);
        self.scannerLine.frameWidth = self.bgView.frameWidth * 1.4;
        self.scannerLine.frameHeight = 10;
        if (self.scannerLine.frameY + self.scannerLine.frameHeight >= self.frameHeight) {
            self.scannerLine.frameY = 0;
        }else{
            self.scannerLine.frameY ++;
        }
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)stopScanner{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}
- (void)setHiddenScannerIndicator:(BOOL)hiddenScannerIndicator{
    if (hiddenScannerIndicator == _hiddenScannerIndicator) {
        return;
    }
    
    if (hiddenScannerIndicator) {
        self.scannerLine.frameY = 0;
        [self.scannerLine setHidden:YES];
        _hiddenScannerIndicator = hiddenScannerIndicator;
    }else{
        _hiddenScannerIndicator = hiddenScannerIndicator;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.scannerLine.frameY = 0;
            [self.scannerLine setHidden:hiddenScannerIndicator];
        });
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_topLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self);
        make.width.and.height.mas_lessThanOrEqualTo(self);
    }];
    [_topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(self);
        make.width.and.height.mas_lessThanOrEqualTo(self);
    }];
    [_btmLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.mas_equalTo(self);
        make.width.and.height.mas_lessThanOrEqualTo(self);
    }];
    [_btmRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(self);
        make.width.and.height.mas_lessThanOrEqualTo(self);
    }];
}
#pragma mark - Getter -
- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:[UIColor clearColor]];
        [_bgView.layer setMasksToBounds:YES];
        [_bgView.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_bgView.layer setBorderColor:[UIColor whiteColor].CGColor];
    }
    return _bgView;
}
- (UIImageView *)topLeftView{
    if (_topLeftView == nil) {
        _topLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanner_top_left"]];
    }
    return _topLeftView;
}
- (UIImageView *)topRightView{
    if (_topRightView == nil) {
        _topRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanner_top_right"]];
    }
    return _topRightView;
}
- (UIImageView *)btmLeftView{
    if (_btmLeftView == nil) {
        _btmLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanner_bottom_left"]];
    }
    return _btmLeftView;
}
- (UIImageView *)btmRightView{
    if (_btmRightView == nil) {
        _btmRightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanner_bottom_right"]];
    }
    return _btmRightView;
}
- (UIImageView *)scannerLine{
    if (_scannerLine == nil) {
        _scannerLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanner_line"]];
        [_scannerLine setFrame:CGRectZero];
    }
    return _scannerLine;
}
@end
@interface TLScannerBackgroundView : UIView
- (void)addMasonryWithContainView:(UIView *)containView;
@end
@interface TLScannerBackgroundView ()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *btmView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@end
@implementation TLScannerBackgroundView
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topView];
        [self addSubview:self.btmView];
        [self addSubview:self.leftView];
        [self addSubview:self.rightView];
    }
    return self;
}
#pragma mark - Public Methods -
- (void)addMasonryWithContainView:(UIView *)containView{
    UIView *scannerView = containView;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(scannerView.mas_top);
    }];
    [self.btmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self);
        make.top.mas_equalTo(scannerView.mas_bottom);
    }];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(scannerView.mas_left);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.btmView.mas_top);
    }];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scannerView.mas_right);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.btmView.mas_top);
    }];
}
#pragma mark - Getter -
- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:RGBACOLOR(71, 70, 73, 1.0)];
    }
    return _topView;
}
- (UIView *)btmView{
    if (_btmView == nil) {
        _btmView = [[UIView alloc] init];
        [_btmView setBackgroundColor:RGBACOLOR(71, 70, 73, 1.0)];
    }
    return _btmView;
}
- (UIView *)leftView{
    if (_leftView == nil) {
        _leftView = [[UIView alloc] init];
        [_leftView setBackgroundColor:RGBACOLOR(71, 70, 73, 1.0)];
    }
    return _leftView;
}
- (UIView *)rightView{
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
        [_rightView setBackgroundColor:RGBACOLOR(71, 70, 73, 1.0)];
    }
    return _rightView;
}
@end
@interface TLScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) UILabel *introudctionLabel;
@property (nonatomic, strong) TLScannerView *scannerView;
@property (nonatomic, strong) TLScannerBackgroundView *scannerBGView;
@property (nonatomic, strong) AVCaptureSession *scannerSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end
@implementation TLScannerViewController
+ (void)scannerQRCodeFromImage:(UIImage *)image ans:(void (^)(NSString *ansStr))ans{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = (UIImagePNGRepresentation(image) ? UIImagePNGRepresentation(image) :UIImageJPEGRepresentation(image, 1));
        CIImage *ciImage = [CIImage imageWithData:imageData];
        NSString  *ansStr = nil;
        if (ciImage) {
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:nil] options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
            NSArray *features = [detector featuresInImage:ciImage];
            if (features.count) {
                for (CIFeature *feature in features) {
                    if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
                        ansStr = ((CIQRCodeFeature *)feature).messageString;
                        break;
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            ans(ansStr);
        });
    });
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:self.introudctionLabel];
    [self.view addSubview:self.scannerView];
    [self.view addSubview:self.scannerBGView];
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    
    [self p_addMasonry];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.scannerSession) {
        if (_delegate && [_delegate respondsToSelector:@selector(scannerViewControllerInitSuccess:)]) {
            [_delegate scannerViewControllerInitSuccess:self];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(scannerViewController:initFailed:)]) {
            [_delegate scannerViewController:self initFailed:@"相机初始化失败"];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.scannerSession isRunning]) {
        [self stopCodeReading];
    }
}
#pragma mark - Public Methods -
- (void)setScannerType:(TLScannerType)scannerType{
    if (_scannerType == scannerType) {
        return;
    }
    _scannerType = scannerType;
    
    CGFloat width = 0;
    CGFloat height = 0;
    if (scannerType == TLScannerTypeQR) {
        [self.introudctionLabel setText:@"将二维码/条码放入框内，即可自动扫描"];
        width = height = WIDTH_SCREEN * 0.7;
    }else if (scannerType == TLScannerTypeCover) {
        [self.introudctionLabel setText:@"将书、CD、电影海报放入框内，即可自动扫描"];
        width = height = WIDTH_SCREEN * 0.85;
    }else if (scannerType == TLScannerTypeStreet) {
        [self.introudctionLabel setText:@"扫一下周围环境，寻找附近街景"];
        width = height = WIDTH_SCREEN * 0.85;
    }else if (scannerType == TLScannerTypeTranslate) {
        width = WIDTH_SCREEN * 0.7;
        height = 55;
        [self.introudctionLabel setText:@"将英文单词放入框内"];
    }
    [self.scannerView setHiddenScannerIndicator:scannerType == TLScannerTypeTranslate];
    [UIView animateWithDuration:0.3 animations:^{
        [self.scannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        [self.view layoutIfNeeded];
    }];
    
    // rect值范围0-1，基准点在右上角
    CGRect rect = CGRectMake(self.scannerView.frameY / HEIGHT_SCREEN, self.scannerView.frameX / WIDTH_SCREEN, self.scannerView.frameHeight / HEIGHT_SCREEN, self.scannerView.frameWidth / WIDTH_SCREEN);
    [self.scannerSession.outputs[0] setRectOfInterest:rect];
    if (!self.isRunning) {
        [self startCodeReading];
    }
}
- (void)startCodeReading{
    [self.scannerView startScanner];
    [self.scannerSession startRunning];
}
- (void)stopCodeReading{
    [self.scannerView stopScanner];
    [self.scannerSession stopRunning];
}
- (BOOL)isRunning{
    return [self.scannerSession isRunning];
}
#pragma mark - Delegate -
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self stopCodeReading];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (_delegate && [_delegate respondsToSelector:@selector(scannerViewController:scanAnswer:)]) {
            [_delegate scannerViewController:self scanAnswer:obj.stringValue];
        }
    }
}
#pragma mark - Private Methods -
- (void)p_addMasonry{
    [self.scannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_offset(-55);
        make.width.and.height.mas_equalTo(0);
    }];
    
    [self.scannerBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [_scannerBGView addMasonryWithContainView:self.scannerView];
    
    [self.introudctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.view);
        make.top.mas_equalTo(self.scannerView.mas_bottom).mas_offset(30);
    }];
}
#pragma mark - Getter -
- (AVCaptureSession *)scannerSession{
    if (_scannerSession == nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (error) {    // 没有摄像头
            return nil;
        }
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [session setSessionPreset:AVCaptureSessionPreset1920x1080];
        }else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [session setSessionPreset:AVCaptureSessionPreset1280x720];
        }else{
            [session setSessionPreset:AVCaptureSessionPresetPhoto];
        }
        
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]];
        
        _scannerSession = session;
    }
    return _scannerSession;
}
- (AVCaptureVideoPreviewLayer *)videoPreviewLayer{
    if (_videoPreviewLayer == nil) {
        _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.scannerSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:self.view.layer.bounds];
    }
    return _videoPreviewLayer;
}
- (UILabel *)introudctionLabel{
    if (_introudctionLabel == nil) {
        _introudctionLabel = [[UILabel alloc] init];
        [_introudctionLabel setBackgroundColor:[UIColor clearColor]];
        [_introudctionLabel setTextAlignment:NSTextAlignmentCenter];
        [_introudctionLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_introudctionLabel setTextColor:[UIColor whiteColor]];
    }
    return _introudctionLabel;
}
- (TLScannerView *)scannerView{
    if (_scannerView == nil) {
        _scannerView = [[TLScannerView alloc] init];
    }
    return _scannerView;
}
- (TLScannerBackgroundView *)scannerBGView{
    if (_scannerBGView == nil) {
        _scannerBGView = [[TLScannerBackgroundView alloc] init];
    }
    return _scannerBGView;
}
@end
