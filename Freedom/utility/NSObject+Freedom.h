//  NSObject+Freedom.h
//  Freedom
//  Created by htf on 2018/4/26.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface NSObject (Freedom)
@end
@interface UIImagePickerController (Fixed)
@end
@interface UINavigationItem (Fixed)
@end
@interface UIFont (expanded)
#pragma mark - Common
+ (UIFont *)fontNavBarTitle;
#pragma mark - Conversation
+ (UIFont *)fontConversationUsername;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;
#pragma mark - Friends
+ (UIFont *) fontFriendsUsername;
#pragma mark - Mine
+ (UIFont *)fontMineNikename;
+ (UIFont *)fontMineUsername;
#pragma mark - Setting
+ (UIFont *)fontSettingHeaderAndFooterTitle;
#pragma mark - Chat
+ (UIFont *)fontTextMessageText;
@end
@interface UIViewController (add)<CKRadialMenuDelegate>
@end
