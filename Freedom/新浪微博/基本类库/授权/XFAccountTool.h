
//  Freedom
//  Created by Fay on 15/9/21.
#import <Foundation/Foundation.h>
@class XFAccount;
@interface XFAccountTool : NSObject
/*存储账号信息
 *
 *  @param account 账号模型*/
+ (void)saveAccount:(XFAccount *)account;
/*返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）*/
+ (XFAccount *)account;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
