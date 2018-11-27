//  WXCommonSettingViewController.h
//  Freedom
// Created by Super
#import "WXSettingViewController.h"
@interface WXCommonSettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *commonSettingData;
+ (NSMutableArray *)chatBackgroundSettingData;
@end
@interface WXCommonSettingViewController : WXSettingViewController
@end
