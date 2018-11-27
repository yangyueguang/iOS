//  TLMineViewController.h
//  Freedom
// Created by Super
#import "TLMenuViewController.h"
#import "TLUserHelper.h"
@interface TLMineInfoHelper : NSObject
- (NSMutableArray *)mineInfoDataByUserInfo:(TLUser *)userInfo;
@end
@interface TLMineViewController : TLMenuViewController
@end
