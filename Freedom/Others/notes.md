#
#复杂功能说明之导入xcodeproj项目
内含excel文件解析读取，依赖库：libiconv.tbd需要加入新的xcodeproj，增加方法如下：
1. 将开源项目拖入项目文件夹中，点击file/AddFilesTo  选择开源项目的.xcodeproj
2. Build Phases下 Links Binary With Libraries 引入.a文件。Target Dependencies里引入.a文件
3. Build Setting下的 Search Paths 里 Header Search Paths 加入开源项目src目录
如果该excel解析库文件夹libxls为空，则可以在终端进入该文件夹下svn co https://libxls.svn.sourceforge.net/svnroot/libxls/trunk/libxls libxls
*2.内含把数据写成xls文件并分享和发送邮件的方法。
1.设置bitcode为no,other linker flag为-lstdc++
2.下载LibXL.framework拖进项目即可http://www.libxl.com/download.html
# HTTPS 请求需要配置加密解密文件
+ (AFSecurityPolicy*)customSecurityPolicy{
// /先导入证书
NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
NSData *certData = [NSData dataWithContentsOfFile:cerPath];
// AFSSLPinningModeCertificate 使用证书验证模式
AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
// allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO// 如果是需要验证自建证书，需要设置为YES
securityPolicy.allowInvalidCertificates = YES;
//validatesDomainName 是否需要验证域名，默认为YES；
//假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
//置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
//如置为NO，建议自己添加对应域名的校验逻辑。
securityPolicy.validatesDomainName = NO;
securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData,nil];
return securityPolicy;
}
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
// 1.获得请求管理者
AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
// 2.申明返回的结果是text/html类型
mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
// 加上这行代码，https ssl 验证。
//[mgr setSecurityPolicy:[self customSecurityPolicy]];
// 3.发送POST请求
[mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
}];
}
#
#银联支付的APPDelegate文件中增加的代码
//
#import "UPPaymentControl.h"  
#import "RSA.h" 
#import <CommonCrypto/CommonDigest.h>
加入这些代码
- (NSString *) readPublicKey:(NSString *) keyName{
if (keyName == nil || [keyName isEqualToString:@""]) return nil;
NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
NSString *extension = filenameChunks[[filenameChunks count] - 1];
[filenameChunks removeLastObject]; // remove the extension
NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension
NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];
return keyStr;
}
-(BOOL) verify:(NSString *) resultStr {
//验签证书同后台验签证书 //此处的verify，商户需送去商户后台做验签
return NO;
}
-(BOOL) verifyLocal:(NSString *) resultStr {
//从NSString转化为NSDictionary
NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
//获取生成签名的数据
NSString *sign = data[@"sign"];
NSString *signElements = data[@"data"];
//NSString *pay_result = signElements[@"pay_result"];
//NSString *tn = signElements[@"tn"];
//转换服务器签名数据
NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:sign options:0];
//生成本地签名数据，并生成摘要
// NSString *mySignBlock = [NSString stringWithFormat:@"pay_result=%@tn=%@",pay_result,tn];
NSData *dataOriginal = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];
//验证签名
//TODO：此处如果是正式环境需要换成public_product.key
NSString *pubkey =[self readPublicKey:@"public_test.key"];
OSStatus result=[UPPayRSA verifyData:dataOriginal sig:nsdataFromBase64String publicKey:pubkey];
//签名验证成功，商户app做后续处理
if(result == 0) {//支付成功且验签成功，展示支付成功提示
return YES;
}else { //验签失败，交易结果数据被篡改，商户app后台查询交易结果
return NO;
}return NO;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
[[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {//结果code为成功时，先校验签名，校验成功后做后续处理
if([code isEqualToString:@"success"]) { //判断签名数据是否存在
if(data == nil){return;}//如果没有签名数据，建议商户app后台查询交易结果
//数据从NSDictionary转换为NSString
NSData *signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
NSString *sign = [[NSString alloc] initWithData:signData encoding:NSUTF8StringEncoding];
//验签证书同后台验签证书
//此处的verify，商户需送去商户后台做验签
if([self verify:sign]) {//支付成功且验签成功，展示支付成功提示
}else {}//验签失败，交易结果数据被篡改，商户app后台查询交易结果
}else if([code isEqualToString:@"fail"]) {//交易失败
}else if([code isEqualToString:@"cancel"]){}//交易取消
}];
return YES;
}
- (NSString*)sha1:(NSString *)string{
unsigned char digest[CC_SHA1_DIGEST_LENGTH]; CC_SHA1_CTX context; NSString *description; CC_SHA1_Init(&context); memset(digest, 0, sizeof(digest)); description = @"";
if (string == nil){return nil;}
const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];
if (str == NULL){return nil;}
int len = (int)strlen(str);
if (len == 0){return nil;}
if (str == NULL){return nil;}
CC_SHA1_Update(&context, str, len); CC_SHA1_Final(digest, &context);
description = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
digest[ 0], digest[ 1], digest[ 2], digest[ 3],digest[ 4], digest[ 5], digest[ 6], digest[ 7],digest[ 8], digest[ 9],
digest[10], digest[11],digest[12], digest[13], digest[14], digest[15],digest[16], digest[17], digest[18], digest[19]];
return description;
}
#
#点击展开分区是这样实现的：
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
if (section == 1) {
    if (self.currentIndex==1) {
        return [arrayCell count];
    }else{
        return 0;
    }
}else{
    return 0;
}}
#
#清理缓存：
-(void)learbtnAction{
[SVProgressHUD showWithStatus:ssssss(@"正在清理缓存", @"")];
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
NSFileManager* fileManager=[NSFileManager defaultManager];
NSString *_documentsDirectory = paths[0];
NSString * cacheDirectoryName = [_documentsDirectory stringByAppendingPathComponent:@"MyCache"];
DLog(@"cacheDirectoryName:%@",cacheDirectoryName);
NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:cacheDirectoryName error:nil]];
for (NSString *strName in tempFileList) {
NSString* fileAbsolutePath = [cacheDirectoryName stringByAppendingPathComponent:strName];
BOOL blDele= [fileManager removeItemAtPath:fileAbsolutePath error:nil];
if(blDele)DLog(@"删除:%d",blDele);
else[SVProgressHUD showImage:nil status:@"您已经清理过了,暂无缓存文件!"];
}
dispatch_async(dispatch_get_main_queue(), ^{[SVProgressHUD showImage:nil status:ssssss(@"清理成功!", @"")];});
});
}
#
#xcode8不打印多余log
按步骤打开Product > Scheme > Edit Scheme > 选择Run > Argumens > Environment Variables ;加入OS_ACTIVITY_MODE = disable
#
#保存模拟器图片到电脑桌面
NSString *folder =@"/Users/xuechao/Desktop/image/";
[[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
[[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@%@",folder,dict[@"imagename"]] contents:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"imagename"]]] attributes:nil];
NSString *folder =@"/Users/xuechao/Desktop/image/";
[[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
[[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"%@%@",folder,dict[@"imagename"]] contents:[NSData dataWithContentsOfURL:[NSURL URLWithString:dict[@"imagename"]]]attributes:nil];
#
#
