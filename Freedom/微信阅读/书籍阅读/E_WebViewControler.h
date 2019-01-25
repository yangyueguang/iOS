//  E_WebViewControler.h
//  Freedom
//  Created by Super on 15/3/3.
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NJKWebViewProgressView.h"
/*浏览器视图控制器*/
@interface E_WebViewControler : UIViewController<UIWebViewDelegate, NJKWebViewProgressDelegate>{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    NSString *_selectString;
}
- (id)initWithSelectString:(NSString *)selectString;
@end
