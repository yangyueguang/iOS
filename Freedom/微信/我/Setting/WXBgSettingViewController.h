//  FreedomBackgroundSettingViewController.h
//  Freedom
//  Created by Super on 16/3/19.
#import "WXSettingViewController.h"
@interface WXBgSettingViewController : WXSettingViewController
/*若为nil则全局设置，否则只给对应好友设置*/
@property (nonatomic, assign) NSString *partnerID;
@end
