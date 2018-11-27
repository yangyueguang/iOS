//  TLCommonSettingViewController.h
//  Freedom
// Created by Super
#import "TLSettingViewController.h"
@interface TLCommonSettingHelper : NSObject
@property (nonatomic, strong) NSMutableArray *commonSettingData;
+ (NSMutableArray *)chatBackgroundSettingData;
@end
@interface TLCommonSettingViewController : TLSettingViewController
@end
