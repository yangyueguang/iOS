//  User.h
//  Freedom
//  Created by Super on 2017/10/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
#pragma mark 用户相关属性
@interface User : NSObject
@property (nonatomic, strong) NSString *userAccount;//账号
@property (nonatomic, strong) NSString *userId;//ID
@property (nonatomic, strong) NSString *userName;//用户名
@property (nonatomic, strong) NSString *userPwd;//密码
@property (nonatomic, strong) NSString *userLogo;//头像
@property (nonatomic, strong) NSString *userToken;//口令
@property (nonatomic, strong) NSString *userAddress;//地址
@property (nonatomic, strong) NSString *userlongitude;//经度
@property (nonatomic, strong) NSString *userlatitude;//维度
@property (nonatomic, strong) NSString *usertype;//用户级别
@property (nonatomic, strong) NSString *userSign;//用户签名
@property (nonatomic, strong) NSString *usermony;//用户金额
@property (nonatomic, strong) NSString *userstatus;//用户状态
@property (nonatomic, strong) NSString *usercards;//用户银行卡号
@property (nonatomic, strong) NSString *userphone;//手机号
@property (nonatomic, strong) NSString *useridcard;//身份证号
@property (nonatomic, strong) NSString *userWechartnum;//微信号
@property (nonatomic, strong) NSString *userQQnumber;//QQ号
@property (nonatomic, strong) NSString *userSex;//性别
@property (nonatomic, strong) NSString *userAge;//年龄
@property (nonatomic, strong) NSString *userProtect;//账号保护
@property (nonatomic, strong) NSString *userEmail;//邮箱
@property (nonatomic, strong) NSString *userDevices;//登录设备
@property (nonatomic, strong) NSString *userSystem;//手机系统
@property (nonatomic, strong) NSString *userIP;//手机登录的IP地址
@property (nonatomic, strong) NSString *userRealName;//真实姓名
+(NSArray*)getControllerData;
@end
