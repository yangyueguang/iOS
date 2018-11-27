//  WXConversationViewController.h
//  Freedom
// Created by Super
#import "WXTableViewController.h"
#import "WXFriendSearchViewController.h"
#import "WXChatViewController.h"
#define     HEIGHT_CONVERSATION_CELL        64.0f
#import "WXMessageManager.h"
#import "WXModes.h"
@class WechatAddMenuView;
@protocol WXAddMenuViewDelegate <NSObject>
- (void)addMenuView:(WechatAddMenuView *)addMenuView didSelectedItem:(WXAddMenuItem *)item;
@end
@interface WechatAddMenuView : UIView
@property (nonatomic, assign) id<WXAddMenuViewDelegate>delegate;
/*显示AddMenu
 *
 *  @param view 父View*/
- (void)showInView:(UIView *)view;
/*是否正在显示*/
- (BOOL)isShow;
/*隐藏*/
- (void)dismiss;
@end
@interface WXConversationViewController : WXTableViewController<WXMessageManagerConvVCDelegate, UISearchBarDelegate, WXAddMenuViewDelegate>
@property (nonatomic, strong) WXFriendSearchViewController *searchVC;
@property (nonatomic, strong) NSMutableArray *data;
- (void)registerCellClass;
@end
