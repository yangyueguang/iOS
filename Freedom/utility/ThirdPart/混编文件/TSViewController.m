//
#import "TSViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>
static const char kTSJavaScriptContext[] = "ts_javaScriptContext";
static NSHashTable* g_webViews = nil;
@protocol TSWebViewDelegate <UIWebViewDelegate>
@optional
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx;
@end
@interface UIWebView (TS_JavaScriptContext)
@property (nonatomic, readonly) JSContext* ts_javaScriptContext;
@end
@implementation NSObject (TS_JavaScriptContext)
- (void) webView: (id) unused didCreateJavaScriptContext: (JSContext*) ctx forFrame: (id) frame{
    void (^notifyDidCreateJavaScriptContext)() = ^{
        for ( UIWebView* webView in g_webViews ){
            NSString* cookie = [NSString stringWithFormat: @"ts_jscWebView_%lud", (unsigned long)webView.hash ];
            [webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat: @"var %@ = '%@'", cookie, cookie ] ];
            if ( [ctx[cookie].toString isEqualToString: cookie] ){
                [webView willChangeValueForKey: @"ts_javaScriptContext"];
                objc_setAssociatedObject( self, kTSJavaScriptContext, ctx, OBJC_ASSOCIATION_RETAIN);
                [webView didChangeValueForKey: @"ts_javaScriptContext"];
                if ( [webView.delegate respondsToSelector: @selector(webView:didCreateJavaScriptContext:)] ){
                    [( id<TSWebViewDelegate>)webView.delegate webView: webView didCreateJavaScriptContext: ctx];
                }
                return;
            }
        }
    };
    if ( [NSThread isMainThread]){
        notifyDidCreateJavaScriptContext();
    }else{
        dispatch_async( dispatch_get_main_queue(), notifyDidCreateJavaScriptContext );
    }
}
@end
@implementation UIWebView (TS_JavaScriptContext)
+ (id) allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_webViews = [NSHashTable weakObjectsHashTable];
    });
    id webView = [super allocWithZone: zone];
    [g_webViews addObject: webView];
    return webView;
}

- (JSContext*) ts_javaScriptContext{
    JSContext* javaScriptContext = objc_getAssociatedObject( self, kTSJavaScriptContext );
    return javaScriptContext;
}
    @end

@protocol aaa <JSExport>
- (void) sayGoodbye;
@end
@interface TSViewController () <TSWebViewDelegate, aaa>{
    UIWebView* _webView;
}
@end
@implementation TSViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 100, 300, 300)];
    [self.view addSubview:_webView];
    NSURL* htmlURL = [[NSBundle mainBundle] URLForResource: @"testWebView" withExtension: @"htm"];
    [_webView loadRequest: [NSURLRequest requestWithURL: htmlURL]];
}
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx{
    ctx[@"sayHello"] = ^{
        dispatch_async( dispatch_get_main_queue(), ^{
            NSLog(@"说嗨");
        });
    };
    ctx[@"viewController"] = self;
    
    ctx[@"sendTextStr"] = ^(){
        NSLog(@"js调用");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
    };
    /**oc给js传入函数值*/
    NSString * func = [NSString stringWithFormat:@"show('%@');",@"OC后台传入数据"];
    [webView stringByEvaluatingJavaScriptFromString:func];
}
- (void) sayGoodbye{
    NSLog(@"说拜拜");
}
-(void)javaScriptBridgeTest{
    JSContext *context = [JSContext new];
    [context evaluateScript:
     @"var window = UIWindow.new();"
     @"window.frame = UIScreen.mainScreen().bounds;"
     @"window.backgroundColor = UIColor.whiteColor();"
     @""
     @"var navigationController = UINavigationController.new();"
     @"var viewController = UIViewController.new();"
     @"viewController.navigationItem.title = 'Make UI with JavaScript';"
     @""
     @"var view = UIView.new();"
     @"view.backgroundColor = UIColor.redColor();"
     @"view.frame = {x: 20, y: 80, width: 280, height: 80};"
     @""
     @"var label = UILabel.new();"
     @"label.backgroundColor = UIColor.blueColor();"
     @"label.textColor = UIColor.whiteColor();"
     @"label.text = 'Hello World.';"
     @"label.font = UIFont.boldSystemFontOfSize(24);"
     @"label.sizeToFit();"
     @""
     @"var frame = label.frame;"
     @"frame.x = 10;"
     @"frame.y = 10;"
     @"label.frame = frame;"
     @""
     @"view.addSubview(label);"
     @"viewController.view.addSubview(view);"
     @""
     @"navigationController.viewControllers = [viewController];"
     @""
     @"window.rootViewController = navigationController;"
     @"window.makeKeyAndVisible();"
     ];
}
@end
