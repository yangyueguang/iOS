//  XFAccount.h
//  Freedom
//  Created by Fay on 15/9/20.
#import <Foundation/Foundation.h>
@interface XFAccount : NSObject <NSCoding>
/**　string	用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;
/**　string	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber *expires_in;
/**　string	当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;
/**	access token的创建时间 */
@property (nonatomic, strong) NSDate *created_time;
/** 用户昵称  */
@property (nonatomic,copy)NSString *name;
+ (instancetype)accountWithDict:(NSDictionary *)dict;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
