//  User.m
//  Freedom
//  Created by Super on 2017/10/11.
//  Copyright © 2017年 Super. All rights reserved.
//
#import "User.h"
@implementation User
+(NSArray *)getControllerData{
    NSArray *theNewItems = @[@{@"icon":@"kugouIcon",@"title":@"酷狗",@"control":@"Kugou"},@{@"icon":@"juheIcon",@"title":@"聚合数据",@"control":@"JuheData"},@{@"icon":@"aiqiyiIcon",@"title":@"爱奇艺",@"control":@"Iqiyi"},@{@"icon":@"taobaoIcon",@"title":@"淘宝",@"control":@"Taobao"},@{@"icon":@"weiboIcon",@"title":@"新浪微博",@"control":@"Sina"},@{@"icon":@"zhifubaoIcon",@"title":@"支付宝",@"control":@"Alipay"},@{@"icon":@"jianliIcon",@"title":@"我的简历",@"control":@"Resume"},@{@"icon":@"database",@"title":@"我的数据库",@"control":@"MyDatabase"},@{@"icon":@"shengyibaoIcon",@"title":@"微能量",@"control":@"MicroEnergy"},@{@"icon":@"weixinIcon",@"title":@"微信",@"control":@"Wechart"},@{@"icon":@"dianpingIcon",@"title":@"大众点评",@"control":@"Dianping"},@{@"icon":@"toutiaoIcon",@"title":@"今日头条",@"control":@"Toutiao"},@{@"icon":@"books",@"title":@"书籍收藏",@"control":@"Books"},@{@"icon":@"ziyouzhuyi",@"title":@"个性特色自由主义",@"control":@"Freedom"},@{@"icon":@"yingyongIcon",@"title":@"个人应用",@"control":@"PersonalApply"}];
    return theNewItems;
}
@end
