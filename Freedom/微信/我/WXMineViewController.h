//  WXMineViewController.h
//  Freedom
// Created by Super
#import "WXMenuViewController.h"
#import "WXUserHelper.h"
@interface WXMineInfoHelper : NSObject
- (NSMutableArray *)mineInfoDataByUserInfo:(WXUser *)userInfo;
@end
@interface WXMineViewController : WXMenuViewController
@end
