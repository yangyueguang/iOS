//  E_WebViewControler.h
//  Freedom
//  Created by Super on 15/3/3.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface NJKWebViewProgressView : UIView
@property (nonatomic) float progress;
@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1
- (void)setProgress:(float)progress animated:(BOOL)animated;
@end
extern const float NJKInitialProgressValue;
extern const float NJKInteractiveProgressValue;
extern const float NJKFinalProgressValue;
typedef void (^NJKWebViewProgressBlock)(float progress);
@protocol NJKWebViewProgressDelegate;
@interface NJKWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, weak) id<NJKWebViewProgressDelegate>progressDelegate;
@property (nonatomic, weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) NJKWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0
- (void)reset;
@end
@protocol NJKWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end
/*浏览器视图控制器*/
@interface E_WebViewControler : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString *_selectString;
}
- (id)initWithSelectString:(NSString *)selectString;
@end
