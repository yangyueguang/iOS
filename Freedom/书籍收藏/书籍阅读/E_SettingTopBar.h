//  E_SettingBar.h
//  Freedom
//  Created by Super on 15/2/13.
#import <UIKit/UIKit.h>
/*顶部设置条*/
@protocol E_SettingTopBarDelegate <NSObject>
- (void)goBack;//退出
- (void)showMultifunctionButton;
@end
@interface E_SettingTopBar : UIView
@property(nonatomic,assign)id<E_SettingTopBarDelegate>delegate;
- (void)showToolBar;
- (void)hideToolBar;
@end
