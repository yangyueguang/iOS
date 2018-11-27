

JSContext *context = [self  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
context[@"fakeopen"] = ^ {
NSString * title =  [self stringByEvaluatingJavaScriptFromString:@"document.title"];
self.backBlock(20,title);
};


