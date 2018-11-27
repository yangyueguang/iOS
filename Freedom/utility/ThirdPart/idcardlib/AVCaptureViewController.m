////
////  AVCaptureViewController.m
////  实时视频Demo
////
////  Created by zhongfeng1 on 2017/2/16.
////  Copyright © 2017年 zhongfeng. All rights reserved.
//#import "AVCaptureViewController.h"
//#import <AVFoundation/AVFoundation.h>
//#import <AssetsLibrary/AssetsLibrary.h>
////#import "excards.h"
//#include "excards.h"
//@interface IDInfo : NSObject
//@property (nonatomic,assign) int type; //1:正面  2:反面
//@property (nonatomic,copy) NSString *num; //身份证号
//@property (nonatomic,copy) NSString *name; //姓名
//@property (nonatomic,copy) NSString *gender; //性别
//@property (nonatomic,copy) NSString *nation; //民族
//@property (nonatomic,copy) NSString *address; //地址
//@property (nonatomic,copy) NSString *issue; //签发机关
//@property (nonatomic,copy) NSString *valid; //有效期
//@end
//@implementation IDInfo
//-(NSString *)description {
//    return [NSString stringWithFormat:@"<%@>",@{@"姓名：":_name,@"性别：":_gender,@"民族：":_nation,@"住址：":_address,@"公民身份证：":_num}];
//}
//@end
//@interface UIImage (Extend)
//+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
//+ (UIImage *)getImageStream:(CVImageBufferRef)imageBuffer;
//+ (UIImage *)getSubImage:(CGRect)rect inImage:(UIImage*)image;
//@end
//@implementation UIImage (Extend)
//+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
//    // Get a CMSampleBuffer's Core Video image buffer for the media data
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    // Lock the base address of the pixel buffer
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    // Get the number of bytes per row for the pixel buffer
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    // Get the number of bytes per row for the pixel buffer
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // Get the pixel buffer width and height
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    // Create a device-dependent RGB color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    // Create a bitmap graphics context with the sample buffer data
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    // Create a Quartz image from the pixel data in the bitmap graphics context
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    // Unlock the pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    // Free up the context and color space
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    // Create an image object from the Quartz image
//    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
//    // Release the Quartz image
//    CGImageRelease(quartzImage);
//    return (image);
//}
//+ (UIImage *)getImageStream:(CVImageBufferRef)imageBuffer {
//    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
//    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
//    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer))];
//    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
//    CGImageRelease(videoImage);
//    return image;
//}
//+ (UIImage *)getSubImage:(CGRect)rect inImage:(UIImage*)image {
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    CFRelease(subImageRef);
//    UIGraphicsEndImageContext();
//    return smallImage;
//}
//@end
//char numbers[256];
//CGRect rects[64];
//@interface RectManager : UIView
//@property (nonatomic, assign)CGRect subRect;
//+ (CGRect)getEffectImageRect:(CGSize)size;
//+ (CGRect)getGuideFrame:(CGRect)rect;
//+ (int)docode:(unsigned char *)pbBuf len:(int)tLen;
//+ (CGRect)getCorpCardRect:(int)width  height:(int)height guideRect:(CGRect)guideRect charCount:(int) charCount;
//+ (char *)getNumbers;
//@end
//@implementation RectManager
//+ (CGRect)getEffectImageRect:(CGSize)size {
//    CGSize size2 = [UIScreen mainScreen].bounds.size;
//    CGPoint point;
//    if(size.width/size.height > size2.width/size2.height) {
//        float oldW = size.width;
//        size.width = size2.width / size2.height * size.height;
//        point.x = (oldW - size.width)/2;
//        point.y = 0;
//    }else {
//        float oldH = size.height;
//        size.height = size2.height / size2.width * size.width;
//        point.x = 0;
//        point.y = (oldH - size.height)/2;;
//    }
//    return CGRectMake(point.x, point.y, size.width, size.height);
//}
//+ (CGRect)getGuideFrame:(CGRect)rect {
//    float previewWidth = rect.size.height;
//    float previewHeight = rect.size.width;
//    float cardh, cardw;
//    float left, top;
//    cardw = previewWidth*70/100;
//    //if(cardw < 720) cardw = 720;
//    if(previewWidth < cardw)cardw = previewWidth;
//    cardh = (int)(cardw / 0.63084f);
//    left = (previewWidth-cardw)/2;
//    top = (previewHeight-cardh)/2;
//    return CGRectMake(top+rect.origin.x, left+rect.origin.y, cardh, cardw);
//}
//+ (int)docode:(unsigned char *)pbBuf len:(int)tLen {
//    int hic, lwc;
//    int i, j, code;
//    int x, y, w, h;
//    int charCount = 0;
//    int charNum = 0;
//    char szBankName[128];
//    //字符解析，包含空格
//    i = 0;
//    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
//    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
//    //bank name, GBK CharSet;
//    for(j = 0; j < 64; ++j) { szBankName[j] = pbBuf[i++]; }
//    //charNum
//    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
//    charNum = code;
//    //char code and its rect
//    while(i < tLen-9){
//        //字符的编码unsigned short
//        hic = pbBuf[i++]; lwc = pbBuf[i++]; x = (hic<<8)+lwc;
//        numbers[charCount] = (char)x;
//        //字符的矩形框lft, top, w, h
//        hic = pbBuf[i++]; lwc = pbBuf[i++]; x = (hic<<8)+lwc;
//        hic = pbBuf[i++]; lwc = pbBuf[i++]; y = (hic<<8)+lwc;
//        hic = pbBuf[i++]; lwc = pbBuf[i++]; w = (hic<<8)+lwc;
//        hic = pbBuf[i++]; lwc = pbBuf[i++]; h = (hic<<8)+lwc;
//        rects[charCount] = CGRectMake(x, y, w, h);
//        charCount++;
//    }
//    numbers[charCount] = 0;
//    if(charCount < 10 || charCount > 24 || charNum != charCount){
//        charCount = 0;
//    }
//    return charCount;
//}
//
//+ (CGRect)getCorpCardRect:(int)width  height:(int)height guideRect:(CGRect)guideRect charCount:(int) charCount {
//    CGRect subRect = rects[0];
//    int i;
//    int nAvgW = 0;
//    int nAvgH = 0;
//    int nCount = 0;
//    nAvgW  = rects[0].size.width;
//    nAvgH  = rects[0].size.height;
//    nCount = 1;
//    //所有非空格的字符的矩形框合并
//    for(i = 1; i < charCount; ++i){
//        subRect = combinRect(subRect, rects[i]);
//        if(numbers[i] != ' '){
//            nAvgW += rects[i].size.width;
//            nAvgH += rects[i].size.height;
//            nCount ++;
//        }
//    }
//    //统计得到的平均宽度和高度
//    nAvgW /= nCount;
//    nAvgH /= nCount;
//    //releative to the big image（相对于大图）
//    subRect.origin.x = subRect.origin.x + guideRect.origin.x;
//    subRect.origin.y = subRect.origin.y + guideRect.origin.y;
//    //    rect.offset(guideRect.left, guideRect.top);
//    //做一个扩展
//    subRect.origin.y -= nAvgH;  if(subRect.origin.y < 0) subRect.origin.y = 0;
//    subRect.size.height += nAvgH * 2; if(subRect.size.height+subRect.origin.y  >= height) subRect.size.height = height-subRect.origin.y-1;
//    subRect.origin.x -= nAvgW; if(subRect.origin.x < 0) subRect.origin.x = 0;
//    subRect.size.width += nAvgW * 2; if(subRect.size.width+subRect.origin.x >= width) subRect.size.width = width-subRect.origin.x-1;
//    return subRect;
//}
//+ (char *)getNumbers {
//    return numbers;
//}
//CGRect combinRect(CGRect A, CGRect B){
//    CGFloat t,b,l,r;
//    l = fminf(A.origin.x, B.origin.x);
//    r = fmaxf(A.size.width+A.origin.x, B.size.width+B.origin.x);
//    t = fminf(A.origin.y, B.origin.y);
//    b = fmaxf(A.size.height+A.origin.y, B.size.height+B.origin.y);
//    return CGRectMake(l, t, r-l, b-t);
//}
//@end
//@interface LHSIDCardScaningView : UIView
//@property (nonatomic,assign) CGRect facePathRect;
//@end
//@interface LHSIDCardScaningView () {
//    CAShapeLayer *_IDCardScanningWindowLayer;
//    NSTimer *_timer;
//}
//@end
//@implementation LHSIDCardScaningView
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor clearColor];
//        // 添加扫描窗口
//        [self addScaningWindow];
//        // 添加定时器
//        [self addTimer];
//    }
//    return self;
//}
//#pragma mark - 添加扫描窗口
//-(void)addScaningWindow {
//    // 中间包裹线
//    _IDCardScanningWindowLayer = [CAShapeLayer layer];
//    _IDCardScanningWindowLayer.position = self.layer.position;
//    CGFloat width = [UIScreen mainScreen].bounds.size.height == 568.0? 240: ([UIScreen mainScreen].bounds.size.height == 667.0? 270: 300);
//    _IDCardScanningWindowLayer.bounds = (CGRect){CGPointZero, {width, width * 1.574}};
//    _IDCardScanningWindowLayer.cornerRadius = 15;
//    _IDCardScanningWindowLayer.borderColor = [UIColor whiteColor].CGColor;
//    _IDCardScanningWindowLayer.borderWidth = 1.5;
//    [self.layer addSublayer:_IDCardScanningWindowLayer];
//    // 最里层镂空
//    UIBezierPath *transparentRoundedRectPath = [UIBezierPath bezierPathWithRoundedRect:_IDCardScanningWindowLayer.frame cornerRadius:_IDCardScanningWindowLayer.cornerRadius];
//    // 最外层背景
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
//    [path appendPath:transparentRoundedRectPath];
//    [path setUsesEvenOddFillRule:YES];
//    CAShapeLayer *fillLayer = [CAShapeLayer layer];
//    fillLayer.path = path.CGPath;
//    fillLayer.fillRule = kCAFillRuleEvenOdd;
//    fillLayer.fillColor = [UIColor blackColor].CGColor;
//    fillLayer.opacity = 0.7;
//    [self.layer addSublayer:fillLayer];
//    CGFloat facePathWidth = [UIScreen mainScreen].bounds.size.height == 568.0? 125: ([UIScreen mainScreen].bounds.size.height == 667.0? 150: 180);
//    CGFloat facePathHeight = facePathWidth * 0.812;
//    CGRect rect = _IDCardScanningWindowLayer.frame;
//    self.facePathRect = (CGRect){CGRectGetMaxX(rect) - facePathWidth - 35,CGRectGetMaxY(rect) - facePathHeight - 25,facePathWidth,facePathHeight};
//    // 提示标签
//    CGPoint center = self.center;
//    center.x = CGRectGetMaxX(_IDCardScanningWindowLayer.frame) + 20;
//    [self addTipLabelWithText:@"请拍摄身份证人像面，尝试对齐拍摄框边缘" center:center];
//    /*CGPoint center1 = (CGPoint){CGRectGetMidX(_facePathRect), CGRectGetMidY(_facePathRect)};
//     [self addTipLabelWithText:@"人像" center:center1];
//     */
//    // 人像
//    UIImageView *headIV = [[UIImageView alloc] initWithFrame:_facePathRect];
//    headIV.image = [UIImage imageNamed:@"idcard_first_head"];
//    headIV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
//    headIV.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:headIV];
//}
//-(void )addTipLabelWithText:(NSString *)text center:(CGPoint)center {
//    UILabel *tipLabel = [[UILabel alloc] init];
//    tipLabel.text = text;
//    tipLabel.textColor = [UIColor whiteColor];
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    tipLabel.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
//    [tipLabel sizeToFit];
//    tipLabel.center = center;
//    [self addSubview:tipLabel];
//}
//-(void)addTimer {
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
//    [_timer fire];
//}
//-(void)timerFire:(id)notice {
//    [self setNeedsDisplay];
//}
//-(void)dealloc {
//    [_timer invalidate];
//}
//- (void)drawRect:(CGRect)rect {
//    rect = _IDCardScanningWindowLayer.frame;
//    // 人像提示框
//    UIBezierPath *facePath = [UIBezierPath bezierPathWithRect:_facePathRect];
//    facePath.lineWidth = 1.5;
//    [[UIColor whiteColor] set];
//    [facePath stroke];
//    // 水平扫描线
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    static CGFloat moveX = 0;
//    static CGFloat distanceX = 0;
//    CGContextBeginPath(context);
//    CGContextSetLineWidth(context, 2);
//    CGContextSetRGBStrokeColor(context,0.3,0.8,0.3,0.8);
//    CGPoint p1, p2;// p1, p2 连成水平扫描线;
//    moveX += distanceX;
//    if (moveX >= CGRectGetWidth(rect) - 2) {
//        distanceX = -2;
//    } else if (moveX <= 2){
//        distanceX = 2;
//    }
//    p1 = CGPointMake(CGRectGetMaxX(rect) - moveX, rect.origin.y);
//    p2 = CGPointMake(CGRectGetMaxX(rect) - moveX, rect.origin.y + rect.size.height);
//    CGContextMoveToPoint(context,p1.x, p1.y);
//    CGContextAddLineToPoint(context, p2.x, p2.y);
//    CGContextStrokePath(context);
//}
//@end
//@interface IDInfoViewController : UIViewController
//// 身份证信息
//@property (nonatomic,strong) IDInfo *IDInfo;
//// 身份证图像
//@property (nonatomic,strong) UIImage *IDImage;
//@end
//@interface IDInfoViewController ()
//@property (strong, nonatomic) UIImageView *IDImageView;
//@property (strong, nonatomic) UILabel *IDNumLabel;
//@end
//@implementation IDInfoViewController
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.IDImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
//    self.IDImageView.backgroundColor = [UIColor greenColor];
//    self.IDNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 320, [UIScreen mainScreen].bounds.size.width, 30)];
//    self.IDNumLabel.textAlignment = NSTextAlignmentCenter;
//    self.IDNumLabel.textColor = [UIColor redColor];
//    UIButton *reTakeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 400, 150, 40)];
//    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 400, 150, 40)];
//    reTakeBtn.backgroundColor = [UIColor greenColor];
//    nextBtn.backgroundColor = [UIColor yellowColor];
//    [reTakeBtn setTitle:@"重新拍摄" forState:UIControlStateNormal];
//    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    [self.view addSubview:self.IDImageView];
//    [self.view addSubview:self.IDNumLabel];
//    [self.view addSubview:reTakeBtn];
//    [self.view addSubview:nextBtn];
//    [reTakeBtn addTarget:self action:@selector(shootAgain:) forControlEvents:UIControlEventTouchUpInside];
//    [nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.title = @"身份证信息";
//    self.IDNumLabel.text = _IDInfo.num;
//    self.IDImageView.image = _IDImage;
//}
//- (void)shootAgain:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)nextStep:(UIButton *)sender {
//}
//@end
//@interface AVCaptureViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>
//// 摄像头设备
//@property (nonatomic,strong) AVCaptureDevice *device;
//// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
//@property (nonatomic,strong) AVCaptureSession *session;
//// 输出格式
//@property (nonatomic,strong) NSNumber *outPutSetting;
//// 出流对象
//@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;
//// 元数据（用于人脸识别）
//@property (nonatomic,strong) AVCaptureMetadataOutput *metadataOutput;
//// 预览图层
//@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
//// 人脸检测框区域
//@property (nonatomic,assign) CGRect faceDetectionFrame;
//@property (nonatomic,strong) dispatch_queue_t queue;
//@end
//@implementation AVCaptureViewController
//-(AVCaptureDevice *)device {
//    if (_device == nil) {
//        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        NSError *error = nil;
//        if ([_device lockForConfiguration:&error]) {
//            if ([_device isSmoothAutoFocusSupported]) {// 平滑对焦
//                _device.smoothAutoFocusEnabled = YES;
//            }
//            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {// 自动持续对焦
//                _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
//            }
//            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) {// 自动持续曝光
//                _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
//            }
//            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {// 自动持续白平衡
//                _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
//            }
////            NSError *error1;
////            CMTime frameDuration = CMTimeMake(1, 30); // 默认是1秒30帧
////            NSArray *supportedFrameRateRanges = [_device.activeFormat videoSupportedFrameRateRanges];
////            BOOL frameRateSupported = NO;
////            for (AVFrameRateRange *range in supportedFrameRateRanges) {
////                if (CMTIME_COMPARE_INLINE(frameDuration, >=, range.minFrameDuration) && CMTIME_COMPARE_INLINE(frameDuration, <=, range.maxFrameDuration)) {
////                    frameRateSupported = YES;
////                }
////            }
////            if (frameRateSupported && [self.device lockForConfiguration:&error1]) {
////                [_device setActiveVideoMaxFrameDuration:frameDuration];
////                [_device setActiveVideoMinFrameDuration:frameDuration];
//////                [self.device unlockForConfiguration];
////            }
//            [_device unlockForConfiguration];
//        }
//    }
//    return _device;
//}
//-(NSNumber *)outPutSetting {
//    if (_outPutSetting == nil) {
//        _outPutSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
//    }
//    return _outPutSetting;
//}
//-(AVCaptureMetadataOutput *)metadataOutput {
//    if (_metadataOutput == nil) {
//        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
//        [_metadataOutput setMetadataObjectsDelegate:self queue:self.queue];
//    }
//    return _metadataOutput;
//}
//-(AVCaptureVideoDataOutput *)videoDataOutput {
//    if (_videoDataOutput == nil) {
//        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
//        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
//        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:self.outPutSetting};
//    }
//    return _videoDataOutput;
//}
//-(AVCaptureSession *)session {
//    if (_session == nil) {
//        _session = [[AVCaptureSession alloc] init];
//        _session.sessionPreset = AVCaptureSessionPresetHigh;
//        // 2、设置输入：由于模拟器没有摄像头，因此最好做一个判断
//        NSError *error = nil;
//        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
//        if (error) {
//            NSLog(@"没有摄像头%@",error.localizedDescription);
//        }else {
//            if ([_session canAddInput:input]) {
//                [_session addInput:input];
//            }
//            if ([_session canAddOutput:self.videoDataOutput]) {
//                [_session addOutput:self.videoDataOutput];
//            }
//            if ([_session canAddOutput:self.metadataOutput]) {
//                [_session addOutput:self.metadataOutput];
//                // 输出格式要放在addOutPut之后，否则奔溃
//                self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
//            }
//        }
//    }
//    return _session;
//}
//-(AVCaptureVideoPreviewLayer *)previewLayer {
//    if (_previewLayer == nil) {
//        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//        _previewLayer.frame = self.view.frame;
//        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    }
//    return _previewLayer;
//}
//-(dispatch_queue_t)queue {
//    if (_queue == nil) {
////        _queue = dispatch_queue_create("AVCaptureSession_Start_Running_Queue", DISPATCH_QUEUE_SERIAL);
//        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    }
//    return _queue;
//}
//// session开始，即输入设备和输出设备开始数据传递
//- (void)runSession {
//    if (![self.session isRunning]) {
//        dispatch_async(self.queue, ^{
//            [self.session startRunning];
//        });
//    }
//}
//// session停止，即输入设备和输出设备结束数据传递
//-(void)stopSession {
//    if ([self.session isRunning]) {
//        dispatch_async(self.queue, ^{
//            [self.session stopRunning];
//        });
//    }
//}
//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    // 每次展现AVCaptureViewController的界面时，都检查摄像头使用权限
//    [self checkAuthorizationStatus];
//}
//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self stopSession];
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationItem.title = @"请拍摄身份证";
//    // 初始化rect
//    const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
//    int ret = EXCARDS_Init(thePath);
//    if (ret != 0) {
//        NSLog(@"初始化失败：ret=%d", ret);
//    }
//    // 添加预览图层
//    [self.view.layer addSublayer:self.previewLayer];
//    // 添加自定义的扫描界面（中间有一个镂空窗口和来回移动的扫描线）
//    LHSIDCardScaningView *IDCardScaningView = [[LHSIDCardScaningView alloc] initWithFrame:self.view.frame];
//    self.faceDetectionFrame = IDCardScaningView.facePathRect;
//    [self.view addSubview:IDCardScaningView];
//    // 设置人脸扫描区域
//    // 为什么做人脸扫描？
//    // 经实践证明，由于预览图层是全屏的，当用户有时没有将身份证对准拍摄框边缘时，也会成功读取身份证上的信息，即也会捕获到不完整的身份证图像。
//    // 因此，为了截取到比较完整的身份证图像，在自定义扫描界面的合适位置上加了一个身份证头像框，让用户将该小框对准身份证上的头像，最终目的是使程序截取到完整的身份证图像。
//    // 当该小框检测到人脸时，再对比人脸区域是否在这个小框内，若在，说明用户的确将身份证头像放在了这个框里，那么此时这一帧身份证图像大小正好合适且完整，接下来才捕获该帧，就获得了完整的身份证截图。（若不在，那么就不捕获此时的图像）
//    // 理解：检测身份证上的人脸是为了获得证上的人脸区域，获得人脸区域是为了希望人脸区域能在小框内，这样的话，才截取到完整的身份证图像。
//    // ps: 如果你不想加入人脸识别这一功能，你的app无需这么精细的话，注释掉所有metadataOutput的代码及其下面的那个代理方法（-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection）即可
//    // 个人认为：有了文字、拍摄区域的提示，99%的用户会主动将身份证和拍摄框边缘对齐，就能够获得完整的身份证图像，不做人脸区域的检测也可以。。。
////    [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification* _Nonnull note) {
////        __weak __typeof__(self) weakSelf = self;
//        self.metadataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:IDCardScaningView.facePathRect];
////    }];
//    // 添加关闭按钮
//    [self addCloseButton];
//}
//#pragma mark - 添加关闭按钮
//-(void)addCloseButton {
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setImage:[UIImage imageNamed:@"idcard_back"] forState:UIControlStateNormal];
//    CGFloat closeBtnWidth = 40;
//    CGFloat closeBtnHeight = closeBtnWidth;
//    CGRect viewFrame = self.view.frame;
//    closeBtn.frame = (CGRect){CGRectGetMaxX(viewFrame) - closeBtnWidth, CGRectGetMaxY(viewFrame) - closeBtnHeight, closeBtnWidth, closeBtnHeight};
//    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeBtn];
//}
//-(void)close {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//#pragma mark - 检测摄像头权限
//-(void)checkAuthorizationStatus {
//    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    switch (authorizationStatus) {
//        case AVAuthorizationStatusNotDetermined:[self showAuthorizationNotDetermined]; break;// 用户尚未决定授权与否，那就请求授权
//        case AVAuthorizationStatusAuthorized:[self showAuthorizationAuthorized]; break;// 用户已授权，那就立即使用
//        case AVAuthorizationStatusDenied:[self showAuthorizationDenied]; break;// 用户明确地拒绝授权，那就展示提示
//        case AVAuthorizationStatusRestricted:[self showAuthorizationRestricted]; break;// 无法访问相机设备，那就展示提示
//        }
//}
//#pragma mark 用户还未决定是否授权使用相机
//-(void)showAuthorizationNotDetermined {
//    __weak __typeof__(self) weakSelf = self;
//    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
//        granted? [weakSelf runSession]: [weakSelf showAuthorizationDenied];
//    }];
//}
//-(void)showAuthorizationDenied {
//    NSString *title = @"相机未授权";
//    NSString *message = @"请到系统的“设置-隐私-相机”中授权此应用使用您的相机";
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        // 跳转到“新浪微盾”隐私设置界面
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
//    [self alertControllerWithTitle:title message:message okAction:okAction cancelAction:cancelAction];
//}
//-(void)showAuthorizationAuthorized {
//    [self runSession];
//}
//-(void)showAuthorizationRestricted {
//    NSString *title = @"相机设备受限";
//    NSString *message = @"请检查您的手机硬件或设置";
//    NSLog(@"%@%@",title,message);
//}
//-(void)alertControllerWithTitle:(NSString *)title message:(NSString *)message okAction:(UIAlertAction *)okAction cancelAction:(UIAlertAction *)cancelAction {
//    NSLog(@"相机未授权 请到系统的“设置 - 隐私 - 相机”中授权新浪微盾使用您的相机");
//}
//#pragma mark 从输出的元数据中捕捉人脸
//// 检测人脸是为了获得“人脸区域”，做“人脸区域”与“身份证人像框”的区域对比，当前者在后者范围内的时候，才能截取到完整的身份证图像
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    if (metadataObjects.count) {
//        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
//        AVMetadataObject *transformedMetadataObject = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
//        CGRect faceRegion = transformedMetadataObject.bounds;
//        if (metadataObject.type == AVMetadataObjectTypeFace) {
//            NSLog(@"是否包含头像：%d, facePathRect: %@, faceRegion: %@",CGRectContainsRect(self.faceDetectionFrame, faceRegion),NSStringFromCGRect(self.faceDetectionFrame),NSStringFromCGRect(faceRegion));
//            if (CGRectContainsRect(self.faceDetectionFrame, faceRegion)) {// 只有当人脸区域的确在小框内时，才再去做捕获此时的这一帧图像
//                // 为videoDataOutput设置代理，程序就会自动调用下面的代理方法，捕获每一帧图像
//                if (!self.videoDataOutput.sampleBufferDelegate) {
//                    [self.videoDataOutput setSampleBufferDelegate:self queue:self.queue];
//                }
//            }
//        }
//    }
//}
//#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegte
//#pragma mark 从输出的数据流捕捉单一的图像帧
//// AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    if ([self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] || [self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
//        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        if ([captureOutput isEqual:self.videoDataOutput]) {
//            // 身份证信息识别
//            [self IDCardRecognit:imageBuffer];
//            // 身份证信息识别完毕后，就将videoDataOutput的代理去掉，防止频繁调用AVCaptureVideoDataOutputSampleBufferDelegate方法而引起的“混乱”
//            if (self.videoDataOutput.sampleBufferDelegate) {
//                [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
//            }
//        }
//    } else {
//        NSLog(@"输出格式不支持");
//    }
//}
//#pragma mark - 身份证信息识别
//- (void)IDCardRecognit:(CVImageBufferRef)imageBuffer {
//    CVBufferRetain(imageBuffer);
//    // Lock the image buffer
//    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess) {
//        size_t width= CVPixelBufferGetWidth(imageBuffer);// 1920
//        size_t height = CVPixelBufferGetHeight(imageBuffer);// 1080
//        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
//        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
//        size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
//        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
//        unsigned char* pixelAddress = baseAddress + offset;
//        static unsigned char *buffer = NULL;
//        if (buffer == NULL) {
//            buffer = (unsigned char *)malloc(sizeof(unsigned char) * width * height);
//        }
//        memcpy(buffer, pixelAddress, sizeof(unsigned char) * width * height);
//        unsigned char pResult[1024];
//        int ret = EXCARDS_RecoIDCardData(buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
//        if (ret <= 0) {
//            NSLog(@"ret=[%d]", ret);
//        } else {
//            NSLog(@"ret=[%d]", ret);
//            // 播放一下“拍照”的声音，模拟拍照
//            AudioServicesPlaySystemSound(1108);
//            if ([self.session isRunning]) {
//                [self.session stopRunning];
//            }
//            char ctype;
//            char content[256];
//            int xlen;
//            int i = 0;
//            IDInfo *iDInfo = [[IDInfo alloc] init];
//            ctype = pResult[i++];
////            iDInfo.type = ctype;
//            while(i < ret){
//                ctype = pResult[i++];
//                for(xlen = 0; i < ret; ++i){
//                    if(pResult[i] == ' ') { ++i; break; }
//                    content[xlen++] = pResult[i];
//                }
//                content[xlen] = 0;
//                if(xlen) {
//                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//                    if(ctype == 0x21) {
//                        iDInfo.num = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    } else if(ctype == 0x22) {
//                        iDInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    } else if(ctype == 0x23) {
//                        iDInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    } else if(ctype == 0x24) {
//                        iDInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    } else if(ctype == 0x25) {
//                        iDInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    } else if(ctype == 0x26) {
//                        iDInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    } else if(ctype == 0x27) {
//                        iDInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
//                    }
//                }
//            }
//            if (iDInfo.num.length) {// 读取到身份证信息，实例化出IDInfo对象后，截取身份证的有效区域，获取到图像
//                CGRect effectRect = [RectManager getEffectImageRect:CGSizeMake(width, height)];
//                CGRect rect = [RectManager getGuideFrame:effectRect];
//                UIImage *image = [UIImage getImageStream:imageBuffer];
//                UIImage *subImage = [UIImage getSubImage:rect inImage:image];
//                // 推出IDInfoVC（展示身份证信息的控制器）
//                IDInfoViewController *IDInfoVC = [[IDInfoViewController alloc] init];
//                IDInfoVC.IDInfo = iDInfo;// 身份证信息
//                IDInfoVC.IDImage = subImage;// 身份证图像
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.navigationController pushViewController:IDInfoVC animated:YES];
//                });
//            }
//        }
//        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//    }
//    CVBufferRelease(imageBuffer);
//}
//@end
